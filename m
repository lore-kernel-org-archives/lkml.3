Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557Ab3CUSQf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 14:16:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33589 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073Ab3CUSQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 14:16:33 -0400
Date: Thu, 21 Mar 2013 11:15:17 -0700
From: tip-bot for Stephane Eranian <tipbot@zytor.com>
Message-ID: <tip-0e48026ae7abf871e51eaa9183c81ab5bef4c267@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl,
        tglx@linutronix.de
In-Reply-To: <20130319151038.GA25439@quad>
References: <20130319151038.GA25439@quad>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf/x86:
  Fix uninitialized pt_regs in intel_pmu_drain_bts_buffer()
Git-Commit-ID: 0e48026ae7abf871e51eaa9183c81ab5bef4c267
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 21 Mar 2013 11:15:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0e48026ae7abf871e51eaa9183c81ab5bef4c267
Gitweb:     http://git.kernel.org/tip/0e48026ae7abf871e51eaa9183c81ab5bef4c267
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Tue, 19 Mar 2013 16:10:38 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 21 Mar 2013 12:03:29 +0100

perf/x86: Fix uninitialized pt_regs in intel_pmu_drain_bts_buffer()

This patch fixes an uninitialized pt_regs struct in drain BTS
function. The pt_regs struct is propagated all the way to the
code_get_segment() function from perf_instruction_pointer()
and may get garbage.

We cannot simply inherit the actual pt_regs from the interrupt
because BTS must be flushed on context-switch or when the
associated event is disabled. And there we do not have a pt_regs
handy.

Setting pt_regs to all zeroes may not be the best option but it
is not clear what else to do given where the drain_bts_buffer()
is called from.

In V2, we move the memset() later in the code to avoid doing it
when we end up returning early without doing the actual BTS
processing. Also dropped the reg.val initialization because it
is redundant with the memset() as suggested by PeterZ.

Signed-off-by: Stephane Eranian <eranian@google.com>
Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: peterz@infradead.org
Cc: sqazi@google.com
Cc: ak@linux.intel.com
Cc: jolsa@redhat.com
Link: http://lkml.kernel.org/r/20130319151038.GA25439@quad
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/cpu/perf_event_intel_ds.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index 826054a..f71c9f0 100644
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
