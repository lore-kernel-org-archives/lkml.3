Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab3IJVs3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 17:48:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63138 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752539Ab3IJVpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 17:45:11 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        kexec@lists.infradead.org
Cc: akpm@linux-foundation.org, zohar@linux.vnet.ibm.com,
        d.kasatkin@samsung.com, ebiederm@xmission.com, hpa@zytor.com,
        matthew.garrett@nebula.com, vgoyal@redhat.com
Subject: [PATCH 07/16] mm: Define a task flag MMF_VM_LOCKED for memlocked tasks and don't allow munlock
Date: Tue, 10 Sep 2013 17:44:22 -0400
Message-Id: <1378849471-10521-8-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define a flag to mark tasks which are running locked in memory. And use it
to deny munlock/munlockall operation.

We want to lock down a task in memory so that it is not swapped out.
Otherwise it is susceptible to attack on swap disk and then modified
code/data will be swapped back.

I am not sure what exactly a memory locked task should mean. Should
we lock down selected vmas of a task or all the vmas of a task.

In this patch series, I am locking down everything by setting VM_LOCKED
bit in mm->def_flags at exec() time. A task who is running memlocked,
can not unlock any of the vmas. munlock() call will fail. So one need
to be careful while signing a task and designating it to run as memlocked.

If feedback is to lock down only selected vmas, then we can probably
define a flag VM_LOCKED_PERM per vma which signifies that a particuar
vma is permanently locked by kernel and can not be unlocked if user calls
munlock[all]. This will allow to not memlock whole of the address space
of process.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 include/linux/sched.h | 2 ++
 mm/mlock.c            | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 50d04b9..0f7e8c0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -367,6 +367,8 @@ extern int get_dumpable(struct mm_struct *mm);
 
 #define MMF_HAS_UPROBES		19	/* has uprobes */
 #define MMF_RECALC_UPROBES	20	/* MMF_HAS_UPROBES can be wrong */
+#define MMF_VM_LOCKED		21	/* Task needs to run with some VMAs
+					   locked permanently */
 
 #define MMF_INIT_MASK		(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK)
 
diff --git a/mm/mlock.c b/mm/mlock.c
index 79b7cf7..50ab11a 100644
--- a/mm/mlock.c
+++ b/mm/mlock.c
@@ -478,6 +478,9 @@ SYSCALL_DEFINE2(munlock, unsigned long, start, size_t, len)
 {
 	int ret;
 
+	if (test_bit(MMF_VM_LOCKED, &current->mm->flags))
+		return -EINVAL;
+
 	down_write(&current->mm->mmap_sem);
 	len = PAGE_ALIGN(len + (start & ~PAGE_MASK));
 	start &= PAGE_MASK;
@@ -546,6 +549,9 @@ SYSCALL_DEFINE0(munlockall)
 {
 	int ret;
 
+	if (test_bit(MMF_VM_LOCKED, &current->mm->flags))
+		return -EINVAL;
+
 	down_write(&current->mm->mmap_sem);
 	ret = do_mlockall(0);
 	up_write(&current->mm->mmap_sem);
-- 
1.8.3.1

