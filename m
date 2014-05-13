Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759170AbaEMIki (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 04:40:38 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:44220 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358AbaEMIkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 04:40:36 -0400
Message-ID: <5371DA80.2060603@gmail.com>
Date: Tue, 13 May 2014 10:40:32 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Mike Turquette <mturquette@linaro.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] clk: berlin: add driver for BG2x complex divider
 cells
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com> <1399839881-29895-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1399839881-29895-6-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 10:24 PM, Sebastian Hesselbarth wrote:
> From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
>
> This is a driver for the complex divider cells found on Marvell Berlin2
> SoCs. The cells come in two flavors: single register cells and shared
> register cells. The single register cells are registered by using a DT
> node, while the shared ones will be taken care of in a SoC-specific
> core clock driver.
>
> Signed-off-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
[...]
> diff --git a/drivers/clk/berlin/berlin2-div.c b/drivers/clk/berlin/berlin2-div.c
> new file mode 100644
> index 000000000000..96513a6e8ca7
> --- /dev/null
> +++ b/drivers/clk/berlin/berlin2-div.c
> @@ -0,0 +1,326 @@
[...]
> +static void __init berlin2_div_of_setup(struct device_node *np)
> +{
> +	const char *parent_names[9] = {};
> +	char *mux_name = "mux0";
> +	int num_parents = 0;

num_parents is always zero...

> +	void __iomem *base;
> +	struct clk *iclk;
> +	struct clk *div;
> +	char *div_name;
> +	int n;
> +
> +	iclk = of_clk_get_by_name(np, "mux_bypass");
> +	if (IS_ERR(iclk)) {
> +		pr_err("%s: Missing mux bypass clock\n", np->full_name);
> +		return;
> +	}
> +	parent_names[0] = __clk_get_name(iclk);

.. and needs to be incremented here..

> +	clk_put(iclk);
> +
> +	/* collect mux input clock names */
> +	for (n = 0; n < 8; n++) {
> +		sprintf(mux_name, "mux%d", n);
> +		iclk = of_clk_get_by_name(np, mux_name);
> +		if (IS_ERR(iclk))
> +			continue;
> +		parent_names[1 + n] = __clk_get_name(iclk);

.. and here.

I'll fix it up for v2.

Sebastian

> +		clk_put(iclk);
> +	}
> +
> +	base = of_iomap(np, 0);
> +	if (!base) {
> +		pr_err("%s: Unable to map div register\n", np->full_name);
> +		return;
> +	}
> +
> +	div_name = of_clk_create_name(np);
> +	div = berlin2_div_register(&berlin2_single_div_map, base, div_name,
> +				   BERLIN2_DIV_HAS_GATE | BERLIN2_DIV_HAS_MUX,
> +				   parent_names, num_parents, 0, NULL);
> +	if (!IS_ERR(div))
> +		of_clk_add_provider(np, of_clk_src_simple_get, div);
> +
> +	kfree(div_name);
> +}
> +CLK_OF_DECLARE(berlin2_div, "marvell,berlin2-div", berlin2_div_of_setup);

