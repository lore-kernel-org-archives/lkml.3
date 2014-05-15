Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754683AbaEOHqW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 03:46:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52648 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753366AbaEOHqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 03:46:21 -0400
Date: Thu, 15 May 2014 09:46:17 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Jisheng Zhang <jszhang@marvell.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 07/10] clk: berlin: add core clock driver for BG2Q
Message-ID: <20140515074617.GO29318@piout.net>
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1400098522-14770-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1400098522-14770-8-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400098522-14770-8-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/05/2014 at 22:15:18 +0200, Sebastian Hesselbarth wrote :
> From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> 
> This driver deals with the core clocks found on Marvell Berlin BG2Q. For the
> shared register dividers, make use of the corresponding driver and add some
> single clock muxes and gates for the rest.
> 
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> ---
> Changelog:
> v1->v2:
> - initial version
> 
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Cc: Jisheng Zhang <jszhang@marvell.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  drivers/clk/berlin/Makefile |   1 +
>  drivers/clk/berlin/bg2q.c   | 269 ++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 270 insertions(+)
>  create mode 100644 drivers/clk/berlin/bg2q.c
> 
> diff --git a/drivers/clk/berlin/Makefile b/drivers/clk/berlin/Makefile
> index 2b33e1e74503..2a36ab710a07 100644
> --- a/drivers/clk/berlin/Makefile
> +++ b/drivers/clk/berlin/Makefile
> @@ -1,3 +1,4 @@
>  obj-y += berlin2-avpll.o berlin2-pll.o berlin2-div.o
>  obj-$(CONFIG_MACH_BERLIN_BG2)	+= bg2.o
>  obj-$(CONFIG_MACH_BERLIN_BG2CD)	+= bg2.o
> +obj-$(CONFIG_MACH_BERLIN_BG2Q)	+= bg2q.o
> diff --git a/drivers/clk/berlin/bg2q.c b/drivers/clk/berlin/bg2q.c
> new file mode 100644
> index 000000000000..df5a4ce5eb87
> --- /dev/null
> +++ b/drivers/clk/berlin/bg2q.c
> @@ -0,0 +1,269 @@
> +/*
> + * Copyright (c) 2014 Marvell Technology Group Ltd.
> + *
> + * Alexandre Belloni <alexandre.belloni@free-electrons.com>
> + * Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> + *
> + * This program is free software; you can redistribute it and/or modify it
> + * under the terms and conditions of the GNU General Public License,
> + * version 2, as published by the Free Software Foundation.
> + *
> + * This program is distributed in the hope it will be useful, but WITHOUT
> + * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
> + * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
> + * more details.
> + *
> + * You should have received a copy of the GNU General Public License along with
> + * this program.  If not, see <http://www.gnu.org/licenses/>.
> + */
> +
> +#include <linux/clk.h>
> +#include <linux/clk-provider.h>
> +#include <linux/io.h>
> +#include <linux/kernel.h>
> +#include <linux/of.h>
> +#include <linux/of_address.h>
> +#include <linux/slab.h>
> +
> +#include "berlin2-div.h"
> +
> +struct bg2_gate_data {
> +	const char *name;
> +	const char *parent_name;
> +	u8 bit_idx;
> +	unsigned long flags;
> +};
> +
> +#define REG_CLKENABLE		0x00
> +#define REG_CLKSELECT0		0x04
> +#define REG_CLKSELECT1		0x08
> +#define REG_CLKSELECT2		0x0c
> +#define REG_CLKSWITCH0		0x10
> +#define REG_CLKSWITCH1		0x14
> +
> +#define MAX_CLKS		24
> +
> +static DEFINE_SPINLOCK(lock);
> +static struct clk *clks[MAX_CLKS];
> +static struct clk_onecell_data clk_data;
> +
> +static const struct berlin2_div_data bg2q_divs[] __initconst = {
> +	{
> +		.name = "sys",
> +		.flags = CLK_IGNORE_UNUSED,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 0),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 0),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT0, 3),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 3),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 4),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 5),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "drmfigo",
> +		.flags = 0,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 17),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 6),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT0, 9),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 6),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 7),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 8),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "cfg",
> +		.flags = 0,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 1),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 12),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT0, 15),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 9),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 10),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 11),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "gfx2d",
> +		.flags = 0,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 4),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 18),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT0, 21),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 12),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 13),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 14),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "zsp",
> +		.flags = 0,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 6),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT0, 24),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT0, 27),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 15),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 16),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 17),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "perif",
> +		.flags = CLK_IGNORE_UNUSED,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 7),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 0),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 3),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 18),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 19),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 20),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "pcube",
> +		.flags = 0,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 2),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 6),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 9),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 21),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 22),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 23),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "vscope",
> +		.flags = 0,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 3),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 12),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 15),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 24),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 25),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 26),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "nfc_ecc",
> +		.flags = 0,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 19),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 18),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 21),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 27),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 28),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH0, 29),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "vpp",
> +		.flags = 0,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 21),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT1, 24),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT1, 27),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH0, 30),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH0, 31),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 0),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +	{
> +		.name = "app",
> +		.flags = 0,
> +		.map = {
> +			BERLIN2_DIV_GATE(REG_CLKENABLE, 20),
> +			BERLIN2_PLL_SELECT(REG_CLKSELECT2, 0),
> +			BERLIN2_DIV_SELECT(REG_CLKSELECT2, 3),
> +			BERLIN2_PLL_SWITCH(REG_CLKSWITCH1, 1),
> +			BERLIN2_DIV_SWITCH(REG_CLKSWITCH1, 2),
> +			BERLIN2_DIV_D3SWITCH(REG_CLKSWITCH1, 3),
> +		},
> +		.div_flags = BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +	},
> +};
> +
> +static const struct bg2_gate_data bg2q_gates[] __initconst = {
> +	{ "gfx2daxi",	"perif",	5 },
> +	{ "geth0",	"perif",	8 },
> +	{ "sata",	"perif",	9 },
> +	{ "ahbapb",	"perif",	10, CLK_IGNORE_UNUSED },
> +	{ "usb0",	"perif",	11 },
> +	{ "usb1",	"perif",	12 },
> +	{ "usb2",	"perif",	13 },
> +	{ "usb3",	"perif",	14 },
> +	{ "pbridge",	"perif",	15, CLK_IGNORE_UNUSED },
> +	{ "sdio",	"perif",	16 },
> +	{ "nfc",	"perif",	18 },
> +	{ "smemc",	"perif",	19 },
> +	{ "pcie",	"perif",	22 },
> +};
> +
> +static void __init berlin2q_core_clock_of_setup(struct device_node *np)
> +{
> +	const struct berlin2_div_data *data;
> +	const char *parent_names[9];
> +	void __iomem *base;
> +	int n, nclk = 0;
> +
> +	base = of_iomap(np, 0);
> +	if (!base) {
> +		pr_err("%s: Unable to map register base\n", np->full_name);
> +		return;
> +	}
> +
> +	/*
> +	 * TODO: reference clock bypass switches: memPLLSWBypass, cpuPLLSWBypass
> +	 * and sysPLLSWBypass are missing
> +	 */
> +
> +	/* TODO: Once BG2Q AVPLL are added, add AVPLLB[4-7] as parents*/
> +	parent_names[0] = "syspll";
> +	for (n = 0; n < ARRAY_SIZE(bg2q_divs); n++) {
> +		data = &bg2q_divs[n];
> +		clks[n] = berlin2_div_register(&data->map, base, data->name,
> +			 data->div_flags, parent_names, 5, data->flags, &lock);

That one should be 1, not 5.

> +	}
> +	nclk += n;
> +
> +	/* clock gate cells */
> +	for (n = 0; n < ARRAY_SIZE(bg2q_gates); n++) {
> +		const struct bg2_gate_data *gd = &bg2q_gates[n];
> +
> +		clks[nclk + n] = clk_register_gate(NULL, gd->name,
> +			    gd->parent_name, gd->flags, base + REG_CLKENABLE,
> +			    gd->bit_idx, 0, &lock);
> +	}
> +	nclk += n;
> +
> +	/* check for errors on leaf clocks */
> +	for (n = 0; n < nclk; n++) {
> +		if (!IS_ERR(clks[n]))
> +			continue;
> +
> +		pr_err("%s: Unable to register leaf clock %d\n",
> +		       np->full_name, n);
> +		goto core_clock_fail;
> +	}
> +
> +	/* register clk-provider */
> +	clk_data.clks = clks;
> +	clk_data.clk_num = MAX_CLKS;
> +	of_clk_add_provider(np, of_clk_src_onecell_get, &clk_data);
> +	return;
> +
> +core_clock_fail:
> +	iounmap(base);
> +}
> +CLK_OF_DECLARE(berlin2q_coreclk, "marvell,berlin2q-core-clocks",
> +	       berlin2q_core_clock_of_setup);

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
