Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695AbaIXTcr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 15:32:47 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47630 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943AbaIXT1x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 15:27:53 -0400
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        Jiri Olsa <jolsa@redhat.com>, peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v4 02/10] tools/perf: extend format_alias() to include event parameters
Date: Wed, 24 Sep 2014 12:27:16 -0700
Message-Id: <1411586844-21381-3-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1411586844-21381-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1411586844-21381-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092419-5806-0000-0000-000000951C6C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

This causes `perf list pmu` to show parameters for parameterized events
like follows:

  pmu/event_name,param1=?,param2=?/ [Kernel PMU event]

An example:

  hv_gpci/dispatch_timebase_by_processor_processor_time_in_timebase_cycles,phys_processor_idx=?/ [Kernel PMU event]

Changelog[v6]
	[Jir Olsa] If the parameter for an event in sysfs is 'param=val',
	have perf-list show the event as 'param=?' rather than 'val=?'.

CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/util/pmu.c | 26 +++++++++++++++++++++++++-
 1 file changed, 25 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 67e59b9..a05dd9d 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -760,10 +760,33 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
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
+					",%s=?", term->config);
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
 
@@ -814,6 +837,7 @@ void print_pmu_events(const char *event_glob, bool name_only)
 			if (is_cpu && !name_only)
 				aliases[j] = format_alias_or(buf, sizeof(buf),
 							      pmu, alias);
+
 			aliases[j] = strdup(aliases[j]);
 			j++;
 		}
-- 
1.8.3.1

