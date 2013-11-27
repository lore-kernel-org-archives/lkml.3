Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab3K0OJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:09:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47684 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756471Ab3K0OJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:09:28 -0500
Date: Wed, 27 Nov 2013 06:08:58 -0800
From: tip-bot for Sasha Levin <tipbot@zytor.com>
Message-ID: <tip-878f968eeb852383ff79dc3f181db24e5b52fd75@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de
In-Reply-To: <1371163284-6346-5-git-send-email-sasha.levin@oracle.com>
References: <1371163284-6346-5-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Add pthread_mutex_t test suite
Git-Commit-ID: 878f968eeb852383ff79dc3f181db24e5b52fd75
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 27 Nov 2013 06:09:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  878f968eeb852383ff79dc3f181db24e5b52fd75
Gitweb:     http://git.kernel.org/tip/878f968eeb852383ff79dc3f181db24e5b52fd75
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Thu, 13 Jun 2013 18:41:19 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 27 Nov 2013 11:55:22 +0100

liblockdep: Add pthread_mutex_t test suite

This is a rather simple and basic test suite to test common
locking issues.

Beyond tests, it also shows how to use the library.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: torvalds@linux-foundation.org
Link: http://lkml.kernel.org/r/1371163284-6346-5-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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

diff --git a/tools/lib/lockdep/run_tests.sh b/tools/lib/lockdep/run_tests.sh
new file mode 100644
index 0000000..5334ad9
--- /dev/null
+++ b/tools/lib/lockdep/run_tests.sh
@@ -0,0 +1,27 @@
+#! /bin/bash
+
+make &> /dev/null
+
+for i in `ls tests/*.c`; do
+	testname=$(basename -s .c "$i")
+	gcc -o tests/$testname -pthread -lpthread $i liblockdep.a -Iinclude -D__USE_LIBLOCKDEP &> /dev/null
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
+	gcc -o tests/$testname -pthread -lpthread -Iinclude $i &> /dev/null
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
