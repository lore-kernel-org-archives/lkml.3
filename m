Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755860Ab3BNGpH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 01:45:07 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:53247 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755352Ab3BNGpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 01:45:05 -0500
MIME-Version: 1.0
In-Reply-To: <511C3E32.9010709@gmail.com>
References: <1360264144-20714-1-git-send-email-robherring2@gmail.com>
	<1360264144-20714-2-git-send-email-robherring2@gmail.com>
	<CAHTX3dKLCbfhBaHKBE=fVTcRReVL6yotA9e_8S70bH+_gajL5Q@mail.gmail.com>
	<511BC043.4030506@gmail.com>
	<CAHTX3d+2rGBE3ZBwiHbq7tOi+OE+5KGPh34APzp0NhRP=mBv+w@mail.gmail.com>
	<511C3E32.9010709@gmail.com>
Date: Thu, 14 Feb 2013 07:45:02 +0100
Message-ID: <CAHTX3dKcnkjOTY5yyBSwcUH0Rxz+L9ZROeaemMYLexW50Z7Eng@mail.gmail.com>
Subject: Re: [PATCH 1/4] clocksource: pass DT node pointer to init functions
From: Michal Simek <monstr@monstr.eu>
To: Rob Herring <robherring2@gmail.com>
Cc: arm@kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Stephen Warren <swarren@wwwdotorg.org>,
        John Stultz <johnstul@us.ibm.com>,
        Josh Cartwright <josh.cartwright@ni.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/2/14 Rob Herring <robherring2@gmail.com>:
> On 02/13/2013 11:33 AM, Michal Simek wrote:
>> 2013/2/13 Rob Herring <robherring2@gmail.com>:
>>> On 02/13/2013 10:21 AM, Michal Simek wrote:
>>>> 2013/2/7 Rob Herring <robherring2@gmail.com>:
>>>>> From: Rob Herring <rob.herring@calxeda.com>
>>>>>
>>>>> In cases where we have multiple nodes of the same type, we may need the
>>>>> node pointer to know which node was matched. Passing the node pointer
>>>>> also keeps the init function from having to match the node a 2nd time.
>>>>>
>>>>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>>>>> Cc: John Stultz <johnstul@us.ibm.com>
>>>>> Cc: Thomas Gleixner <tglx@linutronix.de>
>>>>> ---
>>>>>  drivers/clocksource/clksrc-of.c |    4 ++--
>>>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> Tested-by: Michal Simek <michal.simek@xilinx.com>
>>>>
>>>> The rest is just the same as I have done. Any option to add these
>>>> patches to v3.9?
>>>
>>> I would like to before we have more users to fix, but it will have to be
>>> post rc1. If not, Arnd/Olof should be be able to provide a stable branch
>>> for 3.10.
>>
>> ok
>
> I now see you were trying to get zynq changes in for 3.9. You could add
> this patch to your pull request. As is, it is not dependent on some DT
> code changes, but the subsequent patches are. I can send the rest after
> rc1. It's a bit of a hack with the function call prototype, but nothing
> actually breaks. I was going to combine as Arnd suggested, but either
> way is probably fine.

It is not big deal with that. I just want to use this patch. No problem to keep
it in my repo. I am not worried about. The main point for me is that
the patch exists
and I can use it.


>>>> Because I need these patches for zynq timer because we have two in the soc.
>>>> Is it OK to register several clock source and clockevent devices?
>>>
>>> If it is 1 DT node, then that should be fine.
>>
>> zynq is using two triple timer counter IP . There are also described by two
>> different DT nodes because there are separated and uses different baseaddresses.
>>
>> Does it mean that if there are 2 DT nodes that it won't work?
>>
>>
>> One more thing. Is there any rule which should describe which timer should be
>> used for clockevent and for clocksource?
>
> No. This is a common problem. A simple solution is a "linux,clockevent"
> property, but I want to avoid that.

Let me describe it a little bit more. I am going to change current
mainline implementation
for zynq timer which uses special compatible string to define
clocksource and clockevent
device. I don't think this is right way to go because compatible
string shouldn't point
to device usage. Which is exact case you wanted to avoid.

> Ultimately it is some feature of the
> h/w that makes you choose. This could be it has an interrupt or not,
> higher frequency, has timer compare pins, gets power gated, etc. So you
> should describe enough of the h/w properties to make this decision.

For different timer type, kernel should decide which timer should be
used. It should be easy to test
because I can add some timers to the programmable logic (as is done
for Microblaze) and check
how kernel decide which clocksource/clockevent device will use. I
believe there is any logic around.


For solution with two instances of the same triple timer counters it
is impossible
to specify additional h/w property because all of 6 timers are the same.
And also adding special parameter to IP goes against rule
that device-tree should describe hw not Linux usage.
Maybe enough to save information to driver that clocksource and
clockevent device is registered
and do not try to register another timer (and also another timer from
another instance).

Or maybe it can be done via chosen property or via aliases property where
timer0 alias is that one who should be used for clocksource and
clockevent device.
(for my case alias to one instance of triple timer counter).

I saw some dtses which have aliases timer.

How good/bad is this option?


> OMAP
> is an example doing this with lots of timers with varying integration
> level differences.

Can you point me that that omap drivers you are talking about?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian and responsible for u-boot arm zynq platform
