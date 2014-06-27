Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452AbaF0Wo3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 18:44:29 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45984 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751447AbaF0Wo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 18:44:28 -0400
Message-ID: <53ADF3C8.2060702@wwwdotorg.org>
Date: Fri, 27 Jun 2014 16:44:24 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 4/5] clk: per-user clock accounting for debug
References: <1403855872-14749-1-git-send-email-tomeu.vizoso@collabora.com> <1403855872-14749-5-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1403855872-14749-5-git-send-email-tomeu.vizoso@collabora.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/27/2014 01:57 AM, Tomeu Vizoso wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> When a clock has multiple users, the WARNING on imbalance of
> enable/disable may not show the guilty party since although they may
> have commited the error earlier, the warning is emitted later when some
> other user, presumably innocent, disables the clock.
> 
> Provide per-user clock enable/disable accounting and disabler tracking
> in order to help debug these problems.
> 
> NOTE: with this patch, clk_get_parent() behaves like clk_get(), i.e. it
> needs to be matched with a clk_put().  Otherwise, memory will leak.

> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index 91659b2..9657fc8 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -56,7 +56,11 @@ struct clk_core {
>  };
>  
>  struct clk {
> -	struct clk_core clk;
> +	struct clk_core	*core;
> +	unsigned int	enable_count;
> +	const char	*dev_id;
> +	const char	*con_id;

Why not just store the "struct device *" there instead of pulling the
name out of it, so ...

> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c

>  void clk_disable(struct clk *clk_user)
>  {
> -	__clk_disable_internal(clk_to_clk_core(clk_user));
> +	struct clk_core *clk = clk_to_clk_core(clk_user);
> +	unsigned long flags;
> +
> +	flags = clk_enable_lock();
> +	if (!WARN(clk_user->enable_count == 0,
> +		  "incorrect disable clk dev %s con %s last disabler %pF\n",
> +		  clk_user->dev_id, clk_user->con_id, clk_user->last_disable)) {

Here, you could do something like:

    if (!clk_user->enable_count) {
        dev_err(clk_user->dev, "", ...);
        goto out;
    }
    ...
    out:
    clk_enable_unlock(flags);
}

I suppose that has the disadvantage of not using WARN() so not
generating a full back-trace. Still, you could keep the use of WARN()
and pass as a parameter to the printf parameters dev_name(clk_user->dev)
rather than manually saving the fields separately.
