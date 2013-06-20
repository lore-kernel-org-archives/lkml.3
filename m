Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab3FTHjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 03:39:51 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:55728 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3FTHju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 03:39:50 -0400
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: acme@ghostprotocols.net
Cc: namhyung@kernel.org, mingo@redhat.com, linux-kernel@vger.kernel.org,
        Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH v3] perf: fix bench numa compilation
Date: Thu, 20 Jun 2013 09:39:45 +0200
Message-Id: <1371713985-1694-1-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <20130619172310.GA2818@ghostprotocols.net>
References: <20130619172310.GA2818@ghostprotocols.net>
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
 tools/perf/bench/numa.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Changes since v2:
- use PRIu64 as suggested by Arnaldo Carvalho da Melo

diff --git a/tools/perf/bench/numa.c b/tools/perf/bench/numa.c
index 30d1c32..f5c0834 100644
--- a/tools/perf/bench/numa.c
+++ b/tools/perf/bench/numa.c
@@ -21,6 +21,7 @@
 #include <string.h>
 #include <unistd.h>
 #include <pthread.h>
+#include <inttypes.h>
 #include <sys/mman.h>
 #include <sys/time.h>
 #include <sys/wait.h>
@@ -1110,7 +1111,7 @@ static void *worker_thread(void *__tdata)
 		/* Check whether our max runtime timed out: */
 		if (g->p.nr_secs) {
 			timersub(&stop, &start0, &diff);
-			if (diff.tv_sec >= g->p.nr_secs) {
+			if (diff.tv_sec >= (long int)g->p.nr_secs) {
 				g->stop_work = true;
 				break;
 			}
@@ -1157,7 +1158,7 @@ static void *worker_thread(void *__tdata)
 			runtime_ns_max += diff.tv_usec * 1000;
 
 			if (details >= 0) {
-				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016lx]\n",
+				printf(" #%2d / %2d: %14.2lf nsecs/op [val: %016"PRIu64"x]\n",
 					process_nr, thread_nr, runtime_ns_max / bytes_done, val);
 			}
 			fflush(stdout);
-- 
1.8.3.1

