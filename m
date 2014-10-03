Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaJCF0I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 01:26:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60711 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbaJCF0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 01:26:05 -0400
Date: Thu, 2 Oct 2014 22:25:53 -0700
From: tip-bot for Davidlohr Bueso <tipbot@zytor.com>
Message-ID: <tip-e19685ed24b518440c0717719ff02e74c0e6d2cb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, dave@stgolabs.net, tglx@linutronix.de,
        dbueso@suse.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, dave@stgolabs.net, tglx@linutronix.de, dbueso@suse.de
In-Reply-To: <1412008868-22328-2-git-send-email-dave@stgolabs.net>
References: <1412008868-22328-2-git-send-email-dave@stgolabs.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf bench futex: Sanitize -q option in requeue
Git-Commit-ID: e19685ed24b518440c0717719ff02e74c0e6d2cb
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

Commit-ID:  e19685ed24b518440c0717719ff02e74c0e6d2cb
Gitweb:     http://git.kernel.org/tip/e19685ed24b518440c0717719ff02e74c0e6d2cb
Author:     Davidlohr Bueso <dave@stgolabs.net>
AuthorDate: Mon, 29 Sep 2014 09:41:08 -0700
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Sep 2014 15:43:26 -0300

perf bench futex: Sanitize -q option in requeue

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
