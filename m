Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759157AbaGCPL2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 11:11:28 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:58050 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758447AbaGCPLH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 11:11:07 -0400
Message-Id: <20140703151102.842945837@openvz.org>
User-Agent: quilt/0.60-1
Date: Thu, 03 Jul 2014 18:33:20 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: gorcunov@openvz.org, Kees Cook <keescook@chromium.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Andrew Vagin <avagin@openvz.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>
Subject: [RFC 2/2] prctl: PR_SET_MM -- Introduce PR_SET_MM_MAP operation
References: <20140703143318.568554771@openvz.org>
Content-Disposition: inline; filename=prctl-rework-new-mm-map-2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During development of c/r we've noticed that in case if we need to
support user namespaces we face a problem with capabilities in
prctl(PR_SET_MM, ...) call.

Current PR_SET_MM code forbids to modify fields if no CAP_SYS_RESOURCE
granted, but rather relies on one who use this interface is passing
more-less sane values (though the values must pass the basic validation
procedure).

It seems a better approach is to eliminate CAP_SYS_RESOURCE check but
provide all new values in one bundle, which would allow the kernel to make
more intensive test for sanity of values and same time allow us to
support checkpoint/restore of user namespaces.

Thus a new command (PR_SET_MM_MAP) introduced. It takes a pointer of
prctl_mm_map structure which carries all members to be updated.

Most intensive work is done in validate_prctl_map_locked helper,
because we need to make sure the values are valid. Thus we do

 - check the values are laying inside available user address space
 - stack, brk, command line arguments and evnironment variables
   must point to already existing VMA
 - values must be ordered (start < end)
 - if RLIMITs are defined don't allow to exceed it with new values

Since it uses prctl_set_mm_exe_file_locked helper, updating the
exe-file link is one-shot action for security reason.

I believe the old interface should be deprecated and ripped off
in a couple of kernel releases if noone against.

To test if new interface is implemented in the kernel one
can pass PR_SET_MM_MAP_SIZE opcode and the kernel returns
the size of currently supported struct prctl_mm_map.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
---
 include/uapi/linux/prctl.h |   19 ++++
 kernel/sys.c               |  188 ++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 206 insertions(+), 1 deletion(-)

Index: linux-2.6.git/include/uapi/linux/prctl.h
===================================================================
--- linux-2.6.git.orig/include/uapi/linux/prctl.h
+++ linux-2.6.git/include/uapi/linux/prctl.h
@@ -119,6 +119,25 @@
 # define PR_SET_MM_ENV_END		11
 # define PR_SET_MM_AUXV			12
 # define PR_SET_MM_EXE_FILE		13
+# define PR_SET_MM_MAP			14
+# define PR_SET_MM_MAP_SIZE		15
+
+struct prctl_mm_map {
+	unsigned long	start_code;
+	unsigned long	end_code;
+	unsigned long	start_data;
+	unsigned long	end_data;
+	unsigned long	start_brk;
+	unsigned long	brk;
+	unsigned long	start_stack;
+	unsigned long	arg_start;
+	unsigned long	arg_end;
+	unsigned long	env_start;
+	unsigned long	env_end;
+	unsigned long	*auxv;
+	unsigned int	auxv_size;
+	int		exe_fd;
+};
 
 /*
  * Set specific pid that is allowed to ptrace the current task.
Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1687,6 +1687,187 @@ exit:
 	return err;
 }
 
+/*
+ * WARNING: we don't require any capability here so be very careful
+ * in what is allowed for modification from userspace.
+ */
+static int validate_prctl_map_locked(struct prctl_mm_map *prctl_map)
+{
+	unsigned long mmap_max_addr = TASK_SIZE;
+	struct mm_struct *mm = current->mm;
+	struct vm_area_struct *stack_vma;
+	unsigned long rlim;
+	int error = 0;
+
+	/*
+	 * Make sure the members are not somewhere outside
+	 * of allowed address space.
+	 */
+#define __prctl_check_addr_space(__map, __member)				\
+	({									\
+		int __rc;							\
+		if ((unsigned long)__map->__member < mmap_max_addr &&		\
+		    (unsigned long)__map->__member >= mmap_min_addr)		\
+			__rc = 0;						\
+		else								\
+			__rc = -EINVAL;						\
+		__rc;								\
+	})
+
+	error |= __prctl_check_addr_space(prctl_map, start_code);
+	error |= __prctl_check_addr_space(prctl_map, end_code);
+	error |= __prctl_check_addr_space(prctl_map, start_data);
+	error |= __prctl_check_addr_space(prctl_map, end_data);
+	error |= __prctl_check_addr_space(prctl_map, start_stack);
+	error |= __prctl_check_addr_space(prctl_map, start_brk);
+	error |= __prctl_check_addr_space(prctl_map, brk);
+	error |= __prctl_check_addr_space(prctl_map, arg_start);
+	error |= __prctl_check_addr_space(prctl_map, arg_end);
+	error |= __prctl_check_addr_space(prctl_map, env_start);
+	error |= __prctl_check_addr_space(prctl_map, env_end);
+	if (error)
+		goto out;
+#undef __prctl_check_addr_space
+
+	/*
+	 * Stack, brk, command line arguments and environment must exist.
+	 */
+	stack_vma = find_vma(mm, prctl_map->start_stack);
+	if (!stack_vma) {
+		error = -EINVAL;
+		goto out;
+	}
+#define __prctl_check_vma(mm, addr) find_vma(mm, addr) ? 0 : -EINVAL
+	error |= __prctl_check_vma(mm, prctl_map->start_brk);
+	error |= __prctl_check_vma(mm, prctl_map->brk);
+	error |= __prctl_check_vma(mm, prctl_map->arg_start);
+	error |= __prctl_check_vma(mm, prctl_map->arg_end);
+	error |= __prctl_check_vma(mm, prctl_map->env_start);
+	error |= __prctl_check_vma(mm, prctl_map->env_end);
+	if (error)
+		goto out;
+#undef __prctl_check_vma
+
+	/*
+	 * Make sure the pairs are ordered.
+	 */
+#define __prctl_check_order(__map, __m1, __m2)					\
+	__map->__m2 <= __map->__m1
+	if (__prctl_check_order(prctl_map, start_code, end_code)	||
+	    __prctl_check_order(prctl_map, start_data, end_data)	||
+	    __prctl_check_order(prctl_map, arg_start, arg_end)		||
+	    __prctl_check_order(prctl_map, env_start, env_end))
+		goto out;
+#undef __prctl_check_order
+
+	error = -EINVAL;
+
+	/*
+	 * @brk should be after @end_data in traditional maps.
+	 */
+	if (prctl_map->start_brk <= prctl_map->end_data ||
+	    prctl_map->brk <= prctl_map->end_data)
+		goto out;
+
+	/*
+	 * Neither we should allow to override limits if they set.
+	 */
+	rlim = rlimit(RLIMIT_DATA);
+	if (rlim < RLIM_INFINITY) {
+		if ((prctl_map->brk - prctl_map->start_brk) +
+		    (prctl_map->end_data - prctl_map->start_data) > rlim)
+			goto out;
+	}
+
+	rlim = rlimit(RLIMIT_STACK);
+	if (rlim < RLIM_INFINITY) {
+#ifdef CONFIG_STACK_GROWSUP
+		unsigned long left = stack_vma->vm_end - prctl_map->start_stack;
+#else
+		unsigned long left = prctl_map->start_stack - stack_vma->vm_start;
+#endif
+		if (left > rlim)
+			goto out;
+	}
+
+	/*
+	 * Someone is trying to cheat the auxv vector.
+	 */
+	if (prctl_map->auxv && prctl_map->auxv_size > sizeof(mm->saved_auxv))
+		goto out;
+	error = 0;
+out:
+	return error;
+}
+
+static int prctl_set_mm_map(int opt, const void __user *addr, unsigned long data_size)
+{
+	struct prctl_mm_map prctl_map = { .exe_fd = (u32)-1, };
+	unsigned long user_auxv[AT_VECTOR_SIZE];
+	struct mm_struct *mm = current->mm;
+	int error = -EINVAL;
+
+	BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
+
+	if (opt == PR_SET_MM_MAP_SIZE)
+		return put_user((unsigned int)sizeof(prctl_map),
+				(unsigned int __user *)addr);
+
+	if (data_size != sizeof(prctl_map))
+		return -EINVAL;
+
+	if (copy_from_user(&prctl_map, addr, sizeof(prctl_map)))
+		return -EFAULT;
+
+	down_read(&mm->mmap_sem);
+
+	if (validate_prctl_map_locked(&prctl_map))
+		goto out;
+
+	if (prctl_map.auxv && prctl_map.auxv_size) {
+		up_read(&mm->mmap_sem);
+		memset(user_auxv, 0, sizeof(user_auxv));
+		error = copy_from_user(user_auxv,
+				       (const void __user *)prctl_map.auxv,
+				       prctl_map.auxv_size);
+		down_read(&mm->mmap_sem);
+		if (error)
+			goto out;
+	}
+
+	if (prctl_map.exe_fd != (u32)-1) {
+		error = prctl_set_mm_exe_file_locked(mm, prctl_map.exe_fd);
+		if (error)
+			goto out;
+	}
+
+	if (prctl_map.auxv && prctl_map.auxv_size) {
+		user_auxv[AT_VECTOR_SIZE - 2] = 0;
+		user_auxv[AT_VECTOR_SIZE - 1] = 0;
+
+		task_lock(current);
+		memcpy(mm->saved_auxv, user_auxv, sizeof(user_auxv));
+		task_unlock(current);
+	}
+
+	mm->start_code	= prctl_map.start_code;
+	mm->end_code	= prctl_map.end_code;
+	mm->start_data	= prctl_map.start_data;
+	mm->end_data	= prctl_map.end_data;
+	mm->start_brk	= prctl_map.start_brk;
+	mm->brk		= prctl_map.brk;
+	mm->start_stack	= prctl_map.start_stack;
+	mm->arg_start	= prctl_map.arg_start;
+	mm->arg_end	= prctl_map.arg_end;
+	mm->env_start	= prctl_map.env_start;
+	mm->env_end	= prctl_map.env_end;
+
+	error = 0;
+out:
+	up_read(&mm->mmap_sem);
+	return error;
+}
+
 static int prctl_set_mm(int opt, unsigned long addr,
 			unsigned long arg4, unsigned long arg5)
 {
@@ -1695,9 +1876,14 @@ static int prctl_set_mm(int opt, unsigne
 	struct vm_area_struct *vma;
 	int error;
 
-	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
+	if (arg5 || (arg4 && (opt != PR_SET_MM_AUXV &&
+			      opt != PR_SET_MM_MAP &&
+			      opt != PR_SET_MM_MAP_SIZE)))
 		return -EINVAL;
 
+	if (opt == PR_SET_MM_MAP || opt == PR_SET_MM_MAP_SIZE)
+		return prctl_set_mm_map(opt, (const void __user *)addr, arg4);
+
 	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 

