Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070Ab3FLUD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 16:03:27 -0400
Received: from g6t0184.atlanta.hp.com ([15.193.32.61]:37316 "EHLO
	g6t0184.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202Ab3FLUDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 16:03:25 -0400
Message-ID: <1371067399.1746.47.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH RFC ticketlock] Auto-queued ticketlock
From: Davidlohr Bueso <davidlohr.bueso@hp.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        =?UTF-8?Q?=E8=B5=96=E6=B1=9F=E5=B1=B1?= <laijs@cn.fujitsu.com>,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Josh Triplett <josh@joshtriplett.org>, niv@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        David Howells <dhowells@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Darren Hart <darren@dvhart.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Silas Boyd-Wickizer <sbw@mit.edu>, Waiman Long <Waiman.Long@hp.com>
Date: Wed, 12 Jun 2013 13:03:19 -0700
In-Reply-To: <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
References: <20130609193657.GA13392@linux.vnet.ibm.com>
	 <1370911480.9844.160.camel@gandalf.local.home>
	 <CA+55aFxeLszgfTZeG7L6289DcaoKT+uhtf5nwB6r=2i9Sy4Mrg@mail.gmail.com>
	 <1370973186.1744.9.camel@buesod1.americas.hpqcorp.net>
	 <1370974231.9844.212.camel@gandalf.local.home>
	 <1371059401.1746.33.camel@buesod1.americas.hpqcorp.net>
	 <CA+55aFygedE80F3SvE7VvqwXaCthbFh7sMCwVnZt6wzst8YLHA@mail.gmail.com>
Content-Type: multipart/mixed; boundary="=-Qvgc/S1g2/qog5KLpist"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Qvgc/S1g2/qog5KLpist
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit

On Wed, 2013-06-12 at 11:15 -0700, Linus Torvalds wrote:
> On Wed, Jun 12, 2013 at 10:50 AM, Davidlohr Bueso
> <davidlohr.bueso@hp.com> wrote:
> >
> > * short: is the big winner for this patch, +69% throughput improvement
> > with 100-2000 users. This makes a lot of sense since the workload spends
> > a ridiculous amount of time trying to acquire the d_lock:
> >
> >   84.86%    1569902            reaim  [kernel.kallsyms]            [k] _raw_spin_lock
> >                       |
> >                       --- _raw_spin_lock
> >                          |
> >                          |--49.96%-- dget_parent
> >                          |          __fsnotify_parent
> >                          |--49.71%-- dput
> 
> Ugh. Do you have any idea what the heck that thing actually does?

Waiman's dcache patchet were actually an attempt to address these exact
issues: http://lkml.org/lkml/2013/5/22/716

According to him:

"the short workload calls security functions like getpwnam(),
getpwuid(), getgrgid() a couple of times. These functions open
the /etc/passwd or /etc/group files, read their content and close the
files. 
It is the intensive open/read/close sequence from multiple threads that 
is causing 80%+ contention in the d_lock on a system with large number 
of cores. The MIT's MOSBench paper also outlined dentry reference 
counting as a scalability roadblock for its Apache and Exim tests."

> 
> Normally, we shouldn't see lots of dget contention, since the dcache
> these days does everything but the last path component locklessly.
> 
> But there's a few exceptions, like symlinks (act as "last component"
> in the middle). And obviously, if some crazy threaded program opens
> the *same* file concurrently over and over again, then that "last
> component" will hammer on the dentry lock of that particular path. But
> that "open the same file concurrently" seems totally unrealistic -
> although maybe that's what AIM does..
> 
> Anybody know the AIM subtests?
> 
> Also, we *may* actually be able to optimize this by making
> dentry->d_count atomic, which will allow us to often do dget_parent
> and put() without taking the dcache lock at all. That's what it used
> to be, but the RCU patches actually made it be protected by the
> d_lock. It made sense at the time, as a step in the sequence, and many
> of the dentry d_count accesses are under the lock, but now that the
> remaining hot-paths are dget_parent and dput and many of the dentry
> d_count increments are gone from the hot-paths, we might want to
> re-visit that decision.  It could go either way.

I did a quick attempt at this (patch attached). For the short workload,
we now have:

   76.90%     928688            reaim  [kernel.kallsyms]        [k] _raw_spin_lock                            
                      |
                      --- _raw_spin_lock
                         |          
                         |--99.69%-- dget_parent
                         |          __fsnotify_parent
                         |          |          
                         |          |--20.23%-- fsnotify_access
                         |          |          vfs_read
                         |          |--20.13%-- __fput
                         |          |          ____fput
                         |          |          task_work_run
                         |          |--20.07%-- security_file_permission
                         |          |          rw_verify_area
                         |          |          vfs_read
                         |          |--19.97%-- do_sys_open
                         |          |          SyS_open
                         |           --19.60%-- security_file_open
                         |                     do_dentry_open

Still 76%!!! Throughput wise we do have a very nice boost when compared
to the vanilla kernel:

10-100 users: +47%
100-1000 users: +76%
1000-2000 users: +76%

Thanks,
Davidlohr


--=-Qvgc/S1g2/qog5KLpist
Content-Disposition: attachment; filename="atomic_dcount.patch"
Content-Type: text/x-patch; name="atomic_dcount.patch"; charset="UTF-8"
Content-Transfer-Encoding: 7bit

diff --git a/fs/autofs4/expire.c b/fs/autofs4/expire.c
index 13ddec9..0127d69 100644
--- a/fs/autofs4/expire.c
+++ b/fs/autofs4/expire.c
@@ -109,7 +109,7 @@ cont:
 
 	spin_lock_nested(&q->d_lock, DENTRY_D_LOCK_NESTED);
 	/* Already gone or negative dentry (under construction) - try next */
-	if (q->d_count == 0 || !simple_positive(q)) {
+	if (atomic_read(&q->d_count) == 0 || !simple_positive(q)) {
 		spin_unlock(&q->d_lock);
 		next = q->d_u.d_child.next;
 		goto cont;
@@ -267,7 +267,7 @@ static int autofs4_tree_busy(struct vfsmount *mnt,
 			else
 				ino_count++;
 
-			if (p->d_count > ino_count) {
+			if (atomic_read(&p->d_count) > ino_count) {
 				top_ino->last_used = jiffies;
 				dput(p);
 				return 1;
@@ -409,7 +409,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		if (!exp_leaves) {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
+			if (atomic_read(&dentry->d_count) > ino_count)
 				goto next;
 
 			if (!autofs4_tree_busy(mnt, dentry, timeout, do_now)) {
@@ -423,7 +423,7 @@ struct dentry *autofs4_expire_indirect(struct super_block *sb,
 		} else {
 			/* Path walk currently on this dentry? */
 			ino_count = atomic_read(&ino->count) + 1;
-			if (dentry->d_count > ino_count)
+			if (atomic_read(&dentry->d_count) > ino_count)
 				goto next;
 
 			expired = autofs4_check_leaves(mnt, dentry, timeout, do_now);
diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
index 085da86..dea7768 100644
--- a/fs/autofs4/root.c
+++ b/fs/autofs4/root.c
@@ -176,12 +176,11 @@ static struct dentry *autofs4_lookup_active(struct dentry *dentry)
 		ino = list_entry(p, struct autofs_info, active);
 		active = ino->dentry;
 
-		spin_lock(&active->d_lock);
-
 		/* Already gone? */
-		if (active->d_count == 0)
-			goto next;
+		if (atomic_read(&active->d_count) == 0)
+			continue;
 
+		spin_lock(&active->d_lock);
 		qstr = &active->d_name;
 
 		if (active->d_name.hash != hash)
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index be0f7e2..0ff5677 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -903,8 +903,8 @@ static struct dentry *splice_dentry(struct dentry *dn, struct inode *in,
 	} else if (realdn) {
 		dout("dn %p (%d) spliced with %p (%d) "
 		     "inode %p ino %llx.%llx\n",
-		     dn, dn->d_count,
-		     realdn, realdn->d_count,
+		     dn, atomic_read(&dn->d_count),
+		     realdn, atomic_read(&realdn->d_count),
 		     realdn->d_inode, ceph_vinop(realdn->d_inode));
 		dput(dn);
 		dn = realdn;
diff --git a/fs/coda/dir.c b/fs/coda/dir.c
index b7d3a05..817c91f 100644
--- a/fs/coda/dir.c
+++ b/fs/coda/dir.c
@@ -560,7 +560,7 @@ static int coda_dentry_revalidate(struct dentry *de, unsigned int flags)
 	if (cii->c_flags & C_FLUSH) 
 		coda_flag_inode_children(inode, C_FLUSH);
 
-	if (de->d_count > 1)
+	if (atomic_read(&de->d_count) > 1)
 		/* pretend it's valid, but don't change the flags */
 		goto out;
 
diff --git a/fs/configfs/dir.c b/fs/configfs/dir.c
index 7aabc6a..a173bc9 100644
--- a/fs/configfs/dir.c
+++ b/fs/configfs/dir.c
@@ -387,7 +387,7 @@ static void remove_dir(struct dentry * d)
 	if (d->d_inode)
 		simple_rmdir(parent->d_inode,d);
 
-	pr_debug(" o %s removing done (%d)\n",d->d_name.name, d->d_count);
+	pr_debug(" o %s removing done (%d)\n",d->d_name.name, atomic_read(&d->d_count));
 
 	dput(parent);
 }
diff --git a/fs/dcache.c b/fs/dcache.c
index f09b908..a66eaca 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -54,7 +54,6 @@
  *   - d_flags
  *   - d_name
  *   - d_lru
- *   - d_count
  *   - d_unhashed()
  *   - d_parent and d_subdirs
  *   - childrens' d_child and d_parent
@@ -229,7 +228,7 @@ static void __d_free(struct rcu_head *head)
  */
 static void d_free(struct dentry *dentry)
 {
-	BUG_ON(dentry->d_count);
+	BUG_ON(atomic_read(&dentry->d_count));
 	this_cpu_dec(nr_dentry);
 	if (dentry->d_op && dentry->d_op->d_release)
 		dentry->d_op->d_release(dentry);
@@ -467,7 +466,7 @@ relock:
 	}
 
 	if (ref)
-		dentry->d_count--;
+		atomic_dec(&dentry->d_count);
 	/*
 	 * inform the fs via d_prune that this dentry is about to be
 	 * unhashed and destroyed.
@@ -513,16 +512,14 @@ void dput(struct dentry *dentry)
 		return;
 
 repeat:
-	if (dentry->d_count == 1)
+	if (atomic_read(&dentry->d_count) == 1)
 		might_sleep();
-	spin_lock(&dentry->d_lock);
-	BUG_ON(!dentry->d_count);
-	if (dentry->d_count > 1) {
-		dentry->d_count--;
-		spin_unlock(&dentry->d_lock);
+	BUG_ON(!atomic_read(&dentry->d_count));
+	if (atomic_read(&dentry->d_count) > 1) {
+		atomic_dec(&dentry->d_count);
 		return;
 	}
-
+	spin_lock(&dentry->d_lock);
 	if (dentry->d_flags & DCACHE_OP_DELETE) {
 		if (dentry->d_op->d_delete(dentry))
 			goto kill_it;
@@ -534,9 +531,9 @@ repeat:
 
 	dentry->d_flags |= DCACHE_REFERENCED;
 	dentry_lru_add(dentry);
-
-	dentry->d_count--;
 	spin_unlock(&dentry->d_lock);
+
+	atomic_dec(&dentry->d_count);
 	return;
 
 kill_it:
@@ -590,7 +587,7 @@ int d_invalidate(struct dentry * dentry)
 	 * We also need to leave mountpoints alone,
 	 * directory or not.
 	 */
-	if (dentry->d_count > 1 && dentry->d_inode) {
+	if (atomic_read(&dentry->d_count) > 1 && dentry->d_inode) {
 		if (S_ISDIR(dentry->d_inode->i_mode) || d_mountpoint(dentry)) {
 			spin_unlock(&dentry->d_lock);
 			return -EBUSY;
@@ -606,14 +603,12 @@ EXPORT_SYMBOL(d_invalidate);
 /* This must be called with d_lock held */
 static inline void __dget_dlock(struct dentry *dentry)
 {
-	dentry->d_count++;
+	atomic_inc(&dentry->d_count);
 }
 
 static inline void __dget(struct dentry *dentry)
 {
-	spin_lock(&dentry->d_lock);
 	__dget_dlock(dentry);
-	spin_unlock(&dentry->d_lock);
 }
 
 struct dentry *dget_parent(struct dentry *dentry)
@@ -634,9 +629,9 @@ repeat:
 		goto repeat;
 	}
 	rcu_read_unlock();
-	BUG_ON(!ret->d_count);
-	ret->d_count++;
 	spin_unlock(&ret->d_lock);
+	BUG_ON(!atomic_read(&ret->d_count));
+	atomic_inc(&ret->d_count);
 	return ret;
 }
 EXPORT_SYMBOL(dget_parent);
@@ -717,8 +712,8 @@ void d_prune_aliases(struct inode *inode)
 restart:
 	spin_lock(&inode->i_lock);
 	hlist_for_each_entry(dentry, &inode->i_dentry, d_alias) {
-		spin_lock(&dentry->d_lock);
-		if (!dentry->d_count) {
+		if (!atomic_read(&dentry->d_count)) {
+			spin_lock(&dentry->d_lock);
 			__dget_dlock(dentry);
 			__d_drop(dentry);
 			spin_unlock(&dentry->d_lock);
@@ -726,7 +721,6 @@ restart:
 			dput(dentry);
 			goto restart;
 		}
-		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&inode->i_lock);
 }
@@ -763,12 +757,11 @@ static void try_prune_one_dentry(struct dentry *dentry)
 	/* Prune ancestors. */
 	dentry = parent;
 	while (dentry) {
-		spin_lock(&dentry->d_lock);
-		if (dentry->d_count > 1) {
-			dentry->d_count--;
-			spin_unlock(&dentry->d_lock);
+		if (atomic_read(&dentry->d_count) > 1) {
+			atomic_dec(&dentry->d_count);
 			return;
 		}
+		spin_lock(&dentry->d_lock);
 		dentry = dentry_kill(dentry, 1);
 	}
 }
@@ -793,7 +786,7 @@ static void shrink_dentry_list(struct list_head *list)
 		 * the LRU because of laziness during lookup.  Do not free
 		 * it - just keep it off the LRU list.
 		 */
-		if (dentry->d_count) {
+		if (atomic_read(&dentry->d_count)) {
 			dentry_lru_del(dentry);
 			spin_unlock(&dentry->d_lock);
 			continue;
@@ -913,7 +906,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 			dentry_lru_del(dentry);
 			__d_shrink(dentry);
 
-			if (dentry->d_count != 0) {
+			if (atomic_read(&dentry->d_count) != 0) {
 				printk(KERN_ERR
 				       "BUG: Dentry %p{i=%lx,n=%s}"
 				       " still in use (%d)"
@@ -922,7 +915,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				       dentry->d_inode ?
 				       dentry->d_inode->i_ino : 0UL,
 				       dentry->d_name.name,
-				       dentry->d_count,
+				       atomic_read(&dentry->d_count),
 				       dentry->d_sb->s_type->name,
 				       dentry->d_sb->s_id);
 				BUG();
@@ -933,7 +926,7 @@ static void shrink_dcache_for_umount_subtree(struct dentry *dentry)
 				list_del(&dentry->d_u.d_child);
 			} else {
 				parent = dentry->d_parent;
-				parent->d_count--;
+				atomic_dec(&parent->d_count);
 				list_del(&dentry->d_u.d_child);
 			}
 
@@ -981,7 +974,7 @@ void shrink_dcache_for_umount(struct super_block *sb)
 
 	dentry = sb->s_root;
 	sb->s_root = NULL;
-	dentry->d_count--;
+	atomic_dec(&dentry->d_count);
 	shrink_dcache_for_umount_subtree(dentry);
 
 	while (!hlist_bl_empty(&sb->s_anon)) {
@@ -1137,8 +1130,6 @@ resume:
 		struct dentry *dentry = list_entry(tmp, struct dentry, d_u.d_child);
 		next = tmp->next;
 
-		spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
-
 		/*
 		 * move only zero ref count dentries to the dispose list.
 		 *
@@ -1147,9 +1138,11 @@ resume:
 		 * loop in shrink_dcache_parent() might not make any progress
 		 * and loop forever.
 		 */
-		if (dentry->d_count) {
+		if (atomic_read(&dentry->d_count)) {
+			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 			dentry_lru_del(dentry);
 		} else if (!(dentry->d_flags & DCACHE_SHRINK_LIST)) {
+			spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
 			dentry_lru_move_list(dentry, dispose);
 			dentry->d_flags |= DCACHE_SHRINK_LIST;
 			found++;
@@ -1269,7 +1262,7 @@ struct dentry *__d_alloc(struct super_block *sb, const struct qstr *name)
 	smp_wmb();
 	dentry->d_name.name = dname;
 
-	dentry->d_count = 1;
+	atomic_set(&dentry->d_count, 1);
 	dentry->d_flags = 0;
 	spin_lock_init(&dentry->d_lock);
 	seqcount_init(&dentry->d_seq);
@@ -1970,7 +1963,7 @@ struct dentry *__d_lookup(const struct dentry *parent, const struct qstr *name)
 				goto next;
 		}
 
-		dentry->d_count++;
+		atomic_inc(&dentry->d_count);
 		found = dentry;
 		spin_unlock(&dentry->d_lock);
 		break;
@@ -2069,7 +2062,7 @@ again:
 	spin_lock(&dentry->d_lock);
 	inode = dentry->d_inode;
 	isdir = S_ISDIR(inode->i_mode);
-	if (dentry->d_count == 1) {
+	if (atomic_read(&dentry->d_count) == 1) {
 		if (!spin_trylock(&inode->i_lock)) {
 			spin_unlock(&dentry->d_lock);
 			cpu_relax();
@@ -2937,7 +2930,7 @@ resume:
 		}
 		if (!(dentry->d_flags & DCACHE_GENOCIDE)) {
 			dentry->d_flags |= DCACHE_GENOCIDE;
-			dentry->d_count--;
+			atomic_dec(&dentry->d_count);
 		}
 		spin_unlock(&dentry->d_lock);
 	}
@@ -2945,7 +2938,7 @@ resume:
 		struct dentry *child = this_parent;
 		if (!(this_parent->d_flags & DCACHE_GENOCIDE)) {
 			this_parent->d_flags |= DCACHE_GENOCIDE;
-			this_parent->d_count--;
+			atomic_dec(&this_parent->d_count);
 		}
 		this_parent = try_to_ascend(this_parent, locked, seq);
 		if (!this_parent)
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 5eab400..88cd9b6 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -358,7 +358,7 @@ static int ecryptfs_lookup_interpose(struct dentry *dentry,
 
 	lower_mnt = mntget(ecryptfs_dentry_to_lower_mnt(dentry->d_parent));
 	fsstack_copy_attr_atime(dir_inode, lower_dentry->d_parent->d_inode);
-	BUG_ON(!lower_dentry->d_count);
+	BUG_ON(!atomic_read(&lower_dentry->d_count));
 
 	ecryptfs_set_dentry_private(dentry, dentry_info);
 	ecryptfs_set_dentry_lower(dentry, lower_dentry);
diff --git a/fs/locks.c b/fs/locks.c
index cb424a4..b622143 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1351,7 +1351,7 @@ int generic_add_lease(struct file *filp, long arg, struct file_lock **flp)
 	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 		goto out;
 	if ((arg == F_WRLCK)
-	    && ((dentry->d_count > 1)
+	    && ((atomic_read(&dentry->d_count) > 1)
 		|| (atomic_read(&inode->i_count) > 1)))
 		goto out;
 
diff --git a/fs/namei.c b/fs/namei.c
index 85e40d1..cb748ca 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -536,8 +536,8 @@ static int unlazy_walk(struct nameidata *nd, struct dentry *dentry)
 		 * a reference at this point.
 		 */
 		BUG_ON(!IS_ROOT(dentry) && dentry->d_parent != parent);
-		BUG_ON(!parent->d_count);
-		parent->d_count++;
+		BUG_ON(!atomic_read(&parent->d_count));
+		atomic_inc(&parent->d_count);
 		spin_unlock(&dentry->d_lock);
 	}
 	spin_unlock(&parent->d_lock);
@@ -3279,10 +3279,11 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, umode_t, mode)
 void dentry_unhash(struct dentry *dentry)
 {
 	shrink_dcache_parent(dentry);
-	spin_lock(&dentry->d_lock);
-	if (dentry->d_count == 1)
+	if (atomic_read(&dentry->d_count) == 1) {
+		spin_lock(&dentry->d_lock);
 		__d_drop(dentry);
-	spin_unlock(&dentry->d_lock);
+		spin_unlock(&dentry->d_lock);
+	}
 }
 
 int vfs_rmdir(struct inode *dir, struct dentry *dentry)
diff --git a/fs/nfs/dir.c b/fs/nfs/dir.c
index e093e73..491ff71 100644
--- a/fs/nfs/dir.c
+++ b/fs/nfs/dir.c
@@ -1721,7 +1721,7 @@ int nfs_unlink(struct inode *dir, struct dentry *dentry)
 		dir->i_ino, dentry->d_name.name);
 
 	spin_lock(&dentry->d_lock);
-	if (dentry->d_count > 1) {
+	if (atomic_read(&dentry->d_count) > 1) {
 		spin_unlock(&dentry->d_lock);
 		/* Start asynchronous writeout of the inode */
 		write_inode_now(dentry->d_inode, 0);
@@ -1870,7 +1870,7 @@ int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 	dfprintk(VFS, "NFS: rename(%s/%s -> %s/%s, ct=%d)\n",
 		 old_dentry->d_parent->d_name.name, old_dentry->d_name.name,
 		 new_dentry->d_parent->d_name.name, new_dentry->d_name.name,
-		 new_dentry->d_count);
+		 atomic_read(&new_dentry->d_count));
 
 	/*
 	 * For non-directories, check whether the target is busy and if so,
@@ -1888,7 +1888,7 @@ int nfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			rehash = new_dentry;
 		}
 
-		if (new_dentry->d_count > 2) {
+		if (atomic_read(&new_dentry->d_count) > 2) {
 			int err;
 
 			/* copy the target dentry's name */
diff --git a/fs/nfs/unlink.c b/fs/nfs/unlink.c
index 1f1f38f..c547f2b 100644
--- a/fs/nfs/unlink.c
+++ b/fs/nfs/unlink.c
@@ -479,7 +479,7 @@ nfs_sillyrename(struct inode *dir, struct dentry *dentry)
 
 	dfprintk(VFS, "NFS: silly-rename(%s/%s, ct=%d)\n",
 		dentry->d_parent->d_name.name, dentry->d_name.name,
-		dentry->d_count);
+		 atomic_read(&dentry->d_count));
 	nfs_inc_stats(dir, NFSIOS_SILLYRENAME);
 
 	/*
diff --git a/fs/nilfs2/super.c b/fs/nilfs2/super.c
index c7d1f9f..c9257b3 100644
--- a/fs/nilfs2/super.c
+++ b/fs/nilfs2/super.c
@@ -973,7 +973,7 @@ static int nilfs_attach_snapshot(struct super_block *s, __u64 cno,
 
 static int nilfs_tree_was_touched(struct dentry *root_dentry)
 {
-	return root_dentry->d_count > 1;
+	return atomic_read(&root_dentry->d_count) > 1;
 }
 
 /**
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 1a6bb81..8f5511c 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -112,7 +112,7 @@ struct dentry {
 	unsigned char d_iname[DNAME_INLINE_LEN];	/* small names */
 
 	/* Ref lookup also touches following */
-	unsigned int d_count;		/* protected by d_lock */
+	atomic_t d_count;
 	spinlock_t d_lock;		/* per dentry lock */
 	const struct dentry_operations *d_op;
 	struct super_block *d_sb;	/* The root of the dentry tree */
@@ -319,7 +319,7 @@ static inline int __d_rcu_to_refcount(struct dentry *dentry, unsigned seq)
 	assert_spin_locked(&dentry->d_lock);
 	if (!read_seqcount_retry(&dentry->d_seq, seq)) {
 		ret = 1;
-		dentry->d_count++;
+		atomic_inc(&dentry->d_count);
 	}
 
 	return ret;
@@ -352,7 +352,7 @@ extern char *dentry_path(struct dentry *, char *, int);
 static inline struct dentry *dget_dlock(struct dentry *dentry)
 {
 	if (dentry)
-		dentry->d_count++;
+		atomic_inc(&dentry->d_count);
 	return dentry;
 }
 

--=-Qvgc/S1g2/qog5KLpist--

