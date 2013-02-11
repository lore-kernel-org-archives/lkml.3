Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756763Ab3BKMWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 07:22:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59986 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756674Ab3BKMWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 07:22:49 -0500
Date: Mon, 11 Feb 2013 04:22:27 -0800
From: tip-bot for Sasha Levin <sasha.levin@oracle.com>
Message-ID: <tip-4d81b02bbc6aa485e9cf0bdb6951b7b1b4952bb8@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <1360456781-32462-2-git-send-email-sasha.levin@oracle.com>
References: <1360456781-32462-2-git-send-email-sasha.levin@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:core/locking] liblockdep:
  Remove the need for liblockdep_set_thread()
Git-Commit-ID: 4d81b02bbc6aa485e9cf0bdb6951b7b1b4952bb8
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 11 Feb 2013 04:22:33 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4d81b02bbc6aa485e9cf0bdb6951b7b1b4952bb8
Gitweb:     http://git.kernel.org/tip/4d81b02bbc6aa485e9cf0bdb6951b7b1b4952bb8
Author:     Sasha Levin <sasha.levin@oracle.com>
AuthorDate: Sat, 9 Feb 2013 19:39:32 -0500
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Feb 2013 10:12:36 +0100

liblockdep: Remove the need for liblockdep_set_thread()

Generate the task_struct data on the fly when needed, instead on
on thread creation.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Cc: jamie.iles@oracle.com
Cc: penberg@kernel.org
Cc: acme@ghostprotocols.net
Cc: paulus@samba.org
Cc: namhyung@kernel.org
Cc: peterz@infradead.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lkml.kernel.org/r/1360456781-32462-2-git-send-email-sasha.levin@oracle.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
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
