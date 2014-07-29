Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaG2XWk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 19:22:40 -0400
Received: from mail-bn1blp0187.outbound.protection.outlook.com ([207.46.163.187]:2139
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754498AbaG2XWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 19:22:39 -0400
Date: Tue, 29 Jul 2014 16:22:31 -0700
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
 <d7b265bb-546f-4e86-8e81-197edd1757c5@BN1AFFO11FD007.protection.gbl>
 <53D828A0.1080408@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D828A0.1080408@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <cdd55961-e247-4385-b86e-a0a0b794ab58@BN1BFFO11FD020.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(979002)(6009001)(438002)(189002)(479174003)(164054003)(24454002)(199002)(54094003)(377424004)(51704005)(86362001)(20776003)(21056001)(92566001)(85306003)(77096002)(47776003)(79102001)(77982001)(50466002)(70736001)(83072002)(74502001)(104016003)(95666004)(4396001)(31966008)(83506001)(76482001)(23676002)(102836001)(107046002)(74662001)(1496007)(87936001)(46102001)(6806004)(76176999)(92726001)(50986999)(64706001)(85852003)(54356999)(80022001)(33646002)(93886003)(81542001)(85202003)(31696002)(85182001)(81342001)(83322001)(74316001)(53416004)(106466001)(44976005)(110136001)(99396002)(107986001)(217873001)(23106004)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB034;H:xsj-pvapsmtpgw01;FPR:;MLV:ovrnspm;PTR:unknown-60-83.xilinx.com;MX:1;A:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0287BBA78D
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-07-29 at 04:05PM -0700, Stephen Boyd wrote:
> On 07/28/14 13:02, Sören Brinkmann wrote:
> > On Mon, 2014-07-28 at 12:38PM -0700, Stephen Boyd wrote:
> >>
> >> Agreed. Perhaps I put it the wrong way. I'm worried that some timer
> >> needs to run just when we go into suspend. As long as that timer is the
> >> scheduler tick we should be ok, but if it isn't the scheduler tick then
> >> it would be good to know what it is and why it's pending. Unless the
> >> idea is that if we get this far into suspend and there's a pending timer
> >> we should just ignore it and go to sleep anyway?
> > Well, that is pretty much what happens currently. The IRQs are disabled
> > and nobody cares about the pending timer. 
> 
> Yep. It sounds like we don't know what it is so let's hope it's the
> sched tick. I suspect that driver suspend paths are canceling their
> timers because their hardware has been quiesced.
Drivers probably, as well as the suspend path in general, mask all non-timer
and non-wakeup interrupts.

> 
> > My problem with that is, that
> > "suspend" for Zynq is just waiting in WFI. Hence, the pending interrupts
> > causes an immediate resume.
> > So, it should hopefully be more or less fine since the current
> > implementation basically ignores the timer. With this patch we just shut
> > them down a little earlier to prevent this pending interrupt - at least
> > that is the intention.
> >
> 
> That sort of WFI based suspend doesn't actually sound like a memory
> suspend at all. It's really the "freeze" state where we would sit in the
> deepest CPU idle state waiting for some prescribed wakeup event (power
> button press, etc.) that would then trigger a wakeup_source to be
> activated and then wakeup the suspend thread.
> 
> Unless the WFI actually triggers some power state controller? For
> example, on the ARM platforms I have we trigger suspend via a WFI, which
> causes a power state controller to pull the power from the CPU that
> triggered the WFI and then goes ahead and turns off the rest of the SoC
> power and puts the ddr in self-refresh. If we have a pending irq then
> the power state controller would abort suspend and we'd come right back
> almost immediately (similar to your situation). The thing is we don't
> see any pending irqs and we don't have this patch, so I wonder if we
> just haven't hit this case, or if there's something more fundamental
> going on that causes a difference. Or maybe we do see this pending irq
> sometimes but we don't care because we'll try and go right back to
> suspend again.
On Zynq we don't have such sophisticated external helpers. The ARM core
does everything on its own and power down is pretty much impossible by
design.
So, for Zynq we enable some low power features, move execution to OCM,
shut down PLLs and DRAM as far as possible and then just sit in wfi
(which might trigger some external low power features like SCU and L2$
standby etc.), but no smart external power controller.

One thing that might make this happen on Zynq more frequently is
that we use a 16-bit timer. I guess that timer overflowing all the
time probably causes more frequent interrupts than you'd see on
platforms with wider timers. After all the window in which this
problem would occur is rather small.

	Thanks,
	Sören
