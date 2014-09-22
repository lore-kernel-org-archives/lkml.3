Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbaIVWlv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 18:41:51 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49429 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754899AbaIVWlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 18:41:50 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH RESEND] PM / sleep: Fix racing timers
Date: Tue, 23 Sep 2014 01:01:35 +0200
Message-ID: <1860362.OyoLA3GxVJ@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411405623-7869-1-git-send-email-soren.brinkmann@xilinx.com>
References: <1411405623-7869-1-git-send-email-soren.brinkmann@xilinx.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 22, 2014 10:07:03 AM Soren Brinkmann wrote:
> On platforms that do not power off during suspend, successfully entering
> suspend races with timers.
> 
> The race happening in a couple of location is:
> 
>   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
>      ...
>   2. syscore_suspend()
>       -> timekeeping_suspend()
>        -> clockevents_notify(SUSPEND)
>         -> tick_suspend()   	(timers are turned off here)
>      ...
>   3. wfi            		(wait for wake-IRQ here)
> 
> Between steps 1 and 2 the timers can still generate interrupts that are
> not handled and stay pending until step 3. That pending IRQ causes an
> immediate - spurious - wake.
> 
> The solution is to move the clockevents suspend/resume notification
> out of the syscore_suspend step and explictly call them at the appropriate
> time in the suspend/hibernation paths. I.e. timers are suspend _before_
> IRQs get disabled. And accordingly in the resume path.
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> ---
> Hi,
> 
> there was not a lot of discussion on the last submission. Just one comment from
> Rafael (https://lkml.org/lkml/2014/8/26/780), which - as I outlined in my
> response, does not apply, IMHO, since the platform does not re-enable
> interrupts.

Well, you just don't agree with it.

The problem with your approach is that timer interrupts aren't actually as
special as you think and any other IRQF_NO_SUSPEND interrupts would have caused
similar issues to appear under specific conditions.

The solution I would suggest and that actually covers all IRQF_NO_SUSPEND
interrupts would be to use a wait_event() loop like the one in freeze_enter()
(on top of the current linux-next or the pm-genirq branch of linux-pm.git),
but wait for pm_abort_suspend to become true, to implement system suspend.

Rafael

