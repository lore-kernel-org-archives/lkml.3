Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaKFTBU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 14:01:20 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:48877 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaKFTBT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 14:01:19 -0500
Message-ID: <545BC583.407@wwwdotorg.org>
Date: Thu, 06 Nov 2014 12:01:23 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Matthias Klein <matthias.klein@linux.com>
CC: linux-rpi-kernel@lists.infradead.org, lee@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: bcm2835: add device tree for Raspberry Pi model
 B+
References: <1415231123-920-1-git-send-email-matthias.klein@linux.com> <545B071E.7090007@wwwdotorg.org> <545BBAA4.90407@linux.com>
In-Reply-To: <545BBAA4.90407@linux.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2014 11:15 AM, Matthias Klein wrote:
>
> Am 06.11.2014 um 06:29 schrieb Stephen Warren:
>> I guess we should have separate device trees for those, since there are
>> some differences in the GPIO and I2C channel usage. That'd leave us with:
>>
>> bcm2835-rpi-b.dts (Pin3=GPIO0, Pin5=GPIO1, Pin13=GPIO21, I2C-0)
>> bcm2835-rpi-b-rev2.dts (Pin3=GPIO1, Pin5=GPIO2, Pin13=GPIO27, 12C-1)
 >
> I think for these differences separate device trees are not needed.
> These pins are all at the moment configured as ALT0.Both I2C buses are
> configured for I2C,
> therefore I doesn't matter which one is wired to the gpio header.

At the moment perhaps there's not a lot of difference between the board. 
However, e.g. the board ID pins on the early boards are connected to 
pull-up/down resistors, and hence could be represented in DT as specific 
named GPIOs or not, depending on whether the board has board ID pins. 
Similarly, we should only enable the I2C controllers on a particular 
board if there's any possibility of a user connecting something, which 
is only true if that particular I2C controller is routed to an IO 
connector (or on-board device).

> But for clarity it would be better to have a separate device tree for
> each model.

So yes, I think we should move to separate DTs for each incompatible 
model, so that if/when we actually want to make the DT content different 
between them, we already have separate DTs in place to do that. That 
will allow use to update any bootloaders to choose the right DT now, 
rather than right when we really need it done already:-)

> When a gpio signal (which is configured in device tree as ALT0) is used
> as e.g. plain gpio output, does the kernel the reconfiguration from ALT0
> to gpio output?

IIRC, the kernel GPIO driver sets the pinmux to GPIOin/GPIOout based on 
gpio_request() calls.

> Or must the gpio signal be configured as output in the device tree?

It doens't have to be. That said, if we *know* that a particular GPIO is 
used as a GPIO rather than a special function, there's probably no harm 
just putting that setting right into the DT.

> Is is possible to set at the brcm,function/brcm,pins gpio definition
> also the voltage level of an gpio output for e.g. the LAN_RUN signal?

No. The value on a GPIO pin can only be selected by code. For pins such 
as LAN_RUN that don't have code controlling them, you can get away with 
setting the pin as input/tri-state with a pull-up/pull-down to get the 
desired state.

> How do we want to continue?
> Is my patch OK, or should I try to write a device tree for every model
> where every gpio signal is defined?

I think the patch is fine for now; my thoughts were more about the need 
to send additional patches to add more DTs later.
