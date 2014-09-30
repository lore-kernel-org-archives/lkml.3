Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352AbaI3JOw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 05:14:52 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:47827 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751017AbaI3JOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 05:14:50 -0400
Date: Tue, 30 Sep 2014 10:14:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [RFC] clk: Make clk API return per-user struct clk instances
Message-ID: <20140930091437.GJ5182@n2100.arm.linux.org.uk>
References: <20140926232009.19023.15825@quantum> <1412014643-29099-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412014643-29099-1-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 29, 2014 at 08:17:23PM +0200, Tomeu Vizoso wrote:
> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index da4bda8..ab22460 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -168,14 +168,20 @@ static struct clk_lookup *clk_find(const char *dev_id, const char *con_id)
>  struct clk *clk_get_sys(const char *dev_id, const char *con_id)
>  {
>  	struct clk_lookup *cl;
> +	struct clk *clk = NULL;
>  
>  	mutex_lock(&clocks_mutex);
>  	cl = clk_find(dev_id, con_id);
> -	if (cl && !__clk_get(cl->clk))
> -		cl = NULL;
> +	if (cl) {
> +		clk = __clk_create_clk(cl->clk);
> +		if (clk && !__clk_get(clk)) {
> +			__clk_free_clk(clk);
> +			clk = NULL;
> +		}
> +	}
>  	mutex_unlock(&clocks_mutex);
>  
> -	return cl ? cl->clk : ERR_PTR(-ENOENT);
> +	return clk ? clk : ERR_PTR(-ENOENT);

NAK.  We have places where we explicitly expect clk_get* to return NULL.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
