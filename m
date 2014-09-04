Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755095AbaIDJJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 05:09:26 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:62781 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbaIDJJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 05:09:21 -0400
Message-ID: <54082C40.2000107@linaro.org>
Date: Thu, 04 Sep 2014 10:09:20 +0100
From: Daniel Thompson <daniel.thompson@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.7.0
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kgdb-bugreport@lists.sourceforge.net, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Colin Cross <ccross@android.com>, kernel-team@android.com,
        Rob Herring <robherring2@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Dave Martin <Dave.Martin@arm.com>, Fabio Estevam <festevam@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Nicolas Pitre <nico@linaro.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v10 03/19] arm: fiq: Replace default FIQ handler
References: <1408369264-14242-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-1-git-send-email-daniel.thompson@linaro.org> <1408466769-20004-4-git-send-email-daniel.thompson@linaro.org> <20140819173742.GG30401@n2100.arm.linux.org.uk> <53F39377.1070308@linaro.org> <20140828150112.GD30401@n2100.arm.linux.org.uk> <5405AEBC.9020904@linaro.org> <20140902164204.GT30401@n2100.arm.linux.org.uk> <5406EBAA.9040206@linaro.org> <20140903193453.GA30401@n2100.arm.linux.org.uk>
In-Reply-To: <20140903193453.GA30401@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/09/14 20:34, Russell King - ARM Linux wrote:
> On Wed, Sep 03, 2014 at 11:21:30AM +0100, Daniel Thompson wrote:
>> On 02/09/14 17:42, Russell King - ARM Linux wrote:
>>> Yes, it does, because unlike the x86 community, we have a wide range
>>> of platforms, and platform code does not go through the same path or
>>> get the same review as core ARM code.
>>>
>>> As I already pointed out, with a notifier, it's very easy to sneak
>>> something into the FIQ path by submitting a patch for platform code
>>> which calls the registration function.  That's going to be pretty
>>> difficult to spot amongst the 3000+ messages on the linux-arm-kernel
>>> list each month in order to give it the review that it would need.
>>> That's especially true as I now ignore almost all most platform
>>> code patches as we have Arnd and Olof to look at that.
>>>
>>> So, unless you can come up with a proposal which ensures that there
>>> is sufficient review triggered when someone decides to call the
>>> notifier registration function...
>>
>> Reflecting upon this and upon Thomas' comments about only using FIQ for
>> watchdog, backtrace and performance monitoring...
>>
>> The short version is, "I was wrong and should have done what you said in
>> the first place".
>>
>> The long version adds, "because the coupling concerns were spurious; the
>> only proposed users of the default FIQ handler outside of core ARM code,
>> are ARM-centric irqchip drivers."
> 
> I would say that the ARM specific changes to entry-armv.S and setup.c
> are correct.  All that you're doing there is to replace the existing
> default no-op FIQ handler with some additional code which gets us into
> SVC mode and back out, but itself is also a no-op.  In other words, no
> real change.
> 
> That's a good first patch, and one which I would actually like to have
> in my tree sooner rather than later, so that I can split that out from
> my prototype code.

So would I!

I did some rebasing yesterday to put anything to do with kgdb right at
the back of the queue. This "good first patch" is now actually the first
patch; where the nofifier used to be it currently calls do_unexp_fiq()
making it very close to "no real change".

BTW do_unexp_fiq() calls printk() but

> I can also split out from it the ARM generic changes for implementing
> the FIQ dumping too, which gives us a second patch.  With a bit of
> additional work, much of that should actually be generic code, not
> ARM or x86 specific code.  That's going to annoy x86 people a little
> because some of that is being reworked...

So far I have been testing the action after patch review using the big
kgdb patches on top of it.

Today I plan to remove the kgdb stuff, drop in your version of
arch_trigger_all_cpu_backtrace() and test the results. I was going to
use the code you shared on 13 August meaning all the cpu mask bit
manipulation is in the arm-only code.

If you want me to work with something more recent then feel free to
point me at it...


> That will leave the problem of how to deal with the IRQ controller
> specifics, and how to properly wire it together with the IRQ controller
> in the loop - that is where Thomas' concerns are focused.

I'm working on those and its looking pretty good so far. This is mostly
because SGIs don't need to allocate virqs so the controversial bits of
my last patchset disappear completely.

