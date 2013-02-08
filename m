Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002Ab3BHHII (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 02:08:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:14963 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756536Ab3BHHIG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 02:08:06 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,627,1355126400"; 
   d="scan'208";a="254147088"
Message-ID: <5114A453.8000408@linux.intel.com>
Date: Thu, 07 Feb 2013 23:08:03 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "lkml," <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Denis Turischev <denis@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, sameo@linux.intel.com
Subject: Re: gpio-sch GPIO_SYSFS access
References: <5112FC44.2000303@linux.intel.com> <CACRpkdacYOeG2tqSW5YhqbkxGnxCxamAc_UUyghEQXO98OvKJw@mail.gmail.com> <511481A2.7010100@linux.intel.com>
In-Reply-To: <511481A2.7010100@linux.intel.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 08:40 PM, Darren Hart wrote:
> 
> 
> On 02/07/2013 02:09 AM, Linus Walleij wrote:
>> On Thu, Feb 7, 2013 at 1:58 AM, Darren Hart <dvhart@linux.intel.com> wrote:
>>
>>> Is it that some other driver has claimed these GPIO lines? If so, how do
>>> I determine which one?
>>
>> Yes I think that could be it, the driver would need to call
>> gpio_export() for it to also be accessible in sysfs.
>>
>> Configure in debugfs and check the file "gpio" in debugfs
>> to figure out the client.
>>
>> Yours,
>> Linus Walleij
>>
> 
> I found gpio_export() as you suggested above and instrumented it. What I
> found was that it was not getting called at all. As I understand it,
> calling gpiochip_export() should make the gpiochip# appear in
> /sys/class/gpio and then I should be able to configure which lines are
> exported via the /sys/class/gpio/export file.
> 
> I haven't yet found how gpio-pch differs from gpio-sch that causes the
> gpio-pch chip to appear in sysfs and the gpio-sch one not to. I did
> patch gpio-sch with a request and export loop:
> 
> $ git diff drivers/gpio/gpio-sch.c
> diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
> index 8cadf4d..79783c1 100644
> --- a/drivers/gpio/gpio-sch.c
> +++ b/drivers/gpio/gpio-sch.c
> @@ -188,7 +188,7 @@ static struct gpio_chip sch_gpio_resume = {
>  static int __devinit sch_gpio_probe(struct platform_device *pdev)
>  {
>         struct resource *res;
> -       int err, id;
> +       int err, id, gpio;
> 
>         id = pdev->id;
>         if (!id)
> @@ -243,10 +243,24 @@ static int __devinit sch_gpio_probe(struct
> platform_device *p
>         if (err < 0)
>                 goto err_sch_gpio_core;
> 
> +       /* DEBUG: export all the core GPIOS */
> +       for (gpio = sch_gpio_core.base;
> +            gpio < sch_gpio_core.base + sch_gpio_core.ngpio; gpio++) {
> +               gpio_request(gpio, "gpio-sch");
> +               gpio_export(gpio, true);
> +       }
> +
>         err = gpiochip_add(&sch_gpio_resume);
>         if (err < 0)
>                 goto err_sch_gpio_resume;
> 
> +       /* DEBUG: export all the resume GPIOS */
> +       for (gpio = sch_gpio_resume.base;
> +            gpio < sch_gpio_resume.base + sch_gpio_resume.ngpio; gpio++) {
> +               gpio_request(gpio, "gpio-sch");
> +               gpio_export(gpio, true);
> +       }
> +
>         return 0;
> 
>  err_sch_gpio_resume:
> 
> 
> With this both the gpiochip# and gpio# entries appear in sysfs. However,
> unlike those for the gpio-pch lines, these report an error in the sysfs
> interface:
> 
> /sys/class/gpio# ls *
> ls: gpio0: No such file or directory
> 

Well, this happens when the driver in question gets removed by another
driver. In this case the mfd/lpc_sch.c driver fails reading some PCI
config after it has added the gpio-pch device to a list:

lpc_sch 0000:00:1f.0: Decode of the WDT I/O range disabled


It then proceeds to remove all the devices it added - including gpio-pch.c.

Dragging Samuel in as his name is on some of the commits, maybe he can
help here.

Samuel, does it make sense for CONFIG_GPIO_SCH to require
CONFIG_LPC_SCH? I'm building for a Queensbay (Atom E6xx + EG20T PCH).
There is no SCH as I understand things. Can these be decoupled?

I should note that if I just refuse to remove the gpio-sch with -EBUSY,
the gpiochip files show up in /sys:

# ls /sys/class/gpio/
export       gpiochip0    gpiochip244  gpiochip5    unexport

and debugfs/gpio shows the sch gpio ranges:

GPIOs 0-4,platform/sch_gpio.33158,sch_gpio_core:
GPIOs 5-13, platform/sch_gpio.33158, sch_gpio_resume:

GPIOs 244-255, 0000:02:00.2:


Unfortunatley, they still fail to export:

# echo 0 > /sys/class/gpio/export
gpio_export: gpio0 status -2
export_store: status -2
sh: write error: No such file or directory

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
