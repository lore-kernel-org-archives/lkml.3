Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab3H3UCb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 16:02:31 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:33428 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab3H3UC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 16:02:29 -0400
Subject: Re: [PATCH v4 3/5] clk: dt: binding for basic multiplexer clock
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <20130829011425.8231.78802@quantum>
Date: Fri, 30 Aug 2013 15:02:42 -0500
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Tero Kristo <t-kristo@ti.com>,
        =?iso-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        devicetree@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <39BAF1F8-41AD-4667-BF76-22BDF709415A@codeaurora.org>
References: <1377150793-27864-1-git-send-email-mturquette@linaro.org> <1377150793-27864-4-git-send-email-mturquette@linaro.org> <2A930389-012E-45C3-93EB-6B4A41DB2EF5@codeaurora.org> <20130829011425.8231.78802@quantum>
To: Mike Turquette <mturquette@linaro.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 28, 2013, at 8:14 PM, Mike Turquette wrote:

> Quoting Kumar Gala (2013-08-28 08:50:10)
>> On Aug 22, 2013, at 12:53 AM, Mike Turquette wrote:
>> 
>>> Device Tree binding for the basic clock multiplexer, plus the setup
>>> function to register the clock.  Based on the existing fixed-clock
>>> binding.
>>> 
>>> Includes minor beautification of clk-provider.h where some whitespace is
>>> added and of_fixed_factor_clock_setup is relocated to maintain a
>>> consistent style.
>>> 
>>> Tero Kristo contributed helpful bug fixes to this patch.
>>> 
>>> Signed-off-by: Mike Turquette <mturquette@linaro.org>
>>> Tested-by: Heiko Stuebner <heiko@sntech.de>
>>> Reviewed-by: Heiko Stuebner <heiko@sntech.de>
>>> ---
>>> Changes since v3:
>>> * replaced underscores with dashes in DT property names
>>> * bail from of clock setup function early if of_iomap fails
>>> * removed unecessary explict cast
>>> 
>>> .../devicetree/bindings/clock/mux-clock.txt        | 79 ++++++++++++++++++++++
>>> drivers/clk/clk-mux.c                              | 68 ++++++++++++++++++-
>>> include/linux/clk-provider.h                       |  5 +-
>>> 3 files changed, 150 insertions(+), 2 deletions(-)
>>> create mode 100644 Documentation/devicetree/bindings/clock/mux-clock.txt
>>> 
>>> diff --git a/Documentation/devicetree/bindings/clock/mux-clock.txt b/Documentation/devicetree/bindings/clock/mux-clock.txt
>>> new file mode 100644
>>> index 0000000..21eb3b3
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/clock/mux-clock.txt
>>> @@ -0,0 +1,79 @@
>>> +Binding for simple mux clock.
>>> +
>>> +This binding uses the common clock binding[1].  It assumes a
>>> +register-mapped multiplexer with multiple input clock signals or
>>> +parents, one of which can be selected as output.  This clock does not
>>> +gate or adjust the parent rate via a divider or multiplier.
>>> +
>>> +By default the "clocks" property lists the parents in the same order
>>> +as they are programmed into the regster.  E.g:
>>> +
>>> +     clocks = <&foo_clock>, <&bar_clock>, <&baz_clock>;
>>> +
>>> +results in programming the register as follows:
>>> +
>>> +register value               selected parent clock
>>> +0                    foo_clock
>>> +1                    bar_clock
>>> +2                    baz_clock
>>> +
>>> +Some clock controller IPs do not allow a value of zero to be programmed
>>> +into the register, instead indexing begins at 1.  The optional property
>>> +"index-starts-at-one" modified the scheme as follows:
>>> +
>>> +register value               selected clock parent
>>> +1                    foo_clock
>>> +2                    bar_clock
>>> +3                    baz_clock
>>> +
>>> +Additionally an optional table of bit and parent pairs may be supplied
>>> +like so:
>>> +
>>> +     table = <&foo_clock 0x0>, <&bar_clock, 0x2>, <&baz_clock, 0x4>;
>>> +
>> 
>> I think this is going way too far for what should be in a device tree.  Why should this not just be encoded in tables in the code?
> 
> To reduce kernel data bloat.

Why is this really an issue, for systems that are concerned about kernel size, they are going to be built targeting the HW platform of choice, for one's like a server, the bloat isn't going to be significant, and if so we can look at mechanisms like __init section that would free up after boot.

> The mux-clock binding covers a quite a few platforms that have similar
> mux-clock programming requirements. If the DT binding is verbose enough
> then the basic mux clock driver is sufficient to initialize all of the
> mux clocks from DT: no new platform-specific clock driver with a bunch
> of data is necessary.

The same could be said of just embedded this info in a C struct that is well known, I don't need the data in the dt for bits and shifts.

> On the other hand if we rely on tables in C to define how mux-clock
> parents are selected then every platform will have to write their own
> clock driver just to define their clock data.

Why?  If you can have a common mechanism in the device tree there isn't any reason you can't have a common struct that looks similar in C.

> Having drivers written for the sole purpose of listing out a bunch of
> data sounds like something that DT was meant to solve, even if this
> isn't at the board level and is at the SoC level.

I just don't see the need for the data to be in the DT.  You can get the same goal w/a standard struct defined in C.

> 
> Regards,
> Mike
> 
>> 
>>> +where the first value in the pair is the parent clock and the second
>>> +value is the bitfield to be programmed into the register.
>>> +
>>> +The binding must provide the register to control the mux and the mask
>>> +for the corresponding control bits.  Optionally the number of bits to
>>> +shift that mask if necessary.  If the shift value is missing it is the
>>> +same as supplying a zero shift.
>>> +
>>> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
>>> +
>>> +Required properties:
>>> +- compatible : shall be "mux-clock".
>>> +- #clock-cells : from common clock binding; shall be set to 0.
>>> +- clocks : link phandles of parent clocks
>>> +- reg : base address for register controlling adjustable mux
>>> +- bit-mask : arbitrary bitmask for programming the adjustable mux
>>> +
>>> +Optional properties:
>>> +- clock-output-names : From common clock binding.
>>> +- table : array of integer pairs defining parents & bitfield values
>>> +- bit-shift : number of bits to shift the bit-mask, defaults to
>>> +  (ffs(mask) - 1) if not present
>>> +- index-starts-at-one : valid input select programming starts at 1, not
>>> +  zero
>>> +- hiword-mask : lower half of the register programs the mux, upper half
>>> +  of the register indicates bits that were updated in the lower half
>>> +
>>> +Examples:
>>> +     clock: clock@4a008100 {
>>> +             compatible = "mux-clock";
>>> +             #clock-cells = <0>;
>>> +             clocks = <&clock_foo>, <&clock_bar>, <&clock_baz>;
>>> +             reg = <0x4a008100 0x4>
>>> +             mask = <0x3>;
>>> +             index-starts-at-one;
>>> +     };
>>> +
>>> +     clock: clock@4a008100 {
>>> +             #clock-cells = <0>;
>>> +             compatible = "mux-clock";
>>> +             clocks = <&clock_foo>, <&clock_bar>, <&clock_baz>;
>>> +             reg = <0x4a008100 0x4>;
>>> +             mask = <0x3>;
>>> +             shift = <0>;
>>> +             table = <&clock_foo 1>, <&clock_bar 2>, <&clock_baz 3>;
>>> +     };
>>> diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
>>> index 0811633..9292253 100644
>>> --- a/drivers/clk/clk-mux.c
>>> +++ b/drivers/clk/clk-mux.c
>>> @@ -1,7 +1,7 @@
>>> /*
>>> * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
>>> * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
>>> - * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
>>> + * Copyright (C) 2011-2013 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
>>> *
>>> * This program is free software; you can redistribute it and/or modify
>>> * it under the terms of the GNU General Public License version 2 as
>>> @@ -16,6 +16,8 @@
>>> #include <linux/slab.h>
>>> #include <linux/io.h>
>>> #include <linux/err.h>
>>> +#include <linux/of.h>
>>> +#include <linux/of_address.h>
>>> 
>>> /*
>>> * DOC: basic adjustable multiplexer clock that cannot gate
>>> @@ -177,3 +179,67 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
>>>                                    NULL, lock);
>>> }
>>> EXPORT_SYMBOL_GPL(clk_register_mux);
>>> +
>>> +#ifdef CONFIG_OF
>>> +/**
>>> + * of_mux_clk_setup() - Setup function for simple mux rate clock
>>> + */
>>> +void of_mux_clk_setup(struct device_node *node)
>>> +{
>>> +     struct clk *clk;
>>> +     const char *clk_name = node->name;
>>> +     void __iomem *reg;
>>> +     int num_parents;
>>> +     const char **parent_names;
>>> +     int i;
>>> +     u8 clk_mux_flags = 0;
>>> +     u32 mask = 0;
>>> +     u32 shift = 0;
>>> +
>>> +     of_property_read_string(node, "clock-output-names", &clk_name);
>>> +
>>> +     num_parents = of_clk_get_parent_count(node);
>>> +     if (num_parents < 1) {
>>> +             pr_err("%s: mux-clock %s must have parent(s)\n",
>>> +                             __func__, node->name);
>>> +             return;
>>> +     }
>>> +
>>> +     parent_names = kzalloc((sizeof(char*) * num_parents),
>>> +                     GFP_KERNEL);
>>> +
>>> +     for (i = 0; i < num_parents; i++)
>>> +             parent_names[i] = of_clk_get_parent_name(node, i);
>>> +
>>> +     reg = of_iomap(node, 0);
>>> +     if (!reg) {
>>> +             pr_err("%s: no memory mapped for property reg\n", __func__);
>>> +             return;
>>> +     }
>>> +
>>> +     if (of_property_read_u32(node, "bit-mask", &mask)) {
>>> +             pr_err("%s: missing bit-mask property for %s\n", __func__, node->name);
>>> +             return;
>>> +     }
>>> +
>>> +     if (of_property_read_u32(node, "bit-shift", &shift)) {
>>> +             shift = __ffs(mask);
>>> +             pr_debug("%s: bit-shift property defaults to 0x%x for %s\n",
>>> +                             __func__, shift, node->name);
>>> +     }
>>> +
>>> +     if (of_property_read_bool(node, "index-starts-at-one"))
>>> +             clk_mux_flags |= CLK_MUX_INDEX_ONE;
>>> +
>>> +     if (of_property_read_bool(node, "hiword-mask"))
>>> +             clk_mux_flags |= CLK_MUX_HIWORD_MASK;
>>> +
>>> +     clk = clk_register_mux_table(NULL, clk_name, parent_names, num_parents,
>>> +                     0, reg, shift, mask, clk_mux_flags, NULL, NULL);
>>> +
>>> +     if (!IS_ERR(clk))
>>> +             of_clk_add_provider(node, of_clk_src_simple_get, clk);
>>> +}
>>> +EXPORT_SYMBOL_GPL(of_mux_clk_setup);
>>> +CLK_OF_DECLARE(mux_clk, "mux-clock", of_mux_clk_setup);
>>> +#endif
>>> diff --git a/include/linux/clk-provider.h b/include/linux/clk-provider.h
>>> index 5497739..e019212 100644
>>> --- a/include/linux/clk-provider.h
>>> +++ b/include/linux/clk-provider.h
>>> @@ -350,7 +350,7 @@ struct clk *clk_register_mux_table(struct device *dev, const char *name,
>>>              void __iomem *reg, u8 shift, u32 mask,
>>>              u8 clk_mux_flags, u32 *table, spinlock_t *lock);
>>> 
>>> -void of_fixed_factor_clk_setup(struct device_node *node);
>>> +void of_mux_clk_setup(struct device_node *node);
>>> 
>>> /**
>>> * struct clk_fixed_factor - fixed multiplier and divider clock
>>> @@ -371,10 +371,13 @@ struct clk_fixed_factor {
>>> };
>>> 
>>> extern struct clk_ops clk_fixed_factor_ops;
>>> +
>>> struct clk *clk_register_fixed_factor(struct device *dev, const char *name,
>>>              const char *parent_name, unsigned long flags,
>>>              unsigned int mult, unsigned int div);
>>> 
>>> +void of_fixed_factor_clk_setup(struct device_node *node);
>>> +
>>> /***
>>> * struct clk_composite - aggregate clock of mux, divider and gate clocks
>>> *
>>> -- 
>>> 1.8.1.2
>>> 
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe devicetree" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> 
>> -- 
>> Employee of Qualcomm Innovation Center, Inc.
>> Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

