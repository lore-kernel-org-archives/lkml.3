Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaJAWKJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 18:10:09 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:58268 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751644AbaJAWKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 18:10:08 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "dbasehore ." <dbasehore@chromium.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        xen-devel@lists.xenproject.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Linux-pm mailing list <linux-pm@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Eric Biederman <ebiederm@xmission.com>
Subject: Re: [Xen-devel] [PATCH v1 1/2] genirq: Fix error path for resuming irqs
Date: Thu, 02 Oct 2014 00:30:05 +0200
Message-ID: <6351010.TOHuEbTbVD@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2820251.cyKiTY1p5v@vostro.rjw.lan>
References: <1403913865-31614-1-git-send-email-dbasehore@chromium.org> <CAGAzgsqEwVFHh2+Xtmraxb6Xwt_Rz2iTsOz+R+P-wmc4Vq9-mg@mail.gmail.com> <2820251.cyKiTY1p5v@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 02, 2014 12:25:08 AM Rafael J. Wysocki wrote:
> On Wednesday, October 01, 2014 01:48:39 PM dbasehore . wrote:
> > Adding maintainers for affected systems to this CL for review.
> > 
> > On Mon, Jul 7, 2014 at 8:33 AM, Konrad Rzeszutek Wilk
> > <konrad.wilk@oracle.com> wrote:
> > > On Fri, Jun 27, 2014 at 05:04:24PM -0700, Derek Basehore wrote:
> > >> In the case of a late abort to suspend/hibernate, irqs marked with
> > >> IRQF_EARLY_RESUME will not be enabled. This is due to syscore_resume not getting
> > >> called on these paths.
> > >>
> > >> This can happen with a pm test for platform, a late wakeup irq, and other
> > >> instances. This change removes the function from syscore and calls it explicitly
> > >> in suspend, hibernate, etc.
> > >>
> > >> This regression was introduced in 9bab0b7f "genirq: Add IRQF_RESUME_EARLY"
> > >>
> > >> Signed-off-by: Derek Basehore <dbasehore@chromium.org>
> > >
> > > Tested-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > >
> > > on the Xen side.
> > >> ---
> > >>  drivers/base/power/main.c |  5 ++++-
> > >>  drivers/xen/manage.c      |  5 ++++-
> > >>  include/linux/interrupt.h |  1 +
> > >>  include/linux/pm.h        |  2 +-
> > >>  kernel/irq/pm.c           | 17 +++--------------
> > >>  kernel/kexec.c            |  2 +-
> > >>  kernel/power/hibernate.c  |  6 +++---
> > >>  kernel/power/suspend.c    |  2 +-
> > >>  8 files changed, 18 insertions(+), 22 deletions(-)
> > >>
> > >> diff --git a/drivers/base/power/main.c b/drivers/base/power/main.c
> > >> index bf41296..a087473 100644
> > >> --- a/drivers/base/power/main.c
> > >> +++ b/drivers/base/power/main.c
> > >> @@ -712,8 +712,10 @@ static void dpm_resume_early(pm_message_t state)
> > >>   * dpm_resume_start - Execute "noirq" and "early" device callbacks.
> > >>   * @state: PM transition of the system being carried out.
> > >>   */
> > >> -void dpm_resume_start(pm_message_t state)
> > >> +void dpm_resume_start(pm_message_t state, bool enable_early_irqs)
> > >>  {
> > >> +     if (enable_early_irqs)
> > >> +             early_resume_device_irqs();
> 
> This conflicts with some changes I've already queued up for merging.
> 
> Why don't you do that in dpm_resume_noirq() directly?  Also why do we need
> the extra argument here?  The only case when we pass 'false' apprears to be
> the Xen one, so perhaps we can use a special PM_EVENT_XEN flag or something
> similar to indicate that?  Honestly, I don't want to litter the regular suspend
> code with Xen-specific stuff like this.

BTW, is dpm_resume_noirq() early enough?  What about the time we bring up
the non-boot CPUs?  Don't we need to call the early_resume_device_irqs()
thing before that?

> > >>       dpm_resume_noirq(state);
> > >>       dpm_resume_early(state);
> > >>  }
> > >> @@ -1132,6 +1134,7 @@ static int dpm_suspend_noirq(pm_message_t state)
> > >>       if (error) {
> > >>               suspend_stats.failed_suspend_noirq++;
> > >>               dpm_save_failed_step(SUSPEND_SUSPEND_NOIRQ);
> > >> +             early_resume_device_irqs();
> > >>               dpm_resume_noirq(resume_event(state));
> > >>       } else {
> > >>               dpm_show_time(starttime, state, "noirq");
> > >> diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
> > >> index c3667b2..d387cdf 100644
> > >> --- a/drivers/xen/manage.c
> > >> +++ b/drivers/xen/manage.c
> > >> @@ -68,6 +68,7 @@ static int xen_suspend(void *data)
> > >>       err = syscore_suspend();
> > >>       if (err) {
> > >>               pr_err("%s: system core suspend failed: %d\n", __func__, err);
> > >> +             early_resume_device_irqs();
> > >>               return err;
> > >>       }
> > >>
> > >> @@ -92,6 +93,8 @@ static int xen_suspend(void *data)
> > >>               xen_timer_resume();
> > >>       }
> > >>
> > >> +     early_resume_device_irqs();
> > >> +
> > >>       syscore_resume();
> > >>
> > >>       return 0;
> > >> @@ -137,7 +140,7 @@ static void do_suspend(void)
> > >>
> > >>       raw_notifier_call_chain(&xen_resume_notifier, 0, NULL);
> > >>
> > >> -     dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
> > >> +     dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE, false);
> > >>
> > >>       if (err) {
> > >>               pr_err("failed to start xen_suspend: %d\n", err);
> > >> diff --git a/include/linux/interrupt.h b/include/linux/interrupt.h
> > >> index 698ad05..7f390e3 100644
> > >> --- a/include/linux/interrupt.h
> > >> +++ b/include/linux/interrupt.h
> > >> @@ -193,6 +193,7 @@ extern void irq_wake_thread(unsigned int irq, void *dev_id);
> > >>  /* The following three functions are for the core kernel use only. */
> > >>  extern void suspend_device_irqs(void);
> > >>  extern void resume_device_irqs(void);
> > >> +extern void early_resume_device_irqs(void);
> > >>  #ifdef CONFIG_PM_SLEEP
> > >>  extern int check_wakeup_irqs(void);
> > >>  #else
> > >> diff --git a/include/linux/pm.h b/include/linux/pm.h
> > >> index 72c0fe0..ae5b26a 100644
> > >> --- a/include/linux/pm.h
> > >> +++ b/include/linux/pm.h
> > >> @@ -677,7 +677,7 @@ struct dev_pm_domain {
> > >>
> > >>  #ifdef CONFIG_PM_SLEEP
> > >>  extern void device_pm_lock(void);
> > >> -extern void dpm_resume_start(pm_message_t state);
> > >> +extern void dpm_resume_start(pm_message_t state, bool enable_early_irqs);
> > >>  extern void dpm_resume_end(pm_message_t state);
> > >>  extern void dpm_resume(pm_message_t state);
> > >>  extern void dpm_complete(pm_message_t state);
> > >> diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
> > >> index abcd6ca..b07dc9c 100644
> > >> --- a/kernel/irq/pm.c
> > >> +++ b/kernel/irq/pm.c
> > >> @@ -60,26 +60,15 @@ static void resume_irqs(bool want_early)
> > >>  }
> > >>
> > >>  /**
> > >> - * irq_pm_syscore_ops - enable interrupt lines early
> > >> + * early_resume_device_irqs - enable interrupt lines early
> > >>   *
> > >>   * Enable all interrupt lines with %IRQF_EARLY_RESUME set.
> > >>   */
> > >> -static void irq_pm_syscore_resume(void)
> > >> +void early_resume_device_irqs(void)
> > >>  {
> > >>       resume_irqs(true);
> > >>  }
> > >> -
> > >> -static struct syscore_ops irq_pm_syscore_ops = {
> > >> -     .resume         = irq_pm_syscore_resume,
> > >> -};
> > >> -
> > >> -static int __init irq_pm_init_ops(void)
> > >> -{
> > >> -     register_syscore_ops(&irq_pm_syscore_ops);
> > >> -     return 0;
> > >> -}
> > >> -
> > >> -device_initcall(irq_pm_init_ops);
> > >> +EXPORT_SYMBOL_GPL(early_resume_device_irqs);
> > >>
> > >>  /**
> > >>   * resume_device_irqs - enable interrupt lines disabled by suspend_device_irqs()
> > >> diff --git a/kernel/kexec.c b/kernel/kexec.c
> > >> index 369f41a..272853b 100644
> > >> --- a/kernel/kexec.c
> > >> +++ b/kernel/kexec.c
> > >> @@ -1700,7 +1700,7 @@ int kernel_kexec(void)
> > >>               local_irq_enable();
> > >>   Enable_cpus:
> > >>               enable_nonboot_cpus();
> > >> -             dpm_resume_start(PMSG_RESTORE);
> > >> +             dpm_resume_start(PMSG_RESTORE, true);
> > >>   Resume_devices:
> > >>               dpm_resume_end(PMSG_RESTORE);
> > >>   Resume_console:
> > >> diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> > >> index fcc2611..1d6dd56 100644
> > >> --- a/kernel/power/hibernate.c
> > >> +++ b/kernel/power/hibernate.c
> > >> @@ -325,7 +325,7 @@ static int create_image(int platform_mode)
> > >>       platform_finish(platform_mode);
> > >>
> > >>       dpm_resume_start(in_suspend ?
> > >> -             (error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
> > >> +             (error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE, true);
> > >>
> > >>       return error;
> > >>  }
> > >> @@ -482,7 +482,7 @@ static int resume_target_kernel(bool platform_mode)
> > >>   Cleanup:
> > >>       platform_restore_cleanup(platform_mode);
> > >>
> > >> -     dpm_resume_start(PMSG_RECOVER);
> > >> +     dpm_resume_start(PMSG_RECOVER, true);
> > >>
> > >>       return error;
> > >>  }
> > >> @@ -574,7 +574,7 @@ int hibernation_platform_enter(void)
> > >>   Platform_finish:
> > >>       hibernation_ops->finish();
> > >>
> > >> -     dpm_resume_start(PMSG_RESTORE);
> > >> +     dpm_resume_start(PMSG_RESTORE, true);
> > >>
> > >>   Resume_devices:
> > >>       entering_platform_hibernation = false;
> > >> diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > >> index 4dd8822..3597c72 100644
> > >> --- a/kernel/power/suspend.c
> > >> +++ b/kernel/power/suspend.c
> > >> @@ -281,7 +281,7 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
> > >>       if (need_suspend_ops(state) && suspend_ops->wake)
> > >>               suspend_ops->wake();
> > >>
> > >> -     dpm_resume_start(PMSG_RESUME);
> > >> +     dpm_resume_start(PMSG_RESUME, true);
> > >>
> > >>   Platform_finish:
> > >>       if (need_suspend_ops(state) && suspend_ops->finish)
> > >> --
> > >> 2.0.0.526.g5318336
> > >>
> > >>
> > >> _______________________________________________
> > >> Xen-devel mailing list
> > >> Xen-devel@lists.xen.org
> > >> http://lists.xen.org/xen-devel
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
