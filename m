Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933681Ab3HGVYO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:24:14 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46938 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933311Ab3HGVLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/47] perf evsel: Add PERF_SAMPLE_READ sample related processing
Date: Wed,  7 Aug 2013 18:10:34 -0300
Message-Id: <1375909874-22073-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

For sample with sample type PERF_SAMPLE_READ the period value is stored
in the 'struct sample_read'.

Moreover if the read format has PERF_FORMAT_GROUP, the 'struct
sample_read' contains period values for all events in the group (for
which the sample's event is a leader).

We deliver separated samples for all the values contained within the
'struct sample_read'.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-6mdm5xkrm6kypouh1c33cyys@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.h   |  3 ++
 tools/perf/util/session.c | 72 ++++++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 74 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 3f156cc..6a2cf26 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -38,6 +38,9 @@ struct perf_sample_id {
 	struct hlist_node 	node;
 	u64		 	id;
 	struct perf_evsel	*evsel;
+
+	/* Holds total ID period value for PERF_SAMPLE_READ processing. */
+	u64			period;
 };
 
 /** struct perf_evsel - event selector
diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index f082921..9247d9c 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -860,6 +860,75 @@ static struct machine *
 	return &session->machines.host;
 }
 
+static int deliver_sample_value(struct perf_session *session,
+				struct perf_tool *tool,
+				union perf_event *event,
+				struct perf_sample *sample,
+				struct sample_read_value *v,
+				struct machine *machine)
+{
+	struct perf_sample_id *sid;
+
+	sid = perf_evlist__id2sid(session->evlist, v->id);
+	if (sid) {
+		sample->id     = v->id;
+		sample->period = v->value - sid->period;
+		sid->period    = v->value;
+	}
+
+	if (!sid || sid->evsel == NULL) {
+		++session->stats.nr_unknown_id;
+		return 0;
+	}
+
+	return tool->sample(tool, event, sample, sid->evsel, machine);
+}
+
+static int deliver_sample_group(struct perf_session *session,
+				struct perf_tool *tool,
+				union  perf_event *event,
+				struct perf_sample *sample,
+				struct machine *machine)
+{
+	int ret = -EINVAL;
+	u64 i;
+
+	for (i = 0; i < sample->read.group.nr; i++) {
+		ret = deliver_sample_value(session, tool, event, sample,
+					   &sample->read.group.values[i],
+					   machine);
+		if (ret)
+			break;
+	}
+
+	return ret;
+}
+
+static int
+perf_session__deliver_sample(struct perf_session *session,
+			     struct perf_tool *tool,
+			     union  perf_event *event,
+			     struct perf_sample *sample,
+			     struct perf_evsel *evsel,
+			     struct machine *machine)
+{
+	/* We know evsel != NULL. */
+	u64 sample_type = evsel->attr.sample_type;
+	u64 read_format = evsel->attr.read_format;
+
+	/* Standard sample delievery. */
+	if (!(sample_type & PERF_SAMPLE_READ))
+		return tool->sample(tool, event, sample, evsel, machine);
+
+	/* For PERF_SAMPLE_READ we have either single or group mode. */
+	if (read_format & PERF_FORMAT_GROUP)
+		return deliver_sample_group(session, tool, event, sample,
+					    machine);
+	else
+		return deliver_sample_value(session, tool, event, sample,
+					    &sample->read.one, machine);
+}
+
 static int perf_session_deliver_event(struct perf_session *session,
 				      union perf_event *event,
 				      struct perf_sample *sample,
@@ -902,7 +971,8 @@ static int perf_session_deliver_event(struct perf_session *session,
 			++session->stats.nr_unprocessable_samples;
 			return 0;
 		}
-		return tool->sample(tool, event, sample, evsel, machine);
+		return perf_session__deliver_sample(session, tool, event,
+						    sample, evsel, machine);
 	case PERF_RECORD_MMAP:
 		return tool->mmap(tool, event, sample, machine);
 	case PERF_RECORD_COMM:
-- 
1.8.1.4

