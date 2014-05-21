Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702AbaEUXWF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 19:22:05 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43325 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882AbaEUXWD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 19:22:03 -0400
Date: Wed, 21 May 2014 16:21:47 -0700
From: tip-bot for Andy Lutomirski <tipbot@zytor.com>
Message-ID: <tip-78d683e838a60ec4ba4591cca4364cba84a9e626@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, luto@amacapital.net, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, luto@amacapital.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <2eee21791bb36a0a408c5c2bdb382a9e6a41ca4a.1400538962.git.luto@amacapital.net>
References: <2eee21791bb36a0a408c5c2bdb382a9e6a41ca4a.1400538962.git.luto@amacapital.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/vdso] mm, fs: Add vm_ops->
 name as an alternative to arch_vma_name
Git-Commit-ID: 78d683e838a60ec4ba4591cca4364cba84a9e626
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  78d683e838a60ec4ba4591cca4364cba84a9e626
Gitweb:     http://git.kernel.org/tip/78d683e838a60ec4ba4591cca4364cba84a9e626
Author:     Andy Lutomirski <luto@amacapital.net>
AuthorDate: Mon, 19 May 2014 15:58:32 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 20 May 2014 11:36:31 -0700

mm, fs: Add vm_ops->name as an alternative to arch_vma_name

arch_vma_name sucks.  It's a silly hack, and it's annoying to
implement correctly.  In fact, AFAICS, even the straightforward x86
implementation is incorrect (I suspect that it breaks if the vdso
mapping is split or gets remapped).

This adds a new vm_ops->name operation that can replace it.  The
followup patches will remove all uses of arch_vma_name on x86,
fixing a couple of annoyances in the process.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
Link: http://lkml.kernel.org/r/2eee21791bb36a0a408c5c2bdb382a9e6a41ca4a.1400538962.git.luto@amacapital.net
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 fs/binfmt_elf.c    | 8 ++++++++
 fs/proc/task_mmu.c | 6 ++++++
 include/linux/mm.h | 6 ++++++
 3 files changed, 20 insertions(+)

diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index aa3cb62..df9ea41 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1108,6 +1108,14 @@ static bool always_dump_vma(struct vm_area_struct *vma)
 	/* Any vsyscall mappings? */
 	if (vma == get_gate_vma(vma->vm_mm))
 		return true;
+
+	/*
+	 * Assume that all vmas with a .name op should always be dumped.
+	 * If this changes, a new vm_ops field can easily be added.
+	 */
+	if (vma->vm_ops && vma->vm_ops->name && vma->vm_ops->name(vma))
+		return true;
+
 	/*
 	 * arch_vma_name() returns non-NULL for special architecture mappings,
 	 * such as vDSO sections.
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 442177b..9b2f5d6 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -300,6 +300,12 @@ show_map_vma(struct seq_file *m, struct vm_area_struct *vma, int is_pid)
 		goto done;
 	}
 
+	if (vma->vm_ops && vma->vm_ops->name) {
+		name = vma->vm_ops->name(vma);
+		if (name)
+			goto done;
+	}
+
 	name = arch_vma_name(vma);
 	if (!name) {
 		pid_t tid;
diff --git a/include/linux/mm.h b/include/linux/mm.h
index bf9811e..63f8d4e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -239,6 +239,12 @@ struct vm_operations_struct {
 	 */
 	int (*access)(struct vm_area_struct *vma, unsigned long addr,
 		      void *buf, int len, int write);
+
+	/* Called by the /proc/PID/maps code to ask the vma whether it
+	 * has a special name.  Returning non-NULL will also cause this
+	 * vma to be dumped unconditionally. */
+	const char *(*name)(struct vm_area_struct *vma);
+
 #ifdef CONFIG_NUMA
 	/*
 	 * set_policy() op must add a reference to any non-NULL @new mempolicy
