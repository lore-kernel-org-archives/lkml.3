Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3HFBmU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 21:42:20 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:49608 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3HFBlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 21:41:52 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: xiaoguangrong@linux.vnet.ibm.com, David Ahern <dsahern@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 3/5] perf kvm: add min and max stats to display - v2
Date: Mon,  5 Aug 2013 21:41:35 -0400
Message-Id: <1375753297-69645-4-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
References: <1375753297-69645-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add max and min times for exit events.

v2: address Xia's comment to use get_event function for pulling max and
    min from stats struct similar to mean and count

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
---
 tools/perf/builtin-kvm.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 29bfca7..b6595e9 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -337,14 +337,19 @@ static void clear_events_cache_stats(struct list_head *kvm_events_cache)
 	struct list_head *head;
 	struct kvm_event *event;
 	unsigned int i;
+	int j;
 
 	for (i = 0; i < EVENTS_CACHE_SIZE; i++) {
 		head = &kvm_events_cache[i];
 		list_for_each_entry(event, head, hash_entry) {
 			/* reset stats for event */
-			memset(&event->total, 0, sizeof(event->total));
-			memset(event->vcpu, 0,
-			       event->max_vcpu * sizeof(*event->vcpu));
+			event->total.time = 0;
+			init_stats(&event->total.stats);
+
+			for (j = 0; j < event->max_vcpu; ++j) {
+				event->vcpu[j].time = 0;
+				init_stats(&event->vcpu[j].stats);
+			}
 		}
 	}
 }
@@ -583,6 +588,8 @@ static int compare_kvm_event_ ## func(struct kvm_event *one,		\
 GET_EVENT_KEY(time, time);
 COMPARE_EVENT_KEY(count, stats.n);
 COMPARE_EVENT_KEY(mean, stats.mean);
+GET_EVENT_KEY(max, stats.max);
+GET_EVENT_KEY(min, stats.min);
 
 #define DEF_SORT_NAME_KEY(name, compare_key)				\
 	{ #name, compare_kvm_event_ ## compare_key }
@@ -727,20 +734,26 @@ static void print_result(struct perf_kvm_stat *kvm)
 	pr_info("%9s ", "Samples%");
 
 	pr_info("%9s ", "Time%");
+	pr_info("%10s ", "Min Time");
+	pr_info("%10s ", "Max Time");
 	pr_info("%16s ", "Avg time");
 	pr_info("\n\n");
 
 	while ((event = pop_from_result(&kvm->result))) {
-		u64 ecount, etime;
+		u64 ecount, etime, max, min;
 
 		ecount = get_event_count(event, vcpu);
 		etime = get_event_time(event, vcpu);
+		max = get_event_max(event, vcpu);
+		min = get_event_min(event, vcpu);
 
 		kvm->events_ops->decode_key(kvm, &event->key, decode);
 		pr_info("%20s ", decode);
 		pr_info("%10llu ", (unsigned long long)ecount);
 		pr_info("%8.2f%% ", (double)ecount / kvm->total_count * 100);
 		pr_info("%8.2f%% ", (double)etime / kvm->total_time * 100);
+		pr_info("%8" PRIu64 "us ", min / 1000);
+		pr_info("%8" PRIu64 "us ", max / 1000);
 		pr_info("%9.2fus ( +-%7.2f%% )", (double)etime / ecount/1e3,
 			kvm_event_rel_stddev(vcpu, event));
 		pr_info("\n");
-- 
1.7.10.1

