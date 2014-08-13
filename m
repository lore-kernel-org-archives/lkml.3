Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545AbaHMIY4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 04:24:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52055 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbaHMIYy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 04:24:54 -0400
Date: Wed, 13 Aug 2014 01:24:07 -0700
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-03de874aa76ac0adcf6f56ebf3de623d09a5dde3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, ak@linux.intel.com, acme@kernel.org,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        peterz@infradead.org, ak@linux.intel.com, tglx@linutronix.de,
        acme@kernel.org
In-Reply-To: <1407456534-15747-1-git-send-email-andi@firstfloor.org>
References: <1407456534-15747-1-git-send-email-andi@firstfloor.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf/x86: Fix :pp without LBR
Git-Commit-ID: 03de874aa76ac0adcf6f56ebf3de623d09a5dde3
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

Commit-ID:  03de874aa76ac0adcf6f56ebf3de623d09a5dde3
Gitweb:     http://git.kernel.org/tip/03de874aa76ac0adcf6f56ebf3de623d09a5dde3
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Thu, 7 Aug 2014 17:08:54 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 13 Aug 2014 07:51:12 +0200

perf/x86: Fix :pp without LBR

This fixes a side effect of Kan's earlier patch to probe the LBRs at boot
time. Normally when the LBRs are disabled cycles:pp is disabled too.
So for example cycles:pp doesn't work.

However this is not needed with PEBSv2 and later (Haswell) because
it does not need LBRs to correct the IP-off-by-one.

So add an extra check for PEBSv2 that also allows :pp

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: kan.liang@intel.com
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Link: http://lkml.kernel.org/r/1407456534-15747-1-git-send-email-andi@firstfloor.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event.c b/arch/x86/kernel/cpu/perf_event.c
index 2879ecd..0646d3b 100644
--- a/arch/x86/kernel/cpu/perf_event.c
+++ b/arch/x86/kernel/cpu/perf_event.c
@@ -387,7 +387,7 @@ int x86_pmu_hw_config(struct perf_event *event)
 			precise++;
 
 			/* Support for IP fixup */
-			if (x86_pmu.lbr_nr)
+			if (x86_pmu.lbr_nr || x86_pmu.intel_cap.pebs_format >= 2)
 				precise++;
 		}
 
