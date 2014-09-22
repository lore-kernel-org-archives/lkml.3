Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbaIVSIe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:08:34 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:37547 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753486AbaIVSIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:08:32 -0400
Date: Mon, 22 Sep 2014 19:08:07 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Cc: Mike Turquette <mturquette@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        linux-kernel@vger.kernel.org, tomasz.figa@gmail.com, rabin@rab.in,
        Thierry Reding <thierry.reding@gmail.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v12 04/10] clk: use struct clk only for external API
Message-ID: <20140922180807.GN5182@n2100.arm.linux.org.uk>
References: <1411395124-2476-1-git-send-email-tomeu.vizoso@collabora.com> <1411395353-3189-1-git-send-email-tomeu.vizoso@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411395353-3189-1-git-send-email-tomeu.vizoso@collabora.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 04:15:47PM +0200, Tomeu Vizoso wrote:
> diff --git a/drivers/clk/clk.h b/drivers/clk/clk.h
> index d278572..3b3068b 100644
> --- a/drivers/clk/clk.h
> +++ b/drivers/clk/clk.h
> @@ -9,9 +9,15 @@
>   * published by the Free Software Foundation.
>   */
>  
> +#include <linux/clk-private.h>
> +
>  #if defined(CONFIG_OF) && defined(CONFIG_COMMON_CLK)
>  struct clk_core *of_clk_get_by_clkspec(struct of_phandle_args *clkspec);
>  struct clk_core *__of_clk_get_from_provider(struct of_phandle_args *clkspec);
>  void of_clk_lock(void);
>  void of_clk_unlock(void);
>  #endif
> +
> +#if defined(CONFIG_COMMON_CLK)
> +struct clk *__clk_create_clk(struct clk_core *clk_core);
> +#endif

Why does any of the above need ifdefs?

> diff --git a/drivers/clk/clkdev.c b/drivers/clk/clkdev.c
> index c751d0c..060041b 100644
> --- a/drivers/clk/clkdev.c
> +++ b/drivers/clk/clkdev.c
> @@ -18,6 +18,7 @@
>  #include <linux/string.h>
>  #include <linux/mutex.h>
>  #include <linux/clk.h>
> +#include <linux/clk-private.h>
>  #include <linux/clk-provider.h>
>  #include <linux/clkdev.h>
>  #include <linux/of.h>
> @@ -33,13 +34,13 @@ static DEFINE_MUTEX(clocks_mutex);

I'm not happy with any of these changes, because it introduces a huge
number of ifdefs.

Instead of doing this, please introduce a local typedef in this .c file
which is conditional on whether we're using your new struct clk_core
or not, eg, clkdev_ret_t.

Then, rename all the functions here to be _provider based, and arrange
for these to return clkdev_ret_t.

Then provide the original functions, with your __clk_create_clk() call
to allocate your struct clk.  A dummy version which merely returns its
argument can be provided when we're not using clk_core.

This should result in substantially fewer ifdefs - probably just one
ifdef.

Another concern here is what happens when __clk_create_clk() fails.
Your __clk_create_clk() function does nothing in that regard, so any
references which the parent function took are never released.

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
