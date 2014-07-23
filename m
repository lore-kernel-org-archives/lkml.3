Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073AbaGWGVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 02:21:14 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62641 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaGWGVM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 02:21:12 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53CF5456.90503@roeck-us.net>
Date: Tue, 22 Jul 2014 23:21:10 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexandre Courbot <gnurou@gmail.com>
CC: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/5] gpio: make gpiochip_get_desc() gpiolib-private
References: <1406013463-19218-1-git-send-email-acourbot@nvidia.com> <1406013463-19218-4-git-send-email-acourbot@nvidia.com> <20140722201740.GA11459@roeck-us.net> <CAAVeFuJAudOY-s3x38sv13SNo8zfofLWKOKBhKQPYAm1fAj4kw@mail.gmail.com> <53CF305A.6080007@roeck-us.net> <CAAVeFu+fCq5e=YinNk++10oJPv8R2LeTbYV=6G95WSuw1f9_gQ@mail.gmail.com>
In-Reply-To: <CAAVeFu+fCq5e=YinNk++10oJPv8R2LeTbYV=6G95WSuw1f9_gQ@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------060204090005050701070808"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060204090005050701070808
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/22/2014 10:39 PM, Alexandre Courbot wrote:
> On Wed, Jul 23, 2014 at 12:47 PM, Guenter Roeck <linux@roeck-us.net> wrote:
>> On 07/22/2014 08:10 PM, Alexandre Courbot wrote:
>>>
>>> On Wed, Jul 23, 2014 at 5:17 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>>
>>>> On Tue, Jul 22, 2014 at 04:17:41PM +0900, Alexandre Courbot wrote:
>>>>>
>>>>> As GPIO descriptors are not going to remain unique anymore, having this
>>>>> function public is not safe. Restrain its use to gpiolib since we have
>>>>> no user outside of it.
>>>>>
>>>> If I implement a gpio chip driver built as module, and I want to use
>>>> gpiochip_request_own_desc(), how am I supposed to get desc ?
>>>>
>>>> I understand that there is still gpio_to_desc(), but I would have thought
>>>> that
>>>>           desc = gpiochip_get_desc(chip, pin);
>>>> would be better than
>>>>           desc = gpio_to_desc(chip->base + pin);
>>>>
>>>> Not that it makes much of a difference for me, just asking.
>>>
>>>
>>> Actually I was thinking of changing the prototype of
>>> gpiochip_request_own_desc(), and your comment definitely strenghtens
>>> that idea. gpiochip functions should not work with descriptors,
>>> especially since we are going to switch to a multiple-consumer scheme
>>> where there won't be any canonical descriptor anymore. Thus, how about
>>> turning gpiochip_request_own_desc() into this:
>>>
>>> struct gpio_desc *
>>> gpiochip_request_own_desc(struct gpio_chip *chip, u16 hwnum, const char
>>> *label);
>>>
>>> which would basically do both the gpiochip_get_desc() and former
>>> gpiochip_request_own_desc() in one call. I think it should satisfy
>>> everybody and removes the need to have gpiochip_get_desc() (a not very
>>> useful function by itself) exposed out of gpiolib.
>>>
>>> I will send a patch taking care of this if you agree that makes sense.
>>>
>>
>> I think you also plan to remove the capability to retrieve the chip
>> pointer, don't you ? If so, I won't be able to use the function from
>> the pca953x platform init function, since I won't be able to get the
>> pointer to the gpio chip. Even if you don't remove gpiod_to_chip(),
>> things would become a bit messy, since I would first have to convert
>> a pin to a desc and then to the chip pointer. Anyway, that change
>> would mean that exporting gpiochip_request_own_desc or its replacement
>> won't solve one of the problems addressed by my patch anymore, leaving
>> me more or less in the dark :-(.
>
> Here is why this change is taking place: right now you have a clear
> descriptor/pin mapping, i.e. there is only one descriptor per pin,
> anytime. For various reasons this is going to change soon, and
> descriptors will be allocated the provided to GPIO consumers as an
> abstraction of the pin. Meaning that you cannot really "get the
> descriptor for that pin" anymore. Since gpiochip_request_own_desc()'s
> purpose is precisely to request one descriptor for drivers to use, the
> new prototype makes much more sense IMHO.
>
> Another reason to have it work on a gpio_chip is that the gpio_chip
> pointer is a token to doing certain "priviledged" operations. Like
> obtaining an arbitrary descriptor. If consumers can get a pointer to
> the gpio_chip of a descriptor, this means they can basically do
> anything.
>
I understand, but my problem with pca953x platform initialization
is that the code to do that is outside the gpio directory in platform code.
Even though this is not consumer code, it still needs a means to perform
operations on a gpio pin, whatever those means are.

> Being in the board code, it seems to be that you are in a good
> position to obtain a pointer to the gpio_chip, and without knowing
> better I'd say that's what you should try to do. But maybe I would
> understand your problem better if you could post a small patch of what
> you want to achieve here.
>
Ok, but how do I get the pointer to the gpio chip from platform code
if gpiod_to_chip is gone ?

I attached the relevant parts of a platform file (scu.c), the one utilizing
pca953x initialization code to auto-export gpio pins. It currently uses
gpio_request_one(), which I am trying to replace. I can send you
the complete file if you like, but it is 1,600 bytes long so I figured
that would not help much.

I also attached a patch that tries to replace gpio_request_one with
gpiochip_request_own_desc in a gpio chip driver; maybe that gives
you an idea of that part of the problem.

>>
>> I was thinking about implementing a separate platform driver which
>> would enable me to auto-export (or initialize, if needed) gpio pins
>> from arbitrary gpio drivers to user space. I could make this work
>> with both devicetree data and platform data. Sure, that driver
>> would not have a chance to get accepted upstream, since it would use
>> devicetree data to, in a sense, configure the system, but on the
>> upside it would be independent of gpio API changes, and it would
>> work for _all_ gpio chips, not just for the ones with gpio driver
>> support. Unfortunately this approach doesn't really work either,
>> since exported pin names need to be configured with the chip driver,
>> and can not be selected afterwards when a pin is actually exported.
>>
>> On the other side, would you agree to adding something like
>> gpiod_export_name(), which would export a gpio pin with given name,
>> not using the default or chip->names ? That might help solving
>> at least some of my problems, and I would no longer depend on
>> gpiochip_request_own_desc or any of the related functions.
>
> Isn't that what gpiod_export_link() does?
>
This function assumes the existence of an exported pin,
and the resulting link is not in /sys/class/gpio but elsewhere.
That is not really the idea here; I did not want to create a second
export directory just for the sake of having well defined pin names
in some arbitrary place; the idea was to have those well defined
names in /sys/cass/gpio, and /sys/class/gpio is not available
as target for linking outside the gpio subsystem (if I remember
correctly because gpio_class is static and not exported).

>>
>> For reference, I currently need the ability to auto-export
>> gpio pins to user space for pca953x, ich, and for various
>> to-be-published gpio drivers used by my employer.
>
> Under which criteria are the GPIOs auto-exported? Can't you have the
> board code simply request all the GPIOs as a regular consumer and
> export them to user-space?
>

That is what the above mentioned platform driver would do. On x86 it
would use platform data for the purpose of identifying to-be-exported
pins, on devicetree platforms it would use devicetree data.

Thanks,
Guenter



--------------060204090005050701070808
Content-Type: text/plain; charset=UTF-8;
 name="patch.sam"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="patch.sam"

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3Bpby9ncGlvLXNhbS5jIGIvZHJpdmVycy9ncGlvL2dw
aW8tc2FtLmMKaW5kZXggNjJjZWE0OC4uNGQ1OTA1OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9n
cGlvL2dwaW8tc2FtLmMKKysrIGIvZHJpdmVycy9ncGlvL2dwaW8tc2FtLmMKQEAgLTI1LDYg
KzI1LDggQEAKICNpbmNsdWRlIDxsaW51eC9zY2hlZC5oPgogI2luY2x1ZGUgPGxpbnV4L21m
ZC9zYW0uaD4KIAorI2luY2x1ZGUgImdwaW9saWIuaCIKKwogLyogZ3BpbyBzdGF0dXMvY29u
ZmlndXJhdGlvbiAqLwogI2RlZmluZSBTQU1fR1BJT19ORUdfRURHRQkoMSA8PCA4KQogI2Rl
ZmluZSBTQU1fR1BJT19ORUdfRURHRV9FTgkoMSA8PCA3KQpAQCAtMTY2LDE0ICsxNjgsNyBA
QCBzdGF0aWMgdm9pZCBzYW1fZ3Bpb19zZXR1cChzdHJ1Y3Qgc2FtX2dwaW8gKnNhbSkKIAog
CWNoaXAtPmRldiA9IHNhbS0+ZGV2OwogCWNoaXAtPmxhYmVsID0gZGV2X25hbWUoc2FtLT5k
ZXYpOwotCS8qCi0JICogU2V0dGluZyB0aGUgb3duZXIgcmVzdWx0cyBpbiB0aGUgbW9kdWxl
IGJlaW5nIGxvY2tlZAotCSAqIGludG8gdGhlIGtlcm5lbCBpZiBncGlvIHBpbnMgYXJlIGF1
dG8tZXhwb3J0ZWQuCi0JICogRG9uJ3Qgc2V0IHRoZSBncGlvIGNoaXAgb3duZXIgdW50aWwg
d2UgZmluZCBhIGJldHRlcgotCSAqIHNvbHV0aW9uLgotCSAqCi0JICogY2hpcC0+b3duZXIg
PSBUSElTX01PRFVMRTsKLQkgKi8KKwljaGlwLT5vd25lciA9IFRISVNfTU9EVUxFOwogCWNo
aXAtPmRpcmVjdGlvbl9pbnB1dCA9IHNhbV9ncGlvX2RpcmVjdGlvbl9pbnB1dDsKIAljaGlw
LT5nZXQgPSBzYW1fZ3Bpb19nZXQ7CiAJY2hpcC0+ZGlyZWN0aW9uX291dHB1dCA9IHNhbV9n
cGlvX2RpcmVjdGlvbl9vdXRwdXQ7CkBAIC01NjQsMTAgKzU1OSw5IEBAIHN0YXRpYyBpbnQg
c2FtX2dwaW9fdW5leHBvcnQoc3RydWN0IHNhbV9ncGlvICpzYW0pCiAKIAkvKiB1bi1leHBv
cnQgYWxsIGF1dG8tZXhwb3J0ZWQgcGlucyAqLwogCWZvciAoaSA9IDA7IGkgPCBzYW0tPmdw
aW9fY291bnQ7IGkrKykgewotCQlpZiAoc2FtLT5leHBvcnRfZmxhZ3NbaV0gJiBHUElPRl9F
WFBPUlQpIHsKLQkJCWdwaW9fdW5leHBvcnQoaSArIHNhbS0+Z3Bpby5iYXNlKTsKLQkJCWdw
aW9fZnJlZShpICsgc2FtLT5ncGlvLmJhc2UpOwotCQl9CisJCXN0cnVjdCBncGlvX2Rlc2Mg
KmRlc2MgPSBncGlvY2hpcF9nZXRfZGVzYygmc2FtLT5ncGlvLCBpKTsKKwkJaWYgKHNhbS0+
ZXhwb3J0X2ZsYWdzW2ldICYgR1BJT0ZfRVhQT1JUKQorCQkJZ3Bpb2NoaXBfZnJlZV9vd25f
ZGVzYyhkZXNjKTsKIAl9CiAJcmV0dXJuIDA7CiB9CkBAIC01ODIsMTEgKzU3NiwzMiBAQCBz
dGF0aWMgaW50IHNhbV9ncGlvX2V4cG9ydChzdHJ1Y3Qgc2FtX2dwaW8gKnNhbSkKIAkvKiBh
dXRvLWV4cG9ydCBwaW5zIGFzIHJlcXVlc3RlZCAqLwogCiAJZm9yIChpID0gMDsgaSA8IHNh
bS0+Z3Bpb19jb3VudDsgaSsrKSB7CisJCWVudW0gb2ZfZ3Bpb19mbGFncyBmbGFncyA9IHNh
bS0+ZXhwb3J0X2ZsYWdzW2ldOworCQlzdHJ1Y3QgZ3Bpb19kZXNjICpkZXNjID0gZ3Bpb2No
aXBfZ2V0X2Rlc2MoJnNhbS0+Z3BpbywgaSk7CisKIAkJLyogcmVxdWVzdCBhbmQgaW5pdGlh
bGl6ZSBleHBvcnRlZCBwaW5zICovCi0JCWlmIChzYW0tPmV4cG9ydF9mbGFnc1tpXSAmIEdQ
SU9GX0VYUE9SVCkgewotCQkJcmV0ID0gZ3Bpb19yZXF1ZXN0X29uZShpICsgc2FtLT5ncGlv
LmJhc2UsCi0JCQkJCSAgICAgICBzYW0tPmV4cG9ydF9mbGFnc1tpXSwKLQkJCQkJICAgICAg
IHNhbS0+bmFtZXNbaV0pOworCQlpZiAoZmxhZ3MgJiBHUElPRl9FWFBPUlQpIHsKKwkJCXJl
dCA9IGdwaW9kX3N5c2ZzX3NldF9hY3RpdmVfbG93KGRlc2MsCisJCQkJCQlmbGFncyAmIEdQ
SU9GX0FDVElWRV9MT1cpOworCQkJaWYgKHJldCkKKwkJCQlnb3RvIGVycm9yOworCisJCQly
ZXQgPSBncGlvY2hpcF9yZXF1ZXN0X293bl9kZXNjKGRlc2MsICJzYW0tZXhwb3J0Iik7CisJ
CQlpZiAocmV0KQorCQkJCWdvdG8gZXJyb3I7CisKKwkJCWlmIChmbGFncyAmIEdQSU9GX0RJ
Ul9JTikgeworCQkJCXJldCA9IGdwaW9kX2RpcmVjdGlvbl9pbnB1dChkZXNjKTsKKwkJCQlp
ZiAocmV0KQorCQkJCQlnb3RvIGVycm9yOworCQkJfSBlbHNlIHsKKwkJCQlyZXQgPSBncGlv
ZF9kaXJlY3Rpb25fb3V0cHV0KGRlc2MsCisJCQkJCQlmbGFncyAmIEdQSU9GX09VVF9JTklU
X0hJR0gpOworCQkJCWlmIChyZXQpCisJCQkJCWdvdG8gZXJyb3I7CisJCQl9CisJCQlyZXQg
PSBncGlvZF9leHBvcnQoZGVzYywKKwkJCQkJICAgZmxhZ3MgJiBHUElPRl9FWFBPUlRfQ0hB
TkdFQUJMRSk7CiAJCQlpZiAocmV0KQogCQkJCWdvdG8gZXJyb3I7CiAJCX0KZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3Bpby9ncGlvbGliLmMgYi9kcml2ZXJzL2dwaW8vZ3Bpb2xpYi5jCmlu
ZGV4IDYxZGUxZWYuLmYwMTE4MzQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvZ3Bpby9ncGlvbGli
LmMKKysrIGIvZHJpdmVycy9ncGlvL2dwaW9saWIuYwpAQCAtMTcxMSw2ICsxNzExLDcgQEAg
aW50IGdwaW9jaGlwX3JlcXVlc3Rfb3duX2Rlc2Moc3RydWN0IGdwaW9fZGVzYyAqZGVzYywg
Y29uc3QgY2hhciAqbGFiZWwpCiAKIAlyZXR1cm4gX19ncGlvZF9yZXF1ZXN0KGRlc2MsIGxh
YmVsKTsKIH0KK0VYUE9SVF9TWU1CT0woZ3Bpb2NoaXBfcmVxdWVzdF9vd25fZGVzYyk7CiAK
IC8qKgogICogZ3Bpb2NoaXBfZnJlZV9vd25fZGVzYyAtIEZyZWUgR1BJTyByZXF1ZXN0ZWQg
YnkgdGhlIGNoaXAgZHJpdmVyCkBAIC0xNzI0LDYgKzE3MjUsNyBAQCB2b2lkIGdwaW9jaGlw
X2ZyZWVfb3duX2Rlc2Moc3RydWN0IGdwaW9fZGVzYyAqZGVzYykKIAlpZiAoZGVzYykKIAkJ
X19ncGlvZF9mcmVlKGRlc2MpOwogfQorRVhQT1JUX1NZTUJPTChncGlvY2hpcF9mcmVlX293
bl9kZXNjKTsKIAogLyogRHJpdmVycyBNVVNUIHNldCBHUElPIGRpcmVjdGlvbiBiZWZvcmUg
bWFraW5nIGdldC9zZXQgY2FsbHMuICBJbgogICogc29tZSBjYXNlcyB0aGlzIGlzIGRvbmUg
aW4gZWFybHkgYm9vdCwgYmVmb3JlIElSUXMgYXJlIGVuYWJsZWQuCg==
--------------060204090005050701070808
Content-Type: text/x-csrc;
 name="scu.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="scu.c"

/*
 * SCU board driver
 *
 * Copyright (c) 2012, 2014 Guenter Roeck <linux@roeck-us.net>
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 */

#include <linux/kernel.h>
#include <linux/init.h>
#include <linux/types.h>
#include <linux/string.h>
#include <linux/module.h>
#include <linux/mutex.h>
#include <linux/leds.h>
#include <linux/mdio-gpio.h>
#include <linux/platform_device.h>
#include <linux/gpio.h>
#include <linux/err.h>
#include <linux/dmi.h>
#include <linux/i2c.h>
#include <linux/i2c-gpio.h>
#include <linux/version.h>
#include <linux/platform_data/at24.h>
#include <linux/platform_data/pca953x.h>
#include <linux/sysfs.h>
#include <linux/spi/spi.h>
#include <linux/proc_fs.h>
#include <linux/seq_file.h>
#include <linux/netdevice.h>
#include <linux/rtnetlink.h>
#include <net/dsa.h>
#include <asm/processor.h>
#include <asm/byteorder.h>

...

static const char *pca9538_ext0_gpio_names[8] = {
	"pca9538_ext0:wireless_ena_1",
	"pca9538_ext0:wireless_ena_2",
	"pca9538_ext0:wireless_a_radio_disable",
	"pca9538_ext0:wireless_a_reset",
	"pca9538_ext0:in_spare_1",
	"pca9538_ext0:in_spare_2",
	"pca9538_ext0:wireless_b_radio_disable",
	"pca9538_ext0:wireless_b_reset",
};

static const char *pca9538_ext1_gpio_names[8] = {
	"pca9538_ext1:rd_led_on",
	"pca9538_ext1:wless_led_on",
	"pca9538_ext1:ld_fail_led_on",
	"pca9538_ext1:sw_led_on",
	"pca9538_ext1:discrete_out_1",
	"pca9538_ext1:discrete_out_2",
	"pca9538_ext1:discrete_out_3",
	"pca9538_ext1:discrete_out_4",
};

static const char *pca9538_ext2_gpio_names[8] = {
	"pca9538_ext2:sd_active_1",
	"pca9538_ext2:sd_error_1",
	"pca9538_ext2:sd_active_2",
	"pca9538_ext2:sd_error_2",
	"pca9538_ext2:sd_active_3",
	"pca9538_ext2:sd_error_3",
	"pca9538_ext2:hub_6_reset",
	"pca9538_ext2:hub_6_config_status",
};

static const char *pca9538_ext3_gpio_names[8] = {
	"pca9538_ext3:sd_active_4",
	"pca9538_ext3:sd_error_4",
	"pca9538_ext3:sd_active_5",
	"pca9538_ext3:sd_error_5",
	"pca9538_ext3:sd_active_6",
	"pca9538_ext3:sd_error_6",
	"pca9538_ext3:hub_2_reset",
	"pca9538_ext3:hub_2_config_status",
};

static const char *pca9557_gpio_names[8] = {
	"pca9557:sd_card_detect_1",
	"pca9557:sd_card_detect_2",
	"pca9557:sd_card_detect_3",
	"pca9557:sd_card_detect_4",
	"pca9557:sd_card_detect_5",
	"pca9557:sd_card_detect_6",
	"pca9557:spare1",
	"pca9557:spare2",
};

static int scu_gpio_common_setup(unsigned gpio_base, unsigned ngpio, u32 mask,
				 u32 is_input, u32 is_active, u32 active_low)
{
	int i;
	unsigned long flags;

	for (i = 0; i < ngpio; i++) {
		if (!(mask & (1 << i)))
			continue;
		flags = GPIOF_EXPORT_DIR_FIXED;
		if (is_input & (1 << i)) {
			flags |= GPIOF_DIR_IN;
		} else {
			flags |= GPIOF_DIR_OUT;
			if (is_active & (1 << i))
				flags |= GPIOF_INIT_HIGH;
		}
		if (active_low & (1 << i))
			flags |= GPIOF_ACTIVE_LOW;
		gpio_request_one(gpio_base + i, flags, NULL);
	}
	return 0;
}

static int pca9538_ext0_setup(struct i2c_client *client,
			      unsigned gpio_base, unsigned ngpio, void *context)
{
	scu_gpio_common_setup(gpio_base, ngpio, 0xff, 0x33, 0xcc, 0x00);
	return 0;
}

static int pca9538_ext1_setup(struct i2c_client *client,
			      unsigned gpio_base, unsigned ngpio, void *context)
{
	scu_gpio_common_setup(gpio_base, ngpio, 0xf0, 0x00, 0x00, 0x00);
	return 0;
}

static int pca9538_ext2_setup(struct i2c_client *client,
			      unsigned gpio_base, unsigned ngpio, void *context)
{
	scu_gpio_common_setup(gpio_base, ngpio, 0xc0, 0x80, 0x40, 0x00);
	return 0;
}

static int pca9538_ext3_setup(struct i2c_client *client,
			      unsigned gpio_base, unsigned ngpio, void *context)
{
	scu_gpio_common_setup(gpio_base, ngpio, 0xc0, 0x80, 0x40, 0x00);
	return 0;
}

static int pca9557_setup(struct i2c_client *client,
			 unsigned gpio_base, unsigned ngpio, void *context)
{
	scu_gpio_common_setup(gpio_base, ngpio, 0x3f, 0x3f, 0x00, 0x3f);
	return 0;
}

static void scu_gpio_common_teardown(unsigned gpio_base, int ngpio, u32 mask)
{
	int i;

	for (i = 0; i < ngpio; i++) {
		if (mask & (1 << i)) {
			gpio_unexport(gpio_base + i);
			gpio_free(gpio_base + i);
		}
	}
}

static int pca9538_ext0_teardown(struct i2c_client *client,
				 unsigned gpio_base, unsigned ngpio,
				 void *context)
{
	scu_gpio_common_teardown(gpio_base, ngpio, 0xff);
	return 0;
}

static int pca9538_ext1_teardown(struct i2c_client *client,
				 unsigned gpio_base, unsigned ngpio,
				 void *context)
{
	scu_gpio_common_teardown(gpio_base, ngpio, 0xf0);
	return 0;
}

static int pca9538_ext2_teardown(struct i2c_client *client,
				 unsigned gpio_base, unsigned ngpio,
				 void *context)
{
	scu_gpio_common_teardown(gpio_base, ngpio, 0xc0);
	return 0;
}

static int pca9538_ext3_teardown(struct i2c_client *client,
				 unsigned gpio_base, unsigned ngpio,
				 void *context)
{
	scu_gpio_common_teardown(gpio_base, ngpio, 0xc0);
	return 0;
}

static int pca9557_teardown(struct i2c_client *client,
			    unsigned gpio_base, unsigned ngpio,
			    void *context)
{
	scu_gpio_common_teardown(gpio_base, ngpio, 0x3f);
	return 0;
}

static struct pca953x_platform_data scu_pca953x_pdata[] = {
	[0] = {.gpio_base = SCU_EXT_GPIO_BASE(0),
	       .irq_base = -1,
	       .setup = pca9538_ext0_setup,
	       .teardown = pca9538_ext0_teardown,
	       .names = pca9538_ext0_gpio_names},
	[1] = {.gpio_base = SCU_EXT_GPIO_BASE(1),
	       .irq_base = -1,
	       .setup = pca9538_ext1_setup,
	       .teardown = pca9538_ext1_teardown,
	       .names = pca9538_ext1_gpio_names},
	[2] = {.gpio_base = SCU_EXT_GPIO_BASE(2),
	       .irq_base = -1,
	       .setup = pca9538_ext2_setup,
	       .teardown = pca9538_ext2_teardown,
	       .names = pca9538_ext2_gpio_names},
	[3] = {.gpio_base = SCU_EXT_GPIO_BASE(3),
	       .irq_base = -1,
	       .setup = pca9538_ext3_setup,
	       .teardown = pca9538_ext3_teardown,
	       .names = pca9538_ext3_gpio_names},
	[4] = {.gpio_base = SCU_EXT_GPIO_BASE(4),
	       .irq_base = -1,
	       .setup = pca9557_setup,
	       .teardown = pca9557_teardown,
	       .names = pca9557_gpio_names},
};

...

static int scu_instantiate_i2c(struct scu_data *data, int base,
			       struct i2c_board_info *info, int count)
{
	int i;

	for (i = 0; i < count; i++) {
		data->client[base + i] = i2c_new_device(data->adapter, info);
		if (!data->client[base + i]) {
			/*
			 * Unfortunately this call does not tell us
			 * why it failed. Pick the most likely reason.
			 */
			return -EBUSY;
		}
		info++;
	}
	return 0;
}

static struct i2c_board_info scu_i2c_info_common[] = {
	{ I2C_BOARD_INFO("scu_pic", 0x20)},
	{ I2C_BOARD_INFO("at24", 0x54),
		.platform_data = &at24c08},
	{ I2C_BOARD_INFO("ds1682", 0x6b)},
	{ I2C_BOARD_INFO("pca9538", 0x71),
		.platform_data = &scu_pca953x_pdata[1],},
	{ I2C_BOARD_INFO("pca9538", 0x72),
		.platform_data = &scu_pca953x_pdata[2],},
	{ I2C_BOARD_INFO("pca9538", 0x73),
		.platform_data = &scu_pca953x_pdata[3],},
};

...

static int scu_probe(struct platform_device *pdev)
{
	struct proc_dir_entry *rave_board_type;
	struct device *dev = &pdev->dev;
	struct i2c_adapter *adapter;
	struct net_device *ndev;
	struct scu_data *data;
	int i, ret;

	...

	ret = scu_instantiate_i2c(data, 0, scu_i2c_info_common,
				  ARRAY_SIZE(scu_i2c_info_common));
	...
}

--------------060204090005050701070808--
