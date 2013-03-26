Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796Ab3CZJ4r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:56:47 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:53791 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab3CZJ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:56:44 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
Date: Tue, 26 Mar 2013 09:56:28 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: Rob Herring <robherring2@gmail.com>,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>, Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com> <201303252236.23270.arnd@arndb.de> <5150D54D.1070004@linaro.org>
In-Reply-To: <5150D54D.1070004@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303260956.28784.arnd@arndb.de>
X-Provags-ID: V02:K0:GwIxWl9iLwNwWzTIAD7d3K4DUDv7TiUB8U7mbraSZn9
 Kgyp3ozSmZfxHUJd7x5/86GNs40eYpvYwPRXQFKAnb8b+uFK8E
 HGhlFQG6+GSZ85glvbrW9ZmPch7E2eqi8nN9s126r+oe9qhhD/
 MiztdpWUOwgkF7Rghbp4rrz/AXmwJAvXcocEXxokT0+QgB3rvG
 Qi3wbCOt18q2aeaPt5esXWMzt9dvEoNM8xFARWh+aDHt2io7Te
 PEDo8bxpES7LKTQSVwNbAtVcpHzr9dq3xHkeiBFbtxBkzJDByI
 CoHt8NFBmKifE/qXBVKTHMNvxs4W4s7A6d/Jw1ENTSCMdo7GWh
 ZVMn1xkiOi24GfUUSaUw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 25 March 2013, John Stultz wrote:
> On 03/25/2013 03:36 PM, Arnd Bergmann wrote:
> > On Monday 25 March 2013, Rob Herring wrote:
> >> I count integrator-cp, realview, versatile and non-DT VExpress that do
> >> this (not surprisingly) and 25 platforms or timer implementations plus
> >> arm64 that do sched_clock setup in time_init. What's broken by not
> >> moving these earlier?
> > timekeeping_init() will leave the persistent_clock_exist variable as "false",
> > which is read in rtc_suspend() and timekeeping_inject_sleeptime().
> 
> Are you mixing up the persistent_clock and sched_clock here? From a 
> generic stand-point they have different requirements.

Ah, sorry about that. I had stumbled over the persistent_clock
issue earlier and was confusing the two.

> > For all I can tell, you will get a little jitter every time you
> > do a suspend in that case. Or perhaps it means the system clock
> > will be forwarded by the amount of time spent in suspend twice
> > after wakeup, but I'm probably misreading the code for that case.
> 
> No, you shouldn't see timekeeping being incremented twice, we check in 
> rtc_resume code if the persistent clock is present if so we won't inject 
> any measured suspend time there. But you're probably right that we're 
> being a little overly paranoid checking the same value twice.

Well, the point is that has_persistent_clock() returns false because
it is not yet active when the flag gets set in timekeeping_init(),
but when we call read_persistent_clock() in timekeeping_suspend(),
it will actually return a non-zero time.
 
> As far as the benefit to the persistent clock: it is just a little 
> better to use, since we can access it earlier in resume, prior to 
> interrupts being enabled. So we should see less time error introduced 
> each suspend.

Ok.

	Arnd
