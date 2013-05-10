Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3EJOm6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 10:42:58 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57058 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754593Ab3EJOUq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 10:20:46 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ingo Molnar" <mingo@kernel.org>,
        "Stephane Eranian" <eranian@google.com>, peterz@infradead.org,
        jolsa@redhat.com, security@kernel.org, gregkh@linuxfoundation.org,
        ak@linux.intel.com
Date: Fri, 10 May 2013 14:39:41 +0100
Message-ID: <lsq.1368193181.86165221@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [079/118] perf/x86: Fix offcore_rsp valid mask for SNB/IVB
In-Reply-To: <lsq.1368193179.973009354@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d51a:8785:aa0a:cebe
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.45-rc1 review patch.  If anyone has any objections, please let me know.

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
Cc: gregkh@linuxfoundation.org
Cc: security@kernel.org
Cc: ak@linux.intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
[bwh: Backported to 3.2: adjust context; drop the IVB case]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/perf_event_intel.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -130,8 +130,14 @@ static struct event_constraint intel_gen
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
 
@@ -1711,7 +1717,10 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_snb_event_constraints;
 		x86_pmu.pebs_constraints = intel_snb_pebs_event_constraints;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		if (boot_cpu_data.x86_model == 45)
+			x86_pmu.extra_regs = intel_snbep_extra_regs;
+		else
+			x86_pmu.extra_regs = intel_snb_extra_regs;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
 		x86_pmu.er_flags |= ERF_NO_HT_SHARING;

