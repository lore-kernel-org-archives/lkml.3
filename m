Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab3BAEsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 23:48:55 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:23321 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226Ab3BAEs0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 23:48:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 3/7] liblock: mutex test suite
Date: Thu, 31 Jan 2013 23:47:34 -0500
Message-Id: <1359694058-24452-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
References: <1359694058-24452-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rather simple and basic test suite to test common locking
issues.

Beyond tests, it also shows how to use the library.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/liblock/run_tests.sh           | 16 ++++++++++++++++
 tools/lib/liblock/tests/AA.c             | 16 ++++++++++++++++
 tools/lib/liblock/tests/ABBA.c           | 16 ++++++++++++++++
 tools/lib/liblock/tests/ABBCCA.c         | 18 ++++++++++++++++++
 tools/lib/liblock/tests/ABBCCDDA.c       | 20 ++++++++++++++++++++
 tools/lib/liblock/tests/ABCABC.c         | 18 ++++++++++++++++++
 tools/lib/liblock/tests/ABCDBCDA.c       | 20 ++++++++++++++++++++
 tools/lib/liblock/tests/ABCDBDDA.c       | 20 ++++++++++++++++++++
 tools/lib/liblock/tests/common.h         | 11 +++++++++++
 tools/lib/liblock/tests/unlock_balance.c | 15 +++++++++++++++
 10 files changed, 170 insertions(+)
 create mode 100755 tools/lib/liblock/run_tests.sh
 create mode 100644 tools/lib/liblock/tests/AA.c
 create mode 100644 tools/lib/liblock/tests/ABBA.c
 create mode 100644 tools/lib/liblock/tests/ABBCCA.c
 create mode 100644 tools/lib/liblock/tests/ABBCCDDA.c
 create mode 100644 tools/lib/liblock/tests/ABCABC.c
 create mode 100644 tools/lib/liblock/tests/ABCDBCDA.c
 create mode 100644 tools/lib/liblock/tests/ABCDBDDA.c
 create mode 100644 tools/lib/liblock/tests/common.h
 create mode 100644 tools/lib/liblock/tests/unlock_balance.c

diff --git a/tools/lib/liblock/run_tests.sh b/tools/lib/liblock/run_tests.sh
new file mode 100755
index 0000000..bbf5281
--- /dev/null
+++ b/tools/lib/liblock/run_tests.sh
@@ -0,0 +1,16 @@
+#! /bin/bash
+
+make &> /dev/null
+
+for i in `ls tests/*.c`; do
+	testname=$(basename -s .c "$i")
+	gcc -o tests/$testname -lpthread $i liblock.a -Iinclude &> /dev/null
+	echo -ne "$testname... "
+	if [ $(timeout 1 ./tests/$testname | wc -l) -gt 0 ]; then
+		echo "PASSED!"
+	else
+		echo "FAILED!"
+	fi
+	rm tests/$testname
+done
+		
diff --git a/tools/lib/liblock/tests/AA.c b/tools/lib/liblock/tests/AA.c
new file mode 100644
index 0000000..558109c
--- /dev/null
+++ b/tools/lib/liblock/tests/AA.c
@@ -0,0 +1,16 @@
+#include <liblock/mutex.h>
+
+void main(void)
+{
+	liblock_pthread_mutex_t a, b;
+
+	liblock_init();
+	liblock_set_thread();
+
+	liblock_pthread_mutex_init(&a, NULL);
+	liblock_pthread_mutex_init(&b, NULL);
+
+	liblock_pthread_mutex_lock(&a);
+	liblock_pthread_mutex_unlock(&b);
+	liblock_pthread_mutex_lock(&a);
+}
diff --git a/tools/lib/liblock/tests/ABBA.c b/tools/lib/liblock/tests/ABBA.c
new file mode 100644
index 0000000..b5070fd
--- /dev/null
+++ b/tools/lib/liblock/tests/ABBA.c
@@ -0,0 +1,16 @@
+#include <liblock/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	liblock_pthread_mutex_t a, b;
+
+	liblock_init();
+	liblock_set_thread();
+
+	liblock_pthread_mutex_init(&a, NULL);
+	liblock_pthread_mutex_init(&b, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, a);
+}
diff --git a/tools/lib/liblock/tests/ABBCCA.c b/tools/lib/liblock/tests/ABBCCA.c
new file mode 100644
index 0000000..5fc5fa2
--- /dev/null
+++ b/tools/lib/liblock/tests/ABBCCA.c
@@ -0,0 +1,18 @@
+#include <liblock/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	liblock_pthread_mutex_t a, b, c;
+	
+	liblock_init();
+	liblock_set_thread();
+
+	liblock_pthread_mutex_init(&a, NULL);
+	liblock_pthread_mutex_init(&b, NULL);
+	liblock_pthread_mutex_init(&c, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(c, a);
+}
diff --git a/tools/lib/liblock/tests/ABBCCDDA.c b/tools/lib/liblock/tests/ABBCCDDA.c
new file mode 100644
index 0000000..5cf05bb
--- /dev/null
+++ b/tools/lib/liblock/tests/ABBCCDDA.c
@@ -0,0 +1,20 @@
+#include <liblock/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	liblock_pthread_mutex_t a, b, c, d;
+
+	liblock_init();
+	liblock_set_thread();
+
+	liblock_pthread_mutex_init(&a, NULL);
+	liblock_pthread_mutex_init(&b, NULL);
+	liblock_pthread_mutex_init(&c, NULL);
+	liblock_pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/liblock/tests/ABCABC.c b/tools/lib/liblock/tests/ABCABC.c
new file mode 100644
index 0000000..eab71ff
--- /dev/null
+++ b/tools/lib/liblock/tests/ABCABC.c
@@ -0,0 +1,18 @@
+#include <liblock/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	liblock_pthread_mutex_t a, b, c;
+
+	liblock_init();
+	liblock_set_thread();
+
+	liblock_pthread_mutex_init(&a, NULL);
+	liblock_pthread_mutex_init(&b, NULL);
+	liblock_pthread_mutex_init(&c, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, a);
+	LOCK_UNLOCK_2(b, c);
+}
diff --git a/tools/lib/liblock/tests/ABCDBCDA.c b/tools/lib/liblock/tests/ABCDBCDA.c
new file mode 100644
index 0000000..3250f0f
--- /dev/null
+++ b/tools/lib/liblock/tests/ABCDBCDA.c
@@ -0,0 +1,20 @@
+#include <liblock/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	liblock_pthread_mutex_t a, b, c, d;
+
+	liblock_init();
+	liblock_set_thread();
+
+	liblock_pthread_mutex_init(&a, NULL);
+	liblock_pthread_mutex_init(&b, NULL);
+	liblock_pthread_mutex_init(&c, NULL);
+	liblock_pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/liblock/tests/ABCDBDDA.c b/tools/lib/liblock/tests/ABCDBDDA.c
new file mode 100644
index 0000000..b49c5d9
--- /dev/null
+++ b/tools/lib/liblock/tests/ABCDBDDA.c
@@ -0,0 +1,20 @@
+#include <liblock/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	liblock_pthread_mutex_t a, b, c, d;
+
+	liblock_init();
+	liblock_set_thread();
+
+	liblock_pthread_mutex_init(&a, NULL);
+	liblock_pthread_mutex_init(&b, NULL);
+	liblock_pthread_mutex_init(&c, NULL);
+	liblock_pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(b, d);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/liblock/tests/common.h b/tools/lib/liblock/tests/common.h
new file mode 100644
index 0000000..d5f6d5e
--- /dev/null
+++ b/tools/lib/liblock/tests/common.h
@@ -0,0 +1,11 @@
+#ifndef _LIBLOCK_TEST_COMMON_H
+#define _LIBLOCK_TEST_COMMON_H
+
+#define LOCK_UNLOCK_2(a, b)			\
+	liblock_pthread_mutex_lock(&(a));	\
+	liblock_pthread_mutex_lock(&(b));	\
+	liblock_pthread_mutex_unlock(&(b));	\
+	liblock_pthread_mutex_unlock(&(a));
+
+
+#endif
diff --git a/tools/lib/liblock/tests/unlock_balance.c b/tools/lib/liblock/tests/unlock_balance.c
new file mode 100644
index 0000000..e68ca99
--- /dev/null
+++ b/tools/lib/liblock/tests/unlock_balance.c
@@ -0,0 +1,15 @@
+#include <liblock/mutex.h>
+
+void main(void)
+{
+	liblock_pthread_mutex_t a;
+
+	liblock_init();
+	liblock_set_thread();
+
+	liblock_pthread_mutex_init(&a, NULL);
+
+	liblock_pthread_mutex_lock(&a);
+	liblock_pthread_mutex_unlock(&a);
+	liblock_pthread_mutex_unlock(&a);
+}
-- 
1.8.1.1

