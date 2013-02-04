Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab3BDBwy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 20:52:54 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45909 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753728Ab3BDBvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 20:51:15 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@redhat.com, peterz@infradead.org
Cc: paulus@samba.org, acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org, Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v3 3/7] liblockdep: mutex test suite
Date: Sun,  3 Feb 2013 20:50:40 -0500
Message-Id: <1359942644-26371-3-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1359942644-26371-1-git-send-email-sasha.levin@oracle.com>
References: <1359942644-26371-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rather simple and basic test suite to test common locking
issues.

Beyond tests, it also shows how to use the library.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/run_tests.sh           | 15 +++++++++++++++
 tools/lib/lockdep/tests/AA.c             | 16 ++++++++++++++++
 tools/lib/lockdep/tests/ABBA.c           | 16 ++++++++++++++++
 tools/lib/lockdep/tests/ABBCCA.c         | 18 ++++++++++++++++++
 tools/lib/lockdep/tests/ABBCCDDA.c       | 20 ++++++++++++++++++++
 tools/lib/lockdep/tests/ABCABC.c         | 18 ++++++++++++++++++
 tools/lib/lockdep/tests/ABCDBCDA.c       | 20 ++++++++++++++++++++
 tools/lib/lockdep/tests/ABCDBDDA.c       | 20 ++++++++++++++++++++
 tools/lib/lockdep/tests/common.h         | 12 ++++++++++++
 tools/lib/lockdep/tests/unlock_balance.c | 15 +++++++++++++++
 10 files changed, 170 insertions(+)
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
index 0000000..4dd32d1
--- /dev/null
+++ b/tools/lib/lockdep/run_tests.sh
@@ -0,0 +1,15 @@
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
diff --git a/tools/lib/lockdep/tests/AA.c b/tools/lib/lockdep/tests/AA.c
new file mode 100644
index 0000000..933d32f
--- /dev/null
+++ b/tools/lib/lockdep/tests/AA.c
@@ -0,0 +1,16 @@
+#include <liblockdep/mutex.h>
+
+void main(void)
+{
+	pthread_mutex_t a, b;
+
+	liblockdep_init();
+	liblockdep_set_thread();
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+
+	pthread_mutex_lock(&a);
+	pthread_mutex_unlock(&b);
+	pthread_mutex_lock(&a);
+}
diff --git a/tools/lib/lockdep/tests/ABBA.c b/tools/lib/lockdep/tests/ABBA.c
new file mode 100644
index 0000000..9f5146b
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABBA.c
@@ -0,0 +1,16 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b;
+
+	liblockdep_init();
+	liblockdep_set_thread();
+
+	pthread_mutex_init(&a, NULL);
+	pthread_mutex_init(&b, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(b, a);
+}
diff --git a/tools/lib/lockdep/tests/ABBCCA.c b/tools/lib/lockdep/tests/ABBCCA.c
new file mode 100644
index 0000000..b7435d7
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABBCCA.c
@@ -0,0 +1,18 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c;
+
+	liblockdep_init();
+	liblockdep_set_thread();
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
index 0000000..2425330
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABBCCDDA.c
@@ -0,0 +1,20 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c, d;
+
+	liblockdep_init();
+	liblockdep_set_thread();
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
index 0000000..2ee30fe
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABCABC.c
@@ -0,0 +1,18 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c;
+
+	liblockdep_init();
+	liblockdep_set_thread();
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
index 0000000..32d19d6
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABCDBCDA.c
@@ -0,0 +1,20 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	liblockdep_pthread_mutex_t a, b, c, d;
+
+	liblockdep_init();
+	liblockdep_set_thread();
+
+	liblockdep_pthread_mutex_init(&a, NULL);
+	liblockdep_pthread_mutex_init(&b, NULL);
+	liblockdep_pthread_mutex_init(&c, NULL);
+	liblockdep_pthread_mutex_init(&d, NULL);
+
+	LOCK_UNLOCK_2(a, b);
+	LOCK_UNLOCK_2(c, d);
+	LOCK_UNLOCK_2(b, c);
+	LOCK_UNLOCK_2(d, a);
+}
diff --git a/tools/lib/lockdep/tests/ABCDBDDA.c b/tools/lib/lockdep/tests/ABCDBDDA.c
new file mode 100644
index 0000000..850eaca
--- /dev/null
+++ b/tools/lib/lockdep/tests/ABCDBDDA.c
@@ -0,0 +1,20 @@
+#include <liblockdep/mutex.h>
+#include "common.h"
+
+void main(void)
+{
+	pthread_mutex_t a, b, c, d;
+
+	liblockdep_init();
+	liblockdep_set_thread();
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
index 0000000..9dfaf97
--- /dev/null
+++ b/tools/lib/lockdep/tests/unlock_balance.c
@@ -0,0 +1,15 @@
+#include <liblockdep/mutex.h>
+
+void main(void)
+{
+	pthread_mutex_t a;
+
+	liblockdep_init();
+	liblockdep_set_thread();
+
+	pthread_mutex_init(&a, NULL);
+
+	pthread_mutex_lock(&a);
+	pthread_mutex_unlock(&a);
+	pthread_mutex_unlock(&a);
+}
-- 
1.8.1.2

