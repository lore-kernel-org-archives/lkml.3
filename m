Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab3CSPKo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 11:10:44 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:38472 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754705Ab3CSPKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 11:10:43 -0400
Date: Tue, 19 Mar 2013 16:10:38 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, sqazi@google.com, ak@linux.intel.com,
        jolsa@redhat.com
Subject: [PATCH v2] perf,x86: fix uninitialized pt_regs in
 intel_pmu_drain_bts_buffer()
Message-ID: <20130319151038.GA25439@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch fixes an uninitialized pt_regs struct in drain BTS
function. The pt_regs struct is propagated all the way to the
code_get_segment() function from perf_instruction_pointer()
and may get garbage.

We cannot simply inherit the actual pt_regs from the interrupt
because BTS must be flushed on context-switch or when the associated
event is disabled. And there we do not have a pt_regs handy.

Setting pt_regs to all zeroes may not be the best option but it is
not clear what else to do given where the drain_bts_buffer() is called
from.

In V2, we move the memset() later in the code to avoid doing it when
we end up returning early without doing the actual BTS processing.
Also dropped the reg.val initialization because it is redundant with
the memset() as suggested by PeterZ.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b05a575..26830f3 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -314,10 +314,11 @@ int intel_pmu_drain_bts_buffer(void)
 	if (top <= at)
 		return 0;
 
+	memset(&regs, 0, sizeof(regs));
+
 	ds->bts_index = ds->bts_buffer_base;
 
 	perf_sample_data_init(&data, 0, event->hw.last_period);
-	regs.ip     = 0;
 
 	/*
 	 * Prepare a generic sample, i.e. fill in the invariant fields.
