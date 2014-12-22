Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258AbaLVHu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 02:50:56 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41594 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754188AbaLVHuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 02:50:03 -0500
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>
Cc: dev@codyps.com, peterz@infradead.org, hbabu@us.ibm.com,
        <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH v6 2/4] tools/perf: extend format_alias() to include event parameters
Date: Sun, 21 Dec 2014 23:49:25 -0800
Message-Id: <1419234567-22784-3-git-send-email-sukadev@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1419234567-22784-1-git-send-email-sukadev@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122207-0037-0000-0000-0000002EF792
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

This causes `perf list pmu` to show parameters for parameterized events
like:

  pmu/event_name,param1=?,param2=?/ [Kernel PMU event]

An example:

  hv_24x7/HPM_TLBIE__PHYS_CORE,core=?/ [Kernel PMU event]

Changelog[v6]
	[Jir Olsa, Sukadev Bhattiprolu] Drop the '$' sign and go back to
	just printing whatevever sysfs provides (which is '=?') to identify
	required parameters. sysfs also now uses parameters like 'core'
	and 'vcpu' rather than 'starting_index'.

Changelog[v5]
	[Jiri Olsa, Peter Zijlstra] Use '$' to prefix parameterized events.

Changelog[v4]
	[Jiri Olsa] If the parameter for an event in sysfs is 'param=val',
	have perf-list show the event as 'param=?' rather than 'val=?'.

CC: Haren Myneni <hbabu@us.ibm.com>
CC: Cody P Schafer <dev@codyps.com>
Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
---
 tools/perf/util/pmu.c | 27 ++++++++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index cb516dd..d208fef 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -810,10 +810,35 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
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
+					",%s=%s", term->config,
+					term->val.str);
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
+
 	return buf;
 }
 
-- 
1.8.3.1

