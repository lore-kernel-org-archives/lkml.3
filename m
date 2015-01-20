Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbbATSC7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 13:02:59 -0500
Received: from mail-pa0-f48.google.com ([209.85.220.48]:49022 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996AbbATSC6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 13:02:58 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Thierry Reding <thierry.reding@gmail.com>, dri-devel@lists.freedesktop.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
Cc: linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Russell King" <linux@arm.linux.org.uk>,
        "Stephen Boyd" <sboyd@codeaurora.org>
References: <1421750935-4023-1-git-send-email-thierry.reding@gmail.com>
 <1421750935-4023-2-git-send-email-thierry.reding@gmail.com>
Message-ID: <20150120180247.22722.92597@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH 01/36] clk: Introduce clk_try_parent()
Date: Tue, 20 Jan 2015 10:02:47 -0800
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Thierry Reding (2015-01-20 02:48:20)
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

Can you describe why this was needed for your atomic modesetting work?
What problem did you hit in the driver that required this new check?

Thanks,
Mike

> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Mike Turquette <mturquette@linaro.org>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Signed-off-by: Thierry Reding <treding@nvidia.com>
> ---
>  drivers/clk/clk.c   | 36 ++++++++++++++++++++++++++++++++++++
>  include/linux/clk.h | 14 ++++++++++++++
>  2 files changed, 50 insertions(+)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index af06b7377d37..297910815dea 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -1672,6 +1672,42 @@ void __clk_reparent(struct clk *clk, struct clk *new_parent)
>  }
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
> +       int err = 0;
> +
> +       if (!clk || !parent)
> +               return -EINVAL;
> +
> +       if ((clk->num_parents > 1) && !clk->ops->set_parent)
> +               return -ENOSYS;
> +
> +       clk_prepare_lock();
> +
> +       if (clk->parent == parent)
> +               goto unlock;
> +
> +       err = clk_fetch_parent_index(clk, parent);
> +       if (err > 0)
> +               err = 0;
> +
> +unlock:
> +       clk_prepare_unlock();
> +
> +       return err;
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
> + */
> +int clk_try_parent(struct clk *clk, struct clk *parent);
> +
> +/**
>   * clk_set_parent - set the parent clock source for this clock
>   * @clk: clock source
>   * @parent: parent clock source
> @@ -400,6 +409,11 @@ static inline long clk_round_rate(struct clk *clk, unsigned long rate)
>         return 0;
>  }
>  
> +static inline int clk_try_parent(struct clk *clk, struct clk *parent)
> +{
> +       return 0;
> +}
> +
>  static inline int clk_set_parent(struct clk *clk, struct clk *parent)
>  {
>         return 0;
> -- 
> 2.1.3
> 
