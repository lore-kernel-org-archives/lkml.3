Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190AbaJATvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:51:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:47794 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945AbaJATvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:51:14 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <dave@stgolabs.net>,
        Davidlohr Bueso <dbueso@suse.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/8] perf bench futex: Sanitize -q option in requeue
Date: Wed,  1 Oct 2014 16:50:39 -0300
Message-Id: <1412193043-15493-5-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1412193043-15493-1-git-send-email-acme@kernel.org>
References: <1412193043-15493-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@stgolabs.net>

When given the number of threads to requeue at once by user input,
there's always the risk of this value being larger than the total number
of threads.  This doesn't make any sense, and the kernel can easily deal
with such sort of situations, hence no big deal. We should however
prevent bogus output such as:

./perf bench --repeat 2 futex requeue -q 10
Run summary [PID 22210]: Requeuing 4 threads (from [private] 0x99ef3c to 0x99ef38), 10 at a time.

[Run 1]: Requeued 10 of 4 threads in 0.0040 ms
[Run 2]: Requeued 10 of 4 threads in 0.0030 ms
Requeued 10 of 4 threads in 0.0035 ms (+-14.29%)

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
Cc: Davidlohr Bueso <dbueso@suse.de>
Link: http://lkml.kernel.org/r/1412008868-22328-2-git-send-email-dave@stgolabs.net
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bench/futex-requeue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index 9837a8831406..bedff6b5b3cf 100644
--- a/tools/perf/bench/futex-requeue.c
+++ b/tools/perf/bench/futex-requeue.c
@@ -172,6 +172,9 @@ int bench_futex_requeue(int argc, const char **argv,
 		gettimeofday(&end, NULL);
 		timersub(&end, &start, &runtime);
 
+		if (nrequeued > nthreads)
+			nrequeued = nthreads;
+
 		update_stats(&requeued_stats, nrequeued);
 		update_stats(&requeuetime_stats, runtime.tv_usec);
 
@@ -190,7 +193,6 @@ int bench_futex_requeue(int argc, const char **argv,
 			if (ret)
 				err(EXIT_FAILURE, "pthread_join");
 		}
-
 	}
 
 	/* cleanup & report results */
-- 
1.9.3

