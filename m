Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751494AbaJIU1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 16:27:42 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:45056 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045AbaJIU1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 16:27:35 -0400
Date: Thu, 9 Oct 2014 13:27:33 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] clk: Don't try to use a struct clk* after it
 could have been freed
Message-ID: <20141009202733.GD5493@codeaurora.org>
References: <1412866903-6970-1-git-send-email-tomeu.vizoso@collabora.com>
 <1412866903-6970-4-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412866903-6970-4-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09, Tomeu Vizoso wrote:
> As __clk_release could call kfree on clk and then we wouldn't have a safe way
> of getting the module that owns the clock.
> 
> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>

It would be good to mark this as a "Fixes:".

> ---
>  drivers/clk/clk.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
> index d0712b7..40aa7ad 100644
> --- a/drivers/clk/clk.c
> +++ b/drivers/clk/clk.c
> @@ -2268,14 +2268,16 @@ int __clk_get(struct clk *clk)
>  
>  void __clk_put(struct clk *clk)
>  {
> +	struct module *owner;
> +
>  	if (!clk || WARN_ON_ONCE(IS_ERR(clk)))
>  		return;
>  
>  	clk_prepare_lock();
> +	owner = clk->owner;
>  	kref_put(&clk->ref, __clk_release);
> +	module_put(owner);
>  	clk_prepare_unlock();
> -
> -	module_put(clk->owner);

We don't need to move this call under the prepare lock though, right?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
