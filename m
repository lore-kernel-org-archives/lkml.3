Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaBGXPi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 18:15:38 -0500
Received: from mail-ee0-f54.google.com ([74.125.83.54]:62722 "EHLO
	mail-ee0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913AbaBGXPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 18:15:37 -0500
Message-ID: <52F56913.4090109@gmail.com>
Date: Sat, 08 Feb 2014 00:15:31 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
To: Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>
CC: =?UTF-8?B?RW1pbGlvIEzDs3Bleg==?= <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Andrew Lunn <andrew@lunn.ch>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: respect the clock dependencies in of_clk_init
References: <1391554766-11285-1-git-send-email-gregory.clement@free-electrons.com> <52F4DA40.4090804@elopez.com.ar> <20140207142430.GU8533@titan.lakedaemon.net> <20140207144325.GA8218@localhost> <52F4F279.6010006@free-electrons.com>
In-Reply-To: <52F4F279.6010006@free-electrons.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 03:49 PM, Gregory CLEMENT wrote:
> On 07/02/2014 15:43, Ezequiel Garcia wrote:
>> On Fri, Feb 07, 2014 at 09:24:30AM -0500, Jason Cooper wrote:
>>> On Fri, Feb 07, 2014 at 10:06:08AM -0300, Emilio López wrote:
>>>
>>> [snip a great explanation]
>>>
>>> Guys, can I get some Tested-by's on this?
>>>
>>
>> In case someone missed Emilio's comment about it, I gave his oneliner
>> a test on A370 Reference Design. It worked just as well as Sebastian's.
>
> Well ok it's working but this patch is not better than Sebastian, it is
> even worth. I don't think it is a good idea at all to totally ignore the

Tstststs.. Gregory please re-read the above slooooowly.. and think about
where you'd put me in.

Hint: "this patch", "not better than", "even worse". ;)

> information given by the device tree.

Actually, I have no strong opinion about how we fix the issue now. 
Emilio's patch is short and very suitable for a fix. I'll test later
this weekend.

For the long run, I definitely prefer probe ordering within clk frame
work or even better some early_device stuff.

>> Tested-by: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
>>
>>>> -----8<------
>>>>
>>>>  From ffdb49506e3ce92090c15e1f9b37f4d465097ac1 Mon Sep 17 00:00:00 2001
>>>> From: =?UTF-8?q?Emilio=20L=C3=B3pez?= <emilio@elopez.com.ar>
>>>> Date: Thu, 6 Feb 2014 18:07:07 -0300
>>>> Subject: [PATCH] clk: mvebu: fix name dependency during registration time
>>>>
>>>> Currently, mvebu_clk_gating_setup has a silly dependency on clock
>>>> registration order just to gather the parent clock name. This is

Of course, the dependency is not silly but we are just ignoring that
some clocks actually have a different parent clock. As long as we are
not interested in the frequency and they all depend on a fixed-clock
it makes no difference. Also, on some gates, we do some tweaking, e.g.
on Dove there is a clock gate for the GBE ip that we loop back to the
GBE PHY gate.. some day I may be so bored to get it straight.

>>>> completely unnecesary, as it supports using an already provided name
>>>> via the clk_gating_soc_desc structs, and we can therefore solve this
>>>> issue with a 69+/- line patch. But, given that the parent name is
>>>> always "tclk" as default-hardcoded on mvebu_coreclk_setup(), we can
>>>> just default-hardcode it here too and get away with solving this
>>>> problem with a one-liner.

I agree with the default hard-coded "tclk" for now. But in general,
clocking can become very nasty and rather than coding the whole fscking
clock tree like the imx clock tree beast does, it would be much more
readable to be able separate the clock drivers into different parts.

Sebastian

>>>> ---
>>>>   drivers/clk/mvebu/common.c | 2 +-
>>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/clk/mvebu/common.c b/drivers/clk/mvebu/common.c
>>>> index 25ceccf..6c63b43 100644
>>>> --- a/drivers/clk/mvebu/common.c
>>>> +++ b/drivers/clk/mvebu/common.c
>>>> @@ -121,7 +121,7 @@ void __init mvebu_clk_gating_setup(struct
>>>> device_node *np,
>>>>   	struct clk_gating_ctrl *ctrl;
>>>>   	struct clk *clk;
>>>>   	void __iomem *base;
>>>> -	const char *default_parent = NULL;
>>>> +	const char *default_parent = "tclk";
>>>>   	int n;
>>>>
>>>>   	base = of_iomap(np, 0);
>>>> --
>>>> 1.8.5.3


