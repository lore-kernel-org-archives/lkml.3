Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758534AbaCTJlO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:41:14 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57746 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758486AbaCTJlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:41:09 -0400
Subject: [PATCH 13/33] Fetching thread specific Notes
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
Date: Thu, 20 Mar 2014 15:11:00 +0530
Message-ID: <20140320094100.14878.41595.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-9574-0000-0000-00000C8888BB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populates prstatus for each and every thread of the task to be dumped by
accessing their respective /proc/tid/stat.

Fetching the required registers based on the architecture. The architectures
that are handled are X86, S390 and PPC.

We fetch the registers in thread-wise order, as some architectures depend on
the ordering of the notes. (e.g, s390)

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.h   |   12 +++
 src/elf-compat.h |   76 +++++++++++++++++++++
 src/elf.c        |  194 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/elf32.c      |    1 
 src/elf64.c      |    1 
 5 files changed, 283 insertions(+), 1 deletion(-)

diff --git a/src/coredump.h b/src/coredump.h
index d5562fe..dce6292 100644
--- a/src/coredump.h
+++ b/src/coredump.h
@@ -5,15 +5,27 @@
 #define PGRP 1			/* Index for process group ID */
 #define SID 2			/* Index for session ID */
 #define FLAG 5			/* Index for flags */
+#define UTIME 10		/* Index for scheduled user mode */
+#define STIME 11		/* Index for scheduled user mode */
+#define CUTIME 12		/* Index for scheduled user mode time for a process's waited-for children */
+#define CSTIME 13		/* Index for scheduled kernel mode time for a process's waited-for children */
 #define NICE 15		/* Index for nice value */
 #define THREAD_COUNT_IDX 16	/* Index for number of threads */
+#define SIGPEND 27		/* Index for pending signals for a process */
+#define SIGHOLD 29		/* Index for ignored signals for a process */
 
 #define __ps_thread_count ps_num[THREAD_COUNT_IDX]	/* Process Information */
 #define __ps_ppid ps_num[PPID]				/* Process PID */	
 #define __ps_pgrp ps_num[PGRP]				/* Process Group ID */ 
 #define __ps_sid ps_num[SID]				/* Process Session ID */
 #define __ps_flag ps_num[FLAG]				/* Process Flags */
+#define __ps_utime ps_num[UTIME]			/* Process scheduled user mode */
+#define __ps_stime ps_num[STIME]			/* Process scheduled user mode */
+#define __ps_cutime ps_num[CUTIME]			/* Process scheduled user mode time for a process's waited-for children */
+#define __ps_cstime ps_num[CSTIME]			/* Process scheduled kernel mode time for a process's waited-for children */
 #define __ps_nice ps_num[NICE]				/* Process Nice Value */
+#define __ps_sigpend ps_num[SIGPEND]			/* Process pending signals */
+#define __ps_sighold ps_num[SIGHOLD]			/* Process ignored signals */
 
 /* Status of the dump */
 extern int status;
diff --git a/src/elf-compat.h b/src/elf-compat.h
index 463070a..6399c11 100644
--- a/src/elf-compat.h
+++ b/src/elf-compat.h
@@ -33,6 +33,17 @@ typedef unsigned short compat_id;
 typedef unsigned short compat_id;
 #endif
 
+struct compat_elf_siginfo {
+	int			si_signo;
+	int			si_code;
+	int			si_errno;
+};
+
+struct compat_timeval {
+	int                             tv_sec;
+	int                             tv_usec;
+};
+
 /* Compat structure for PRPS_INFO */
 struct compat_elf_prpsinfo {
 	char				pr_state;
@@ -46,3 +57,68 @@ struct compat_elf_prpsinfo {
 	char				pr_fname[16];
 	char				pr_psargs[ELF_PRARGSZ];
 };
+
+/* Power PC elf_gregset_t */
+#define ELF_NGREG_PPC       48
+typedef unsigned int elf_greg_t32_ppc;
+typedef elf_greg_t32_ppc elf_gregset_t32_ppc[ELF_NGREG_PPC];
+typedef elf_gregset_t32_ppc compat_elf_gregset_t_ppc;
+
+/* x86 elf_gregset_t */
+struct user_regs_struct32_x86 {
+	unsigned int ebx, ecx, edx, esi, edi, ebp, eax;
+	unsigned short ds, __ds, es, __es;
+	unsigned short fs, __fs, gs, __gs;
+	unsigned int orig_eax, eip;
+	unsigned short cs, __cs;
+	unsigned int eflags, esp;
+	unsigned short ss, __ss;
+};
+typedef struct user_regs_struct32_x86 compat_elf_gregset_t_x86;
+
+/* s390 elf_gregset_t */
+#define NUM_GPRS        16
+#define NUM_ACRS        16
+
+typedef struct {
+	unsigned int mask;
+	unsigned int addr;
+} __attribute__((aligned(8))) psw_compat_t;
+
+typedef struct {
+	psw_compat_t psw;
+	unsigned int gprs[NUM_GPRS];
+	unsigned int acrs[NUM_ACRS];
+	unsigned int orig_gpr2;
+} s390_compat_regs;
+
+typedef s390_compat_regs compat_elf_gregset_t_s390;
+
+#if defined(__PPC64__) || defined(__PPC__)
+#define compat_elf_gregset_t compat_elf_gregset_t_ppc
+#endif
+
+#if defined(__s390x__) || defined(__s390__)
+#define compat_elf_gregset_t compat_elf_gregset_t_s390
+#endif
+
+#if defined(__x86_64) || defined(__i386)
+#define compat_elf_gregset_t compat_elf_gregset_t_x86
+#endif
+
+struct compat_elf_prstatus {
+	struct compat_elf_siginfo	pr_info;
+	short				pr_cursig;
+	unsigned int			pr_sigpend;
+	unsigned int			pr_sighold;
+	int				pr_pid;
+	int				pr_ppid;
+	int				pr_pgrp;
+	int				pr_sid;
+	struct compat_timeval           pr_utime;
+	struct compat_timeval           pr_stime;
+	struct compat_timeval           pr_cutime;
+	struct compat_timeval           pr_cstime;
+	compat_elf_gregset_t		pr_reg;
+	int				pr_fpvalid;
+};
diff --git a/src/elf.c b/src/elf.c
index 9e3623f..62dc5a9 100644
--- a/src/elf.c
+++ b/src/elf.c
@@ -30,6 +30,7 @@
 #include <unistd.h>
 #include <sys/uio.h>
 #include <sys/procfs.h>
+#include <sys/ptrace.h>
 #include <linux/elf.h>
 #include "elf-compat.h"
 #include "coredump.h"
@@ -381,9 +382,195 @@ static int get_file_maps(struct core_proc *cp)
 	return ret;
 }
 
-int do_elf_coredump(int pid, struct core_proc *cp)
+/* Getting Registers */
+static int get_regset(int tid, int regset, struct iovec *iov)
+{
+	return ptrace(PTRACE_GETREGSET, tid, regset, iov);
+}
+
+/* Fetching Note */
+static int fetch_note(int regset, const char *name, struct core_proc *cp, int tid)
+{
+	int ret = 0;
+	int size = PAGESIZE;
+	struct iovec iov;
+	void *data;
+	data = malloc(PAGESIZE);
+	if (!data)
+		return -1;
+
+	/*
+	 * The size of regset being fetched may be greater than size,
+	 * which is initially PAGESIZE. The iov_len gets reset to the
+	 * amount of data read by PTRACE_GETREGSET. If the iov_len is
+	 * equal to size, in that case, there is more data to read and
+	 * hence we increase the size and try reading again. The moment
+	 * iov.len is lesser than size, we break out of the loop as all
+	 * the data is read
+	 */
+	while (1) {
+		iov.iov_base = data;
+		iov.iov_len = size;
+		ret = get_regset(cp->t_id[tid], (unsigned int) regset,
+							&iov);
+		if (ret)
+			break;
+		if (iov.iov_len < size)
+			break;
+		size += PAGESIZE;
+		data = realloc(data, size);
+		if (!data)
+			return -1;
+	}
+
+	/* Adding Note */
+	if (ret == 0)
+		ret = add_note(name, regset, iov.iov_len, data, cp);
+
+	free(data);
+
+	return ret;
+}
+
+/* Populates PRSTATUS for the threads */
+static int fill_core_notes(int tid, struct core_proc *cp)
 {
+	/* PRSTATUS */
+	struct iovec iov;
 	int ret;
+	struct Elf_prstatus prstat;
+	struct pid_stat p;
+	char state;
+
+	ret = get_pid_stat(cp->t_id[tid], &p);
+	if (ret)
+		return -1;
+
+	prstat.pr_pid = p.ps_pid;
+	prstat.pr_ppid = p.__ps_ppid;
+	prstat.pr_pgrp = p.__ps_pgrp;
+	prstat.pr_sid = p.__ps_sid;
+	prstat.pr_utime.tv_sec = p.__ps_utime;
+	prstat.pr_stime.tv_sec = p.__ps_stime;
+	prstat.pr_cutime.tv_sec = p.__ps_cutime;
+	prstat.pr_cstime.tv_sec = p.__ps_cstime;
+	prstat.pr_sigpend = p.__ps_sigpend;
+	prstat.pr_sighold = p.__ps_sighold;
+
+	/* General Purpose registers */
+	iov.iov_base = &prstat.pr_reg;
+	iov.iov_len =  sizeof(prstat.pr_reg);
+	ret = get_regset(cp->t_id[tid], NT_PRSTATUS, &iov);
+	if (ret == -1) {
+		state = get_thread_status(cp->t_id[tid]);
+		if (state != 'Z') {
+			status = errno;
+			gencore_log("Failure in fetching General Purpose registers for Thread:%d.\n", tid);
+			return -1;
+		}
+	}
+
+	prstat.pr_info.si_signo = 0;
+
+	/* FP_REGSET */
+	ret = fetch_note(NT_PRFPREG, "CORE", cp, tid);
+	if ( ret == 0)
+		prstat.pr_fpvalid = 1;
+	else
+		prstat.pr_fpvalid = 0;
+		
+	/* Adding PRSTATUS */
+	return add_note("CORE", NT_PRSTATUS, sizeof(prstat),
+						&prstat, cp);
+}
+
+/* X86 Specific Notes */
+static void fetch_x86_notes(struct core_proc *cp, int tid)
+{
+	int notes[] = {
+			NT_X86_XSTATE,
+			NT_386_TLS,
+			0};
+	int i;
+
+	for (i = 0; notes[i]; i++)
+		(void)fetch_note(notes[i], "LINUX", cp, tid);
+}
+
+/* PPC Specific Notes */
+static void fetch_ppc_notes(struct core_proc *cp, int tid)
+{
+	int notes[] = {
+			NT_PPC_VMX,
+			NT_PPC_SPE,
+			NT_PPC_VSX,
+			0};
+	int i;
+
+	for (i = 0; notes[i]; i++)
+		(void)fetch_note(notes[i], "LINUX", cp, tid);
+}
+
+/* S390 Specific Notes */
+static void fetch_s390_notes(struct core_proc *cp, int tid)
+{
+	int notes[] = {
+			NT_S390_HIGH_GPRS,
+			NT_S390_TIMER,
+			NT_S390_LAST_BREAK,
+			NT_S390_SYSTEM_CALL,
+			NT_S390_TODCMP,
+			NT_S390_TODPREG,
+			NT_S390_CTRS,
+			NT_S390_PREFIX,
+			0};
+	int i;
+
+	for (i = 0; notes[i]; i++)
+		(void)fetch_note(notes[i], "LINUX", cp, tid);
+}
+
+/* Fetching thread specific notes */
+static int fetch_thread_notes(struct core_proc *cp)
+{
+	int tid, ret;
+
+	Elf_Ehdr *cp_elf;
+	cp_elf = (Elf_Ehdr *)cp->elf_hdr;
+
+	/*
+	 * The architecture specific notes are optional and they may or may not
+	 * be present. Hence we do not check if we were successful in fetching
+	 * them or not.
+	 */
+
+	for (tid = 0; tid < cp->thread_count; tid++) {
+		ret = fill_core_notes(tid, cp);
+		if (ret)
+			return -1;
+
+		switch (cp_elf->e_machine) {
+		case EM_X86_64:
+		case EM_386:
+			fetch_x86_notes(cp, tid);
+			break;
+		case EM_PPC:
+		case EM_PPC64:
+			fetch_ppc_notes(cp, tid);
+			break;
+		case EM_S390:
+			fetch_s390_notes(cp, tid);
+			break;
+		}
+
+	}
+
+	return 0;
+}
+
+int do_elf_coredump(int pid, struct core_proc *cp)
+{
+	int ret, i;
 
 	/* Fill ELF Header */
 	ret = fill_elf_header(pid, cp);
@@ -405,5 +592,10 @@ int do_elf_coredump(int pid, struct core_proc *cp)
 	if (ret)
 		return -1;
 
+	/* Get the thread specific notes */
+	ret = fetch_thread_notes(cp);
+	if (ret)
+		return -1;
+
 	return 0;
 }
diff --git a/src/elf32.c b/src/elf32.c
index 0f7c03d..8ec287b 100644
--- a/src/elf32.c
+++ b/src/elf32.c
@@ -36,5 +36,6 @@
 #define Elf_Nhdr Elf32_Nhdr
 #define Elf_prpsinfo compat_elf_prpsinfo
 #define Elf_Long int
+#define Elf_prstatus compat_elf_prstatus
 
 #include "elf.c"
diff --git a/src/elf64.c b/src/elf64.c
index 77da222..780e2d4 100644
--- a/src/elf64.c
+++ b/src/elf64.c
@@ -36,5 +36,6 @@
 #define Elf_Nhdr Elf64_Nhdr
 #define Elf_prpsinfo elf_prpsinfo
 #define Elf_Long long
+#define Elf_prstatus elf_prstatus
 
 #include "elf.c"

