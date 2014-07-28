Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaG1UCr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 16:02:47 -0400
Received: from mail-bl2lp0207.outbound.protection.outlook.com ([207.46.163.207]:41020
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751162AbaG1UCn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 16:02:43 -0400
Date: Mon, 28 Jul 2014 13:02:25 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Stephen Boyd <sboyd@codeaurora.org>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH RFC v2] PM / sleep: Fix racing timers
References: <53D083C5.2000501@linaro.org>
 <1406322408-15408-1-git-send-email-soren.brinkmann@xilinx.com>
 <53D6A23A.6010904@codeaurora.org> <53D6A36B.1070105@linaro.org>
 <53D6A6B3.4060507@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D6A6B3.4060507@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <d7b265bb-546f-4e86-8e81-197edd1757c5@BN1AFFO11FD007.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(189002)(377454003)(164054003)(199002)(479174003)(377424004)(24454002)(70736001)(76482001)(64706001)(4396001)(81342001)(21056001)(92726001)(86362001)(53416004)(76176999)(87936001)(92566001)(79102001)(31966008)(85852003)(19580395003)(77096002)(20776003)(33646002)(93886003)(50986999)(83506001)(83072002)(85306003)(83322001)(110136001)(85202003)(47776003)(95666004)(81542001)(74316001)(74662001)(6806004)(19580405001)(46102001)(85182001)(104016003)(107046002)(50466002)(74502001)(106466001)(44976005)(80022001)(99396002)(54356999)(102836001)(1496007)(31696002)(23676002)(77982001)(107986001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1AFFO11HUB013;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0286D7B531
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 12:38PM -0700, Stephen Boyd wrote:
> On 07/28/14 12:24, John Stultz wrote:
> > On 07/28/2014 12:19 PM, Stephen Boyd wrote:
> >> On 07/25/14 14:06, Soren Brinkmann wrote:
> >>> On platforms that do not power off during suspend, successfully entering
> >>> suspend races with timers.
> >>>
> >>> The race happening in a couple of location is:
> >>>
> >>>   1. disable IRQs   		(e.g. arch_suspend_disable_irqs())
> >>>      ...
> >>>   2. syscore_suspend()
> >>>       -> timekeeping_suspend()
> >>>        -> clockevents_notify(SUSPEND)
> >>>         -> tick_suspend()   	(timers are turned off here)
> >>>      ...
> >>>   3. wfi            		(wait for wake-IRQ here)
> >>>
> >>> Between steps 1 and 2 the timers can still generate interrupts that are
> >>> not handled and stay pending until step 3. That pending IRQ causes an
> >>> immediate - spurious - wake.
> >>>
> >>> The solution is to move the clockevents suspend/resume notification
> >>> out of the syscore_suspend step and explictly call them at the appropriate
> >>> time in the suspend/hibernation paths. I.e. timers are suspend _before_
> >>> IRQs get disabled. And accordingly in the resume path.
> >>>
> >>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> >> Do we know which timer_list or hrtimer wants to run while entering
> >> suspend? I'd suspect the scheduler tick but perhaps we just forgot to
> >> cancel some timer during suspend?
> > Though, canceling timers really shouldn't be necessary for
> > suspend/resume, no?
> >
> >
> 
> Agreed. Perhaps I put it the wrong way. I'm worried that some timer
> needs to run just when we go into suspend. As long as that timer is the
> scheduler tick we should be ok, but if it isn't the scheduler tick then
> it would be good to know what it is and why it's pending. Unless the
> idea is that if we get this far into suspend and there's a pending timer
> we should just ignore it and go to sleep anyway?

Well, that is pretty much what happens currently. The IRQs are disabled
and nobody cares about the pending timer. My problem with that is, that
"suspend" for Zynq is just waiting in WFI. Hence, the pending interrupts
causes an immediate resume.
So, it should hopefully be more or less fine since the current
implementation basically ignores the timer. With this patch we just shut
them down a little earlier to prevent this pending interrupt - at least
that is the intention.

	Thanks,
	Sören
