Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932202AbaGIT1w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:27:52 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39813 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779AbaGIT1u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:27:50 -0400
Message-ID: <53BD97A0.2090909@gmail.com>
Date: Wed, 09 Jul 2014 21:27:28 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Mike Turquette <mturquette@linaro.org>, rabin@rab.in,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
CC: Rabin Vincent <rabin.vincent@stericsson.com>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [RFC v2 3/5] clk: use struct clk only for external API
References: <1404398323-18934-1-git-send-email-tomeu.vizoso@collabora.com> <1404398323-18934-4-git-send-email-tomeu.vizoso@collabora.com>
In-Reply-To: <1404398323-18934-4-git-send-email-tomeu.vizoso@collabora.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomeu, Rabin,

Please see my comments inline.

On 03.07.2014 16:38, Tomeu Vizoso wrote:
> From: Rabin Vincent <rabin.vincent@stericsson.com>
> 
> In order to provide per-user accounting, this separates the struct clk
> used in the common clock framework into two structures 'struct clk_core'
> and 'struct clk'.  struct clk_core will be used for internal
> manipulation and struct clk will be used in the clock API
> implementation.
> 
> In this patch, struct clk is simply renamed to struct clk_core and a new
> struct clk is implemented which simply wraps it.  In the next patch, the
> new struct clk will be used to implement per-user clock enable
> accounting.
> 

Hmm, shouldn't have Rabin signed off this patch as well?

> Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
> ---
>  drivers/clk/clk-devres.c     |  13 +-
>  drivers/clk/clk.c            | 539 ++++++++++++++++++++++++-------------------
>  drivers/clk/clk.h            |   4 +
>  drivers/clk/clkdev.c         |  90 +++++---
>  include/linux/clk-private.h  |  38 +--
>  include/linux/clk-provider.h | 127 +++++-----
>  include/linux/clk.h          |  21 +-
>  include/linux/clkdev.h       |  24 +-
>  8 files changed, 494 insertions(+), 362 deletions(-)
> 
> diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
> index 8f57154..5f2aba9 100644
> --- a/drivers/clk/clk-devres.c
> +++ b/drivers/clk/clk-devres.c
> @@ -5,6 +5,7 @@
>   */
>  
>  #include <linux/clk.h>
> +#include <linux/clk-provider.h>
>  #include <linux/device.h>
>  #include <linux/export.h>
>  #include <linux/gfp.h>
> @@ -14,15 +15,15 @@ static void devm_clk_release(struct device *dev, void *res)
>  	clk_put(*(struct clk **)res);
>  }
>  
> -struct clk *devm_clk_get(struct device *dev, const char *id)
> +struct clk_core *devm_clk_provider_get(struct device *dev, const char *id)

nit: I'm not sure if name of the internal struct has been discussed
already, but clk_core sounds a bit off to me. Maybe it's just me but it
looks like a big common structure of the whole clock core not some small
per-clock structure.

As for suggestions of alternative names that come to my mind:
clk_object, clk_data, clk_entity.

>  {
> -	struct clk **ptr, *clk;
> +	struct clk_core **ptr, *clk;
>  
>  	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
>  	if (!ptr)
>  		return ERR_PTR(-ENOMEM);

[snip]

>  
> +/*
> + * To avoid a mass-rename of all non-common clock implementations (spread out
> + * in arch-specific code), we let them use struct clk for both the internal and
> + * external view.
> + */
> +#ifdef CONFIG_COMMON_CLK
> +#define clk_core_t struct clk_core
> +#else
> +#define clk_core_t struct clk
> +#endif

Hmm. I have bad feelings about this making some typedef lovers overuse
this macro to save few characters by not typing "struct" in code that
doesn't have to use this macro. But clearly I can't think of any better
solution right now, so don't consider this a showstopper.

Otherwise looks good to me.

Best regards,
Tomasz
