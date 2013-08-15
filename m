Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754741Ab3HOHzi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 03:55:38 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53832 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028Ab3HOHze (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 03:55:34 -0400
Date: Thu, 15 Aug 2013 00:54:46 -0700
From: tip-bot for David Ahern <tipbot@zytor.com>
Message-ID: <tip-70f7b4a7f3f9a46807b644aa0fcfa7daa0d553e4@git.kernel.org>
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
In-Reply-To: <1375926999-75129-1-git-send-email-dsahern@gmail.com>
References: <1375926999-75129-1-git-send-email-dsahern@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kvm:
  Option to print events that exceed a duration
Git-Commit-ID: 70f7b4a7f3f9a46807b644aa0fcfa7daa0d553e4
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 15 Aug 2013 00:54:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  70f7b4a7f3f9a46807b644aa0fcfa7daa0d553e4
Gitweb:     http://git.kernel.org/tip/70f7b4a7f3f9a46807b644aa0fcfa7daa0d553e4
Author:     David Ahern <dsahern@gmail.com>
AuthorDate: Wed, 7 Aug 2013 21:56:38 -0400
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 12 Aug 2013 10:31:04 -0300

perf kvm: Option to print events that exceed a duration

This is useful to spot high latency blips. It is normal for HLT reasons
to have long exit times, so strip those from the duration check.

v2: changed threshold to duration per acme's request

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Runzhen Wang <runzhen@linux.vnet.ibm.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/1375926999-75129-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kvm.c | 25 +++++++++++++++++++++----
 tools/perf/perf.h        |  3 +++
 2 files changed, 24 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 2ceec81..fa2f3d7 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -106,6 +106,7 @@ struct perf_kvm_stat {
 	u64 total_time;
 	u64 total_count;
 	u64 lost_events;
+	u64 duration;
 
 	const char *pid_str;
 	struct intlist *pid_list;
@@ -473,7 +474,7 @@ static bool update_kvm_event(struct kvm_event *event, int vcpu_id,
 static bool handle_end_event(struct perf_kvm_stat *kvm,
 			     struct vcpu_event_record *vcpu_record,
 			     struct event_key *key,
-			     u64 timestamp)
+			     struct perf_sample *sample)
 {
 	struct kvm_event *event;
 	u64 time_begin, time_diff;
@@ -510,12 +511,24 @@ static bool handle_end_event(struct perf_kvm_stat *kvm,
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
+	if (kvm->duration && time_diff > kvm->duration) {
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
 
@@ -562,7 +575,7 @@ static bool handle_kvm_event(struct perf_kvm_stat *kvm,
 		return handle_begin_event(kvm, vcpu_record, &key, sample->time);
 
 	if (kvm->events_ops->is_end_event(evsel, sample, &key))
-		return handle_end_event(kvm, vcpu_record, &key, sample->time);
+		return handle_end_event(kvm, vcpu_record, &key, sample);
 
 	return true;
 }
@@ -1429,6 +1442,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 		OPT_STRING('k', "key", &kvm->sort_key, "sort-key",
 			"key for sorting: sample(sort by samples number)"
 			" time (sort by avg time)"),
+		OPT_U64(0, "duration", &kvm->duration,
+		    "show events other than HALT that take longer than duration usecs"),
 		OPT_END()
 	};
 	const char * const live_usage[] = {
@@ -1467,6 +1482,8 @@ static int kvm_events_live(struct perf_kvm_stat *kvm,
 			usage_with_options(live_usage, live_options);
 	}
 
+	kvm->duration *= NSEC_PER_USEC;   /* convert usec to nsec */
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
