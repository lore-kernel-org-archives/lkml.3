Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbaDROBN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 10:01:13 -0400
Received: from lekensteyn.nl ([178.21.112.251]:45628 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307AbaDROBL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 10:01:11 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: driverdev-devel@linuxdriverproject.org
Cc: micky_ching@realsil.com.cn, chris@printf.net, sameo@linux.intel.com,
        ulf.hansson@linaro.org, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com,
        devel@linuxdriverproject.org, dan.carpenter@oracle.com
Subject: Re: [PATCH] mmc: rtsx: fix possible circular locking dependency
Date: Fri, 18 Apr 2014 16:00:53 +0200
Message-ID: <29134783.v67ScDLFcC@al>
User-Agent: KMail/4.12.4 (Linux/3.14.0-rc7-custom-00033-g8878439; KDE/4.12.4; x86_64; ; )
In-Reply-To: <1397612325-4968-1-git-send-email-micky_ching@realsil.com.cn>
References: <1397612325-4968-1-git-send-email-micky_ching@realsil.com.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Wednesday 16 April 2014 09:38:44 micky_ching@realsil.com.cn wrote:
> From: Micky Ching <micky_ching@realsil.com.cn>
> 
> To avoid dead lock, we need make sure host->lock is always acquire
> before pcr->lock. But in irq handler, we acquired pcr->lock in rtsx mfd
> driver, and sd_isr_done_transfer() is called during pcr->lock already
> acquired. Since in sd_isr_done_transfer() the only work we do is schdule
> tasklet, the cmd_tasklet and data_tasklet never conflict, so it is safe
> to remove spin_lock() here.
> 
> Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> ---
>  drivers/mmc/host/rtsx_pci_sdmmc.c |    4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

This patch came from https://lkml.kernel.org/r/534DE1D7.3000308@realsil.com.cn
("Re: rtsx_pci_sdmmc lockdep splat").

With v3.15-rc1-49-g10ec34f, I have a hung machine when inserting a SD card.
lockdep was not enabled for the kernel, I have not bisected yet.
This patch on top of that kernel version does not help (tested by
rmmod rtsx_pci_sdmmc and insmod the patched one).

Console (as typed over from a picture, sorry for any typos):
WARNING: CPU: 1 PID: 0 at kernel/locking/mutex.c:698
DEBUG_LOCKS_WARN_ON(in_interrupt())
Modules linked in: ...
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.15-rc1-custom-000049-g10ec34f #5
Hardware name: Shuttle Inc. XS36V/XS36V, BIOS 1.11 12/18/2012
Call trace:
<IRQ> dump_stack
warn_slowpath_common
warn_slowpath_fmt
__mutex_unlock_slowpath
mutex_unlock
sd_finish_request [rtsx_pci_sdmmc]
tasklet_action
__do_softirq
irq_exit
smp_apic_timer_interrupt
apic_timer_interrupt
<EOI> ? cpuidle_enter_state
cpuidle_enter
cpu_startup_entry
start_secondary
---[end trace ...]---
(60 seconds later:)
INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=18004 jiffies, g=3264, c=3263, q=2)
INFO: Stall ended before state dump start

I also managed to get this trace about 106 seconds later when switching TTY:
INFO: task kworker/... blocked for more than 120 seconds
Workqueue: kmmcd mm_rescan [mmc_core]
Call trace:
? update_rq_clock.part80
? internal_add_timer
schedule
schedule_preempt
__mutex_lock_slowpath
mutex_lock
sdmmc_request [rtsx_pci_sdmmc]
mmc_start_request [mmc_core]
__mmc_start_req [mmc_core]
mmc_wait_for_cmd [mmc_core]
? mmc_release_host [mmc_core]
mmc_io_rw_direct_host [mmc_core]

I'll try to get a lockdep kernel and text logs later, but perhaps you already
know the issue?

Peter

> diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c
> b/drivers/mmc/host/rtsx_pci_sdmmc.c index 453e1d4..40695e0 100644
> --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> @@ -108,12 +108,10 @@ static void sd_isr_done_transfer(struct
> platform_device *pdev) {
>  	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
> 
> -	spin_lock(&host->lock);
>  	if (host->cmd)
>  		tasklet_schedule(&host->cmd_tasklet);
> -	if (host->data)
> +	else if (host->data)
>  		tasklet_schedule(&host->data_tasklet);
> -	spin_unlock(&host->lock);
>  }
> 
>  static void sd_request_timeout(unsigned long host_addr)

