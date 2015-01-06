Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756423AbbAFUVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:21:21 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:52631 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005AbbAFUVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:21:19 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Ray Jui <rjui@broadcom.com>, Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>, Matt Porter <mporter@linaro.org>,
        Alex Elder <elder@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        Scott Branden <sbranden@broadcom.com>, linux-kernel@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH v2 4/5] clk: cygnus: add clock support for Broadcom Cygnus
Date: Tue, 06 Jan 2015 21:21:02 +0100
Message-ID: <2048376.BFrtW5tszK@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1420500076-18302-5-git-send-email-rjui@broadcom.com>
References: <1420500076-18302-5-git-send-email-rjui@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:1r7Twpm2aAFD0Sco6u8JZ0NsmSaZFkLQVNlyNa4YKFg/uycS6qt
 GRxwlryR3POcX91tp4zgxPe8T80MNh70wUoojzh6Tyrg8HAJ2xGEvgjoQdb4oFmwsr8UBAa
 n7O7aUTFwyiKaOlADnXBF8hJotNQHzXfI50/FC/BlxXyC//1JCkBck7XA4YRI+EmKHk4X3x
 9Y49UZM4J6dn/7qouqzMQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 05 January 2015 15:21:15 Ray Jui wrote:
> +static const struct iproc_clk_ctrl mipipll_clk[BCM_CYGNUS_NUM_MIPIPLL_CLKS] = {
> +	[BCM_CYGNUS_MIPIPLL_CH0_UNUSED] = {
> +		.channel = BCM_CYGNUS_MIPIPLL_CH0_UNUSED,
> +		.enable = enable_val(0x4, 12, 6, 18),
> +		.mdiv = reg_val(0x20, 0, 8),
> +	},
> +	[BCM_CYGNUS_MIPIPLL_CH1_LCD] = {
> +		.channel = BCM_CYGNUS_MIPIPLL_CH1_LCD,
> +		.enable = enable_val(0x4, 13, 7, 19),
> +		.mdiv = reg_val(0x20, 10, 8),
> +	},
> +	[BCM_CYGNUS_MIPIPLL_CH2_UNUSED] = {
> +		.channel = BCM_CYGNUS_MIPIPLL_CH2_UNUSED,
> +		.enable = enable_val(0x4, 14, 8, 20),
> +		.mdiv = reg_val(0x20, 20, 8),
> +	},
> +	[BCM_CYGNUS_MIPIPLL_CH3_UNUSED] = {
> +		.channel = BCM_CYGNUS_MIPIPLL_CH3_UNUSED,
> +		.enable = enable_val(0x4, 15, 9, 21),
> +		.mdiv = reg_val(0x24, 0, 8),
> +	},
> +	[BCM_CYGNUS_MIPIPLL_CH4_UNUSED] = {
> +		.channel = BCM_CYGNUS_MIPIPLL_CH4_UNUSED,
> +		.enable = enable_val(0x4, 16, 10, 22),
> +		.mdiv = reg_val(0x24, 10, 8),
> +	},
> +	[BCM_CYGNUS_MIPIPLL_CH5_UNUSED] = {
> +		.channel = BCM_CYGNUS_MIPIPLL_CH5_UNUSED,
> +		.enable = enable_val(0x4, 17, 11, 23),
> +		.mdiv = reg_val(0x24, 20, 8),
> +	},
> +};

The tables look fairly regular. Is it possible that it's common
to all iproc variants with a standard way to derive all other
values from the channel index?

> +static const struct iproc_asiu_gate asiu_gate[BCM_CYGNUS_NUM_ASIU_CLKS] = {
> +	[BCM_CYGNUS_ASIU_KEYPAD_CLK] =
> +		asiu_gate_val(0x0, 7),
> +	[BCM_CYGNUS_ASIU_ADC_CLK] =
> +		asiu_gate_val(0x0, 9),
> +	[BCM_CYGNUS_ASIU_PWM_CLK] =
> +		asiu_gate_val(IPROC_CLK_INVALID_OFFSET, 0),
> +};

Here I think a better binding would be to pass the gate value in the
clock specifier, rather than an artificial index. That would let
you get rid of the BCM_CYGNUS_ASIU_KEYPAD_CLK/BCM_CYGNUS_ASIU_ADC_CLK
macros.

> +static void __init cygnus_armpll_init(struct device_node *node)
> +{
> +	iproc_armpll_setup(node);
> +}
> +CLK_OF_DECLARE(cygnus_armpll, "brcm,cygnus-armpll", cygnus_armpll_init);

How about moving all of these directly next to the tables, to keep
each clock controller?

> +static void __init cygnus_genpll_clk_init(struct device_node *node)
> +{
> +	iproc_clk_setup(node, genpll_clk, BCM_CYGNUS_NUM_GENPLL_CLKS);
> +}

If you use ARRAY_SIZE here, you can remove the BCM_CYGNUS_NUM_GENPLL_CLKS
macro that is not useful to the DT binding.

	Arnd
