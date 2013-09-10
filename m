Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618Ab3IJW14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:27:56 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40029 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3IJW1y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:27:54 -0400
Date: Tue, 10 Sep 2013 15:27:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Chinner <dchinner@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the akpm tree with Linus' tree
Message-Id: <20130910152753.662599171456233c5f91edb4@linux-foundation.org>
In-Reply-To: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
References: <20130910143807.4c32d548e08d2184061f52cb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Sep 2013 14:38:07 +1000 Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Andrew,
> 
> Today's linux-next merge of the akpm tree got a conflict in fs/dcache.c
> between commit 8aab6a27332b ("vfs: reorganize dput() memory accesses")
> from Linus' tree and commit "dcache: convert to use new lru list
> infrastructure" from the akpm tree.
> 
> /me mutters about development happening during the merge window -
> especially when Andrew is absent.
> 
> I have no idea if this will be correct, but I just used the version from
> the akpm tree (effectively reverting parts of commit 8aab6a27332b) and
> can carry the fix as necessary (no action is required).

This is rather a fiasco.  "vfs: reorganize dput() memory accesses" made
rather a mess of a 46 patch series which has been under development and
test for two cycles so far.

I reverted it so I could get it all to apply and build with some
confidence that I didn't break anything.  Then I went to re-apply "vfs:
reorganize dput() memory accesses" on top but I'm unsure that it's the
right thing to do.  ->d_lru is now reused for s_dentry_lru and for the
shrink list and for the dispose list, so simply testing its
list_emptiness doesn't work any more.  And it's unobvious that the
problem which "vfs: reorganize dput() memory accesses" addresses still
exists, or whether it was worsened or whatever.

And given that "vfs: reorganize dput() memory accesses" was driven by
careful profiling work, there's not a lot of point in going any further
until the new code is profiled and comparisons are performed.

Am moderately frustrated by all of this.  It would be nice if the vfs
maintainer could have, you know, paid some attention to a massive great
vfs patchset instead of blithely wrecking it :(


Dave, can you please eyeball the below and have a think about its
applicability under the new regime?  Thanks.

Right now I'm not very confident in all of this.  I think what I'll do
is send the patches out for re-re-re-review right now and I'll ask Al
and Linus to please find some time to think them over.




commit 8aab6a27332bbf2abfcb35224738394e784d940b
Author:     Linus Torvalds <torvalds@linux-foundation.org>
AuthorDate: Sun Sep 8 13:26:18 2013 -0700
Commit:     Linus Torvalds <torvalds@linux-foundation.org>
CommitDate: Sun Sep 8 13:26:18 2013 -0700

    vfs: reorganize dput() memory accesses
    
    This is me being a bit OCD after all the dentry optimization work this
    merge window: profiles end up showing 'dput()' as a rather expensive
    operation, and there were two unrelated bad reasons for that.
    
    The first reason was reading d_lockref.count for debugging purposes,
    which touches the lockref cacheline (for reads) before really need to.
    More importantly, the debugging test in question is _wrong_, and has
    hidden bugs.  It's true that we can only sleep when the count goes down
    to zero, but the test as-is hides the much more subtle bug that happens
    if we race with somebody else deleting the file.
    
    Anyway we _will_ touch that cacheline, but let's do it for a write and
    in the right routine (ie in "lockref_put_or_lock()") which annotates the
    costs better.  So remove the misleading debug code.
    
    The other was an unnecessary access to the cacheline that contains the
    d_lru list, just to check whether we already were on the LRU list or
    not.  This is exactly what we have d_flags for, so that we can avoid
    touching extra cache lines for the common case.  So just add another bit
    for "is this dentry on the LRU".
    
    Finally, mark the tests properly likely/unlikely, so that the common
    fast-paths are dense in the instruction stream.
    
    This makes the profiles look much saner.
    
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/fs/dcache.c b/fs/dcache.c
index 761e31b..bf3c4f9 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -308,8 +308,9 @@ static void dentry_unlink_inode(struct dentry * dentry)
  */
 static void dentry_lru_add(struct dentry *dentry)
 {
-	if (list_empty(&dentry->d_lru)) {
+	if (unlikely(!(dentry->d_flags & DCACHE_LRU_LIST))) {
 		spin_lock(&dcache_lru_lock);
+		dentry->d_flags |= DCACHE_LRU_LIST;
 		list_add(&dentry->d_lru, &dentry->d_sb->s_dentry_lru);
 		dentry->d_sb->s_nr_dentry_unused++;
 		dentry_stat.nr_unused++;
@@ -320,7 +321,7 @@ static void dentry_lru_add(struct dentry *dentry)
 static void __dentry_lru_del(struct dentry *dentry)
 {
 	list_del_init(&dentry->d_lru);
-	dentry->d_flags &= ~DCACHE_SHRINK_LIST;
+	dentry->d_flags &= ~(DCACHE_SHRINK_LIST | DCACHE_LRU_LIST);
 	dentry->d_sb->s_nr_dentry_unused--;
 	dentry_stat.nr_unused--;
 }
@@ -341,6 +342,7 @@ static void dentry_lru_move_list(struct dentry *dentry, struct list_head *list)
 {
 	spin_lock(&dcache_lru_lock);
 	if (list_empty(&dentry->d_lru)) {
+		dentry->d_flags |= DCACHE_LRU_LIST;
 		list_add_tail(&dentry->d_lru, list);
 		dentry->d_sb->s_nr_dentry_unused++;
 		dentry_stat.nr_unused++;
@@ -509,24 +511,22 @@ relock:
  */
 void dput(struct dentry *dentry)
 {
-	if (!dentry)
+	if (unlikely(!dentry))
 		return;
 
 repeat:
-	if (dentry->d_lockref.count == 1)
-		might_sleep();
 	if (lockref_put_or_lock(&dentry->d_lockref))
 		return;
 
-	if (dentry->d_flags & DCACHE_OP_DELETE) {
+	/* Unreachable? Get rid of it */
+	if (unlikely(d_unhashed(dentry)))
+		goto kill_it;
+
+	if (unlikely(dentry->d_flags & DCACHE_OP_DELETE)) {
 		if (dentry->d_op->d_delete(dentry))
 			goto kill_it;
 	}
 
-	/* Unreachable? Get rid of it */
- 	if (d_unhashed(dentry))
-		goto kill_it;
-
 	dentry->d_flags |= DCACHE_REFERENCED;
 	dentry_lru_add(dentry);
 
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index fe50f3d..feaa8d8 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -208,6 +208,7 @@ struct dentry_operations {
 #define DCACHE_MANAGED_DENTRY \
 	(DCACHE_MOUNTED|DCACHE_NEED_AUTOMOUNT|DCACHE_MANAGE_TRANSIT)
 
+#define DCACHE_LRU_LIST		0x80000
 #define DCACHE_DENTRY_KILLED	0x100000
 
 extern seqlock_t rename_lock;

