Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758275AbaCTJkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 05:40:15 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:55386 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756984AbaCTJkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 05:40:12 -0400
Subject: [PATCH 07/33] Do elf_coredump
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
Date: Thu, 20 Mar 2014 15:09:58 +0530
Message-ID: <20140320093958.14878.60354.stgit@localhost.localdomain>
In-Reply-To: <20140320093040.14878.903.stgit@localhost.localdomain>
References: <20140320093040.14878.903.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14032009-3568-0000-0000-00000520E5C6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Perform the actual dump depending on whether it is 32 bit or 64 bit.

We create three files elf.c elf32.c and elf64.c. In elf.c we have all the elf
related code in a generic format(not 32 or 64 bit specific). In elf32.c and
elf64.c we include elf.c and #define the required datatypes and functions into
32 or 64 specific values respectively.

Essentially we have two copies of elf.c, one which is 32 bit specific and the
other 64 bit specific and hence the appropriate function is called based on the
application to be dumped.

Signed-off-by: Janani Venkataraman <jananive@linux.vnet.ibm.com>
---
 src/Makefile.am |    2 +-
 src/coredump.c  |    9 +++++++++
 src/elf.c       |   31 +++++++++++++++++++++++++++++++
 src/elf32.c     |   33 +++++++++++++++++++++++++++++++++
 src/elf64.c     |   33 +++++++++++++++++++++++++++++++++
 5 files changed, 107 insertions(+), 1 deletion(-)
 create mode 100644 src/elf.c
 create mode 100644 src/elf32.c
 create mode 100644 src/elf64.c

diff --git a/src/Makefile.am b/src/Makefile.am
index 9e5d3c0..90d8b25 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -3,5 +3,5 @@ HAVE_SYSTEMD_SOCKET_SUPPORT = 0
 CFLAGS += -I. -DHAVE_SYSTEMD_SOCKET_SUPPORT='$(HAVE_SYSTEMD_SOCKET_SUPPORT)'
 
 bin_PROGRAMS = gencore
-gencore_SOURCES = coredump.c proc.c
+gencore_SOURCES = coredump.c proc.c elf32.c elf64.c
 
diff --git a/src/coredump.c b/src/coredump.c
index f9c7176..b1ee99d 100644
--- a/src/coredump.c
+++ b/src/coredump.c
@@ -28,6 +28,7 @@
 #include <stdlib.h>
 #include <dirent.h>
 #include <errno.h>
+#include <elf.h>
 #include <sys/ptrace.h>
 #include <coredump.h>
 
@@ -193,6 +194,14 @@ int do_coredump(int pid, char *core_file)
 	if (ret == -1)
 		goto cleanup;
 
+	/* Do elf_dump */
+	if (cp.elf_class == ELFCLASS32)
+		ret = do_elf32_coredump(pid, &cp);
+	else
+		ret = do_elf64_coredump(pid, &cp);
+	if (ret)
+		goto cleanup;
+
 cleanup:
 
 	/* Release the threads */
diff --git a/src/elf.c b/src/elf.c
new file mode 100644
index 0000000..280df13
--- /dev/null
+++ b/src/elf.c
@@ -0,0 +1,31 @@
+/*
+ * ELF helper routines for gencore
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
+#include "coredump.h"
+
+int do_elf_coredump(int pid, struct core_proc *cp)
+{
+	return 0;
+}
diff --git a/src/elf32.c b/src/elf32.c
new file mode 100644
index 0000000..d6b40b4
--- /dev/null
+++ b/src/elf32.c
@@ -0,0 +1,33 @@
+/*
+ * ELF helper routines for gencore
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
+/*
+ * We include elf.c to add all the elf specific operations here.
+ * In this file, we define all 32 bit specific data and hence
+ * this file would contain all elf 32 bit specific functions
+ * and operations once elf.c is included.
+ */
+
+#define do_elf_coredump do_elf32_coredump
+
+#include "elf.c"
diff --git a/src/elf64.c b/src/elf64.c
new file mode 100644
index 0000000..d8b5e89
--- /dev/null
+++ b/src/elf64.c
@@ -0,0 +1,33 @@
+/*
+ * ELF helper routines for gencore
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
+/*
+ * We include elf.c to add all the elf specific operations here.
+ * In this file, we define all 64 bit specific data and hence
+ * this file would contain all elf 64 bit specific functions
+ * and operations once elf.c is included.
+ */
+
+#define do_elf_coredump do_elf64_coredump
+
+#include "elf.c"

