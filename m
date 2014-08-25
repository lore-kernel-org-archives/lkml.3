Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933256AbaHYOtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:49:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932317AbaHYOqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:23 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 6/9] perf tools: Add hash of periods for struct perf_sample_id
Date: Mon, 25 Aug 2014 16:45:40 +0200
Message-Id: <1408977943-16594-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With PERF_FORMAT_GROUP format on inherited events being allowed
in kernel, we can now allow leader sampling on inherited events.

But before we actually switch it on, we need to change the sorting
of PERF_SAMPLE_READ sample's data. Currently PERF_SAMPLE_READ values
are sorted on event id. Now when we'll get data from all children
processes we need to add TID as another sort key.

Adding hash of TIDs into each 'struct perf_sample_id' to
hold event values for different TIDs.

Reported-by: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.c   | 13 +++++++
 tools/perf/util/evsel.h   |  5 ++-
 tools/perf/util/session.c | 93 ++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 104 insertions(+), 7 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index b38de5819323..507d458ded2c 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -787,8 +787,21 @@ void perf_evsel__free_fd(struct perf_evsel *evsel)
 	evsel->fd = NULL;
 }
 
+static void free_sample_id(struct perf_evsel *evsel)
+{
+	struct perf_sample_id *sid;
+
+	if (evsel->sample_id) {
+		xyarray__for_each(evsel->sample_id, sid) {
+			if (sid->periods)
+				perf_sample_hash__delete(sid->periods);
+		}
+	}
+}
+
 void perf_evsel__free_id(struct perf_evsel *evsel)
 {
+	free_sample_id(evsel);
 	xyarray__delete(evsel->sample_id);
 	evsel->sample_id = NULL;
 	zfree(&evsel->id);
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 7bc314be6a7b..41c000fc018b 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -29,6 +29,7 @@ struct perf_counts {
 };
 
 struct perf_evsel;
+struct perf_sample_hash;
 
 /*
  * Per fd, to map back from PERF_SAMPLE_ID to evsel, only used when there are
@@ -40,9 +41,11 @@ struct perf_sample_id {
 	struct perf_evsel	*evsel;
 
 	/* Holds total ID period value for PERF_SAMPLE_READ processing. */
-	u64			period;
+	struct perf_sample_hash	*periods;
 };
 
+void perf_sample_hash__delete(struct perf_sample_hash *hash);
+
 /** struct perf_evsel - event selector
  *
  * @name - Can be set to retain the original event name passed by the user,
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 6d2d50dea1d8..dcd2662b3b2e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1,4 +1,6 @@
 #include <linux/kernel.h>
+#include <linux/bitops.h>
+#include <linux/hash.h>
 #include <traceevent/event-parse.h>
 
 #include <byteswap.h>
@@ -733,6 +735,82 @@ static struct machine *
 	return &session->machines.host;
 }
 
+struct perf_sample_period {
+	struct hlist_node	node;
+	u64			value;
+	pid_t			tid;
+};
+
+#define PERF_SAMPLE__HLIST_BITS 8
+#define PERF_SAMPLE__HLIST_SIZE (1 << PERF_SAMPLE__HLIST_BITS)
+
+struct perf_sample_hash {
+	struct hlist_head heads[PERF_SAMPLE__HLIST_SIZE];
+};
+
+void perf_sample_hash__delete(struct perf_sample_hash *hash)
+{
+	int h;
+
+	for (h = 0; h < PERF_SAMPLE__HLIST_SIZE; h++) {
+		struct perf_sample_period *period;
+		struct hlist_head *head;
+		struct hlist_node *n;
+
+		head = &hash->heads[h];
+		hlist_for_each_entry_safe(period, n, head, node) {
+			hlist_del(&period->node);
+			free(period);
+		}
+	}
+
+	free(hash);
+}
+
+static struct perf_sample_period*
+findnew_hash_period(struct perf_sample_hash *hash, pid_t tid)
+{
+	struct perf_sample_period *period;
+	struct hlist_head *head;
+	int hash_val;
+
+	hash_val = hash_64(tid, PERF_SAMPLE__HLIST_BITS);
+	head = &hash->heads[hash_val];
+
+	hlist_for_each_entry(period, head, node) {
+		if (period->tid == tid)
+			return period;
+	}
+
+	period = zalloc(sizeof(*period));
+	if (period) {
+		period->tid = tid;
+		hlist_add_head(&period->node, &hash->heads[hash_val]);
+	}
+
+	return period;
+}
+
+static struct perf_sample_period*
+get_sample_period(struct perf_sample_id *sid, pid_t tid)
+{
+	struct perf_sample_hash *hash = sid->periods;
+	int i;
+
+	if (hash == NULL) {
+		hash = zalloc(sizeof(*hash));
+		if (hash == NULL)
+			return NULL;
+
+		for (i = 0; i < PERF_SAMPLE__HLIST_SIZE; ++i)
+			INIT_HLIST_HEAD(&hash->heads[i]);
+
+		sid->periods = hash;
+	}
+
+	return findnew_hash_period(hash, tid);
+}
+
 static int deliver_sample_value(struct perf_session *session,
 				struct perf_tool *tool,
 				union perf_event *event,
@@ -741,19 +819,22 @@ static int deliver_sample_value(struct perf_session *session,
 				struct machine *machine)
 {
 	struct perf_sample_id *sid;
+	struct perf_sample_period *period;
 
 	sid = perf_evlist__id2sid(session->evlist, v->id);
-	if (sid) {
-		sample->id     = v->id;
-		sample->period = v->value - sid->period;
-		sid->period    = v->value;
-	}
-
 	if (!sid || sid->evsel == NULL) {
 		++session->stats.nr_unknown_id;
 		return 0;
 	}
 
+	period = get_sample_period(sid, sample->tid);
+	if (period == NULL)
+		return -ENOMEM;
+
+	sample->id     = v->id;
+	sample->period = v->value - period->value;
+	period->value  = v->value;
+
 	return tool->sample(tool, event, sample, sid->evsel, machine);
 }
 
-- 
1.8.3.1

