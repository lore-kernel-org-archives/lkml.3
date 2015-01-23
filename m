Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755875AbbAWRop (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 12:44:45 -0500
Received: from mail-bn1bon0074.outbound.protection.outlook.com ([157.56.111.74]:5184
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751726AbbAWRom (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 12:44:42 -0500
Date: Fri, 23 Jan 2015 09:44:37 -0800
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        John Stultz <john.stultz@linaro.org>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH RESEND] PM / sleep: Fix racing timers
References: <1411405623-7869-1-git-send-email-soren.brinkmann@xilinx.com>
 <1025ebd0a9984037bf15adf3ae4889d9@BN1BFFO11FD013.protection.gbl>
 <99d5bcca1d6541a49ff8a9f41f9b18af@BL2FFO11FD039.protection.gbl>
 <12360948.gSvRbI0dui@vostro.rjw.lan> <20150112154347.GA23297@red-moon>
 <2313f65696c04c48867a3e8ce65ceb0b@BL2FFO11FD015.protection.gbl>
 <20150112161453.GA25281@red-moon>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20150112161453.GA25281@red-moon>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-21278.001
X-TM-AS-User-Approved-Sender: Yes;Yes
Message-ID: <97acd41d4ec349de80a2c1f30ec18efa@BL2FFO11FD007.protection.gbl>
X-EOPAttributedMessage: 0
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; vger.kernel.org; dkim=none (message
 not signed) header.d=none;
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(377454003)(164054003)(24454002)(43544003)(377424004)(51704005)(87936001)(19580395003)(6806004)(54356999)(76176999)(50986999)(106466001)(23676002)(83506001)(104016003)(19580405001)(53416004)(86362001)(575784001)(47776003)(15975445007)(110136001)(85202003)(92566002)(93886004)(85182001)(50466002)(92726002)(62966003)(46102003)(74316001)(2950100001)(77156002)(107986001)(24736002);DIR:OUT;SFP:1101;SCL:1;SRVR:BL2FFO11HUB016;H:xsj-pvapsmtpgw01;FPR:;SPF:None;MLV:sfv;LANG:en;
X-Microsoft-Antispam: UriScan:;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB016;
X-Exchange-Antispam-Report-Test: UriScan:;
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:(601004);SRVR:BL2FFO11HUB016;
X-Forefront-PRVS: 0465429B7F
X-Exchange-Antispam-Report-CFA-Test: BCL:0;PCL:0;RULEID:;SRVR:BL2FFO11HUB016;
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2015 17:44:39.7517
 (UTC)
X-MS-Exchange-CrossTenant-Id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=657af505-d5df-48d0-8300-c31994686c5c;Ip=[149.199.60.83]
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL2FFO11HUB016
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry for the delay, but a lot of stuff came in between and I need to
rebase a couple of branches and re-test things.
Some comments inline below:

On Mon, 2015-01-12 at 04:14PM +0000, Lorenzo Pieralisi wrote:
> On Mon, Jan 12, 2015 at 03:55:05PM +0000, Sören Brinkmann wrote:
> > On Mon, 2015-01-12 at 03:43PM +0000, Lorenzo Pieralisi wrote:
> > > Hi Rafael, Soren,
> > >
> > > On Sun, Jan 11, 2015 at 11:20:36PM +0000, Rafael J. Wysocki wrote:
> > > > On Friday, January 09, 2015 01:50:59 PM Sören Brinkmann wrote:
> > > > > On Sat, 2014-11-08 at 03:56PM -0800, Sören Brinkmann wrote:
> > > > > > Hi Rafael,
> > > > > >
> > > > > > On Thu, 2014-11-06 at 01:33AM +0100, Rafael J. Wysocki wrote:
> > > > > > > On Thursday, October 02, 2014 09:01:15 AM Sören Brinkmann wrote:
> > > > > > > > Hi Rafael,
> > > > > > >
> > > > > > > Hi,
> > > > > > >
> > > > > > > Sorry for the huge delay.
> > > > > > >
> > > > > > > > On Tue, 2014-09-23 at 01:01AM +0200, Rafael J. Wysocki wrote:
> > > > > > > > > On Monday, September 22, 2014 10:07:03 AM Soren Brinkmann wrote:
> > > > > > > > > > On platforms that do not power off during suspend, successfully entering
> > > > > > > > > > suspend races with timers.
> > > > > > > > > >
> > > > > > > > > > The race happening in a couple of location is:
> > > > > > > > > >
> > > > > > > > > >   1. disable IRQs               (e.g. arch_suspend_disable_irqs())
> > > > > > > > > >      ...
> > > > > > > > > >   2. syscore_suspend()
> > > > > > > > > >       -> timekeeping_suspend()
> > > > > > > > > >        -> clockevents_notify(SUSPEND)
> > > > > > > > > >         -> tick_suspend()       (timers are turned off here)
> > > > > > > > > >      ...
> > > > > > > > > >   3. wfi                        (wait for wake-IRQ here)
> > > > > > > > > >
> > > > > > > > > > Between steps 1 and 2 the timers can still generate interrupts that are
> > > > > > > > > > not handled and stay pending until step 3. That pending IRQ causes an
> > > > > > > > > > immediate - spurious - wake.
> > > > > > > > > >
> > > > > > > > > > The solution is to move the clockevents suspend/resume notification
> > > > > > > > > > out of the syscore_suspend step and explictly call them at the appropriate
> > > > > > > > > > time in the suspend/hibernation paths. I.e. timers are suspend _before_
> > > > > > > > > > IRQs get disabled. And accordingly in the resume path.
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > > > > > > > > > ---
> > > > > > > > > > Hi,
> > > > > > > > > >
> > > > > > > > > > there was not a lot of discussion on the last submission. Just one comment from
> > > > > > > > > > Rafael (https://lkml.org/lkml/2014/8/26/780), which - as I outlined in my
> > > > > > > > > > response, does not apply, IMHO, since the platform does not re-enable
> > > > > > > > > > interrupts.
> > > > > > > > >
> > > > > > > > > Well, you just don't agree with it.
> > > > > > > > >
> > > > > > > > > The problem with your approach is that timer interrupts aren't actually as
> > > > > > > > > special as you think and any other IRQF_NO_SUSPEND interrupts would have caused
> > > > > > > > > similar issues to appear under specific conditions.
> > > > > > > > >
> > > > > > > > > The solution I would suggest and that actually covers all IRQF_NO_SUSPEND
> > > > > > > > > interrupts would be to use a wait_event() loop like the one in freeze_enter()
> > > > > > > > > (on top of the current linux-next or the pm-genirq branch of linux-pm.git),
> > > > > > > > > but wait for pm_abort_suspend to become true, to implement system suspend.
> > > > > > > >
> > > > > > > > sorry, it took me a while since I needed to get some dependencies ported
> > > > > > > > to the pm-genirq base. Once I had that, it reproduced my original issue.
> > > > > > > > So far so good. I then looked into finding a solution following your
> > > > > > > > guidance. I'm not sure I really found what you had in mind, but below is
> > > > > > > > what I came up with, which seems to do it.
> > > > > > > > Please let me know how far off I am.
> > > > > > > >
> > > > > > > >     Thanks,
> > > > > > > >     Sören
> > > > > > > >
> > > > > > > > -------8<------------------8<----------------8<----------------8<---------------
> > > > > > > > diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
> > > > > > > > index c2744b30d5d9..a4f9914571f1 100644
> > > > > > > > --- a/drivers/base/power/wakeup.c
> > > > > > > > +++ b/drivers/base/power/wakeup.c
> > > > > > > > @@ -25,7 +25,7 @@
> > > > > > > >  bool events_check_enabled __read_mostly;
> > > > > > > >
> > > > > > > >  /* If set and the system is suspending, terminate the suspend. */
> > > > > > > > -static bool pm_abort_suspend __read_mostly;
> > > > > > > > +bool pm_abort_suspend __read_mostly;
> > > > > > > >
> > > > > > > >  /*
> > > > > > > >   * Combined counters of registered wakeup events and wakeup events in progress.
> > > > > > > > diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
> > > > > > > > index 6dadb25cb0d8..e6a6de8f76d0 100644
> > > > > > > > --- a/kernel/power/suspend.c
> > > > > > > > +++ b/kernel/power/suspend.c
> > > > > > > > @@ -33,6 +33,7 @@
> > > > > > > >
> > > > > > > >  static const char *pm_labels[] = { "mem", "standby", "freeze", };
> > > > > > > >  const char *pm_states[PM_SUSPEND_MAX];
> > > > > > > > +extern bool pm_abort_suspend;
> > > > > > > >
> > > > > > > >  static const struct platform_suspend_ops *suspend_ops;
> > > > > > > >  static const struct platform_freeze_ops *freeze_ops;
> > > > > > > > @@ -294,25 +295,27 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
> > > > > > > >     if (error || suspend_test(TEST_CPUS))
> > > > > > > >             goto Enable_cpus;
> > > > > > > >
> > > > > > > > -   arch_suspend_disable_irqs();
> > > > > > > > -   BUG_ON(!irqs_disabled());
> > > > > > > > -
> > > > > > > > -   error = syscore_suspend();
> > > > > > > > -   if (!error) {
> > > > > > > > -           *wakeup = pm_wakeup_pending();
> > > > > > > > -           if (!(suspend_test(TEST_CORE) || *wakeup)) {
> > > > > > > > -                   trace_suspend_resume(TPS("machine_suspend"),
> > > > > > > > -                           state, true);
> > > > > > > > -                   error = suspend_ops->enter(state);
> > > > > > > > -                   trace_suspend_resume(TPS("machine_suspend"),
> > > > > > > > -                           state, false);
> > > > > > > > -                   events_check_enabled = false;
> > > > > > > > +   while (!pm_abort_suspend) {
> > > > > > >
> > > > > > > That won't work in general, because pm_abort_suspend may not be set on some
> > > > > > > platforms on wakeup.  It is only set if a wakeup interrupt triggers which
> > > > > > > may not be the case on ACPI systems if the BIOS has woken up the system.
> > > > > > >
> > > > > > > But that could be addressed by making those platforms simply set pm_wakeup_pending
> > > > > > > in their BIOS exit path.
> > > > > > >
> > > > > > > > +           arch_suspend_disable_irqs();
> > > > > > > > +           BUG_ON(!irqs_disabled());
> > > > > > > > +
> > > > > > > > +           error = syscore_suspend();
> > > > > > >
> > > > > > > Also it shouldn't be necessary to do syscore_suspend()/syscore_resume() in
> > > > > > > every iteration of the loop.
> > > > > > >
> > > > > > > > +           if (!error) {
> > > > > > > > +                   *wakeup = pm_wakeup_pending();
> > > > > > >
> > > > > > > Plus pm_wakeup_pending() returns true if pm_abort_suspend is set
> > > > > > >
> > > > > > > > +                   if (!(suspend_test(TEST_CORE) || *wakeup)) {
> > > > > > > > +                           trace_suspend_resume(TPS("machine_suspend"),
> > > > > > > > +                                   state, true);
> > > > > > >
> > > > > > > Did you try to add the loop here instead of above?  Like:
> > > > > > >
> > > > > > >                       for (;;) {
> > > > > > >                               *wakeup = pm_wakeup_pending();
> > > > > > >                               if (*wakeup)
> > > > > > >                                       break;
> > > > > >
> > > > > > I think, that doesn't work. I chose the start/end points of the loop
> > > > > > to include the IRQ enable/disable calls. AFAICT, pm_abort_suspend is
> > > > > > set in an ISR. Without enabling interrupts the abort condition of
> > > > > > this loop never becomes true.
> > > > >
> > > > > Any further ideas how to resolve this?
> > > >
> > > > Sorry about the delay, lost track of this.
> > > >
> > > > You're right, the IRQ disabling/enabling needs to happen in the loop.
> > > >
> > > > So the direction of the patch looks OK, but it needs to ensure that pm_wakeup_pending
> > > > is set properly by all platforms.  Also it should be sufficient to check
> > > > pm_wakeup_pending() to detect wakeup.
> > > >
> > > > Have you tested the patch?
> > >
> > > Before considering this patch a solution, can I ask you to rewind
> > > the discussion a bit since I have a question.
> > >
> > > I thought that "suspending" the tick through syscore meant shutting down
> > > the respective clock_event_device, and that's how it is implemented in the
> > > kernel.
> > >
> > > Now, do we expect a shutdown clock_event_device to still signal pending
> > > IRQs ? I do not think that should be the case, at least that's not what
> > > happens for eg arm arch timers - ie disabling them implicitly gates
> > > the signal connected to the IRQ line.
> > >
> > > So the question is more related to the zynq platform and how their clock
> > > event device (which is ?) is shutdown, and what's the correct behaviour we
> > > are expecting.
> > 
> > As outlined in the commit message, there is a race condition in the core
> > code. Looking at the timers is just fighting the symptoms.
> 
> I gathered there is a race condition between 1 and 2 in your code path.
> What I am asking you is why are we getting a pending IRQ at step 3 when the
> clock event device is supposed to be shutdown. My question is:
> 
> Should a clock event device in shutdown mode (ie disabled) still signal
> IRQs to the interrupt controller (and consequently to the core) ?
> 
> It is for me to understand if that's the behaviour we are expecting.

Yeah, I think that would be the other way to resolve this. But since I
see this with already two different clock event drivers, it seems much
harder to enforce. I think pretty much no driver expects it has to clear
any interrupts unless its ISR is triggered.

> 
> > > FWIW, the problem here is not related to the simple wfi state on zynq,
> > > even some other ARM platforms with power management capabilities would wake
> > > up from the state entered by executing wfi (ie possibly through reset) if
> > > there is a pending timer IRQ, the question is more "should the IRQ be
> > > allowed to be there" instead IMHO.
> > >
> > > I still think that Stephen's query related to what timer is causing
> > > the wake-up is worth investigating.
> > 
> > As I reported earlier, I see these spurious wakes with the cadence_ttc
> > as well as the ARM twd timers.
> 
> I thought that a shutdown clock event device explicitly disables IRQ
> assertion, that's why I am inquiring, I do not understand how this
> can happen - how can you have a pending timer IRQ at step 3 above.

It does I guess, but the shutdown of the IRQ happens after disabling
IRQs. During that window the IRQ can become pening without anybody
handling it. Shutting the timer down usually just ensures that no new
interrupts are signaled but it apparently doesn't check whether any are
still pending (which isn't necessary in almost all cases since the ISR
would take care of it).

	Sören
