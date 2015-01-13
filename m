Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbbAMKXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:23:13 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47495 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbbAMKXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:23:10 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org, shuahkh@osg.samsung.com
Subject: [PATCH V2 08/12] selftests, powerpc: Add test for DSCR SPR numbers
Date: Tue, 13 Jan 2015 15:52:36 +0530
Message-Id: <1421144560-15901-9-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011310-1618-0000-0000-00000171EC06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a test which verifies that the DSCR privilege and
problem state SPR read & write accesses while making sure that the
results are always the same irrespective of which SPR number is
being used.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 tools/testing/selftests/powerpc/dscr/Makefile      |  2 +-
 .../selftests/powerpc/dscr/dscr_user_test.c        | 62 ++++++++++++++++++++++
 2 files changed, 63 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/powerpc/dscr/dscr_user_test.c

diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
index aede453..ae865d8 100644
--- a/tools/testing/selftests/powerpc/dscr/Makefile
+++ b/tools/testing/selftests/powerpc/dscr/Makefile
@@ -1,4 +1,4 @@
-PROGS := dscr_default_test dscr_explicit_test
+PROGS := dscr_default_test dscr_explicit_test dscr_user_test
 
 CFLAGS := $(CFLAGS) -lpthread
 
diff --git a/tools/testing/selftests/powerpc/dscr/dscr_user_test.c b/tools/testing/selftests/powerpc/dscr/dscr_user_test.c
new file mode 100644
index 0000000..f25d68e
--- /dev/null
+++ b/tools/testing/selftests/powerpc/dscr/dscr_user_test.c
@@ -0,0 +1,62 @@
+/*
+ * POWER Data Stream Control Register (DSCR) SPR test
+ *
+ * This test modifies the DSCR value through both the SPR number
+ * based mtspr instruction and then makes sure that the same is
+ * reflected through mfspr instruction using either of the SPR
+ * numbers.
+ *
+ * When using the privilege state SPR, the instructions such as
+ * mfspr or mtspr are priviledged and the kernel emulates them
+ * for us. Instructions using problem state SPR can be exuecuted
+ * directly without any emulation if the HW supports them. Else
+ * they also get emulated by the kernel.
+ *
+ * Copyright (C) 2013 Anton Blanchard <anton@au.ibm.com>, IBM
+ * Copyright (C) 2015 Anshuman Khandual <khandual@linux.vnet.ibm.com>, IBM
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include "dscr.h"
+
+static int check_dscr(char *str)
+{
+	unsigned long cur_dscr, cur_dscr_usr;
+
+	cur_dscr = get_dscr();
+	cur_dscr_usr = get_dscr_usr();
+	if (cur_dscr != cur_dscr_usr) {
+		printf("%s set, kernel get %lx != user get %lx\n",
+					str, cur_dscr, cur_dscr_usr);
+		return 1;
+	}
+	return 0;
+}
+
+int test_body(void)
+{
+	int i;
+
+	check_dscr("");
+
+	for (i = 0; i < COUNT; i++) {
+		set_dscr(i);
+		if (check_dscr("kernel"))
+			return 1;
+	}
+
+	for (i = 0; i < COUNT; i++) {
+		set_dscr_usr(i);
+		if (check_dscr("user"))
+			return 1;
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	return test_harness(test_body, "dscr_user_test");
+}
-- 
1.9.3

