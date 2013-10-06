Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab3JFRmJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Oct 2013 13:42:09 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:37392 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753892Ab3JFRmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Oct 2013 13:42:07 -0400
Message-ID: <5251BD09.3050900@gmail.com>
Date: Sun, 06 Oct 2013 21:42:01 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Andrew Lunn <andrew@lunn.ch>,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        Grant Likely <grant.likely@linaro.org>,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] clk: provide public clk_is_enabled function
References: <1380881310-24345-1-git-send-email-sebastian.hesselbarth@gmail.com> <20131005202430.GI10079@pengutronix.de> <20131005204208.GB28106@lunn.ch> <20131006090609.GK14747@book.gsilab.sittig.org> <20131006163011.GA30818@lunn.ch>
In-Reply-To: <20131006163011.GA30818@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2013 06:30 PM, Andrew Lunn wrote:
> On Sun, Oct 06, 2013 at 11:06:09AM +0200, Gerhard Sittig wrote:
>> On Sat, Oct 05, 2013 at 22:42 +0200, Andrew Lunn wrote:
>>>
>>> On Sat, Oct 05, 2013 at 10:24:30PM +0200, Uwe Kleine-König wrote:
>>>> On Fri, Oct 04, 2013 at 12:08:30PM +0200, Sebastian Hesselbarth wrote:
>>>>> To determine if a clk has been previously enabled, provide a public
>>>>> clk_is_enabled function. This is especially helpful to check the state
>>>>> of clk-gate without actually changing the state of the gate.
>>>> I wonder what you want to do with the return value.
>>>>
>>>> When doing
>>>>
>>>> 	if (clk_is_enabled(someclk))
>>>> 		do_something();
>>>>
>>>> you cannot in general know if the clock is still on when you start to
>>>> do_something.
>>>
>>> Hi Uwe
>>>
>>> At least in the use case Sebastian needs it for, we don't need an "in
>>> general" solution. It is used early boot time to see if the boot
>>> loader left the clock running.
>>
>> Wait, unless I'm missing something, the clk_is_enabled() call
>> _won't_ determine whether the clock is enabled in hardware
>> (whether the boot loader created or left this condition), instead
>> it only determines whether clk_enable() was called previously and
>> thus the clock _shall_ be enabled.
>
> Nope, you are wrong.
>
> static int clk_gate_is_enabled(struct clk_hw *hw)
> {
> 	u32 reg;
> 	struct clk_gate *gate = to_clk_gate(hw);
>
> 	reg = clk_readl(gate->reg);
>
> 	/* if a set bit disables this clk, flip it before masking */
> 	if (gate->flags & CLK_GATE_SET_TO_DISABLE)
> 	   reg ^= BIT(gate->bit_idx);
>
> 	   reg &= BIT(gate->bit_idx);
>
> 	   return reg ? 1 : 0;
> }
>
> It reads the hardware state.
>
>> AFAIK the kernel's CCF support is "self contained" and does not
>> consider any data or state that was "inherited" from boot staged
>> before the kernel.  That's why the "disable unused" step disables
>> everything that wasn't acquired _in the kernel_ regardless of
>> what the boot loader may have done or what is enabled at reset.
>
> Not quite true. It uses the is_enabled(), which gets the real hardware
> state, to turn off clocks which are unused but on. It will not turn
> off clock which are already off. So it is inheriting some state from
> the boot loader, in that it knows if the bootloader turned it
> on. However this is not propagated into prepare/enable status.
>
>>> The other user of the clock is the
>>> ethernet driver, which we know cannot change it yet, because driver
>>> probing has not started yet.
>>
>> I understand that the situation here is, that the ethernet driver
>> hasn't probed yet, but the clock driver did.  You are in early setup
>> code and want to (check and) fetch data from the hardware which the
>> ethernet driver later needs.
>
> Nearly, but not quite. If there is an enabled DT node for the device,
> and that node does not have a valid local-mac-address property in the
> node, the bootloader should of programmed the MAC address into the
> device. If it has done that, the clock should be running, because as
> soon as you turn the clock off, it forgets the MAC address. Thus, if
> we find an enabled device in DT, without a valid local-mac-address,
> and the clock is off, we have a bootloader bug, which we want to
> report.
>
>> What's wrong with an explicit enable/disable around the data
>> acquisition?
>
> It avoids the CPU locking hard, but will not get us a valid MAC
> address, which is the point of the exercise.

While I agree to all Andew explained above, I somehow have the strong
feeling that an clk_is_enabled will just be abused where possible. We
already have two ppl complaining about it - even though a quick look at
clk/core.c should have cleared out most of it.

Maybe we should just enable the clock, get the (possibly bogus) MAC
and disable it again. We loose one possible FW_BUG report and overwrite
an invalid local-mac-address property with another invalid one.

Sebastian
