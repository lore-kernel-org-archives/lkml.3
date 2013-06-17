Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab3FQKzW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 06:55:22 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:63957 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756164Ab3FQKzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 06:55:21 -0400
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: namhyung@kernel.org, acme@ghostprotocols.net
Cc: mingo@redhat.com, linux-kernel@vger.kernel.org,
        Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH] perf: fix bench numa compilation
Date: Mon, 17 Jun 2013 12:54:59 +0200
Message-Id: <1371466499-28291-1-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <8761xd2k1c.fsf@sejong.aot.lge.com>
References: <8761xd2k1c.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix the following errors on gcc 4.8.1 / x86:

bench/numa.c: In function ‘worker_thread’:
bench/numa.c:1113:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
    if (diff.tv_sec >= g->p.nr_secs) {
                    ^
bench/numa.c:1161:6: error: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 5 has type ‘u64’ [-Werror=format=]
      process_nr, thread_nr, runtime_ns_max / bytes_done, val);
      ^

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 tools/perf/bench/numa.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

changes from v1:
- make it actually work on 64bit too as reported by Namhyung Kim

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 30d1c32..bd501454 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -1110,7 +1110,7 @@ static void *worker_thread(void *__tdata)
 		/* Check whether our max runtime timed out: */
 		if (g->p.nr_secs) {
 			timersub(&stop, &start0, &diff);
-			if (diff.tv_sec >= g->p.nr_secs) {
+			if (diff.tv_sec >= (long int)g->p.nr_secs) {
 				g->stop_work = true;
 				break;
 			}
@@ -1157,8 +1157,8 @@ static void *worker_thread(void *__tdata)
 			runtime_ns_max += diff.tv_usec * 1000;
 
 			if (details >= 0) {
-				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
-					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
+				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016llx]\n",
+					process_nr, thread_nr, runtime_ns_max / bytes_done, (unsigned long long)val);
 			}
 			fflush(stdout);
 		}
-- 
1.8.3.1

