Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab3JDKch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:32:37 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:41925 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3JDKcf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:32:35 -0400
Subject: [PATCH 14/19] Create ELF Core notes Data
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
Date: Fri, 04 Oct 2013 16:02:21 +0530
Message-ID: <20131004103221.1612.11297.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-7014-0000-0000-000003B72A09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Collect the PT_NOTE information for the core.

There are two "process wide" notes. NT_PRPSINFO and NT_AUXV. These are captured
in the core_proc structure.

Each thread gets a NT_PRSTATUS note, which will contain the GPR contents. A
thread may have additional notes depending on the other register sets used by it.
Uses struct elf_thread_core_info to capture the thread specific information.

fill_thread_core_info() fills in the notes for a thread.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N. Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/gencore-elf.c |  180 ++++++++++++++++++++++++++++++++++++++++++++++++-
 fs/proc/gencore.c     |   56 +++++++++++++++
 fs/proc/gencore.h     |   28 ++++++++
 3 files changed, 260 insertions(+), 4 deletions(-)

diff --git a/fs/proc/gencore-elf.c b/fs/proc/gencore-elf.c
index 0a245f0..6e97f6a 100644
--- a/fs/proc/gencore-elf.c
+++ b/fs/proc/gencore-elf.c
@@ -34,6 +34,157 @@
 
 #include "gencore.h"
 
+static int notesize(struct memelfnote *men)
+{
+	int size = sizeof(struct elf_note);
+
+	size += roundup(strlen(men->name) + 1, 4);
+	size += roundup(men->datasz, 4);
+
+	return size;
+}
+
+/* Store the note in the header buffer */
+static char *storenote(struct memelfnote *men, char *bufp)
+{
+	struct elf_note *en = (struct elf_note *)bufp;
+
+	en->n_namesz = strlen(men->name) + 1;
+	en->n_descsz = men->datasz;
+	en->n_type = men->type;
+	bufp = (char *) (en + 1);
+
+	memcpy(bufp, men->name, en->n_namesz);
+	bufp = (char *) roundup((unsigned long)bufp + en->n_namesz, 4);
+
+	memcpy(bufp, men->data, men->datasz);
+	bufp = (char *) roundup((unsigned long)bufp + men->datasz, 4);
+
+	return bufp;
+}
+
+#ifdef CORE_DUMP_USE_REGSET
+static void do_thread_regset_writeback(struct task_struct *task,
+				const struct user_regset *regset)
+{
+	if (regset->writeback)
+		regset->writeback(task, regset, 1);
+}
+
+static int fill_thread_core_info(struct elf_thread_core_info *tinfo,
+					struct core_proc *cp)
+{
+	unsigned int i;
+	const struct user_regset_view *view = task_user_regset_view(tinfo->task);
+
+	fill_prstatus(&tinfo->prstatus, tinfo->task, 0);
+
+	do_thread_regset_writeback(tinfo->task, &view->regsets[0]);
+	(void) view->regsets[0].get(tinfo->task, &view->regsets[0],
+				0, sizeof(tinfo->prstatus.pr_reg),
+				&tinfo->prstatus.pr_reg, NULL);
+	fill_note(&tinfo->notes[0], "CORE", NT_PRSTATUS,
+			sizeof(tinfo->prstatus), &tinfo->prstatus);
+	cp->notes_size += notesize(&tinfo->notes[0]);
+	tinfo->num_notes = view->n;
+
+	for (i = 1; i < view->n; i++) {
+		const struct user_regset *regset = &view->regsets[i];
+
+		do_thread_regset_writeback(tinfo->task, regset);
+		if (regset->core_note_type &&
+			(!regset->active || regset->active(tinfo->task, regset))) {
+			int ret;
+			size_t size = regset->n * regset->size;
+			void *data = kzalloc(size, GFP_KERNEL);
+			if (!unlikely(data))
+				return 0;
+			ret = regset->get(tinfo->task, regset,
+					0, size, data, NULL);
+			if (unlikely(ret))
+				kfree(data);
+			else {
+				if (regset->core_note_type != NT_PRFPREG)
+					fill_note(&tinfo->notes[i], "LINUX",
+						regset->core_note_type,
+						size, data);
+				else {
+					tinfo->prstatus.pr_fpvalid = 1;
+					fill_note(&tinfo->notes[i], "CORE",
+						NT_PRFPREG, size, data);
+				}
+				cp->notes_size += notesize(&tinfo->notes[i]);
+			}
+		}
+	}
+	return 1;
+}
+#else
+static int fill_thread_core_info(struct elf_thread_core_info *tinfo,
+					struct core_proc *cp)
+{
+	elf_fpregset_t fpu, *pfpu;
+#ifdef ELF_CORE_COPY_XFPREGS
+	elf_fpxregset_t xfpu, *pxfpu;
+#endif
+
+	fill_prstatus(&tinfo->prstatus, t->task, 0);
+	elf_core_copy_task_regs(t->task, &tinfo->prstatus.pr_reg);
+	fill_note(&tinfo->notes[0], "CORE", NT_PRSTATUS,
+			sizeof(t->prstatus), &t->prstatus);
+	cp->notes_size += notesize(&tinfo->notes[0]);
+	tinfo->num_notes = 1;
+
+	if (tinfo->prstatus.pr_fpvalid = elf_core_copy_task_fpregs(tinfo->task,
+							NULL, &fpu)) {
+		pfpu = kzalloc(sizeof(*pfpu), GFP_KERNEL);
+		if (pfpu == NULL)
+			return 0;
+		memcpy(pfpu, &fpu, sizeof(fpu));
+		fill_note(&tinfo->notes[tinfo->num_notes], "CORE", NT_PRFPREG,
+				sizeof(*pfpu), pfpu);
+		cp->notes_size += notesize(&tinfo->notes[tinfo->num_notes]);
+		tinfo->num_notes++;
+	}
+#ifdef ELF_CORE_COPY_XFPREGS
+	if (elf_core_copy_task_xfpregs(tinfo->task, &xfpu)) {
+		pxfpu = kzalloc(sizeof(*pxfpu), GFP_KERNEL);
+		if (!pxfpu)
+			return 0;
+		memcpy(pxfpu, &xfpu, sizeof(xfpu));
+		fill_note(&tinfo->notes[tinfo->num_notes], "LINUX",
+			ELF_CORE_XFPREG_TYPE, sizeof(*pxfpu), pxfpu);
+		cp->notes_size += notesize(&tinfo->notes[tinfo->num_notes]);
+		tinfo->num_notes++;
+	}
+#endif
+	return 1;
+}
+#endif
+
+/* Returns 0 on error, 1 on success */
+static int collect_notes(struct core_proc *cp)
+{
+	struct elf_thread_core_info *tinfo;
+
+	/* Fill the 2 process wide notes */
+	fill_psinfo(&cp->prpsinfo, cp->task, cp->task->mm);
+	fill_note(&cp->psinfo, "CORE", NT_PRPSINFO,
+			sizeof(struct elf_prpsinfo), &cp->prpsinfo);
+	cp->notes_size += notesize(&cp->psinfo);
+
+	fill_auxv_note(&cp->auxv, cp->task->mm);
+	cp->notes_size += notesize(&cp->auxv);
+
+	tinfo = cp->tinfo;
+	while (tinfo != NULL) {
+		if (!fill_thread_core_info(tinfo, cp))
+			return 0;
+		tinfo = tinfo->next;
+	}
+	return 1;
+}
+
 static void get_elfhdr_size(struct core_proc *cp)
 {
 	struct vm_area_struct *gate_vma;
@@ -51,7 +202,7 @@ static void get_elfhdr_size(struct core_proc *cp)
 
 	cp->nphdrs = segs;
 	cp->elf_buflen = sizeof(struct elfhdr) +
-			(cp->nphdrs * sizeof(struct elf_phdr));
+			(cp->nphdrs * sizeof(struct elf_phdr)) + cp->notes_size;
 	cp->elf_buflen = roundup(cp->elf_buflen, ELF_EXEC_PAGESIZE);
 
 	return;
@@ -66,11 +217,13 @@ static int create_elf_header(struct core_proc *cp)
 	struct elfhdr *elf = (struct elfhdr *)cp->elf_buf;
 	struct elf_phdr *note;
 	struct vm_area_struct *vma, *gate_vma = get_gate_vma(cp->task->mm);
+	struct elf_thread_core_info *tinfo;
 	char *bufp;
 	off_t dataoff, offset;
 	short e_phnum = (cp->nphdrs > PN_XNUM ? PN_XNUM : cp->nphdrs);
 	size_t exphdrs_sz = 0;
 	unsigned long limit = elf_core_extra_phdrs() * sizeof(struct elf_phdr);
+	int first = 1;
 
 #ifdef CORE_DUMP_USE_REGSET
 	const struct user_regset_view *view = task_user_regset_view(cp->task);
@@ -91,7 +244,7 @@ static int create_elf_header(struct core_proc *cp)
 	note->p_offset = dataoff;
 	note->p_vaddr = 0;
 	note->p_paddr = 0;
-	/* TODO: Needs to be populated with the size of the notes section */
+	note->p_filesz = cp->notes_size;
 	note->p_memsz = 0;
 	note->p_flags = 0;
 	note->p_align = 0;
@@ -138,6 +291,22 @@ static int create_elf_header(struct core_proc *cp)
 						dataoff, cp->nphdrs);
 		dataoff += sizeof(struct elf_shdr);
 	}
+	/* Store the notes */
+	tinfo = cp->tinfo;
+	do {
+		int i;
+
+		bufp = storenote(&tinfo->notes[0], bufp);
+		if (first) {
+			bufp = storenote(&cp->psinfo, bufp);
+			bufp = storenote(&cp->auxv, bufp);
+		}
+		for (i = 1; i < tinfo->num_notes; i++)
+			if (tinfo->notes[i].data != NULL)
+				bufp = storenote(&tinfo->notes[i], bufp);
+		first = 0;
+		tinfo = tinfo->next;
+	} while (tinfo != NULL);
 
 	return 0;
 }
@@ -147,6 +316,13 @@ ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
 {
 	ssize_t ret = 0;
 
+	if (!cp->notes_size) {
+		if (!collect_notes(cp)) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	}
+
 	if (!cp->elf_buf) {
 		get_elfhdr_size(cp);
 
diff --git a/fs/proc/gencore.c b/fs/proc/gencore.c
index d741f18..463bedd 100644
--- a/fs/proc/gencore.c
+++ b/fs/proc/gencore.c
@@ -29,7 +29,7 @@
 #include <linux/slab.h>
 #include "internal.h"
 #include "gencore.h"
-
+#include <linux/sched.h>
 static LIST_HEAD(core_list);
 static DEFINE_MUTEX(core_mutex);
 
@@ -69,6 +69,39 @@ out:
 	return ret;
 }
 
+static void free_notes_data(struct elf_thread_core_info *tinfo)
+{
+	int i;
+
+	for (i = 1; i < tinfo->num_notes; i++)
+		if (tinfo->notes[i].data) {
+			kfree(tinfo->notes[i].data);
+			tinfo->notes[i].data = NULL;
+		}
+}
+
+static void cleanup_cp(struct core_proc *cp)
+{
+	struct elf_thread_core_info *tmp, *tinfo = cp->tinfo;
+
+	mutex_lock(&core_mutex);
+	list_del(&cp->list);
+	mutex_unlock(&core_mutex);
+
+	if (tinfo) {
+		do {
+			tmp = tinfo;
+			tinfo = tinfo->next;
+			free_notes_data(tmp);
+			kfree(tmp);
+		} while (tinfo != NULL);
+	}
+	if (cp->shdr)
+		kfree(cp->shdr);
+	kfree(cp->elf_buf);
+	kfree(cp);
+}
+
 static void gencore_work(struct callback_head *open_work)
 {
 	/* TODO A method to know when all the threads have reached here */ 
@@ -143,7 +176,8 @@ static int open_gencore(struct inode *inode, struct file *filp)
 	struct task_struct *task = get_proc_task(inode);
 	struct core_proc *cp;
 	struct task_struct *t;
-	int elf_class;
+	struct elf_thread_core_info *tinfo = NULL;
+	int elf_class, max_regset, i;
 	int ret = 0;
 	if (!task)
 		return -ENOENT;
@@ -171,12 +205,30 @@ static int open_gencore(struct inode *inode, struct file *filp)
 	mutex_lock(&core_mutex);
 	list_add(&cp->list, &core_list);
 	mutex_unlock(&core_mutex);
+	max_regset = get_max_regsets(task);
+
+	for (i = 0; i < get_nr_threads(task); i++) {
+		tinfo = kzalloc(offsetof(struct elf_thread_core_info,
+					notes[max_regset]), GFP_KERNEL);
+		if (unlikely(!tinfo)) {
+			cleanup_cp(cp);
+			ret = -ENOMEM;
+			goto out;
+		}
+		tinfo->next = cp->tinfo;
+		cp->tinfo = tinfo;
+	}
+
 	init_completion(&cp->hold);
 	/* Adding the work for all the threads except current */
 	t = cp->task;
 	init_task_work(&cp->twork, gencore_work);
 	read_lock(&tasklist_lock);
 	do {
+		if (tinfo) {
+			tinfo->task = t;
+			tinfo = tinfo->next;
+		}
 		if (t != current)
 			task_work_add(t, &cp->twork, true);
 	} while_each_thread(cp->task, t);
diff --git a/fs/proc/gencore.h b/fs/proc/gencore.h
index 6c1d57c..e508417 100644
--- a/fs/proc/gencore.h
+++ b/fs/proc/gencore.h
@@ -5,6 +5,16 @@
 #include <linux/list.h>
 #include <linux/sched.h>
 #include <linux/completion.h>
+#include <linux/elfcore.h>
+#include <linux/elfcore-internal.h>
+
+struct elf_thread_core_info {
+	unsigned short num_notes;       /* Number of notes for this thread */
+	struct elf_thread_core_info *next;
+	struct task_struct *task;
+	struct elf_prstatus prstatus;
+	struct memelfnote notes[0];
+};
 
 struct core_proc {
 	struct list_head list;
@@ -13,10 +23,28 @@ struct core_proc {
 	struct callback_head twork;
 	void *shdr;             /* elf_shdr, in case nphdrs > PN_XNUM */
 	char *elf_buf;          /* buffer for elf_hdr + phdrs + notes */
+	struct elf_thread_core_info *tinfo; 
+	struct memelfnote psinfo; 
+	struct memelfnote auxv;
+	struct elf_prpsinfo prpsinfo;
 	size_t elf_buflen;      /* size of elf_buf */
 	size_t nphdrs;          /* number of phdrs */
+	size_t notes_size;
 };
 
+#ifdef CORE_DUMP_USE_REGSET
+#include <linux/regset.h>
+
+static inline int  get_max_regsets(struct task_struct *task)
+{  
+	const struct user_regset_view *view = task_user_regset_view(task);
+	return view->n;
+}
+
+#else
+#define get_max_regsets(task)  3 /* GPR, FP, XFP? */
+#endif
+
 extern ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
 					size_t buflen, loff_t *foffset);
 

