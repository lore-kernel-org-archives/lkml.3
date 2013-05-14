Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3ENWqg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 18:46:36 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36148 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab3ENWqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 18:46:35 -0400
X-IronPort-AV: E=Sophos;i="4.87,672,1363158000"; 
   d="scan'208";a="47332479"
Message-ID: <5192BEC9.1040104@codeaurora.org>
Date: Tue, 14 May 2013 15:46:33 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: linux-arm-kernel@lists.infradead.org,
        Mike Turquette <mturquette@linaro.org>, Paul Walmsley <paul@pwsan.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>,
        Ulf Hansson <ulf.hansson@linaro.org>, Andrew Lunn <andrew@lunn.ch>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-arm-msm@vger.kernel.org, Magnus Damm <magnus.damm@gmail.com>,
        linux-kernel@vger.kernel.org, Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>, Jamie Iles <jamie@jamieiles.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>
Subject: Re: [PATCH] clk: Fix race condition between clk_set_parent and clk_enable()
References: <1367383328-25700-1-git-send-email-skannan@codeaurora.org> <20130514185417.10068.5717@quantum> <9066674.E2RzuEn3ap@flatron>
In-Reply-To: <9066674.E2RzuEn3ap@flatron>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/14/2013 03:10 PM, Tomasz Figa wrote:
> Hi,
>
> On Tuesday 14 of May 2013 11:54:17 Mike Turquette wrote:
>> Quoting Saravana Kannan (2013-04-30 21:42:08)
>>
>>> Without this patch, the following race conditions are possible.
>>>
>>> Race condition 1:
>>> * clk-A has two parents - clk-X and clk-Y.
>>> * All three are disabled and clk-X is current parent.
>>> * Thread A: clk_set_parent(clk-A, clk-Y).
>>> * Thread A: <snip execution flow>
>>> * Thread A: Grabs enable lock.
>>> * Thread A: Sees enable count of clk-A is 0, so doesn't enable clk-Y.
>>> * Thread A: Updates clk-A SW parent to clk-Y
>>> * Thread A: Releases enable lock.
>>> * Thread B: clk_enable(clk-A).
>>> * Thread B: clk_enable() enables clk-Y, then enabled clk-A and
>>> returns.
>>>
>>> clk-A is now enabled in software, but not clocking in hardware since
>>> the hardware parent is still clk-X.
>>>
>>> The only way to avoid race conditions between clk_set_parent() and
>>> clk_enable/disable() is to ensure that clk_enable/disable() calls
>>> don't
>>> require changes to hardware enable state between changes to software
>>> clock topology and hardware clock topology.
>>>
>>> There are options to achieve the above:
>>> 1. Grab the enable lock before changing software/hardware topology and
>>>
>>>     release it afterwards.
>>>
>>> 2. Keep the clock enabled for the duration of software/hardware
>>> topology>
>>>     change so that any additional enable/disable calls don't try to
>>>     change
>>>     the hardware state. Once the topology change is complete, the clock
>>>     can
>>>     be put back in its original enable state.
>>>
>>> Option (1) is not an acceptable solution since the set_parent() ops
>>> might need to sleep.
>>>
>>> Therefore, this patch implements option (2).
>>>
>>> This patch doesn't violate any API semantics. clk_disable() doesn't
>>> guarantee that the clock is actually disabled. So, no clients of a
>>> clock can assume that a clock is disabled after their last call to
>>> clk_disable(). So, enabling the clock during a parent change is not a
>>> violation of any API semantics.
>>>
>>> This also has the nice side effect of simplifying the error handling
>>> code.
>>>
>>> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
>>
>> I've taken this patch into clk-next for testing.  The code itself looks
>> fine.  The only thing that remains to be seen is if any platforms have a
>> problem with disabled clocks getting turned on during a reparent
>> operation.
>
> IMHO this behavior should be documented somewhere, with a note that the
> clock must not be prepared to keep it disabled during reparent operation
> and possibly also pointing to the CLK_SET_PARENT_GATE flag.

Reasonable request. I can update the documentation of clk_set_parent() 
to indicate that the clock might get turned on for the duration of the 
call and if they need a guarantee the GATE flag should be used.

>
>> On platforms that I have worked on this is OK, but I suppose there could
>> be some platform out there where a clock is prepared and disabled, and
>> briefly enabling the clock during the reparent operation somehow puts
>> the hardware in a bad state.
>
> Well, on any platform where default clock settings are not completely
> correct this is likely to cause problems, because some device might get
> too high frequency for some period of time, which might crash it alone as
> well as the whole system.
>

I don't think this is really a problem with this patch. It's present 
even without this patch.

The patch doesn't switch to some other unspecified parent. It only 
switches between the new/old parent. Even without this patch, if a clock 
is prepared while you reparent it, clk_enable() could be called at 
anytime between the parent switch and the future clock API calls to set 
up the new parent correctly. I think that's just crappy driver code to 
switch to a new parent before setting it up correctly. There's 
absolutely no good reason to do it that way.

-Saravana

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
