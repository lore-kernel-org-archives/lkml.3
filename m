Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751139Ab3KWFhA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 00:37:00 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:33939 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab3KWFg5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 00:36:57 -0500
MIME-Version: 1.0
In-Reply-To: <528FA509.6080907@wwwdotorg.org>
References: <1385122474-14926-1-git-send-email-mika.westerberg@linux.intel.com>
 <1385122474-14926-3-git-send-email-mika.westerberg@linux.intel.com> <528FA509.6080907@wwwdotorg.org>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Sat, 23 Nov 2013 14:36:36 +0900
Message-ID: <CAAVeFuKBAJS8LyDJ=99ZTWH6j=Z+H-KPAjA0SEWJ9oC5BSbe7w@mail.gmail.com>
Subject: Re: [PATCH v2 2/7] ARM: tegra: add gpiod_lookup table for paz00
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Chris Ball <cjb@laptop.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Rhyland Klein <rklein@nvidia.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Rob Landley <rob@landley.net>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 23, 2013 at 3:40 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 11/22/2013 05:14 AM, Mika Westerberg wrote:
>> From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>
>> This makes it possible to request the gpio descriptors in
>> rfkill-gpio driver regardless of the platform.
>
> Patches 1-3,
> Tested-by: Stephen Warren <swarren@nvidia.com>
>
> All the testing I did was to "cat /sys/kernel/debug/gpios" to make sure
> those two GPIOs had been correctly acquired by the driver, and that they
> changed state as expected via the command-line "rfkill {un,}block" commands.
>
> However, please note that I had to apply a couple fixes to the gpiolib
> core to get this working:
>
> 1)
>
> To solve the following build warning:
>
>> In file included from arch/arm/mach-tegra/board-paz00.c:21:0:
>> include/linux/gpio/driver.h:102:17: warning: ‘struct of_phandle_args’ declared inside parameter list [enabled by default]
>> include/linux/gpio/driver.h:102:17: warning: its scope is only this definition or declaration, which is probably not what you want [enabled by default]
>
> I applied:
>
>
>> diff --git a/include/linux/gpio/driver.h b/include/linux/gpio/driver.h
>> index 82eac610ce1a..5133cf29803a 100644
>> --- a/include/linux/gpio/driver.h
>> +++ b/include/linux/gpio/driver.h
>> @@ -5,6 +5,7 @@
>>
>>  struct device;
>>  struct gpio_desc;
>> +struct of_phandle_args;
>>  struct seq_file;
>>
>>  /**
>
> 2)
>
> In order to get the GPIO lookups from the rfkill driver working, I applied:
>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index ac53a9593662..b73c39f99858 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -2368,7 +2368,7 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
>>                               continue;
>>                       }
>>
>> -                     if (chip->ngpio >= p->chip_hwnum) {
>> +                     if (chip->ngpio <= p->chip_hwnum) {
>>                               dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
>>                                        chip->label, chip->ngpio);
>>                               continue;

Mmm. I guess should be blamed for this one. I haven't tested GPIO
platform lookup in a while and this seems to have slipped in at some
point. :( I will send fixup patches to Linus for both issues, thanks
for pointing them out.

Alex.
