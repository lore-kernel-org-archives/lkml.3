Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601AbbATTV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 14:21:28 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:45384 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbbATTV0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 14:21:26 -0500
Message-ID: <54BEAAB4.9030803@codeaurora.org>
Date: Tue, 20 Jan 2015 11:21:24 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org
CC: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@linaro.org>
Subject: Re: [PATCH 01/36] clk: Introduce clk_try_parent()
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com> <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
In-Reply-To: <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2015 02:48 AM, Thierry Reding wrote:
>  
>  /**
> + * clk_try_parent - check if a clock can be the parent clock source of another
> + * @clk: clock source
> + * @parent: parent clock source
> + *
> + * This is like clk_set_parent(), except that it only checks that parent can
> + * be the parent clock source for clock.
> + *
> + * Returns success (0) or negative errno.
> + */
> +int clk_try_parent(struct clk *clk, struct clk *parent)
> +{
> +	int err = 0;
> +
> +	if (!clk || !parent)
> +		return -EINVAL;

NULL clock should be a nop, so return success in either case.

> +
> +	if ((clk->num_parents > 1) && !clk->ops->set_parent)
> +		return -ENOSYS;

This suffers from the same problem as discussed in another thread where
the mux is read-only and the parent is the current parent. That case
shouldn't fail.

> +
> +	clk_prepare_lock();
> +
> +	if (clk->parent == parent)
> +		goto unlock;
> +
> +	err = clk_fetch_parent_index(clk, parent);
> +	if (err > 0)
> +		err = 0;
> +

Given that we just throw away the index, perhaps we should just loop
over the parent_names array searching for a name match on the parent's
name. If we did that this entire function would be lockless too.

> +unlock:
> +	clk_prepare_unlock();
> +
> +	return err;
> +}
> +EXPORT_SYMBOL_GPL(clk_try_parent);
> +
> +/**
>   * clk_set_parent - switch the parent of a mux clk
>   * @clk: the mux clk whose input we are switching
>   * @parent: the new input to clk
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index fb1ac65f127c..94da8c68a515 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -328,6 +328,15 @@ long clk_round_rate(struct clk *clk, unsigned long rate);
>  int clk_set_rate(struct clk *clk, unsigned long rate);
>  
>  /**
> + * clk_try_parent - check if a clock can be the parent clock source of another
> + * @clk: clock source
> + * @parent: parent clock source
> + *
> + * Returns success (0) or negative errno.

Why not a bool? Do we really care why we can't set the parent in the
error case?

> + */
> +int clk_try_parent(struct clk *clk, struct clk *parent);

The name makes me think of mutex_trylock(), so I immediately think this
tries to set the parent. Perhaps a better name would be
clk_can_have_parent() or clk_has_parent()?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project

