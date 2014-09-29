Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665AbaI2RZ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 13:25:28 -0400
Received: from mail.kmu-office.ch ([178.209.48.102]:33941 "EHLO
	mail.kmu-office.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752177AbaI2RZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 13:25:24 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: 7bit
Date: Mon, 29 Sep 2014 19:25:18 +0200
From: Stefan Agner <stefan@agner.ch>
To: Bill Pringlemeir <bpringlemeir@nbsps.com>
Cc: Shawn Guo <shawn.guo@freescale.com>, linus.walleij@linaro.org,
        gnurou@gmail.com, kernel@pengutronix.de, linux-gpio@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/5] pinctrl: imx: add gpio pinmux support for vf610
In-Reply-To: <87sijaeab6.fsf@nbsps.com>
References: <cover.1411492954.git.stefan@agner.ch>
 <bb68d2360314158cd8ccb9c6794877c3bb45d72e.1411492954.git.stefan@agner.ch>
 <20140925024712.GB6405@dragon> <1d3735aff5e0961c43d349d673a1c2b2@agner.ch>
 <20140925090714.GH6405@dragon> <26008fa68a3eaf5f806a7dc4df48f77e@agner.ch>
 <877g0rlkh3.fsf@nbsps.com> <e9ddcd256056187ffea0b05b7b31c1a6@agner.ch>
 <87sijaeab6.fsf@nbsps.com>
Message-ID: <3bdbe13465f857fe29248c0fdfd54019@agner.ch>
User-Agent: Roundcube Webmail/1.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 2014-09-29 17:05, schrieb Bill Pringlemeir:
>>> On 25 Sep 2014, stefan@agner.ch wrote:
> 
>>>> IMHO, fully orthogonal is not possible, since on Vybrid those two
>>>> depend on each other. But in order to make it "more orthogonal", we
>>>> maybe should force applying the full configuration in
>>>> imx_pmx_gpio_request_enable (e.g. drive strenght etc), rather then
>>>> only mux the pad to to GPIO...
>>>> What do you think?
> 
>> Am 2014-09-25 18:43, schrieb Bill Pringlemeir:
> 
>>> The muxing must have been done, that is correct.  However, this could
>>> be by a boot loader, by some other API, etc.  People maybe concerned
>>> about Linux affecting 'CAN' (or some 'mission critical' pins) muxing
>>> for instance, but want the A5 to handle GPIO.
>>>
>>> If somewhere, somehow the pin was muxed properly and the GPIO code
>>> still works, I believe this is a win.  I see that this flexibility
>>> makes it more difficult to get something that just works.  I think
>>> the device trees take care of this for normal users.  It might be
>>> appropriate to add a DT node that sets 'GPIO_CONTROL' and put a note
>>> in the DT-GPIO document, that pinctrl is needed for a normal case or
>>> if some external muxing is used or not needed, then 'control=false'
>>> can be set (or whatever good DT terminology)?  Then the
>>> 'GPIO_CONTROL' check would be in the 'vf610_gpio_direction_input()'
>>> functions.  The 'pinctrl' functions are currently compiled to stubs
>>> if that is configured out.
> 
> On 26 Sep 2014, stefan@agner.ch wrote:
> 
>> Currently pinctrl is not optional for Vybrid (Kconfig mandates pinctrl
>> by "select PINCTRL_VF610").
> 
>> IMHO there is no real value having a way to mark a pin as "muxed
>> externally" (control=false). If we use a pin, we should configure and
>> mux that properly in Linux, and if we don't have valid
>> configuration/mux information, we should not touch that pin.
> 
> I didn't mean per-pin, I meant for the GPIO controller as a whole.  I
> was also looking at a IOMUX controlled by the M4 and/or a boot loader.
> I agree it is not possible with the mainline.  This just makes it even
> less possible.  This is great if we know we are going that route.

Ok, but this patch doesn't make it less possible then before: You can
disable the GPIO driver or disable all gpio device tree entries.

> 
>> In v2 of this patchset, the GPIO code only worked when there _is_ a
>> pinctrl entry for that GPIO pin in the DT. This is because I need the
>> register offset, which is provided by the entry itself. But the pad
>> configuration is another point, which I did not consider in v2. But in
>> v3, the GPIO code also writes the pad control.
> 
> I was a little concerned about this as the pin may have pull-ups and
> pull-downs.  We would not want to dynamically change this.  However, I
> don't fully understand this path.
> 
> [snip]
> 
>>> Then there is 'multi-machine' support with DT and compile time
>>> selects with CONFIG_PINCTRL and I don't think there is a lot of
>>> additional code or confusion?
> 
>> I don't understand that.
> 
> I was thinking of a modified Vybrid which would allow us to not select
> PINCTRL.  As per Shawn's comment, it is suppose to be
> optional/orthogonal to the GPIO controller.  If someone made the change
> to not select PINCTRL_VF610, then the GPIO code calls would currently
> compile to stubs.  To get the same things with a multi-machine
> (Vybrid/Imx with/without pinctrl), then you could use the DT property
> which would avoid the pinctrl calls.

Now I understand, you mean a kernel with PINCTRL support but having an
option to still disable the pinctrl functionality for Vybrids GPIOs.

I think if you descide to use a pin as GPIO from Linux on A5, you also
want that pin to be "pinctrl"ed by Linux. I don't see a reason why you
want a pin configured by something else (bootloader or firmware on M4),
but then use that same pin as GPIO from Linux. IMHO, it's good to get
this as a package (GPIO which does pinctrl).

In the IOMUXC module each pin has its own register, so here it's ok to
have multiple sytems fiddling with it, as long as the systems are not
touching the same pins at the same time.

> The more required modules we require for each feature, the harder it is
> to partition the AIPS peripherals between cores.  It sort of makes the
> mainline Linux only useful for the VF5xx non-secure parts.

I agree, having the option to partition AIPS peripherals is useful,
especially on Vybrid (and i.MX6SX). And this is perfectly possible with
device tree. Just disable the gpio device tree sections (which are
compatible = "fsl,vf610-gpio") which you don't plan to use on Linux.
Linux creates 5 instances of the driver when all 5 gpio device tree
entries are active. However, you can create a board file with only one
gpio section, and you get only one instance of the driver which takes
care of the associated 32 pins. Or even no gpio device tree sections at
all, and you have the same situation before this driver was merged...
However, sub GPIO/PORT bank partitioning is not possible... The PORT and
GPIO module have shared register for 32 pins, and some operation might
not be atomic, so locking would be required. Having two system accessing
the same PORT/GPIO bank would certainly impose problems, for instance
when handling a PORT interrupt.


> I guess another option is to make another pinctrl module for the Vybrid
> which uses some inter-core communications to alter the MUX
> configuration.  This makes sense for the pinctrl and the CCM/clock
> modules.  Each and every driver depends on them, so it is probably good
> for sanity to require that Linux has some version of these modules.  If
> the 'M4' was to control the pins and/or clock, then some other modules
> could be written that makes some calls to that CPU (or world).

I also have some M4 firmwares running (eCos, bare-metal), and usually we
just let them access the CCM in a "read-only" mode. It works fairly
well, however I agree this solution is not perfect. The hardware
designers gave us hardware semaphores and CPU to CPU interrupts, so we
could build a configuration interface (and maybe a resource allocation
as well) around this. This would then implicate an ABI, and this
certainly would need some time and discussion to make it good enough for
mainline, if possible at all.

> For other AIPS peripherals, it would be nice if they could be either
> configured out and/or set to disabled by the device tree.

Agreed, we should do this as much as possible for Vybrid. 

--
Stefan

