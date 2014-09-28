Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754229AbaI1SGA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 14:06:00 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:51296 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427AbaI1SF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 14:05:59 -0400
Date: Sun, 28 Sep 2014 19:05:56 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikhail Efremov <sem@altlinux.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140928180556.GA7996@ZenIV.linux.org.uk>
References: <20140924185521.GC7996@ZenIV.linux.org.uk>
 <CA+55aFzTs5R_TzwdsBRAkw+mGLWF0XT9_sGeb_+ETUy-gJsY_w@mail.gmail.com>
 <20140924201813.GI7996@ZenIV.linux.org.uk>
 <20140925044601.GL7996@ZenIV.linux.org.uk>
 <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <20140928074747.GZ7996@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140928074747.GZ7996@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 28, 2014 at 08:47:47AM +0100, Al Viro wrote:

> The root cause, of course, is that we delay decrementing the refcount on
> dentry_free() path...  One variant is to rip freeing these suckers out of
> __d_free() and have dentry_free() do atomic_dec_and_test + kfree_rcu.
> That works (and we don't need to set DCACHE_RCUACCESS in copy_name();
> the interesting part of never-hashed case is for short names anyway), but
> the cost is twice the number of rcu callbacks on freeing long-name dentries.
> Is that really painful enough to care?  If not, something like the following
> would do; if it is... well, we could probably do make free_dentry() mark
> dentry->d_flags for __d_free() with "free the external name hanging off
> this one" in case if refcount decrement has ended up with zero.  Doable,
> but more complicated (and somewhat messy, since ->d_lock is not held
> at that point; OTOH, we could play with ->d_name instead of ->d_flags...).
> Anyway, the delta below might suffice.  Comments?

Now that I've got some sleep...  It's easy to avoid extra call_rcu, of
course - just have two variants of __d_free(), one freeing the external
name (always called via call_rcu()) and another just freeing the dentry
itself.  So free_dentry() would
	* decrement the refcount on external name and if that has reached
zero - call_rcu the full variant.
	* if there had been no external name or if its refcount has not
reached zero - call_rcu the variant that just frees dentry itself or
just do a direct call of the same if dentry has never been RCU-visible.

One thing that worries me is the barriers that might be needed on assignments
to ->d_name.name.  We should be no worse than we are right now - either RCU
accessors are careful enough with ACCESS_ONCE() and everything's fine,
or they are not, in which case we already have a bug in mainline - swapping
->d_name followed by dput() and freeing of target is no better than
copying ->d_name from target to source followed by kfree_rcu() of what
used to be ->d_name.name of source.  IOW, if RCU lookup could pick
a value of ->d_name.name that got obsolete by d_move() happening
before our read_lock_rcu(), we would be in trouble anyway - it might
already have had its freeing RCU-scheduled and thus not delayed
by read_lock_rcu() done afterwards.  So I think the patch below doesn't
introduce new problems of that sort, but I'd really appreciate if RCU
people would take a look at the situation with barriers in that area.
Are those ACCESS_ONCE() in dentry_cmp() and prepend_name() enough, or
do we need some barriers in switch_names() as well?

Folks, care to review and test the following?

Allow sharing external names after __d_move()

* external dentry names get a small structure prepended to them
(struct ext_name).
* it contains an atomic refcount, matching the number of struct dentry
instances that have ->d_name.name pointing to that ext name.  The
first thing free_dentry() does is decrementing refcount of ext name,
so the instances between the call of free_dentry() and RCU-delayed
actual freeing do not contribute.
* __d_move(x, y, false) makes the name of x equal to the name of y,
external or not.  If y has an external name, extra reference is grabbed
and put into x->d_name.name.  If x used to have an external name, the
reference to it is dropped and, should it reach zero, freeing is scheduled
via kfree_rcu().

All non-RCU accesses to dentry ext name are safe wrt freeing since they
all should happen before free_dentry() is called.  RCU accesses might run
into a dentry seen by free_dentry() or into an old name that got already
dropped by __d_move(); however, in both cases dentry must have been
alive and refer to that name at some point after we'd done rcu_read_lock(),
which means that any freeing must be still pending.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
diff --git a/fs/dcache.c b/fs/dcache.c
index cb25a1a..0cf5aff 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -235,20 +235,44 @@ static inline int dentry_cmp(const struct dentry *dentry, const unsigned char *c
 	return dentry_string_cmp(cs, ct, tcount);
 }
 
+struct ext_name {
+	union {
+		atomic_t count;
+		struct rcu_head head;
+	};
+	unsigned char name[];
+};
+
+static inline struct ext_name *ext_name(struct dentry *dentry)
+{
+	if (likely(!dname_external(dentry)))
+		return NULL;
+	return container_of(dentry->d_name.name, struct ext_name, name[0]);
+}
+
 static void __d_free(struct rcu_head *head)
 {
 	struct dentry *dentry = container_of(head, struct dentry, d_u.d_rcu);
 
 	WARN_ON(!hlist_unhashed(&dentry->d_alias));
-	if (dname_external(dentry))
-		kfree(dentry->d_name.name);
+	kmem_cache_free(dentry_cache, dentry); 
+}
+
+static void __d_free_ext(struct rcu_head *head)
+{
+	struct dentry *dentry = container_of(head, struct dentry, d_u.d_rcu);
+	WARN_ON(!hlist_unhashed(&dentry->d_alias));
+	kfree(ext_name(dentry));
 	kmem_cache_free(dentry_cache, dentry); 
 }
 
 static void dentry_free(struct dentry *dentry)
 {
+	struct ext_name *p = ext_name(dentry);
+	if (unlikely(p) && likely(atomic_dec_and_test(&p->count)))
+		call_rcu(&dentry->d_u.d_rcu, __d_free_ext);
 	/* if dentry was never visible to RCU, immediate free is OK */
-	if (!(dentry->d_flags & DCACHE_RCUACCESS))
+	else if (!(dentry->d_flags & DCACHE_RCUACCESS))
 		__d_free(&dentry->d_u.d_rcu);
 	else
 		call_rcu(&dentry->d_u.d_rcu, __d_free);
@@ -1438,11 +1462,14 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	 */
 	dentry->d_iname[DNAME_INLINE_LEN-1] = 0;
 	if (name->len > DNAME_INLINE_LEN-1) {
-		dname = kmalloc(name->len + 1, GFP_KERNEL);
-		if (!dname) {
+		size_t size = offsetof(struct ext_name, name) + name->len + 1;
+		struct ext_name *p = kmalloc(size, GFP_KERNEL);
+		if (!p) {
 			kmem_cache_free(dentry_cache, dentry); 
 			return NULL;
 		}
+		atomic_set(&p->count, 1);
+		dname = p->name;
 	} else  {
 		dname = dentry->d_iname;
 	}	
@@ -2372,11 +2399,10 @@ void dentry_update_name_case(struct dentry *dentry, struct qstr *name)
 }
 EXPORT_SYMBOL(dentry_update_name_case);
 
-static void switch_names(struct dentry *dentry, struct dentry *target,
-			 bool exchange)
+static void swap_names(struct dentry *dentry, struct dentry *target)
 {
-	if (dname_external(target)) {
-		if (dname_external(dentry)) {
+	if (unlikely(dname_external(target))) {
+		if (unlikely(dname_external(dentry))) {
 			/*
 			 * Both external: swap the pointers
 			 */
@@ -2392,7 +2418,7 @@ static void switch_names(struct dentry *dentry, struct dentry *target,
 			target->d_name.name = target->d_iname;
 		}
 	} else {
-		if (dname_external(dentry)) {
+		if (unlikely(dname_external(dentry))) {
 			/*
 			 * dentry:external, target:internal.  Give dentry's
 			 * storage to target and make dentry internal
@@ -2407,12 +2433,6 @@ static void switch_names(struct dentry *dentry, struct dentry *target,
 			 */
 			unsigned int i;
 			BUILD_BUG_ON(!IS_ALIGNED(DNAME_INLINE_LEN, sizeof(long)));
-			if (!exchange) {
-				memcpy(dentry->d_iname, target->d_name.name,
-						target->d_name.len + 1);
-				dentry->d_name.hash_len = target->d_name.hash_len;
-				return;
-			}
 			for (i = 0; i < DNAME_INLINE_LEN / sizeof(long); i++) {
 				swap(((long *) &dentry->d_iname)[i],
 				     ((long *) &target->d_iname)[i]);
@@ -2422,6 +2442,22 @@ static void switch_names(struct dentry *dentry, struct dentry *target,
 	swap(dentry->d_name.hash_len, target->d_name.hash_len);
 }
 
+static void copy_name(struct dentry *dentry, struct dentry *target)
+{
+	struct ext_name *old_name = ext_name(dentry);
+	if (unlikely(dname_external(target))) {
+		atomic_inc(&ext_name(target)->count);
+		dentry->d_name = target->d_name;
+	} else {
+		memcpy(dentry->d_iname, target->d_name.name,
+				target->d_name.len + 1);
+		dentry->d_name.name = dentry->d_iname;
+		dentry->d_name.hash_len = target->d_name.hash_len;
+	}
+	if (unlikely(old_name) && likely(atomic_dec_and_test(&old_name->count)))
+		kfree_rcu(old_name, head);
+}
+
 static void dentry_lock_for_move(struct dentry *dentry, struct dentry *target)
 {
 	/*
@@ -2518,7 +2554,10 @@ static void __d_move(struct dentry *dentry, struct dentry *target,
 	}
 
 	/* Switch the names.. */
-	switch_names(dentry, target, exchange);
+	if (exchange)
+		swap_names(dentry, target);
+	else
+		copy_name(dentry, target);
 
 	/* ... and switch them in the tree */
 	if (IS_ROOT(dentry)) {
