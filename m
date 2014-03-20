Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758410AbaCTJkx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:40:53 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55484 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758135AbaCTJkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:40:47 -0400
Subject: [PATCH 10/33] Populates PRPS info
To: linux-kernel@vger.kernel.org
From: Janani Venkataraman <jananive@linux.vnet.ibm.com>
Cc: amwang@redhat.com, procps@freelists.org, rdunlap@xenotime.net,
        james.hogan@imgtec.com, aravinda@linux.vnet.ibm.com, hch@lst.de,
        mhiramat@redhat.com, jeremy.fitzhardinge@citrix.com,
        xemul@parallels.com, d.hatayama@jp.fujitsu.com, coreutils@gnu.org,
        kosaki.motohiro@jp.fujitsu.com, adobriyan@gmail.com,
        util-linux@vger.kernel.org, tarundsk@linux.vnet.ibm.com,
        vapier@gentoo.org, roland@hack.frob.com, ananth@linux.vnet.ibm.com,
        gorcunov@openvz.org, avagin@openvz.org, oleg@redhat.com,
        eparis@redhat.com, suzuki@linux.vnet.ibm.com, andi@firstfloor.org,
        tj@kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Date: Thu, 20 Mar 2014 15:10:32 +0530
Message-ID: <20140320094032.14878.79807.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-3568-0000-0000-00000520E636
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populates the prps_info by reading /proc/pid/stat and /proc/pid/cmdline.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.h   |   10 +++++++++
 src/elf-compat.h |   48 +++++++++++++++++++++++++++++++++++++++++++++
 src/elf.c        |   58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/elf32.c      |    1 +
 src/elf64.c      |    1 +
 5 files changed, 118 insertions(+)
 create mode 100644 src/elf-compat.h

diff --git a/src/coredump.h b/src/coredump.h
index 9b19f19..d5562fe 100644
--- a/src/coredump.h
+++ b/src/coredump.h
@@ -1,9 +1,19 @@
 #define COMM_LEN 17            /* Maximum length of command line */
 #define NUM_STAT_FEILDS 30     /* Number of fields read from /proc/pid/stat */
 
+#define PPID 0			/* Index for parent process ID */
+#define PGRP 1			/* Index for process group ID */
+#define SID 2			/* Index for session ID */
+#define FLAG 5			/* Index for flags */
+#define NICE 15		/* Index for nice value */
 #define THREAD_COUNT_IDX 16	/* Index for number of threads */
 
 #define __ps_thread_count ps_num[THREAD_COUNT_IDX]	/* Process Information */
+#define __ps_ppid ps_num[PPID]				/* Process PID */	
+#define __ps_pgrp ps_num[PGRP]				/* Process Group ID */ 
+#define __ps_sid ps_num[SID]				/* Process Session ID */
+#define __ps_flag ps_num[FLAG]				/* Process Flags */
+#define __ps_nice ps_num[NICE]				/* Process Nice Value */
 
 /* Status of the dump */
 extern int status;
diff --git a/src/elf-compat.h b/src/elf-compat.h
new file mode 100644
index 0000000..463070a
--- /dev/null
+++ b/src/elf-compat.h
@@ -0,0 +1,48 @@
+/*
+ * ELF structures for gencore
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
+ * Copyright (C) IBM Corporation, 2013
+ *
+ * Authors:
+ *      Janani Venkataraman <jananve@in.ibm.com>
+ */
+
+#if defined(__PPC64__) || defined(__PPC__)
+typedef unsigned int compat_id;
+#endif
+
+#if defined(__s390x__) || defined(__s390__)
+typedef unsigned short compat_id;
+#endif
+
+#if defined(__x86_64) || defined(__i386)
+typedef unsigned short compat_id;
+#endif
+
+/* Compat structure for PRPS_INFO */
+struct compat_elf_prpsinfo {
+	char				pr_state;
+	char				pr_sname;
+	char				pr_zomb;
+	char				pr_nice;
+	unsigned int			pr_flag;
+	compat_id			pr_uid;
+	compat_id			pr_gid;
+	int				pr_pid, pr_ppid, pr_pgrp, pr_sid;
+	char				pr_fname[16];
+	char				pr_psargs[ELF_PRARGSZ];
+};
diff --git a/src/elf.c b/src/elf.c
index dfcb1d7..18bbeeb 100644
--- a/src/elf.c
+++ b/src/elf.c
@@ -27,7 +27,9 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/uio.h>
+#include <sys/procfs.h>
 #include <linux/elf.h>
+#include "elf-compat.h"
 #include "coredump.h"
 
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
@@ -187,6 +189,57 @@ static int fill_elf_header(int pid, struct core_proc *cp)
 	return 0;
 }
 
+/* Populates PRPS_INFO */
+static int get_prpsinfo(int pid, struct core_proc *cp)
+{
+	char filename[40];
+	int ret;
+	FILE *fin;
+	struct Elf_prpsinfo prps;
+	struct pid_stat p;
+
+	ret = get_pid_stat(pid, &p);
+	if (ret)
+		return -1;
+
+	prps.pr_pid = p.ps_pid;
+	strcpy(prps.pr_fname, p.ps_comm);
+	prps.pr_state = p.ps_state;
+	prps.pr_ppid = p.__ps_ppid;
+	prps.pr_pgrp = p.__ps_pgrp;
+	prps.pr_sid = p.__ps_sid;
+	prps.pr_flag = p.__ps_flag;
+	prps.pr_nice = p.__ps_nice;
+
+	prps.pr_sname = prps.pr_state;
+	if (prps.pr_sname == 'z')
+		prps.pr_zomb = 1;
+	else
+		prps.pr_zomb = 0;
+
+	snprintf(filename, 40, "/proc/%d/cmdline", pid);
+	fin = fopen(filename, "r");
+	if (fin == NULL) {
+		status = errno;
+		gencore_log("Failure while fetching command line arguments from %s.\n", filename);
+		return -1;
+	}
+
+	/* Getting CMDLINE arguments */
+	ret = fread(prps.pr_psargs, ELF_PRARGSZ, 1, fin);
+	if (ret == -1) {
+		status = errno;
+		gencore_log("Failure while fetching command line arguments from %s.\n", filename);
+		fclose(fin);
+		return -1;
+	}
+
+	fclose(fin);
+
+	/* Adding PRPSINFO */
+	return add_note("CORE", NT_PRPSINFO, sizeof(prps), &prps, cp);
+}
+
 int do_elf_coredump(int pid, struct core_proc *cp)
 {
 	int ret;
@@ -196,5 +249,10 @@ int do_elf_coredump(int pid, struct core_proc *cp)
 	if (ret)
 		return -1;
 
+	/* Get prps_info */
+	ret = get_prpsinfo(pid, cp);
+	if (ret)
+		return -1;
+
 	return 0;
 }
diff --git a/src/elf32.c b/src/elf32.c
index 01b3923..8778bed 100644
--- a/src/elf32.c
+++ b/src/elf32.c
@@ -34,5 +34,6 @@
 #define Elf_Phdr Elf32_Phdr
 #define Elf_Shdr Elf32_Shdr
 #define Elf_Nhdr Elf32_Nhdr
+#define Elf_prpsinfo compat_elf_prpsinfo
 
 #include "elf.c"
diff --git a/src/elf64.c b/src/elf64.c
index a99a73b..d062888 100644
--- a/src/elf64.c
+++ b/src/elf64.c
@@ -34,5 +34,6 @@
 #define Elf_Phdr Elf64_Phdr
 #define Elf_Shdr Elf64_Shdr
 #define Elf_Nhdr Elf64_Nhdr
+#define Elf_prpsinfo elf_prpsinfo
 
 #include "elf.c"

