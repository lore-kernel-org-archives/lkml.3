Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755659Ab3HFHmu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 03:42:50 -0400
Received: from ozlabs.org ([203.10.76.45]:42985 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755286Ab3HFHmr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 03:42:47 -0400
From: Michael Ellerman <michael@ellerman.id.au>
To: <linuxppc-dev@ozlabs.org>
Cc: <linux-kernel@vger.kernel.org>, Anton Blanchard <anton@samba.org>,
        Jeremy Kerr <jk@ozlabs.org>, Michael Neuling <mikey@neuling.org>,
        Andrew Morton <akpm@osdl.org>
Subject: [PATCH v3 2/3] selftests: Add support files for powerpc tests
Date: Tue,  6 Aug 2013 17:42:36 +1000
Message-Id: <1375774957-30052-2-git-send-email-michael@ellerman.id.au>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375774957-30052-1-git-send-email-michael@ellerman.id.au>
References: <1375774957-30052-1-git-send-email-michael@ellerman.id.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit adds support code used by upcoming powerpc tests.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
v3: Print when the child dies due to a signal
v2: Put back the SIGALARM handler to make the hang logic work.

 tools/testing/selftests/powerpc/harness.c | 105 ++++++++++++++++++++++++++++++
 tools/testing/selftests/powerpc/subunit.h |  47 +++++++++++++
 tools/testing/selftests/powerpc/utils.h   |  34 ++++++++++
 3 files changed, 186 insertions(+)
 create mode 100644 tools/testing/selftests/powerpc/harness.c
 create mode 100644 tools/testing/selftests/powerpc/subunit.h
 create mode 100644 tools/testing/selftests/powerpc/utils.h

diff --git a/tools/testing/selftests/powerpc/harness.c b/tools/testing/selftests/powerpc/harness.c
new file mode 100644
index 0000000..e80c42a
--- /dev/null
+++ b/tools/testing/selftests/powerpc/harness.c
@@ -0,0 +1,105 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+#include <errno.h>
+#include <signal.h>
+#include <stdbool.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+#include <unistd.h>
+
+#include "subunit.h"
+#include "utils.h"
+
+#define TIMEOUT		120
+#define KILL_TIMEOUT	5
+
+
+int run_test(int (test_function)(void), char *name)
+{
+	bool terminated;
+	int rc, status;
+	pid_t pid;
+
+	/* Make sure output is flushed before forking */
+	fflush(stdout);
+
+	pid = fork();
+	if (pid == 0) {
+		exit(test_function());
+	} else if (pid == -1) {
+		perror("fork");
+		return 1;
+	}
+
+	/* Wake us up in timeout seconds */
+	alarm(TIMEOUT);
+	terminated = false;
+
+wait:
+	rc = waitpid(pid, &status, 0);
+	if (rc == -1) {
+		if (errno != EINTR) {
+			printf("unknown error from waitpid\n");
+			return 1;
+		}
+
+		if (terminated) {
+			printf("!! force killing %s\n", name);
+			kill(pid, SIGKILL);
+			return 1;
+		} else {
+			printf("!! killing %s\n", name);
+			kill(pid, SIGTERM);
+			terminated = true;
+			alarm(KILL_TIMEOUT);
+			goto wait;
+		}
+	}
+
+	if (WIFEXITED(status))
+		status = WEXITSTATUS(status);
+	else {
+		if (WIFSIGNALED(status))
+			printf("!! child died by signal %d\n", WTERMSIG(status));
+		else
+			printf("!! child died by unknown cause\n");
+
+		status = 1; /* Signal or other */
+	}
+
+	return status;
+}
+
+static void alarm_handler(int signum)
+{
+	/* Jut wake us up from waitpid */
+}
+
+static struct sigaction alarm_action = {
+	.sa_handler = alarm_handler,
+};
+
+int test_harness(int (test_function)(void), char *name)
+{
+	int rc;
+
+	test_start(name);
+	test_set_git_version(GIT_VERSION);
+
+	if (sigaction(SIGALRM, &alarm_action, NULL)) {
+		perror("sigaction");
+		test_error(name);
+		return 1;
+	}
+
+	rc = run_test(test_function, name);
+
+	test_finish(name, rc);
+
+	return rc;
+}
diff --git a/tools/testing/selftests/powerpc/subunit.h b/tools/testing/selftests/powerpc/subunit.h
new file mode 100644
index 0000000..98a2292
--- /dev/null
+++ b/tools/testing/selftests/powerpc/subunit.h
@@ -0,0 +1,47 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+#ifndef _SELFTESTS_POWERPC_SUBUNIT_H
+#define _SELFTESTS_POWERPC_SUBUNIT_H
+
+static inline void test_start(char *name)
+{
+	printf("test: %s\n", name);
+}
+
+static inline void test_failure_detail(char *name, char *detail)
+{
+	printf("failure: %s [%s]\n", name, detail);
+}
+
+static inline void test_failure(char *name)
+{
+	printf("failure: %s\n", name);
+}
+
+static inline void test_error(char *name)
+{
+	printf("error: %s\n", name);
+}
+
+static inline void test_success(char *name)
+{
+	printf("success: %s\n", name);
+}
+
+static inline void test_finish(char *name, int status)
+{
+	if (status)
+		test_failure(name);
+	else
+		test_success(name);
+}
+
+static inline void test_set_git_version(char *value)
+{
+	printf("tags: git_version:%s\n", value);
+}
+
+#endif /* _SELFTESTS_POWERPC_SUBUNIT_H */
diff --git a/tools/testing/selftests/powerpc/utils.h b/tools/testing/selftests/powerpc/utils.h
new file mode 100644
index 0000000..5851c4b
--- /dev/null
+++ b/tools/testing/selftests/powerpc/utils.h
@@ -0,0 +1,34 @@
+/*
+ * Copyright 2013, Michael Ellerman, IBM Corp.
+ * Licensed under GPLv2.
+ */
+
+#ifndef _SELFTESTS_POWERPC_UTILS_H
+#define _SELFTESTS_POWERPC_UTILS_H
+
+#include <stdint.h>
+#include <stdbool.h>
+
+/* Avoid headaches with PRI?64 - just use %ll? always */
+typedef unsigned long long u64;
+typedef   signed long long s64;
+
+/* Just for familiarity */
+typedef uint32_t u32;
+typedef uint8_t u8;
+
+
+int test_harness(int (test_function)(void), char *name);
+
+
+/* Yes, this is evil */
+#define FAIL_IF(x)						\
+do {								\
+	if ((x)) {						\
+		fprintf(stderr,					\
+		"[FAIL] Test FAILED on line %d\n", __LINE__);	\
+		return 1;					\
+	}							\
+} while (0)
+
+#endif /* _SELFTESTS_POWERPC_UTILS_H */
-- 
1.8.1.2

