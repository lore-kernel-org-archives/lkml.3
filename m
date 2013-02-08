Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759943Ab3BHEkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 23:40:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:56899 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757902Ab3BHEkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 23:40:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,626,1355126400"; 
   d="scan'208";a="288140604"
Message-ID: <511481A2.7010100@linux.intel.com>
Date: Thu, 07 Feb 2013 20:40:02 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "lkml," <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Denis Turischev <denis@compulab.co.il>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: gpio-sch GPIO_SYSFS access
References: <5112FC44.2000303@linux.intel.com> <CACRpkdacYOeG2tqSW5YhqbkxGnxCxamAc_UUyghEQXO98OvKJw@mail.gmail.com>
In-Reply-To: <CACRpkdacYOeG2tqSW5YhqbkxGnxCxamAc_UUyghEQXO98OvKJw@mail.gmail.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/07/2013 02:09 AM, Linus Walleij wrote:
> On Thu, Feb 7, 2013 at 1:58 AM, Darren Hart <dvhart@linux.intel.com> wrote:
> 
>> Is it that some other driver has claimed these GPIO lines? If so, how do
>> I determine which one?
> 
> Yes I think that could be it, the driver would need to call
> gpio_export() for it to also be accessible in sysfs.
> 
> Configure in debugfs and check the file "gpio" in debugfs
> to figure out the client.
> 
> Yours,
> Linus Walleij
> 

I found gpio_export() as you suggested above and instrumented it. What I
found was that it was not getting called at all. As I understand it,
calling gpiochip_export() should make the gpiochip# appear in
/sys/class/gpio and then I should be able to configure which lines are
exported via the /sys/class/gpio/export file.

I haven't yet found how gpio-pch differs from gpio-sch that causes the
gpio-pch chip to appear in sysfs and the gpio-sch one not to. I did
patch gpio-sch with a request and export loop:

$ git diff drivers/gpio/gpio-sch.c
diff --git a/drivers/gpio/gpio-sch.c b/drivers/gpio/gpio-sch.c
index 8cadf4d..79783c1 100644
--- a/drivers/gpio/gpio-sch.c
+++ b/drivers/gpio/gpio-sch.c
@@ -188,7 +188,7 @@ static struct gpio_chip sch_gpio_resume = {
 static int __devinit sch_gpio_probe(struct platform_device *pdev)
 {
        struct resource *res;
-       int err, id;
+       int err, id, gpio;

        id = pdev->id;
        if (!id)
@@ -243,10 +243,24 @@ static int __devinit sch_gpio_probe(struct
platform_device *p
        if (err < 0)
                goto err_sch_gpio_core;

+       /* DEBUG: export all the core GPIOS */
+       for (gpio = sch_gpio_core.base;
+            gpio < sch_gpio_core.base + sch_gpio_core.ngpio; gpio++) {
+               gpio_request(gpio, "gpio-sch");
+               gpio_export(gpio, true);
+       }
+
        err = gpiochip_add(&sch_gpio_resume);
        if (err < 0)
                goto err_sch_gpio_resume;

+       /* DEBUG: export all the resume GPIOS */
+       for (gpio = sch_gpio_resume.base;
+            gpio < sch_gpio_resume.base + sch_gpio_resume.ngpio; gpio++) {
+               gpio_request(gpio, "gpio-sch");
+               gpio_export(gpio, true);
+       }
+
        return 0;

 err_sch_gpio_resume:


With this both the gpiochip# and gpio# entries appear in sysfs. However,
unlike those for the gpio-pch lines, these report an error in the sysfs
interface:

/sys/class/gpio# ls *
ls: gpio0: No such file or directory

ls: gpio1: No such file or directory

ls: gpio10: No such file or directory

ls: gpio11: No such file or directory

ls: gpio12: No such file or directory

ls: gpio13: No such file or directory

ls: gpio2: No such file or directory

ls: gpio3: No such file or directory

ls: gpio4: No such file or directory

ls: gpio5: No such file or directory

ls: gpio6: No such file or directory

ls: gpio7: No such file or directory

ls: gpio8: No such file or directory

ls: gpio9: No such file or directory

ls: gpiochip0: No such file or directory

ls: gpiochip5: No such file or directory

export    unexport



gpiochip244:

base       label      ngpio      power      subsystem  uevent

Clearly I'm still missing something. I've read through gpio.txt a couple
times and each time piece a bit more together. I'll do that again, but I
still suspect I'm missing something fundamental here. In particular, I
still don't understand how the gpio-pch and gpio-sch drivers are create
such different results.


Ultimately what I'm looking to do is configure a new board such that 8
of the gpio-sch lines are configured as buttons and LEDs which are
physically attached to the board (4 of each). I was hoping to use this
interface to understand the ins and outs (haha) of the GPIO subsystem.
Ultimately I believe I need either a "platform-device" or possibly an
ACPI DSDT from the firmware to properly describe the GPIO lines and
their direction. Ultimately, these should be driven by the gpio-keys and
gpio-led drivers - at least that's my current understanding.

Any help clarifying some of this would be greatly appreciated.

Thanks for the time!

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
