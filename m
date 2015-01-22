Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378AbbAVAQP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 19:16:15 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:38976 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888AbbAVAQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 19:16:08 -0500
Message-ID: <54C04145.1010906@codeaurora.org>
Date: Wed, 21 Jan 2015 16:16:05 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: Re: [PATCH v2] clk: Introduce clk_has_parent()
References: <1421750935-4023-2-git-send-email-thierry.reding@gmail.com> <1421856780-32103-1-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1421856780-32103-1-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/21/2015 08:13 AM, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
>
> This new function is similar to clk_set_parent(), except that it doesn't
> actually change the parent. It merely checks that the given parent clock
> can be a parent for the given clock.
>
> A situation where this is useful is to check that a particular setup is
> valid before switching to it. One specific use-case for this is atomic
> modesetting in the DRM framework where setting a mode is divided into a
> check phase where a given configuration is validated before applying
> changes to the hardware.
>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---

Reviewed-by: Stephen Boyd <sboyd@codeaurora.org>

This will slightly conflict with Tomeu's  patches for per-user clock
constraints. It would be best if we can take this through the clk tree
to fix up any conflicts

> Changes in v2:
> - lookup parent name in parent names array and make function lockless
> - rename function from clk_try_parent() to clk_has_parent()
> - return boolean
>
>  drivers/clk/clk.c   | 30 ++++++++++++++++++++++++++++++
>  include/linux/clk.h | 17 +++++++++++++++++
>  2 files changed, 47 insertions(+)
>
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index af06b7377d37..470266297dea 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1672,6 +1672,36 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>  }
>  
>  /**
> + * clk_has_parent - check if a clock is a possible parent for another
> + * @clk: clock source
> + * @parent: parent clock source
> + *
> + * This function can be used in drivers that need to check that a clock can be
> + * the parent of another without actually changing the parent.
> + *
> + * Returns true if @parent is a possible parent for @clk, false otherwise.
> + */
> +bool clk_has_parent(struct clk *clk, struct clk *parent)
> +{
> +	unsigned int i;
> +
> +	/* NULL clocks should be nops, so return success if either is NULL. */
> +	if (!clk || !parent)
> +		return true;
> +
> +	/* Optimize for the case where the parent is already the parent. */
> +	if (clk->parent == parent)
> +		return true;

I worry that we'll need to grab a lock here with Tomeu's patches, but
maybe I'm wrong.

> +
> +	for (i = 0; i < clk->num_parents; i++)
> +		if (strcmp(clk->parent_names[i], parent->name) == 0)
> +			return true;
> +
> +	return false;
> +}
> +EXPORT_SYMBOL_GPL(clk_has_parent);
> +
> +/**


-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

