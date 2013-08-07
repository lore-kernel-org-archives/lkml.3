Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933600Ab3HGVRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 17:17:48 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47068 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933406Ab3HGVL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 17:11:29 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Michael Ellerman <michael@ellerman.id.au>,
        Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 44/47] perf tools: Add support for pinned modifier
Date: Wed,  7 Aug 2013 18:11:11 -0300
Message-Id: <1375909874-22073-45-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1375909874-22073-1-git-send-email-acme@infradead.org>
References: <1375909874-22073-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Ellerman <michael@ellerman.id.au>

This commit adds support for a new modifier "D", which requests that the
event, or group of events, be pinned to the PMU.

The "p" modifier is already taken for precise, and "P" may be used in
future to mean "fully precise".

So we use "D", which stands for pinneD - and looks like a padlock, or if
you're using the ":D" syntax perf smiles at you.

This is an oft-requested feature from our HW folks, who want to be able
to run a large number of events, but also want 100% accurate results for
instructions per cycle.

Comparison of results with and without pinning:

$ perf stat -e '{cycles,instructions}:D' -e cycles,instructions,...

  79,590,480,683 cycles         #  0.000 GHz
 166,123,716,524 instructions   #  2.09  insns per cycle
                                #  0.11  stalled cycles per insn

  79,352,134,463 cycles         #  0.000 GHz                     [11.11%]
 165,178,301,818 instructions   #  2.08  insns per cycle
                                #  0.11  stalled cycles per insn [11.13%]

As you can see although perf does a very good job of scaling the values
in the non-pinned case, there is some small discrepancy.

The patch is fairly straight forward, the one detail is that we need to
make sure we only request pinning for the group leader when we have a
group.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1375795686-4226-1-git-send-email-michael@ellerman.id.au
[ Use perf_evsel__is_group_leader instead of open coded equivalent, as
  suggested by Jiri Olsa ]
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-list.txt |  1 +
 tools/perf/util/parse-events.c         | 11 ++++++++++-
 tools/perf/util/parse-events.l         |  3 ++-
 3 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Documentation/perf-list.txt b/tools/perf/Documentation/perf-list.txt
index eb03f06..6fce6a6 100644
--- a/tools/perf/Documentation/perf-list.txt
+++ b/tools/perf/Documentation/perf-list.txt
@@ -30,6 +30,7 @@ counted. The following modifiers exist:
  H - host counting (not in KVM guests)
  p - precise level
  S - read sample value (PERF_SAMPLE_READ)
+ D - pin the event to the PMU
 
 The 'p' modifier can be used for specifying how precise the instruction
 address should be. The 'p' modifier can be specified multiple times:
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index dba877d..9cba923 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -688,6 +688,7 @@ struct event_modifier {
 	int precise;
 	int exclude_GH;
 	int sample_read;
+	int pinned;
 };
 
 static int get_event_modifier(struct event_modifier *mod, char *str,
@@ -700,6 +701,7 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	int eG = evsel ? evsel->attr.exclude_guest : 0;
 	int precise = evsel ? evsel->attr.precise_ip : 0;
 	int sample_read = 0;
+	int pinned = evsel ? evsel->attr.pinned : 0;
 
 	int exclude = eu | ek | eh;
 	int exclude_GH = evsel ? evsel->exclude_GH : 0;
@@ -734,6 +736,8 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 				eG = 1;
 		} else if (*str == 'S') {
 			sample_read = 1;
+		} else if (*str == 'D') {
+			pinned = 1;
 		} else
 			break;
 
@@ -761,6 +765,8 @@ static int get_event_modifier(struct event_modifier *mod, char *str,
 	mod->precise = precise;
 	mod->exclude_GH = exclude_GH;
 	mod->sample_read = sample_read;
+	mod->pinned = pinned;
+
 	return 0;
 }
 
@@ -773,7 +779,7 @@ static int check_modifier(char *str)
 	char *p = str;
 
 	/* The sizeof includes 0 byte as well. */
-	if (strlen(str) > (sizeof("ukhGHpppS") - 1))
+	if (strlen(str) > (sizeof("ukhGHpppSD") - 1))
 		return -1;
 
 	while (*p) {
@@ -812,6 +818,9 @@ int parse_events__modifier_event(struct list_head *list, char *str, bool add)
 		evsel->attr.exclude_guest  = mod.eG;
 		evsel->exclude_GH          = mod.exclude_GH;
 		evsel->sample_read         = mod.sample_read;
+
+		if (perf_evsel__is_group_leader(evsel))
+			evsel->attr.pinned = mod.pinned;
 	}
 
 	return 0;
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index b36115f..0790452 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -82,7 +82,8 @@ num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
 name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?]*
-modifier_event	[ukhpGHS]+
+/* If you add a modifier you need to update check_modifier() */
+modifier_event	[ukhpGHSD]+
 modifier_bp	[rwx]{1,3}
 
 %%
-- 
1.8.1.4

