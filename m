Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3IPJV0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 05:21:26 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45518 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751325Ab3IPJVZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 05:21:25 -0400
Date: Mon, 16 Sep 2013 11:21:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: zheng.z.yan@intel.com
Cc: eranian@google.com, Ingo Molnar <mingo@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [BUG] uncore_pmu_event_init: using smp_processor_id() in preemptible
 core
Message-ID: <20130916092110.GA29018@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Trinity just triggered this:

[  595.847438] BUG: using smp_processor_id() in preemptible [00000000] code: trinity-child28/2674
[  595.857378] caller is uncore_pmu_event_init+0x114/0x270
[  595.863262] CPU: 11 PID: 2674 Comm: trinity-child28 Tainted: G        W    3.11.0+ #365
[  595.872146] Hardware name: Supermicro X8DTN/X8DTN, BIOS 4.6.3 01/08/2010
[  595.879656]  000000000000000b ffff880433e09d98 ffffffff81642eb8 ffff880433e09fd8
[  595.888430]  ffff880433e09dc0 ffffffff81367d1e ffff880373621000 ffff880435bacc00
[  595.897330]  0000000000000000 ffff880433e09df8 ffffffff81068394 ffffffff81068285
[  595.906252] Call Trace:
[  595.909127]  [<ffffffff81642eb8>] dump_stack+0x4e/0x82
[  595.914925]  [<ffffffff81367d1e>] debug_smp_processor_id+0xde/0x100
[  595.921903]  [<ffffffff81068394>] uncore_pmu_event_init+0x114/0x270
[  595.928907]  [<ffffffff81068285>] ? uncore_pmu_event_init+0x5/0x270
[  595.935806]  [<ffffffff8114d18c>] perf_init_event+0xcc/0x190

That's in uncore_validate_group() where we allocate the fake_box().

I'm thinking we might as well use raw_smp_processor_id() since it really
doesn't matter where the fake box lives.

---
 arch/x86/kernel/cpu/perf_event_intel_uncore.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index 8ed4458..63c8913 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3031,7 +3031,7 @@ static int uncore_validate_group(struct intel_uncore_pmu *pmu,
 	struct intel_uncore_box *fake_box;
 	int ret = -EINVAL, n;
 
-	fake_box = uncore_alloc_box(pmu->type, smp_processor_id());
+	fake_box = uncore_alloc_box(pmu->type, raw_smp_processor_id());
 	if (!fake_box)
 		return -ENOMEM;
 
