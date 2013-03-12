Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933210Ab3CLSJc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 14:09:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:41185 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932465Ab3CLSJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 14:09:31 -0400
Message-ID: <513F6F56.6000304@wwwdotorg.org>
Date: Tue, 12 Mar 2013 12:09:26 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: dmitry.torokhov@gmail.com, linux-input@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input: keyboard: tegra: support for defining row/columns
 based on SoC
References: <1363088189-14654-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1363088189-14654-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2013 05:36 AM, Laxman Dewangan wrote:
> NVIDIA's Tegra20 and Tegra30 supports the 16x8 keyboard matrix and T114
> support the 11x8 Key matrix.
> 
> Add support for defining the maximum row/columns based on SoC through
> proper compatibity.

Aside from the few nits below,
Reviewed-by: Stephen Warren <swarren@nvidia.com>

> diff --git a/drivers/input/keyboard/tegra-kbc.c b/drivers/input/keyboard/tegra-kbc.c

> @@ -108,6 +115,9 @@ struct tegra_kbc {
>  	u32 wakeup_key;
>  	struct timer_list timer;
>  	struct clk *clk;
> +	const struct tegra_kbc_hw_support *hw_support;
> +	int max_keys;
> +	int max_row_columns;

That isn't really max_row_columns, that's num_gpios or perhaps
num_rows_and_columns.

> +	if (num_cols > kbc->hw_support->max_columns) {
> +		dev_err(kbc->dev,
> +			"Number of column is more than supported on SoCs\n");

That's be slightly better as:

Number of columns is more than supported by this hardware.

Similar for the row check above.

> @@ -579,6 +622,12 @@ static int tegra_kbc_probe(struct platform_device *pdev)
>  	}
>  
>  	kbc->dev = &pdev->dev;
> +	kbc->hw_support = match->data;
> +	kbc->max_keys = (kbc->hw_support->max_rows *
> +				kbc->hw_support->max_columns);
> +	kbc->max_row_columns = (kbc->hw_support->max_rows +
> +					kbc->hw_support->max_columns);

You don't need the () around either of those expressions.
