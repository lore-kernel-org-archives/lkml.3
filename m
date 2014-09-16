Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957AbaIPK66 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 06:58:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43694 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbaIPK6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 06:58:55 -0400
Date: Tue, 16 Sep 2014 03:57:45 -0700
From: tip-bot for Juri Lelli <tipbot@zytor.com>
Message-ID: <tip-13924d2a983fc1557eb737ea59e2324adb538fa2@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        henrik@austad.us, torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, raistlin@linux.it, juri.lelli@arm.com,
        tglx@linutronix.de, juri.lelli@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        henrik@austad.us, torvalds@linux-foundation.org, peterz@infradead.org,
        rdunlap@infradead.org, raistlin@linux.it, juri.lelli@arm.com,
        tglx@linutronix.de, juri.lelli@gmail.com
In-Reply-To: <1410256636-26171-6-git-send-email-juri.lelli@arm.com>
References: <1410256636-26171-6-git-send-email-juri.lelli@arm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] Documentation/scheduler/sched-deadline.txt:
  Add minimal main() appendix
Git-Commit-ID: 13924d2a983fc1557eb737ea59e2324adb538fa2
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  13924d2a983fc1557eb737ea59e2324adb538fa2
Gitweb:     http://git.kernel.org/tip/13924d2a983fc1557eb737ea59e2324adb538fa2
Author:     Juri Lelli <juri.lelli@arm.com>
AuthorDate: Tue, 9 Sep 2014 10:57:16 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 16 Sep 2014 10:23:45 +0200

Documentation/scheduler/sched-deadline.txt: Add minimal main() appendix

Add an appendix providing a simple self-contained code snippet
showing how SCHED_DEADLINE reservations can be created by
application developers.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Reviewed-by: Henrik Austad <henrik@austad.us>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1410256636-26171-6-git-send-email-juri.lelli@arm.com
[ Fixed some whitespace inconsistencies. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 Documentation/scheduler/sched-deadline.txt | 126 +++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index b4aad31..21461a0 100644
--- a/Documentation/scheduler/sched-deadline.txt
+++ b/Documentation/scheduler/sched-deadline.txt
@@ -16,6 +16,7 @@ CONTENTS
    5.1 SCHED_DEADLINE and cpusets HOWTO
  6. Future plans
  A. Test suite
+ B. Minimal main()
 
 
 0. WARNING
@@ -397,3 +398,128 @@ Appendix A. Test suite
  application, given that you know its pid:
 
   # schedtool -E -t 10000000:100000000 my_app_pid
+
+Appendix B. Minimal main()
+==========================
+
+ We provide in what follows a simple (ugly) self-contained code snippet
+ showing how SCHED_DEADLINE reservations can be created by a real-time
+ application developer.
+
+ #define _GNU_SOURCE
+ #include <unistd.h>
+ #include <stdio.h>
+ #include <stdlib.h>
+ #include <string.h>
+ #include <time.h>
+ #include <linux/unistd.h>
+ #include <linux/kernel.h>
+ #include <linux/types.h>
+ #include <sys/syscall.h>
+ #include <pthread.h>
+
+ #define gettid() syscall(__NR_gettid)
+
+ #define SCHED_DEADLINE	6
+
+ /* XXX use the proper syscall numbers */
+ #ifdef __x86_64__
+ #define __NR_sched_setattr		314
+ #define __NR_sched_getattr		315
+ #endif
+
+ #ifdef __i386__
+ #define __NR_sched_setattr		351
+ #define __NR_sched_getattr		352
+ #endif
+
+ #ifdef __arm__
+ #define __NR_sched_setattr		380
+ #define __NR_sched_getattr		381
+ #endif
+
+ static volatile int done;
+
+ struct sched_attr {
+	__u32 size;
+
+	__u32 sched_policy;
+	__u64 sched_flags;
+
+	/* SCHED_NORMAL, SCHED_BATCH */
+	__s32 sched_nice;
+
+	/* SCHED_FIFO, SCHED_RR */
+	__u32 sched_priority;
+
+	/* SCHED_DEADLINE (nsec) */
+	__u64 sched_runtime;
+	__u64 sched_deadline;
+	__u64 sched_period;
+ };
+
+ int sched_setattr(pid_t pid,
+		  const struct sched_attr *attr,
+		  unsigned int flags)
+ {
+	return syscall(__NR_sched_setattr, pid, attr, flags);
+ }
+
+ int sched_getattr(pid_t pid,
+		  struct sched_attr *attr,
+		  unsigned int size,
+		  unsigned int flags)
+ {
+	return syscall(__NR_sched_getattr, pid, attr, size, flags);
+ }
+
+ void *run_deadline(void *data)
+ {
+	struct sched_attr attr;
+	int x = 0;
+	int ret;
+	unsigned int flags = 0;
+
+	printf("deadline thread started [%ld]\n", gettid());
+
+	attr.size = sizeof(attr);
+	attr.sched_flags = 0;
+	attr.sched_nice = 0;
+	attr.sched_priority = 0;
+
+	/* This creates a 10ms/30ms reservation */
+	attr.sched_policy = SCHED_DEADLINE;
+	attr.sched_runtime = 10 * 1000 * 1000;
+	attr.sched_period = attr.sched_deadline = 30 * 1000 * 1000;
+
+	ret = sched_setattr(0, &attr, flags);
+	if (ret < 0) {
+		done = 0;
+		perror("sched_setattr");
+		exit(-1);
+	}
+
+	while (!done) {
+		x++;
+	}
+
+	printf("deadline thread dies [%ld]\n", gettid());
+	return NULL;
+ }
+
+ int main (int argc, char **argv)
+ {
+	pthread_t thread;
+
+	printf("main thread [%ld]\n", gettid());
+
+	pthread_create(&thread, NULL, run_deadline, NULL);
+
+	sleep(10);
+
+	done = 1;
+	pthread_join(thread, NULL);
+
+	printf("main dies [%ld]\n", gettid());
+	return 0;
+ }
