Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635AbaHWIui (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 04:50:38 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:34289 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247AbaHWIuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 04:50:12 -0400
Message-Id: <20140823085007.388102981@openvz.org>
User-Agent: quilt/0.60-1
Date: Sat, 23 Aug 2014 12:46:13 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, keescook@chromium.org, oleg@redhat.com,
        tj@kernel.org, avagin@openvz.org, ebiederm@xmission.com, hpa@zytor.com,
        serge.hallyn@canonical.com, xemul@parallels.com, segoon@openwall.com,
        kamezawa.hiroyu@jp.fujitsu.com, mtk.manpages@gmail.com, jln@google.com,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [patch 2/2 -mm] prctl: PR_SET_MM_MAP -- Rework validate_prctl_map_locked to use offsets
References: <20140823084611.939722362@openvz.org>
Content-Disposition: inline; filename=prctl-rework-new-mm-map-offsets
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew proposed to use constant offsets when we check the structure members
which allows to shrink the code size for ~1K. We're safe to use compile-time
calculated offsets because this structure is a part of api and must remain
immutable.

Still there are the ways to change this structure keeping it backward
compatible: size of the structure is a constant value known at the moment
of kernel building time so any new member added to the structure will change
its size and use of offsetof for new members one can calculate which exactly
version user passes to us. Another option is to add explicit @version member.

Also add BUILD_BUG_ON to make sure the structure is not bloated too much.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Oleg Nesterov <oleg@redhat.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrew Vagin <avagin@openvz.org>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Vasiliy Kulikov <segoon@openwall.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Julien Tinnes <jln@google.com>
---
 kernel/sys.c |   73 ++++++++++++++++++++++++++---------------------------------
 1 file changed, 33 insertions(+), 40 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1697,56 +1697,48 @@ static int validate_prctl_map_locked(str
 	unsigned long mmap_max_addr = TASK_SIZE;
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *stack_vma;
-	int error = 0;
+	int error = -EINVAL, i;
+
+	static const unsigned char offsets[] = {
+		offsetof(struct prctl_mm_map, start_code),	/*  0 */
+		offsetof(struct prctl_mm_map, end_code),	/*  1 */
+		offsetof(struct prctl_mm_map, start_data),	/*  2 */
+		offsetof(struct prctl_mm_map, end_data),	/*  3 */
+		offsetof(struct prctl_mm_map, start_stack),	/*  4 */
+		offsetof(struct prctl_mm_map, start_brk),	/*  5 */
+		offsetof(struct prctl_mm_map, brk),		/*  6 */
+		offsetof(struct prctl_mm_map, arg_start),	/*  7 */
+		offsetof(struct prctl_mm_map, arg_end),		/*  8 */
+		offsetof(struct prctl_mm_map, env_start),	/*  9 */
+		offsetof(struct prctl_mm_map, env_end),		/* 10 */
+	};
 
 	/*
 	 * Make sure the members are not somewhere outside
 	 * of allowed address space.
 	 */
-#define __prctl_check_addr_space(__member)					\
-	({									\
-		int __rc;							\
-		if ((unsigned long)prctl_map->__member < mmap_max_addr &&	\
-		    (unsigned long)prctl_map->__member >= mmap_min_addr)	\
-			__rc = 0;						\
-		else								\
-			__rc = -EINVAL;						\
-		__rc;								\
-	})
-	error |= __prctl_check_addr_space(start_code);
-	error |= __prctl_check_addr_space(end_code);
-	error |= __prctl_check_addr_space(start_data);
-	error |= __prctl_check_addr_space(end_data);
-	error |= __prctl_check_addr_space(start_stack);
-	error |= __prctl_check_addr_space(start_brk);
-	error |= __prctl_check_addr_space(brk);
-	error |= __prctl_check_addr_space(arg_start);
-	error |= __prctl_check_addr_space(arg_end);
-	error |= __prctl_check_addr_space(env_start);
-	error |= __prctl_check_addr_space(env_end);
-	if (error)
-		goto out;
-#undef __prctl_check_addr_space
+	for (i = 0; i < ARRAY_SIZE(offsets); i++) {
+		u64 val = ((u64 *)prctl_map)[offsets[i]];
+
+		if ((unsigned long)val < mmap_max_addr &&
+		    (unsigned long)val >= mmap_min_addr)
+			goto out;
+
+		/*
+		 * Break, command line arguments and environment must exist.
+		 */
+		if (i >= 5) {
+			if (!(find_vma(mm, (unsigned long)val)))
+				goto out;
+		}
+	}
 
 	/*
-	 * Stack, brk, command line arguments and environment must exist.
+	 * Stack reference will be needed for rlimit check.
 	 */
 	stack_vma = find_vma(mm, (unsigned long)prctl_map->start_stack);
-	if (!stack_vma) {
-		error = -EINVAL;
-		goto out;
-	}
-#define __prctl_check_vma(__member)						\
-	find_vma(mm, (unsigned long)prctl_map->__member) ? 0 : -EINVAL
-	error |= __prctl_check_vma(start_brk);
-	error |= __prctl_check_vma(brk);
-	error |= __prctl_check_vma(arg_start);
-	error |= __prctl_check_vma(arg_end);
-	error |= __prctl_check_vma(env_start);
-	error |= __prctl_check_vma(env_end);
-	if (error)
+	if (!stack_vma)
 		goto out;
-#undef __prctl_check_vma
 
 	/*
 	 * Make sure the pairs are ordered.
@@ -1827,6 +1819,7 @@ static int prctl_set_mm_map(int opt, con
 	int error = -EINVAL;
 
 	BUILD_BUG_ON(sizeof(user_auxv) != sizeof(mm->saved_auxv));
+	BUILD_BUG_ON(sizeof(struct prctl_mm_map) > 256);
 
 	if (opt == PR_SET_MM_MAP_SIZE)
 		return put_user((unsigned int)sizeof(prctl_map),

