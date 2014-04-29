Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757955AbaD2QCH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 12:02:07 -0400
Received: from mail-ee0-f48.google.com ([74.125.83.48]:61296 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaD2QCF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 12:02:05 -0400
Date: Tue, 29 Apr 2014 18:01:39 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: dcache shrink list corruption?
Message-ID: <20140429160139.GA3113@tucsk.piliscsaba.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This was reported by IBM for 3.12, but if my analysis is right, it affects
current kernel as well as older ones.

So the question is: does anything protect the shrink list from concurrent
modification by one or more dput() instances?

E.g. two dentries are on the shrink list, for both dget(), d_drop() and dput()
are called.  dput() -> dentry_kill() -> dentry_lru_del() -> d_shrink_del() ->
list_del_init().  Unlike the LRU list this is only protected with d_lock on the
individual dentries, which is not enough to prevent list corruption:

list->next = a, list->prev = b
a->next = b, a->prev = list
b->next = list, b->prev = a

CPU1: list_del_init(b)
        __list_del(a, list)
             a->next = list ...
CPU2: list_del_init(a)
        __list_del(list, list)
             list->next = list
             list->prev = list
CPU1: (continuing list_del_init(b))
             list->prev = a

Attached patch is just a starting point (untested).  Not sure how to minimize
contention without adding too much complexity.

Thanks,
Miklos


diff --git a/fs/dcache.c b/fs/dcache.c
index 40707d88a945..5e0719292e3e 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -357,10 +357,14 @@ static void d_lru_del(struct dentry *dentry)
 	WARN_ON_ONCE(!list_lru_del(&dentry->d_sb->s_dentry_lru, &dentry->d_lru));
 }
 
+static __cacheline_aligned_in_smp DEFINE_SPINLOCK(dcache_shrink_lock);
+
 static void d_shrink_del(struct dentry *dentry)
 {
 	D_FLAG_VERIFY(dentry, DCACHE_SHRINK_LIST | DCACHE_LRU_LIST);
+	spin_lock(&dcache_shrink_lock);
 	list_del_init(&dentry->d_lru);
+	spin_unlock(&dcache_shrink_lock);
 	dentry->d_flags &= ~(DCACHE_SHRINK_LIST | DCACHE_LRU_LIST);
 	this_cpu_dec(nr_dentry_unused);
 }
@@ -368,7 +372,9 @@ static void d_shrink_del(struct dentry *dentry)
 static void d_shrink_add(struct dentry *dentry, struct list_head *list)
 {
 	D_FLAG_VERIFY(dentry, 0);
+	spin_lock(&dcache_shrink_lock);
 	list_add(&dentry->d_lru, list);
+	spin_unlock(&dcache_shrink_lock);
 	dentry->d_flags |= DCACHE_SHRINK_LIST | DCACHE_LRU_LIST;
 	this_cpu_inc(nr_dentry_unused);
 }
@@ -391,7 +397,9 @@ static void d_lru_shrink_move(struct dentry *dentry, struct list_head *list)
 {
 	D_FLAG_VERIFY(dentry, DCACHE_LRU_LIST);
 	dentry->d_flags |= DCACHE_SHRINK_LIST;
+	spin_lock(&dcache_shrink_lock);
 	list_move_tail(&dentry->d_lru, list);
+	spin_unlock(&dcache_shrink_lock);
 }
 
 /*
