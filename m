Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757272Ab3DAMql (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 08:46:41 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:52041 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757150Ab3DAMqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 08:46:40 -0400
X-AuditID: 9c93016f-b7b6aae000000e9c-22-515981adebb9
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH 3/3] ftrace: Constify ftrace_profile_bits
Date: Mon,  1 Apr 2013 21:46:25 +0900
Message-Id: <1364820385-32027-3-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1364820385-32027-1-git-send-email-namhyung@kernel.org>
References: <1364820385-32027-1-git-send-email-namhyung@kernel.org>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It seems that function profiler's hash size is fixed at 1024.
Make the ftrace_profile_bits const and update hash size macro.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d38ad7145f2f..08bbc5952a3a 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -486,7 +486,6 @@ struct ftrace_profile_stat {
 #define PROFILES_PER_PAGE					\
 	(PROFILE_RECORDS_SIZE / sizeof(struct ftrace_profile))
 
-static int ftrace_profile_bits __read_mostly;
 static int ftrace_profile_enabled __read_mostly;
 
 /* ftrace_profile_lock - synchronize the enable and disable of the profiler */
@@ -494,7 +493,10 @@ static DEFINE_MUTEX(ftrace_profile_lock);
 
 static DEFINE_PER_CPU(struct ftrace_profile_stat, ftrace_profile_stats);
 
-#define FTRACE_PROFILE_HASH_SIZE 1024 /* must be power of 2 */
+#define FTRACE_PROFILE_HASH_BITS 10
+#define FTRACE_PROFILE_HASH_SIZE (1 << FTRACE_PROFILE_HASH_BITS)
+
+static const int ftrace_profile_bits = FTRACE_PROFILE_HASH_BITS;
 
 static void *
 function_stat_next(void *v, int idx)
@@ -724,13 +726,6 @@ static int ftrace_profile_init_cpu(int cpu)
 	if (!stat->hash)
 		return -ENOMEM;
 
-	if (!ftrace_profile_bits) {
-		size--;
-
-		for (; size; size >>= 1)
-			ftrace_profile_bits++;
-	}
-
 	/* Preallocate the function profiling pages */
 	if (ftrace_profile_pages_init(stat) < 0) {
 		kfree(stat->hash);
-- 
1.7.11.7

