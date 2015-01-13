Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181AbbAMKXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:23:20 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:36129 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136AbbAMKXQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:23:16 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org, shuahkh@osg.samsung.com
Subject: [PATCH V2 11/12] selftests, powerpc: Add test for all DSCR sysfs interfaces
Date: Tue, 13 Jan 2015 15:52:39 +0530
Message-Id: <1421144560-15901-12-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011310-0033-0000-0000-000000EA6C15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This test continuously updates the system wide DSCR default value
in the sysfs interface and makes sure that the same is reflected
across all the sysfs interfaces for each individual CPUs present
on the system.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 tools/testing/selftests/powerpc/dscr/Makefile      |  3 +-
 .../selftests/powerpc/dscr/dscr_sysfs_test.c       | 89 ++++++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c

diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
index 4e84309..fada526 100644
--- a/tools/testing/selftests/powerpc/dscr/Makefile
+++ b/tools/testing/selftests/powerpc/dscr/Makefile
@@ -1,5 +1,6 @@
 PROGS := dscr_default_test dscr_explicit_test dscr_user_test	\
-	 dscr_inherit_test dscr_inherit_exec_test
+	 dscr_inherit_test dscr_inherit_exec_test		\
+	 dscr_sysfs_test
 
 CFLAGS := $(CFLAGS) -lpthread
 
diff --git a/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
new file mode 100644
index 0000000..3d11439
--- /dev/null
+++ b/tools/testing/selftests/powerpc/dscr/dscr_sysfs_test.c
@@ -0,0 +1,89 @@
+/*
+ * POWER Data Stream Control Register (DSCR) sysfs interface test
+ *
+ * This test updates to system wide DSCR default through the sysfs interface
+ * and then verifies that all the CPU specific DSCR defaults are updated as
+ * well verified from their sysfs interfaces.
+ *
+ * Copyright (C) 2015 Anshuman Khandual <khandual@linux.vnet.ibm.com>, IBM
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include "dscr.h"
+
+static int check_cpu_dscr_default(char *file, unsigned long val)
+{
+	char buf[10];
+	int fd, rc;
+
+	fd = open(file, O_RDWR);
+	if (fd == -1) {
+		perror("open() failed\n");
+		return 1;
+	}
+
+	rc = read(fd, buf, sizeof(buf));
+	if (rc == -1) {
+		perror("read() failed\n");
+		return 1;
+	}
+	close(fd);
+
+	buf[rc] = '\0';
+	if (strtol(buf, NULL, 16) != val) {
+		printf("DSCR match failed: %ld (system) %ld (cpu)\n",
+					val, strtol(buf, NULL, 16));
+		return 1;
+	}
+	return 0;
+}
+
+static int check_all_cpu_dscr_defaults(unsigned long val)
+{
+	DIR *sysfs;
+	struct dirent *dp;
+	char file[LEN_MAX];
+
+	sysfs = opendir(CPU_PATH);
+	if (!sysfs) {
+		perror("opendir() failed\n");
+		return 1;
+	}
+
+	while ((dp = readdir(sysfs))) {
+		if (!(dp->d_type & DT_DIR))
+			continue;
+		if (!strcmp(dp->d_name, "cpuidle"))
+			continue;
+		if (!strstr(dp->d_name, "cpu"))
+			continue;
+
+		sprintf(file, "%s%s/dscr", CPU_PATH, dp->d_name);
+		if (check_cpu_dscr_default(file, val))
+			return 1;
+	}
+	closedir(sysfs);
+	return 0;
+}
+
+int test_body(void)
+{
+	int i, j;
+
+	for (i = 0; i < COUNT; i++) {
+		for (j = 0; j < DSCR_MAX; j++) {
+			set_default_dscr(j);
+			if (check_all_cpu_dscr_defaults(j))
+				return 1;
+		}
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	return test_harness(test_body, "dscr_sysfs_test");
+}
-- 
1.9.3

