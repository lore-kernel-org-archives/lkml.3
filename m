Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab3BDNxB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 08:53:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60904 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752350Ab3BDNxA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 08:53:00 -0500
Date: Mon, 4 Feb 2013 05:52:38 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-804a7ae57c90188263d49621cb4f1e0bae46c5ca@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1359942644-26371-3-git-send-email-sasha.levin@oracle.com>
References: <1359942644-26371-3-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep: Add pthread_mutex_t test suite
Git-Commit-ID: 804a7ae57c90188263d49621cb4f1e0bae46c5ca
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 04 Feb 2013 05:52:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  804a7ae57c90188263d49621cb4f1e0bae46c5ca
Gitweb:     http://git.kernel.org/tip/804a7ae57c90188263d49621cb4f1e0bae46c5ca
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sun, 3 Feb 2013 20:50:40 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 4 Feb 2013 11:39:05 +0100

liblockdep: Add pthread_mutex_t test suite

This is a rather simple and basic test suite to test common
locking issues.

Beyond tests, it also shows how to use the library.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: paulus@samba.org
Cc: acme@ghostprotocols.net
Cc: penberg@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1359942644-26371-3-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
