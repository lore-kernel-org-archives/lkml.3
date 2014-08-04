Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753280AbaHDXUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 19:20:31 -0400
Received: from mail-qa0-f44.google.com ([209.85.216.44]:39256 "EHLO
	mail-qa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbaHDXU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 19:20:28 -0400
Date: Mon, 4 Aug 2014 19:20:25 -0400 (EDT)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
cc: Thomas Gleixner <tglx@linutronix.de>, Jason Cooper <jason@lakedaemon.net>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] irqchip: gic: Allow gic_arch_extn hooks to call into
 scheduler
In-Reply-To: <1407191616-31829-1-git-send-email-sboyd@codeaurora.org>
Message-ID: <alpine.LFD.2.11.1408041858570.6061@knanqh.ubzr>
References: <1407191616-31829-1-git-send-email-sboyd@codeaurora.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Aug 2014, Stephen Boyd wrote:

> Commit 1a6b69b6548c (ARM: gic: add CPU migration support,
> 2012-04-12) introduced an acquisition of the irq_controller_lock
> in gic_raise_softirq() which can lead to a spinlock recursion if
> the gic_arch_extn hooks call into the scheduler (via complete()
> or wake_up(), etc.). This happens because gic_arch_extn hooks are
> normally called with the irq_controller_lock held and calling
> into the scheduler may cause us to call smp_send_reschedule()
> which will grab the irq_controller_lock again. Here's an example
> from a vendor kernel (note that the gic_arch_extn hook code here
> isn't actually in mainline):
> 
> BUG: spinlock recursion on CPU#0, swapper/0/1
>  lock: irq_controller_lock+0x0/0x18, .magic: dead4ead, .owner: sw
> er_cpu: 0
> CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.10-00430-g3d433c4e
> 
> Call trace:
> [<ffffffc000087e1c>] dump_backtrace+0x0/0x140
> [<ffffffc000087f6c>] show_stack+0x10/0x1c
> [<ffffffc00064732c>] dump_stack+0x74/0xc4
> [<ffffffc0006446c0>] spin_dump+0x78/0x88
> [<ffffffc0006446f4>] spin_bug+0x24/0x34
> [<ffffffc0000d47d0>] do_raw_spin_lock+0x58/0x148
> [<ffffffc00064d398>] _raw_spin_lock_irqsave+0x24/0x38
> [<ffffffc0002c9d7c>] gic_raise_softirq+0x2c/0xbc
> [<ffffffc00008daa4>] smp_send_reschedule+0x34/0x40
> [<ffffffc0000c1e94>] try_to_wake_up+0x224/0x288
> [<ffffffc0000c1f4c>] default_wake_function+0xc/0x18
> [<ffffffc0000ceef0>] __wake_up_common+0x50/0x8c
> [<ffffffc0000cef3c>] __wake_up_locked+0x10/0x1c
> [<ffffffc0000cf734>] complete+0x3c/0x5c
> [<ffffffc0002f0e78>] msm_mpm_enable_irq_exclusive+0x1b8/0x1c8
> [<ffffffc0002f0f58>] __msm_mpm_enable_irq+0x4c/0x7c
> [<ffffffc0002f0f94>] msm_mpm_enable_irq+0xc/0x18
> [<ffffffc0002c9bb0>] gic_unmask_irq+0x40/0x7c
> [<ffffffc0000de5f4>] irq_enable+0x2c/0x48
> [<ffffffc0000de65c>] irq_startup+0x4c/0x74
> [<ffffffc0000dd2fc>] __setup_irq+0x264/0x3f0
> [<ffffffc0000dd5e0>] request_threaded_irq+0xcc/0x11c
> [<ffffffc0000df254>] devm_request_threaded_irq+0x68/0xb4
> [<ffffffc000471520>] msm_iommu_ctx_probe+0x124/0x2d4
> [<ffffffc000337374>] platform_drv_probe+0x20/0x54
> [<ffffffc00033598c>] driver_probe_device+0x158/0x340
> [<ffffffc000335c20>] __driver_attach+0x60/0x90
> [<ffffffc000333c9c>] bus_for_each_dev+0x6c/0x8c
> [<ffffffc000335304>] driver_attach+0x1c/0x28
> [<ffffffc000334f14>] bus_add_driver+0x120/0x204
> [<ffffffc0003362e4>] driver_register+0xbc/0x10c
> [<ffffffc000337348>] __platform_driver_register+0x5c/0x68
> [<ffffffc00094c478>] msm_iommu_driver_init+0x54/0x7c
> [<ffffffc0000813ec>] do_one_initcall+0xa4/0x130
> [<ffffffc00091d928>] kernel_init_freeable+0x138/0x1dc
> [<ffffffc000642578>] kernel_init+0xc/0xd4
> 
> We really just want to synchronize the sending of an SGI with the
> update of the gic_cpu_map[], so introduce a new SGI lock that we
> can use to synchronize the two code paths.
> 
> Cc: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  drivers/irqchip/irq-gic.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/irqchip/irq-gic.c b/drivers/irqchip/irq-gic.c
> index 7c131cf7cc13..824c1e2ac403 100644
> --- a/drivers/irqchip/irq-gic.c
> +++ b/drivers/irqchip/irq-gic.c
> @@ -72,6 +72,8 @@ struct gic_chip_data {
>  };
>  
>  static DEFINE_RAW_SPINLOCK(irq_controller_lock);
> +/* Synchronize switching CPU interface and sending SGIs */
> +static DEFINE_RAW_SPINLOCK(gic_sgi_lock);

I'd suggest moving this below gic_cpu_map[] definition for the comment 
block right above it to also apply to this lock.

>  
>  /*
>   * The GIC mapping of CPU interfaces does not necessarily match
> @@ -658,7 +660,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  	int cpu;
>  	unsigned long flags, map = 0;
>  
> -	raw_spin_lock_irqsave(&irq_controller_lock, flags);
> +	raw_spin_lock_irqsave(&gic_sgi_lock, flags);
>  
>  	/* Convert our logical CPU mask into a physical one. */
>  	for_each_cpu(cpu, mask)
> @@ -673,7 +675,7 @@ static void gic_raise_softirq(const struct cpumask *mask, unsigned int irq)
>  	/* this always happens on GIC0 */
>  	writel_relaxed(map << 16 | irq, gic_data_dist_base(&gic_data[0]) + GIC_DIST_SOFTINT);
>  
> -	raw_spin_unlock_irqrestore(&irq_controller_lock, flags);
> +	raw_spin_unlock_irqrestore(&gic_sgi_lock, flags);
>  }
>  #endif
>  
> @@ -742,6 +744,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
>  	cur_target_mask = 0x01010101 << cur_cpu_id;
>  	ror_val = (cur_cpu_id - new_cpu_id) & 31;
>  
> +	raw_spin_lock(&gic_sgi_lock);
>  	raw_spin_lock(&irq_controller_lock);

According to your call trace, you would now take irq_controller_lock and 
then gic_sgi_lock.  Here you're doing it in the opposite order with an 
AB-BA deadlock potential.  I'd suggest reversing them here.


>  
>  	/* Update the target interface for this logical CPU */
> @@ -763,6 +766,7 @@ void gic_migrate_target(unsigned int new_cpu_id)
>  	}
>  
>  	raw_spin_unlock(&irq_controller_lock);
> +	raw_spin_unlock(&gic_sgi_lock);
>  
>  	/*
>  	 * Now let's migrate and clear any potential SGIs that might be
> -- 
> The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
> hosted by The Linux Foundation
> 
> 
