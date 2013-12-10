Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab3LJDLC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 22:11:02 -0500
Received: from hqemgate15.nvidia.com ([216.228.121.64]:11360 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab3LJDLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 22:11:00 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Dec 2013 19:07:39 -0800
Message-ID: <52A68640.5010806@nvidia.com>
Date: Tue, 10 Dec 2013 12:10:56 +0900
From: Alex Courbot <acourbot@nvidia.com>
Organization: NVIDIA
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpiolib: return -ENOENT when no GPIO mapping exists
References: <1386295616-14192-1-git-send-email-acourbot@nvidia.com> <1386584927.1871.127.camel@smile>
In-Reply-To: <1386584927.1871.127.camel@smile>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2013 07:28 PM, Andy Shevchenko wrote:
> On Fri, 2013-12-06 at 11:06 +0900, Alexandre Courbot wrote:
>> Some devices drivers make use of optional GPIO parameters. For such
>> drivers, it is important to discriminate between the case where no
>> GPIO mapping has been defined for the function they are requesting, and
>> the case where a mapping exists but an error occured while resolving it
>> or when acquiring the GPIO.
>>
>> This patch changes the family of gpiod_get() functions such that they
>> will return -ENOENT if and only if no GPIO mapping is defined for the
>> requested function. Other error codes are used when an actual error
>> occured during the GPIO resolution.
>>
>
> I like the idea.
> One minor comment below (in code).
>
>> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
>> ---
>> I think this change should be merged early as not having it may prevent
>> some users to switch to gpiod. I stumbled upon this issue while
>> considering porting a simple driver (pwm_bl) that has an optional GPIO
>> parameter.
>>
>> Mika, Andy: if Linus agrees with this change, could you take care of
>> having -ENOENT returned as well for the ACPI and SFI GPIOs lookup?
>
> I have already switched to -ENOENT, so, consider done.

Great, thanks!

>> My understanding of ACPI was not sufficient to allow me to do it myself.
>> SFI OTOH should be trivial as it is a simple table.
>>
>>   Documentation/gpio/consumer.txt |  6 +++++-
>>   drivers/gpio/gpiolib.c          | 31 ++++++++++++++++---------------
>>   2 files changed, 21 insertions(+), 16 deletions(-)
>>
>> diff --git a/Documentation/gpio/consumer.txt b/Documentation/gpio/consumer.txt
>> index 07c74a3765a0..e42f77d8d4ca 100644
>> --- a/Documentation/gpio/consumer.txt
>> +++ b/Documentation/gpio/consumer.txt
>> @@ -38,7 +38,11 @@ device that displays digits), an additional index argument can be specified:
>>   					  const char *con_id, unsigned int idx)
>>
>>   Both functions return either a valid GPIO descriptor, or an error code checkable
>> -with IS_ERR(). They will never return a NULL pointer.
>> +with IS_ERR() (they will never return a NULL pointer). -ENOENT will be returned
>> +if and only if no GPIO has been assigned to the device/function/index triplet,
>> +other error codes are used for cases where a GPIO has been assigned but an error
>> +occured while trying to acquire it. This is useful to discriminate between mere
>> +errors and an absence of GPIO for optional GPIO parameters.
>>
>>   Device-managed variants of these functions are also defined:
>>
>> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
>> index 5fad38fcd701..e96d4a90c0c3 100644
>> --- a/drivers/gpio/gpiolib.c
>> +++ b/drivers/gpio/gpiolib.c
>> @@ -2358,7 +2358,7 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
>>   				    unsigned int idx,
>>   				    enum gpio_lookup_flags *flags)
>>   {
>> -	struct gpio_desc *desc = ERR_PTR(-ENODEV);
>> +	struct gpio_desc *desc = ERR_PTR(-ENOENT);
>>   	struct gpiod_lookup_table *table;
>>   	struct gpiod_lookup *p;
>>
>> @@ -2380,19 +2380,21 @@ static struct gpio_desc *gpiod_find(struct device *dev, const char *con_id,
>>   		chip = find_chip_by_name(p->chip_label);
>>
>>   		if (!chip) {
>> -			dev_warn(dev, "cannot find GPIO chip %s\n",
>> -				 p->chip_label);
>> -			continue;
>> +			dev_err(dev, "cannot find GPIO chip %s\n",
>> +				p->chip_label);
>> +			return ERR_PTR(-ENODEV);
>>   		}
>>
>>   		if (chip->ngpio <= p->chip_hwnum) {
>> -			dev_warn(dev, "GPIO chip %s has %d GPIOs\n",
>> -				 chip->label, chip->ngpio);
>> -			continue;
>> +			dev_err(dev, "requested GPIO %d but chip %s has %d\n",
>
> The proposed message may confuse user. This lead to question in my head:
> "what gpio chip has that referred by %d at the end of line".
>
> Maybe something like "requested GPIO %d is out of range [0..%d] for chip
> %s\n" ?

I agree it would be better. My concern here is to have the line fit 
within 80 characters. :P

But you're right, I will improve this in v2.

Thanks,
Alex.
