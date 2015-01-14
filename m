Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbbANL61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 06:58:27 -0500
Received: from mail-ie0-f172.google.com ([209.85.223.172]:39579 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751966AbbANL6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 06:58:25 -0500
MIME-Version: 1.0
In-Reply-To: <54AA2EB1.8090501@ti.com>
References: <1418371601-22658-1-git-send-email-kishon@ti.com>
	<548F498F.7050202@ti.com>
	<549271A9.5040701@ti.com>
	<5492E09F.1000003@ti.com>
	<54AA2EB1.8090501@ti.com>
Date: Wed, 14 Jan 2015 12:58:24 +0100
Message-ID: <CACRpkdago2vWJYFmywULna6nkrbtciPZFESuuKixF0r8rSB1Sw@mail.gmail.com>
Subject: Re: [PATCH] gpio: pcf857x: restore the initial line state of all pcf lines
From: Linus Walleij <linus.walleij@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Nishanth Menon <nm@ti.com>, Alexandre Courbot <gnurou@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, Linux-OMAP <linux-omap@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Benoit Parrot <bparrot@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 5, 2015 at 7:26 AM, Kishon Vijay Abraham I <kishon@ti.com> wrote:
> On Thursday 18 December 2014 07:41 PM, Nishanth Menon wrote:
>> On 12/18/2014 12:18 AM, Kishon Vijay Abraham I wrote:
>>>
>>>
>>> On Tuesday 16 December 2014 02:20 AM, Nishanth Menon wrote:
>>>> On 12/12/2014 02:06 AM, Kishon Vijay Abraham I wrote:
>>>>> The reset values for all the PCF lines are high and hence on shutdown
>>>>> we should drive all the lines high in order to bring it to the reset state.
>>>>>
>>>>> This is actually required since pcf doesn't have a reset line and even after
>>>>> warm reset (by invoking "reboot" in prompt) the pcf lines maintains it's
>>>>> previous programmed state. This becomes a problem if the boards are designed
>>>>> to work with the default initial state.
>>>>>
>>>>> DRA7XX_evm uses PCF8575 and one of the PCF output lines feeds to MMC/SD and
>>>>> this line should be driven high in order for the MMC/SD to be detected.
>>>>> This line is modelled as regulator and the hsmmc driver takes care of enabling
>>>>> and disabling it. In the case of 'reboot', during shutdown path as part of it's
>>>>> cleanup process the hsmmc driver disables this regulator. This makes MMC boot
>>>>> not functional.
>>>>>
>>>>> Fixed it by driving high all the pcf lines.
>>>>>
>>>>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>>>>> ---
>>>>>  drivers/gpio/gpio-pcf857x.c |    9 +++++++++
>>>>>  1 file changed, 9 insertions(+)
>>>>>
>>>>> diff --git a/drivers/gpio/gpio-pcf857x.c b/drivers/gpio/gpio-pcf857x.c
>>>>> index 236708a..00b15b2 100644
>>>>> --- a/drivers/gpio/gpio-pcf857x.c
>>>>> +++ b/drivers/gpio/gpio-pcf857x.c
>>>>> @@ -448,6 +448,14 @@ static int pcf857x_remove(struct i2c_client *client)
>>>>>    return status;
>>>>>  }
>>>>>
>>>>> +static void pcf857x_shutdown(struct i2c_client *client)
>>>>> +{
>>>>> +  struct pcf857x *gpio = i2c_get_clientdata(client);
>>>>> +
>>>>> +  /* Drive all the I/O lines high */
>>>>> +  gpio->write(gpio->client, BIT(gpio->chip.ngpio) - 1);
>>>>
>>>> you might force a contention here - depending on System configuration.
>>>> example:
>>>> +-------+
>>>> |       |
>>>> |  U1   |         +------+      +-----------+
>>>> |       +--------->      |      |           |
>>>> +-------+         |      |      |           |
>>>>                   | Switch<-----+    SoC    |
>>>> +-------+         |      |      |           |
>>>> |       |         |      |      |           |
>>>> | U2    <---------+--^---+      +-----------+
>>>> |       |            |
>>>> |       |            |
>>>> +-------+            |
>>>>                   +--+--+
>>>>                   |     |
>>>>                   | PCF |
>>>>                   |     |
>>>>                   +-----+
>>>>
>>>> At low, SoC pin is connected to U2 as drive. when reset to high, you
>>>> now have U1 driving to the same pin that SoC has, potentially
>>>> resulting in contention.
>>>>
>>>>
>>>> Unfortunately, at this level, you do not know what the state of the
>>>> system is, blindly forcing a pin level will potentially cause
>>>> contention risk depending on pin configuration.
>>>
>>> Assume we are doing a reset when the system is powered on, irrespective of the
>>> state of the system, we'll be forcing the pin level to the default state.
>>
>> Yes, I dont deny that system will be fine *after* reset sequence is
>> started or completed. However there is a duration between the pcf
>> shutdown handler is called and the final reset handler is invoked -
>> that is the duration when  the contention might cause device behavior.
>> Essentially ignoring the state various drivers have asked PCF to setup
>> the pins and doing a hands down configuration may have side effects we
>> cant properly expect.
>
> The solution might be to invoke the shutdown handler of the various drivers
> using the PCF before the shutdown handler of the PCF driver itself gets
> invoked? But I'm not sure how can that be achieved in linux kernel :-(

#include <linux/reboot.h>

static int foo_reboot_handler(struct notifier_block *this,
                                unsigned long code,
                                void *unused)
{
        pr_crit("do some last minute stuff\n");
        return NOTIFY_OK;
}

static struct notifier_block foo_reboot_notifier = {
        .notifier_call = foo_reboot_handler,
};

register_reboot_notifier(&foo_reboot_notifier);

Yours,
Linus Walleij
