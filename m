Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab3CYWxJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 18:53:09 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40225 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932811Ab3CYWxF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 18:53:05 -0400
Message-ID: <5150D54D.1070004@linaro.org>
Date: Mon, 25 Mar 2013 15:53:01 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Rob Herring <robherring2@gmail.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
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
Subject: Re: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com> <20130325172633.GP30923@n2100.arm.linux.org.uk> <5150C16A.3040208@gmail.com> <201303252236.23270.arnd@arndb.de>
In-Reply-To: <201303252236.23270.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 03:36 PM, Arnd Bergmann wrote:
> On Monday 25 March 2013, Rob Herring wrote:
>> I count integrator-cp, realview, versatile and non-DT VExpress that do
>> this (not surprisingly) and 25 platforms or timer implementations plus
>> arm64 that do sched_clock setup in time_init. What's broken by not
>> moving these earlier?
> timekeeping_init() will leave the persistent_clock_exist variable as "false",
> which is read in rtc_suspend() and timekeeping_inject_sleeptime().

Are you mixing up the persistent_clock and sched_clock here? From a 
generic stand-point they have different requirements.

> For all I can tell, you will get a little jitter every time you
> do a suspend in that case. Or perhaps it means the system clock
> will be forwarded by the amount of time spent in suspend twice
> after wakeup, but I'm probably misreading the code for that case.

No, you shouldn't see timekeeping being incremented twice, we check in 
rtc_resume code if the persistent clock is present if so we won't inject 
any measured suspend time there. But you're probably right that we're 
being a little overly paranoid checking the same value twice.

As far as the benefit to the persistent clock: it is just a little 
better to use, since we can access it earlier in resume, prior to 
interrupts being enabled. So we should see less time error introduced 
each suspend.

thanks
-john

