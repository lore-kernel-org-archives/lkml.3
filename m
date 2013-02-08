Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752305Ab3BHFVk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 00:21:40 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:11668 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab3BHFVj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 00:21:39 -0500
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 07 Feb 2013 21:18:22 -0800
Message-ID: <51148B5B.1090701@nvidia.com>
Date: Fri, 8 Feb 2013 10:51:31 +0530
From: Prashant Gaikwad <pgaikwad@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Stephen Warren <swarren@nvidia.com>,
        Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] clk: tegra: Implement locking for super clock
References: <1360254261-23000-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1360254261-23000-1-git-send-email-pdeschrijver@nvidia.com>
X-NVConfidentiality: public
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 07 February 2013 09:54 PM, Peter De Schrijver wrote:
> Although tegra_clk_register_super_mux() has a lock parameter, the lock is not
> actually used by the code. Fixed with this patch.
>
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Reviewed-by: Prashant Gaikwad <pgaikwad@nvidia.com>

> ---
>   drivers/clk/tegra/clk-super.c |   18 +++++++++++++++---
>   1 files changed, 15 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clk/tegra/clk-super.c b/drivers/clk/tegra/clk-super.c
> index 7ad48a8..2fd924d 100644
> --- a/drivers/clk/tegra/clk-super.c
> +++ b/drivers/clk/tegra/clk-super.c
> @@ -73,7 +73,12 @@ static int clk_super_set_parent(struct clk_hw *hw, u8 index)
>   {
>   	struct tegra_clk_super_mux *mux = to_clk_super_mux(hw);
>   	u32 val, state;
> +	int err = 0;
>   	u8 parent_index, shift;
> +	unsigned long flags = 0;
> +
> +	if (mux->lock)
> +		spin_lock_irqsave(mux->lock, flags);
>   
>   	val = readl_relaxed(mux->reg);
>   	state = val & SUPER_STATE_MASK;
> @@ -92,8 +97,10 @@ static int clk_super_set_parent(struct clk_hw *hw, u8 index)
>   					       (index == mux->pllx_index))) {
>   		parent_index = clk_super_get_parent(hw);
>   		if ((parent_index == mux->div2_index) ||
> -		    (parent_index == mux->pllx_index))
> -			return -EINVAL;
> +		    (parent_index == mux->pllx_index)) {
> +			err = -EINVAL;
> +			goto out;
> +		}
>   
>   		val ^= SUPER_LP_DIV2_BYPASS;
>   		writel_relaxed(val, mux->reg);
> @@ -107,7 +114,12 @@ static int clk_super_set_parent(struct clk_hw *hw, u8 index)
>   
>   	writel_relaxed(val, mux->reg);
>   	udelay(2);
> -	return 0;
> +
> +out:
> +	if (mux->lock)
> +		spin_unlock_irqrestore(mux->lock, flags);
> +
> +	return err;
>   }
>   
>   const struct clk_ops tegra_clk_super_ops = {

