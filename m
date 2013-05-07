Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759556Ab3EGEfE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 00:35:04 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13075 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759555Ab3EGEZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 00:25:52 -0400
X-Authority-Analysis: v=2.0 cv=cOZiQyiN c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=d31XBkAe-3MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=JTs2u2NijhMA:10 a=1XWaLZrsAAAA:8 a=JfrnYn6hAAAA:8 a=20KFwNOVAAAA:8 a=ag1SF4gXAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=Z9hppVypvsQCDiRzgicA:9 a=UTB_XpHje0EA:10 a=3Rfx1nUSh_UA:10 a=jEp0ucaQiEUA:10 a=1TSTQ8KKaH4A:10 a=LI9Vle30uBYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130507035854.858307018@goodmis.org>
User-Agent: quilt/0.60-1
Date: Mon, 06 May 2013 23:58:35 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Stephane Eranian <eranian@google.com>, <peterz@infradead.org>,
        <jolsa@redhat.com>, <gregkh@linuxfoundation.org>,
        <security@kernel.org>, <ak@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [083/126] perf/x86: Fix offcore_rsp valid mask for SNB/IVB
References: <20130507035712.909872333@goodmis.org>
Content-Disposition: inline; filename=0083-perf-x86-Fix-offcore_rsp-valid-mask-for-SNB-IVB.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.3 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Stephane Eranian <eranian@google.com>

[ Upstream commit f1923820c447e986a9da0fc6bf60c1dccdf0408e ]

The valid mask for both offcore_response_0 and
offcore_response_1 was wrong for SNB/SNB-EP,
IVB/IVB-EP. It was possible to write to
reserved bit and cause a GP fault crashing
the kernel.

This patch fixes the problem by correctly marking the
reserved bits in the valid mask for all the processors
mentioned above.

A distinction between desktop and server parts is introduced
because bits 24-30 are only available on the server parts.

This version of the  patch is just a rebase to perf/urgent tree
and should apply to older kernels as well.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: peterz@infradead.org
Cc: jolsa@redhat.com
Cc: gregkh@linuxfoundation.org
Cc: security@kernel.org
Cc: ak@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 6bca492..5e6b361 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -128,8 +128,14 @@ static struct event_constraint intel_gen_event_constraints[] __read_mostly =
 };
 
 static struct extra_reg intel_snb_extra_regs[] __read_mostly = {
-	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffffffffull, RSP_0),
-	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffffffffull, RSP_1),
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3f807f8fffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3f807f8fffull, RSP_1),
+	EVENT_EXTRA_END
+};
+
+static struct extra_reg intel_snbep_extra_regs[] __read_mostly = {
+	INTEL_EVENT_EXTRA_REG(0xb7, MSR_OFFCORE_RSP_0, 0x3fffff8fffull, RSP_0),
+	INTEL_EVENT_EXTRA_REG(0xbb, MSR_OFFCORE_RSP_1, 0x3fffff8fffull, RSP_1),
 	EVENT_EXTRA_END
 };
 
@@ -2058,7 +2064,10 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		if (boot_cpu_data.x86_model == 45)
+			x86_pmu.extra_regs = intel_snbep_extra_regs;
+		else
+			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
@@ -2083,7 +2092,10 @@ __init int intel_pmu_init(void)
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_ivb_pebs_event_constraints;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		if (boot_cpu_data.x86_model == 62)
+			x86_pmu.extra_regs = intel_snbep_extra_regs;
+		else
+			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;
-- 
1.7.10.4


