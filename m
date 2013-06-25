Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751539Ab3FYRkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 13:40:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38021 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab3FYRke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 13:40:34 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Haojian Zhuang <haojian.zhuang@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <CAD6h2NS=AOQ4B6V=TtA120ga9ucF7eBxEguqFK0y4cfpa-F50Q@mail.gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        =?utf-8?q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Matt Sealey <neko@bakuhatsu.net>, Stephen Boyd <sboyd@codeaurora.org>,
        Tero Kristo <t-kristo@ti.com>
References: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
 <1371795256-16703-4-git-send-email-mturquette@linaro.org>
 <CAD6h2NS=AOQ4B6V=TtA120ga9ucF7eBxEguqFK0y4cfpa-F50Q@mail.gmail.com>
Message-ID: <20130625174030.23972.40841@quantum>
User-Agent: alot/0.3.4
Subject: Re: [PATCH v3 3/5] clk: dt: binding for basic multiplexer clock
Date: Tue, 25 Jun 2013 10:40:30 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Haojian Zhuang (2013-06-25 01:27:58)
> On 21 June 2013 14:14, Mike Turquette <mturquette@linaro.org> wrote:
> > Device Tree binding for the basic clock multiplexer, plus the setup
> > function to register the clock.  Based on the existing fixed-clock
> > binding.
> >
> > Includes minor beautification of clk-provider.h where some whitespace is
> > added and of_fixed_factor_clock_setup is relocated to maintain a
> > consistent style.
> >
> > Tero Kristo contributed helpful bug fixes to this patch.
> >
> > Signed-off-by: Mike Turquette <mturquette@linaro.org>
> > ---
> > Changes since v2:
> > * added hiword-mask property to the binding
> > * changed bit-shift property from u8 to u32 in the dt binding
> >
> > Changes since v1:
> > * pass shift value into clk_register_mux_table
> > * s/multiplexor/multiplexer/
> > * removed debug prints
> > * mask is u32, shift is u8
> > * DT property names use dashes instead of underscores
> > * DT property names are more verbose
> > * shift property is optional in binding and can be auto-generated from a
> >   full 32-bit mask
> >
> >  .../devicetree/bindings/clock/mux-clock.txt        | 79 ++++++++++++++++++++++
> >  drivers/clk/clk-mux.c                              | 65 +++++++++++++++++-
> >  include/linux/clk-provider.h                       |  5 +-
> >  3 files changed, 147 insertions(+), 2 deletions(-)
> >  create mode 100644 Documentation/devicetree/bindings/clock/mux-clock.txt
> >
> > diff --git a/Documentation/devicetree/bindings/clock/mux-clock.txt b/Documentation/devicetree/bindings/clock/mux-clock.txt
> > new file mode 100644
> > index 0000000..54cb8d1
> > --- /dev/null
> > +++ b/Documentation/devicetree/bindings/clock/mux-clock.txt
> > @@ -0,0 +1,79 @@
> > +Binding for simple mux clock.
> > +
> > +This binding uses the common clock binding[1].  It assumes a
> > +register-mapped multiplexer with multiple input clock signals or
> > +parents, one of which can be selected as output.  This clock does not
> > +gate or adjust the parent rate via a divider or multiplier.
> > +
> > +By default the "clocks" property lists the parents in the same order
> > +as they are programmed into the regster.  E.g:
> > +
> > +       clocks = <&foo_clock>, <&bar_clock>, <&baz_clock>;
> > +
> > +results in programming the register as follows:
> > +
> > +register value         selected parent clock
> > +0                      foo_clock
> > +1                      bar_clock
> > +2                      baz_clock
> > +
> > +Some clock controller IPs do not allow a value of zero to be programmed
> > +into the register, instead indexing begins at 1.  The optional property
> > +"index_one" modified the scheme as follows:
> > +
> > +register value         selected clock parent
> > +1                      foo_clock
> > +2                      bar_clock
> > +3                      baz_clock
> > +
> > +Additionally an optional table of bit and parent pairs may be supplied
> > +like so:
> > +
> > +       table = <&foo_clock 0x0>, <&bar_clock, 0x2>, <&baz_clock, 0x4>;
> > +
> > +where the first value in the pair is the parent clock and the second
> > +value is the bitfield to be programmed into the register.
> > +
> > +The binding must provide the register to control the mux and the mask
> > +for the corresponding control bits.  Optionally the number of bits to
> > +shift that mask if necessary.  If the shift value is missing it is the
> > +same as supplying a zero shift.
> > +
> > +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> > +
> > +Required properties:
> > +- compatible : shall be "mux-clock".
> > +- #clock-cells : from common clock binding; shall be set to 0.
> > +- clocks : link phandles of parent clocks
> > +- reg : base address for register controlling adjustable mux
> > +- bit-mask : arbitrary bitmask for programming the adjustable mux
> > +
> > +Optional properties:
> > +- clock-output-names : From common clock binding.
> > +- table : array of integer pairs defining parents & bitfield values
> > +- bit-shift : number of bits to shift the bit-mask, defaults to
> > +  (ffs(mask) - 1) if not present
> > +- index-starts-at-one : valid input select programming starts at 1, not
> > +  zero
> > +- hiword-mask : lower half of the register programs the mux, upper half
> > +  of the register indicates bits that were updated in the lower half
> > +
> > +Examples:
> > +       clock: clock@4a008100 {
> > +               compatible = "mux-clock";
> > +               #clock-cells = <0>;
> > +               clocks = <&clock_foo>, <&clock_bar>, <&clock_baz>;
> > +               reg = <0x4a008100 0x4>
> > +               mask = <0x3>;
> > +               index_one;
> > +       };
> > +
> > +       clock: clock@4a008100 {
> > +               #clock-cells = <0>;
> > +               compatible = "mux-clock";
> > +               clocks = <&clock_foo>, <&clock_bar>, <&clock_baz>;
> > +               reg = <0x4a008100 0x4>;
> > +               mask = <0x3>;
> > +               shift = <0>;
> > +               table = <&clock_foo 1>, <&clock_bar 2>, <&clock_baz 3>;
> > +       };
> > diff --git a/drivers/clk/clk-mux.c b/drivers/clk/clk-mux.c
> > index 614444c..4751bce 100644
> > --- a/drivers/clk/clk-mux.c
> > +++ b/drivers/clk/clk-mux.c
> > @@ -1,7 +1,7 @@
> >  /*
> >   * Copyright (C) 2011 Sascha Hauer, Pengutronix <s.hauer@pengutronix.de>
> >   * Copyright (C) 2011 Richard Zhao, Linaro <richard.zhao@linaro.org>
> > - * Copyright (C) 2011-2012 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
> > + * Copyright (C) 2011-2013 Mike Turquette, Linaro Ltd <mturquette@linaro.org>
> >   *
> >   * This program is free software; you can redistribute it and/or modify
> >   * it under the terms of the GNU General Public License version 2 as
> > @@ -16,6 +16,8 @@
> >  #include <linux/slab.h>
> >  #include <linux/io.h>
> >  #include <linux/err.h>
> > +#include <linux/of.h>
> > +#include <linux/of_address.h>
> >
> >  /*
> >   * DOC: basic adjustable multiplexer clock that cannot gate
> > @@ -166,3 +168,64 @@ struct clk *clk_register_mux(struct device *dev, const char *name,
> >                                       flags, reg, shift, mask, clk_mux_flags,
> >                                       NULL, lock);
> >  }
> > +
> > +#ifdef CONFIG_OF
> > +/**
> > + * of_mux_clk_setup() - Setup function for simple mux rate clock
> > + */
> > +void of_mux_clk_setup(struct device_node *node)
> > +{
> > +       struct clk *clk;
> > +       const char *clk_name = node->name;
> > +       void __iomem *reg;
> > +       int num_parents;
> > +       const char **parent_names;
> > +       int i;
> > +       u8 clk_mux_flags = 0;
> > +       u32 mask = 0;
> > +       u32 shift = 0;
> > +
> > +       of_property_read_string(node, "clock-output-names", &clk_name);
> > +
> > +       num_parents = of_clk_get_parent_count(node);
> > +       if (num_parents < 1) {
> > +               pr_err("%s: mux-clock %s must have parent(s)\n",
> > +                               __func__, node->name);
> > +               return;
> > +       }
> > +
> > +       parent_names = kzalloc((sizeof(char*) * num_parents),
> > +                       GFP_KERNEL);
> > +
> > +       for (i = 0; i < num_parents; i++)
> > +               parent_names[i] = of_clk_get_parent_name(node, i);
> > +
> > +       reg = of_iomap(node, 0);
> 
> As you mentioned above,  reg : base address for register controlling
> adjustable mux.
> 
> Each clock node has the reg property. It means that we have to
> allocate one page memory
> for each register since of_iomap() is used at here. We always have
> lots of registers with
> continuous address in SoC, like 0x40a00040, 0x40a00044, .... Then
> we'll waste too much
> memory in system.
> 
> How about only define common function to parse property? Make register
> mapping handled
> by vendor's clock driver.

This is probably a good idea. It is independent of the binding though.
The reg property can still be used as described above and however the OS
interacts with it is an implementation detail that can be sorted out
later.

I'll look into your suggestion though, since it could save some memory.

Regards,
Mike

> 
> Regards
> Haojian
