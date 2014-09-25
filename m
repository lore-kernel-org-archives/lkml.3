Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbaIYQn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:43:29 -0400
Received: from 71-19-161-253.dedicated.allstream.net ([71.19.161.253]:50816
	"EHLO nsa.nbspaymentsolutions.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752585AbaIYQn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:43:28 -0400
From: Bill Pringlemeir <bpringlemeir@nbsps.com>
To: Stefan Agner <stefan@agner.ch>
Cc: Shawn Guo <shawn.guo@freescale.com>, linus.walleij@linaro.org,
        gnurou@gmail.com, kernel@pengutronix.de, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] pinctrl: imx: add gpio pinmux support for vf610
Organization: NBS Payment Solutions
References: <cover.1411492954.git.stefan@agner.ch>
	<bb68d2360314158cd8ccb9c6794877c3bb45d72e.1411492954.git.stefan@agner.ch>
	<20140925024712.GB6405@dragon>
	<1d3735aff5e0961c43d349d673a1c2b2@agner.ch>
	<20140925090714.GH6405@dragon>
	<26008fa68a3eaf5f806a7dc4df48f77e@agner.ch>
Date: Thu, 25 Sep 2014 12:43:04 -0400
In-Reply-To: <26008fa68a3eaf5f806a7dc4df48f77e@agner.ch> (Stefan Agner's
	message of "Thu, 25 Sep 2014 11:36:48 +0200")
Message-ID: <877g0rlkh3.fsf@nbsps.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25 Sep 2014, stefan@agner.ch wrote:

> Am 2014-09-25 11:07, schrieb Shawn Guo:
>> On Thu, Sep 25, 2014 at 09:00:41AM +0200, Stefan Agner wrote:
>>> Am 2014-09-25 04:47, schrieb Shawn Guo:
>>>> On Tue, Sep 23, 2014 at 07:37:54PM +0200, Stefan Agner wrote:

>>>>> Add pinmux support for GPIO for Vybrid (vf610) IOMUX controller.
>>>>> This is needed since direction configuration is not part of the
>>>>> GPIO module in Vybrid.
>>>>>
>>>>> Signed-off-by: Stefan Agner <stefan@agner.ch>
>>>>> ---

[snip]

>>>>> +	reg = readl(ipctl->base + pin_reg->mux_reg);
>>>>> +	reg &= ~(0x7 << 20);
>>>>> +	writel(reg, ipctl->base + pin_reg->mux_reg);

>>>> Isn't this setup redundant at all, since imx_pmx_enable() already
>>>> takes care of setting mux register including GPIO mode?

>>> Yes currently this is redundant, when a pinmux is actually
>>> applied. What is the expected behaviour? Is a explicit pinmux
>>> necessary before we can use GPIO? If not, maybe it would make more
>>> sense to use imx_pmx_enable here to write all pinctrl settings?

>> Okay, as per Documentation/pinctrl.txt, it's required that GPIO and
>> PINCTRL can be used as orthogonal.  That said, your code does the
>> right thing.  Sorry for the noisy comment.

> I'm happy you came up with this, since its the thing which I'm must
> unsure whether this is right.

> Right now, if you just export a random pin (which has no pinmux
> configured in dt), you get an error since this function fails (mux_reg
> == -1). But I guess we can't avoid it, we need the pinctrl framework
> to have a valid setting before we fiddle around with the pad.

> But now, if there is a pinmux configuration in dt, but its not applied
> (using pinctrl-0 = ...), the export will succeed, however the GPIO
> will not really be usable since no sane pad configuration is not
> applied (input/output buffer disabled, no drive-strength)... So we
> might well just don't change the mux here too.

> IMHO, fully orthogonal is not possible, since on Vybrid those two
> depend on each other. But in order to make it "more orthogonal", we
> maybe should force applying the full configuration in
> imx_pmx_gpio_request_enable (e.g. drive strenght etc), rather then
> only mux the pad to to GPIO...

> What do you think?

The muxing must have been done, that is correct.  However, this could be
by a boot loader, by some other API, etc.  People maybe concerned about
Linux affecting 'CAN' (or some 'mission critical' pins) muxing for
instance, but want the A5 to handle GPIO.

If somewhere, somehow the pin was muxed properly and the GPIO code still
works, I believe this is a win.  I see that this flexibility makes it
more difficult to get something that just works.  I think the device
trees take care of this for normal users.  It might be appropriate to
add a DT node that sets 'GPIO_CONTROL' and put a note in the DT-GPIO
document, that pinctrl is needed for a normal case or if some external
muxing is used or not needed, then 'control=false' can be set (or
whatever good DT terminology)?  Then the 'GPIO_CONTROL' check would be
in the 'vf610_gpio_direction_input()' functions.  The 'pinctrl'
functions are currently compiled to stubs if that is configured out.

Then there is 'multi-machine' support with DT and compile time selects
with CONFIG_PINCTRL and I don't think there is a lot of additional code
or confusion?

Fwiw,
Bill Pringlemeir.
