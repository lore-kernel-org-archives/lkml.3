Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3JDKdg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Oct 2013 06:33:36 -0400
Received: from e28smtp04.in.ibm.com ([122.248.162.4]:43689 "EHLO
	e28smtp04.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab3JDKdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Oct 2013 06:33:33 -0400
Subject: [PATCH 19/19] Compat ELF class core generation support
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
Date: Fri, 04 Oct 2013 16:03:22 +0530
Message-ID: <20131004103322.1612.11295.stgit@f19-x64>
In-Reply-To: <20131004102532.1612.24185.stgit@f19-x64>
References: <20131004102532.1612.24185.stgit@f19-x64>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13100410-5564-0000-0000-00000A037291
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From:Suzuki K. Poulose <suzuki@in.ibm.com>

Add full support for the compat ELF class objects. The gencore-compat-elf.c
reuses the gencore-elf.c, by renaming the ABI structures and functions.
(Inspired by compat_binfmt_elf.c)

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
---
 fs/proc/Makefile             |    1 +
 fs/proc/gencore-compat-elf.c |   62 ++++++++++++++++++++++++++++++++++++++++++
 fs/proc/gencore.c            |    4 +++
 fs/proc/gencore.h            |    5 +++
 4 files changed, 72 insertions(+)
 create mode 100644 fs/proc/gencore-compat-elf.c

diff --git a/fs/proc/Makefile b/fs/proc/Makefile
index d231ac3..d8e17f2 100644
--- a/fs/proc/Makefile
+++ b/fs/proc/Makefile
@@ -24,6 +24,7 @@ proc-y	+= softirqs.o
 proc-y	+= namespaces.o
 proc-y	+= self.o
 proc-$(CONFIG_ELF_CORE)        += gencore.o gencore-elf.o
+proc-$(CONFIG_COMPAT_BINFMT_ELF) += gencore-compat-elf.o
 proc-$(CONFIG_PROC_SYSCTL)	+= proc_sysctl.o
 proc-$(CONFIG_NET)		+= proc_net.o
 proc-$(CONFIG_PROC_KCORE)	+= kcore.o
diff --git a/fs/proc/gencore-compat-elf.c b/fs/proc/gencore-compat-elf.c
new file mode 100644
index 0000000..8fd11be
--- /dev/null
+++ b/fs/proc/gencore-compat-elf.c
@@ -0,0 +1,62 @@
+/*
+ * Application core dump - compat ELF Class specific code
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 2111-1307, USA.
+ *
+ * Copyright (C) IBM Corporation, 2010
+ *
+ * We use macros to rename the types and functions in gencore-elf.c o
+ * the compat versions
+ *
+ */
+
+#include <linux/elfcore-compat.h>
+#include "gencore.h"
+
+#undef elfhdr
+#undef elf_phdr
+#undef elf_shdr
+#undef elf_note
+#undef elf_addr_t
+#define elfhdr		elf32_hdr
+#define elf_phdr	elf32_phdr
+#define elf_shdr	elf32_shdr
+#define elf_note	elf32_note
+#define elf_addr_t	Elf32_Addr
+
+#undef ELF_CLASS
+#define ELF_CLASS ELF_CASS32
+
+#define elf_prstatus	compat_elf_prstatus
+#define elf_prpsinfo	compat_elf_prpsinfo
+
+/* Functions used from binfmt_elf core code */
+#define fill_psinfo		compat_fill_psinfo
+#define fill_prstatus		compat_fill_prstatus
+#define fill_extnum_info	compat_fill_extnum_info
+#define fill_auxv_note		compat_fill_auxv_note
+#define fill_elf_header 	compat_fill_elf_header
+
+/*
+ * Define the fileds in elf_thread_core_info and core_proc
+ * for compat ELF class
+ */
+#define et_prstatus	u.compat_prstatus
+#define cp_prpsinfo	u.compat_prpsinfo
+
+/* Rename the core function to compat_ */
+#define elf_read_gencore	compat_elf_read_gencore
+
+#include "gencore-elf.c"
+
diff --git a/fs/proc/gencore.c b/fs/proc/gencore.c
index 3e0db30..92be778 100644
--- a/fs/proc/gencore.c
+++ b/fs/proc/gencore.c
@@ -66,6 +66,10 @@ static ssize_t read_gencore(struct file *file, char __user *buffer,
 
 	if (cp->elf_class == ELF_CLASS_NATIVE)
 		ret = elf_read_gencore(cp, buffer, buflen, fpos);
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+	else if (cp->elf_class == ELF_CLASS_COMPAT)
+		ret = compat_elf_read_gencore(cp, buffer, buflen, fpos);
+#endif
 
 out:
 	put_task_struct(task);
diff --git a/fs/proc/gencore.h b/fs/proc/gencore.h
index 60972a2..840863b 100644
--- a/fs/proc/gencore.h
+++ b/fs/proc/gencore.h
@@ -66,4 +66,9 @@ static inline int  get_max_regsets(struct task_struct *task)
 extern ssize_t elf_read_gencore(struct core_proc *cp, char __user *buffer,
 					size_t buflen, loff_t *foffset);
 
+#ifdef CONFIG_COMPAT_BINFMT_ELF
+extern ssize_t compat_elf_read_gencore(struct core_proc *cp, char __user *buffer,
+					size_t buflen, loff_t *foffset);
+#endif
+
 #endif

