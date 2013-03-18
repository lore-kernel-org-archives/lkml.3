Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab3CRNqx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 09:46:53 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:48912 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059Ab3CRNqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 09:46:50 -0400
Date: Mon, 18 Mar 2013 14:46:45 +0100
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, jolsa@redhat.com, sqazi@google.com,
        ak@linux.intel.com
Subject: [PATCH] perf,x86: fix uninitialized pt_regs in
 intel_pmu_drain_bts_buffer()
Message-ID: <20130318134645.GA3278@quad>
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

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/arch/x86/kernel/cpu/perf_event_intel_ds.c b/arch/x86/kernel/cpu/perf_event_intel_ds.c
index b05a575..208f0c8 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_ds.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_ds.c
@@ -302,6 +302,8 @@ int intel_pmu_drain_bts_buffer(void)
 	struct perf_sample_data data;
 	struct pt_regs regs;
 
+	memset(&regs, 0, sizeof(regs));
+
 	if (!event)
 		return 0;
 
