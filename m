Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473AbaJWOHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2014 10:07:02 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:42076 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756048AbaJWOG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2014 10:06:58 -0400
Date: Thu, 23 Oct 2014 15:06:44 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marcin Jabrzyk <m.jabrzyk@samsung.com>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Thomas Gleixner <tglx@linutronix.de>, kyungmin.park@samsung.com,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: =?iso-8859-1?Q?PROBLEM=3A=A0BUG__appea?=
 =?iso-8859-1?Q?ring_when_tryin?= =?iso-8859-1?Q?g?= to allocate interrupt on
 Exynos MCT after CPU hotplug
Message-ID: <20141023140644.GI27405@n2100.arm.linux.org.uk>
References: <544907D4.1020409@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <544907D4.1020409@samsung.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 23, 2014 at 03:51:16PM +0200, Marcin Jabrzyk wrote:
> [1.] One line summary of the problem: "BUG: sleeping function called from
> invalid context at mm/slub.c:1250" after CPU hotplug

I'm really not surprised.

> When SoC have MCT_INT_SPI interrupt it is being allocated after hotplugging
> of the CPU, secondary_start_kernel() is sending CPU boot notifications which
> are send when preemption and interrupts are disabled. Exynos_mct
> notification handler tries to set up and allocate IRQ for SPI type interrupt
> for started CPU and then BUG appears.
> There might be similar problem on qcom-timer I think just after looking on
> the code.

The CPU notifier is called via notify_cpu_starting(), which is called
with interrupts disabled, and a reason code of CPU_STARTING.  Interrupts
at this point /must/ remain disabled.

The Exynos code then goes on to call exynos4_local_timer_setup() which
tries to reverse the free_irq() in exynos4_local_timer_stop() by calling
request_irq().  Calling request_irq() with interrupts off has never been
permissible.

So, this code is wrong today, and it was also wrong when it was written.
It /couldn't/ have been tested.  It looks like this commit added this
buggy code:

commit ee98d27df6827b5ba4bd99cb7d5cb1239b6a1a31
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Fri Feb 15 16:40:51 2013 -0800

    ARM: EXYNOS4: Divorce mct from local timer API

    Separate the mct local timers from the local timer API. This will
    allow us to remove ARM local timer support in the near future and
    gets us closer to moving this driver to drivers/clocksource.

    Acked-by: Kukjin Kim <kgene.kim@samsung.com>
    Acked-by: Marc Zyngier <marc.zyngier@arm.com>
    Cc: Thomas Abraham <thomas.abraham@linaro.org>
    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>

A good question would be: why doesn't this happen at boot time when CPU1
is first brought up?  The conditions here are no different from hotplugging
CPU1 back in.  Do you see a similar warning on boot too?

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
