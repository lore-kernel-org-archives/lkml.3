Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754423AbaDRXNW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 19:13:22 -0400
Received: from lekensteyn.nl ([178.21.112.251]:48703 "EHLO lekensteyn.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751807AbaDRXNT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 19:13:19 -0400
From: Peter Wu <peter@lekensteyn.nl>
To: driverdev-devel@linuxdriverproject.org
Cc: micky_ching@realsil.com.cn, chris@printf.net, sameo@linux.intel.com,
        ulf.hansson@linaro.org, gregkh@linuxfoundation.org,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        wei_wang@realsil.com.cn, rogerable@realtek.com,
        devel@linuxdriverproject.org, dan.carpenter@oracle.com,
        Borislav Petkov <bp@alien8.de>
Subject: Locking issues in "mmc: rtsx: add support for pre_req and post_req"  (was: Re: [PATCH] mmc: rtsx: fix possible circular locking dependency)
Date: Sat, 19 Apr 2014 01:13:04 +0200
Message-ID: <4100650.KWclyjzvIH@al>
User-Agent: KMail/4.12.4 (Linux/3.14.0-rc7-custom-00033-g8878439; KDE/4.12.4; x86_64; ; )
In-Reply-To: <29134783.v67ScDLFcC@al>
References: <1397612325-4968-1-git-send-email-micky_ching@realsil.com.cn> <29134783.v67ScDLFcC@al>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So, I reverted c42deffd5b53c9e583d83c7964854ede2f12410d ("mmc: rtsx: add 
support for pre_req and post_req") on top of v3.15-rc1-49-g10ec34f and the 
hang issue went away.

There is something that is possibly problematic. All three tasklets (cmd, 
data, finish) try to spinlock on host->lock. According to the tasklets 
documentation[1], they always run at interrupts (i.e., at any time, possibly 
right after tasklet_schedule if I got this right?).

These tasklets however do get scheduled *under* the host->lock which will 
cause a deadlock. This proposed patch ("mmc: rtsx: fix possible circular 
locking dependency") fixes the issue for sd_isr_done_transfer, but there are 
others:

1. sd_request_timeout:
 125         spin_lock_irqsave(&host->lock, flags);
 ...
 139 out:
 140         tasklet_schedule(&host->finish_tasklet); // <--
 141         spin_unlock_irqrestore(&host->lock, flags);

2. sd_get_rsp (cmd_tasklet!):
 429         spin_lock_irqsave(&host->lock, flags);
 ...
 506         tasklet_schedule(&host->finish_tasklet); // <--
 507         spin_unlock_irqrestore(&host->lock, flags);

3. sd_finish_multi_rw (data_tasklet!):
 657         spin_lock_irqsave(&host->lock, flags);
 ...
 684         tasklet_schedule(&host->finish_tasklet); // <--
 685         spin_unlock_irqrestore(&host->lock, flags);

4. sdmmc_request:
 921         mutex_lock(&pcr->pcr_mutex);
 922         spin_lock_irqsave(&host->lock, flags);
 ...
 967         tasklet_schedule(&host->finish_tasklet); // <--
 968         spin_unlock_irqrestore(&host->lock, flags);

5. rtsx_pci_sdmmc_drv_remove:
  1526         spin_lock_irqsave(&host->lock, flags);
  1527         if (host->mrq) {
  ...
  1541                 tasklet_schedule(&host->finish_tasklet); // <--
  1542         }
  1543         spin_unlock_irqrestore(&host->lock, flags);
  1544 
  1545         del_timer_sync(&host->timer);
  1546         tasklet_kill(&host->cmd_tasklet);
  1547         tasklet_kill(&host->data_tasklet);
  1548         tasklet_kill(&host->finish_tasklet); // <--

pcr_mutex (un)locking:
 - gets locked in sdmmc_request
 - gets unlocked in sd_finish_request (finish_tasklet).
 - gets locked/unlocked in sdmmc_set_ios
 - gets locked/unlocked in sdmmc_get_ro
 - gets locked/unlocked in sdmmc_get_cd
 - gets locked/unlocked in sdmmc_switch_voltage
 - gets locked/unlocked in sdmmc_execute_tuning

finish_tasklet (sd_finish_request()) gets scheduled in:
 - sd_request_timeout (under host->lock; called on timer expiration)
 - error path of sd_send_cmd
 - get_rsp (cmd_tasklet; under host->lock)
 - error path of sd_start_multi_rw (after mod timer)
 - sd_finish_multi_rw (under host->lock)
 - sdmmc_request (under host->lock in error path; without host->lock
   elsewhere)
 - rtsx_pci_sdmmc_drv_remove (under host->lock)

sd_request_timeout (timer) related:
 - deleted in sd_finish_request under host->lock (also assumes pcr_mutex)
 - sd_send_cmd (timer set with 100ms timeout, not called in error path)
 - sd_start_multi_rw (timeout set to 10 HZ, called before error path is
   checked in which finish_tasklet gets scheduled)
Note: sd_request_timeout claims+releases host->lock.

If I understand it correctly, host->lock is responsible for protecting the 
realtek_pci_sdmmc structure. Why is tasklet_schedule() on the same lock?

Shouldn't the above five tasklet_schedule calls be moved outside the lock? 
Will it be problematic if the same tasklet gets executed multiple times (if 
that is possible?).

Does it really need that much locking? dw_mmc.c also implements pre_req, but 
uses tasklets without needing to lock anything.

Kind regards,
Peter

 [1]: http://www.makelinux.net/ldd3/chp-7-sect-5

On Friday 18 April 2014 16:00:53 Peter Wu wrote:
> On Wednesday 16 April 2014 09:38:44 micky_ching@realsil.com.cn wrote:
> > From: Micky Ching <micky_ching@realsil.com.cn>
> > 
> > To avoid dead lock, we need make sure host->lock is always acquire
> > before pcr->lock. But in irq handler, we acquired pcr->lock in rtsx mfd
> > driver, and sd_isr_done_transfer() is called during pcr->lock already
> > acquired. Since in sd_isr_done_transfer() the only work we do is schdule
> > tasklet, the cmd_tasklet and data_tasklet never conflict, so it is safe
> > to remove spin_lock() here.
> > 
> > Signed-off-by: Micky Ching <micky_ching@realsil.com.cn>
> > ---
> > 
> >  drivers/mmc/host/rtsx_pci_sdmmc.c |    4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> This patch came from
> https://lkml.kernel.org/r/534DE1D7.3000308@realsil.com.cn ("Re:
> rtsx_pci_sdmmc lockdep splat").
> 
> With v3.15-rc1-49-g10ec34f, I have a hung machine when inserting a SD card.
> lockdep was not enabled for the kernel, I have not bisected yet.
> This patch on top of that kernel version does not help (tested by
> rmmod rtsx_pci_sdmmc and insmod the patched one).
> 
> Console (as typed over from a picture, sorry for any typos):
> WARNING: CPU: 1 PID: 0 at kernel/locking/mutex.c:698
> DEBUG_LOCKS_WARN_ON(in_interrupt())
> Modules linked in: ...
> CPU: 1 PID: 0 Comm: swapper/1 Not tainted 3.15-rc1-custom-000049-g10ec34f #5
> Hardware name: Shuttle Inc. XS36V/XS36V, BIOS 1.11 12/18/2012
> Call trace:
> <IRQ> dump_stack
> warn_slowpath_common
> warn_slowpath_fmt
> __mutex_unlock_slowpath
> mutex_unlock
> sd_finish_request [rtsx_pci_sdmmc]
> tasklet_action
> __do_softirq
> irq_exit
> smp_apic_timer_interrupt
> apic_timer_interrupt
> <EOI> ? cpuidle_enter_state
> cpuidle_enter
> cpu_startup_entry
> start_secondary
> ---[end trace ...]---
> (60 seconds later:)
> INFO: rcu_preempt detected stalls on CPUs/tasks: {} (detected by 1, t=18004
> jiffies, g=3264, c=3263, q=2) INFO: Stall ended before state dump start
> 
> I also managed to get this trace about 106 seconds later when switching TTY:
> INFO: task kworker/... blocked for more than 120 seconds
> Workqueue: kmmcd mm_rescan [mmc_core]
> Call trace:
> ? update_rq_clock.part80
> ? internal_add_timer
> schedule
> schedule_preempt
> __mutex_lock_slowpath
> mutex_lock
> sdmmc_request [rtsx_pci_sdmmc]
> mmc_start_request [mmc_core]
> __mmc_start_req [mmc_core]
> mmc_wait_for_cmd [mmc_core]
> ? mmc_release_host [mmc_core]
> mmc_io_rw_direct_host [mmc_core]
> 
> I'll try to get a lockdep kernel and text logs later, but perhaps you
> already know the issue?
> 
> Peter
> 
> > diff --git a/drivers/mmc/host/rtsx_pci_sdmmc.c
> > b/drivers/mmc/host/rtsx_pci_sdmmc.c index 453e1d4..40695e0 100644
> > --- a/drivers/mmc/host/rtsx_pci_sdmmc.c
> > +++ b/drivers/mmc/host/rtsx_pci_sdmmc.c
> > @@ -108,12 +108,10 @@ static void sd_isr_done_transfer(struct
> > platform_device *pdev) {
> > 
> >  	struct realtek_pci_sdmmc *host = platform_get_drvdata(pdev);
> > 
> > -	spin_lock(&host->lock);
> > 
> >  	if (host->cmd)
> >  	
> >  		tasklet_schedule(&host->cmd_tasklet);
> > 
> > -	if (host->data)
> > +	else if (host->data)
> > 
> >  		tasklet_schedule(&host->data_tasklet);
> > 
> > -	spin_unlock(&host->lock);
> > 
> >  }
> >  
> >  static void sd_request_timeout(unsigned long host_addr)

