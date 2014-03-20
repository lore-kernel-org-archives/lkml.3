Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757802AbaCTJjb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:39:31 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:46543 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757349AbaCTJj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:39:28 -0400
Subject: [PATCH 02/33] Validity of arguments
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
Date: Thu, 20 Mar 2014 15:09:20 +0530
Message-ID: <20140320093920.14878.52834.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-2000-0000-0000-00001044DA0E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The validity of the arguments passed to the program are checked. PID is a
mandatory argument. The core file name is optional, if not specified the
default file name is core.pid.

If a self dump is requested then, the application is called with a --daemon
option or the --socket option.

If the SYSTEMD_SOCKET_OPTION is enabled, then the socket option will be fully
functional. The system where the program is run needs to have sd-daemon.h. For
this we need to have the correct version of systemd which has this socket
option enabled.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 Makefile.am     |    2 +
 configure.ac    |    2 +
 src/Makefile.am |    7 ++++
 src/coredump.c  |  104 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 113 insertions(+), 2 deletions(-)
 create mode 100644 src/Makefile.am
 create mode 100644 src/coredump.c

diff --git a/Makefile.am b/Makefile.am
index 2cc6dc7..dfa49b2 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,2 +1,2 @@
 AUTOMAKE_OPTIONS = foreign
-SUBDIRS =
+SUBDIRS = src
diff --git a/configure.ac b/configure.ac
index f34a0c3..8c785cd 100644
--- a/configure.ac
+++ b/configure.ac
@@ -4,4 +4,4 @@ AM_INIT_AUTOMAKE([-Wall -Werror foreign])
 AC_CONFIG_HEADERS([config.h])
 AC_PROG_CC
 AC_CONFIG_FILES(Makefile)
-AC_OUTPUT()
+AC_OUTPUT(src/Makefile)
diff --git a/src/Makefile.am b/src/Makefile.am
new file mode 100644
index 0000000..f7b25fa
--- /dev/null
+++ b/src/Makefile.am
@@ -0,0 +1,7 @@
+AUTOMAKE_OPTIONS = foreign
+HAVE_SYSTEMD_SOCKET_SUPPORT = 0
+CFLAGS += -I. -DHAVE_SYSTEMD_SOCKET_SUPPORT='$(HAVE_SYSTEMD_SOCKET_SUPPORT)'
+
+bin_PROGRAMS = gencore
+gencore_SOURCES = coredump.c
+
diff --git a/src/coredump.c b/src/coredump.c
new file mode 100644
index 0000000..7a7fe11
--- /dev/null
+++ b/src/coredump.c
@@ -0,0 +1,104 @@
+/*
+ * Initiates the core-dump
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
+ * Copyright (C) IBM Corporation, 2013, 2014
+ *
+ * Authors:
+ *      Janani Venkataraman <jananve@in.ibm.com>
+ *      Suzuki K. Poulose <suzuki@in.ibm.com>
+ */
+
+#include <stdarg.h>
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+
+/* For logging all the messages */
+FILE *fp_log;
+
+/* Logging messages */
+void gencore_log(char *fmt, ...)
+{
+	va_list argptr;
+	va_start(argptr, fmt);
+	vfprintf(fp_log, fmt, argptr);
+	va_end(argptr);
+}
+
+/* Performs the core dump */
+int do_coredump(int pid, char *core_file)
+{
+	return 0;
+}
+
+/* Daemon for self dump */
+int daemon_dump(void)
+{
+	return 0;
+}
+
+#if HAVE_SYSTEMD_SOCKET_SUPPORT
+/* Systemd socket for self dump */
+int socket_dump(void)
+{
+	return 0;
+}
+#endif
+
+int main(int argc, char *argv[])
+{
+	int ret;
+	int pid;
+	char core_file[15];
+
+	if (argc < 2 || argc > 3) {
+		fprintf(stderr, "Invalid number of arguments.\n\n");
+		fprintf(stderr, "Usage: %s pid [output-file-name]\n", argv[0]);
+		return -1;
+	}
+
+	if (strcmp(argv[1], "--daemon") == 0)
+		ret = daemon_dump();
+#if HAVE_SYSTEMD_SOCKET_SUPPORT
+	else if (strcmp(argv[1], "--socket") == 0) {
+		fp_log = stderr;
+		ret = socket_dump();
+	}
+#endif
+	else if (strcmp(argv[1], "--help") == 0) {
+		printf("Usage: %s pid [output-file-name]\n", argv[0]);
+		return -1;
+	} else {
+		fp_log = stderr;
+		pid = atoi(argv[1]);
+		if (pid == 0 && argv[1][0] != '0') {
+			fprintf(stderr, "Enter a valid PID.\n");
+			fprintf(stderr, "Usage: %s pid [output-file-name]\n", argv[0]);
+			return -1;
+		}
+		if (argc == 2) {
+			snprintf(core_file, 15, "core.%d", pid);
+			ret = do_coredump(pid, core_file);
+		} else
+			ret = do_coredump(pid, argv[2]);
+
+		if (ret == -1)
+			gencore_log("Failed to create core file.\n");
+	}
+
+	return ret;
+}

