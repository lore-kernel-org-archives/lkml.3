Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758307AbaCTJk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:40:28 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:48659 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992AbaCTJkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:40:23 -0400
Subject: [PATCH 08/33] Fills elf header
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
Date: Thu, 20 Mar 2014 15:10:09 +0530
Message-ID: <20140320094009.14878.56164.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-7014-0000-0000-0000048ABA97
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populates the ELF header. It fills the magic number, version, machine number of
program headers and other members of the ELF_HEADER.

All the information is derived from the ELF_HEADER of the exe of the process to
be dumped through /proc/pid/exe.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |    3 ++
 src/coredump.h |    1 +
 src/elf.c      |   96 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 src/elf32.c    |    4 ++
 src/elf64.c    |    4 ++
 5 files changed, 108 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index b1ee99d..de0a7ce 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -213,6 +213,9 @@ cleanup:
 	if (cp.vmas)
 		free_maps(cp.vmas);
 
+	if (cp.elf_hdr)
+		free(cp.elf_hdr);
+
 	errno = status;
 
 	return ret;
diff --git a/src/coredump.h b/src/coredump.h
index 25042f5..4e508c1 100644
--- a/src/coredump.h
+++ b/src/coredump.h
@@ -32,4 +32,5 @@ struct core_proc {
 	struct maps *vmas;		/* VMAs */
 	int phdrs_count;		/* Number of Program headers */
 	int elf_class;			/* Elf class of the process */
+	void *elf_hdr;			/* Stores the ELF_header */
 };
diff --git a/src/elf.c b/src/elf.c
index 280df13..9f65c77 100644
--- a/src/elf.c
+++ b/src/elf.c
@@ -22,10 +22,106 @@
  *      Suzuki K. Poulose <suzuki@in.ibm.com>
  */
 
+#include <errno.h>
 #include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/uio.h>
+#include <linux/elf.h>
 #include "coredump.h"
 
+/* Fetchs ELF header of the executable */
+static int get_elf_hdr_exe_file(int pid, Elf_Ehdr *elf)
+{
+	char filename[40];
+	int ret;
+	FILE *fin;
+
+	snprintf(filename, 40, "/proc/%d/exe", pid);
+	fin = fopen(filename, "r");
+	if (fin == NULL) {
+		status = errno;
+		gencore_log("Failed to open %s for checking the ELF header.",
+								filename);
+		return -1;
+	}
+
+	ret = fread(elf, sizeof(*elf), 1, fin);
+	if (ret != 1) {
+		status = errno;
+		gencore_log("Failure while fetching the ELF header of the executable from %s.\n", filename);
+		fclose(fin);
+		return -1;
+	}
+
+	fclose(fin);
+
+	return 0;
+}
+
+/* Fills the ELF HEADER */
+static int fill_elf_header(int pid, struct core_proc *cp)
+{
+	Elf_Ehdr elf, *cp_elf;
+	int ret;
+
+	cp->elf_hdr = malloc(sizeof(Elf_Ehdr));
+	if (!cp->elf_hdr) {
+		status = errno;
+		gencore_log("Failure in allocating memory for ELF header.\n");
+		return -1;
+	}
+
+	cp_elf = (Elf_Ehdr *)cp->elf_hdr;
+
+	memset(cp_elf, 0, EI_NIDENT);
+
+	ret = get_elf_hdr_exe_file(pid, &elf);
+	if (ret == -1)
+		return -1;
+
+	/* Magic Number */
+	memcpy(cp_elf->e_ident, ELFMAG, SELFMAG);
+
+	cp_elf->e_ident[EI_CLASS] = elf.e_ident[EI_CLASS];
+	cp_elf->e_ident[EI_DATA] = elf.e_ident[EI_DATA];
+	cp_elf->e_ident[EI_VERSION] = EV_CURRENT;
+	cp_elf->e_ident[EI_OSABI] = EI_OSABI;
+
+	/* Rest of the fields */
+	cp_elf->e_entry = 0;
+	cp_elf->e_type = ET_CORE;
+	cp_elf->e_machine = elf.e_machine;
+	cp_elf->e_version = EV_CURRENT;
+	cp_elf->e_phoff = sizeof(Elf_Ehdr);
+	cp_elf->e_shoff = 0;
+	cp_elf->e_flags = 0;
+	cp_elf->e_ehsize =  sizeof(Elf_Ehdr);
+	cp_elf->e_phentsize = sizeof(Elf_Phdr);
+
+	if (cp->phdrs_count > PN_XNUM) {
+		cp_elf->e_phnum = PN_XNUM;
+		cp_elf->e_shentsize = sizeof(Elf_Shdr);
+		cp_elf->e_shnum = 1;
+	} else {
+		cp_elf->e_phnum = cp->phdrs_count;
+		cp_elf->e_shentsize = 0;
+		cp_elf->e_shnum = 0;
+	}
+
+	cp_elf->e_shstrndx = SHN_UNDEF;
+
+	return 0;
+}
+
 int do_elf_coredump(int pid, struct core_proc *cp)
 {
+	int ret;
+
+	/* Fill ELF Header */
+	ret = fill_elf_header(pid, cp);
+	if (ret)
+		return -1;
+
 	return 0;
 }
diff --git a/src/elf32.c b/src/elf32.c
index d6b40b4..1a95ff2 100644
--- a/src/elf32.c
+++ b/src/elf32.c
@@ -30,4 +30,8 @@
 
 #define do_elf_coredump do_elf32_coredump
 
+#define Elf_Ehdr Elf32_Ehdr
+#define Elf_Phdr Elf32_Phdr
+#define Elf_Shdr Elf32_Shdr
+
 #include "elf.c"
diff --git a/src/elf64.c b/src/elf64.c
index d8b5e89..953b826 100644
--- a/src/elf64.c
+++ b/src/elf64.c
@@ -30,4 +30,8 @@
 
 #define do_elf_coredump do_elf64_coredump
 
+#define Elf_Ehdr Elf64_Ehdr
+#define Elf_Phdr Elf64_Phdr
+#define Elf_Shdr Elf64_Shdr
+
 #include "elf.c"

