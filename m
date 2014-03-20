Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758099AbaCTJkH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:40:07 -0400
Received: from e23smtp04.au.ibm.com ([202.81.31.146]:50538 "EHLO
	e23smtp04.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbaCTJkB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:40:01 -0400
Subject: [PATCH 06/33] Check ELF class
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
Date: Thu, 20 Mar 2014 15:09:47 +0530
Message-ID: <20140320093947.14878.48540.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-9264-0000-0000-000005AD5B45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The process to be dumped can be either a 32bit application or a 64 bit
application. We first need to check this and proceed with the dump accordingly.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/coredump.c |    5 +++++
 src/coredump.h |    1 +
 src/proc.c     |   45 +++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 51 insertions(+)

diff --git a/src/coredump.c b/src/coredump.c
index 7a559e2..f9c7176 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -188,6 +188,11 @@ int do_coredump(int pid, char *core_file)
 	if (ret)
 		goto cleanup;
 
+	/* Compat Support */
+	cp.elf_class = ret = get_elf_class(pid, &cp);
+	if (ret == -1)
+		goto cleanup;
+
 cleanup:
 
 	/* Release the threads */
diff --git a/src/coredump.h b/src/coredump.h
index 291e13b..25042f5 100644
--- a/src/coredump.h
+++ b/src/coredump.h
@@ -31,4 +31,5 @@ struct core_proc {
 	int *t_id;			/* Threads_ids of all the threads */
 	struct maps *vmas;		/* VMAs */
 	int phdrs_count;		/* Number of Program headers */
+	int elf_class;			/* Elf class of the process */
 };
diff --git a/src/proc.c b/src/proc.c
index a401aa5..3a4a387 100644
--- a/src/proc.c
+++ b/src/proc.c
@@ -27,6 +27,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <coredump.h>
+#include <elf.h>
 
 /* Get Process Stats */
 int get_pid_stat(int pid, struct pid_stat *ps)
@@ -231,3 +232,47 @@ int get_vmas(int pid, struct core_proc *cp)
 	fclose(fin);
 	return 0;
 }
+
+/* Check if its ELF */
+int check_elf_hdr(unsigned char *elf_ident)
+{
+	if (memcmp(elf_ident, ELFMAG, SELFMAG) != 0)
+		return -1;
+
+	return 0;
+}
+
+/* Get ELF Class */
+int get_elf_class(int pid, struct core_proc *cp)
+{
+	FILE *fin;
+	unsigned char elf_magic[EI_NIDENT];
+	char filename[40];
+	int ret;
+
+	snprintf(filename, 40, "/proc/%d/exe", pid);
+	fin = fopen(filename, "r");
+	if (fin == NULL) {
+		status = errno;
+		gencore_log("Failure while fetching the ELF header of the executable from %s.\n", filename);
+		return -1;
+	}
+
+	ret = fread(elf_magic, EI_NIDENT, 1, fin);
+	if (ret != 1) {
+		status = errno;
+		gencore_log("Failure while fetching the ELF header of the executable from %s.\n", filename);
+		fclose(fin);
+		return -1;
+	}
+
+	if (check_elf_hdr(elf_magic)) {
+		status = EINVAL;
+		gencore_log("Process to be dumped is not an ELF.\n");
+		return -1;
+	}
+
+	fclose(fin);
+
+	return elf_magic[EI_CLASS];
+}

