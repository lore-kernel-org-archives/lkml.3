Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756944Ab3JJS55 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 14:57:57 -0400
Received: from mailhost.informatik.uni-hamburg.de ([134.100.9.70]:37257 "EHLO
	mailhost.informatik.uni-hamburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756102Ab3JJS5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 14:57:55 -0400
Message-ID: <5256F8DF.2020801@metafoo.de>
Date: Thu, 10 Oct 2013 20:58:39 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130827 Icedove/17.0.8
MIME-Version: 1.0
To: "Dr. H. Nikolaus Schaller" <hns@goldelico.com>
CC: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Marek Belisko <marek@goldelico.com>, plagnioj@jcrosoft.com,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] omapdss: Add new panel driver for Topolly td028ttec1
 LCD.
References: <1381352915-17219-1-git-send-email-marek@goldelico.com> <525662F5.3090600@ti.com> <7FAC77D4-5E1E-4B11-B067-3A8233C69240@goldelico.com> <52568B40.4040802@ti.com> <04AC7291-38E4-421B-979C-BF03D52E94BD@goldelico.com> <525699EF.6090803@ti.com> <52569CE8.5070201@metafoo.de> <A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com>
In-Reply-To: <A7739B52-2632-4DD8-924D-B657A6BFE3ED@goldelico.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2013 03:42 PM, Dr. H. Nikolaus Schaller wrote:
>
> Am 10.10.2013 um 14:26 schrieb Lars-Peter Clausen:
>
>> On 10/10/2013 02:13 PM, Tomi Valkeinen wrote:
>>> On 10/10/13 14:52, Dr. H. Nikolaus Schaller wrote:
>>>
>>>> Yes, I agree and I am willing to help if someone comes up with such a SoC.
>>>> At the moment we have connected it to the OMAP3 only.
>>>
>>> True, but even without that kind of SoC, SPI bitbanging should be
>>> handled by an SPI driver, not by the drivers that use the bus.
>>>
>>>> I.e. I want not to do a lot of work for others who we just guess about that they
>>>> might exist...
>>>
>>> Yep. It's fine for me, it's not that much extra code in the panel driver.
>>>
>>>>> The panel hardware has three wires, so the panel driver (if it does
>>>>> handle the bus by bitbanging) can only refer to three gpios.
>>>>
>>>> Hm. The panle hardware has 3 but the SoC (OMAP3) the driver
>>>> is running on has 4.
>>>
>>> Right, but this panel driver is a driver for the panel hardware. Not for
>>> the SoC, or the SoC+panel combination. So the panel driver must only use
>>> resources as seen by the panel hardware.
>>>
>>>>> So either
>>>>> the bus details should be hidden by using the normal spi framework, or
>>>>> if the driver does the bitbanging, use the gpios as specified in the
>>>>> panel spec. The panel driver cannot contain any board specific stuff.
>>>>
>>>> The bitbang driver shown below can handle either 3 or 4 gpios (except
>>>> for initialization).
>>>
>>> It's not a bitbang driver, it's a panel driver. And anyway, if I
>>> understood right, your use of 4 gpios was just a hack to try to make it
>>> look like a normal 4-wire SPI bus. What you really have is 3 wires, 3
>>> gpios. I don't see any reason to use 4 gpios, as two of them are the same.
>
> There is a protection resistor in the one defined as "output" so that
> protocol errors don't have two outputs work against each other.
>
>>>
>>> Hmm, how does it work anyway. Did I understand it right, the panel's
>>> 'DIN' pin is connected to two gpios on the SoC, and one of those gpios
>>> is set as output, and the other as input?
>
> Yes.
>
>>> So the SoC is always pulling
>>> that line up or down, and the panel is also pulling it up or down when
>>> it's sending data. I'm no HW guy but that sounds quite bad =).
>
> Yes, that is the strange thing with this protocol. It does a direction reversal
> after some time. I.e. the panel switches its input to output and the SoC has
> to be fast enough to do the same. Therefore, we have one output GPIO
> (protected by a resistor) and a separate input GPIO.
>
> Sometimes interfacing hardware is indeed strange.
>
>>>
>>> I've never written or studied a bitbanging driver, but shouldn't there
>>> be just one gpio used on the SoC for DIN, and it would be set to either
>>> output or input mode, depending on if we are reading or writing?
>>
>> Back in the OpenMoko days we used the panel in normal 4-wire SPI mode with
>> the GPIO bitbang SPI master. The bitbang code in this driver also looks like
>> normal 4 wire.
>
>
> Thanks for this hint!
>
> Maybe using a standard 4-wire SPI simply works if we only write data and
> make sure the panel is not sending anything...

According to the datasheet the the panel as a dedicated dout pin. Maybe you did 
not connect it in your design, which means you won't be able to read any data 
from the panel at all.

Also your custom bitbang code looks a bit strange:

	gpio_set_value(data->dout_gpio, 1);
	if (gpio_get_value(data->din_gpio) == 0)
		return 1;

You set the state on the dout pin and then read the din pin, if both do not 
match you abort with an error. This suggest that, for whatever reason, you feed 
the dout pin back into the din pin in your design. Btw. this is also the only 
place where din is used in your driver.

- Lars
