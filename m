Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754521Ab3JDM6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 08:58:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47990 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754323Ab3JDM6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 08:58:47 -0400
Date: Fri, 4 Oct 2013 13:58:43 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@lst.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/17] RCU'd vfsmounts
Message-ID: <20131004125843.GP13318@ZenIV.linux.org.uk>
References: <CA+55aFzh+n_2fs=aWcT_5gnLC_pWSHqQPJeQ+fg=+Xw7ib9=dQ@mail.gmail.com>
 <20131003174439.GG13318@ZenIV.linux.org.uk>
 <CA+55aFy5kA7ubyetouWsB0OnB5mMRAoyQ-4kbQsCVWARFaf9MA@mail.gmail.com>
 <20131003194351.GK13318@ZenIV.linux.org.uk>
 <CA+55aFw-Yp7xEG3cnU1hcVXAHNGkCoomm0NsUt_Adf=mrauSHw@mail.gmail.com>
 <20131003204142.GL13318@ZenIV.linux.org.uk>
 <CA+55aFybjMDwdfV2uoGL=8U4c1tytjMwk4sU187e6ha2xQ=3+Q@mail.gmail.com>
 <20131003211448.GN13318@ZenIV.linux.org.uk>
 <20131004025351.GO13318@ZenIV.linux.org.uk>
 <20131004083729.GA23116@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131004083729.GA23116@lst.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 04, 2013 at 10:37:29AM +0200, Christoph Hellwig wrote:
> On Fri, Oct 04, 2013 at 03:53:51AM +0100, Al Viro wrote:
> > Speaking of those two - I really want to see file_table.c one killed.
> > Christoph, do you have anything along the lines of getting rid of the
> > mark_files_ro() nonsense?  After all, a combination of r/w vfsmount
> > and a superblock with MS_RDONLY in flags should do about the right thing
> > these days...  I can probably knock something together tomorrow, but
> > you've brought that thing up quite a few times, so if you happen to have
> > a patch more or less ready...
> 
> I used to have a patch for it that was also sent to the list long ago,
> but it got rid of the sysrq emergency remount r/o, which people didn't like.

Well...  What I had in mind is less drastic; something like this (on top
of #experimental); does anybody see any problems with it?

diff --git a/fs/file_table.c b/fs/file_table.c
index e61e552..23b6dca 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -36,8 +36,6 @@ struct files_stat_struct files_stat = {
 	.max_files = NR_FILE
 };
 
-DEFINE_STATIC_LGLOCK(files_lglock);
-
 /* SLAB cache for file structures */
 static struct kmem_cache *filp_cachep __read_mostly;
 
@@ -134,7 +132,6 @@ struct file *get_empty_filp(void)
 		return ERR_PTR(error);
 	}
 
-	INIT_LIST_HEAD(&f->f_u.fu_list);
 	atomic_long_set(&f->f_count, 1);
 	rwlock_init(&f->f_owner.lock);
 	spin_lock_init(&f->f_lock);
@@ -304,7 +301,6 @@ void fput(struct file *file)
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		struct task_struct *task = current;
 
-		file_sb_list_del(file);
 		if (likely(!in_interrupt() && !(task->flags & PF_KTHREAD))) {
 			init_task_work(&file->f_u.fu_rcuhead, ____fput);
 			if (!task_work_add(task, &file->f_u.fu_rcuhead, true))
@@ -333,7 +329,6 @@ void __fput_sync(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		struct task_struct *task = current;
-		file_sb_list_del(file);
 		BUG_ON(!(task->flags & PF_KTHREAD));
 		__fput(file);
 	}
@@ -345,129 +340,10 @@ void put_filp(struct file *file)
 {
 	if (atomic_long_dec_and_test(&file->f_count)) {
 		security_file_free(file);
-		file_sb_list_del(file);
 		file_free(file);
 	}
 }
 
-static inline int file_list_cpu(struct file *file)
-{
-#ifdef CONFIG_SMP
-	return file->f_sb_list_cpu;
-#else
-	return smp_processor_id();
-#endif
-}
-
-/* helper for file_sb_list_add to reduce ifdefs */
-static inline void __file_sb_list_add(struct file *file, struct super_block *sb)
-{
-	struct list_head *list;
-#ifdef CONFIG_SMP
-	int cpu;
-	cpu = smp_processor_id();
-	file->f_sb_list_cpu = cpu;
-	list = per_cpu_ptr(sb->s_files, cpu);
-#else
-	list = &sb->s_files;
-#endif
-	list_add(&file->f_u.fu_list, list);
-}
-
-/**
- * file_sb_list_add - add a file to the sb's file list
- * @file: file to add
- * @sb: sb to add it to
- *
- * Use this function to associate a file with the superblock of the inode it
- * refers to.
- */
-void file_sb_list_add(struct file *file, struct super_block *sb)
-{
-	if (likely(!(file->f_mode & FMODE_WRITE)))
-		return;
-	if (!S_ISREG(file_inode(file)->i_mode))
-		return;
-	lg_local_lock(&files_lglock);
-	__file_sb_list_add(file, sb);
-	lg_local_unlock(&files_lglock);
-}
-
-/**
- * file_sb_list_del - remove a file from the sb's file list
- * @file: file to remove
- * @sb: sb to remove it from
- *
- * Use this function to remove a file from its superblock.
- */
-void file_sb_list_del(struct file *file)
-{
-	if (!list_empty(&file->f_u.fu_list)) {
-		lg_local_lock_cpu(&files_lglock, file_list_cpu(file));
-		list_del_init(&file->f_u.fu_list);
-		lg_local_unlock_cpu(&files_lglock, file_list_cpu(file));
-	}
-}
-
-#ifdef CONFIG_SMP
-
-/*
- * These macros iterate all files on all CPUs for a given superblock.
- * files_lglock must be held globally.
- */
-#define do_file_list_for_each_entry(__sb, __file)		\
-{								\
-	int i;							\
-	for_each_possible_cpu(i) {				\
-		struct list_head *list;				\
-		list = per_cpu_ptr((__sb)->s_files, i);		\
-		list_for_each_entry((__file), list, f_u.fu_list)
-
-#define while_file_list_for_each_entry				\
-	}							\
-}
-
-#else
-
-#define do_file_list_for_each_entry(__sb, __file)		\
-{								\
-	struct list_head *list;					\
-	list = &(sb)->s_files;					\
-	list_for_each_entry((__file), list, f_u.fu_list)
-
-#define while_file_list_for_each_entry				\
-}
-
-#endif
-
-/**
- *	mark_files_ro - mark all files read-only
- *	@sb: superblock in question
- *
- *	All files are marked read-only.  We don't care about pending
- *	delete files so this should be used in 'force' mode only.
- */
-void mark_files_ro(struct super_block *sb)
-{
-	struct file *f;
-
-	lg_global_lock(&files_lglock);
-	do_file_list_for_each_entry(sb, f) {
-		if (!file_count(f))
-			continue;
-		if (!(f->f_mode & FMODE_WRITE))
-			continue;
-		spin_lock(&f->f_lock);
-		f->f_mode &= ~FMODE_WRITE;
-		spin_unlock(&f->f_lock);
-		if (file_check_writeable(f) != 0)
-			continue;
-		__mnt_drop_write(f->f_path.mnt);
-		file_release_write(f);
-	} while_file_list_for_each_entry;
-	lg_global_unlock(&files_lglock);
-}
-
 void __init files_init(unsigned long mempages)
 { 
 	unsigned long n;
@@ -483,6 +359,5 @@ void __init files_init(unsigned long mempages)
 	n = (mempages * (PAGE_SIZE / 1024)) / 10;
 	files_stat.max_files = max_t(unsigned long, n, NR_FILE);
 	files_defer_init();
-	lg_lock_init(&files_lglock, "files_lglock");
 	percpu_counter_init(&nr_files, 0);
 } 
diff --git a/fs/internal.h b/fs/internal.h
index 4a11e75..4657424 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -73,9 +73,6 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
 /*
  * file_table.c
  */
-extern void file_sb_list_add(struct file *f, struct super_block *sb);
-extern void file_sb_list_del(struct file *f);
-extern void mark_files_ro(struct super_block *);
 extern struct file *get_empty_filp(void);
 
 /*
diff --git a/fs/open.c b/fs/open.c
index a1465b1..fffbed4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -685,7 +685,6 @@ static int do_dentry_open(struct file *f,
 	}
 
 	f->f_mapping = inode->i_mapping;
-	file_sb_list_add(f, inode->i_sb);
 
 	if (unlikely(f->f_mode & FMODE_PATH)) {
 		f->f_op = &empty_fops;
@@ -724,7 +723,6 @@ static int do_dentry_open(struct file *f,
 
 cleanup_all:
 	fops_put(f->f_op);
-	file_sb_list_del(f);
 	if (f->f_mode & FMODE_WRITE) {
 		put_write_access(inode);
 		if (!special_file(inode->i_mode)) {
diff --git a/fs/super.c b/fs/super.c
index efa6e48..539d9bc 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -140,9 +140,6 @@ static void destroy_super(struct super_block *s)
 	int i;
 	list_lru_destroy(&s->s_dentry_lru);
 	list_lru_destroy(&s->s_inode_lru);
-#ifdef CONFIG_SMP
-	free_percpu(s->s_files);
-#endif
 	for (i = 0; i < SB_FREEZE_LEVELS; i++)
 		percpu_counter_destroy(&s->s_writers.counter[i]);
 	security_sb_free(s);
@@ -172,15 +169,6 @@ static struct super_block *alloc_super(struct file_system_type *type, int flags)
 	if (security_sb_alloc(s))
 		goto fail;
 
-#ifdef CONFIG_SMP
-	s->s_files = alloc_percpu(struct list_head);
-	if (!s->s_files)
-		goto fail;
-	for_each_possible_cpu(i)
-		INIT_LIST_HEAD(per_cpu_ptr(s->s_files, i));
-#else
-	INIT_LIST_HEAD(&s->s_files);
-#endif
 	for (i = 0; i < SB_FREEZE_LEVELS; i++) {
 		if (percpu_counter_init(&s->s_writers.counter[i], 0) < 0)
 			goto fail;
@@ -722,7 +710,8 @@ int do_remount_sb(struct super_block *sb, int flags, void *data, int force)
 	   make sure there are no rw files opened */
 	if (remount_ro) {
 		if (force) {
-			mark_files_ro(sb);
+			sb->s_readonly_remount = 1;
+			smp_wmb();
 		} else {
 			retval = sb_prepare_remount_readonly(sb);
 			if (retval)
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b09e4e1..e6b0109 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -764,12 +764,7 @@ static inline int ra_has_index(struct file_ra_state *ra, pgoff_t index)
 #define FILE_MNT_WRITE_RELEASED	2
 
 struct file {
-	/*
-	 * fu_list becomes invalid after file_free is called and queued via
-	 * fu_rcuhead for RCU freeing
-	 */
 	union {
-		struct list_head	fu_list;
 		struct llist_node	fu_llist;
 		struct rcu_head 	fu_rcuhead;
 	} f_u;
@@ -783,9 +778,6 @@ struct file {
 	 * Must not be taken from IRQ context.
 	 */
 	spinlock_t		f_lock;
-#ifdef CONFIG_SMP
-	int			f_sb_list_cpu;
-#endif
 	atomic_long_t		f_count;
 	unsigned int 		f_flags;
 	fmode_t			f_mode;
@@ -1264,11 +1256,6 @@ struct super_block {
 
 	struct list_head	s_inodes;	/* all inodes */
 	struct hlist_bl_head	s_anon;		/* anonymous dentries for (nfs) exporting */
-#ifdef CONFIG_SMP
-	struct list_head __percpu *s_files;
-#else
-	struct list_head	s_files;
-#endif
 	struct list_head	s_mounts;	/* list of mounts; _not_ for fs use */
 	struct block_device	*s_bdev;
 	struct backing_dev_info *s_bdi;
