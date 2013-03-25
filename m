Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758969Ab3CYV2Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 17:28:16 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:46201 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab3CYV2N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 17:28:13 -0400
Message-ID: <5150C16A.3040208@gmail.com>
Date: Mon, 25 Mar 2013 16:28:10 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mark Rutland <mark.rutland@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-sh@vger.kernel.org" <linux-sh@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        John Stultz <john.stultz@linaro.org>,
        Will Deacon <Will.Deacon@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] ARM: convert arm/arm64 arch timer to use CLKSRC_OF init
References: <1363818875-15978-1-git-send-email-robherring2@gmail.com> <20130321110646.GE15279@e106331-lin.cambridge.arm.com> <20130325172633.GP30923@n2100.arm.linux.org.uk>
In-Reply-To: <20130325172633.GP30923@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/25/2013 12:26 PM, Russell King - ARM Linux wrote:
> On Thu, Mar 21, 2013 at 11:06:47AM +0000, Mark Rutland wrote:
>> On TC2 this series leads to using the vexpress 24MHz clock as the sched clock
>> in preference to the architected timer:
>>
>>   Architected local timer running at 24.00MHz (virt).
>>   Switching to timer-based delay loop
>>   Registered arch_counter_get_cntvct+0x0/0x14 as sched_clock source
>>   sched_clock: 32 bits at 24MHz, resolution 41ns, wraps every 178956ms
>>   Registered versatile_read_sched_clock+0x0/0x28 as sched_clock source
>>
>> As they both have the same frequency, neither overrides the other, and
>> whichever gets registered last is used as the sched_clock. As accesses
>> to the architected timer are going to have a much lower overhead, this
>> isn't very nice (and it could be better to use it even if it had a lower
>> frequency).
> 
> I'll remind people that sched_clock() is supposed to be functional at
> the point in the boot sequence where the call to sched_init() is called.
> That is after setup_arch() and *before* time_init() is called.

I count integrator-cp, realview, versatile and non-DT VExpress that do
this (not surprisingly) and 25 platforms or timer implementations plus
arm64 that do sched_clock setup in time_init. What's broken by not
moving these earlier?

We could probably fix arch timers relatively easily, but supporting the
numerous memory-mapped timers will be harder. Most timers are also
dependent on the clocks being initialized. That's really an orthogonal
issue to what this patch series solves. This series is about selecting
the best sched_clock when multiple timers are present. Perhaps one that
is setup in init_early should be preferred over one setup in init_time.
I'm not sure how to detect that.

Rob

