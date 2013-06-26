Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3FZIp5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:45:57 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48104 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752067Ab3FZIpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:45:54 -0400
Date: Wed, 26 Jun 2013 09:40:58 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Mike Turquette <mturquette@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Tero Kristo <t-kristo@ti.com>,
        Haojian Zhuang <haojian.zhuang@linaro.org>,
        Matt Sealey <neko@bakuhatsu.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 3/5] clk: dt: binding for basic multiplexer clock
Message-ID: <20130626084058.GA10833@e106331-lin.cambridge.arm.com>
References: <1371795256-16703-1-git-send-email-mturquette@linaro.org>
 <1371795256-16703-4-git-send-email-mturquette@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371795256-16703-4-git-send-email-mturquette@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have a couple of minor comments.

On Fri, Jun 21, 2013 at 07:14:14AM +0100, Mike Turquette wrote:
> Device Tree binding for the basic clock multiplexer, plus the setup
> function to register the clock.  Based on the existing fixed-clock
> binding.
> 
> Includes minor beautification of clk-provider.h where some whitespace is
> added and of_fixed_factor_clock_setup is relocated to maintain a
> consistent style.
> 
> Tero Kristo contributed helpful bug fixes to this patch.
> 
> Signed-off-by: Mike Turquette <mturquette@linaro.org>
> ---
> Changes since v2:
> * added hiword-mask property to the binding
> * changed bit-shift property from u8 to u32 in the dt binding
> 
> Changes since v1:
> * pass shift value into clk_register_mux_table
> * s/multiplexor/multiplexer/
> * removed debug prints
> * mask is u32, shift is u8
> * DT property names use dashes instead of underscores
> * DT property names are more verbose
> * shift property is optional in binding and can be auto-generated from a
>   full 32-bit mask
> 
>  .../devicetree/bindings/clock/mux-clock.txt        | 79 ++++++++++++++++++++++
>  drivers/clk/clk-mux.c                              | 65 +++++++++++++++++-
>  include/linux/clk-provider.h                       |  5 +-
>  3 files changed, 147 insertions(+), 2 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/clock/mux-clock.txt
> 
> diff --git a/Documentation/devicetree/bindings/clock/mux-clock.txt b/Documentation/devicetree/bindings/clock/mux-clock.txt
> new file mode 100644
> index 0000000..54cb8d1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/clock/mux-clock.txt
> @@ -0,0 +1,79 @@
> +Binding for simple mux clock.
> +
> +This binding uses the common clock binding[1].  It assumes a
> +register-mapped multiplexer with multiple input clock signals or
> +parents, one of which can be selected as output.  This clock does not
> +gate or adjust the parent rate via a divider or multiplier.
> +
> +By default the "clocks" property lists the parents in the same order
> +as they are programmed into the regster.  E.g:
> +
> +	clocks = <&foo_clock>, <&bar_clock>, <&baz_clock>;
> +
> +results in programming the register as follows:
> +
> +register value		selected parent clock
> +0			foo_clock
> +1			bar_clock
> +2			baz_clock
> +
> +Some clock controller IPs do not allow a value of zero to be programmed
> +into the register, instead indexing begins at 1.  The optional property
> +"index_one" modified the scheme as follows:

I assume this is meant to be "index-starts-at-one", given the code and
changelog?

> +
> +register value		selected clock parent
> +1			foo_clock
> +2			bar_clock
> +3			baz_clock
> +
> +Additionally an optional table of bit and parent pairs may be supplied
> +like so:
> +
> +	table = <&foo_clock 0x0>, <&bar_clock, 0x2>, <&baz_clock, 0x4>;
> +
> +where the first value in the pair is the parent clock and the second
> +value is the bitfield to be programmed into the register.
> +
> +The binding must provide the register to control the mux and the mask
> +for the corresponding control bits.  Optionally the number of bits to
> +shift that mask if necessary.  If the shift value is missing it is the
> +same as supplying a zero shift.
> +
> +[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
> +
> +Required properties:
> +- compatible : shall be "mux-clock".
> +- #clock-cells : from common clock binding; shall be set to 0.
> +- clocks : link phandles of parent clocks
> +- reg : base address for register controlling adjustable mux
> +- bit-mask : arbitrary bitmask for programming the adjustable mux
> +
> +Optional properties:
> +- clock-output-names : From common clock binding.
> +- table : array of integer pairs defining parents & bitfield values
> +- bit-shift : number of bits to shift the bit-mask, defaults to
> +  (ffs(mask) - 1) if not present
> +- index-starts-at-one : valid input select programming starts at 1, not
> +  zero
> +- hiword-mask : lower half of the register programs the mux, upper half
> +  of the register indicates bits that were updated in the lower half
> +
> +Examples:
> +	clock: clock@4a008100 {
> +		compatible = "mux-clock";
> +		#clock-cells = <0>;
> +		clocks = <&clock_foo>, <&clock_bar>, <&clock_baz>;
> +		reg = <0x4a008100 0x4>
> +		mask = <0x3>;
> +		index_one;

And here too?

[...]

> +/**
> + * of_mux_clk_setup() - Setup function for simple mux rate clock
> + */
> +void of_mux_clk_setup(struct device_node *node)
> +{
> +	struct clk *clk;
> +	const char *clk_name = node->name;
> +	void __iomem *reg;
> +	int num_parents;
> +	const char **parent_names;
> +	int i;
> +	u8 clk_mux_flags = 0;
> +	u32 mask = 0;
> +	u32 shift = 0;
> +
> +	of_property_read_string(node, "clock-output-names", &clk_name);
> +
> +	num_parents = of_clk_get_parent_count(node);
> +	if (num_parents < 1) {
> +		pr_err("%s: mux-clock %s must have parent(s)\n",
> +				__func__, node->name);
> +		return;
> +	}
> +
> +	parent_names = kzalloc((sizeof(char*) * num_parents),
> +			GFP_KERNEL);
> +
> +	for (i = 0; i < num_parents; i++)
> +		parent_names[i] = of_clk_get_parent_name(node, i);
> +
> +	reg = of_iomap(node, 0);

Would it not be a good idea to check this isn't NULL before we pass it
to clk_register_mux_table later?

> +
> +	if (of_property_read_u32(node, "bit-mask", &mask)) {
> +		pr_err("%s: missing bit-mask property for %s\n", __func__, node->name);
> +		return;
> +	}
> +
> +	if (of_property_read_u32(node, "bit-shift", &shift)) {
> +		shift = __ffs(mask);
> +		pr_debug("%s: bit-shift property defaults to 0x%x for %s\n",
> +				__func__, shift, node->name);
> +	}
> +
> +	if (of_property_read_bool(node, "index-starts-at-one"))
> +		clk_mux_flags |= CLK_MUX_INDEX_ONE;
> +
> +	if (of_property_read_bool(node, "hiword-mask"))
> +		clk_mux_flags |= CLK_MUX_HIWORD_MASK;
> +
> +	clk = clk_register_mux_table(NULL, clk_name, parent_names, num_parents,
> +			0, reg, (u8) shift, mask, clk_mux_flags,
> +			NULL, NULL);

Why do you need the (u8) cast on shift? Isn't that implicit?

Thanks,
Mark.
