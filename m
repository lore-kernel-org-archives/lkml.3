Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3JDKc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:32:26 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:47480 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752487Ab3JDKcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:32:21 -0400
Subject: [PATCH 13/19] Create ELF Header
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
Date: Fri, 04 Oct 2013 16:02:08 +0530
Message-ID: <20131004103208.1612.36010.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-6102-0000-0000-00000447AAD0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Build the ELF header on the fly for the very first read request. The ELF Header,
Program Headers are stored in a buffer for processing future read() requests.

gencore-elf.c contains the ELF class specific functions.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Ananth N.Mavinakayanahalli <ananth@in.ibm.com>
---
 fs/proc/Makefile      |    2 -
 fs/proc/gencore-elf.c |  181 +++++++++++++++++++++++++++++++++++++++++++++++++
 fs/proc/gencore.h     |    7 ++
 3 files changed, 189 insertions(+), 1 deletion(-)
 create mode 100644 fs/proc/gencore-elf.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index a456c22..d231ac3 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -23,7 +23,7 @@ proc-y	+= version.o
 proc-y	+= softirqs.o
 proc-y	+= namespaces.o
 proc-y	+= self.o
-proc-$(CONFIG_ELF_CORE)        += gencore.o
+proc-$(CONFIG_ELF_CORE)        += gencore.o gencore-elf.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
diff --git a/fs/proc/gencore-elf.c b/fs/proc/gencore-elf.c
new file mode 100644
index 0000000..0a245f0
--- /dev/null
+++ b/fs/proc/gencore-elf.c
@@ -0,0 +1,181 @@
+/*
+ * Application core dump - ELF Class specific code
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2010
+ *
+ * Authors:
+ * 	Suzuki K. Poulose <suzuki@in.ibm.com> 
+ */
+
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <linux/freezer.h>
+#include <linux/elf.h>
+#include <linux/elfcore.h>
+#include <linux/elfcore-internal.h>
+
+#ifdef CORE_DUMP_USE_REGSET
+#include <linux/regset.h>
+#endif
+
+#include "gencore.h"
+
+static void get_elfhdr_size(struct core_proc *cp)
+{
+	struct vm_area_struct *gate_vma;
+	int segs;
+
+	segs = cp->task->mm->map_count;
+	segs += elf_core_extra_phdrs();
+
+	gate_vma = get_gate_vma(cp->task->mm);
+	if (gate_vma != NULL)
+		segs++;
+
+	/* One phdr for PT_NOTE */
+	segs++;
+
+	cp->nphdrs = segs;
+	cp->elf_buflen = sizeof(struct elfhdr) +
+			(cp->nphdrs * sizeof(struct elf_phdr));
+	cp->elf_buflen = roundup(cp->elf_buflen, ELF_EXEC_PAGESIZE);
+
+	return;
+}
+
+/*
+ * Fill the elf_hdr and the phdrs
+ * Returns 0 on success. On error, returns errno
+ */
+static int create_elf_header(struct core_proc *cp)
+{
+	struct elfhdr *elf = (struct elfhdr *)cp->elf_buf;
+	struct elf_phdr *note;
+	struct vm_area_struct *vma, *gate_vma = get_gate_vma(cp->task->mm);
+	char *bufp;
+	off_t dataoff, offset;
+	short e_phnum = (cp->nphdrs > PN_XNUM ? PN_XNUM : cp->nphdrs);
+	size_t exphdrs_sz = 0;
+	unsigned long limit = elf_core_extra_phdrs() * sizeof(struct elf_phdr);
+
+#ifdef CORE_DUMP_USE_REGSET
+	const struct user_regset_view *view = task_user_regset_view(cp->task);
+
+	fill_elf_header(elf, e_phnum, view->e_machine, view->e_flags);
+#else
+	fill_elf_header(elf, e_phnum, ELF_ARCH, ELF_CORE_EFLAGS);
+#endif
+	offset = sizeof(struct elfhdr);
+ 	bufp = cp->elf_buf + offset;
+	dataoff = offset + (cp->nphdrs * sizeof(struct elf_phdr));
+
+	/* Setup ELF PT_NOTE */
+	note = (struct elf_phdr*)bufp;
+	bufp += sizeof(struct elf_phdr);
+	offset += sizeof(struct elf_phdr);
+	note->p_type = PT_NOTE;
+	note->p_offset = dataoff;
+	note->p_vaddr = 0;
+	note->p_paddr = 0;
+	/* TODO: Needs to be populated with the size of the notes section */
+	note->p_memsz = 0;
+	note->p_flags = 0;
+	note->p_align = 0;
+
+	dataoff = cp->elf_buflen;
+
+	/* Write the phdrs for memory segments */
+	down_read(&cp->task->mm->mmap_sem);
+	for (vma = first_vma(cp->task, gate_vma); vma != NULL;
+			vma = next_vma(vma, gate_vma)) {
+		struct elf_phdr *phdr = (struct elf_phdr  *)bufp;
+
+		bufp += sizeof(struct elf_phdr);
+		offset += sizeof(struct elf_phdr);
+
+		phdr->p_type = PT_LOAD;
+		phdr->p_offset = dataoff;
+		phdr->p_vaddr = vma->vm_start;
+		phdr->p_paddr = 0;
+		phdr->p_filesz = vma_dump_size(cp->task, vma, cp->task->mm->flags);
+		phdr->p_memsz = vma->vm_end - vma->vm_start;
+		phdr->p_flags = (vma->vm_flags & VM_READ) ? PF_R : 0;
+		if (vma->vm_flags & VM_WRITE)
+			phdr->p_flags |= PF_W;
+		if (vma->vm_flags & VM_EXEC)
+			phdr->p_flags |= PF_X;
+		phdr->p_align = ELF_EXEC_PAGESIZE;
+		if (!(phdr->p_flags & (PF_R | PF_W | PF_X)))
+			phdr->p_filesz=0;
+		dataoff += phdr->p_filesz;
+	}
+	up_read(&cp->task->mm->mmap_sem);
+
+	if (!elf_core_copy_extra_phdrs(bufp, dataoff, &exphdrs_sz, limit))
+		return -EIO;
+	bufp += exphdrs_sz;
+	dataoff += elf_core_extra_data_size();
+
+	if (e_phnum == PN_XNUM) {
+		cp->shdr = kzalloc(sizeof(struct elf_shdr), GFP_KERNEL);
+		if (!cp->shdr)
+			return -ENOMEM;
+		fill_extnum_info(elf, (struct elf_shdr *)cp->shdr,
+						dataoff, cp->nphdrs);
+		dataoff += sizeof(struct elf_shdr);
+	}
+
+	return 0;
+}
+
+ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
+				size_t buflen, loff_t *fpos)
+{
+	ssize_t ret = 0;
+
+	if (!cp->elf_buf) {
+		get_elfhdr_size(cp);
+
+		cp->elf_buf = kzalloc(cp->elf_buflen, GFP_KERNEL);
+		if (!cp->elf_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		ret = create_elf_header(cp);
+		if (ret < 0)
+			goto out;
+	}
+
+	if (*fpos < cp->elf_buflen) {
+		size_t bcp = cp->elf_buflen - *fpos;
+
+		bcp = (bcp < buflen) ? bcp : buflen;
+		if (copy_to_user(buffer, (cp->elf_buf + *fpos), bcp)) {
+			ret = -EFAULT;
+			goto out;
+		} else {
+			ret = bcp;
+			*fpos += bcp;
+			buflen -= bcp;
+			buffer += bcp;
+		}
+	}
+out:
+	return ret;
+}
+
diff --git a/fs/proc/gencore.h b/fs/proc/gencore.h
index 1a88e24..6c1d57c 100644
--- a/fs/proc/gencore.h
+++ b/fs/proc/gencore.h
@@ -11,6 +11,13 @@ struct core_proc {
 	struct task_struct *task;
 	struct completion hold;
 	struct callback_head twork;
+	void *shdr;             /* elf_shdr, in case nphdrs > PN_XNUM */
+	char *elf_buf;          /* buffer for elf_hdr + phdrs + notes */
+	size_t elf_buflen;      /* size of elf_buf */
+	size_t nphdrs;          /* number of phdrs */
 };
 
+extern ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
+					size_t buflen, loff_t *foffset);
+
 #endif

