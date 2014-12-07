Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752772AbaLGHiW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2014 02:38:22 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:51839 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752347AbaLGHiS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2014 02:38:18 -0500
Date: Sat, 6 Dec 2014 23:37:24 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Michael Ellerman <michaele@au1.ibm.com>,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        peterz@infradead.org, hbabu@us.ibm.com, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v5 1/4] tools/perf: support parsing parameterized events
Message-ID: <20141207073724.GA32721@us.ibm.com>
References: <1417572578-9051-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1417572578-9051-2-git-send-email-sukadev@linux.vnet.ibm.com>
 <20141204124422.GA4195@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141204124422.GA4195@krava.brq.redhat.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14120707-0033-0000-0000-000002ED1596
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Olsa [jolsa@redhat.com] wrote:

| anyway we could assign directly to the param term name as you do,
| but I think we just need to mark the term as parametrized, like:
| 
| in /sys/bus/event_source/devices/pmu/events/event_name you have:
|   param2=?,bar=1,param1=?

I like the idea of just using a single ? for required parameters, but
the problem I had with this approach can be seen with these two sysfs
entries:

        $ cat HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE
        domain=0x2,offset=0xe0,starting_index=core,lpar=0x0

        $ cat HPM_0THRD_NON_IDLE_CCYC__VCPU_HOME_CORE
        domain=0x3,offset=0xe0,starting_index=vcpu,lpar=sibling_guest_id

The parameter 'starting_index' refers to a core in one event and vcpu in
another event. We were trying to give a hint as to what it refers to.

Given that, 'starting_index' is not very intuitive, how about discarding
starting_index and replacing with what it really means for the event and,
use a simple '?' to indicate required parameter).

        $ cat HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE
        domain=0x2,offset=0xe0,core=?,lpar=0x0

        $ cat HPM_0THRD_NON_IDLE_CCYC__VCPU_HOME_CORE
        domain=0x3,offset=0xe0,vcpu=?,lpar=?

perf list shows these as:

	hv_24x7/HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE,core=?/ 
	hv_24x7/HPM_0THRD_NON_IDLE_CCYC__VCPU_HOME_CHIP,vcpu=?,lpar=?/

command line would be

	-e hv_24x7/HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE,core=2/ 

	or

	-e hv_24x7/HPM_0THRD_NON_IDLE_CCYC__VCPU_HOME_CHIP,vcpu=2,lpar=7/

and would fail if a required parameter is missing.

This would eliminate the need for new strings like 'sibling_guest_id' (or
as Cody calls it monopolizing strings...)

Following quick patch on top of the patchset shows the changes:

diff --git a/arch/powerpc/perf/hv-24x7.c b/arch/powerpc/perf/hv-24x7.c
index 73d5bfc..a82bc64 100644
--- a/arch/powerpc/perf/hv-24x7.c
+++ b/arch/powerpc/perf/hv-24x7.c
@@ -27,6 +27,8 @@
 #include "hv-24x7-catalog.h"
 #include "hv-common.h"
 
+
+#if 0
 static const char *domain_to_index_string(unsigned domain)
 {
 	switch (domain) {
@@ -40,6 +42,7 @@ static const char *domain_to_index_string(unsigned domain)
 		return "UNKNOWN_DOMAIN_INDEX_STRING";
 	}
 }
+#endif
 
 static const char *event_domain_suffix(unsigned domain)
 {
@@ -114,7 +117,8 @@ static bool catalog_entry_domain_is_valid(unsigned domain)
 /* u3 0-6, one of HV_24X7_PERF_DOMAIN */
 EVENT_DEFINE_RANGE_FORMAT(domain, config, 0, 3);
 /* u16 */
-EVENT_DEFINE_RANGE_FORMAT(starting_index, config, 16, 31);
+EVENT_DEFINE_RANGE_FORMAT(core, config, 16, 31);
+EVENT_DEFINE_RANGE_FORMAT(vcpu, config, 16, 31);
 /* u32, see "data_offset" */
 EVENT_DEFINE_RANGE_FORMAT(offset, config, 32, 63);
 /* u16 */
@@ -127,7 +131,8 @@ EVENT_DEFINE_RANGE(reserved3, config2,  0, 63);
 static struct attribute *format_attrs[] = {
 	&format_attr_domain.attr,
 	&format_attr_offset.attr,
-	&format_attr_starting_index.attr,
+	&format_attr_core.attr,
+	&format_attr_vcpu.attr,
 	&format_attr_lpar.attr,
 	NULL,
 };
@@ -280,19 +285,23 @@ static unsigned core_domains[] = {
 
 static char *event_fmt(struct hv_24x7_event_data *event, unsigned domain)
 {
+	const char *sindex;
 	const char *lpar;
 
-	if (is_physical_domain(domain))
+	if (is_physical_domain(domain)) {
 		lpar = "0x0";
-	else
-		lpar = "$sibling_guest_id";
+		sindex = "core";
+	} else {
+		lpar = "?";
+		sindex = "vcpu";
+	}
 
 	return kasprintf(GFP_KERNEL,
-			"domain=0x%x,offset=0x%x,starting_index=%s,lpar=%s",
+			"domain=0x%x,offset=0x%x,%s=?,lpar=%s",
 			domain,
 			be16_to_cpu(event->event_counter_offs) +
 				be16_to_cpu(event->event_group_record_offs),
-			domain_to_index_string(domain),
+			sindex,
 			lpar);
 }
 
@@ -1061,9 +1070,17 @@ out:
 static unsigned long event_24x7_request(struct perf_event *event, u64 *res,
 		bool success_expected)
 {
+	u16 idx;
+	unsigned domain = event_get_domain(event);
+
+	if (is_physical_domain(domain))
+		idx = event_get_core(event);
+	else
+		idx = event_get_vcpu(event);
+
 	return single_24x7_request(event_get_domain(event),
 				event_get_offset(event),
-				event_get_starting_index(event),
+				idx,
 				event_get_lpar(event),
 				res,
 				success_expected);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index f8674c1..d208fef 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -826,7 +826,7 @@ static char *format_alias(char *buf, int len, struct perf_pmu *pmu,
 	list_for_each_entry(term, &alias->terms, list)
 		if (term->type_val == PARSE_EVENTS__TERM_TYPE_STR)
 			used += snprintf(buf + used, sub_non_neg(len, used),
-					",%s=$%s", term->config,
+					",%s=%s", term->config,
 					term->val.str);
 
 	if (sub_non_neg(len, used) > 0) {





