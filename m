Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbbAWRq5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:46:57 -0500
Received: from mail-bl2on0083.outbound.protection.outlook.com ([65.55.169.83]:47328
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752844AbbAWRqw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:46:52 -0500
Date: Fri, 23 Jan 2015 09:46:47 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH RESEND] PM / sleep: Fix racing timers
References: <1411405623-7869-1-git-send-email-soren.brinkmann@xilinx.com>
 <1025ebd0a9984037bf15adf3ae4889d9@BN1BFFO11FD013.protection.gbl>
 <99d5bcca1d6541a49ff8a9f41f9b18af@BL2FFO11FD039.protection.gbl>
 <12360948.gSvRbI0dui@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12360948.gSvRbI0dui@vostro.rjw.lan>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21278.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <5340dc237cfc4d48895a01087c3ffa4c@BL2FFO11FD015.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; vger.kernel.org; dkim=none (message
 not signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(24454002)(377424004)(164054003)(51704005)(377454003)(2950100001)(93886004)(50466002)(92726002)(77156002)(92566002)(47776003)(15975445007)(74316001)(110136001)(46102003)(62966003)(85202003)(76176999)(54356999)(50986999)(106466001)(23676002)(104016003)(85182001)(53416004)(86362001)(575784001)(6806004)(83506001)(19580405001)(19580395003)(87936001)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB019;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB019;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB019;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB019;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 17:46:49.4267
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 12:20AM +0100, Rafael J. Wysocki wrote:
> On Friday, January 09, 2015 01:50:59 PM Sören Brinkmann wrote:
> > On Sat, 2014-11-08 at 03:56PM -0800, Sören Brinkmann wrote:
> > > Hi Rafael,
> > > 
> > > On Thu, 2014-11-06 at 01:33AM +0100, Rafael J. Wysocki wrote:
> > > > On Thursday, October 02, 2014 09:01:15 AM Sören Brinkmann wrote:
> > > > > Hi Rafael,
> > > > 
> > > > Hi,
> > > > 
> > > > Sorry for the huge delay.
> > > > 
> > > > > On Tue, 2014-09-23 at 01:01AM +0200, Rafael J. Wysocki wrote:
> > > > > > On Monday, September 22, 2014 10:07:03 AM Soren Brinkmann wrote:
> > > > > > > On platforms that do not power off during suspend, successfully entering
> > > > > > > suspend races with timers.
> > > > > > > 
> > > > > > > The race happening in a couple of location is:
> > > > > > > 
> > > > > > >   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
> > > > > > >      ...
> > > > > > >   2. syscore_suspend()
> > > > > > >       -> timekeeping_suspend()
> > > > > > >        -> clockevents_notify(SUSPEND)
> > > > > > >         -> tick_suspend()   	(timers are turned off here)
> > > > > > >      ...
> > > > > > >   3. wfi            		(wait for wake-IRQ here)
> > > > > > > 
> > > > > > > Between steps 1 and 2 the timers can still generate interrupts that are
> > > > > > > not handled and stay pending until step 3. That pending IRQ causes an
> > > > > > > immediate - spurious - wake.
> > > > > > > 
> > > > > > > The solution is to move the clockevents suspend/resume notification
> > > > > > > out of the syscore_suspend step and explictly call them at the appropriate
> > > > > > > time in the suspend/hibernation paths. I.e. timers are suspend _before_
> > > > > > > IRQs get disabled. And accordingly in the resume path.
> > > > > > > 
> > > > > > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > > > > > ---
> > > > > > > Hi,
> > > > > > > 
> > > > > > > there was not a lot of discussion on the last submission. Just one comment from
> > > > > > > Rafael (https://lkml.org/lkml/2014/8/26/780), which - as I outlined in my
> > > > > > > response, does not apply, IMHO, since the platform does not re-enable
> > > > > > > interrupts.
> > > > > > 
> > > > > > Well, you just don't agree with it.
> > > > > > 
> > > > > > The problem with your approach is that timer interrupts aren't actually as
> > > > > > special as you think and any other IRQF_NO_SUSPEND interrupts would have caused
> > > > > > similar issues to appear under specific conditions.
> > > > > > 
> > > > > > The solution I would suggest and that actually covers all IRQF_NO_SUSPEND
> > > > > > interrupts would be to use a wait_event() loop like the one in freeze_enter()
> > > > > > (on top of the current linux-next or the pm-genirq branch of linux-pm.git),
> > > > > > but wait for pm_abort_suspend to become true, to implement system suspend.
> > > > > 
> > > > > sorry, it took me a while since I needed to get some dependencies ported
> > > > > to the pm-genirq base. Once I had that, it reproduced my original issue.
> > > > > So far so good. I then looked into finding a solution following your
> > > > > guidance. I'm not sure I really found what you had in mind, but below is
> > > > > what I came up with, which seems to do it.
> > > > > Please let me know how far off I am.
> > > > > 
> > > > > 	Thanks,
> > > > > 	Sören
> > > > > 
> > > > > -------8<------------------8<----------------8<----------------8<---------------
> > > > > diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
> > > > > index c2744b30d5d9..a4f9914571f1 100644
> > > > > --- a/drivers/base/power/wakeup.c
> > > > > +++ b/drivers/base/power/wakeup.c
> > > > > @@ -25,7 +25,7 @@
> > > > >  bool events_check_enabled __read_mostly;
> > > > >  
> > > > >  /* If set and the system is suspending, terminate the suspend. */
> > > > > -static bool pm_abort_suspend __read_mostly;
> > > > > +bool pm_abort_suspend __read_mostly;
> > > > >  
> > > > >  /*
> > > > >   * Combined counters of registered wakeup events and wakeup events in progress.
> > > > > diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > > > > index 6dadb25cb0d8..e6a6de8f76d0 100644
> > > > > --- a/kernel/power/suspend.c
> > > > > +++ b/kernel/power/suspend.c
> > > > > @@ -33,6 +33,7 @@
> > > > >  
> > > > >  static const char *pm_labels[] = { "mem", "standby", "freeze", };
> > > > >  const char *pm_states[PM_SUSPEND_MAX];
> > > > > +extern bool pm_abort_suspend;
> > > > >  
> > > > >  static const struct platform_suspend_ops *suspend_ops;
> > > > >  static const struct platform_freeze_ops *freeze_ops;
> > > > > @@ -294,25 +295,27 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
> > > > >  	if (error || suspend_test(TEST_CPUS))
> > > > >  		goto Enable_cpus;
> > > > >  
> > > > > -	arch_suspend_disable_irqs();
> > > > > -	BUG_ON(!irqs_disabled());
> > > > > -
> > > > > -	error = syscore_suspend();
> > > > > -	if (!error) {
> > > > > -		*wakeup = pm_wakeup_pending();
> > > > > -		if (!(suspend_test(TEST_CORE) || *wakeup)) {
> > > > > -			trace_suspend_resume(TPS("machine_suspend"),
> > > > > -				state, true);
> > > > > -			error = suspend_ops->enter(state);
> > > > > -			trace_suspend_resume(TPS("machine_suspend"),
> > > > > -				state, false);
> > > > > -			events_check_enabled = false;
> > > > > +	while (!pm_abort_suspend) {
> > > > 
> > > > That won't work in general, because pm_abort_suspend may not be set on some
> > > > platforms on wakeup.  It is only set if a wakeup interrupt triggers which
> > > > may not be the case on ACPI systems if the BIOS has woken up the system.
> > > > 
> > > > But that could be addressed by making those platforms simply set pm_wakeup_pending
> > > > in their BIOS exit path.
> > > > 
> > > > > +		arch_suspend_disable_irqs();
> > > > > +		BUG_ON(!irqs_disabled());
> > > > > +
> > > > > +		error = syscore_suspend();
> > > > 
> > > > Also it shouldn't be necessary to do syscore_suspend()/syscore_resume() in
> > > > every iteration of the loop.
> > > > 
> > > > > +		if (!error) {
> > > > > +			*wakeup = pm_wakeup_pending();
> > > > 
> > > > Plus pm_wakeup_pending() returns true if pm_abort_suspend is set
> > > > 
> > > > > +			if (!(suspend_test(TEST_CORE) || *wakeup)) {
> > > > > +				trace_suspend_resume(TPS("machine_suspend"),
> > > > > +					state, true);
> > > > 
> > > > Did you try to add the loop here instead of above?  Like:
> > > > 
> > > > 			for (;;) {
> > > > 				*wakeup = pm_wakeup_pending();
> > > > 				if (*wakeup)
> > > > 					break;
> > > 
> > > I think, that doesn't work. I chose the start/end points of the loop
> > > to include the IRQ enable/disable calls. AFAICT, pm_abort_suspend is
> > > set in an ISR. Without enabling interrupts the abort condition of
> > > this loop never becomes true.
> > 
> > Any further ideas how to resolve this?
> 
> Sorry about the delay, lost track of this.
> 
> You're right, the IRQ disabling/enabling needs to happen in the loop.
> 
> So the direction of the patch looks OK, but it needs to ensure that pm_wakeup_pending
> is set properly by all platforms.  Also it should be sufficient to check
> pm_wakeup_pending() to detect wakeup.
> 
> Have you tested the patch? 

I have to look into this, rebase my stuff and test again. May take a
while, but I'll stay on it.
Regarding testing: I don't have platforms to really test this on other
than my Zynq platforms where I see this issue on. It worked for me
there, but rebasing just broke something.

	Thanks,
	Sören
