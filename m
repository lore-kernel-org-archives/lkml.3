Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaHEFjW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 01:39:22 -0400
Received: from mail1.windriver.com ([147.11.146.13]:44241 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753095AbaHEFjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 01:39:21 -0400
From: <Wei.Yang@windriver.com>
To: <ralf@linux-mips.org>
CC: <a.p.zijlstra@chello.nl>, <paulus@samba.org>, <mingo@redhat.com>,
        <acme@kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-mips@linux-mips.org>, <wei.yang@windriver.com>
Subject: [PATCH v1] MIPS: perf: Mark pmu interupt IRQF_NO_THREAD
Date: Tue, 5 Aug 2014 13:37:47 +0800
Message-ID: <1407217067-1144-1-git-send-email-Wei.Yang@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yang Wei <Wei.Yang@windriver.com>

In RT kernel, I ran into the following calltrace, so PMU interrupts cannot
be threaded

in_atomic(): 1, irqs_disabled(): 1, pid: 0, name: swapper/0
INFO: lockdep is turned off.
Call Trace:
[<ffffffff8088595c>] dump_stack+0x1c/0x50
[<ffffffff801a958c>] __might_sleep+0x13c/0x148
[<ffffffff80891c54>] rt_spin_lock+0x3c/0xb0
[<ffffffff801ad29c>] __wake_up+0x3c/0x80
[<ffffffff80243ba4>] perf_event_wakeup+0x8c/0xf8
[<ffffffff80243c50>] perf_pending_event+0x40/0x78
[<ffffffff8023d88c>] irq_work_run+0x74/0xc0
[<ffffffff80152640>] mipsxx_pmu_handle_shared_irq+0x110/0x228
[<ffffffff8015276c>] mipsxx_pmu_handle_irq+0x14/0x30
[<ffffffff801ffda4>] handle_irq_event_percpu+0xbc/0x470
[<ffffffff80204478>] handle_percpu_irq+0x98/0xc8
[<ffffffff801ff284>] generic_handle_irq+0x4c/0x68
[<ffffffff8089748c>] do_IRQ+0x2c/0x48
[<ffffffff80105864>] plat_irq_dispatch+0x64/0xd0 


Signed-off-by: Yang Wei <Wei.Yang@windriver.com>
---
 arch/mips/kernel/perf_event_mipsxx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/kernel/perf_event_mipsxx.c b/arch/mips/kernel/perf_event_mipsxx.c
index 811084f..fd16763 100644
--- a/arch/mips/kernel/perf_event_mipsxx.c
+++ b/arch/mips/kernel/perf_event_mipsxx.c
@@ -550,7 +550,7 @@ static int mipspmu_get_irq(void)
 	if (mipspmu.irq >= 0) {
 		/* Request my own irq handler. */
 		err = request_irq(mipspmu.irq, mipsxx_pmu_handle_irq,
-			IRQF_PERCPU | IRQF_NOBALANCING,
+			IRQF_PERCPU | IRQF_NOBALANCING | IRQF_NO_THREAD,
 			"mips_perf_pmu", NULL);
 		if (err) {
 			pr_warning("Unable to request IRQ%d for MIPS "
-- 
1.7.9.5

