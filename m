Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755103AbaI2Q1S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:27:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:52833 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073AbaI2Q1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:27:16 -0400
Date: Mon, 29 Sep 2014 17:27:14 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikhail Efremov <sem@altlinux.org>
Subject: Re: [PATCH v2] vfs: Don't exchange "short" filenames unconditionally.
Message-ID: <20140929162714.GH7996@ZenIV.linux.org.uk>
References: <20140926164442.GA26897@ZenIV.linux.org.uk>
 <20140927044555.GS7996@ZenIV.linux.org.uk>
 <CA+55aFyw8U94tYVB9Xbo7gh1SC_f9ecKSoFL509bXM122dC46Q@mail.gmail.com>
 <20140927183139.GT7996@ZenIV.linux.org.uk>
 <20140927191657.GU7996@ZenIV.linux.org.uk>
 <20140928074747.GZ7996@ZenIV.linux.org.uk>
 <20140928180556.GA7996@ZenIV.linux.org.uk>
 <CA+55aFxZDsD94CSDYfyw9g3WWNkVApZDKxHVhK2zy0ycRsjcmA@mail.gmail.com>
 <20140929155918.GG7996@ZenIV.linux.org.uk>
 <CA+55aFyveyOABqssxLinsmHkBg9=95TwEGC1ZT1POe+RmTbj+A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyveyOABqssxLinsmHkBg9=95TwEGC1ZT1POe+RmTbj+A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 09:07:00AM -0700, Linus Torvalds wrote:
> On Mon, Sep 29, 2014 at 8:59 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> >
> > Now RCU lookup starts.  And on another CPU we move the first dentry over
> > the third one.  copy_name() is called, it decrements the refcount down
> > to 1 (__d_free() hasn't happened yet) and doesn't schedule any freeing.
> 
> Ahh. If we were to do *all* of the copy-name name freeing under RCU,
> we'd be ok. But we don't. We do the refcount decrement immediately
> (and have to, if we want to have the rcu/refcount union). Yeah, good
> call, although I find that doubvle rcu grace period for the common
> case to be very annoying.

See below (or in followup to what you were replying to); it *is* trivial to
avoid double grace periods there.  Look: in free_dentry() we know if we want
the name freed.  So let's have __d_free() for "just free dentry" and
__d_free_ext() for "free dentry and name".  No looking at refcount in the
latter - just choose which one to call_rcu() when free_dentry() does decrement.
It's equivalent from the grace period POV to doing kfree_rcu(), but avoids
double call_rcu(); it just that in case we'd want kfree_rcu() we
schedule the call of a function that frees both.

What we get in free_dentry() is:
	* external name not shared: refcount driven to 0, RCU-delayed
call of "free dentry, free ext name"
	* external name still shared: refcount positive after decrement,
no freeing ext name
	* no external name: no ext name to free
In the last two cases we do what dentry_free() used to do, except that now
__d_free() doesn't even look for ext name.  Just frees the dentry.  If
it never had been hashed - directly called, otherwise - via call_rcu().

Does that look OK for you?

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
