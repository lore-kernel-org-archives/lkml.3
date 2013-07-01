Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710Ab3GAKFK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 06:05:10 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:38104 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753659Ab3GAKFE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 06:05:04 -0400
Date: Mon, 1 Jul 2013 11:04:55 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Stehle Vincent-B46079 <B46079@freescale.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: next-20130627 breaks i.MX6 sabre sd UART console
Message-ID: <20130701100455.GA31358@e106331-lin.cambridge.arm.com>
References: <F7C43F8B2814514CA05F3436BC68046EF1EB72@039-SN2MPN1-013.039d.mgd.msft.net>
 <alpine.DEB.2.02.1306281403530.4013@ionos.tec.linutronix.de>
 <51CDB26A.9060500@codeaurora.org>
 <F7C43F8B2814514CA05F3436BC68046EF2297D@039-SN2MPN1-013.039d.mgd.msft.net>
 <51CDC2B3.1030907@codeaurora.org>
 <20130629020738.GG11625@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130629020738.GG11625@codeaurora.org>
Thread-Topic: next-20130627 breaks i.MX6 sabre sd UART console
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 03:07:38AM +0100, Stephen Boyd wrote:
> On 06/28, Stephen Boyd wrote:
> > On 06/28/13 09:58, Stehle Vincent-B46079 wrote:
> > > From: linux-next-owner@vger.kernel.org [mailto:linux-next-owner@vger.kernel.org] On Behalf Of Stephen Boyd
> > > (..)
> > >> Do you have debug_ll support to get some serial logs?
> > > Hi,
> > >
> > > Thanks for your concern on the matter. You are right, there is debug_ll support for i.MX6. If I activate it for next-20130628 imx_v6_v7_defconfig, that only "buys" me one additional line, though:
> > >
> > >   Uncompressing Linux... done, booting the kernel.
> > 
> > Oh and also add earlyprintk to the command line and enable the
> > earlyprintk config. It should buy you some more lines.
> > 
> > >
> > >> Also could you try booting with maxcpus=1 on the kernel commandline?
> > > Good idea; it goes much further with this one (until it crashes in wm8962_probe(), which is as far as I go when I revert 064706514ec3fea740c2656e03c4f01f6a551ac4).
> > 
> > Interesting. Thanks for the test.
> > 
> > >
> > >> And it would be useful to have the output of /proc/timer_list if you have it from a working device.
> > > Sure; I pasted it below.
> > 
> > Is this an SMP capable device? What devicetree blob are you using?
> > 
> > >
> > >> I believe you have a per-cpu TWD timer and a global imx-gpt?
> > > I think you are right from what I see in /proc/interrupts.
> > 
> > Well oddly I don't see any twd in the timer list but that may be because
> > you're not running more than one CPU? It would be good to get the output
> > when you run SMP if it has that support.
> > 
> 
> I tried to recreate this probelm an an smp vexpress qemu and I
> couldn't do it. This is with next-20130628. If you can get
> debug_ll and earlyprinkt working it would be useful if you can
> apply the attached patch and give back the logs. I'm confused how
> the dummy timers are causing problems.

Similarly I couldn't reproduce the issue on a physical A9x4 coretile
with next-20130627. In case there's some weird interaction with the
imx-gpt registration, I tried dropping the rating on the sp804 down to
200 to match, and also removed CLOCKEVT_FEAT_PERIODIC from its features,
but was still able to get to userspace.

If I've followed the code correctly, I see mxc_timer_init is called from
the imx6q_clocks_init, which is marked with CLK_OF_DECLARE. I had a
suspicion that there was an ordering issue that we were somehow
irritating, but given booting with one CPU worked, that doesn't seem to
be the case. On me A9x4. I can't move the sp804 to CLK_OF_INIT to check
as I cannot guarantee I'll have the requisite clocks.

I'm also left scratching my head on this one. A dmesg and timer list
from a working SMP boot would be useful.

Thanks,
Mark.

> 
> diff --git a/kernel/time/tick-broadcast.c b/kernel/time/tick-broadcast.c
> index 9d96a54..3795c9c 100644
> --- a/kernel/time/tick-broadcast.c
> +++ b/kernel/time/tick-broadcast.c
> @@ -92,6 +92,8 @@ void tick_install_broadcast_device(struct clock_event_device *dev)
>  	if (!try_module_get(dev->owner))
>  		return;
>  
> +	pr_info("%s is now the broadcast\n", dev->name);
> +
>  	clockevents_exchange_device(cur, dev);
>  	if (cur)
>  		cur->event_handler = clockevents_handle_noop;
> diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
> index edd45f6..24548aa 100644
> --- a/kernel/time/tick-common.c
> +++ b/kernel/time/tick-common.c
> @@ -275,6 +275,8 @@ void tick_check_new_device(struct clock_event_device *newdev)
>  	struct tick_device *td;
>  	int cpu;
>  
> +	pr_info("Checking %s\n", newdev->name);
> +
>  	cpu = smp_processor_id();
>  	if (!cpumask_test_cpu(cpu, newdev->cpumask))
>  		goto out_bc;
> @@ -286,10 +288,14 @@ void tick_check_new_device(struct clock_event_device *newdev)
>  	if (!tick_check_percpu(curdev, newdev, cpu))
>  		goto out_bc;
>  
> +	pr_info("%d: %s is per-cpu\n", cpu, newdev->name);
> +
>  	/* Preference decision */
>  	if (!tick_check_preferred(curdev, newdev))
>  		goto out_bc;
>  
> +	pr_info("%d: %s is preferred\n", cpu, newdev->name);
> +
>  	if (!try_module_get(newdev->owner))
>  		return;
>  
> @@ -312,6 +318,7 @@ out_bc:
>  	/*
>  	 * Can the new device be used as a broadcast device ?
>  	 */
> +	pr_info("%d: %s is trying broadcast\n", cpu, newdev->name);
>  	tick_install_broadcast_device(newdev);
>  }
>  
> 
> -- 
> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> hosted by The Linux Foundation
> 
