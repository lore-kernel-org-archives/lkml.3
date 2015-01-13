Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752090AbbAMKXK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 05:23:10 -0500
Received: from e23smtp01.au.ibm.com ([202.81.31.143]:47484 "EHLO
	e23smtp01.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751630AbbAMKXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 05:23:06 -0500
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: mpe@ellerman.id.au, benh@kernel.crashing.org, anton@samba.org,
        mikey@neuling.org, shuahkh@osg.samsung.com
Subject: [PATCH V2 06/12] selftests, powerpc: Add test for system wide DSCR default
Date: Tue, 13 Jan 2015 15:52:34 +0530
Message-Id: <1421144560-15901-7-git-send-email-khandual@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
References: <1421144560-15901-1-git-send-email-khandual@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011310-1618-0000-0000-00000171EC03
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a test case for the system wide DSCR default
value, which when changed through it's sysfs interface must
be visible to all threads reading DSCR either through the
privilege state SPR or the problem state SPR. The DSCR value
change should be immediate as well.

Signed-off-by: Anshuman Khandual <khandual@linux.vnet.ibm.com>
---
 tools/testing/selftests/powerpc/Makefile           |   2 +-
 tools/testing/selftests/powerpc/dscr/Makefile      |  17 +++
 tools/testing/selftests/powerpc/dscr/dscr.h        | 120 ++++++++++++++++++++
 .../selftests/powerpc/dscr/dscr_default_test.c     | 121 +++++++++++++++++++++
 4 files changed, 259 insertions(+), 1 deletion(-)
 create mode 100644 tools/testing/selftests/powerpc/dscr/Makefile
 create mode 100644 tools/testing/selftests/powerpc/dscr/dscr.h
 create mode 100644 tools/testing/selftests/powerpc/dscr/dscr_default_test.c

diff --git a/tools/testing/selftests/powerpc/Makefile b/tools/testing/selftests/powerpc/Makefile
index f6ff90a..1318883 100644
--- a/tools/testing/selftests/powerpc/Makefile
+++ b/tools/testing/selftests/powerpc/Makefile
@@ -13,7 +13,7 @@ CFLAGS := -Wall -O2 -flto -Wall -Werror -DGIT_VERSION='"$(GIT_VERSION)"' -I$(CUR
 
 export CC CFLAGS
 
-TARGETS = pmu copyloops mm tm primitives
+TARGETS = pmu copyloops mm tm primitives dscr
 
 endif
 
diff --git a/tools/testing/selftests/powerpc/dscr/Makefile b/tools/testing/selftests/powerpc/dscr/Makefile
new file mode 100644
index 0000000..0aa90ab
--- /dev/null
+++ b/tools/testing/selftests/powerpc/dscr/Makefile
@@ -0,0 +1,17 @@
+PROGS := dscr_default_test
+
+CFLAGS := $(CFLAGS) -lpthread
+
+all: $(PROGS)
+
+$(PROGS): ../harness.c
+
+run_tests: all
+	@-for PROG in $(PROGS); do \
+		./$$PROG; \
+	done;
+
+clean:
+	rm -f $(PROGS) *.o
+
+.PHONY: all run_tests clean
diff --git a/tools/testing/selftests/powerpc/dscr/dscr.h b/tools/testing/selftests/powerpc/dscr/dscr.h
new file mode 100644
index 0000000..2e6535b
--- /dev/null
+++ b/tools/testing/selftests/powerpc/dscr/dscr.h
@@ -0,0 +1,120 @@
+/*
+ * POWER Data Stream Control Register (DSCR)
+ *
+ * This header file contains helper functions and macros
+ * required for all the DSCR related test cases.
+ *
+ * Copyright (C) 2012 Anton Blanchard <anton@au.ibm.com>, IBM
+ * Copyright (C) 2015 Anshuman Khandual <khandual@linux.vnet.ibm.com>, IBM
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#ifndef _SELFTESTS_POWERPC_DSCR_DSCR_H
+#define _SELFTESTS_POWERPC_DSCR_DSCR_H
+
+#include <unistd.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <dirent.h>
+#include <pthread.h>
+#include <sched.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <sys/wait.h>
+
+#include "utils.h"
+
+#define SPRN_DSCR	0x11	/* Privilege state SPR */
+#define SPRN_DSCR_USR	0x03	/* Problem state SPR */
+#define THREADS		100	/* Max threads */
+#define COUNT		100	/* Max iterations */
+#define DSCR_MAX	16	/* Max DSCR value */
+#define LEN_MAX		100	/* Max name length */
+
+#define DSCR_DEFAULT	"/sys/devices/system/cpu/dscr_default"
+#define CPU_PATH	"/sys/devices/system/cpu/"
+
+#define rmb()  asm volatile("lwsync":::"memory")
+#define wmb()  asm volatile("lwsync":::"memory")
+
+#define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
+
+/* Prilvilege state DSCR access */
+inline unsigned long get_dscr(void)
+{
+	unsigned long ret;
+
+	asm volatile("mfspr %0,%1" : "=r" (ret): "i" (SPRN_DSCR));
+
+	return ret;
+}
+
+inline void set_dscr(unsigned long val)
+{
+	asm volatile("mtspr %1,%0" : : "r" (val), "i" (SPRN_DSCR));
+}
+
+/* Problem state DSCR access */
+inline unsigned long get_dscr_usr(void)
+{
+	unsigned long ret;
+
+	asm volatile("mfspr %0,%1" : "=r" (ret): "i" (SPRN_DSCR_USR));
+
+	return ret;
+}
+
+inline void set_dscr_usr(unsigned long val)
+{
+	asm volatile("mtspr %1,%0" : : "r" (val), "i" (SPRN_DSCR_USR));
+}
+
+/* Default DSCR access */
+unsigned long get_default_dscr(void)
+{
+	int fd = -1;
+	char buf[16];
+	unsigned long val;
+
+	if (fd == -1) {
+		fd = open(DSCR_DEFAULT, O_RDONLY);
+		if (fd == -1) {
+			perror("open() failed\n");
+			exit(1);
+		}
+	}
+	memset(buf, 0, sizeof(buf));
+	lseek(fd, 0, SEEK_SET);
+	read(fd, buf, sizeof(buf));
+	sscanf(buf, "%lx", &val);
+	close(fd);
+	return val;
+}
+
+void set_default_dscr(unsigned long val)
+{
+	int fd = -1;
+	char buf[16];
+
+	if (fd == -1) {
+		fd = open(DSCR_DEFAULT, O_RDWR);
+		if (fd == -1) {
+			perror("open() failed\n");
+			exit(1);
+		}
+	}
+	sprintf(buf, "%lx\n", val);
+	write(fd, buf, strlen(buf));
+	close(fd);
+}
+
+double uniform_deviate(int seed)
+{
+	return seed * (1.0 / (RAND_MAX + 1.0));
+}
+#endif	/* _SELFTESTS_POWERPC_DSCR_DSCR_H */
diff --git a/tools/testing/selftests/powerpc/dscr/dscr_default_test.c b/tools/testing/selftests/powerpc/dscr/dscr_default_test.c
new file mode 100644
index 0000000..fd8b7b9
--- /dev/null
+++ b/tools/testing/selftests/powerpc/dscr/dscr_default_test.c
@@ -0,0 +1,121 @@
+/*
+ * POWER Data Stream Control Register (DSCR) default test
+ *
+ * This test modifies the system wide default DSCR through
+ * it's sysfs interface and then verifies that all threads
+ * see the correct changed DSCR value immediately.
+ *
+ * Copyright (C) 2012 Anton Blanchard <anton@au.ibm.com>, IBM
+ * Copyright (C) 2015 Anshuman Khandual <khandual@linux.vnet.ibm.com>, IBM
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+#include "dscr.h"
+
+static unsigned long dscr;		/* System DSCR default */
+static unsigned long sequence;
+static unsigned long result[THREADS];
+
+static void *do_test(void *in)
+{
+	unsigned long thread = (unsigned long)in;
+	unsigned long i;
+
+	for (i = 0; i < COUNT; i++) {
+		unsigned long d, cur_dscr, cur_dscr_usr;
+		unsigned long s1, s2;
+
+		s1 = ACCESS_ONCE(sequence);
+		if (s1 & 1)
+			continue;
+		rmb();
+
+		d = dscr;
+		cur_dscr = get_dscr();
+		cur_dscr_usr = get_dscr_usr();
+
+		rmb();
+		s2 = sequence;
+
+		if (s1 != s2)
+			continue;
+
+		if (cur_dscr != d) {
+			fprintf(stderr, "thread %ld kernel DSCR should be %ld "
+				"but is %ld\n", thread, d, cur_dscr);
+			result[thread] = 1;
+			pthread_exit(&result[thread]);
+		}
+
+		if (cur_dscr_usr != d) {
+			fprintf(stderr, "thread %ld user DSCR should be %ld "
+				"but is %ld\n", thread, d, cur_dscr_usr);
+			result[thread] = 1;
+			pthread_exit(&result[thread]);
+		}
+	}
+	result[thread] = 0;
+	pthread_exit(&result[thread]);
+}
+
+int test_body(void)
+{
+	pthread_t threads[THREADS];
+	unsigned long i, *status[THREADS];
+
+	/* Initial DSCR default */
+	dscr = 1;
+	set_default_dscr(dscr);
+
+	/* Spawn all testing threads */
+	for (i = 0; i < THREADS; i++) {
+		if (pthread_create(&threads[i], NULL, do_test, (void *)i)) {
+			perror("pthread_create() failed\n");
+			exit(1);
+		}
+	}
+
+	srand(getpid());
+
+	/* Keep changing the DSCR default */
+	for (i = 0; i < COUNT; i++) {
+		double ret = uniform_deviate(rand());
+
+		if (ret < 0.0001) {
+			sequence++;
+			wmb();
+
+			dscr++;
+			if (dscr > DSCR_MAX)
+				dscr = 0;
+
+			set_default_dscr(dscr);
+
+			wmb();
+			sequence++;
+		}
+	}
+
+	/* Individual testing thread exit status */
+	for (i = 0; i < THREADS; i++) {
+		if (pthread_join(threads[i], (void **)&(status[i]))) {
+			perror("pthread_join() failed\n");
+			exit(1);
+		}
+
+		if (*status[i]) {
+			printf("%ldth thread failed to join with %ld status\n",
+								i, *status[i]);
+			return 1;
+		}
+	}
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	return test_harness(test_body, "dscr_default_test");
+}
-- 
1.9.3

