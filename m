Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaKFAMy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:12:54 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:52661 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751184AbaKFAMw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:12:52 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: =?ISO-8859-1?Q?S=F6ren?= Brinkmann <soren.brinkmann@xilinx.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH RESEND] PM / sleep: Fix racing timers
Date: Thu, 06 Nov 2014 01:33:36 +0100
Message-ID: <1803639.rQE0urO8Tr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <fadb1f7b-82bf-4dbd-bfd4-ca24daca0a8f@BN1AFFO11FD060.protection.gbl>
References: <1411405623-7869-1-git-send-email-soren.brinkmann@xilinx.com> <1860362.OyoLA3GxVJ@vostro.rjw.lan> <fadb1f7b-82bf-4dbd-bfd4-ca24daca0a8f@BN1AFFO11FD060.protection.gbl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 02, 2014 09:01:15 AM Sören Brinkmann wrote:
> Hi Rafael,

Hi,

Sorry for the huge delay.

> On Tue, 2014-09-23 at 01:01AM +0200, Rafael J. Wysocki wrote:
> > On Monday, September 22, 2014 10:07:03 AM Soren Brinkmann wrote:
> > > On platforms that do not power off during suspend, successfully entering
> > > suspend races with timers.
> > > 
> > > The race happening in a couple of location is:
> > > 
> > >   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
> > >      ...
> > >   2. syscore_suspend()
> > >       -> timekeeping_suspend()
> > >        -> clockevents_notify(SUSPEND)
> > >         -> tick_suspend()   	(timers are turned off here)
> > >      ...
> > >   3. wfi            		(wait for wake-IRQ here)
> > > 
> > > Between steps 1 and 2 the timers can still generate interrupts that are
> > > not handled and stay pending until step 3. That pending IRQ causes an
> > > immediate - spurious - wake.
> > > 
> > > The solution is to move the clockevents suspend/resume notification
> > > out of the syscore_suspend step and explictly call them at the appropriate
> > > time in the suspend/hibernation paths. I.e. timers are suspend _before_
> > > IRQs get disabled. And accordingly in the resume path.
> > > 
> > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > ---
> > > Hi,
> > > 
> > > there was not a lot of discussion on the last submission. Just one comment from
> > > Rafael (https://lkml.org/lkml/2014/8/26/780), which - as I outlined in my
> > > response, does not apply, IMHO, since the platform does not re-enable
> > > interrupts.
> > 
> > Well, you just don't agree with it.
> > 
> > The problem with your approach is that timer interrupts aren't actually as
> > special as you think and any other IRQF_NO_SUSPEND interrupts would have caused
> > similar issues to appear under specific conditions.
> > 
> > The solution I would suggest and that actually covers all IRQF_NO_SUSPEND
> > interrupts would be to use a wait_event() loop like the one in freeze_enter()
> > (on top of the current linux-next or the pm-genirq branch of linux-pm.git),
> > but wait for pm_abort_suspend to become true, to implement system suspend.
> 
> sorry, it took me a while since I needed to get some dependencies ported
> to the pm-genirq base. Once I had that, it reproduced my original issue.
> So far so good. I then looked into finding a solution following your
> guidance. I'm not sure I really found what you had in mind, but below is
> what I came up with, which seems to do it.
> Please let me know how far off I am.
> 
> 	Thanks,
> 	Sören
> 
> -------8<------------------8<----------------8<----------------8<---------------
> diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
> index c2744b30d5d9..a4f9914571f1 100644
> --- a/drivers/base/power/wakeup.c
> +++ b/drivers/base/power/wakeup.c
> @@ -25,7 +25,7 @@
>  bool events_check_enabled __read_mostly;
>  
>  /* If set and the system is suspending, terminate the suspend. */
> -static bool pm_abort_suspend __read_mostly;
> +bool pm_abort_suspend __read_mostly;
>  
>  /*
>   * Combined counters of registered wakeup events and wakeup events in progress.
> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> index 6dadb25cb0d8..e6a6de8f76d0 100644
> --- a/kernel/power/suspend.c
> +++ b/kernel/power/suspend.c
> @@ -33,6 +33,7 @@
>  
>  static const char *pm_labels[] = { "mem", "standby", "freeze", };
>  const char *pm_states[PM_SUSPEND_MAX];
> +extern bool pm_abort_suspend;
>  
>  static const struct platform_suspend_ops *suspend_ops;
>  static const struct platform_freeze_ops *freeze_ops;
> @@ -294,25 +295,27 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
>  	if (error || suspend_test(TEST_CPUS))
>  		goto Enable_cpus;
>  
> -	arch_suspend_disable_irqs();
> -	BUG_ON(!irqs_disabled());
> -
> -	error = syscore_suspend();
> -	if (!error) {
> -		*wakeup = pm_wakeup_pending();
> -		if (!(suspend_test(TEST_CORE) || *wakeup)) {
> -			trace_suspend_resume(TPS("machine_suspend"),
> -				state, true);
> -			error = suspend_ops->enter(state);
> -			trace_suspend_resume(TPS("machine_suspend"),
> -				state, false);
> -			events_check_enabled = false;
> +	while (!pm_abort_suspend) {

That won't work in general, because pm_abort_suspend may not be set on some
platforms on wakeup.  It is only set if a wakeup interrupt triggers which
may not be the case on ACPI systems if the BIOS has woken up the system.

But that could be addressed by making those platforms simply set pm_wakeup_pending
in their BIOS exit path.

> +		arch_suspend_disable_irqs();
> +		BUG_ON(!irqs_disabled());
> +
> +		error = syscore_suspend();

Also it shouldn't be necessary to do syscore_suspend()/syscore_resume() in
every iteration of the loop.

> +		if (!error) {
> +			*wakeup = pm_wakeup_pending();

Plus pm_wakeup_pending() returns true if pm_abort_suspend is set

> +			if (!(suspend_test(TEST_CORE) || *wakeup)) {
> +				trace_suspend_resume(TPS("machine_suspend"),
> +					state, true);

Did you try to add the loop here instead of above?  Like:

			for (;;) {
				*wakeup = pm_wakeup_pending();
				if (*wakeup)
					break;

> +				error = suspend_ops->enter(state);

			}

> +				trace_suspend_resume(TPS("machine_suspend"),
> +					state, false);
> +				events_check_enabled = false;
> +			}
> +			syscore_resume();
>  		}
> -		syscore_resume();
> -	}
>  
> -	arch_suspend_enable_irqs();
> -	BUG_ON(irqs_disabled());
> +		arch_suspend_enable_irqs();
> +		BUG_ON(irqs_disabled());
> +	}
>  
>   Enable_cpus:
>  	enable_nonboot_cpus();
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pm" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
