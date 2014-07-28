Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbaG1Pv1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:51:27 -0400
Received: from mail-bn1lp0144.outbound.protection.outlook.com ([207.46.163.144]:18770
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752161AbaG1PvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:51:24 -0400
Date: Mon, 28 Jul 2014 08:51:18 -0700
From: =?utf-8?B?U8O2cmVu?= Brinkmann <soren.brinkmann@xilinx.com>
To: Pavel Machek <pavel@ucw.cz>
CC: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>, <linux-kernel@vger.kernel.org>,
        <linux-pm@vger.kernel.org>, Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH RFC v2] PM / sleep: Fix racing timers
References: <53D083C5.2000501@linaro.org>
 <1406322408-15408-1-git-send-email-soren.brinkmann@xilinx.com>
 <20140728100538.GA16237@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140728100538.GA16237@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-RCIS-Action: ALLOW
Message-ID: <db9a4d35-891e-4b66-aa70-25c1f65012fd@BN1BFFO11FD021.protection.gbl>
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:149.199.60.83;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(438002)(51704005)(24454002)(377424004)(199002)(189002)(70736001)(83072002)(85852003)(86362001)(74662001)(6806004)(64706001)(47776003)(31966008)(1496007)(20776003)(74502001)(50986999)(92726001)(81342001)(92566001)(99396002)(85202003)(31696002)(102836001)(95666004)(106466001)(46102001)(81542001)(85306003)(76482001)(107046002)(79102001)(83506001)(110136001)(4396001)(53416004)(74316001)(21056001)(77982001)(85182001)(44976005)(83322001)(80022001)(19580395003)(19580405001)(76176999)(77096002)(33646002)(50466002)(104016003)(54356999)(23676002)(87936001)(107986001)(217873001);DIR:OUT;SFP:;SCL:1;SRVR:BN1BFFO11HUB031;H:xsj-pvapsmtpgw01;FPR:;MLV:sfv;PTR:unknown-60-83.xilinx.com;A:1;MX:1;LANG:en;
X-OriginatorOrg: xilinx.onmicrosoft.com
X-Microsoft-Antispam: BCL:0;PCL:0;RULEID:
X-Forefront-PRVS: 0286D7B531
Authentication-Results: spf=pass (sender IP is 149.199.60.83)
 smtp.mailfrom=soren.brinkmann@xilinx.com; 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-28 at 12:05PM +0200, Pavel Machek wrote:
> On Fri 2014-07-25 14:06:48, Soren Brinkmann wrote:
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
> 
> Did you test the hibernation?
No, I don't have a system to test hibernation. Suspend seems to work
fine though.

	Sören
