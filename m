Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758471AbaCTJlB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:41:01 -0400
Received: from e28smtp07.in.ibm.com ([122.248.162.7]:54894 "EHLO
	e28smtp07.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758435AbaCTJk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:40:58 -0400
Subject: [PATCH 11/33] Populate AUXV
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
Date: Thu, 20 Mar 2014 15:10:43 +0530
Message-ID: <20140320094043.14878.87687.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-8878-0000-0000-00000B6921B1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Populate the auxillary vector using /proc/pid/auxv.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/elf.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 73 insertions(+)

diff --git a/src/elf.c b/src/elf.c
index 18bbeeb..b7fd6d0 100644
--- a/src/elf.c
+++ b/src/elf.c
@@ -26,12 +26,16 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
+#include <fcntl.h>
+#include <unistd.h>
 #include <sys/uio.h>
 #include <sys/procfs.h>
 #include <linux/elf.h>
 #include "elf-compat.h"
 #include "coredump.h"
 
+#define PAGESIZE getpagesize()
+
 #define roundup(x, y) ((((x) + ((y) - 1)) / (y)) * (y))
 
 /* Appending the note to the list */
@@ -240,6 +244,70 @@ static int get_prpsinfo(int pid, struct core_proc *cp)
 	return add_note("CORE", NT_PRPSINFO, sizeof(prps), &prps, cp);
 }
 
+/* Populate auxillary vector */
+static int get_auxv(int pid, struct core_proc *cp)
+{
+	unsigned char buff[PAGESIZE];
+	char filename[40];
+	int ret, fd, pages;
+	unsigned char *ptr, *auxv;
+	unsigned int auxv_size;
+
+	snprintf(filename, 40, "/proc/%d/auxv", pid);
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0) {
+		status = errno;
+		gencore_log("Failure while fetching auxv data from %s.\n",
+								filename);
+		return -1;
+	}
+
+	auxv = malloc(PAGESIZE);
+	if (!auxv) {
+		status = errno;
+		gencore_log("Could not allocate memory for the auxv_buffer.\n");
+		close(fd);
+		return -1;
+	}
+	/* Position to copy the auxv data */
+	ptr = auxv;
+	pages = 1;
+	/*
+	 * We read the auxv data page by page and also we don't not
+	 * know the size of auxv, hence we read till ret becomes
+	 * lesser than PAGESIZE.
+	 */
+	while ((ret = read(fd, buff, PAGESIZE)) > 0) {
+		memcpy(ptr, buff, ret);
+		if (ret < PAGESIZE)   /* Finished reading */
+			break;
+		else {
+			/* We have more data to read */
+			pages++;
+			auxv = realloc(auxv, pages * PAGESIZE);
+			ptr = auxv + ((pages - 1) * PAGESIZE);
+		}
+	}
+	if (ret >= 0)
+		auxv_size = ((pages - 1) * PAGESIZE) + ret;
+	else {
+		status = errno;
+		gencore_log("Failure while fetching auxv data from %s.\n", filename);
+		close(fd);
+		free(auxv);
+		return -1;
+	}
+
+	/* Adding AUXV */
+	ret = add_note("CORE", NT_AUXV, auxv_size, auxv, cp);
+
+	close(fd);
+	free(auxv);
+
+	return ret;
+}
+
 int do_elf_coredump(int pid, struct core_proc *cp)
 {
 	int ret;
@@ -254,5 +322,10 @@ int do_elf_coredump(int pid, struct core_proc *cp)
 	if (ret)
 		return -1;
 
+	/* Get Auxillary Vector */
+	ret = get_auxv(pid, cp);
+	if (ret)
+		return -1;
+
 	return 0;
 }

