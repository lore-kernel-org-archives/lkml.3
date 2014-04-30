Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759593AbaD3Ui0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 16:38:26 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49485 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758905AbaD3UiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 16:38:25 -0400
Date: Wed, 30 Apr 2014 21:38:23 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430203823.GT18016@ZenIV.linux.org.uk>
References: <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430040436.GO18016@ZenIV.linux.org.uk>
 <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
 <20140430160345.GP18016@ZenIV.linux.org.uk>
 <CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
 <20140430183650.GQ18016@ZenIV.linux.org.uk>
 <CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
 <20140430190227.GR18016@ZenIV.linux.org.uk>
 <20140430195918.GS18016@ZenIV.linux.org.uk>
 <CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxe4HKHiWbarfwtww9=WUgfAmk+Cf3G7tdBB19uMdjbEg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 01:23:26PM -0700, Linus Torvalds wrote:
> On Wed, Apr 30, 2014 at 12:59 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Another thing: I don't like what's going on with freeing vs. ->d_lock there.
> > Had that been a mutex, we'd definitely get a repeat of "vfs: fix subtle
> > use-after-free of pipe_inode_info".  The question is, can spin_unlock(p)
> > dereference p after another CPU gets through spin_lock(p)?  Linus?
> 
> spin_unlock() *should* be safe wrt that issue.
> 
> But I have to say, I think paravirtualized spinlocks may break that.
> They do all kinds of "kick waiters" after releasing the lock.
> 
> Doesn't the RCU protection solve that, though? Nobody should be
> releasing the dentry under us, afaik..

We do not (and cannot) call dentry_kill() with rcu_read_lock held - it can
trigger any amount of IO, for one thing.  We can take it around the
couple of places where do that spin_unlock(&dentry->d_lock) (along with
setting DCACHE_RCUACCESS) - that's what I'd been refering to.  Then this
sucker (tests still running, so far everything seems to survive) becomes
the following (again, on top of 1/6..4/6).  BTW, is there any convenient
way to tell git commit --amend to update the commit date?  Something
like --date=now would be nice, but it isn't accepted...

commit 797ff22681dc969b478ed837787d24dfd2dd2132
Author: Al Viro <viro@zeniv.linux.org.uk>
Date:   Tue Apr 29 23:52:05 2014 -0400

    dentry_kill(): don't try to remove from shrink list
    
    If the victim in on the shrink list, don't remove it from there.
    If shrink_dentry_list() manages to remove it from the list before
    we are done - fine, we'll just free it as usual.  If not - mark
    it with new flag (DCACHE_MAY_FREE) and leave it there.
    
    Eventually, shrink_dentry_list() will get to it, remove the sucker
    from shrink list and call dentry_kill(dentry, 0).  Which is where
    we'll deal with freeing.
    
    Since now dentry_kill(dentry, 0) may happen after or during
    dentry_kill(dentry, 1), we need to recognize that (by seeing
    DCACHE_DENTRY_KILLED already set), unlock everything
    and either free the sucker (in case DCACHE_MAY_FREE has been
    set) or leave it for ongoing dentry_kill(dentry, 1) to deal with.
    
    Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

diff --git a/fs/dcache.c b/fs/dcache.c
index e482775..fa40d26 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -489,6 +489,20 @@ relock:
 		goto relock;
 	}
 
+	if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+		if (parent)
+			spin_unlock(&parent->d_lock);
+		if (dentry->d_flags & DCACHE_MAY_FREE) {
+			spin_unlock(&dentry->d_lock);
+			dentry_free(dentry);
+		} else {
+			dentry->d_flags |= DCACHE_RCUACCESS;
+			rcu_read_lock();
+			spin_unlock(&dentry->d_lock);
+			rcu_read_unlock();
+		}
+		return parent;
+	}
 	/*
 	 * The dentry is now unrecoverably dead to the world.
 	 */
@@ -504,8 +518,6 @@ relock:
 	if (dentry->d_flags & DCACHE_LRU_LIST) {
 		if (!(dentry->d_flags & DCACHE_SHRINK_LIST))
 			d_lru_del(dentry);
-		else
-			d_shrink_del(dentry);
 	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
@@ -527,7 +539,16 @@ relock:
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
-	dentry_free(dentry);
+	spin_lock(&dentry->d_lock);
+	if (dentry->d_flags & DCACHE_SHRINK_LIST) {
+		dentry->d_flags |= DCACHE_MAY_FREE | DCACHE_RCUACCESS;
+		rcu_read_lock();
+		spin_unlock(&dentry->d_lock);
+		rcu_read_unlock();
+	} else {
+		spin_unlock(&dentry->d_lock);
+		dentry_free(dentry);
+	}
 	return parent;
 }
 
@@ -829,7 +850,7 @@ static void shrink_dentry_list(struct list_head *list)
 		 * We found an inuse dentry which was not removed from
 		 * the LRU because of laziness during lookup. Do not free it.
 		 */
-		if (dentry->d_lockref.count) {
+		if (dentry->d_lockref.count > 0) {
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 3b9bfdb..3c7ec32 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -221,6 +221,8 @@ struct dentry_operations {
 #define DCACHE_SYMLINK_TYPE		0x00300000 /* Symlink */
 #define DCACHE_FILE_TYPE		0x00400000 /* Other file type */
 
+#define DCACHE_MAY_FREE			0x00800000
+
 extern seqlock_t rename_lock;
 
 static inline int dname_external(const struct dentry *dentry)
