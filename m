Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab3ILLMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 07:12:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:34468 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab3ILLMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 07:12:16 -0400
Date: Thu, 12 Sep 2013 04:11:48 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-dbc33f7016747bfce64f3d1e3af63f1251fcbf85@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, ak@linux.intel.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, ak@linux.intel.com, tglx@linutronix.de
In-Reply-To: <20130909195350.GA17643@google.com>
References: <20130909195350.GA17643@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86: Fix uncore PCI fixed counter handling
Git-Commit-ID: dbc33f7016747bfce64f3d1e3af63f1251fcbf85
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 12 Sep 2013 04:11:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  dbc33f7016747bfce64f3d1e3af63f1251fcbf85
Gitweb:     http://git.kernel.org/tip/dbc33f7016747bfce64f3d1e3af63f1251fcbf85
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Mon, 9 Sep 2013 12:53:50 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 12 Sep 2013 08:42:37 +0200

perf/x86: Fix uncore PCI fixed counter handling

There was a bug in the handling of SNB-EP/IVB-EP uncore PCI
fixed counters, e.g., IMC.

It would cause erratic values to be returned for the IMC
clockticks event. This was due to a bogus hwc->config value
which was then written to PCI config space.

The erratic values can be seen via:

  $ perf stat -a -C 0 -e uncore_imc_0/clockticks/ -I 1000 sleep 10

The fixed counter has most fields marked as reserved with
hw reset values of 0. Yet the kernel was defaulting to a
hwc->config = ~0 and that was causing the issues.

This patch sets the hwc->config values for fixed uncore event
to 0. Now, the values of IMC clockticks is correct.

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Andi Kleen <ak@linux.intel.com>
Cc: peterz@infradead.org
Cc: zheng.z.yan@intel.com
Link: http://lkml.kernel.org/r/20130909195350.GA17643@google.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index fd8011e..8ed4458 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -2808,7 +2808,7 @@ uncore_get_event_constraint(struct intel_uncore_box *box, struct perf_event *eve
 			return c;
 	}
 
-	if (event->hw.config == ~0ULL)
+	if (event->attr.config == UNCORE_FIXED_EVENT)
 		return &constraint_fixed;
 
 	if (type->constraints) {
@@ -3112,7 +3112,9 @@ static int uncore_pmu_event_init(struct perf_event *event)
 		 */
 		if (pmu->type->single_fixed && pmu->pmu_idx > 0)
 			return -EINVAL;
-		hwc->config = ~0ULL;
+
+		/* fixed counters have event field hardcoded to zero */
+		hwc->config = 0ULL;
 	} else {
 		hwc->config = event->attr.config & pmu->type->event_mask;
 		if (pmu->type->ops->hw_config) {
