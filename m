Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758949AbbA1VSF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 16:18:05 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40980 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762180AbbA1Uu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:50:28 -0500
Date: Wed, 28 Jan 2015 07:05:37 -0800
From: tip-bot for Cody P Schafer <tipbot@zytor.com>
Message-ID: <tip-aaea36174991ff39c7a18044660db86527100c55@git.kernel.org>
Cc: mpe@ellerman.id.au, tglx@linutronix.de, hbabu@us.ibm.com, paulus@samba.org,
        hpa@zytor.com, jolsa@redhat.com, sukadev@linux.vnet.ibm.com,
        peterz@infradead.org, acme@redhat.com, cody@linux.vnet.ibm.com,
        mingo@kernel.org, dev@codyps.com, jolsa@kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: linux-kernel@vger.kernel.org, dev@codyps.com, jolsa@kernel.org,
        mingo@kernel.org, cody@linux.vnet.ibm.com, acme@redhat.com,
        peterz@infradead.org, sukadev@linux.vnet.ibm.com, hpa@zytor.com,
        jolsa@redhat.com, hbabu@us.ibm.com, paulus@samba.org,
        tglx@linutronix.de, mpe@ellerman.id.au
In-Reply-To: <1420679633-28856-3-git-send-email-sukadev@linux.vnet.ibm.com>
References: <1420679633-28856-3-git-send-email-sukadev@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Extend format_alias()
  to include event parameters
Git-Commit-ID: aaea36174991ff39c7a18044660db86527100c55
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  aaea36174991ff39c7a18044660db86527100c55
Gitweb:     http://git.kernel.org/tip/aaea36174991ff39c7a18044660db86527100c55
Author:     Cody P Schafer <cody@linux.vnet.ibm.com>
AuthorDate: Wed, 7 Jan 2015 17:13:51 -0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 21 Jan 2015 13:24:33 -0300

perf tools: Extend format_alias() to include event parameters

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
index bfbecf7..4841167 100644
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
 
