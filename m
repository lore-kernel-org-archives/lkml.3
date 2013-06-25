Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab3FYX1p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 19:27:45 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:40293 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774Ab3FYX1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 19:27:43 -0400
Message-ID: <51CA276B.9080201@gmail.com>
Date: Tue, 25 Jun 2013 17:27:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
CC: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 12/15] perf tools: allow non-matching sample types
References: <1372079772-20803-1-git-send-email-adrian.hunter@intel.com> <1372079772-20803-13-git-send-email-adrian.hunter@intel.com> <51C9BDB2.7060905@gmail.com> <CABPqkBQK5PdcULwtAefsVKvV+Ne6kaaH2_jeoba8kz3Ui_EqAw@mail.gmail.com> <51CA2205.4040006@gmail.com>
In-Reply-To: <51CA2205.4040006@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/25/13 5:04 PM, David Ahern wrote:
> On 6/25/13 10:03 AM, Stephane Eranian wrote:
>>> Stephane: are you looking at allowing sample_types per event?
>>> >
>> Yes, this is what I need. I have a kernel patch to do this. I don't
>> know how to update perf to handle it correctly. So maybe you can
>> help. My patch is useful to drastically reduce the size of the perf.data
>> file in case we use the branch-stack with lots of events which is
>> what our Gooda tool would like to do.
>
> Refreshing my memory on the root problem here. It's a chicken-and-egg
> problem: we need the id in the sample to find the event (evsel) that
> generated it (perf_evlist__id2evsel). To get the id we need the
> sample_type to parse it and we want the sample_type to be per event.
>
> As I recall this is where the conversation turns to per-event data files...

That said, this hack works for me with the combined S/W-tracepoint data 
file:

$ perf record -e cs -c1 -e sched:sched_switch -a -- sleep 1
$ perf script

It basically guesses which entry in the array has the id. (Ignore the 
whitespace ugliness - dev box expands tabs).

diff --git a/tools/perf/util/evlist.c b/tools/perf/util/evlist.c
index 89aea20..a6824b4 100644
--- a/tools/perf/util/evlist.c
+++ b/tools/perf/util/evlist.c
@@ -849,7 +849,20 @@ int perf_evlist__start_workload(struct perf_evlist 
*evlist)
  int perf_evlist__parse_sample(struct perf_evlist *evlist, union 
perf_event *event,
  			      struct perf_sample *sample)
  {
-	struct perf_evsel *evsel = perf_evlist__first(evlist);
+	struct perf_evsel *evsel;
+    const u64 *array = event->sample.array;
+    u64 id;
+    int n;
+
+    for (n = 0; n < 4; ++n) {
+        id = array[n];
+        evsel = perf_evlist__id2evsel(evlist, id);
+        if (evsel)
+            break;
+    }
+    if (evsel == NULL)
+        evsel = perf_evlist__first(evlist);
+
  	return perf_evsel__parse_sample(evsel, event, sample);
  }

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index ad47fb9..dbbda09 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -61,10 +61,10 @@ static int perf_session__open(struct perf_session 
*self, bool force)
  		goto out_close;
  	}

-	if (!perf_evlist__valid_sample_type(self->evlist)) {
-		pr_err("non matching sample_type");
-		goto out_close;
-	}
+//	if (!perf_evlist__valid_sample_type(self->evlist)) {
+//		pr_err("non matching sample_type");
+//		goto out_close;
+//	}

  	if (!perf_evlist__valid_sample_id_all(self->evlist)) {
  		pr_err("non matching sample_id_all");
@@ -1295,10 +1295,15 @@ int perf_session__process_events(struct 
perf_session *self,

  bool perf_session__has_traces(struct perf_session *session, const char 
*msg)
  {
-	if (!(perf_evlist__sample_type(session->evlist) & PERF_SAMPLE_RAW)) {
-		pr_err("No trace sample to read. Did you call 'perf %s'?\n", msg);
-		return false;
-	}
+    struct perf_evsel *evsel;
+
+    list_for_each_entry(evsel, &session->evlist->entries, node) {
+		if ((evsel->attr.type == PERF_TYPE_TRACEPOINT) &&
+		   !(evsel->attr.sample_type & PERF_SAMPLE_RAW)) {
+			pr_err("No trace sample to read. Did you call 'perf %s'?\n", msg);
+			return false;
+		}
+    }

  	return true;
  }

