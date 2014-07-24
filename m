Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933598AbaGXQAB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 12:00:01 -0400
Received: from mail-bn1blp0188.outbound.protection.outlook.com ([207.46.163.188]:36593
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932207AbaGXP77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 11:59:59 -0400
Date: Thu, 24 Jul 2014 08:59:55 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: John Stultz <john.stultz@linaro.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH RFC] suspend/hibernation: Fix racing timers
References: <1405964152-17865-1-git-send-email-soren.brinkmann@xilinx.com>
 <53D083C5.2000501@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D083C5.2000501@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <b125f213-6799-48bd-9e70-040287264948@BN1AFFO11FD033.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(377424004)(51704005)(24454002)(377454003)(54094003)(479174003)(189002)(164054003)(199002)(81342001)(107046002)(81542001)(77096002)(85306003)(102836001)(53416004)(83322001)(106466001)(104016003)(85202003)(4396001)(6806004)(74502001)(95666004)(21056001)(44976005)(110136001)(70736001)(83506001)(77982001)(31966008)(50466002)(76482001)(20776003)(47776003)(50986999)(79102001)(80022001)(92726001)(86362001)(64706001)(85852003)(54356999)(83072002)(76176999)(92566001)(31696002)(46102001)(74316001)(74662001)(33646002)(1496007)(99396002)(85182001)(87936001)(23676002)(107986001)(23106004);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB042;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 028256169F
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Wed, 2014-07-23 at 08:55PM -0700, John Stultz wrote:
> On 07/21/2014 10:35 AM, Soren Brinkmann wrote:
> > On platforms that do not power off during suspend, successfully entering
> > suspend races with timers.
> >
> > The race happening in a couple of location is:
> >
> >   1. disable IRQs 	(e.g. arch_suspend_disable_irqs())
> >      ...
> >   2. syscore_suspend()
> >         -> tick_suspend() 	(timers are turned off here)
> >      ...
> >   3. wfi		(wait for wake-IRQ here)
> >
> > Between steps 1 and 2 the timers can still generate interrupts that are
> > not handled and stay pending until step 3. That pending IRQ causes an
> > immediate - spurious - wake.
> >
> > The solution is to remove the timekeeping suspend/resume functions from
> > the syscore functions and explictly call them at the appropriate time in
> > the suspend/hibernation patchs. I.e. timers are suspend _before_ IRQs
> > get disabled. And accordingly in the resume path.
> 
> So.. I sort of follow this, though from the description disabling
> timekeeping to turn off timers seems a little indirect (I do see that
> suspending timekeeping calls clockevents_suspend() which is the key
> part). Maybe this could be clarified in a future version of the patch
> description?
> 
> I worry that moving timekeeping_suspend earlier in the suspend process
> might cause problems where things access time in the suspend path. I
> recall these orderings have been problematic in the past, and slightly
> tweaking them can often destabilize things badly.

You're right. Just when I received this I started seeing some warning
from the kernel due to ktime_get() called with timekeeping being
suspended.
Though, stability-wise it seems to work.

> 
> I wonder if it would be better just to move the clockevent_suspend()
> call to the earlier site, that way timers are halted but timekeeping
> continues until its normal suspend point.

I'll look into this and send out a patch once I have something working.

	Thanks,
	Sören
