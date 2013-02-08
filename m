Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab3BHAg7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 19:36:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:42533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750824Ab3BHAg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 19:36:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,626,1355126400"; 
   d="scan'208";a="259365590"
Message-ID: <511448A8.8000509@linux.intel.com>
Date: Thu, 07 Feb 2013 16:36:56 -0800
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

I added dynamic printk and queried the relevant files. I didn't see any
dev_* or pr_* messages.

# dmesg | grep -i gpio
Kernel command line: BOOT_IMAGE=/vmlinuz root=/dev/sda2
console=ttyPCH0,115200 cons
ole=tty0 vmalloc=256MB "dyndbg=file gpiolib.c +p;file gpio-sch.c +p;
file gpio-pch.
c +p" dynamic_debug.verbose=1 debug loglevel=8

dynamic_debug:ddebug_add_module: 17 debug prints in module gpiolib
dynamic_debug:ddebug_add_module: 2 debug prints in module gpio_pch
pch_gpio 0000:02:00.2: enabling device (0000 -> 0002)
gpiochip_find_base: found new base at 244
gpiochip_add: registered GPIOs 244 to 255 on device: 0000:02:00.2
gpiochip_add: registered GPIOs 0 to 4 on device: sch_gpio_core
gpiochip_add: registered GPIOs 5 to 13 on device: sch_gpio_resume

The GPIO debugfs and SYSFS interfaces only show the GPIO from the PCH,
nothing from the SCH (CPU):

# cat /debug/gpio
GPIOs 244-255, 0000:02:00.2:

# ls /sys/class/gpio/
export       gpiochip244  unexport

Instrumenting gpiochip_export, I see:

gpiochip_export: base=0 ngpio=5 label=sch_gpio_core
gpiochip_add: registered GPIOs 0 to 4 on device: sch_gpio_core

gpiochip_export: base=5 ngpio=9 label=sch_gpio_resume
gpiochip_add: registered GPIOs 5 to 13 on device: sch_gpio_resume

So the calls to gpiochip_export for the sch driver are being made, and
my on-error instrumentation did not trigger.

Finally, I do see an "irq 16: nobody cared" with the sch driver as
the handler. It isn't clear to me that this would cause the chip not
to appear in sysfs, but I'm including it here for completeness:

irq 16: nobody cared (try booting with the "irqpoll" option)

Pid: 0, comm: swapper/0 Not tainted 3.4.26-yocto-standard #2

Call Trace:

 [<c1648288>] ? printk+0x2e/0x30

 [<c1093cfa>] __report_bad_irq+0x2a/0xd0
 [<c1389719>] ? add_interrupt_randomness+0x19/0x150

 [<c1093fd4>] note_interrupt+0x174/0x1c0
 [<c1009fbf>] ? cpu_idle+0x1f/0xb0

 [<c1091da2>] handle_irq_event_percpu+0xb2/0x220

 [<c1653fc9>] ? add_preempt_count+0x9/0xb0

 [<c1091f4b>] handle_irq_event+0x3b/0x60

 [<c1094940>] ? unmask_irq+0x30/0x30

 [<c1094990>] handle_fasteoi_irq+0x50/0xe0

 <IRQ>  [<c16576b3>] ? do_IRQ+0x43/0xb0

 [<c1056f04>] ? scheduler_ipi+0x74/0xd0

 [<c16575e9>] ? common_interrupt+0x29/0x30

 [<c1009fbf>] ? cpu_idle+0x1f/0xb0
 [<c1632518>] ? rest_init+0x6c/0x74
 [<c193b71d>] ? start_kernel+0x30c/0x313

 [<c193b243>] ? repair_env_string+0x51/0x51

 [<c193b078>] ? i386_start_kernel+0x78/0x7d

handlers:

[<c130aec0>] pch_gpio_handler

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Technical Lead - Linux Kernel
