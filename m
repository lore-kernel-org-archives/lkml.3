Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343AbaJ0UbT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 16:31:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50769 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751666AbaJ0UbS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 16:31:18 -0400
Date: Mon, 27 Oct 2014 16:31:16 -0400 (EDT)
Message-Id: <20141027.163116.627611711460671434.davem@davemloft.net>
To: dvhart@linux.intel.com
Cc: linux-kernel@vger.kernel.org, dvhart@infradead.org
Subject: Re: futex testsuite suggestion...
From: David Miller <davem@davemloft.net>
In-Reply-To: <544EAB1A.2030403@linux.intel.com>
References: <20141027.155656.1414383076601514662.davem@davemloft.net>
	<544EAB1A.2030403@linux.intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Oct 2014 13:31:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>
Date: Mon, 27 Oct 2014 13:29:14 -0700

> On 10/27/14 12:56, David Miller wrote:
>> I'd like to suggest that you add a test that triggers transparent
>> hugepages, because if an architecture doesn't implement
>> __get_user_pages_fast() such futexes cause a machine to hang.
>> 
>> I hacked up something simple that took the existing performance
>> test and made it operate in a register allocated using memalign().
>> 
>> I would suggest doing a memalign(HUGEPAGE_SIZE, HUGEPAGE_SIZE) then
>> iterating running a futex test within each normal page within that
>> hugepage.
> 
> Do you want this option for the performance tests, or would a less
> intensive functional test be sufficient?

I think a functional test is sufficient.

> I'm perfectly happy to add such a test. I'm currently buried under a
> number of other things that have resulted in futextests suffering
> somewhat. So a couple of things to help make this happen:
> 
> 1) Could you send me your hacked up test, in whatever condition?

See at the end of this email.

> 2) I'm more than happy to accept patches, but I do understand why you
> might prefer to have someone else write it :-)

I could find time to work on this. :)

diff --git a/performance/harness.h b/performance/harness.h
index a395492..5cfd09b 100644
--- a/performance/harness.h
+++ b/performance/harness.h
@@ -38,6 +38,7 @@
 #include <limits.h>
 #include <pthread.h>
 #include <stdio.h>
+#include <malloc.h>
 #include <sys/times.h>
 #include "logging.h"
 
@@ -102,35 +103,39 @@ static void * locktest_thread(void * dummy)
 static int locktest(void locktest_function(futex_t * ptr, int loops),
 		     int iterations, int threads)
 {
-	struct locktest_shared shared;
+	struct locktest_shared *shared;
 	pthread_t thread[threads];
+	void *buf;
 	int i;
 	clock_t before, after;
 	struct tms tms_before, tms_after;
 	int wall, user, system;
 	double tick;
 
-	barrier_init(&shared.barrier_before, threads);
-	barrier_init(&shared.barrier_after, threads);
-	shared.locktest_function = locktest_function;
-	shared.loops = iterations / threads;
-	shared.futex = 0;
+	buf = memalign(8 * 1024 * 1024, 8 * 1024 * 1024);
+	shared = (buf + (8 * 1024 * 1024) - sizeof(*shared));
+
+	barrier_init(&shared->barrier_before, threads);
+	barrier_init(&shared->barrier_after, threads);
+	shared->locktest_function = locktest_function;
+	shared->loops = iterations / threads;
+	shared->futex = 0;
 
 	for (i = 0; i < threads; i++)
 		if (pthread_create(thread + i, NULL, locktest_thread,
-					&shared)) {
+					shared)) {
 			error("pthread_create\n", errno);
 			/* Could not create thread; abort */
-			barrier_unblock(&shared.barrier_before, -1);
+			barrier_unblock(&shared->barrier_before, -1);
 			while (--i >= 0)
 				pthread_join(thread[i], NULL);
 			print_result(RET_ERROR);
 			return RET_ERROR;
 		}
-	barrier_wait(&shared.barrier_before);
+	barrier_wait(&shared->barrier_before);
 	before = times(&tms_before);
-	barrier_unblock(&shared.barrier_before, 1);
-	barrier_wait(&shared.barrier_after);
+	barrier_unblock(&shared->barrier_before, 1);
+	barrier_wait(&shared->barrier_after);
 	after = times(&tms_after);
 	wall = after - before;
 	user = tms_after.tms_utime - tms_before.tms_utime;
@@ -139,12 +144,12 @@ static int locktest(void locktest_function(futex_t * ptr, int loops),
 	info("%.2fs user, %.2fs system, %.2fs wall, %.2f cores\n",
 	     user * tick, system * tick, wall * tick,
 	     wall ? (user + system) * 1. / wall : 1.);
-	barrier_unblock(&shared.barrier_after, 1);
+	barrier_unblock(&shared->barrier_after, 1);
 	for (i = 0; i < threads; i++)
 		pthread_join(thread[i], NULL);
 
 	printf("Result: %.0f Kiter/s\n",
-	       (threads * shared.loops) / (wall * tick * 1000));
+	       (threads * shared->loops) / (wall * tick * 1000));
 
 	return RET_PASS;
 }
