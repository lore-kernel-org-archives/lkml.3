Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754736Ab3JDKd3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:33:29 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47558 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3JDKdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:33:24 -0400
Subject: [PATCH 18/19] Adding support for compat ELF class data structures
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@in.ibm.com>
Cc: amwang@redhat.com, rdunlap@xenotime.net, andi@firstfloor.org,
        aravinda@linux.vnet.ibm.com, hch@lst.de, mhiramat@redhat.com,
        jeremy.fitzhardinge@citrix.com, xemul@parallels.com,
        suzuki@linux.vnet.ibm.com, kosaki.motohiro@jp.fujitsu.com,
        adobriyan@gmail.com, tarundsk@linux.vnet.ibm.com, vapier@gentoo.org,
        roland@hack.frob.com, tj@kernel.org, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, d.hatayama@jp.fujitsu.com, james.hogan@imgtec.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org
Date: Fri, 04 Oct 2013 16:03:09 +0530
Message-ID: <20131004103309.1612.87082.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-6102-0000-0000-00000447AB07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

gencore-elf.c will be reused for the compat ELF class support. Hence, define
macros to get the right member for each class.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/proc/gencore-elf.c |   31 ++++++++++++++++++++-----------
 fs/proc/gencore.h     |   16 +++++++++++++++-
 2 files changed, 35 insertions(+), 12 deletions(-)

diff --git a/fs/proc/gencore-elf.c b/fs/proc/gencore-elf.c
index 244e5bb..3c6b67a 100644
--- a/fs/proc/gencore-elf.c
+++ b/fs/proc/gencore-elf.c
@@ -33,6 +33,15 @@
 #endif
 
 #include "gencore.h"
+#ifndef et_prstatus
+/* prstatus field for native elf,  in elf_thread_core_info*/
+#define et_prstatus u.prstatus
+#endif
+
+#ifndef cp_prpsinfo
+/* prpsinfo field for native elf, in core_proc */
+#define cp_prpsinfo u.prpsinfo
+#endif
 
 static int notesize(struct memelfnote *men)
 {
@@ -77,14 +86,14 @@ static int fill_thread_core_info(struct elf_thread_core_info *tinfo,
 	unsigned int i;
 	const struct user_regset_view *view = task_user_regset_view(tinfo->task);
 
-	fill_prstatus(&tinfo->prstatus, tinfo->task, 0);
+	fill_prstatus(&tinfo->et_prstatus, tinfo->task, 0);
 
 	do_thread_regset_writeback(tinfo->task, &view->regsets[0]);
 	(void) view->regsets[0].get(tinfo->task, &view->regsets[0],
-				0, sizeof(tinfo->prstatus.pr_reg),
-				&tinfo->prstatus.pr_reg, NULL);
+				0, sizeof(tinfo->et_prstatus.pr_reg),
+				&tinfo->et_prstatus.pr_reg, NULL);
 	fill_note(&tinfo->notes[0], "CORE", NT_PRSTATUS,
-			sizeof(tinfo->prstatus), &tinfo->prstatus);
+			sizeof(tinfo->et_prstatus), &tinfo->et_prstatus);
 	cp->notes_size += notesize(&tinfo->notes[0]);
 	tinfo->num_notes = view->n;
 
@@ -109,7 +118,7 @@ static int fill_thread_core_info(struct elf_thread_core_info *tinfo,
 						regset->core_note_type,
 						size, data);
 				else {
-					tinfo->prstatus.pr_fpvalid = 1;
+					tinfo->et_prstatus.pr_fpvalid = 1;
 					fill_note(&tinfo->notes[i], "CORE",
 						NT_PRFPREG, size, data);
 				}
@@ -128,14 +137,14 @@ static int fill_thread_core_info(struct elf_thread_core_info *tinfo,
 	elf_fpxregset_t xfpu, *pxfpu;
 #endif
 
-	fill_prstatus(&tinfo->prstatus, t->task, 0);
-	elf_core_copy_task_regs(t->task, &tinfo->prstatus.pr_reg);
+	fill_prstatus(&tinfo->et_prstatus, t->task, 0);
+	elf_core_copy_task_regs(t->task, &tinfo->et_prstatus.pr_reg);
 	fill_note(&tinfo->notes[0], "CORE", NT_PRSTATUS,
-			sizeof(t->prstatus), &t->prstatus);
+			sizeof(t->et_prstatus), &t->et_prstatus);
 	cp->notes_size += notesize(&tinfo->notes[0]);
 	tinfo->num_notes = 1;
 
-	if (tinfo->prstatus.pr_fpvalid = elf_core_copy_task_fpregs(tinfo->task,
+	if (tinfo->et_prstatus.pr_fpvalid = elf_core_copy_task_fpregs(tinfo->task,
 							NULL, &fpu)) {
 		pfpu = kzalloc(sizeof(*pfpu), GFP_KERNEL);
 		if (pfpu == NULL)
@@ -168,9 +177,9 @@ static int collect_notes(struct core_proc *cp)
 	struct elf_thread_core_info *tinfo;
 
 	/* Fill the 2 process wide notes */
-	fill_psinfo(&cp->prpsinfo, cp->task, cp->task->mm);
+	fill_psinfo(&cp->cp_prpsinfo, cp->task, cp->task->mm);
 	fill_note(&cp->psinfo, "CORE", NT_PRPSINFO,
-			sizeof(struct elf_prpsinfo), &cp->prpsinfo);
+			sizeof(struct elf_prpsinfo), &cp->cp_prpsinfo);
 	cp->notes_size += notesize(&cp->psinfo);
 
 	fill_auxv_note(&cp->auxv, cp->task->mm);
diff --git a/fs/proc/gencore.h b/fs/proc/gencore.h
index d7a5fb3..60972a2 100644
--- a/fs/proc/gencore.h
+++ b/fs/proc/gencore.h
@@ -7,6 +7,9 @@
 #include <linux/completion.h>
 #include <linux/elfcore.h>
 #include <linux/elfcore-internal.h>
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+#include <linux/elfcore-compat.h>
+#endif
 
 enum { ELF_CLASS_NATIVE, ELF_CLASS_COMPAT };
 
@@ -15,6 +18,12 @@ struct elf_thread_core_info {
 	struct elf_thread_core_info *next;
 	struct task_struct *task;
 	struct elf_prstatus prstatus;
+	union {
+		struct elf_prstatus prstatus;
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+		struct compat_elf_prstatus compat_prstatus;
+#endif
+	} u;
 	struct memelfnote notes[0];
 };
 
@@ -28,7 +37,12 @@ struct core_proc {
 	struct elf_thread_core_info *tinfo; 
 	struct memelfnote psinfo; 
 	struct memelfnote auxv;
-	struct elf_prpsinfo prpsinfo;
+	union {
+		struct elf_prpsinfo prpsinfo;
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+		struct compat_elf_prpsinfo compat_prpsinfo;
+#endif
+	} u; 
 	size_t elf_buflen;      /* size of elf_buf */
 	size_t nphdrs;          /* number of phdrs */
 	size_t notes_size;

