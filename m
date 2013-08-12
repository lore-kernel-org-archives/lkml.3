Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab3HLKYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:24:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48158 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755936Ab3HLKYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:24:06 -0400
Date: Mon, 12 Aug 2013 03:23:22 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-62d04dbf3652264157e646d93006b2d74cf1be93@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, namhyung@kernel.org,
        runzhen@linux.vnet.ibm.com, jolsa@redhat.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, peterz@infradead.org, namhyung@kernel.org,
        jolsa@redhat.com, runzhen@linux.vnet.ibm.com, fweisbec@gmail.com,
        xiaoguangrong@linux.vnet.ibm.com, dsahern@gmail.com,
        tglx@linutronix.de
In-Reply-To: <1375753297-69645-4-git-send-email-dsahern@gmail.com>
References: <1375753297-69645-4-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm: Add min and max stats to display
Git-Commit-ID: 62d04dbf3652264157e646d93006b2d74cf1be93
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Mon, 12 Aug 2013 03:23:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62d04dbf3652264157e646d93006b2d74cf1be93
Gitweb:     http://git.kernel.org/tip/62d04dbf3652264157e646d93006b2d74cf1be93
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Mon, 5 Aug 2013 21:41:35 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 7 Aug 2013 17:35:38 -0300

perf kvm: Add min and max stats to display

Add max and min times for exit events.

v2: address Xiao's comment to use get_event function for pulling max and
    min from stats struct similar to mean and count

Signed-off-by: David Ahern <dsahern@gmail.com>
Reviewed-by: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375753297-69645-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 21 +++++++++++++++++----
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
