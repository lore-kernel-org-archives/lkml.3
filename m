Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330AbaKHX4c (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 18:56:32 -0500
Received: from mail-bn1on0061.outbound.protection.outlook.com ([157.56.110.61]:50880
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751231AbaKHX4a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 18:56:30 -0500
Date: Sat, 8 Nov 2014 15:56:25 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH RESEND] PM / sleep: Fix racing timers
References: <1411405623-7869-1-git-send-email-soren.brinkmann@xilinx.com>
 <1860362.OyoLA3GxVJ@vostro.rjw.lan>
 <fadb1f7b-82bf-4dbd-bfd4-ca24daca0a8f@BN1AFFO11FD060.protection.gbl>
 <1803639.rQE0urO8Tr@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1803639.rQE0urO8Tr@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21086.003
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <1025ebd0a9984037bf15adf3ae4889d9@BN1BFFO11FD013.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(189002)(51704005)(164054003)(199003)(24454002)(377424004)(377454003)(47776003)(31966008)(77096003)(108616004)(86362001)(93886004)(95666004)(20776003)(64706001)(92566001)(50986999)(4396001)(575784001)(120916001)(46102003)(99396003)(62966003)(15975445006)(104016003)(77156002)(85182001)(87936001)(21056001)(33646002)(74316001)(50466002)(83506001)(110136001)(107046002)(106466001)(76176999)(54356999)(85202003)(19580405001)(44976005)(19580395003)(53416004)(23676002)(102836001)(6806004)(24736002)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1BFFO11HUB016;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB016;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB016;
X-Forefront-PRVS: 0389EDA07F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-Exchange-Antispam-Report-CFA: BCL:0;PCL:0;RULEID:;SRVR:BN1BFFO11HUB016;
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Thu, 2014-11-06 at 01:33AM +0100, Rafael J. Wysocki wrote:
> On Thursday, October 02, 2014 09:01:15 AM Sören Brinkmann wrote:
> > Hi Rafael,
> 
> Hi,
> 
> Sorry for the huge delay.
> 
> > On Tue, 2014-09-23 at 01:01AM +0200, Rafael J. Wysocki wrote:
> > > On Monday, September 22, 2014 10:07:03 AM Soren Brinkmann wrote:
> > > > On platforms that do not power off during suspend, successfully entering
> > > > suspend races with timers.
> > > > 
> > > > The race happening in a couple of location is:
> > > > 
> > > >   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
> > > >      ...
> > > >   2. syscore_suspend()
> > > >       -> timekeeping_suspend()
> > > >        -> clockevents_notify(SUSPEND)
> > > >         -> tick_suspend()   	(timers are turned off here)
> > > >      ...
> > > >   3. wfi            		(wait for wake-IRQ here)
> > > > 
> > > > Between steps 1 and 2 the timers can still generate interrupts that are
> > > > not handled and stay pending until step 3. That pending IRQ causes an
> > > > immediate - spurious - wake.
> > > > 
> > > > The solution is to move the clockevents suspend/resume notification
> > > > out of the syscore_suspend step and explictly call them at the appropriate
> > > > time in the suspend/hibernation paths. I.e. timers are suspend _before_
> > > > IRQs get disabled. And accordingly in the resume path.
> > > > 
> > > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > > ---
> > > > Hi,
> > > > 
> > > > there was not a lot of discussion on the last submission. Just one comment from
> > > > Rafael (https://lkml.org/lkml/2014/8/26/780), which - as I outlined in my
> > > > response, does not apply, IMHO, since the platform does not re-enable
> > > > interrupts.
> > > 
> > > Well, you just don't agree with it.
> > > 
> > > The problem with your approach is that timer interrupts aren't actually as
> > > special as you think and any other IRQF_NO_SUSPEND interrupts would have caused
> > > similar issues to appear under specific conditions.
> > > 
> > > The solution I would suggest and that actually covers all IRQF_NO_SUSPEND
> > > interrupts would be to use a wait_event() loop like the one in freeze_enter()
> > > (on top of the current linux-next or the pm-genirq branch of linux-pm.git),
> > > but wait for pm_abort_suspend to become true, to implement system suspend.
> > 
> > sorry, it took me a while since I needed to get some dependencies ported
> > to the pm-genirq base. Once I had that, it reproduced my original issue.
> > So far so good. I then looked into finding a solution following your
> > guidance. I'm not sure I really found what you had in mind, but below is
> > what I came up with, which seems to do it.
> > Please let me know how far off I am.
> > 
> > 	Thanks,
> > 	Sören
> > 
> > -------8<------------------8<----------------8<----------------8<---------------
> > diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
> > index c2744b30d5d9..a4f9914571f1 100644
> > --- a/drivers/base/power/wakeup.c
> > +++ b/drivers/base/power/wakeup.c
> > @@ -25,7 +25,7 @@
> >  bool events_check_enabled __read_mostly;
> >  
> >  /* If set and the system is suspending, terminate the suspend. */
> > -static bool pm_abort_suspend __read_mostly;
> > +bool pm_abort_suspend __read_mostly;
> >  
> >  /*
> >   * Combined counters of registered wakeup events and wakeup events in progress.
> > diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > index 6dadb25cb0d8..e6a6de8f76d0 100644
> > --- a/kernel/power/suspend.c
> > +++ b/kernel/power/suspend.c
> > @@ -33,6 +33,7 @@
> >  
> >  static const char *pm_labels[] = { "mem", "standby", "freeze", };
> >  const char *pm_states[PM_SUSPEND_MAX];
> > +extern bool pm_abort_suspend;
> >  
> >  static const struct platform_suspend_ops *suspend_ops;
> >  static const struct platform_freeze_ops *freeze_ops;
> > @@ -294,25 +295,27 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
> >  	if (error || suspend_test(TEST_CPUS))
> >  		goto Enable_cpus;
> >  
> > -	arch_suspend_disable_irqs();
> > -	BUG_ON(!irqs_disabled());
> > -
> > -	error = syscore_suspend();
> > -	if (!error) {
> > -		*wakeup = pm_wakeup_pending();
> > -		if (!(suspend_test(TEST_CORE) || *wakeup)) {
> > -			trace_suspend_resume(TPS("machine_suspend"),
> > -				state, true);
> > -			error = suspend_ops->enter(state);
> > -			trace_suspend_resume(TPS("machine_suspend"),
> > -				state, false);
> > -			events_check_enabled = false;
> > +	while (!pm_abort_suspend) {
> 
> That won't work in general, because pm_abort_suspend may not be set on some
> platforms on wakeup.  It is only set if a wakeup interrupt triggers which
> may not be the case on ACPI systems if the BIOS has woken up the system.
> 
> But that could be addressed by making those platforms simply set pm_wakeup_pending
> in their BIOS exit path.
> 
> > +		arch_suspend_disable_irqs();
> > +		BUG_ON(!irqs_disabled());
> > +
> > +		error = syscore_suspend();
> 
> Also it shouldn't be necessary to do syscore_suspend()/syscore_resume() in
> every iteration of the loop.
> 
> > +		if (!error) {
> > +			*wakeup = pm_wakeup_pending();
> 
> Plus pm_wakeup_pending() returns true if pm_abort_suspend is set
> 
> > +			if (!(suspend_test(TEST_CORE) || *wakeup)) {
> > +				trace_suspend_resume(TPS("machine_suspend"),
> > +					state, true);
> 
> Did you try to add the loop here instead of above?  Like:
> 
> 			for (;;) {
> 				*wakeup = pm_wakeup_pending();
> 				if (*wakeup)
> 					break;

I think, that doesn't work. I chose the start/end points of the loop
to include the IRQ enable/disable calls. AFAICT, pm_abort_suspend is
set in an ISR. Without enabling interrupts the abort condition of
this loop never becomes true.

	Thanks,
	Sören
