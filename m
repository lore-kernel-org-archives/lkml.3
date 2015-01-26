Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932258AbbAZRxR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:53:17 -0500
Received: from mail.kernel.org ([198.145.29.136]:52876 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756709AbbAZRsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:48:15 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Cody P Schafer <cody@linux.vnet.ibm.com>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Cody P Schafer <dev@codyps.com>, Haren Myneni <hbabu@us.ibm.com>,
        Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>, linuxppc-dev@lists.ozlabs.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/26] perf tools: Extend format_alias() to include event parameters
Date: Mon, 26 Jan 2015 14:47:12 -0300
Message-Id: <1422294449-12735-10-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1422294449-12735-1-git-send-email-acme@kernel.org>
References: <1422294449-12735-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cody P Schafer <cody@linux.vnet.ibm.com>

This causes `perf list pmu` to show parameters for parameterized events
like:

  pmu/event_name,param1=?,param2=?/ [Kernel PMU event]

An example:

  hv_24x7/HPM_TLBIE__PHYS_CORE,core=?/ [Kernel PMU event]

Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Cc: Cody P Schafer <dev@codyps.com>
Cc: Haren Myneni <hbabu@us.ibm.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: linuxppc-dev@lists.ozlabs.org
Link: http://lkml.kernel.org/r/1420679633-28856-3-git-send-email-sukadev@linux.vnet.ibm.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/pmu.c | 28 +++++++++++++++++++++++++++-
 1 file changed, 27 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index bfbecf7abd38..48411674da0f 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -819,10 +819,36 @@ void perf_pmu__set_format(unsigned long *bits, long from, long to)
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
+	list_for_each_entry(term, &alias->terms, list) {
+		if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR)
+			used += snprintf(buf + used, sub_non_neg(len, used),
+					",%s=%s", term->config,
+					term->val.str);
+	}
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
1.9.3

