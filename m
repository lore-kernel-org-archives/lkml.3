Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946202Ab3BHKgU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 05:36:20 -0500
Received: from mga03.intel.com ([143.182.124.21]:26030 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030242Ab3BHKgS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 05:36:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,628,1355126400"; 
   d="scan'208";a="200056165"
Message-ID: <5114D520.1080305@linux.intel.com>
Date: Fri, 08 Feb 2013 02:36:16 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        "lkml," <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Denis Turischev <denis@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: gpio-sch GPIO_SYSFS access
References: <5112FC44.2000303@linux.intel.com> <CACRpkdacYOeG2tqSW5YhqbkxGnxCxamAc_UUyghEQXO98OvKJw@mail.gmail.com> <511481A2.7010100@linux.intel.com> <5114A453.8000408@linux.intel.com> <20130208084916.GM5072@sortiz-mobl>
In-Reply-To: <20130208084916.GM5072@sortiz-mobl>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/08/2013 12:49 AM, Samuel Ortiz wrote:
> Hi Darren,
> 
> On Thu, Feb 07, 2013 at 11:08:03PM -0800, Darren Hart wrote:
>> On 02/07/2013 08:40 PM, Darren Hart wrote:
>>>
>>>
>>> On 02/07/2013 02:09 AM, Linus Walleij wrote:
>>>> On Thu, Feb 7, 2013 at 1:58 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>>>>
>>>>> Is it that some other driver has claimed these GPIO lines? If so, how do
>>>>> I determine which one?
>>>>
>>>> Yes I think that could be it, the driver would need to call
>>>> gpio_export() for it to also be accessible in sysfs.
>>>>
>>>> Configure in debugfs and check the file "gpio" in debugfs
>>>> to figure out the client.
>>>>
>>>> Yours,
>>>> Linus Walleij
>>>>
>>>
>>> I found gpio_export() as you suggested above and instrumented it. What I
>>> found was that it was not getting called at all. As I understand it,
>>> calling gpiochip_export() should make the gpiochip# appear in
>>> /sys/class/gpio and then I should be able to configure which lines are
>>> exported via the /sys/class/gpio/export file.
>>>
>>> I haven't yet found how gpio-pch differs from gpio-sch that causes the
>>> gpio-pch chip to appear in sysfs and the gpio-sch one not to. I did
>>> patch gpio-sch with a request and export loop:
>>>
>>> $ git diff drivers/gpio/gpio-sch.c
>>> diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
>>> index 8cadf4d..79783c1 100644
>>> --- a/drivers/gpio/gpio-sch.c
>>> +++ b/drivers/gpio/gpio-sch.c
>>> @@ -188,7 +188,7 @@ static struct gpio_chip sch_gpio_resume = {
>>>  static int __devinit sch_gpio_probe(struct platform_device *pdev)
>>>  {
>>>         struct resource *res;
>>> -       int err, id;
>>> +       int err, id, gpio;
>>>
>>>         id = pdev->id;
>>>         if (!id)
>>> @@ -243,10 +243,24 @@ static int __devinit sch_gpio_probe(struct
>>> platform_device *p
>>>         if (err < 0)
>>>                 goto err_sch_gpio_core;
>>>
>>> +       /* DEBUG: export all the core GPIOS */
>>> +       for (gpio = sch_gpio_core.base;
>>> +            gpio < sch_gpio_core.base + sch_gpio_core.ngpio; gpio++) {
>>> +               gpio_request(gpio, "gpio-sch");
>>> +               gpio_export(gpio, true);
>>> +       }
>>> +
>>>         err = gpiochip_add(&sch_gpio_resume);
>>>         if (err < 0)
>>>                 goto err_sch_gpio_resume;
>>>
>>> +       /* DEBUG: export all the resume GPIOS */
>>> +       for (gpio = sch_gpio_resume.base;
>>> +            gpio < sch_gpio_resume.base + sch_gpio_resume.ngpio; gpio++) {
>>> +               gpio_request(gpio, "gpio-sch");
>>> +               gpio_export(gpio, true);
>>> +       }
>>> +
>>>         return 0;
>>>
>>>  err_sch_gpio_resume:
>>>
>>>
>>> With this both the gpiochip# and gpio# entries appear in sysfs. However,
>>> unlike those for the gpio-pch lines, these report an error in the sysfs
>>> interface:
>>>
>>> /sys/class/gpio# ls *
>>> ls: gpio0: No such file or directory
>>>
>>
>> Well, this happens when the driver in question gets removed by another
>> driver. 
> removed by another driver ? I'm not sure I understand what that means.

In my case, the gpio-sch probe function runs and creates the gpiochip
with 14 GPIO lines. Later lpc-sch probe runs, adds devices to the mfd
device list, fails the WDT base address as described below, and then
removes the devices in the mfd device list, which triggers the removal
of the gpio-sch device.

If I just skip the WDT lookup and not abort, then things work as I had
expected. Sooo... does it make sense to remove ALL the MFD device when
the read of the WDTBA registers indicates "Disabled"? Seems extreme to me.

> 
>> In this case the mfd/lpc_sch.c driver fails reading some PCI
>> config after it has added the gpio-pch device to a list:
>>
>> lpc_sch 0000:00:1f.0: Decode of the WDT I/O range disabled
>>
>>
>> It then proceeds to remove all the devices it added - including gpio-pch.c.
>>
>> Dragging Samuel in as his name is on some of the commits, maybe he can
>> help here.
>>
>> Samuel, does it make sense for CONFIG_GPIO_SCH to require
>> CONFIG_LPC_SCH? I'm building for a Queensbay (Atom E6xx + EG20T PCH).
>> There is no SCH as I understand things. Can these be decoupled?
> They actually don't have code dependency, GPIO_SCH selects LPC_SCH beacause
> the MFD parts actually creates the GPIO device.
> So you're saying Queensbay use the same GPIO IP block without actually having
> SCH ?

That is how I currently understand it. These drivers appear to have been
originaly written for the Silverthorne (Z5xx) CPUs and the Intel SCH
chipset.
TunnelCreek (E6xx) support was added later, but apparently the LPC
bridge is onboard the CPU and it still contains the registers to setup
the gpio-sch base address and such as you suggest - so still needed. The
Queensbay platform is an E6xx CPU and the EG20T PCH (no SCH).

The driver is failing when looking for the watchdog base address (bit 31
isn't 1 apparently). I suppose this could be a firmware issue?

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
