Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754796Ab3EPDRy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 23:17:54 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:23534 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754402Ab3EPDQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 23:16:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
To: torvalds@linux-foundation.org
Cc: mingo@kernel.org, peterz@infradead.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v4 4/9] liblockdep: Add pthread_mutex_t test suite
Date: Wed, 15 May 2013 23:15:36 -0400
Message-Id: <1368674141-10796-5-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
References: <1368674141-10796-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rather simple and basic test suite to test common
locking issues.

Beyond tests, it also shows how to use the library.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/run_tests.sh           | 27 +++++++++++++++++++++++++++
 tools/lib/lockdep/tests/AA.c             | 13 +++++++++++++
 tools/lib/lockdep/tests/ABBA.c           | 13 +++++++++++++
 tools/lib/lockdep/tests/ABBCCA.c         | 15 +++++++++++++++
 tools/lib/lockdep/tests/ABBCCDDA.c       | 17 +++++++++++++++++
 tools/lib/lockdep/tests/ABCABC.c         | 15 +++++++++++++++
 tools/lib/lockdep/tests/ABCDBCDA.c       | 17 +++++++++++++++++
 tools/lib/lockdep/tests/ABCDBDDA.c       | 17 +++++++++++++++++
 tools/lib/lockdep/tests/common.h         | 12 ++++++++++++
 tools/lib/lockdep/tests/unlock_balance.c | 12 ++++++++++++
 10 files changed, 158 insertions(+)
 create mode 100755 tools/lib/lockdep/run_tests.sh
 create mode 100644 tools/lib/lockdep/tests/AA.c
 create mode 100644 tools/lib/lockdep/tests/ABBA.c
 create mode 100644 tools/lib/lockdep/tests/ABBCCA.c
 create mode 100644 tools/lib/lockdep/tests/ABBCCDDA.c
 create mode 100644 tools/lib/lockdep/tests/ABCABC.c
 create mode 100644 tools/lib/lockdep/tests/ABCDBCDA.c
 create mode 100644 tools/lib/lockdep/tests/ABCDBDDA.c
 create mode 100644 tools/lib/lockdep/tests/common.h
 create mode 100644 tools/lib/lockdep/tests/unlock_balance.c

diff --git a/tools/lib/lockdep/run_tests.sh b/tools/lib/lockdep/run_tests.sh
new file mode 100755
index 0000000..240a93c
--- /dev/null
+++ b/tools/lib/lockdep/run_tests.sh
@@ -0,0 +1,27 @@
+#! /bin/bash
+
+make &> /dev/null
+
+for i in `ls tests/*.c`; do
+	testname=$(basename -s .c "$i")
+	gcc -o tests/$testname -lpthread $i liblockdep.a -Iinclude -D__USE_LIBLOCKDEP &> /dev/null
+	echo -ne "$testname... "
+	if [ $(timeout 1 ./tests/$testname | wc -l) -gt 0 ]; then
+		echo "PASSED!"
+	else
+		echo "FAILED!"
+	fi
+	rm tests/$testname
+done
+
+for i in `ls tests/*.c`; do
+	testname=$(basename -s .c "$i")
+	gcc -o tests/$testname -lpthread -Iinclude $i &> /dev/null
+	echo -ne "(PRELOAD) $testname... "
+	if [ $(timeout 1 ./lockdep ./tests/$testname | wc -l) -gt 0 ]; then
+		echo "PASSED!"
+	else
+		echo "FAILED!"
+	fi
+	rm tests/$testname
+done
diff --git a/tools/lib/lockdep/tests/AA.c b/tools/lib/lockdep/tests/AA.c
new file mode 100644
index 0000000..0f782ff
--- /dev/null
+++ b/tools/lib/lockdep/tests/AA.c
@@ -0,0 +1,13 @@
+#include <liblockdep/mutex.h>
+
+void main(void)
+{
+	pthread_mutex_t a, b;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+
+	pthread_mutex_lock(&a);
+	pthread_mutex_lock(&b);
+	pthread_mutex_lock(&a);
+}
diff --git a/tools/lib/lockdep/tests/ABBA.c b/tools/lib/lockdep/tests/ABBA.c
new file mode 100644
index 0000000..07f0e29
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABBA.c
@@ -0,0 +1,13 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, a);
+}
diff --git a/tools/lib/lockdep/tests/ABBCCA.c b/tools/lib/lockdep/tests/ABBCCA.c
new file mode 100644
index 0000000..843db09
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABBCCA.c
@@ -0,0 +1,15 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(c, a);
+}
diff --git a/tools/lib/lockdep/tests/ABBCCDDA.c b/tools/lib/lockdep/tests/ABBCCDDA.c
new file mode 100644
index 0000000..33620e2
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABBCCDDA.c
@@ -0,0 +1,17 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c, d;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+	pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/lockdep/tests/ABCABC.c b/tools/lib/lockdep/tests/ABCABC.c
new file mode 100644
index 0000000..3fee51e
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABCABC.c
@@ -0,0 +1,15 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, a);
+	LOCK_UNLOCK_2(b, c);
+}
diff --git a/tools/lib/lockdep/tests/ABCDBCDA.c b/tools/lib/lockdep/tests/ABCDBCDA.c
new file mode 100644
index 0000000..427ba56
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABCDBCDA.c
@@ -0,0 +1,17 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c, d;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+	pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/lockdep/tests/ABCDBDDA.c b/tools/lib/lockdep/tests/ABCDBDDA.c
new file mode 100644
index 0000000..680c6cf
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABCDBDDA.c
@@ -0,0 +1,17 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c, d;
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+	pthread_mutex_init(&c, NULL);
+	pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(b, d);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/lockdep/tests/common.h b/tools/lib/lockdep/tests/common.h
new file mode 100644
index 0000000..d89e94d
--- /dev/null
+++ b/tools/lib/lockdep/tests/common.h
@@ -0,0 +1,12 @@
+#ifndef _LIBLOCKDEP_TEST_COMMON_H
+#define _LIBLOCKDEP_TEST_COMMON_H
+
+#define LOCK_UNLOCK_2(a, b)			\
+	do {					\
+		pthread_mutex_lock(&(a));	\
+		pthread_mutex_lock(&(b));	\
+		pthread_mutex_unlock(&(b));	\
+		pthread_mutex_unlock(&(a));	\
+	} while(0)
+
+#endif
diff --git a/tools/lib/lockdep/tests/unlock_balance.c b/tools/lib/lockdep/tests/unlock_balance.c
new file mode 100644
index 0000000..0bc62de
--- /dev/null
+++ b/tools/lib/lockdep/tests/unlock_balance.c
@@ -0,0 +1,12 @@
+#include <liblockdep/mutex.h>
+
+void main(void)
+{
+	pthread_mutex_t a;
+
+	pthread_mutex_init(&a, NULL);
+
+	pthread_mutex_lock(&a);
+	pthread_mutex_unlock(&a);
+	pthread_mutex_unlock(&a);
+}
-- 
1.8.2.1

