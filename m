Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbaH2Rpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 13:45:51 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:57790 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753434AbaH2Rpg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 13:45:36 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: lwn@lwn.net
Subject: Re: [3.8.y.z extended stable] Linux 3.8.13.28
Date: Fri, 29 Aug 2014 10:45:32 -0700
Message-Id: <1409334332-22902-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409334332-22902-1-git-send-email-kamal@canonical.com>
References: <1409334332-22902-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

diff --git a/Makefile b/Makefile
index 5cc8641..7f7e383 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 VERSION = 3
 PATCHLEVEL = 8
 SUBLEVEL = 13
-EXTRAVERSION = .27
+EXTRAVERSION = .28
 NAME = Remoralised Urchins Update
 
 # *DOCUMENTATION*
diff --git a/arch/x86/include/asm/ptrace.h b/arch/x86/include/asm/ptrace.h
index 942a086..68e9f00 100644
--- a/arch/x86/include/asm/ptrace.h
+++ b/arch/x86/include/asm/ptrace.h
@@ -232,6 +232,22 @@ static inline unsigned long regs_get_kernel_stack_nth(struct pt_regs *regs,
 
 #define ARCH_HAS_USER_SINGLE_STEP_INFO
 
+/*
+ * When hitting ptrace_stop(), we cannot return using SYSRET because
+ * that does not restore the full CPU state, only a minimal set.  The
+ * ptracer can change arbitrary register values, which is usually okay
+ * because the usual ptrace stops run off the signal delivery path which
+ * forces IRET; however, ptrace_event() stops happen in arbitrary places
+ * in the kernel and don't force IRET path.
+ *
+ * So force IRET path after a ptrace stop.
+ */
+#define arch_ptrace_stop_needed(code, info)				\
+({									\
+	set_thread_flag(TIF_NOTIFY_RESUME);				\
+	false;								\
+})
+
 struct user_desc;
 extern int do_get_thread_area(struct task_struct *p, int idx,
 			      struct user_desc __user *info);
diff --git a/arch/x86/kernel/entry_32.S b/arch/x86/kernel/entry_32.S
index 60d03c2..1843543 100644
--- a/arch/x86/kernel/entry_32.S
+++ b/arch/x86/kernel/entry_32.S
@@ -434,8 +434,9 @@ sysenter_past_esp:
 	jnz sysenter_audit
 sysenter_do_call:
 	cmpl $(NR_syscalls), %eax
-	jae syscall_badsys
+	jae sysenter_badsys
 	call *sys_call_table(,%eax,4)
+sysenter_after_call:
 	movl %eax,PT_EAX(%esp)
 	LOCKDEP_SYS_EXIT
 	DISABLE_INTERRUPTS(CLBR_ANY)
@@ -516,6 +517,7 @@ ENTRY(system_call)
 	jae syscall_badsys
 syscall_call:
 	call *sys_call_table(,%eax,4)
+syscall_after_call:
 	movl %eax,PT_EAX(%esp)		# store the return value
 syscall_exit:
 	LOCKDEP_SYS_EXIT
@@ -685,8 +687,13 @@ syscall_fault:
 END(syscall_fault)
 
 syscall_badsys:
-	movl $-ENOSYS,PT_EAX(%esp)
-	jmp resume_userspace
+	movl $-ENOSYS,%eax
+	jmp syscall_after_call
+END(syscall_badsys)
+
+sysenter_badsys:
+	movl $-ENOSYS,%eax
+	jmp sysenter_after_call
 END(syscall_badsys)
 	CFI_ENDPROC
 /*
diff --git a/drivers/target/target_core_rd.c b/drivers/target/target_core_rd.c
index 0457de3..51968ed 100644
--- a/drivers/target/target_core_rd.c
+++ b/drivers/target/target_core_rd.c
@@ -174,7 +174,7 @@ static int rd_build_device_space(struct rd_dev *rd_dev)
 						- 1;
 
 		for (j = 0; j < sg_per_table; j++) {
-			pg = alloc_pages(GFP_KERNEL, 0);
+			pg = alloc_pages(GFP_KERNEL | __GFP_ZERO, 0);
 			if (!pg) {
 				pr_err("Unable to allocate scatterlist"
 					" pages for struct rd_dev_sg_table\n");
diff --git a/fs/namespace.c b/fs/namespace.c
index 5dd7709..4d63cfe 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -799,8 +799,21 @@ static struct mount *clone_mnt(struct mount *old, struct dentry *root,
 
 	mnt->mnt.mnt_flags = old->mnt.mnt_flags & ~MNT_WRITE_HOLD;
 	/* Don't allow unprivileged users to change mount flags */
-	if ((flag & CL_UNPRIVILEGED) && (mnt->mnt.mnt_flags & MNT_READONLY))
-		mnt->mnt.mnt_flags |= MNT_LOCK_READONLY;
+	if (flag & CL_UNPRIVILEGED) {
+		mnt->mnt.mnt_flags |= MNT_LOCK_ATIME;
+
+		if (mnt->mnt.mnt_flags & MNT_READONLY)
+			mnt->mnt.mnt_flags |= MNT_LOCK_READONLY;
+
+		if (mnt->mnt.mnt_flags & MNT_NODEV)
+			mnt->mnt.mnt_flags |= MNT_LOCK_NODEV;
+
+		if (mnt->mnt.mnt_flags & MNT_NOSUID)
+			mnt->mnt.mnt_flags |= MNT_LOCK_NOSUID;
+
+		if (mnt->mnt.mnt_flags & MNT_NOEXEC)
+			mnt->mnt.mnt_flags |= MNT_LOCK_NOEXEC;
+	}
 
 	atomic_inc(&sb->s_active);
 	mnt->mnt.mnt_sb = sb;
@@ -1740,9 +1753,6 @@ static int change_mount_flags(struct vfsmount *mnt, int ms_flags)
 	if (readonly_request == __mnt_is_readonly(mnt))
 		return 0;
 
-	if (mnt->mnt_flags & MNT_LOCK_READONLY)
-		return -EPERM;
-
 	if (readonly_request)
 		error = mnt_make_readonly(real_mount(mnt));
 	else
@@ -1771,6 +1781,33 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 	if (path->dentry != path->mnt->mnt_root)
 		return -EINVAL;
 
+	/* Don't allow changing of locked mnt flags.
+	 *
+	 * No locks need to be held here while testing the various
+	 * MNT_LOCK flags because those flags can never be cleared
+	 * once they are set.
+	 */
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_READONLY) &&
+	    !(mnt_flags & MNT_READONLY)) {
+		return -EPERM;
+	}
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_NODEV) &&
+	    !(mnt_flags & MNT_NODEV)) {
+		return -EPERM;
+	}
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_NOSUID) &&
+	    !(mnt_flags & MNT_NOSUID)) {
+		return -EPERM;
+	}
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_NOEXEC) &&
+	    !(mnt_flags & MNT_NOEXEC)) {
+		return -EPERM;
+	}
+	if ((mnt->mnt.mnt_flags & MNT_LOCK_ATIME) &&
+	    ((mnt->mnt.mnt_flags & MNT_ATIME_MASK) != (mnt_flags & MNT_ATIME_MASK))) {
+		return -EPERM;
+	}
+
 	err = security_sb_remount(sb, data);
 	if (err)
 		return err;
@@ -1782,7 +1819,7 @@ static int do_remount(struct path *path, int flags, int mnt_flags,
 		err = do_remount_sb(sb, flags, data, 0);
 	if (!err) {
 		br_write_lock(&vfsmount_lock);
-		mnt_flags |= mnt->mnt.mnt_flags & MNT_PROPAGATION_MASK;
+		mnt_flags |= mnt->mnt.mnt_flags & ~MNT_USER_SETTABLE_MASK;
 		mnt->mnt.mnt_flags = mnt_flags;
 		br_write_unlock(&vfsmount_lock);
 	}
@@ -1971,7 +2008,7 @@ static int do_new_mount(struct path *path, const char *fstype, int flags,
 		 */
 		if (!(type->fs_flags & FS_USERNS_DEV_MOUNT)) {
 			flags |= MS_NODEV;
-			mnt_flags |= MNT_NODEV;
+			mnt_flags |= MNT_NODEV | MNT_LOCK_NODEV;
 		}
 	}
 
@@ -2290,6 +2327,14 @@ long do_mount(const char *dev_name, const char *dir_name,
 	if (flags & MS_RDONLY)
 		mnt_flags |= MNT_READONLY;
 
+	/* The default atime for remount is preservation */
+	if ((flags & MS_REMOUNT) &&
+	    ((flags & (MS_NOATIME | MS_NODIRATIME | MS_RELATIME |
+		       MS_STRICTATIME)) == 0)) {
+		mnt_flags &= ~MNT_ATIME_MASK;
+		mnt_flags |= path.mnt->mnt_flags & MNT_ATIME_MASK;
+	}
+
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
 		   MS_STRICTATIME);
diff --git a/include/linux/mount.h b/include/linux/mount.h
index 73005f9..f058e13 100644
--- a/include/linux/mount.h
+++ b/include/linux/mount.h
@@ -42,11 +42,18 @@ struct mnt_namespace;
  * flag, consider how it interacts with shared mounts.
  */
 #define MNT_SHARED_MASK	(MNT_UNBINDABLE)
-#define MNT_PROPAGATION_MASK	(MNT_SHARED | MNT_UNBINDABLE)
+#define MNT_USER_SETTABLE_MASK  (MNT_NOSUID | MNT_NODEV | MNT_NOEXEC \
+				 | MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME \
+				 | MNT_READONLY)
+#define MNT_ATIME_MASK (MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME )
 
 
 #define MNT_INTERNAL	0x4000
 
+#define MNT_LOCK_ATIME		0x040000
+#define MNT_LOCK_NOEXEC		0x080000
+#define MNT_LOCK_NOSUID		0x100000
+#define MNT_LOCK_NODEV		0x200000
 #define MNT_LOCK_READONLY	0x400000
 
 struct vfsmount {
diff --git a/include/linux/ptrace.h b/include/linux/ptrace.h
index 2e99b8e..bb980ae 100644
--- a/include/linux/ptrace.h
+++ b/include/linux/ptrace.h
@@ -337,6 +337,9 @@ static inline void user_single_step_siginfo(struct task_struct *tsk,
  * calling arch_ptrace_stop() when it would be superfluous.  For example,
  * if the thread has not been back to user mode since the last stop, the
  * thread state might indicate that nothing needs to be done.
+ *
+ * This is guaranteed to be invoked once before a task stops for ptrace and
+ * may include arch-specific operations necessary prior to a ptrace stop.
  */
 #define arch_ptrace_stop_needed(code, info)	(0)
 #endif
diff --git a/mm/shmem.c b/mm/shmem.c
index efd0b3a..840643a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -78,11 +78,12 @@ static struct vfsmount *shm_mnt;
 #define SHORT_SYMLINK_LEN 128
 
 /*
- * shmem_fallocate and shmem_writepage communicate via inode->i_private
- * (with i_mutex making sure that it has only one user at a time):
- * we would prefer not to enlarge the shmem inode just for that.
+ * shmem_fallocate communicates with shmem_fault or shmem_writepage via
+ * inode->i_private (with i_mutex making sure that it has only one user at
+ * a time): we would prefer not to enlarge the shmem inode just for that.
  */
 struct shmem_falloc {
+	wait_queue_head_t *waitq; /* faults into hole wait for punch to end */
 	pgoff_t start;		/* start of range currently being fallocated */
 	pgoff_t next;		/* the next page offset to be fallocated */
 	pgoff_t nr_falloced;	/* how many new pages have been fallocated */
@@ -532,22 +533,19 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 		return;
 
 	index = start;
-	for ( ; ; ) {
+	while (index < end) {
 		cond_resched();
 		pvec.nr = shmem_find_get_pages_and_swap(mapping, index,
 				min(end - index, (pgoff_t)PAGEVEC_SIZE),
 							pvec.pages, indices);
 		if (!pvec.nr) {
-			if (index == start || unfalloc)
+			/* If all gone or hole-punch or unfalloc, we're done */
+			if (index == start || end != -1)
 				break;
+			/* But if truncating, restart to make sure all gone */
 			index = start;
 			continue;
 		}
-		if ((index == start || unfalloc) && indices[0] >= end) {
-			shmem_deswap_pagevec(&pvec);
-			pagevec_release(&pvec);
-			break;
-		}
 		mem_cgroup_uncharge_start();
 		for (i = 0; i < pagevec_count(&pvec); i++) {
 			struct page *page = pvec.pages[i];
@@ -559,8 +557,12 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 			if (radix_tree_exceptional_entry(page)) {
 				if (unfalloc)
 					continue;
-				nr_swaps_freed += !shmem_free_swap(mapping,
-								index, page);
+				if (shmem_free_swap(mapping, index, page)) {
+					/* Swap was replaced by page: retry */
+					index--;
+					break;
+				}
+				nr_swaps_freed++;
 				continue;
 			}
 
@@ -569,6 +571,11 @@ static void shmem_undo_range(struct inode *inode, loff_t lstart, loff_t lend,
 				if (page->mapping == mapping) {
 					VM_BUG_ON(PageWriteback(page));
 					truncate_inode_page(mapping, page);
+				} else {
+					/* Page was replaced by swap: retry */
+					unlock_page(page);
+					index--;
+					break;
 				}
 			}
 			unlock_page(page);
@@ -825,6 +832,7 @@ static int shmem_writepage(struct page *page, struct writeback_control *wbc)
 			spin_lock(&inode->i_lock);
 			shmem_falloc = inode->i_private;
 			if (shmem_falloc &&
+			    !shmem_falloc->waitq &&
 			    index >= shmem_falloc->start &&
 			    index < shmem_falloc->next)
 				shmem_falloc->nr_unswapped++;
@@ -1299,6 +1307,64 @@ static int shmem_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 	int error;
 	int ret = VM_FAULT_LOCKED;
 
+	/*
+	 * Trinity finds that probing a hole which tmpfs is punching can
+	 * prevent the hole-punch from ever completing: which in turn
+	 * locks writers out with its hold on i_mutex.  So refrain from
+	 * faulting pages into the hole while it's being punched.  Although
+	 * shmem_undo_range() does remove the additions, it may be unable to
+	 * keep up, as each new page needs its own unmap_mapping_range() call,
+	 * and the i_mmap tree grows ever slower to scan if new vmas are added.
+	 *
+	 * It does not matter if we sometimes reach this check just before the
+	 * hole-punch begins, so that one fault then races with the punch:
+	 * we just need to make racing faults a rare case.
+	 *
+	 * The implementation below would be much simpler if we just used a
+	 * standard mutex or completion: but we cannot take i_mutex in fault,
+	 * and bloating every shmem inode for this unlikely case would be sad.
+	 */
+	if (unlikely(inode->i_private)) {
+		struct shmem_falloc *shmem_falloc;
+
+		spin_lock(&inode->i_lock);
+		shmem_falloc = inode->i_private;
+		if (shmem_falloc &&
+		    shmem_falloc->waitq &&
+		    vmf->pgoff >= shmem_falloc->start &&
+		    vmf->pgoff < shmem_falloc->next) {
+			wait_queue_head_t *shmem_falloc_waitq;
+			DEFINE_WAIT(shmem_fault_wait);
+
+			ret = VM_FAULT_NOPAGE;
+			if ((vmf->flags & FAULT_FLAG_ALLOW_RETRY) &&
+			   !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT)) {
+				/* It's polite to up mmap_sem if we can */
+				up_read(&vma->vm_mm->mmap_sem);
+				ret = VM_FAULT_RETRY;
+			}
+
+			shmem_falloc_waitq = shmem_falloc->waitq;
+			prepare_to_wait(shmem_falloc_waitq, &shmem_fault_wait,
+					TASK_UNINTERRUPTIBLE);
+			spin_unlock(&inode->i_lock);
+			schedule();
+
+			/*
+			 * shmem_falloc_waitq points into the shmem_fallocate()
+			 * stack of the hole-punching task: shmem_falloc_waitq
+			 * is usually invalid by the time we reach here, but
+			 * finish_wait() does not dereference it in that case;
+			 * though i_lock needed lest racing with wake_up_all().
+			 */
+			spin_lock(&inode->i_lock);
+			finish_wait(shmem_falloc_waitq, &shmem_fault_wait);
+			spin_unlock(&inode->i_lock);
+			return ret;
+		}
+		spin_unlock(&inode->i_lock);
+	}
+
 	error = shmem_getpage(inode, vmf->pgoff, &vmf->page, SGP_CACHE, &ret);
 	if (error)
 		return ((error == -ENOMEM) ? VM_FAULT_OOM : VM_FAULT_SIGBUS);
@@ -1820,12 +1886,25 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		struct address_space *mapping = file->f_mapping;
 		loff_t unmap_start = round_up(offset, PAGE_SIZE);
 		loff_t unmap_end = round_down(offset + len, PAGE_SIZE) - 1;
+		DECLARE_WAIT_QUEUE_HEAD_ONSTACK(shmem_falloc_waitq);
+
+		shmem_falloc.waitq = &shmem_falloc_waitq;
+		shmem_falloc.start = unmap_start >> PAGE_SHIFT;
+		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
+		spin_lock(&inode->i_lock);
+		inode->i_private = &shmem_falloc;
+		spin_unlock(&inode->i_lock);
 
 		if ((u64)unmap_end > (u64)unmap_start)
 			unmap_mapping_range(mapping, unmap_start,
 					    1 + unmap_end - unmap_start, 0);
 		shmem_truncate_range(inode, offset, offset + len - 1);
 		/* No need to unmap again: hole-punching leaves COWed pages */
+
+		spin_lock(&inode->i_lock);
+		inode->i_private = NULL;
+		wake_up_all(&shmem_falloc_waitq);
+		spin_unlock(&inode->i_lock);
 		error = 0;
 		goto out;
 	}
@@ -1843,6 +1922,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		goto out;
 	}
 
+	shmem_falloc.waitq = NULL;
 	shmem_falloc.start = start;
 	shmem_falloc.next  = start;
 	shmem_falloc.nr_falloced = 0;
diff --git a/net/l2tp/l2tp_ppp.c b/net/l2tp/l2tp_ppp.c
index 26dbd9a..fbd6bbf 100644
--- a/net/l2tp/l2tp_ppp.c
+++ b/net/l2tp/l2tp_ppp.c
@@ -1404,7 +1404,7 @@ static int pppol2tp_setsockopt(struct socket *sock, int level, int optname,
 	int err;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.setsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (optlen < sizeof(int))
 		return -EINVAL;
@@ -1530,7 +1530,7 @@ static int pppol2tp_getsockopt(struct socket *sock, int level, int optname,
 	struct pppol2tp_session *ps;
 
 	if (level != SOL_PPPOL2TP)
-		return udp_prot.getsockopt(sk, level, optname, optval, optlen);
+		return -EINVAL;
 
 	if (get_user(len, optlen))
 		return -EFAULT;
diff --git a/net/sctp/associola.c b/net/sctp/associola.c
index 67c6823..c5cd799 100644
--- a/net/sctp/associola.c
+++ b/net/sctp/associola.c
@@ -396,7 +396,7 @@ void sctp_association_free(struct sctp_association *asoc)
 	/* Only real associations count against the endpoint, so
 	 * don't bother for if this is a temporary association.
 	 */
-	if (!asoc->temp) {
+	if (!list_empty(&asoc->asocs)) {
 		list_del(&asoc->asocs);
 
 		/* Decrement the backlog value for a TCP-style listening
