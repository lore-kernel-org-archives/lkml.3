Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaJBQBV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 12:01:21 -0400
Received: from mail-bl2on0063.outbound.protection.outlook.com ([65.55.169.63]:60448
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753106AbaJBQBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 12:01:20 -0400
Date: Thu, 2 Oct 2014 09:01:15 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
Subject: Re: [PATCH RESEND] PM / sleep: Fix racing timers
References: <1411405623-7869-1-git-send-email-soren.brinkmann@xilinx.com>
 <1860362.OyoLA3GxVJ@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1860362.OyoLA3GxVJ@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20990.005
X-TM-AS-User-Approved-Sender: Yes
Message-ID: <fadb1f7b-82bf-4dbd-bfd4-ca24daca0a8f@BN1AFFO11FD060.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009020)(6009001)(438002)(199003)(377424004)(377454003)(51704005)(24454002)(189002)(164054003)(23676002)(102836001)(86362001)(77096002)(106466001)(110136001)(85852003)(76176999)(54356999)(85202003)(575784001)(50986999)(92566001)(10300001)(4396001)(107046002)(99396003)(92726001)(31696002)(74316001)(85182001)(76482002)(19580395003)(70736001)(19580405001)(44976005)(46102003)(6806004)(87936001)(80022003)(95666004)(53416004)(15975445006)(31966008)(50466002)(104016003)(120916001)(1496007)(21056001)(20776003)(64706001)(83506001)(85306004)(33646002)(47776003)(107986001)(23106004);DIR:OUT;SFP:1101;SCL:1;SRVR:BN1AFFO11HUB006;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 03524FBD26
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

On Tue, 2014-09-23 at 01:01AM +0200, Rafael J. Wysocki wrote:
> On Monday, September 22, 2014 10:07:03 AM Soren Brinkmann wrote:
> > On platforms that do not power off during suspend, successfully entering
> > suspend races with timers.
> > 
> > The race happening in a couple of location is:
> > 
> >   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
> >      ...
> >   2. syscore_suspend()
> >       -> timekeeping_suspend()
> >        -> clockevents_notify(SUSPEND)
> >         -> tick_suspend()   	(timers are turned off here)
> >      ...
> >   3. wfi            		(wait for wake-IRQ here)
> > 
> > Between steps 1 and 2 the timers can still generate interrupts that are
> > not handled and stay pending until step 3. That pending IRQ causes an
> > immediate - spurious - wake.
> > 
> > The solution is to move the clockevents suspend/resume notification
> > out of the syscore_suspend step and explictly call them at the appropriate
> > time in the suspend/hibernation paths. I.e. timers are suspend _before_
> > IRQs get disabled. And accordingly in the resume path.
> > 
> > Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> > ---
> > Hi,
> > 
> > there was not a lot of discussion on the last submission. Just one comment from
> > Rafael (https://lkml.org/lkml/2014/8/26/780), which - as I outlined in my
> > response, does not apply, IMHO, since the platform does not re-enable
> > interrupts.
> 
> Well, you just don't agree with it.
> 
> The problem with your approach is that timer interrupts aren't actually as
> special as you think and any other IRQF_NO_SUSPEND interrupts would have caused
> similar issues to appear under specific conditions.
> 
> The solution I would suggest and that actually covers all IRQF_NO_SUSPEND
> interrupts would be to use a wait_event() loop like the one in freeze_enter()
> (on top of the current linux-next or the pm-genirq branch of linux-pm.git),
> but wait for pm_abort_suspend to become true, to implement system suspend.

sorry, it took me a while since I needed to get some dependencies ported
to the pm-genirq base. Once I had that, it reproduced my original issue.
So far so good. I then looked into finding a solution following your
guidance. I'm not sure I really found what you had in mind, but below is
what I came up with, which seems to do it.
Please let me know how far off I am.

	Thanks,
	Sören

-------8<------------------8<----------------8<----------------8<---------------
diff --git a/drivers/base/power/wakeup.c b/drivers/base/power/wakeup.c
index c2744b30d5d9..a4f9914571f1 100644
--- a/drivers/base/power/wakeup.c
+++ b/drivers/base/power/wakeup.c
@@ -25,7 +25,7 @@
 bool events_check_enabled __read_mostly;
 
 /* If set and the system is suspending, terminate the suspend. */
-static bool pm_abort_suspend __read_mostly;
+bool pm_abort_suspend __read_mostly;
 
 /*
  * Combined counters of registered wakeup events and wakeup events in progress.
diff --git a/kernel/power/suspend.c b/kernel/power/suspend.c
index 6dadb25cb0d8..e6a6de8f76d0 100644
--- a/kernel/power/suspend.c
+++ b/kernel/power/suspend.c
@@ -33,6 +33,7 @@
 
 static const char *pm_labels[] = { "mem", "standby", "freeze", };
 const char *pm_states[PM_SUSPEND_MAX];
+extern bool pm_abort_suspend;
 
 static const struct platform_suspend_ops *suspend_ops;
 static const struct platform_freeze_ops *freeze_ops;
@@ -294,25 +295,27 @@ static int suspend_enter(suspend_state_t state, bool *wakeup)
 	if (error || suspend_test(TEST_CPUS))
 		goto Enable_cpus;
 
-	arch_suspend_disable_irqs();
-	BUG_ON(!irqs_disabled());
-
-	error = syscore_suspend();
-	if (!error) {
-		*wakeup = pm_wakeup_pending();
-		if (!(suspend_test(TEST_CORE) || *wakeup)) {
-			trace_suspend_resume(TPS("machine_suspend"),
-				state, true);
-			error = suspend_ops->enter(state);
-			trace_suspend_resume(TPS("machine_suspend"),
-				state, false);
-			events_check_enabled = false;
+	while (!pm_abort_suspend) {
+		arch_suspend_disable_irqs();
+		BUG_ON(!irqs_disabled());
+
+		error = syscore_suspend();
+		if (!error) {
+			*wakeup = pm_wakeup_pending();
+			if (!(suspend_test(TEST_CORE) || *wakeup)) {
+				trace_suspend_resume(TPS("machine_suspend"),
+					state, true);
+				error = suspend_ops->enter(state);
+				trace_suspend_resume(TPS("machine_suspend"),
+					state, false);
+				events_check_enabled = false;
+			}
+			syscore_resume();
 		}
-		syscore_resume();
-	}
 
-	arch_suspend_enable_irqs();
-	BUG_ON(irqs_disabled());
+		arch_suspend_enable_irqs();
+		BUG_ON(irqs_disabled());
+	}
 
  Enable_cpus:
 	enable_nonboot_cpus();
