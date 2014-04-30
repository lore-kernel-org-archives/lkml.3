Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303AbaD3TCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 15:02:33 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49404 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758963AbaD3TCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 15:02:30 -0400
Date: Wed, 30 Apr 2014 20:02:27 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430190227.GR18016@ZenIV.linux.org.uk>
References: <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430040436.GO18016@ZenIV.linux.org.uk>
 <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
 <20140430160345.GP18016@ZenIV.linux.org.uk>
 <CAJfpegu+q3sT=8==9K5t4=qeJH2azFcBGeMXUtK3LVSEEzXTUA@mail.gmail.com>
 <20140430183650.GQ18016@ZenIV.linux.org.uk>
 <CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegu+=zidycJwcBPjuDLP-ZnGisOGQpD8GKhD-Wz6eNzd9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2014 at 08:42:01PM +0200, Miklos Szeredi wrote:

> Message-ID: <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>

I see...  Several points:
	* I still think that it's better to do handling of "we see
DCACHE_DENTRY_KILLED already set" in dentry_kill() itself.
	* in dentry_kill(dentry, 0) we *know* that it's not on a shrink
list - the caller has just removed it from there and we'd kept ->d_lock
since that point.   What's more, with that scheme we don't need to bother
with can_free at all - just grab ->d_lock after ->d_release() call and check
DCACHE_SHRINK_LIST.  No sense trying to avoid that - in case where we
could just go ahead and free the sucker, there's neither contention nor
anybody else interested in that cacheline, so spin_lock(&dentry->d_lock)
is pretty much free.

IOW, I'd prefer to do the following (completely untested) on top of 1/6--4/6:

diff --git a/fs/dcache.c b/fs/dcache.c
index e482775..82d8eb4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -489,6 +489,17 @@ relock:
 		goto relock;
 	}
 
+	if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
+		if (parent)
+			spin_unlock(&parent->d_lock);
+		if (dentry->d_flags & DCACHE_MAY_FREE) {
+			spin_unlock(&dentry->d_lock);
+			dentry_free(dentry);
+		} else {
+			spin_unlock(&dentry->d_lock);
+		}
+		return parent;
+	}
 	/*
 	 * The dentry is now unrecoverably dead to the world.
 	 */
@@ -504,8 +515,6 @@ relock:
 	if (dentry->d_flags & DCACHE_LRU_LIST) {
 		if (!(dentry->d_flags & DCACHE_SHRINK_LIST))
 			d_lru_del(dentry);
-		else
-			d_shrink_del(dentry);
 	}
 	/* if it was on the hash then remove it */
 	__d_drop(dentry);
@@ -527,7 +536,14 @@ relock:
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
 
-	dentry_free(dentry);
+	spin_lock(&dentry->d_lock);
+	if (dentry->d_flags & DCACHE_SHRINK_LIST) {
+		dentry->d_flags |= DCACHE_MAY_FREE;
+		spin_unlock(&dentry->d_lock);
+	} else {
+		spin_unlock(&dentry->d_lock);
+		dentry_free(dentry);
+	}
 	return parent;
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
