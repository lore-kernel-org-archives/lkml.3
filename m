Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaDPBrD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:47:03 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:40968 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951AbaDPBrA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:47:00 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s3G1kIPx004869, This message is accepted by code: ctloc85258
Message-ID: <534DE1D7.3000308@realsil.com.cn>
Date: Wed, 16 Apr 2014 09:50:15 +0800
From: micky <micky_ching@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>
CC: Chris Ball <chris@printf.net>, Wei WANG <wei_wang@realsil.com.cn>
Subject: Re: rtsx_pci_sdmmc lockdep splat
References: <20140415174934.GD4826@pd.tnic>
In-Reply-To: <20140415174934.GD4826@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.29.41.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav,

On 04/16/2014 01:49 AM, Borislav Petkov wrote:
> Hi all,
>
> I'm seeing the following when I insert an sd card. Kernel is 3.15-rc1+.
>
> Thanks.
The patch below may fix this problem.

From: Micky Ching<micky_ching@realsil.com.cn>

To avoid dead lock, we need make sure host->lock is always acquire
before pcr->lock. But in irq handler, we acquired pcr->lock in rtsx mfd
driver, and sd_isr_done_transfer() is called during pcr->lock already
acquired. Since in sd_isr_done_transfer() the only work we do is schdule
tasklet, the cmd_tasklet and data_tasklet never conflict, so it is safe
to remove spin_lock() here.

Signed-off-by: Micky Ching<micky_ching@realsil.com.cn>
---
  drivers/mmc/host/rtsx_pci_sdmmc.c |    4 +---
  1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c b/drivers/mmc/host/rtsx_pci_sdmmc.c
index 453e1d4..40695e0 100644
--- a/drivers/mmc/host/rtsx_pci_sdmmc.c
+++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
@@ -108,12 +108,10 @@ static void sd_isr_done_transfer(struct platform_device *pdev)
  {
  	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
  
-	spin_lock(&host->lock);
  	if (host->cmd)
  		tasklet_schedule(&host->cmd_tasklet);
-	if (host->data)
+	else if (host->data)
  		tasklet_schedule(&host->data_tasklet);
-	spin_unlock(&host->lock);
  }
  
  static void sd_request_timeout(unsigned long host_addr)
-- 
1.7.9.5

I have send out this patch, Thanks.
Best Regards.
micky.

> [  682.675345] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: sdmmc_get_cd: RTSX_BIPR = 0x00010000
> [  682.679723] mmc0: mmc_rescan_try_freq: trying to init card at 400000 Hz
> [  682.683778] mmc0: clock 0Hz busmode 2 powermode 1 cs 0 Vdd 21 width 0 timing 0
> [  682.689135] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: sdmmc_switch_voltage: signal_voltage = 0
> [  682.701892] mmc0: clock 400000Hz busmode 2 powermode 2 cs 0 Vdd 21 width 0 timing 0
> [  682.718034] mmc0: starting CMD52 arg 00000c00 flags 00000195
> [  682.720975] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: sd_send_cmd: SD/MMC CMD 52, arg = 0x00000c00
> [  682.723749]
> [  682.726488] ======================================================
> [  682.729295] [ INFO: possible circular locking dependency detected ]
> [  682.732138] 3.15.0-rc1+ #3 Not tainted
> [  682.734989] -------------------------------------------------------
> [  682.737905] kworker/u4:0/6 is trying to acquire lock:
> [  682.740853]  (&(&pcr->lock)->rlock){-.-...}, at: [<ffffffffa0004387>] rtsx_pci_add_cmd+0x47/0xb0 [rtsx_pci]
> [  682.743945]
> [  682.743945] but task is already holding lock:
> [  682.749951]  (&(&host->lock)->rlock#3){-.....}, at: [<ffffffffa00bc577>] sdmmc_request+0x57/0x579 [rtsx_pci_sdmmc]
> [  682.753076]
> [  682.753076] which lock already depends on the new lock.
> [  682.753076]
> [  682.762208]
> [  682.762208] the existing dependency chain (in reverse order) is:
> [  682.768191]
> [  682.768191] -> #1 (&(&host->lock)->rlock#3){-.....}:
> [  682.774134]        [<ffffffff810bdfd6>] lock_acquire+0x96/0x130
> [  682.777063]        [<ffffffff8153729b>] _raw_spin_lock+0x3b/0x50
> [  682.779959]        [<ffffffffa00bb91d>] sd_isr_done_transfer+0x2d/0x80 [rtsx_pci_sdmmc]
> [  682.782861]        [<ffffffffa0005679>] rtsx_pci_isr+0x119/0x220 [rtsx_pci]
> [  682.785736]        [<ffffffff810cdea7>] handle_irq_event_percpu+0x47/0x1e0
> [  682.788584]        [<ffffffff810ce088>] handle_irq_event+0x48/0x70
> [  682.791387]        [<ffffffff810d0a9f>] handle_edge_irq+0x8f/0x150
> [  682.794195]        [<ffffffff81004cee>] handle_irq+0x1e/0x30
> [  682.797026]        [<ffffffff8153a8da>] do_IRQ+0x6a/0x110
> [  682.799831]        [<ffffffff8153812f>] ret_from_intr+0x0/0x13
> [  682.802645]        [<ffffffff81099ea8>] __atomic_notifier_call_chain+0x88/0xb0
> [  682.805465]        [<ffffffff81099ee6>] atomic_notifier_call_chain+0x16/0x20
> [  682.808246]        [<ffffffff8133af46>] do_con_write.part.18+0x176/0xa10
> [  682.811028]        [<ffffffff8133b895>] con_write+0x75/0x80
> [  682.813758]        [<ffffffff81324ac5>] n_tty_write+0x325/0x4d0
> [  682.816497]        [<ffffffff81321540>] tty_write+0x150/0x2b0
> [  682.819195]        [<ffffffff8118d571>] do_loop_readv_writev+0x61/0x90
> [  682.821901]        [<ffffffff8118ef25>] do_readv_writev+0x205/0x210
> [  682.824583]        [<ffffffff8118efb0>] vfs_writev+0x30/0x60
> [  682.827226]        [<ffffffff8118f0f2>] SyS_writev+0x52/0xc0
> [  682.829821]        [<ffffffff81538c92>] system_call_fastpath+0x16/0x1b
> [  682.832383]
> [  682.832383] -> #0 (&(&pcr->lock)->rlock){-.-...}:
> [  682.837324]        [<ffffffff810bd570>] __lock_acquire+0x1690/0x1950
> [  682.839790]        [<ffffffff810bdfd6>] lock_acquire+0x96/0x130
> [  682.842229]        [<ffffffff815373f6>] _raw_spin_lock_irqsave+0x46/0x60
> [  682.844650]        [<ffffffffa0004387>] rtsx_pci_add_cmd+0x47/0xb0 [rtsx_pci]
> [  682.847029]        [<ffffffffa00bbc0b>] sd_send_cmd+0xcb/0x3c0 [rtsx_pci_sdmmc]
> [  682.849359]        [<ffffffffa00bc7c0>] sdmmc_request+0x2a0/0x579 [rtsx_pci_sdmmc]
> [  682.851649]        [<ffffffffa009082f>] mmc_start_request+0x16f/0x280 [mmc_core]
> [  682.853921]        [<ffffffffa00909ca>] __mmc_start_req+0x6a/0xa0 [mmc_core]
> [  682.856162]        [<ffffffffa0090f7a>] mmc_wait_for_cmd+0x7a/0xd0 [mmc_core]
> [  682.858387]        [<ffffffffa009bed0>] mmc_io_rw_direct_host+0x90/0x120 [mmc_core]
> [  682.860608]        [<ffffffffa009c416>] sdio_reset+0x26/0x70 [mmc_core]
> [  682.862815]        [<ffffffffa009399d>] mmc_rescan+0x29d/0x350 [mmc_core]
> [  682.865007]        [<ffffffff8108deba>] process_one_work+0x21a/0x560
> [  682.867175]        [<ffffffff8108e320>] worker_thread+0x120/0x390
> [  682.869286]        [<ffffffff81094aac>] kthread+0xfc/0x120
> [  682.871341]        [<ffffffff81538bec>] ret_from_fork+0x7c/0xb0
> [  682.873404]
> [  682.873404] other info that might help us debug this:
> [  682.873404]
> [  682.879197]  Possible unsafe locking scenario:
> [  682.879197]
> [  682.883048]        CPU0                    CPU1
> [  682.884972]        ----                    ----
> [  682.886860]   lock(&(&host->lock)->rlock#3);
> [  682.888763]                                lock(&(&pcr->lock)->rlock);
> [  682.890686]                                lock(&(&host->lock)->rlock#3);
> [  682.892608]   lock(&(&pcr->lock)->rlock);
> [  682.894492]
> [  682.894492]  *** DEADLOCK ***
> [  682.894492]
> [  682.899913] 4 locks held by kworker/u4:0/6:
> [  682.901735]  #0:  ("kmmcd"){.+.+..}, at: [<ffffffff8108de45>] process_one_work+0x1a5/0x560
> [  682.903677]  #1:  ((&(&host->detect)->work)){+.+...}, at: [<ffffffff8108de45>] process_one_work+0x1a5/0x560
> [  682.905678]  #2:  (&pcr->pcr_mutex){+.+...}, at: [<ffffffffa00bc56f>] sdmmc_request+0x4f/0x579 [rtsx_pci_sdmmc]
> [  682.907737]  #3:  (&(&host->lock)->rlock#3){-.....}, at: [<ffffffffa00bc577>] sdmmc_request+0x57/0x579 [rtsx_pci_sdmmc]
> [  682.909851]
> [  682.909851] stack backtrace:
> [  682.913909] CPU: 1 PID: 6 Comm: kworker/u4:0 Not tainted 3.15.0-rc1+ #3
> [  682.915987] Hardware name: LENOVO 30515QG/30515QG, BIOS 8RET30WW (1.12 ) 09/15/2011
> [  682.918124] Workqueue: kmmcd mmc_rescan [mmc_core]
> [  682.920264]  ffffffff8202f4f0 ffff880119949940 ffffffff8152f1c5 ffffffff81ff6fd0
> [  682.922471]  ffff880119949980 ffffffff8152c20e ffff8801199499d0 ffff8801198e59a8
> [  682.924690]  0000000000000003 ffff8801198e51e0 0000000000000004 ffff8801198e59a8
> [  682.926923] Call Trace:
> [  682.929136]  [<ffffffff8152f1c5>] dump_stack+0x4e/0x7a
> [  682.931384]  [<ffffffff8152c20e>] print_circular_bug+0x203/0x211
> [  682.933625]  [<ffffffff810bd570>] __lock_acquire+0x1690/0x1950
> [  682.935869]  [<ffffffff81537591>] ? _raw_spin_unlock_irqrestore+0x41/0x80
> [  682.938106]  [<ffffffffa0004387>] ? rtsx_pci_add_cmd+0x47/0xb0 [rtsx_pci]
> [  682.940345]  [<ffffffff810bdfd6>] lock_acquire+0x96/0x130
> [  682.942585]  [<ffffffffa0004387>] ? rtsx_pci_add_cmd+0x47/0xb0 [rtsx_pci]
> [  682.944835]  [<ffffffff815373f6>] _raw_spin_lock_irqsave+0x46/0x60
> [  682.947089]  [<ffffffffa0004387>] ? rtsx_pci_add_cmd+0x47/0xb0 [rtsx_pci]
> [  682.949350]  [<ffffffffa0004387>] rtsx_pci_add_cmd+0x47/0xb0 [rtsx_pci]
> [  682.951601]  [<ffffffffa00bbc0b>] sd_send_cmd+0xcb/0x3c0 [rtsx_pci_sdmmc]
> [  682.953849]  [<ffffffffa00bc7c0>] sdmmc_request+0x2a0/0x579 [rtsx_pci_sdmmc]
> [  682.956116]  [<ffffffffa009082f>] mmc_start_request+0x16f/0x280 [mmc_core]
> [  682.958382]  [<ffffffffa00909ca>] __mmc_start_req+0x6a/0xa0 [mmc_core]
> [  682.960642]  [<ffffffffa0090f7a>] mmc_wait_for_cmd+0x7a/0xd0 [mmc_core]
> [  682.962906]  [<ffffffffa0090940>] ? mmc_start_request+0x280/0x280 [mmc_core]
> [  682.965183]  [<ffffffffa009bed0>] mmc_io_rw_direct_host+0x90/0x120 [mmc_core]
> [  682.967471]  [<ffffffffa009c416>] sdio_reset+0x26/0x70 [mmc_core]
> [  682.969765]  [<ffffffffa009399d>] mmc_rescan+0x29d/0x350 [mmc_core]
> [  682.972056]  [<ffffffff8108deba>] process_one_work+0x21a/0x560
> [  682.974342]  [<ffffffff8108de45>] ? process_one_work+0x1a5/0x560
> [  682.976634]  [<ffffffff8108e320>] worker_thread+0x120/0x390
> [  682.978916]  [<ffffffff8108e200>] ? process_one_work+0x560/0x560
> [  682.981209]  [<ffffffff81094aac>] kthread+0xfc/0x120
> [  682.983499]  [<ffffffff815375fc>] ? _raw_spin_unlock_irq+0x2c/0x60
> [  682.985826]  [<ffffffff810949b0>] ? kthread_create_on_node+0x1f0/0x1f0
> [  682.988182]  [<ffffffff81538bec>] ret_from_fork+0x7c/0xb0
> [  682.990534]  [<ffffffff810949b0>] ? kthread_create_on_node+0x1f0/0x1f0
> [  683.033350] rtsx_pci_sdmmc rtsx_pci_sdmmc.0: timeout for request
>

