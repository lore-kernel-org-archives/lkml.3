Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab3EATke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 May 2013 15:40:34 -0400
Received: from casper.infradead.org ([85.118.1.10]:56202 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757081Ab3EATk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 May 2013 15:40:27 -0400
Message-ID: <51816F8D.80607@infradead.org>
Date: Wed, 01 May 2013 12:39:57 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: simon@mungewell.org
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH -next] hid: fix hid-steelseries kconfig/build
References: <20130501183734.7ad1efca2d06e75432edabbd@canb.auug.org.au>    <51816271.3040400@infradead.org> <c23b45b45b6a27055cdf18fe4dbc6309.squirrel@www.mungewell.org>
In-Reply-To: <c23b45b45b6a27055cdf18fe4dbc6309.squirrel@www.mungewell.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/01/13 12:27, simon@mungewell.org wrote:
> Hi Randy and all,
> Seems like you found a problem... but the relevant sections of
> 'hid-steelseries.c' already have
> --
> #if defined(CONFIG_LEDS_CLASS) || defined(CONFIG_LEDS_CLASS_MODULE)

which should be replaced with:

#include <linux/kconfig.h>

#if IS_ENABLED(LEDS_CLASS)


> ...
> #endif
> --
> 
> Shouldn't this prevent the module having calls to register/unregister if
> the LED_CLASS is not enabled?

Please read the patch description.  CONFIG_LEDS_CLASS=m but CONFIG_HID_STEELSEREIS=y.
A builtin driver cannot make calls to a modular driver if the modular driver
is not loaded.  Is there a way to require that the modular driver is loaded
for hid-steelseries?  Maybe so, but I don't know.


> Does forcing a 'depends on LED_CLASS' in Kconfig prevent the
> hid-steelseries module being built on systems without LEDs, or is this
> simply a way to ensure that the LED_CLASS module gets loaded first?

It prevents the driver from being built.  I think that a satisfactory solution
would be this small change:

	depends on LEDS_CLASS || LEDS_CLASS=n

That makes HID_STEELSERIES depend on LEDS_CLASS when it is enabled but still
allows the driver to build when LEDS_CLASS=n.  Makes sense?



Oh, and please don't top-post.

Thanks.

> 
> Simon.
> 
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix hid-steelseries build by making it depends on LEDS_CLASS.
>> Build errors happen when LEDS_CLASS=m  and HID_STEELSERIES=y.
>>
>> drivers/built-in.o: In function `steelseries_srws1_remove':
>> hid-steelseries.c:(.text+0x3b97a1): undefined reference to
>> `led_classdev_unregister'
>> drivers/built-in.o: In function `steelseries_srws1_probe':
>> hid-steelseries.c:(.text+0x3b9c51): undefined reference to
>> `led_classdev_register'
>> hid-steelseries.c:(.text+0x3b9ce5): undefined reference to
>> `led_classdev_register'
>> hid-steelseries.c:(.text+0x3b9d4b): undefined reference to
>> `led_classdev_unregister'
>>
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> ---
>>  drivers/hid/Kconfig |    1 +
>>  1 file changed, 1 insertion(+)
>>
>> --- linux-next-20130501.orig/drivers/hid/Kconfig
>> +++ linux-next-20130501/drivers/hid/Kconfig
>> @@ -610,6 +610,7 @@ config HID_SPEEDLINK
>>  config HID_STEELSERIES
>>  	tristate "Steelseries SRW-S1 steering wheel support"
>>  	depends on HID
>> +	depends on LEDS_CLASS
>>  	---help---
>>  	Support for Steelseries SRW-S1 steering wheel
>>
>> --


-- 
~Randy
