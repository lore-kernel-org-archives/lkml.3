Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756566AbaH0Afd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 20:35:33 -0400
Received: from mail-bl2lp0209.outbound.protection.outlook.com ([207.46.163.209]:25228
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756225AbaH0Afb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 20:35:31 -0400
Date: Tue, 26 Aug 2014 17:35:07 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Pavel Machek <pavel@ucw.cz>, Len Brown <len.brown@intel.com>,
        <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: Re: [PATCH] PM / sleep: Fix racing timers
References: <1408568109-30297-1-git-send-email-soren.brinkmann@xilinx.com>
 <19851825.qu8r5WDRRO@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <19851825.qu8r5WDRRO@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1018-20902.005
X-TM-AS-Result: No--19.168-5.0-31-1
X-imss-scan-details: No--19.168-5.0-31-1
Message-ID: <64c2b0ef-39e9-4194-aec1-8026b7fbe272@BY2FFO11FD014.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(199003)(377424004)(24454002)(189002)(377454003)(164054003)(51704005)(77982001)(81542001)(110136001)(104016003)(107046002)(64706001)(46102001)(106466001)(79102001)(81342001)(47776003)(83506001)(85202003)(20776003)(4396001)(85306004)(95666004)(53416004)(23676002)(87936001)(85182001)(92566001)(21056001)(77096002)(90102001)(92726001)(99396002)(31966008)(1496007)(74662001)(74502001)(80022001)(44976005)(83322001)(86362001)(85852003)(31696002)(83072002)(74316001)(76176999)(76482001)(50986999)(6806004)(50466002)(70736001)(54356999)(102836001)(107986001);DIR:OUT;SFP:;SCL:1;SRVR:BY2FFO11HUB045;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:;UriScan:;
X-Forefront-PRVS: 0316567485
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
X-OriginatorOrg: xilinx.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-08-27 at 02:32AM +0200, Rafael J. Wysocki wrote:
> Hi,
> 
> Sorry for being somewhat slow to respond to this, but I'm not sure if the
> approach here is the right one.
> 
> On Wednesday, August 20, 2014 01:55:09 PM Soren Brinkmann wrote:
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
> 
> Well, the problem here is that the platform is not supposed to re-enable
> interrupts after syscore_suspend().  Of course, some platforms do that, because
> they don't really support system sleep and try to emulate it with something
> along the lines of suspend-to-idle.

No, IRQs are not enabled after syscore-suspend. But the wait for
interrupt state on ARM is left even with IRQs disabled. It will prevent
the core from taking the exception, but it will "wake" it up. So, my
impressions was that the core is the appropriate location to fix this. I
wouldn't know where else to do it.

It is certainly an issue caused by this probably non-standard suspend
state, but if we accept this implementation as a valid suspend
implementation, I'd say it's a core issue.

	Thanks,
	Sören
