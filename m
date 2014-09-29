Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428AbaI2PFi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 11:05:38 -0400
Received: from 71-19-161-253.dedicated.allstream.net ([71.19.161.253]:60961
	"EHLO nsa.nbspaymentsolutions.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751913AbaI2PFh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 11:05:37 -0400
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
	<26008fa68a3eaf5f806a7dc4df48f77e@agner.ch> <877g0rlkh3.fsf@nbsps.com>
	<e9ddcd256056187ffea0b05b7b31c1a6@agner.ch>
Date: Mon, 29 Sep 2014 11:05:49 -0400
Message-ID: <87sijaeab6.fsf@nbsps.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> On 25 Sep 2014, stefan@agner.ch wrote:

>>> IMHO, fully orthogonal is not possible, since on Vybrid those two
>>> depend on each other. But in order to make it "more orthogonal", we
>>> maybe should force applying the full configuration in
>>> imx_pmx_gpio_request_enable (e.g. drive strenght etc), rather then
>>> only mux the pad to to GPIO...
>>> What do you think?

> Am 2014-09-25 18:43, schrieb Bill Pringlemeir:

>> The muxing must have been done, that is correct.  However, this could
>> be by a boot loader, by some other API, etc.  People maybe concerned
>> about Linux affecting 'CAN' (or some 'mission critical' pins) muxing
>> for instance, but want the A5 to handle GPIO.
>>
>> If somewhere, somehow the pin was muxed properly and the GPIO code
>> still works, I believe this is a win.  I see that this flexibility
>> makes it more difficult to get something that just works.  I think
>> the device trees take care of this for normal users.  It might be
>> appropriate to add a DT node that sets 'GPIO_CONTROL' and put a note
>> in the DT-GPIO document, that pinctrl is needed for a normal case or
>> if some external muxing is used or not needed, then 'control=false'
>> can be set (or whatever good DT terminology)?  Then the
>> 'GPIO_CONTROL' check would be in the 'vf610_gpio_direction_input()'
>> functions.  The 'pinctrl' functions are currently compiled to stubs
>> if that is configured out.

On 26 Sep 2014, stefan@agner.ch wrote:

> Currently pinctrl is not optional for Vybrid (Kconfig mandates pinctrl
> by "select PINCTRL_VF610").

> IMHO there is no real value having a way to mark a pin as "muxed
> externally" (control=false). If we use a pin, we should configure and
> mux that properly in Linux, and if we don't have valid
> configuration/mux information, we should not touch that pin.

I didn't mean per-pin, I meant for the GPIO controller as a whole.  I
was also looking at a IOMUX controlled by the M4 and/or a boot loader.
I agree it is not possible with the mainline.  This just makes it even
less possible.  This is great if we know we are going that route.

> In v2 of this patchset, the GPIO code only worked when there _is_ a
> pinctrl entry for that GPIO pin in the DT. This is because I need the
> register offset, which is provided by the entry itself. But the pad
> configuration is another point, which I did not consider in v2. But in
> v3, the GPIO code also writes the pad control.

I was a little concerned about this as the pin may have pull-ups and
pull-downs.  We would not want to dynamically change this.  However, I
don't fully understand this path.

[snip]

>> Then there is 'multi-machine' support with DT and compile time
>> selects with CONFIG_PINCTRL and I don't think there is a lot of
>> additional code or confusion?

> I don't understand that.

I was thinking of a modified Vybrid which would allow us to not select
PINCTRL.  As per Shawn's comment, it is suppose to be
optional/orthogonal to the GPIO controller.  If someone made the change
to not select PINCTRL_VF610, then the GPIO code calls would currently
compile to stubs.  To get the same things with a multi-machine
(Vybrid/Imx with/without pinctrl), then you could use the DT property
which would avoid the pinctrl calls.

The more required modules we require for each feature, the harder it is
to partition the AIPS peripherals between cores.  It sort of makes the
mainline Linux only useful for the VF5xx non-secure parts.

I guess another option is to make another pinctrl module for the Vybrid
which uses some inter-core communications to alter the MUX
configuration.  This makes sense for the pinctrl and the CCM/clock
modules.  Each and every driver depends on them, so it is probably good
for sanity to require that Linux has some version of these modules.  If
the 'M4' was to control the pins and/or clock, then some other modules
could be written that makes some calls to that CPU (or world).

For other AIPS peripherals, it would be nice if they could be either
configured out and/or set to disabled by the device tree.

Regards,
Bill Pringlemeir.
