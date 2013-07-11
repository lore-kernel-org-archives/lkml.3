Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3GKQ14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 12:27:56 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:52738 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754451Ab3GKQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 12:27:12 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 09/11] perf kvm: add min and max stats to display
Date: Thu, 11 Jul 2013 10:26:40 -0600
Message-Id: <1373560002-14618-10-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
References: <1373560002-14618-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
 tools/perf/builtin-kvm.c |   21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 15fdf54..9336737 100644
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
@@ -718,6 +723,7 @@ static void print_result(struct perf_kvm_stat *kvm)
 	char decode[20];
 	struct kvm_event *event;
 	int vcpu = kvm->trace_vcpu;
+	struct kvm_event_stats *kvm_stats;
 
 	if (kvm->live) {
 		puts(CONSOLE_CLEAR);
@@ -731,6 +737,8 @@ static void print_result(struct perf_kvm_stat *kvm)
 	pr_info("%9s ", "Samples%");
 
 	pr_info("%9s ", "Time%");
+	pr_info("%10s ", "Min Time");
+	pr_info("%10s ", "Max Time");
 	pr_info("%16s ", "Avg time");
 	pr_info("\n\n");
 
@@ -740,11 +748,18 @@ static void print_result(struct perf_kvm_stat *kvm)
 		ecount = get_event_count(event, vcpu);
 		etime = get_event_time(event, vcpu);
 
+		if (vcpu == -1)
+			kvm_stats = &event->total;
+		else
+			kvm_stats = &event->vcpu[vcpu];
+
 		kvm->events_ops->decode_key(kvm, &event->key, decode);
 		pr_info("%20s ", decode);
 		pr_info("%10llu ", (unsigned long long)ecount);
 		pr_info("%8.2f%% ", (double)ecount / kvm->total_count * 100);
 		pr_info("%8.2f%% ", (double)etime / kvm->total_time * 100);
+		pr_info("%8" PRIu64 "us ", kvm_stats->stats.min / 1000);
+		pr_info("%8" PRIu64 "us ", kvm_stats->stats.max / 1000);
 		pr_info("%9.2fus ( +-%7.2f%% )", (double)etime / ecount/1e3,
 			kvm_event_rel_stddev(vcpu, event));
 		pr_info("\n");
-- 
1.7.10.1

