Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3G2WIt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 18:08:49 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37142 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab3G2WIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 18:08:48 -0400
Message-ID: <51F6E7EC.4000402@wwwdotorg.org>
Date: Mon, 29 Jul 2013 16:08:44 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: linus.walleij@linaro.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 3/4] pinctrl: Add support for additional dynamic states
References: <20130716090310.5541.36777.stgit@localhost> <20130716090536.5541.36289.stgit@localhost> <51E70B5D.6030802@wwwdotorg.org> <20130718073638.GP7656@atomide.com> <51E84180.6080902@wwwdotorg.org> <20130719073957.GZ7656@atomide.com> <51E98C71.5010709@wwwdotorg.org> <20130729092116.GA7656@atomide.com>
In-Reply-To: <20130729092116.GA7656@atomide.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2013 03:21 AM, Tony Lindgren wrote:
> * Stephen Warren <swarren@wwwdotorg.org> [130719 12:05]:
>> On 07/19/2013 01:39 AM, Tony Lindgren wrote:
>>>
>>> I think the only sane way to deal with this is to make the I2C controller
>>> to show up as two separate I2C controller instances. Then use runtime
>>> PM to save and restore the state for each instance, and locking between
>>> the two driver instances.
>>>
>>> For the pin muxing part, I'd do this:
>>>
>>> 			i2c1 instance	i2c2 instance	notes
>>> default_state		0 pins		0 pins		(or dedicated pins only)
>>> active_state		all pins	alls pins
>>> idle_state		safe mode	safe mode
>>>
>>> Then when i2c1 instance is done, it's runtime PM suspend muxes the pins
>>> to safe mode, or some nop state. Then when i2c2 instance is woken, it's
>>> runtime PM resume muxes pins to i2c2.
>>
>> I see two issues with that approach:
>>
>> 1) Runtime PM doesn't always put a device into an idle state as soon as
>> its work is done. Sometimes (always?) there is a delay between when the
>> device is last used and when the HW is actually made idle so that if the
>> device is re-activated quickly, the kernel hasn't wasted time making it
>> idle then active again. You'd have to force that delay to complete when
>> switching between the two virtual controller devices.
> 
> There is the autosuspend timeout for delayed transitions, but I think
> runtime PM already has calls for making the state change immediate also.

True, but I /think/ that then you could never use the APIs that perform
delayed idle, since you'd always need to force immediate idle to
guarantee you could always immediately switch to the other
state/virtual-controller.

>> 2) This requires two separate device objects for the two I2C instances.
>> I guess you could have the driver for the one I2C mux node end up
>> instantiating two child devices for this purpose, and hence make that
>> happen without needing to change the DT ABI. However, that sure feels
>> complex...
> 
> Yes but you will also automatically get quite a bit of sanity to your
> I2C driver code rather than trying to handle the two separate instances
> within the driver alone. Consider things like scanning the I2C buses for
> devices and just dev_dbg().

The I2C mux is already very simple. IIRC, it instantiates a separate
"struct i2c_adapter" for each "virtual" I2C controller. It actually
looks like each of those already embeds its own "struct device", so
perhaps this issue is a little moot. However, we'd have to find some way
of redirecting pinctrl requests from those child devices to the
top-level I2C mux struct device itself, since that's what the pinctrl
mapping table entries are defined for. It seems much simpler to just
leave the pinctrl stuff controlled by that top-level device, rather than
pushing it down to the child virtual devices/adapters.
