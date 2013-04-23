Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab3DWVyG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 17:54:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34164 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932174Ab3DWVxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 17:53:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>,
        peterz@infradead.org, jolsa@redhat.com, ak@linux.intel.com
Subject: [ 31/42] perf/x86: Fix offcore_rsp valid mask for SNB/IVB
Date: Tue, 23 Apr 2013 14:52:29 -0700
Message-Id: <20130423215208.656029780@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130423215205.523980967@linuxfoundation.org>
References: <20130423215205.523980967@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stephane Eranian <eranian@google.com>

commit f1923820c447e986a9da0fc6bf60c1dccdf0408e upstream.

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
Cc: ak@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/cpu/perf_event_intel.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -128,8 +128,14 @@ static struct event_constraint intel_gen
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
 
@@ -2072,7 +2078,10 @@ __init int intel_pmu_init(void)
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
@@ -2098,7 +2107,10 @@ __init int intel_pmu_init(void)
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


