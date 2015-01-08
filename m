Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366AbbAHKI1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:08:27 -0500
Received: from cnbjrel02.sonyericsson.com ([219.141.167.166]:5323 "EHLO
	cnbjrel02.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752756AbbAHKIZ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:08:25 -0500
From: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
To: "'chris@printf.net'" <chris@printf.net>,
        "'ulf.hansson@linaro.org'" <ulf.hansson@linaro.org>,
        "'tim.kryger@gmail.com'" <tim.kryger@gmail.com>,
        "'tgih.jun@samsung.com'" <tgih.jun@samsung.com>,
        "'johan.rudholm@axis.com'" <johan.rudholm@axis.com>,
        "'linux-mmc@vger.kernel.org'" <linux-mmc@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 8 Jan 2015 18:08:21 +0800
Subject: [RFC V2] mmc:change mmc_init workqueue into a freezable workqueue
Thread-Topic: [RFC V2] mmc:change mmc_init workqueue into a freezable
 workqueue
Thread-Index: AdArKscTl4nihDsKS+OgMy1GnhD4twAACQSw
Message-ID: <35FD53F367049845BC99AC72306C23D103EDAF89E193@CNBJMBX05.corpusers.net>
References: <35FD53F367049845BC99AC72306C23D103EDAF89E192@CNBJMBX05.corpusers.net>
In-Reply-To: <35FD53F367049845BC99AC72306C23D103EDAF89E192@CNBJMBX05.corpusers.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fix the mmc driver suspend/resume conflict problems,
mmc workqueue will queue mmc_rescan(), and it will call some
pm_runtime_* functions, this will conflict with suspend path sometimes,
and will result in some strange behavior:

Suspend path:
	-000 |context_switch(inline)
	-000 |__schedule()
	-001 |schedule_preempt_disabled()
	-002 |spin_lock(inline)
	-002 |__mutex_lock_common(inline)
	-002 |__mutex_lock_slowpath(lock_count = 0xEDCD0F48)
	-003 |__mutex_fastpath_lock(inline)
	-003 |mutex_lock(lock = 0xEDCD0F48)
	-004 |sdhci_do_set_ios(host = 0xEDCD0CC0, ios = 0xEDCD0A70)
	-005 |sdhci_set_ios(?, ios = 0xEDCD0A70)
	-006 |mmc_set_ios(host = 0xEDCD0800)
	-007 |mmc_delay(inline)
	-007 |mmc_power_off(host = 0xEDCD0800)
	-008 |mmc_suspend_host(inline)
	-008 |mmc_suspend_host(host = 0xEDCD0800)
	-009 |mmc_host_suspend(dev = 0xEDCD0808)
	-010 |dpm_run_callback(cb = 0xC0627A88, dev = 0xEDCD0808, state = (event = 2), info = 0xC0B6EF9B)
	-011 |__device_suspend(dev = 0xEDCD0808, state = (event = 2), ?)
	-012 |device_suspend(inline)
	-012 |dpm_suspend(state = (event = 2))
	-013 |suspend_devices_and_enter(state = 3)
	-014 |enter_state(inline)
	-014 |pm_suspend(state = 3)
	-015 |try_to_suspend(?)
	-016 |static_key_false(inline)
	-016 |trace_workqueue_execute_end(inline)
	-016 |process_one_work(worker = 0xD5E87040, work = 0xC0E3FF54)
	-017 |worker_thread(__worker = 0xD5E87040)
	-018 |kthread(_create = 0xE9FFBF10)
	-019 |kernel_thread_exit(asm)
	 --- |end of frame

mmc_rescan() resume path:
	 -000 |context_switch(inline)
	 -000 |__schedule()
	 -001 |do_undefinstr(regs = 0xD12242F0)
	 -002 |__und_svc(asm)
	  --> |exception
	  -003 |sdhci_set_power(host = 0xEDCD0CC0, power = 0)
	  -004 |sdhci_do_set_ios(host = 0xEDCD0CC0, ios = 0xEDCD0A70)
	  -005 |sdhci_set_ios(?, ios = 0xEDCD0A70)
	  -006 |mmc_set_ios(host = 0xEDCD0800)
	  -007 |mmc_delay(inline)
	  -007 |mmc_power_up(host = 0xEDCD0800)
	  -008 |mmc_resume_bus(inline)
	  -008 |mmc_resume_bus(host = 0xEDCD0800)
	  -009 |mmc_rpm_hold(host = 0xEDCD0800, ?)
	  -010 |mmc_rescan(work = 0xEDCD0AB0)
	  -011 |static_key_false(inline)
	  -011 |trace_workqueue_execute_end(inline)
	  -011 |process_one_work(worker = 0xE5F0BBC0, work = 0xEDCD0AB0)
	  -012 |worker_thread(__worker = 0xE5F0BBC0)
	  -013 |kthread(_create = 0xD03A5F10)
	  -014 |kernel_thread_exit(asm)
	   --- |end of frame

most mmc power callback function don't check this special case, and
will cause problems.

Signed-off-by: Yalin Wang <yalin.wang@sonymobile.com>
---
 drivers/mmc/core/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index a6c139d..ae8757f 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -3881,7 +3881,7 @@ static int __init mmc_init(void)
 {
 	int ret;
 
-	workqueue = alloc_ordered_workqueue("kmmcd", 0);
+	workqueue = alloc_ordered_workqueue("kmmcd", WQ_FREEZABLE);
 	if (!workqueue)
 		return -ENOMEM;
 
-- 
2.1.3

