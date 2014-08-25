Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933194AbaHYOqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:46:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33010 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933166AbaHYOqe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:34 -0400
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
Subject: [PATCH 7/9] perf tools: Allow PERF_FORMAT_GROUP for inherited events
Date: Mon, 25 Aug 2014 16:45:41 +0200
Message-Id: <1408977943-16594-8-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Swithing on leader sampling on inherited events.

Following command will now get data from all children processes:
  $ perf record -e '{cycles,cache-misses}:S' <workload>

Use following command to display the data:
  $ perf report --group

Adding warning for record command if the support
is not detected:
  $ perf record -e '{cycles,cache-misses}:S,{instructions,branch}:S' kill
  Disabling inherit for sample read events, no kernel support.
  ...

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
 tools/perf/perf.h        |  1 +
 tools/perf/util/evsel.c  |  6 +++++-
 tools/perf/util/record.c | 12 ++++++++++++
 3 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/tools/perf/perf.h b/tools/perf/perf.h
index 510c65f72858..54e1cb42277e 100644
--- a/tools/perf/perf.h
+++ b/tools/perf/perf.h
@@ -45,6 +45,7 @@ struct record_opts {
 	bool         call_graph_enabled;
 	bool	     group;
 	bool	     inherit_stat;
+	bool	     inherit_format_group;
 	bool	     no_buffering;
 	bool	     no_inherit;
 	bool	     no_inherit_set;
diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 507d458ded2c..7415159bbcea 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -586,7 +586,11 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		 */
 		if (leader->nr_members > 1) {
 			attr->read_format |= PERF_FORMAT_GROUP;
-			attr->inherit = 0;
+			attr->inherit = opts->inherit_format_group;
+			if (!opts->inherit_format_group) {
+				pr_warning_once("Disabling inherit for sample read events, "
+						"no kernel support.\n");
+			}
 		}
 	}
 
diff --git a/tools/perf/util/record.c b/tools/perf/util/record.c
index cf69325b985f..22b1d9c79ac0 100644
--- a/tools/perf/util/record.c
+++ b/tools/perf/util/record.c
@@ -85,6 +85,12 @@ static void perf_probe_comm_exec(struct perf_evsel *evsel)
 	evsel->attr.comm_exec = 1;
 }
 
+static void perf_probe_inherit_format_group(struct perf_evsel *evsel)
+{
+	evsel->attr.inherit = 1;
+	evsel->attr.read_format |= PERF_FORMAT_GROUP;
+}
+
 bool perf_can_sample_identifier(void)
 {
 	return perf_probe_api(perf_probe_sample_identifier);
@@ -95,6 +101,11 @@ static bool perf_can_comm_exec(void)
 	return perf_probe_api(perf_probe_comm_exec);
 }
 
+static bool perf_can_inherit_format_group(void)
+{
+	return perf_probe_api(perf_probe_inherit_format_group);
+}
+
 void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 {
 	struct perf_evsel *evsel;
@@ -111,6 +122,7 @@ void perf_evlist__config(struct perf_evlist *evlist, struct record_opts *opts)
 	if (evlist->cpus->map[0] < 0)
 		opts->no_inherit = true;
 
+	opts->inherit_format_group = perf_can_inherit_format_group();
 	use_comm_exec = perf_can_comm_exec();
 
 	evlist__for_each(evlist, evsel) {
-- 
1.8.3.1

