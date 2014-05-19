Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201AbaESW70 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 18:59:26 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:57394 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602AbaESW6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 18:58:44 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sasha.levin@oracle.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Dave Jones <davej@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH 2/4] mm,fs: Add vm_ops->name as an alternative to arch_vma_name
Date: Mon, 19 May 2014 15:58:32 -0700
Message-Id: <2eee21791bb36a0a408c5c2bdb382a9e6a41ca4a.1400538962.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1400538962.git.luto@amacapital.net>
References: <cover.1400538962.git.luto@amacapital.net>
In-Reply-To: <cover.1400538962.git.luto@amacapital.net>
References: <cover.1400538962.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch_vma_name sucks.  It's a silly hack, and it's annoying to
implement correctly.  In fact, AFAICS, even the straightforward x86
implementation is incorrect (I suspect that it breaks if the vdso
mapping is split or gets remapped).

This adds a new vm_ops->name operation that can replace it.  The
followup patches will remove all uses of arch_vma_name on x86,
fixing a couple of annoyances in the process.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
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
-- 
1.9.0

