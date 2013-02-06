Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758683Ab3BFUvv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 15:51:51 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:55880 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121Ab3BFUvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 15:51:47 -0500
Message-ID: <5112C25F.6000508@wwwdotorg.org>
Date: Wed, 06 Feb 2013 13:51:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tglx@linutronix.de, nico@linaro.org, Will.Deacon@arm.com,
        Marc.Zyngier@arm.com, john.stultz@linaro.org
Subject: Re: [PATCHv3 4/4] arm: Add generic timer broadcast support
References: <1358183124-28461-1-git-send-email-mark.rutland@arm.com> <1358183124-28461-5-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1358183124-28461-5-git-send-email-mark.rutland@arm.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2013 10:05 AM, Mark Rutland wrote:
> Implement timer_broadcast for the arm architecture, allowing for the use
> of clock_event_device_drivers decoupled from the timer tick broadcast
> mechanism.

Mark, this patch is now in next-20130206 and causes a crash during boot
on Tegra. The reason appears to be because of:

> diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c

> @@ -524,7 +524,6 @@ static void __cpuinit percpu_timer_setup(void)
>  	struct clock_event_device *evt = &per_cpu(percpu_clockevent, cpu);
>  
>  	evt->cpumask = cpumask_of(cpu);
> -	evt->broadcast = smp_timer_broadcast;

After that change, evt->broadcast is never assigned, and hence is NULL.
Yet elsewhere in kernel/time/tick-broadcast.c it's used unconditionally:

static void tick_do_broadcast(struct cpumask *mask)
...
	if (!cpumask_empty(mask)) {
...
		td = &per_cpu(tick_cpu_device, cpumask_first(mask));
		td->evtdev->broadcast(mask);

Now perhaps the Tegra timer driver simply isn't being set up correctly,
so the bug is there... But the only other place I can find where
->broadcast is assigned is in tick_device_uses_broadcast() which only
does it for "non-functional" timers, which doesn't apply to Tegra's timer.
