Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986AbaIZKup (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:50:45 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:46453 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753419AbaIZKun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 06:50:43 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Fri, 26 Sep 2014 12:50:00 +0200
From: Stefan Agner <stefan@agner.ch>
To: Bill Pringlemeir <bpringlemeir@nbsps.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, linus.walleij@linaro.org,
        gnurou@gmail.com, kernel@pengutronix.de, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] pinctrl: imx: add gpio pinmux support for vf610
In-Reply-To: <877g0rlkh3.fsf@nbsps.com>
References: <cover.1411492954.git.stefan@agner.ch>
 <bb68d2360314158cd8ccb9c6794877c3bb45d72e.1411492954.git.stefan@agner.ch>
 <20140925024712.GB6405@dragon> <1d3735aff5e0961c43d349d673a1c2b2@agner.ch>
 <20140925090714.GH6405@dragon> <26008fa68a3eaf5f806a7dc4df48f77e@agner.ch>
 <877g0rlkh3.fsf@nbsps.com>
Message-ID: <e9ddcd256056187ffea0b05b7b31c1a6@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-25 18:43, schrieb Bill Pringlemeir:
> On 25 Sep 2014, stefan@agner.ch wrote:
> 
>> Am 2014-09-25 11:07, schrieb Shawn Guo:
>>> On Thu, Sep 25, 2014 at 09:00:41AM +0200, Stefan Agner wrote:
>>>> Am 2014-09-25 04:47, schrieb Shawn Guo:
>>>>> On Tue, Sep 23, 2014 at 07:37:54PM +0200, Stefan Agner wrote:
> 
>>>>>> Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
>>>>>> This is needed since direction configuration is not part of the
>>>>>> GPIO module in Vybrid.
>>>>>>
>>>>>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>>>>>> ---
> 
> [snip]
> 
>>>>>> +	reg = readl(ipctl->base + pin_reg->mux_reg);
>>>>>> +	reg &= ~(0x7 << 20);
>>>>>> +	writel(reg, ipctl->base + pin_reg->mux_reg);
> 
>>>>> Isn't this setup redundant at all, since imx_pmx_enable() already
>>>>> takes care of setting mux register including GPIO mode?
> 
>>>> Yes currently this is redundant, when a pinmux is actually
>>>> applied. What is the expected behaviour? Is a explicit pinmux
>>>> necessary before we can use GPIO? If not, maybe it would make more
>>>> sense to use imx_pmx_enable here to write all pinctrl settings?
> 
>>> Okay, as per Documentation/pinctrl.txt, it's required that GPIO and
>>> PINCTRL can be used as orthogonal.  That said, your code does the
>>> right thing.  Sorry for the noisy comment.
> 
>> I'm happy you came up with this, since its the thing which I'm must
>> unsure whether this is right.
> 
>> Right now, if you just export a random pin (which has no pinmux
>> configured in dt), you get an error since this function fails (mux_reg
>> == -1). But I guess we can't avoid it, we need the pinctrl framework
>> to have a valid setting before we fiddle around with the pad.
> 
>> But now, if there is a pinmux configuration in dt, but its not applied
>> (using pinctrl-0 = ...), the export will succeed, however the GPIO
>> will not really be usable since no sane pad configuration is not
>> applied (input/output buffer disabled, no drive-strength)... So we
>> might well just don't change the mux here too.
> 
>> IMHO, fully orthogonal is not possible, since on Vybrid those two
>> depend on each other. But in order to make it "more orthogonal", we
>> maybe should force applying the full configuration in
>> imx_pmx_gpio_request_enable (e.g. drive strenght etc), rather then
>> only mux the pad to to GPIO...
> 
>> What do you think?
> 
> The muxing must have been done, that is correct.  However, this could be
> by a boot loader, by some other API, etc.  People maybe concerned about
> Linux affecting 'CAN' (or some 'mission critical' pins) muxing for
> instance, but want the A5 to handle GPIO.
> 
> If somewhere, somehow the pin was muxed properly and the GPIO code still
> works, I believe this is a win.  I see that this flexibility makes it
> more difficult to get something that just works.  I think the device
> trees take care of this for normal users.  It might be appropriate to
> add a DT node that sets 'GPIO_CONTROL' and put a note in the DT-GPIO
> document, that pinctrl is needed for a normal case or if some external
> muxing is used or not needed, then 'control=false' can be set (or
> whatever good DT terminology)?  Then the 'GPIO_CONTROL' check would be
> in the 'vf610_gpio_direction_input()' functions.  The 'pinctrl'
> functions are currently compiled to stubs if that is configured out.

Currently pinctrl is not optional for Vybrid (Kconfig mandates pinctrl
by "select PINCTRL_VF610").

IMHO there is no real value having a way to mark a pin as "muxed
externally" (control=false). If we use a pin, we should configure and
mux that properly in Linux, and if we don't have valid configuration/mux
information, we should not touch that pin. 

In v2 of this patchset, the GPIO code only worked when there _is_ a
pinctrl entry for that GPIO pin in the DT. This is because I need the
register offset, which is provided by the entry itself. But the pad
configuration is another point, which I did not consider in v2. But in
v3, the GPIO code also writes the pad control.

So it was never possible to just use the GPIO driver for any pin, even
that pin was correctly muxed and configured externally. And, especially
on Vybrid, I think this is a good thing, since the pin could be used by
the M4 core. One has to have at least a proper entry in the device tree.
And in v3, I also check that this entry represents a valid GPIO mux
(VF610_PAD_*GPIO*).

IMHO with v3 we have a quite good and safe solution:
- Using pins as GPIO needs a valid DT entry
- Using that pin only requires exporting the pin, all
configuration/muxing get applied by imx_pmx_gpio_request_enable


> Then there is 'multi-machine' support with DT and compile time selects
> with CONFIG_PINCTRL and I don't think there is a lot of additional code
> or confusion?

I don't understand that.

--
Stefan
