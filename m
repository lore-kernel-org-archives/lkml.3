Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219AbaDGNG3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 09:06:29 -0400
Received: from mx07-00178001.pphosted.com ([62.209.51.94]:58018 "EHLO
	mx07-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754274AbaDGNGZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 09:06:25 -0400
Message-ID: <5342A2BC.2020907@st.com>
Date: Mon, 7 Apr 2014 15:06:04 +0200
From: Gabriel Fernandez <gabriel.fernandez@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: Pankaj Dev <pankaj.dev@st.com>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] clk: st: NULL dereference on error in st_of_clkgen_vcc_setup()
References: <20140407063036.GA11581@mwanda>
In-Reply-To: <20140407063036.GA11581@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.19.41]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-07_02:2014-04-07,2014-04-06,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Dan,
i m agree with patch.

Best Regards.

Gabriel

On 04/07/2014 08:30 AM, Dan Carpenter wrote:
> There are two allocations where, if they fail, then we end up
> dereferencing the NULL pointer in the error handling code.
>
> Fixes: 94885faf9dbc ('clk: st: Support for DIVMUX and PreDiv Clocks')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
>
> diff --git a/drivers/clk/st/clkgen-mux.c b/drivers/clk/st/clkgen-mux.c
> index a329906..10899bc 100644
> --- a/drivers/clk/st/clkgen-mux.c
> +++ b/drivers/clk/st/clkgen-mux.c
> @@ -714,14 +714,14 @@ void __init st_of_clkgen_vcc_setup(struct device_node *np)
>   
>   	clk_data = kzalloc(sizeof(*clk_data), GFP_KERNEL);
>   	if (!clk_data)
> -		goto err;
> +		goto err_free_parents;
>   
>   	clk_data->clk_num = VCC_MAX_CHANNELS;
>   	clk_data->clks = kzalloc(clk_data->clk_num * sizeof(struct clk *),
>   				 GFP_KERNEL);
>   
>   	if (!clk_data->clks)
> -		goto err;
> +		goto err_free_data;
>   
>   	for (i = 0; i < clk_data->clk_num; i++) {
>   		struct clk *clk;
> @@ -811,10 +811,11 @@ err:
>   		kfree(container_of(composite->mux_hw, struct clk_mux, hw));
>   	}
>   
> -	if (clk_data)
> -		kfree(clk_data->clks);
> +	kfree(clk_data->clks);
>   
> +err_free_data:
>   	kfree(clk_data);
> +err_free_parents:
>   	kfree(parents);
>   }
>   CLK_OF_DECLARE(clkgen_vcc, "st,clkgen-vcc", st_of_clkgen_vcc_setup);

