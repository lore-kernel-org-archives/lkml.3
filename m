Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754977AbaI2Qlp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 12:41:45 -0400
Received: from homie.mail.dreamhost.com ([208.97.132.208]:48252 "EHLO
	homiemail-a62.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754045AbaI2Qlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 12:41:42 -0400
From: Davidlohr Bueso <dave@stgolabs.net>
To: acme@kernel.org
Cc: dave@stgolabs.net, linux-kernel@vger.kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: [PATCH 2/2] perf bench: futex: Sanitize -q option in requeue
Date: Mon, 29 Sep 2014 09:41:08 -0700
Message-Id: <1412008868-22328-2-git-send-email-dave@stgolabs.net>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1412008868-22328-1-git-send-email-dave@stgolabs.net>
References: <1412008868-22328-1-git-send-email-dave@stgolabs.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When given the number of threads to requeue at once by
user input, there's always the risk of this value being
larger than the total number of threads. This doesn't
make any sense, and the kernel can easily deal with
such sort of situations, hence no big deal. We should
however prevent bogus output such as:

./perf bench --repeat 2 futex requeue -q 10
Run summary [PID 22210]: Requeuing 4 threads (from [private] 0x99ef3c to 0x99ef38), 10 at a time.

[Run 1]: Requeued 10 of 4 threads in 0.0040 ms
[Run 2]: Requeued 10 of 4 threads in 0.0030 ms
Requeued 10 of 4 threads in 0.0035 ms (+-14.29%)

Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
---
 tools/perf/bench/futex-requeue.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/bench/futex-requeue.c b/tools/perf/bench/futex-requeue.c
index 9837a88..bedff6b 100644
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
1.8.4.5

