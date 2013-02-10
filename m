Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760976Ab3BJAkP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 19:40:15 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:40760 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758493Ab3BJAkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 19:40:06 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: mingo@kernel.org, peterz@infradead.org
Cc: jamie.iles@oracle.com, penberg@kernel.org, acme@ghostprotocols.net,
        paulus@samba.org, linux-kernel@vger.kernel.org, namhyung@kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH v2 02/11] liblockdep: remove the need for liblockdep_set_thread
Date: Sat,  9 Feb 2013 19:39:32 -0500
Message-Id: <1360456781-32462-2-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Generate the task_struct data on the fly when needed, instead on on
thread creation.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 tools/lib/lockdep/common.c                    | 8 +++++---
 tools/lib/lockdep/include/liblockdep/common.h | 1 -
 tools/lib/lockdep/tests/AA.c                  | 2 --
 tools/lib/lockdep/tests/ABBA.c                | 2 --
 tools/lib/lockdep/tests/ABBCCA.c              | 2 --
 tools/lib/lockdep/tests/ABBCCDDA.c            | 2 --
 tools/lib/lockdep/tests/ABCABC.c              | 2 --
 tools/lib/lockdep/tests/ABCDBCDA.c            | 2 --
 tools/lib/lockdep/tests/ABCDBDDA.c            | 2 --
 tools/lib/lockdep/tests/WW.c                  | 2 --
 tools/lib/lockdep/tests/unlock_balance.c      | 2 --
 tools/lib/lockdep/uinclude/linux/lockdep.h    | 4 ++--
 12 files changed, 7 insertions(+), 24 deletions(-)

diff --git a/tools/lib/lockdep/common.c b/tools/lib/lockdep/common.c
index d2946e0..c0f1166 100644
--- a/tools/lib/lockdep/common.c
+++ b/tools/lib/lockdep/common.c
@@ -15,8 +15,10 @@ __attribute__((constructor)) static void liblockdep_init(void)
 	lockdep_init();
 }
 
-void liblockdep_set_thread(void)
+struct task_struct *__curr(void)
 {
-	prctl(PR_GET_NAME, current->comm);
-	current->pid = syscall(__NR_gettid);
+	prctl(PR_GET_NAME, current_obj.comm);
+	current_obj.pid = syscall(__NR_gettid);
+
+	return &current_obj;
 }
diff --git a/tools/lib/lockdep/include/liblockdep/common.h b/tools/lib/lockdep/include/liblockdep/common.h
index f6f7fec8..a675ef0 100644
--- a/tools/lib/lockdep/include/liblockdep/common.h
+++ b/tools/lib/lockdep/include/liblockdep/common.h
@@ -26,7 +26,6 @@ struct lockdep_map {
 #endif
 };
 
-void liblockdep_set_thread(void);
 void lockdep_init_map(struct lockdep_map *lock, const char *name,
 			struct lock_class_key *key, int subclass);
 void lock_acquire(struct lockdep_map *lock, unsigned int subclass,
diff --git a/tools/lib/lockdep/tests/AA.c b/tools/lib/lockdep/tests/AA.c
index 3f71333..a443e65 100644
--- a/tools/lib/lockdep/tests/AA.c
+++ b/tools/lib/lockdep/tests/AA.c
@@ -4,8 +4,6 @@ void main(void)
 {
 	pthread_mutex_t a, b;
 
-	liblockdep_set_thread();
-
 	pthread_mutex_init(&a, NULL);
 	pthread_mutex_init(&b, NULL);
 
diff --git a/tools/lib/lockdep/tests/ABBA.c b/tools/lib/lockdep/tests/ABBA.c
index 08d87a7..07f0e29 100644
--- a/tools/lib/lockdep/tests/ABBA.c
+++ b/tools/lib/lockdep/tests/ABBA.c
@@ -5,8 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b;
 
-	liblockdep_set_thread();
-
 	pthread_mutex_init(&a, NULL);
 	pthread_mutex_init(&b, NULL);
 
diff --git a/tools/lib/lockdep/tests/ABBCCA.c b/tools/lib/lockdep/tests/ABBCCA.c
index c5d0e5c..843db09 100644
--- a/tools/lib/lockdep/tests/ABBCCA.c
+++ b/tools/lib/lockdep/tests/ABBCCA.c
@@ -5,8 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b, c;
 
-	liblockdep_set_thread();
-
 	pthread_mutex_init(&a, NULL);
 	pthread_mutex_init(&b, NULL);
 	pthread_mutex_init(&c, NULL);
diff --git a/tools/lib/lockdep/tests/ABBCCDDA.c b/tools/lib/lockdep/tests/ABBCCDDA.c
index e12dc98..33620e2 100644
--- a/tools/lib/lockdep/tests/ABBCCDDA.c
+++ b/tools/lib/lockdep/tests/ABBCCDDA.c
@@ -5,8 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b, c, d;
 
-	liblockdep_set_thread();
-
 	pthread_mutex_init(&a, NULL);
 	pthread_mutex_init(&b, NULL);
 	pthread_mutex_init(&c, NULL);
diff --git a/tools/lib/lockdep/tests/ABCABC.c b/tools/lib/lockdep/tests/ABCABC.c
index 70879c95..3fee51e 100644
--- a/tools/lib/lockdep/tests/ABCABC.c
+++ b/tools/lib/lockdep/tests/ABCABC.c
@@ -5,8 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b, c;
 
-	liblockdep_set_thread();
-
 	pthread_mutex_init(&a, NULL);
 	pthread_mutex_init(&b, NULL);
 	pthread_mutex_init(&c, NULL);
diff --git a/tools/lib/lockdep/tests/ABCDBCDA.c b/tools/lib/lockdep/tests/ABCDBCDA.c
index 00cd676..aadf11e 100644
--- a/tools/lib/lockdep/tests/ABCDBCDA.c
+++ b/tools/lib/lockdep/tests/ABCDBCDA.c
@@ -5,8 +5,6 @@ void main(void)
 {
 	liblockdep_pthread_mutex_t a, b, c, d;
 
-	liblockdep_set_thread();
-
 	liblockdep_pthread_mutex_init(&a, NULL);
 	liblockdep_pthread_mutex_init(&b, NULL);
 	liblockdep_pthread_mutex_init(&c, NULL);
diff --git a/tools/lib/lockdep/tests/ABCDBDDA.c b/tools/lib/lockdep/tests/ABCDBDDA.c
index 19b3ed1..680c6cf 100644
--- a/tools/lib/lockdep/tests/ABCDBDDA.c
+++ b/tools/lib/lockdep/tests/ABCDBDDA.c
@@ -5,8 +5,6 @@ void main(void)
 {
 	pthread_mutex_t a, b, c, d;
 
-	liblockdep_set_thread();
-
 	pthread_mutex_init(&a, NULL);
 	pthread_mutex_init(&b, NULL);
 	pthread_mutex_init(&c, NULL);
diff --git a/tools/lib/lockdep/tests/WW.c b/tools/lib/lockdep/tests/WW.c
index 2467b13..d44f77d 100644
--- a/tools/lib/lockdep/tests/WW.c
+++ b/tools/lib/lockdep/tests/WW.c
@@ -4,8 +4,6 @@ void main(void)
 {
 	pthread_rwlock_t a, b;
 
-	liblockdep_set_thread();
-
 	pthread_rwlock_init(&a, NULL);
 	pthread_rwlock_init(&b, NULL);
 
diff --git a/tools/lib/lockdep/tests/unlock_balance.c b/tools/lib/lockdep/tests/unlock_balance.c
index 07a4c21..0bc62de 100644
--- a/tools/lib/lockdep/tests/unlock_balance.c
+++ b/tools/lib/lockdep/tests/unlock_balance.c
@@ -4,8 +4,6 @@ void main(void)
 {
 	pthread_mutex_t a;
 
-	liblockdep_set_thread();
-
 	pthread_mutex_init(&a, NULL);
 
 	pthread_mutex_lock(&a);
diff --git a/tools/lib/lockdep/uinclude/linux/lockdep.h b/tools/lib/lockdep/uinclude/linux/lockdep.h
index 611cb28..52609c5 100644
--- a/tools/lib/lockdep/uinclude/linux/lockdep.h
+++ b/tools/lib/lockdep/uinclude/linux/lockdep.h
@@ -23,9 +23,9 @@ struct task_struct {
 };
 
 extern __thread struct task_struct current_obj;
-#define current (&current_obj)
+extern struct task_struct *__curr(void);
 
-void liblockdep_set_thread(void);
+#define current (__curr())
 
 #define debug_locks_off() 1
 #define task_pid_nr(tsk) ((tsk)->pid)
-- 
1.8.1.2

