Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753277Ab3CCJZf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 04:25:35 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34278 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915Ab3CCJW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 04:22:58 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: spi: Return error from of_spi_register_master on bad "cs-gpios" property
To: Andreas Larsson <andreas@gaisler.com>
Cc: spi-devel-general@lists.sourceforge.net,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
In-Reply-To: <1360761804-16044-1-git-send-email-andreas@gaisler.com>
References: <1360761804-16044-1-git-send-email-andreas@gaisler.com>
Date: Sat, 02 Mar 2013 22:49:06 +0000
Message-Id: <20130302224906.369303E2F5C@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Feb 2013 14:23:24 +0100, Andreas Larsson <andreas@gaisler.com> wrote:
> This makes sure that an error is returned on an incorrectly formed
> "cs-gpios" property, but reports success when the "cs-gpios" property is
> well formed or missing.
> 
> When holes in the cs-gpios property phandle list is used to indicate
> that some other form of chipselect is to be used it is important that
> failure to read a broken "cs-gpios" property does not silently fail
> leading to the spi controller to use an unintended chipselect.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Applied, thanks.

g.

> ---
> 
> Can only be applied to devicetree/next as it builds upon the
> "of: Add helper for counting phandle refernces" patch series.
> 
>  drivers/spi/spi.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
> index 21c4748..9b5f024 100644
> --- a/drivers/spi/spi.c
> +++ b/drivers/spi/spi.c
> @@ -1068,8 +1068,11 @@ static int of_spi_register_master(struct spi_master *master)
>  	nb = of_gpio_named_count(np, "cs-gpios");
>  	master->num_chipselect = max(nb, (int)master->num_chipselect);
>  
> -	if (nb < 1)
> +	/* Return error only for an incorrectly formed cs-gpios property */
> +	if (nb == 0 || nb == -ENOENT)
>  		return 0;
> +	else if (nb < 0)
> +		return nb;
>  
>  	cs = devm_kzalloc(&master->dev,
>  			  sizeof(int) * master->num_chipselect,
> -- 
> 1.7.0.4
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
