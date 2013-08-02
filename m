Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754256Ab3HBUGM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 16:06:12 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:63964 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab3HBUGI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 16:06:08 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Runzhen Wang <runzhen@linux.vnet.ibm.com>
Subject: [PATCH 7/9] perf kvm: option to print events that exceed a threshold
Date: Fri,  2 Aug 2013 14:05:45 -0600
Message-Id: <1375473947-64285-8-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375473947-64285-1-git-send-email-dsahern@gmail.com>
References: <1375473947-64285-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is useful to spot high latency blips.

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
 tools/perf/builtin-kvm.c |   25 +++++++++++++++++++++----
 tools/perf/perf.h        |    3 +++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 5c6e3cd..28afc05d 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -106,6 +106,7 @@ struct perf_kvm_stat {
 	u64 total_time;
 	u64 total_count;
 	u64 lost_events;
+	u64 threshold;
 
 	struct rb_root result;
 
@@ -470,7 +471,7 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 static bool handle_end_event(struct perf_kvm_stat *kvm,
 			     struct vcpu_event_record *vcpu_record,
 			     struct event_key *key,
-			     u64 timestamp)
+			     struct perf_sample *sample)
 {
 	struct kvm_event *event;
 	u64 time_begin, time_diff;
@@ -507,12 +508,24 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
 	vcpu_record->start_time = 0;
 
 	/* seems to happen once in a while during live mode */
-	if (timestamp < time_begin) {
+	if (sample->time < time_begin) {
 		pr_debug("End time before begin time; skipping event.\n");
 		return true;
 	}
 
-	time_diff = timestamp - time_begin;
+	time_diff = sample->time - time_begin;
+
+	if (kvm->threshold && time_diff > kvm->threshold) {
+		char decode[32];
+
+		kvm->events_ops->decode_key(kvm, &event->key, decode);
+		if (strcmp(decode, "HLT")) {
+			pr_info("%" PRIu64 " VM %d, vcpu %d: %s event took %" PRIu64 "usec\n",
+				 sample->time, sample->pid, vcpu_record->vcpu_id,
+				 decode, time_diff/1000);
+		}
+	}
+
 	return update_kvm_event(event, vcpu, time_diff);
 }
 
@@ -559,7 +572,7 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
 
 	if (kvm->events_ops->is_end_event(evsel, sample, &key))
-		return handle_end_event(kvm, vcpu_record, &key, sample->time);
+		return handle_end_event(kvm, vcpu_record, &key, sample);
 
 	return true;
 }
@@ -1382,6 +1395,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
 			"key for sorting: sample(sort by samples number)"
 			" time (sort by avg time)"),
+		OPT_U64('T', "threshold", &kvm->threshold,
+		    "show events that take longer than threshold usecs"),
 		OPT_END()
 	};
 	const char * const live_usage[] = {
@@ -1420,6 +1435,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 			usage_with_options(live_usage, live_options);
 	}
 
+	kvm->threshold *= NSEC_PER_USEC;   /* convert usec to nsec */
+
 	/*
 	 * target related setups
 	 */
diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 32bd102..cf20187 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -125,6 +125,9 @@
 #ifndef NSEC_PER_SEC
 # define NSEC_PER_SEC			1000000000ULL
 #endif
+#ifndef NSEC_PER_USEC
+# define NSEC_PER_USEC			1000ULL
+#endif
 
 static inline unsigned long long rdclock(void)
 {
-- 
1.7.10.1

