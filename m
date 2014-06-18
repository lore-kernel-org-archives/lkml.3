Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847AbaFRPBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 11:01:09 -0400
Received: from forward-corp1e.mail.yandex.net ([77.88.60.199]:44909 "EHLO
	forward-corp1e.mail.yandex.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751609AbaFRPAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 11:00:55 -0400
X-Yandex-Uniq: ef641f96-1041-435c-a9fe-e8bb3e5c8dd9
Authentication-Results: smtpcorp4.mail.yandex.net; dkim=pass header.i=@yandex-team.ru
From: Stanislav Fomichev <stfomichev@yandex-team.ru>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@kernel.org, dsahern@gmail.com, stfomichev@yandex-team.ru,
        jolsa@redhat.com, xiaoguangrong@linux.vnet.ibm.com,
        yangds.fnst@cn.fujitsu.com, adrian.hunter@intel.com,
        namhyung@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/5] perf kvm: move perf_kvm__mmap_read into session utils
Date: Wed, 18 Jun 2014 18:59:24 +0400
Message-Id: <1403103565-6388-5-git-send-email-stfomichev@yandex-team.ru>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
References: <1403103565-6388-1-git-send-email-stfomichev@yandex-team.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It will be reused by perf trace in the following commit.

Signed-off-by: Stanislav Fomichev <stfomichev@yandex-team.ru>
---
 tools/perf/builtin-kvm.c  | 88 +++--------------------------------------------
 tools/perf/util/session.c | 85 +++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/session.h |  5 +++
 3 files changed, 94 insertions(+), 84 deletions(-)

diff --git a/tools/perf/builtin-kvm.c b/tools/perf/builtin-kvm.c
index 0f1e5a2f6ad7..a69ffe7512e5 100644
--- a/tools/perf/builtin-kvm.c
+++ b/tools/perf/builtin-kvm.c
@@ -885,89 +885,6 @@ static bool verify_vcpu(int vcpu)
  */
 #define PERF_KVM__MAX_EVENTS_PER_MMAP  25
 
-static s64 perf_kvm__mmap_read_idx(struct perf_kvm_stat *kvm, int idx,
-				   u64 *mmap_time)
-{
-	union perf_event *event;
-	struct perf_sample sample;
-	s64 n = 0;
-	int err;
-
-	*mmap_time = ULLONG_MAX;
-	while ((event = perf_evlist__mmap_read(kvm->evlist, idx)) != NULL) {
-		err = perf_evlist__parse_sample(kvm->evlist, event, &sample);
-		if (err) {
-			perf_evlist__mmap_consume(kvm->evlist, idx);
-			pr_err("Failed to parse sample\n");
-			return -1;
-		}
-
-		err = perf_session_queue_event(kvm->session, event, &sample, 0);
-		/*
-		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
-		 *        point to it, and it'll get possibly overwritten by the kernel.
-		 */
-		perf_evlist__mmap_consume(kvm->evlist, idx);
-
-		if (err) {
-			pr_err("Failed to enqueue sample: %d\n", err);
-			return -1;
-		}
-
-		/* save time stamp of our first sample for this mmap */
-		if (n == 0)
-			*mmap_time = sample.time;
-
-		/* limit events per mmap handled all at once */
-		n++;
-		if (n == PERF_KVM__MAX_EVENTS_PER_MMAP)
-			break;
-	}
-
-	return n;
-}
-
-static int perf_kvm__mmap_read(struct perf_kvm_stat *kvm)
-{
-	int i, err, throttled = 0;
-	s64 n, ntotal = 0;
-	u64 flush_time = ULLONG_MAX, mmap_time;
-
-	for (i = 0; i < kvm->evlist->nr_mmaps; i++) {
-		n = perf_kvm__mmap_read_idx(kvm, i, &mmap_time);
-		if (n < 0)
-			return -1;
-
-		/* flush time is going to be the minimum of all the individual
-		 * mmap times. Essentially, we flush all the samples queued up
-		 * from the last pass under our minimal start time -- that leaves
-		 * a very small race for samples to come in with a lower timestamp.
-		 * The ioctl to return the perf_clock timestamp should close the
-		 * race entirely.
-		 */
-		if (mmap_time < flush_time)
-			flush_time = mmap_time;
-
-		ntotal += n;
-		if (n == PERF_KVM__MAX_EVENTS_PER_MMAP)
-			throttled = 1;
-	}
-
-	/* flush queue after each round in which we processed events */
-	if (ntotal) {
-		kvm->session->ordered_samples.next_flush = flush_time;
-		err = kvm->tool.finished_round(&kvm->tool, NULL, kvm->session);
-		if (err) {
-			if (kvm->lost_events)
-				pr_info("\nLost events: %" PRIu64 "\n\n",
-					kvm->lost_events);
-			return err;
-		}
-	}
-
-	return throttled;
-}
-
 static volatile int done;
 
 static void sig_handler(int sig __maybe_unused)
@@ -1133,7 +1050,10 @@ static int kvm_events_live_report(struct perf_kvm_stat *kvm)
 	while (!done) {
 		int rc;
 
-		rc = perf_kvm__mmap_read(kvm);
+		rc = perf_session__mmap_read(&kvm->tool,
+			    kvm->session,
+			    kvm->evlist,
+			    PERF_KVM__MAX_EVENTS_PER_MMAP);
 		if (rc < 0)
 			break;
 
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 4526d966b10a..994846060c5e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1671,3 +1671,88 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 out:
 	return err;
 }
+
+static s64 perf_session__mmap_read_idx(struct perf_session *session,
+				       int idx,
+				       u64 *mmap_time,
+				       int nr_per_mmap)
+{
+	union perf_event *event;
+	struct perf_sample sample;
+	s64 n = 0;
+	int err;
+
+	*mmap_time = ULLONG_MAX;
+	while ((event = perf_evlist__mmap_read(session->evlist, idx)) != NULL) {
+		err = perf_evlist__parse_sample(session->evlist, event, &sample);
+		if (err) {
+			perf_evlist__mmap_consume(session->evlist, idx);
+			pr_err("Failed to parse sample\n");
+			return -1;
+		}
+
+		err = perf_session_queue_event(session, event, &sample, 0);
+		/*
+		 * FIXME: Here we can't consume the event, as perf_session_queue_event will
+		 *        point to it, and it'll get possibly overwritten by the kernel.
+		 */
+		perf_evlist__mmap_consume(session->evlist, idx);
+
+		if (err) {
+			pr_err("Failed to enqueue sample: %d\n", err);
+			return -1;
+		}
+
+		/* save time stamp of our first sample for this mmap */
+		if (n == 0)
+			*mmap_time = sample.time;
+
+		/* limit events per mmap handled all at once */
+		n++;
+		if (n == nr_per_mmap)
+			break;
+	}
+
+	return n;
+}
+
+int perf_session__mmap_read(struct perf_tool *tool,
+			    struct perf_session *session,
+			    struct perf_evlist *evlist,
+			    int nr_per_mmap)
+{
+	int i, err, throttled = 0;
+	s64 n, ntotal = 0;
+	u64 flush_time = ULLONG_MAX, mmap_time;
+
+	for (i = 0; i < evlist->nr_mmaps; i++) {
+		n = perf_session__mmap_read_idx(session, i, &mmap_time,
+						nr_per_mmap);
+		if (n < 0)
+			return -1;
+
+		/* flush time is going to be the minimum of all the individual
+		 * mmap times. Essentially, we flush all the samples queued up
+		 * from the last pass under our minimal start time -- that leaves
+		 * a very small race for samples to come in with a lower timestamp.
+		 * The ioctl to return the perf_clock timestamp should close the
+		 * race entirely.
+		 */
+		if (mmap_time < flush_time)
+			flush_time = mmap_time;
+
+		ntotal += n;
+		if (n == nr_per_mmap)
+			throttled = 1;
+	}
+
+	/* flush queue after each round in which we processed events */
+	if (ntotal) {
+		session->ordered_samples.next_flush = flush_time;
+		err = tool->finished_round(tool, NULL, session);
+		if (err)
+			return err;
+	}
+
+	return throttled;
+}
diff --git a/tools/perf/util/session.h b/tools/perf/util/session.h
index 9494fb68828a..e79da3c1071e 100644
--- a/tools/perf/util/session.h
+++ b/tools/perf/util/session.h
@@ -133,4 +133,9 @@ int __perf_session__set_tracepoints_handlers(struct perf_session *session,
 extern volatile int session_done;
 
 #define session_done()	(*(volatile int *)(&session_done))
+
+int perf_session__mmap_read(struct perf_tool *tool,
+			    struct perf_session *session,
+			    struct perf_evlist *evlist,
+			    int nr_per_mmap);
 #endif /* __PERF_SESSION_H */
-- 
1.8.3.2

