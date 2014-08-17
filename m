Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751512AbaHQSzl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 14:55:41 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:52427 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751368AbaHQSzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 14:55:39 -0400
Date: Sun, 17 Aug 2014 19:55:23 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Stephen Boyd <sboyd@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH v4] irqchip: gic: Allow gic_arch_extn hooks to call
	into scheduler
Message-ID: <20140817185522.GX30401@n2100.arm.linux.org.uk>
References: <1407938238-21413-1-git-send-email-sboyd@codeaurora.org> <20140817173236.GG12769@titan.lakedaemon.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140817173236.GG12769@titan.lakedaemon.net>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 17, 2014 at 01:32:36PM -0400, Jason Cooper wrote:
> Stephen,
> 
> On Wed, Aug 13, 2014 at 06:57:18AM -0700, Stephen Boyd wrote:
> > Commit 1a6b69b6548c (ARM: gic: add CPU migration support,
> > 2012-04-12) introduced an acquisition of the irq_controller_lock
> > in gic_raise_softirq() which can lead to a spinlock recursion if
> > the gic_arch_extn hooks call into the scheduler (via complete()
> > or wake_up(), etc.). This happens because gic_arch_extn hooks are
> > normally called with the irq_controller_lock held and calling
> > into the scheduler may cause us to call smp_send_reschedule()
> > which will grab the irq_controller_lock again. Here's an example
> > from a vendor kernel (note that the gic_arch_extn hook code here
> > isn't actually in mainline):
> > 
> > BUG: spinlock recursion on CPU#0, swapper/0/1
> >  lock: irq_controller_lock+0x0/0x18, .magic: dead4ead, .owner: sw
> > er_cpu: 0
> > CPU: 0 PID: 1 Comm: swapper/0 Not tainted 3.14.10-00430-g3d433c4e
> > 
> > Call trace:
> > [<ffffffc000087e1c>] dump_backtrace+0x0/0x140
> > [<ffffffc000087f6c>] show_stack+0x10/0x1c
> > [<ffffffc00064732c>] dump_stack+0x74/0xc4
> > [<ffffffc0006446c0>] spin_dump+0x78/0x88
> > [<ffffffc0006446f4>] spin_bug+0x24/0x34
> > [<ffffffc0000d47d0>] do_raw_spin_lock+0x58/0x148
> > [<ffffffc00064d398>] _raw_spin_lock_irqsave+0x24/0x38
> > [<ffffffc0002c9d7c>] gic_raise_softirq+0x2c/0xbc
> > [<ffffffc00008daa4>] smp_send_reschedule+0x34/0x40
> > [<ffffffc0000c1e94>] try_to_wake_up+0x224/0x288
> > [<ffffffc0000c1f4c>] default_wake_function+0xc/0x18
> > [<ffffffc0000ceef0>] __wake_up_common+0x50/0x8c
> > [<ffffffc0000cef3c>] __wake_up_locked+0x10/0x1c
> > [<ffffffc0000cf734>] complete+0x3c/0x5c
> > [<ffffffc0002f0e78>] msm_mpm_enable_irq_exclusive+0x1b8/0x1c8
> > [<ffffffc0002f0f58>] __msm_mpm_enable_irq+0x4c/0x7c
> > [<ffffffc0002f0f94>] msm_mpm_enable_irq+0xc/0x18
> > [<ffffffc0002c9bb0>] gic_unmask_irq+0x40/0x7c
> > [<ffffffc0000de5f4>] irq_enable+0x2c/0x48
> > [<ffffffc0000de65c>] irq_startup+0x4c/0x74
> > [<ffffffc0000dd2fc>] __setup_irq+0x264/0x3f0
> > [<ffffffc0000dd5e0>] request_threaded_irq+0xcc/0x11c
> > [<ffffffc0000df254>] devm_request_threaded_irq+0x68/0xb4
> > [<ffffffc000471520>] msm_iommu_ctx_probe+0x124/0x2d4
> > [<ffffffc000337374>] platform_drv_probe+0x20/0x54
> > [<ffffffc00033598c>] driver_probe_device+0x158/0x340
> > [<ffffffc000335c20>] __driver_attach+0x60/0x90
> > [<ffffffc000333c9c>] bus_for_each_dev+0x6c/0x8c
> > [<ffffffc000335304>] driver_attach+0x1c/0x28
> > [<ffffffc000334f14>] bus_add_driver+0x120/0x204
> > [<ffffffc0003362e4>] driver_register+0xbc/0x10c
> > [<ffffffc000337348>] __platform_driver_register+0x5c/0x68
> > [<ffffffc00094c478>] msm_iommu_driver_init+0x54/0x7c
> > [<ffffffc0000813ec>] do_one_initcall+0xa4/0x130
> > [<ffffffc00091d928>] kernel_init_freeable+0x138/0x1dc
> > [<ffffffc000642578>] kernel_init+0xc/0xd4
> > 
> > We really just want to synchronize the sending of an SGI with the
> > update of the gic_cpu_map[], so introduce a new SGI lock that we
> > can use to synchronize the two code paths. Three main events are
> > happening that we have to consider:
> > 
> > 	1. We're updating the gic_cpu_mask to point to an
> > 	incoming CPU
> > 
> > 	2. We're (potentially) sending an SGI to the outgoing CPU
> > 
> > 	3. We're redirecting any pending SGIs for the outgoing
> > 	CPU to the incoming CPU.
> > 
> > Events 1 and 3 are already ordered within the same CPU by means
> > of program order and use of I/O accessors. Events 1 and 2 don't
> > need to be ordered, but events 2 and 3 do because any SGIs for
> > the outgoing CPU need to be pending before we can redirect them.
> > Synchronize by acquiring a new lock around event 2 and before
> > event 3. Use smp_mb__after_unlock_lock() before event 3 to ensure
> > that event 1 is seen before event 3 on other CPUs that may be
> > executing event 2. We put this all behind the b.L switcher config
> > option so that if we're not using this feature we don't have to
> > acquire any locks at all in the IPI path.
> > 
> > Cc: Nicolas Pitre <nico@linaro.org>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> > ---
> >  drivers/irqchip/irq-gic.c | 23 +++++++++++++++++++++--
> >  1 file changed, 21 insertions(+), 2 deletions(-)
> 
> Applied to irqchip/urgent with Nico's Ack.

Interesting, so I'm discussing this patch, and it gets applied anyway...
yes, that's great.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
