Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235AbaCAQd0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 11:33:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43947 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752972AbaCAQdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 11:33:24 -0500
Message-ID: <53120BA8.3000508@redhat.com>
Date: Sat, 01 Mar 2014 17:32:40 +0100
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: linux-sunxi@googlegroups.com, Emilio Lopez <emilio@elopez.com.ar>,
        Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>
CC: Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        kevin.z.m.zh@gmail.com, sunny@allwinnertech.com,
        shuge@allwinnertech.com, zhuzhenhua@allwinnertech.com,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: [linux-sunxi] [PATCH v2 2/5] clk: sun6i: Reparent AHB clock on
 PLL6
References: <1393605440-14643-1-git-send-email-maxime.ripard@free-electrons.com> <1393605440-14643-3-git-send-email-maxime.ripard@free-electrons.com>
In-Reply-To: <1393605440-14643-3-git-send-email-maxime.ripard@free-electrons.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 02/28/2014 05:37 PM, Maxime Ripard wrote:
> In order for the DMA controller to work for SDRAM to devices transfers, the AHB
> clock should be reparented on the PLL6.
> 
> Force that parenting in the clock driver.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
> ---
>  drivers/clk/sunxi/clk-sunxi.c | 18 +++++++++++++++++-
>  1 file changed, 17 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/clk/sunxi/clk-sunxi.c b/drivers/clk/sunxi/clk-sunxi.c
> index f6f61cc..a5c5882 100644
> --- a/drivers/clk/sunxi/clk-sunxi.c
> +++ b/drivers/clk/sunxi/clk-sunxi.c
> @@ -1286,7 +1286,7 @@ static void __init of_sunxi_table_clock_setup(const struct of_device_id *clk_mat
>   */
>  static void __init sunxi_clock_protect(void)
>  {
> -	struct clk *clk;
> +	struct clk *clk, *parent;
>  
>  	/* memory bus clock - sun5i+ */
>  	clk = clk_get(NULL, "mbus");
> @@ -1307,6 +1307,22 @@ static void __init sunxi_clock_protect(void)
>  	if (!IS_ERR(clk))
>  		clk_prepare_enable(clk);
>  
> +	clk = clk_get(NULL, "ahb1_mux");
> +	if (IS_ERR(clk)) {
> +		pr_err("Couldn't get AHB1 Mux\n");
> +		return;
> +	}

I think Emilio already made a similar remark for v1, but since this
is still here in v2, ahb1_mux is only available on sun6i, so
at a minimum the pr_err should be dropped. Preferably I would like
to see this changed to something like:

	clk = clk_get(NULL, "ahb1_mux");
	parent = clk_get(NULL, "pll6");
	if (!IS_ERR(clk) && !IS_ERR(parent))
		clk_set_parent(clk, parent);
	if (!IS_ERR(parent))
		clk_put(parent);
	if (!IS_ERR(clk))
		clk_put(clk);

> +
> +	parent = clk_get(NULL, "pll6");
> +	if (IS_ERR(clk)) {

Copy paste error should be IS_ERR(parent).

> +		pr_err("Couldn't get PLL6\n");

If we keep things this way this error path should do a clk_put(clk);

> +		return;
> +	}
> +
> +	clk_set_parent(clk, parent);
> +
> +	clk_put(clk);
> +	clk_put(parent);
>  }
>  
>  static void __init sunxi_init_clocks(void)
> 

Regards,

Hans

p.s.

Given Russell's remarks it would also be good to have a
patch in this set dropping the clk_put calls of the existing
enables / protections.
