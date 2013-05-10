Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755198Ab3EJXB2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 19:01:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:45714 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3EJXB0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 19:01:26 -0400
X-IronPort-AV: E=Sophos;i="4.87,651,1363158000"; 
   d="scan'208";a="46284568"
Message-ID: <518D7C45.2090602@codeaurora.org>
Date: Fri, 10 May 2013 16:01:25 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mike Turquette <mturquette@linaro.org>
CC: =?ISO-8859-1?Q?Emilio_L=F3pez?= <emilio@elopez.com.ar>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>
Subject: Re: [PATCH RFC] clk: Introduce userspace clock driver
References: <1368207091-32538-1-git-send-email-soren.brinkmann@xilinx.com> <1368207091-32538-2-git-send-email-soren.brinkmann@xilinx.com> <518D320C.4010707@elopez.com.ar> <fe9e603e-a432-4a29-a195-fd393b875a7e@TX2EHSMHS006.ehs.local> <518D411D.9070209@elopez.com.ar> <CAPtuhTgsP4gvMAFoQb3icXAZw3ucSg4dfrAdJMho-VxNmNTvwg@mail.gmail.com>
In-Reply-To: <CAPtuhTgsP4gvMAFoQb3icXAZw3ucSg4dfrAdJMho-VxNmNTvwg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/10/2013 03:18 PM, Mike Turquette wrote:
> On Fri, May 10, 2013 at 11:49 AM, Emilio López <emilio@elopez.com.ar> wrote:
>> Hi,
>>
>> El 10/05/13 15:15, Sören Brinkmann escribió:
>>> Hi Emilio,
>>>
>>> On Fri, May 10, 2013 at 02:44:44PM -0300, Emilio López wrote:
>>>> Hi,
>>>>
>>>> El 10/05/13 14:31, Soren Brinkmann escribió:
>>>>> The userspace clock driver can be used to expose clock controls through
>>>>> sysfs to userspace. The driver creates entries in /sys/class/clk.
>>>>>
>>>>> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
>>>>> ---
>>>>>   .../devicetree/bindings/clock/clk-userspace.txt    |   7 +
>>>>>   drivers/clk/Kconfig                                |   9 ++
>>>>>   drivers/clk/Makefile                               |   1 +
>>>>>   drivers/clk/clk-userspace.c                        | 169 +++++++++++++++++++++
>>>>>   4 files changed, 186 insertions(+)
>>>>>   create mode 100644 Documentation/devicetree/bindings/clock/clk-userspace.txt
>>>>>   create mode 100644 drivers/clk/clk-userspace.c
>>>>>
>>>>> diff --git a/Documentation/devicetree/bindings/clock/clk-userspace.txt b/Documentation/devicetree/bindings/clock/clk-userspace.txt
>>>>> new file mode 100644
>>>>> index 0000000..2d153c7
>>>>> --- /dev/null
>>>>> +++ b/Documentation/devicetree/bindings/clock/clk-userspace.txt
>>>>> @@ -0,0 +1,7 @@
>>>>> +
>>>>> +Example:
>>>>> +   usclk: usclk {
>>>>> +           compatible = "clk-userspace";
>>>>> +           clocks = <&foo 15>, <&bar>;
>>>>> +           clock-count = <2>;
>>>>> +   };
>>>>
>>>> Does this belong on DT? It isn't describing hardware, is it?
>>> I guess, strictly speaking you are right. Do you have a good
>>> alternative?
>>
>> If this was part of the framework instead of a consumer, I suppose a
>> flag on the DT node defining the clock that indicates it should be
>> exported would be acceptable.
>>
>> Another possibility would be letting the user export what they need,
>> like GPIO does, see "Paths in Sysfs" in
>>
>> https://www.kernel.org/doc/Documentation/gpio.txt
>>
>>>>> diff --git a/drivers/clk/Kconfig b/drivers/clk/Kconfig
>>>>> index 0357ac4..b35b62c 100644
>>>>> --- a/drivers/clk/Kconfig
>>>>> +++ b/drivers/clk/Kconfig
>>>>> @@ -81,6 +81,15 @@ config COMMON_CLK_AXI_CLKGEN
>>>>>        Support for the Analog Devices axi-clkgen pcore clock generator for Xilinx
>>>>>        FPGAs. It is commonly used in Analog Devices' reference designs.
>>>>>
>>>>> +config COMMON_CLK_USERSPACE
>>>>> +   bool "Userspace Clock Controls"
>>>>> +   depends on OF
>>>>> +   depends on SYSFS
>>>>> +   help
>>>>> +   ---help---
>>>>> +     Expose clock controls through sysfs to userspace. Clocks are selected
>>>>> +     through the device tree and the controls are exposed in
>>>>> +     /sys/class/clk.
>>>>>   endmenu
>>>>>
>>>>>   source "drivers/clk/mvebu/Kconfig"
>>>>> diff --git a/drivers/clk/Makefile b/drivers/clk/Makefile
>>>>> index fa435bc..f2f68c8 100644
>>>>> --- a/drivers/clk/Makefile
>>>>> +++ b/drivers/clk/Makefile
>>>>> @@ -8,6 +8,7 @@ obj-$(CONFIG_COMMON_CLK)    += clk-fixed-rate.o
>>>>>   obj-$(CONFIG_COMMON_CLK)   += clk-gate.o
>>>>>   obj-$(CONFIG_COMMON_CLK)   += clk-mux.o
>>>>>   obj-$(CONFIG_COMMON_CLK)   += clk-composite.o
>>>>> +obj-$(CONFIG_COMMON_CLK_USERSPACE) += clk-userspace.o
>>>>>
>>>>>   # SoCs specific
>>>>>   obj-$(CONFIG_ARCH_BCM2835) += clk-bcm2835.o
>>>>> diff --git a/drivers/clk/clk-userspace.c b/drivers/clk/clk-userspace.c
>>>>> new file mode 100644
>>>>> index 0000000..931cf92
>>>>> --- /dev/null
>>>>> +++ b/drivers/clk/clk-userspace.c
>>>>> @@ -0,0 +1,169 @@
>>>>> +/*
>>>>> + * Userspace clock driver
>>>>> + *
>>>>> + *  Copyright (C) 2013 Xilinx
>>>>> + *
>>>>> + *  Sören Brinkmann <soren.brinkmann@xilinx.com>
>>>>> + *
>>>>> + * This program is free software: you can redistribute it and/or modify
>>>>> + * it under the terms of the GNU General Public License v2 as published by
>>>>> + * the Free Software Foundation.
>>>>> + *
>>>>> + * This program is distributed in the hope that it will be useful,
>>>>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>>>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>>>> + * GNU General Public License for more details.
>>>>> + *
>>>>> + * You should have received a copy of the GNU General Public License
>>>>> + * along with this program.  If not, see <http://www.gnu.org/licenses/>.
>>>>> + *
>>>>> + * Expose clock controls through sysfs to userspace.
>>>>> + *
>>>>> + * By writing 0/1 to 'enable' the clock can be disabled/enabled. Reading
>>>>> + * that file returns the current state - 0 = disabled, 1 = enabled.
>>>>> + *
>>>>> + * Reading 'set_rate' returns the current clock frequency in Hz. Writing
>>>>> + * the file requests setting a new frequency in Hz.
>>>>> + */
>>>>> +
>>>>> +#include <linux/clk-provider.h>
>>>>> +#include <linux/fs.h>
>>>>> +#include <linux/module.h>
>>>>> +#include <linux/of.h>
>>>>> +#include <linux/device.h>
>>>>> +#include <linux/slab.h>
>>>>> +
>>>>> +#define DRIVER_NAME        "clk-userspace"
>>>>> +
>>>>> +struct usclk_data {
>>>>> +   struct clk *clk;
>>>>> +   int enabled;
>>>>> +};
>>>>> +
>>>>> +static ssize_t enable_show(struct device *dev, struct device_attribute *attr,
>>>>> +           char *buf)
>>>>> +{
>>>>> +   struct usclk_data *pdata = dev_get_drvdata(dev);
>>>>> +
>>>>> +   return scnprintf(buf, PAGE_SIZE, "%u\n", pdata->enabled);
>>>>> +}
>>>>> +
>>>>> +static ssize_t enable_store(struct device *dev, struct device_attribute *attr,
>>>>> +           const char *buf, size_t count)
>>>>> +{
>>>>> +   unsigned long enable;
>>>>> +   int ret;
>>>>> +   struct usclk_data *pdata = dev_get_drvdata(dev);
>>>>> +
>>>>> +   ret = kstrtoul(buf, 0, &enable);
>>>>> +   if (ret)
>>>>> +           return -EINVAL;
>>>>> +
>>>>> +   enable = !!enable;
>>>>> +   if (enable == pdata->enabled)
>>>>> +           return count;
>>>>> +
>>>>> +   if (enable)
>>>>> +           ret = clk_prepare_enable(pdata->clk);
>>>>> +   else
>>>>> +           clk_disable_unprepare(pdata->clk);
>>>>> +
>>>>> +   if (ret)
>>>>> +           return -EBUSY;
>>>>> +
>>>>> +   pdata->enabled = enable;
>>>>> +   return count;
>>>>> +}
>>>>> +
>>>>> +static DEVICE_ATTR(enable, 0644, enable_show, enable_store);
>>>>> +
>>>>> +static ssize_t set_rate_show(struct device *dev, struct device_attribute *attr,
>>>>> +           char *buf)
>>>>> +{
>>>>> +   struct usclk_data *pdata = dev_get_drvdata(dev);
>>>>> +
>>>>> +   return scnprintf(buf, PAGE_SIZE, "%lu\n", clk_get_rate(pdata->clk));
>>>>> +}
>>>>> +
>>>>> +static ssize_t set_rate_store(struct device *dev, struct device_attribute *attr,
>>>>> +           const char *buf, size_t count)
>>>>> +{
>>>>> +   int ret = 0;
>>>>> +   unsigned long rate;
>>>>> +   struct usclk_data *pdata = dev_get_drvdata(dev);
>>>>> +
>>>>> +   ret = kstrtoul(buf, 0, &rate);
>>>>> +   if (ret)
>>>>> +           return -EINVAL;
>>>>> +
>>>>> +   rate = clk_round_rate(pdata->clk, rate);
>>>>> +   ret = clk_set_rate(pdata->clk, rate);
>>>>> +   if (ret)
>>>>> +           return -EBUSY;
>>>>> +
>>>>> +   return count;
>>>>> +}
>>>>> +
>>>>> +static DEVICE_ATTR(set_rate, 0644, set_rate_show, set_rate_store);
>>>>> +
>>>>> +static const struct attribute *usclk_attrs[] = {
>>>>> +   &dev_attr_enable.attr,
>>>>> +   &dev_attr_set_rate.attr,
>>>>> +   NULL
>>>>> +};
>>>>
>>>> For debugging purposes, being able to change parents would be nice too.
>>> This is difficult and I don't have a good solution for it, hence it's
>>> missing. A clock consumer like a device driver or this driver, just
>>> knows about it's input clock, but not about the topology further up.
>>> Therefore it is pretty much impossible to implement reparent operations
>>> in a clock consumer, IMHO.
>>> IOW: For a given input clock, how do you figure out it's possible
>>> parents?
>>
>> The parent is just a number
>>
>> int (*set_parent)(struct clk_hw *hw, u8 index);
>> u8 (*get_parent)(struct clk_hw *hw);
>>
>> If you are debugging, you know what the possible parents are, and you
>> can reparent with that information.
>>
>> After checking the clk code however, I didn't find any exposed way to
>> reparent with just the parent indexes. Maybe an interface that takes a n
>> arbitrary string representing the parent name, and gets that clock and
>> then sets the parent would fit.
>>
>>>
>>>> Maybe this belongs to debugfs instead of sysfs though.
>>> Well, the more generic use-case probably. My Zynq use-case rather not,
>>> IMHO.
>>
>> The framework already exposes some information on debugfs, maybe
>> expanding that instead of implementing it as a consumer on sysfs would
>> be best for the debugging use case. @Mike, what's your thoughts on this?
>>
>
> In the previous thread on this topic we discussed a generic approach
> to exposing clock controls via debugfs.
>
> One way to do it is to introduce a new config option,
> CONFIG_COMMON_CLK_DEBUG_CONTROL that would expose the controls for
> every clock in the existing debugfs infrastructure.  The downside to
> this approach is that it would get abused and ship in millions of
> Android products using horrible userspace hacks to control clocks.
> Maybe that's not our problem to solve, maybe it is.

We already have this for MSM. But I seem to have managed to keep our 
userspace guys away from abusing it. YMMV.

> If CONFIG_COMMON_CLK_DEBUG_CONTROL existed it might be a good idea to
> intentionally break the abi compatibility with every new release.
> That would certainly reinforce that this is not a condoned or stable
> api (which is true for all debugfs).

+1 if we can do this. Just in a minor way so that we don't end up making 
it unusable for humans. We also have userspace test scripts for that 
that we can try to upstream (I can't guarantees) -- so we can't go all 
crazy when we do the intentional ABI breaking. We could make them 
root-only in hopes of discouraging abuse of the API. In the sense, using 
this API introduces security concerns because their userspace will be 
running as root.

> I think that Soren wants something with a stable interface that he can
> use for his Zynq use case.  Regarding that, why not write an actual
> device driver to do what you want to do from userspace?

Exposing clock control to userspace production use is a terrible idea. A 
misbehaving userspace can easily kill the system. This is not so try for 
GPIO. So, exposing GPIOs to userspace is relatively less of a concern.

-Saravana
-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
