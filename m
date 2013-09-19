Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3ISMHv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:07:51 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:55613 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab3ISMHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:07:33 -0400
Message-ID: <523AE8FF.9020209@ti.com>
Date: Thu, 19 Sep 2013 07:07:27 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: George Cherian <george.cherian@ti.com>, <balbi@ti.com>
CC: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: PCF857x and 16-bit GPIO expanders
References: <20130917190732.GD15645@radagast> <CACRpkdYn8yaTyFJMaC3vK4kGrQsaZpAX=pyn5y33ers7QhQ_pg@mail.gmail.com> <2356541.62QktiIBr5@avalon> <20130918173636.GT21559@radagast> <523AB235.1000808@ti.com>
In-Reply-To: <523AB235.1000808@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/19/2013 03:13 AM, George Cherian wrote:
> On 9/18/2013 11:06 PM, Felipe Balbi wrote:
>> Hi,
>>
>> On Wed, Sep 18, 2013 at 07:18:04PM +0200, Laurent Pinchart wrote:
>>> On Wednesday 18 September 2013 13:16:27 Linus Walleij wrote:
>>>> On Tue, Sep 17, 2013 at 9:07 PM, Felipe Balbi <balbi@ti.com> wrote:
>>>>> has anyone ever successfully using gpio-pcf857x.c driver with 16-bit
>>>>> gpio expanders ? We're having some issues here where toggling the last
>>>>> gpio pin (gpio 15) on a PCF8575 device causes platform to hang and I
>>>>> can't come up with any explanation of why would it hang...
>>>> Bouncing the question to George, Laurent and Kuninori...
>>> I've got a board with a PCF8575 chip, but it uses I/Os 8 to 14 only as far as
>>> I know.
>>>
>>> I can try toggling I/O 15, but that will need to wait until next week as I'm
>>> currently travelling without access to the hardware.
>> alright, that'd help me a lot :-) Just want to make sure if we're having
>> a board issue, or PCF8575 is a bit screwy ;-)
> Is it on dra7x-evm if so which pcf device (i2c address)?
> The pins i were interested were only 1 and 2 I never tried pin 15.
> 
> Just tried toggling through sysfs and it works for me.
When I look at the data sheet for PCF8575[1] Page 7, Figure 4 Write
mode (output)
I see the data writes are of the order:
I2c 1's byte: address
I2c 2'nd byte:P[7-0]
I2c 3rd byte:P[17-10]
Note: bits 8,9 are missing not supported.

Now [2] claims that it does support PCF8575, however when I look at
line 143[3]
	unsigned	bit = 1 << offset;
[snip]
	if (value)
		gpio->out |= bit;
	else
		gpio->out &= ~bit;

There is no handling for the skip needed for bits 8 and 9.. Seems to
me like a driver bug.

[1] http://www.ti.com/lit/ds/symlink/pcf8575.pdf
[2]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/gpio/gpio-pcf857x.c
[3]
http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/drivers/gpio/gpio-pcf857x.c#n143
-- 
Regards,
Nishanth Menon
