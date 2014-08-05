Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542AbaHEEy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 00:54:29 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:45887 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753392AbaHEEyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 00:54:24 -0400
Date: Mon, 4 Aug 2014 21:54:17 -0700
From: Steven Noonan <steven@uplinklabs.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: NeilBrown <neilb@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Is lockref_get_not_zero() really correct in dget_parent()
Message-ID: <20140805045417.GA27012@loki.us-west-2.compute.internal>
References: <20140805131758.3afa6b0b@notabene.brown>
 <CA+55aFxDQ8fE16uKPfjU-nBnvfjWHz3ib5mo1BDn2=JKXVQQmQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+55aFxDQ8fE16uKPfjU-nBnvfjWHz3ib5mo1BDn2=JKXVQQmQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 04, 2014 at 09:07:32PM -0700, Linus Torvalds wrote:
> On Mon, Aug 4, 2014 at 8:17 PM, NeilBrown <neilb@suse.de> wrote:
> >
> >  I've been looking at last year's change to dentry refcounting which sets the
> >  refcount to -128 (mark_dead()) when the dentry is gone.
> >
> >  As this is an "unsigned long" and there are several places where
> >  d_lockref.count is compared e.g. "> 1", I start feeling uncomfortable, as
> >  "-128" is greater than "1".
> 
> Anybody who checks the lockref count without holding the lock is
> pretty much buggy by definition. And if you hold the lock, you had
> better not ever see a negative (== large positive) number, because
> that would be all kinds of buggy too.
> 
> So I don't *think* that people who compare with "> 1" kind of things
> should be problematic. I wouldn't necessarily disagree with the notion
> of making a lockref be a signed entity, though. It started out
> unsigned, but it started out without that dead state too, so that
> unsigned thing can be considered a historical artifact rather than any
> real design decision.
> 
> Anyway, I think my argument is that anybody who actually looks at
> d_count() and might see that magic dead value is so fundamentally
> broken in other ways that I wouldn't worry too much about *that* part.
> 
> But your "lockref_get_not_zero()" thing is a different thing:
> 
> >  That brings me to dget_parent().  It only has rcu_read_lock() protection, and
> >  yet uses lockref_get_not_zero().  This doesn't seem safe.
> 
> Yes, agreed, it's ugly and wrong, and smells bad.
> 
> But I think it happens to be safe (because the re-checking of d_parent
> will fail if a rename and dput could have triggered it, and even the
> extraneous "dput()" is actually safe, because it won't cause the value
> to become zero, so nothing bad happens. But it *is* kind of subtle,
> and I do agree that it's *needlessly* so.
> 
> So it might be a good idea to get rid of the "not zero" version
> entirely, and make the check be about being *active* (ie not zero, and
> not dead).
> 
> The only user of lockref_get_not_zero() is that dget_parent() thing,
> so that should be easy.
> 
> So renaming it to "lockref_get_active()", and changing the "not zero"
> test to check for "positive" and change the rtype of "count" to be
> signed, all sound like good things to me.
> 
> But I don't actually think it's an active bug, it's just an "active
> horribly ugly and subtly working code". I guess in theory if you can
> get lots of CPU's triggering the race at the same time, the magic
> negative number could become zero and positive, but at that point I
> don't think we're really talking reality any more.
> 
> Can somebody pick holes in that? Does somebody want to send in the
> cleanup patch?

How does this look?


diff --git a/fs/dcache.c b/fs/dcache.c
index e99c6f5..1e7dc31 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -479,7 +479,7 @@ static void __dentry_kill(struct dentry *dentry)
 	 * dentry_iput drops the locks, at which point nobody (except
 	 * transient RCU lookups) can reach this dentry.
 	 */
-	BUG_ON((int)dentry->d_lockref.count > 0);
+	BUG_ON(dentry->d_lockref.count > 0);
 	this_cpu_dec(nr_dentry);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
@@ -532,7 +532,7 @@ static inline struct dentry *lock_parent(struct dentry *dentry)
 	struct dentry *parent = dentry->d_parent;
 	if (IS_ROOT(dentry))
 		return NULL;
-	if (unlikely((int)dentry->d_lockref.count < 0))
+	if (unlikely(dentry->d_lockref.count < 0))
 		return NULL;
 	if (likely(spin_trylock(&parent->d_lock)))
 		return parent;
@@ -699,7 +699,7 @@ struct dentry *dget_parent(struct dentry *dentry)
 	 */
 	rcu_read_lock();
 	ret = ACCESS_ONCE(dentry->d_parent);
-	gotref = lockref_get_not_zero(&ret->d_lockref);
+	gotref = lockref_get_active(&ret->d_lockref);
 	rcu_read_unlock();
 	if (likely(gotref)) {
 		if (likely(ret == ACCESS_ONCE(dentry->d_parent)))
@@ -848,7 +848,7 @@ static void shrink_dentry_list(struct list_head *list)
 		 * We found an inuse dentry which was not removed from
 		 * the LRU because of laziness during lookup. Do not free it.
 		 */
-		if ((int)dentry->d_lockref.count > 0) {
+		if (dentry->d_lockref.count > 0) {
 			spin_unlock(&dentry->d_lock);
 			if (parent)
 				spin_unlock(&parent->d_lock);
diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
index aec7f73..d492f0e 100644
--- a/fs/gfs2/glock.c
+++ b/fs/gfs2/glock.c
@@ -1745,7 +1745,7 @@ void gfs2_dump_glock(struct seq_file *seq, const struct gfs2_glock *gl)
 		  state2str(gl->gl_demote_state), dtime,
 		  atomic_read(&gl->gl_ail_count),
 		  atomic_read(&gl->gl_revokes),
-		  (int)gl->gl_lockref.count, gl->gl_hold_time);
+		  gl->gl_lockref.count, gl->gl_hold_time);
 
 	list_for_each_entry(gh, &gl->gl_holders, gh_list)
 		dump_holder(seq, gh);
diff --git a/include/linux/lockref.h b/include/linux/lockref.h
index 4bfde0e..1a9827e 100644
--- a/include/linux/lockref.h
+++ b/include/linux/lockref.h
@@ -28,13 +28,13 @@ struct lockref {
 #endif
 		struct {
 			spinlock_t lock;
-			unsigned int count;
+			int count;
 		};
 	};
 };
 
 extern void lockref_get(struct lockref *);
-extern int lockref_get_not_zero(struct lockref *);
+extern int lockref_get_active(struct lockref *);
 extern int lockref_get_or_lock(struct lockref *);
 extern int lockref_put_or_lock(struct lockref *);
 
diff --git a/lib/lockref.c b/lib/lockref.c
index f07a40d..7f30371 100644
--- a/lib/lockref.c
+++ b/lib/lockref.c
@@ -61,17 +61,18 @@ void lockref_get(struct lockref *lockref)
 EXPORT_SYMBOL(lockref_get);
 
 /**
- * lockref_get_not_zero - Increments count unless the count is 0
+ * lockref_get_active - Increments count unless the count is 0 or ref is dead
  * @lockref: pointer to lockref structure
- * Return: 1 if count updated successfully or 0 if count was zero
+ * Return: 1 if count updated successfully or 0 if count was zero or lockref
+ * was dead
  */
-int lockref_get_not_zero(struct lockref *lockref)
+int lockref_get_active(struct lockref *lockref)
 {
 	int retval;
 
 	CMPXCHG_LOOP(
 		new.count++;
-		if (!old.count)
+		if (old.count < 1)
 			return 0;
 	,
 		return 1;
@@ -79,14 +80,14 @@ int lockref_get_not_zero(struct lockref *lockref)
 
 	spin_lock(&lockref->lock);
 	retval = 0;
-	if (lockref->count) {
+	if (lockref->count >= 1) {
 		lockref->count++;
 		retval = 1;
 	}
 	spin_unlock(&lockref->lock);
 	return retval;
 }
-EXPORT_SYMBOL(lockref_get_not_zero);
+EXPORT_SYMBOL(lockref_get_active);
 
 /**
  * lockref_get_or_lock - Increments count unless the count is 0
@@ -159,7 +160,7 @@ int lockref_get_not_dead(struct lockref *lockref)
 
 	CMPXCHG_LOOP(
 		new.count++;
-		if ((int)old.count < 0)
+		if (old.count < 0)
 			return 0;
 	,
 		return 1;
@@ -167,7 +168,7 @@ int lockref_get_not_dead(struct lockref *lockref)
 
 	spin_lock(&lockref->lock);
 	retval = 0;
-	if ((int) lockref->count >= 0) {
+	if (lockref->count >= 0) {
 		lockref->count++;
 		retval = 1;
 	}


I'm not too happy with the documentation string for lockref_get_active(), but
I believe the logic is at least right. There were a few places where 'count'
was being casted to a signed integer, and since this change turns 'count' into
a signed value anyway, I've stripped out the casts.
