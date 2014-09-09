Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476AbaIIJ7C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 05:59:02 -0400
Received: from service87.mimecast.com ([91.220.42.44]:43118 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756128AbaIIJ5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 05:57:08 -0400
From: Juri Lelli <juri.lelli@arm.com>
To: peterz@infradead.org
Cc: luca.abeni@unitn.it, rdunlap@infradead.org, mingo@redhat.com,
        henrik@austad.us, raistlin@linux.it, juri.lelli@gmail.com,
        juri.lelli@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v4 5/5] Documentation/scheduler/sched-deadline.txt: add minimal main() appendix
Date: Tue,  9 Sep 2014 10:57:16 +0100
Message-Id: <1410256636-26171-6-git-send-email-juri.lelli@arm.com>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410256636-26171-1-git-send-email-juri.lelli@arm.com>
References: <1410256636-26171-1-git-send-email-juri.lelli@arm.com>
X-OriginalArrivalTime: 09 Sep 2014 09:57:04.0892 (UTC) FILETIME=[68EEB3C0:01CFCC14]
X-MC-Unique: 114090910570701701
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id s899x7QR005212

Add an appendix providing a simple self-contained code snippet showing
how SCHED_DEADLINE reservations can be created by application developers.

Signed-off-by: Juri Lelli <juri.lelli@arm.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Henrik Austad <henrik@austad.us>
Cc: Dario Faggioli <raistlin@linux.it>
Cc: Juri Lelli <juri.lelli@gmail.com>
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
---
 Documentation/scheduler/sched-deadline.txt | 126 +++++++++++++++++++++++++++++
 1 file changed, 126 insertions(+)

diff --git a/Documentation/scheduler/sched-deadline.txt b/Documentation/scheduler/sched-deadline.txt
index b4aad31..cd8274c 100644
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
+ 	__u32 size;
+
+ 	__u32 sched_policy;
+ 	__u64 sched_flags;
+
+ 	/* SCHED_NORMAL, SCHED_BATCH */
+ 	__s32 sched_nice;
+
+ 	/* SCHED_FIFO, SCHED_RR */
+ 	__u32 sched_priority;
+
+ 	/* SCHED_DEADLINE (nsec) */
+ 	__u64 sched_runtime;
+ 	__u64 sched_deadline;
+ 	__u64 sched_period;
+ };
+
+ int sched_setattr(pid_t pid,
+ 		  const struct sched_attr *attr,
+ 		  unsigned int flags)
+ {
+ 	return syscall(__NR_sched_setattr, pid, attr, flags);
+ }
+
+ int sched_getattr(pid_t pid,
+ 		  struct sched_attr *attr,
+ 		  unsigned int size,
+ 		  unsigned int flags)
+ {
+ 	return syscall(__NR_sched_getattr, pid, attr, size, flags);
+ }
+
+ void *run_deadline(void *data)
+ {
+ 	struct sched_attr attr;
+ 	int x = 0;
+ 	int ret;
+ 	unsigned int flags = 0;
+
+ 	printf("deadline thread started [%ld]\n", gettid());
+
+ 	attr.size = sizeof(attr);
+ 	attr.sched_flags = 0;
+ 	attr.sched_nice = 0;
+ 	attr.sched_priority = 0;
+
+ 	/* This creates a 10ms/30ms reservation */
+ 	attr.sched_policy = SCHED_DEADLINE;
+ 	attr.sched_runtime = 10 * 1000 * 1000;
+ 	attr.sched_period = attr.sched_deadline = 30 * 1000 * 1000;
+
+ 	ret = sched_setattr(0, &attr, flags);
+ 	if (ret < 0) {
+ 		done = 0;
+ 		perror("sched_setattr");
+ 		exit(-1);
+ 	}
+
+ 	while (!done) {
+ 		x++;
+ 	}
+
+ 	printf("deadline thread dies [%ld]\n", gettid());
+ 	return NULL;
+ }
+
+ int main (int argc, char **argv)
+ {
+ 	pthread_t thread;
+
+ 	printf("main thread [%ld]\n", gettid());
+
+ 	pthread_create(&thread, NULL, run_deadline, NULL);
+
+ 	sleep(10);
+
+ 	done = 1;
+ 	pthread_join(thread, NULL);
+
+ 	printf("main dies [%ld]\n", gettid());
+ 	return 0;
+ }
-- 
2.0.4


