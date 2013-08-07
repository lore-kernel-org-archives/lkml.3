Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933636Ab3HGVTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:19:32 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47022 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933391Ab3HGVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:28 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 08/47] perf tools: Add 'S' event/group modifier to read sample value
Date: Wed,  7 Aug 2013 18:10:35 -0300
Message-Id: <1375909874-22073-9-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding 'S' event/group modifier to specify that the event value/s are
read by PERF_SAMPLE_READ sample type processing, instead of the period
value offered by lower layers.

There's additional behaviour change for 'S' modifier being specified on
event group:

Currently all the events within a group makes samples. If user now
specifies 'S' within group modifier, only the leader will trigger
samples. The rest of events in the group will have sampling disabled.

And same as for single events, values of all events within the group
(including leader) are read by PERF_SAMPLE_READ sample type processing.

Following example will create event group with cycles and cache-misses
events, setting the cycles as group leader and the only event to
actually sample. Both cycles and cache-misses event period values are
read by PERF_SAMPLE_READ sample type processing with PERF_FORMAT_GROUP
read format.

Example:

  $ perf record -e '{cycles,cache-misses}:S' ls
  ...
  $ perf report --group --show-total-period --stdio
  ...
  # Samples: 36  of event 'anon group { cycles, cache-misses }'
  # Event count (approx.): 12585593
  #
  #       Overhead          Period  Command      Shared Object                      Symbol
  # ..............  ..............  .......  .................  ..........................
  #
    19.92%   1.20%  2505936     31       ls  [kernel.kallsyms]  [k] mark_held_locks
    13.74%   0.47%  1729327     12       ls  [kernel.kallsyms]  [k] sched_clock_local
    13.64%  23.72%  1716147    612       ls  ld-2.14.90.so      [.] check_match.10805
    13.12%  23.22%  1650778    599       ls  libc-2.14.90.so    [.] _nl_intern_locale_data
    11.24%  29.19%  1414554    753       ls  [kernel.kallsyms]  [k] sched_clock_cpu
     8.50%   0.35%  1070150      9       ls  [kernel.kallsyms]  [k] check_chain_key
  ...

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-iyoinu3axi11mymwnh2b7fxj@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |  1 +
 tools/perf/util/evsel.c                | 29 +++++++++++++++++++++++++++++
 tools/perf/util/evsel.h                |  1 +
 tools/perf/util/parse-events.c         |  8 +++++++-
 tools/perf/util/parse-events.l         |  2 +-
 5 files changed, 39 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index 826f3d6..eb03f06 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -29,6 +29,7 @@ counted. The following modifiers exist:
  G - guest counting (in KVM guests)
  H - host counting (not in KVM guests)
  p - precise level
+ S - read sample value (PERF_SAMPLE_READ)
 
 The 'p' modifier can be used for specifying how precise the instruction
 address should be. The 'p' modifier can be specified multiple times:
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 9ab8fff..8f10161 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -490,6 +490,7 @@ int perf_evsel__group_desc(struct perf_evsel *evsel, char *buf, size_t size)
 void perf_evsel__config(struct perf_evsel *evsel,
 			struct perf_record_opts *opts)
 {
+	struct perf_evsel *leader = evsel->leader;
 	struct perf_event_attr *attr = &evsel->attr;
 	int track = !evsel->idx; /* only the first counter needs these */
 
@@ -499,6 +500,25 @@ void perf_evsel__config(struct perf_evsel *evsel,
 	perf_evsel__set_sample_bit(evsel, IP);
 	perf_evsel__set_sample_bit(evsel, TID);
 
+	if (evsel->sample_read) {
+		perf_evsel__set_sample_bit(evsel, READ);
+
+		/*
+		 * We need ID even in case of single event, because
+		 * PERF_SAMPLE_READ process ID specific data.
+		 */
+		perf_evsel__set_sample_id(evsel);
+
+		/*
+		 * Apply group format only if we belong to group
+		 * with more than one members.
+		 */
+		if (leader->nr_members > 1) {
+			attr->read_format |= PERF_FORMAT_GROUP;
+			attr->inherit = 0;
+		}
+	}
+
 	/*
 	 * We default some events to a 1 default interval. But keep
 	 * it a weak assumption overridable by the user.
@@ -514,6 +534,15 @@ void perf_evsel__config(struct perf_evsel *evsel,
 		}
 	}
 
+	/*
+	 * Disable sampling for all group members other
+	 * than leader in case leader 'leads' the sampling.
+	 */
+	if ((leader != evsel) && leader->sample_read) {
+		attr->sample_freq   = 0;
+		attr->sample_period = 0;
+	}
+
 	if (opts->no_samples)
 		attr->sample_freq = 0;
 
diff --git a/tools/perf/util/evsel.h b/tools/perf/util/evsel.h
index 6a2cf26..5edc625 100644
--- a/tools/perf/util/evsel.h
+++ b/tools/perf/util/evsel.h
@@ -79,6 +79,7 @@ struct perf_evsel {
 	/* parse modifier helper */
 	int			exclude_GH;
 	int			nr_members;
+	int			sample_read;
 	struct perf_evsel	*leader;
 	char			*group_name;
 };
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 2c460ed..dba877d 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -687,6 +687,7 @@ struct event_modifier {
 	int eG;
 	int precise;
 	int exclude_GH;
+	int sample_read;
 };
 
 static int get_event_modifier(struct event_modifier *mod, char *str,
@@ -698,6 +699,7 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	int eH = evsel ? evsel->attr.exclude_host : 0;
 	int eG = evsel ? evsel->attr.exclude_guest : 0;
 	int precise = evsel ? evsel->attr.precise_ip : 0;
+	int sample_read = 0;
 
 	int exclude = eu | ek | eh;
 	int exclude_GH = evsel ? evsel->exclude_GH : 0;
@@ -730,6 +732,8 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 			/* use of precise requires exclude_guest */
 			if (!exclude_GH)
 				eG = 1;
+		} else if (*str == 'S') {
+			sample_read = 1;
 		} else
 			break;
 
@@ -756,6 +760,7 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	mod->eG = eG;
 	mod->precise = precise;
 	mod->exclude_GH = exclude_GH;
+	mod->sample_read = sample_read;
 	return 0;
 }
 
@@ -768,7 +773,7 @@ static int check_modifier(char *str)
 	char *p = str;
 
 	/* The sizeof includes 0 byte as well. */
-	if (strlen(str) > (sizeof("ukhGHppp") - 1))
+	if (strlen(str) > (sizeof("ukhGHpppS") - 1))
 		return -1;
 
 	while (*p) {
@@ -806,6 +811,7 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 		evsel->attr.exclude_host   = mod.eH;
 		evsel->attr.exclude_guest  = mod.eG;
 		evsel->exclude_GH          = mod.exclude_GH;
+		evsel->sample_read         = mod.sample_read;
 	}
 
 	return 0;
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index e9d1134..b36115f 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -82,7 +82,7 @@ num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
 name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?]*
-modifier_event	[ukhpGH]+
+modifier_event	[ukhpGHS]+
 modifier_bp	[rwx]{1,3}
 
 %%
-- 
1.8.1.4

