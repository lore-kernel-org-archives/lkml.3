Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbaEGCtR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 22:49:17 -0400
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45056 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbaEGCtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 22:49:15 -0400
Message-ID: <53699F28.4070409@gmail.com>
Date: Tue, 06 May 2014 19:49:12 -0700
From: Frank Rowand <frowand.list@gmail.com>
Reply-To: frowand.list@gmail.com
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Josh Cartwright <joshc@codeaurora.org>,
        Courtney Cavin <courtney.cavin@sonymobile.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [RFC PATCH 0/3] devicetree, qcomm PMIC: fix node name conflict
References: <536982E3.10303@gmail.com> <CAL_JsqL6+i_ED+s6kODsadszefaZUcA7VHCfZ4k4yj62iXsarQ@mail.gmail.com>
In-Reply-To: <CAL_JsqL6+i_ED+s6kODsadszefaZUcA7VHCfZ4k4yj62iXsarQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/6/2014 6:32 PM, Rob Herring wrote:
> On Tue, May 6, 2014 at 7:48 PM, Frank Rowand <frowand.list@gmail.com> wrote:
>> An issue with the path of SPMI nodes under /sys/bus/... was reported in
>> https://lkml.org/lkml/2014/4/23/312.  The symptom is that two different

< snip >

>>
> 
> I think the primary question to ask is there any added benefit to
> having the additional hierarchy of devices. I don't think there is
> much support to have more hierarchy from what I have seen of past
> discussions.

The hierarchy avoids the name space conflict.

It also maps the physical reality better than pretending all devices
are on the platform bus.

It follows the model that non-device tree systems use.  For example,
why should a usb device show up under /sys/bus/platform/ instead of
under /sys/bus/usb/ ?  (I'm not positive this actually happens, but
let me pretend it would.)

> Another approach could be to support having multiple platform bus
> instances. Then drivers can easily create a new instance for each set
> of sub-devices.
> 
> This can be solved in a much less invasive way just in the DT naming
> algorithm. This is slightly different from what I had suggested of
> just dropping the unit address. It keeps the unit address, but adds
> the unique index on untranslate-able addresses. The diff is bigger due
> to refactoring to reduce the indentation levels. It is untested and
> whitespace corrupted:
> 
> diff --git a/drivers/of/platform.c b/drivers/of/platform.c
> index 404d1da..c77dd7a 100644
> --- a/drivers/of/platform.c
> +++ b/drivers/of/platform.c
> @@ -105,23 +105,33 @@ void of_device_make_bus_id(struct device *dev)
>          * For MMIO, get the physical address
>          */
>         reg = of_get_property(node, "reg", NULL);
> -       if (reg) {
> -               if (of_can_translate_address(node)) {
> -                       addr = of_translate_address(node, reg);
> -               } else {
> -                       addrp = of_get_address(node, 0, NULL, NULL);
> -                       if (addrp)
> -                               addr = of_read_number(addrp, 1);
> -                       else
> -                               addr = OF_BAD_ADDR;
> -               }
> -               if (addr != OF_BAD_ADDR) {
> -                       dev_set_name(dev, "%llx.%s",
> -                                    (unsigned long long)addr, node->name);
> -                       return;
> -               }
> +       if (!reg)
> +               goto no_bus_id;
> +
> +       if (of_can_translate_address(node)) {
> +               addr = of_translate_address(node, reg);
> +               if (addr == OF_BAD_ADDR)
> +                       goto no_bus_id;
> +
> +               dev_set_name(dev, "%llx.%s",
> +                            (unsigned long long)addr, node->name);
> +               return;
>         }
> 
> +       addrp = of_get_address(node, 0, NULL, NULL);
> +       if (!addrp)
> +               goto no_bus_id;
> +
> +       addr = of_read_number(addrp, 1);
> +       if (addr == OF_BAD_ADDR)
> +               goto no_bus_id;
> +
> +       magic = atomic_add_return(1, &bus_no_reg_magic);
> +       dev_set_name(dev, "%llx.%s.%d", (unsigned long long)addr,
> +                    node->name, magic - 1);
> +       return;
> +
> +no_bus_id:
>         /*
>          * No BusID, use the node name and add a globally incremented
>          * counter (and pray...)
> 

I think the refactored code is easier to read.  (End of bike shed...)

The result of that patch is an even uglier set of device names.  I would love to get rid of
the bus_no_reg_magic instead of making more extensive use of it.  The new names for the
system that started this discussion are:

$ ls /sys/devices/soc.2/fc4cf000.qcom,spmi/spmi-0/0-00/
100.qcom,revid.19            gpios.21
3100.qcom,pm8x41-adc-usr.20  power
6000.qcom,rtc.18             subsystem
driver                       uevent

$ ls /sys/bus/platform/devices/soc.2/fc4cf000.qcom,spmi/spmi-0/0-00/
100.qcom,revid.19            gpios.21
3100.qcom,pm8x41-adc-usr.20  power
6000.qcom,rtc.18             subsystem
driver                       uevent

$ ls /sys/bus/platform/devices/soc.2/fc4cf000.qcom,spmi/spmi-0/0-01/
b040.pm8xxx-pwm.22      driver                  uevent
d000.pm8xxx-pwm-led.23  power
d800.pm8xxx-wled.24     subsystem

$ ls /sys/bus/platform/devices/soc.2/fc4cf000.qcom,spmi/spmi-0/0-04/
100.qcom,revid.25  power              uevent
driver             subsystem

$ ls /sys/bus/platform/devices/
100.qcom,revid.19              fc4ab000.restart
100.qcom,revid.25              fc4cf000.qcom,spmi
3100.qcom,pm8x41-adc-usr.20    fd484000.hwlock
6000.qcom,rtc.18               fd510000.pinctrl
alarmtimer                     fd8c0000.clock-controller
b040.pm8xxx-pwm.22             gpio_keys.5
cpu-pmu.1                      gpios.21
cpus.0                         iio-thermal.4
d000.pm8xxx-pwm-led.23         pm8841-s1.6
d800.pm8xxx-wled.24            pm8841-s2.7
f9000000.interrupt-controller  pm8941-l3.11
f9011000.smem                  pm8941-l6.12
f9012000.regulator             reg-dummy
f9020000.timer                 regulator-l11.14
f9088000.clock-controller      regulator-l19.15
f9098000.clock-controller      regulator-l20.16
f90a8000.clock-controller      regulator-l22.17
f90b8000.clock-controller      regulator-l9.13
f9824900.sdhc                  regulator-s1.8
f991e000.serial                regulator-s2.9
f9924000.i2c2                  regulator-s3.10
f9928000.i2c6                  regulatory.0
f9bff000.rng                   snd-soc-dummy
fc400000.clock-controller      soc.2
fc4281d0.qcom,mpm              timer.3

