Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935849Ab3DIX4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 19:56:01 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:58673 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935092Ab3DIX4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 19:56:00 -0400
X-AuditID: 9c930179-b7b2aae000000518-39-5164aa8bbbe6
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: [PATCH v2 3/3] ftrace: Get rid of ftrace_profile_bits
Date: Wed, 10 Apr 2013 08:55:50 +0900
Message-Id: <1365551750-4504-1-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1365548611.25498.79.camel@gandalf.local.home>
References: <1365548611.25498.79.camel@gandalf.local.home>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

It seems that function profiler's hash size is fixed at 1024.  Add and
use FTRACE_PROFILE_HASH_BITS instead and update hash size macro.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 kernel/trace/ftrace.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index d38ad7145f2f..78f4398cb608 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -486,7 +486,6 @@ struct ftrace_profile_stat {
 #define PROFILES_PER_PAGE					\
 	(PROFILE_RECORDS_SIZE / sizeof(struct ftrace_profile))
 
-static int ftrace_profile_bits __read_mostly;
 static int ftrace_profile_enabled __read_mostly;
 
 /* ftrace_profile_lock - synchronize the enable and disable of the profiler */
@@ -494,7 +493,8 @@ static DEFINE_MUTEX(ftrace_profile_lock);
 
 static DEFINE_PER_CPU(struct ftrace_profile_stat, ftrace_profile_stats);
 
-#define FTRACE_PROFILE_HASH_SIZE 1024 /* must be power of 2 */
+#define FTRACE_PROFILE_HASH_BITS 10
+#define FTRACE_PROFILE_HASH_SIZE (1 << FTRACE_PROFILE_HASH_BITS)
 
 static void *
 function_stat_next(void *v, int idx)
@@ -724,13 +724,6 @@ static int ftrace_profile_init_cpu(int cpu)
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
@@ -764,7 +757,7 @@ ftrace_find_profiled_func(struct ftrace_profile_stat *stat, unsigned long ip)
 	struct hlist_node *n;
 	unsigned long key;
 
-	key = hash_long(ip, ftrace_profile_bits);
+	key = hash_long(ip, FTRACE_PROFILE_HASH_BITS);
 	hhd = &stat->hash[key];
 
 	if (hlist_empty(hhd))
@@ -783,7 +776,7 @@ static void ftrace_add_profile(struct ftrace_profile_stat *stat,
 {
 	unsigned long key;
 
-	key = hash_long(rec->ip, ftrace_profile_bits);
+	key = hash_long(rec->ip, FTRACE_PROFILE_HASH_BITS);
 	hlist_add_head_rcu(&rec->node, &stat->hash[key]);
 }
 
-- 
1.7.11.7

