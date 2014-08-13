Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307AbaHMIYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:24:36 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52039 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbaHMIYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:24:34 -0400
Date: Wed, 13 Aug 2014 01:23:40 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-36bbb2f2988a29cdc3f8e0c93478795934553454@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <1406840722-25416-1-git-send-email-andi@firstfloor.org>
References: <1406840722-25416-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Use extended offcore mask on Haswell
Git-Commit-ID: 36bbb2f2988a29cdc3f8e0c93478795934553454
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

Commit-ID:  36bbb2f2988a29cdc3f8e0c93478795934553454
Gitweb:     http://git.kernel.org/tip/36bbb2f2988a29cdc3f8e0c93478795934553454
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 31 Jul 2014 14:05:22 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:10 +0200

perf/x86: Use extended offcore mask on Haswell

HSW-EP has a larger offcore mask than the client Haswell CPUs.
It is the same mask as on Sandy/IvyBridge-EP. All of
Haswell was using the client mask, so some bits were missing.

On the client parts some bits were also missing compared
to Sandy/IvyBridge, in particular the bits to match on a L4
cache hit.

The Haswell core in both client and server incarnations
accepts the same bits (but some are nops), so we can use
the same mask.

So use the snbep extended mask, which is a superset of the
client and the server, for all of Haswell.

This allows specifying a number of extra offcore events, like
for example for HSW-EP.

% perf stat -e cpu/event=0xb7,umask=0x1,offcore_rsp=0x3fffc00100,name=offcore_response_pf_l3_rfo_l3_miss_any_response/ true

which were <not supported> before.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Reviewed-by: eranian@google.com
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1406840722-25416-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel.c b/arch/x86/kernel/cpu/perf_event_intel.c
index 38d1f6d..89bc750 100644
--- a/arch/x86/kernel/cpu/perf_event_intel.c
+++ b/arch/x86/kernel/cpu/perf_event_intel.c
@@ -2553,7 +2553,7 @@ __init int intel_pmu_init(void)
 
 		x86_pmu.event_constraints = intel_hsw_event_constraints;
 		x86_pmu.pebs_constraints = intel_hsw_pebs_event_constraints;
-		x86_pmu.extra_regs = intel_snb_extra_regs;
+		x86_pmu.extra_regs = intel_snbep_extra_regs;
 		x86_pmu.pebs_aliases = intel_pebs_aliases_snb;
 		/* all extra regs are per-cpu when HT is on */
 		x86_pmu.er_flags |= ERF_HAS_RSP_1;
