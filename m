Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbaCTJji (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:39:38 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:47619 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821AbaCTJje (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:39:34 -0400
Subject: [PATCH 03/33] Process Status
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
Date: Thu, 20 Mar 2014 15:09:25 +0530
Message-ID: <20140320093925.14878.81715.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-5816-0000-0000-00000CF3D632
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fetch the process status from /proc/pid/stat as it will be required for the dump.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/Makefile.am |    2 +
 src/coredump.c  |    4 +++
 src/coredump.h  |   13 ++++++++
 src/proc.c      |   86 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 104 insertions(+), 1 deletion(-)
 create mode 100644 src/coredump.h
 create mode 100644 src/proc.c

diff --git a/src/Makefile.am b/src/Makefile.am
index f7b25fa..9e5d3c0 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -3,5 +3,5 @@ HAVE_SYSTEMD_SOCKET_SUPPORT = 0
 CFLAGS += -I. -DHAVE_SYSTEMD_SOCKET_SUPPORT='$(HAVE_SYSTEMD_SOCKET_SUPPORT)'
 
 bin_PROGRAMS = gencore
-gencore_SOURCES = coredump.c
+gencore_SOURCES = coredump.c proc.c
 
diff --git a/src/coredump.c b/src/coredump.c
index 7a7fe11..ad9ee7d 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -26,10 +26,14 @@
 #include <stdio.h>
 #include <string.h>
 #include <stdlib.h>
+#include <coredump.h>
 
 /* For logging all the messages */
 FILE *fp_log;
 
+/* Status of the dump */
+int status;
+
 /* Logging messages */
 void gencore_log(char *fmt, ...)
 {
diff --git a/src/coredump.h b/src/coredump.h
new file mode 100644
index 0000000..cc77197
--- /dev/null
+++ b/src/coredump.h
@@ -0,0 +1,13 @@
+#define COMM_LEN 17            /* Maximum length of command line */
+#define NUM_STAT_FEILDS 30     /* Number of fields read from /proc/pid/stat */
+
+/* Status of the dump */
+extern int status;
+
+/* Structure for Status of process */
+struct pid_stat {
+	int ps_pid;
+	char ps_comm[COMM_LEN];
+	char ps_state;
+	unsigned long long ps_num[NUM_STAT_FEILDS];
+};
diff --git a/src/proc.c b/src/proc.c
new file mode 100644
index 0000000..6c9e804
--- /dev/null
+++ b/src/proc.c
@@ -0,0 +1,86 @@
+/*
+ * /proc/ helper routines for gencore
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
+ *      Suzuki K. Poulose <suzuki@in.ibm.com>
+ */
+
+#include <stdio.h>
+#include <errno.h>
+#include <coredump.h>
+
+/* Get Process Stats */
+int get_pid_stat(int pid, struct pid_stat *ps)
+{
+	int ret = -1, i;
+	char junk;
+	char filename[40];
+	FILE *fin;
+
+	snprintf(filename, 40, "/proc/%d/stat", pid);
+	fin = fopen(filename, "r");
+	if (fin == NULL) {
+		status = errno;
+		gencore_log("Failure while fetching thread status from %s.\n",
+								filename);
+		return -1;
+	}
+
+	/* Read pid */
+	fscanf(fin, "%d", &ps->ps_pid);
+
+	/* Skip till '(' */
+	while (fscanf(fin, "%c", &junk) != EOF && junk != '(');
+	if (junk != '(')  {
+		status = errno;
+		gencore_log("Failure while fetching thread status from %s.\n",
+								filename);
+		goto err;
+	}
+
+	/* Read Command Line */
+	fscanf(fin, "%[^)]", ps->ps_comm);
+
+	/* Skip the ')' */
+	while (fscanf(fin, "%c", &junk) != EOF && junk != ')');
+	if (junk != ')')  {
+		status = errno;
+		gencore_log("Failure while fetching thread status from %s.\n",
+								filename);
+		goto err;
+	}
+
+	/* Reading the space */
+	fscanf(fin, "%c", &junk);
+
+	/* State */
+	fscanf(fin, "%c", &ps->ps_state);
+
+	/* Read the rest of the fields */
+	for (i = 0; i < NUM_STAT_FEILDS &&
+			(fscanf(fin, "%lld", &ps->ps_num[i]) != EOF); i++);
+
+	if (i == NUM_STAT_FEILDS)
+		ret = 0;
+
+err:
+	fclose(fin);
+	return ret;
+}

