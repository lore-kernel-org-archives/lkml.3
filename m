Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960AbaE1A12 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 20:27:28 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:51903 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150AbaE1A1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 20:27:25 -0400
From: Cody P Schafer <dev@codyps.com>
To: LKML <linux-kernel@vger.kernel.org>,
        Linux PPC <linuxppc-dev@lists.ozlabs.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Cody P Schafer <dev@codyps.com>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/16] tools/perf: extend format_alias() to include event parameters
Date: Tue, 27 May 2014 17:22:03 -0700
Message-Id: <1401236684-10579-9-git-send-email-dev@codyps.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401236684-10579-1-git-send-email-dev@codyps.com>
References: <1401236684-10579-1-git-send-email-dev@codyps.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This causes `perf list pmu` to show parameters for parameterized events
like follows:

  pmu/event_name,param1=?,param2=?/ [Kernel PMU event]

An example:

  hv_gpci/dispatch_timebase_by_processor_processor_time_in_timebase_cycles,phys_processor_idx=?/ [Kernel PMU event]

CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Signed-off-by: Cody P Schafer <dev@codyps.com>
---
 tools/perf/util/pmu.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index db53fac..7b8d067 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -741,10 +741,33 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
 		set_bit(b, bits);
 }
 
+static int sub_non_neg(int a, int b)
+{
+	if (b > a)
+		return 0;
+	return a - b;
+}
+
 static char *format_alias(char *buf, int len, struct perf_pmu *pmu,
 			  struct perf_pmu_alias *alias)
 {
-	snprintf(buf, len, "%s/%s/", pmu->name, alias->name);
+	struct parse_events_term *term;
+	int used = snprintf(buf, len, "%s/%s", pmu->name, alias->name);
+
+	list_for_each_entry(term, &alias->terms, list)
+		if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR)
+			used += snprintf(buf + used, sub_non_neg(len, used),
+					",%s=?", term->val.str);
+
+	if (sub_non_neg(len, used) > 0) {
+		buf[used] = '/';
+		used++;
+	}
+	if (sub_non_neg(len, used) > 0) {
+		buf[used] = '\0';
+		used++;
+	} else
+		buf[len - 1] = '\0';
 	return buf;
 }
 
@@ -795,6 +818,7 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			if (is_cpu && !name_only)
 				aliases[j] = format_alias_or(buf, sizeof(buf),
 							      pmu, alias);
+
 			aliases[j] = strdup(aliases[j]);
 			j++;
 		}
-- 
1.9.3

