Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759373AbaD3P5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:57:04 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:35216 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759285AbaD3P5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:57:01 -0400
Date: Wed, 30 Apr 2014 17:56:56 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: dcache shrink list corruption?
Message-ID: <20140430155656.GD3113@tucsk.piliscsaba.szeredi.hu>
References: <20140429181610.GJ18016@ZenIV.linux.org.uk>
 <20140429191015.GK18016@ZenIV.linux.org.uk>
 <20140429211851.GA32204@dastard>
 <20140429214842.GL18016@ZenIV.linux.org.uk>
 <CA+55aFwcWcyRpwv3us9BbnsjUEfEr1mRjz4RWbcy_tSnZjc_Sw@mail.gmail.com>
 <20140429232013.GM18016@ZenIV.linux.org.uk>
 <20140430023142.GN18016@ZenIV.linux.org.uk>
 <CA+55aFypNxsjJTq_rc2Jx4p_3scJo2VWdt=e8n-9eJ-ZQphnpQ@mail.gmail.com>
 <20140430040436.GO18016@ZenIV.linux.org.uk>
 <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140430154958.GC3113@tucsk.piliscsaba.szeredi.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

And a followup patch for that, removing RCU locking from shrink_dentry_list().

I haven't tested any of this at this point, but I'll ask IBM to do some stress
testing.

Thanks,
Miklos
---

From: Miklos Szeredi <mszeredi@suse.cz>
Subject: dcache: don't need rcu in shrink_dentry_list()

Since now the shrink list is private and nobody can free the dentry while
it is on the shrink list, we can remove RCU protection from this.

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 fs/dcache.c |   29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -822,23 +822,9 @@ static void shrink_dentry_list(struct li
 {
 	struct dentry *dentry, *parent;
 
-	rcu_read_lock();
-	for (;;) {
-		dentry = list_entry_rcu(list->prev, struct dentry, d_lru);
-		if (&dentry->d_lru == list)
-			break; /* empty */
-
-		/*
-		 * Get the dentry lock, and re-verify that the dentry is
-		 * this on the shrinking list. If it is, we know that
-		 * DCACHE_SHRINK_LIST and DCACHE_LRU_LIST are set.
-		 */
+	while (!list_empty(list)) {
+		dentry = list_entry(list->prev, struct dentry, d_lru);
 		spin_lock(&dentry->d_lock);
-		if (dentry != list_entry(list->prev, struct dentry, d_lru)) {
-			spin_unlock(&dentry->d_lock);
-			continue;
-		}
-
 		/*
 		 * The dispose list is isolated and dentries are not accounted
 		 * to the LRU here, so we can simply remove it from the list
@@ -854,7 +840,6 @@ static void shrink_dentry_list(struct li
 			spin_unlock(&dentry->d_lock);
 			continue;
 		}
-		rcu_read_unlock();
 
 		if (unlikely(dentry->d_flags & DCACHE_DENTRY_KILLED)) {
 			bool free_it;
@@ -870,8 +855,6 @@ static void shrink_dentry_list(struct li
 
 			if (free_it)
 				dentry_free(dentry);
-
-			rcu_read_lock();
 			continue;
 		}
 
@@ -879,17 +862,15 @@ static void shrink_dentry_list(struct li
 		/*
 		 * If dentry_kill returns NULL, we have nothing more to do.
 		 */
-		if (!parent) {
-			rcu_read_lock();
+		if (!parent)
 			continue;
-		}
+
 		if (unlikely(parent == dentry)) {
 			/*
 			 * trylocks have failed and d_lock has been held the
 			 * whole time, so it could not have been added to any
 			 * other lists. Just add it back to the shrink list.
 			 */
-			rcu_read_lock();
 			d_shrink_add(dentry, list);
 			spin_unlock(&dentry->d_lock);
 			continue;
@@ -903,9 +884,7 @@ static void shrink_dentry_list(struct li
 		dentry = parent;
 		while (dentry && !lockref_put_or_lock(&dentry->d_lockref))
 			dentry = dentry_kill(dentry, 1);
-		rcu_read_lock();
 	}
-	rcu_read_unlock();
 }
 
 static enum lru_status
