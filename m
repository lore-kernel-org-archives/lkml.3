Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847Ab3ETTVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 15:21:45 -0400
Received: from smtp-out-013.synserver.de ([212.40.185.13]:1080 "EHLO
	smtp-out-010.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755480Ab3ETTVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 15:21:44 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 29159
Message-ID: <519A77B3.8000605@metafoo.de>
Date: Mon, 20 May 2013 21:21:23 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Fabio Estevam <fabio.estevam@freescale.com>
CC: vinod.koul@intel.com, linux-kernel@vger.kernel.org, festevam@gmail.com
Subject: Re: [PATCH] dma: of-dma: Fix "'nbcells' may be used uninitialized"
 warning
References: <1369077462-19315-1-git-send-email-fabio.estevam@freescale.com>
In-Reply-To: <1369077462-19315-1-git-send-email-fabio.estevam@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/20/2013 09:17 PM, Fabio Estevam wrote:
> Rearrange the code a bit so that we can get rid of the following build warning:
> 
> drivers/dma/of-dma.c:83:15: warning: 'nbcells' may be used uninitialized in this function [-Wuninitialized]
> 
> Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>

Hi,

I've submitted a patch a couple of weeks ago which removes nbcells
altogether. See: https://patchwork.kernel.org/patch/2470601/

- Lars

> ---
>  drivers/dma/of-dma.c | 20 ++++++++++++--------
>  1 file changed, 12 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/dma/of-dma.c b/drivers/dma/of-dma.c
> index 7aa0864..107e820 100644
> --- a/drivers/dma/of-dma.c
> +++ b/drivers/dma/of-dma.c
> @@ -77,15 +77,14 @@ int of_dma_controller_register(struct device_node *np,
>  		return -ENOMEM;
>  
>  	prop = of_get_property(np, "#dma-cells", NULL);
> -	if (prop)
> -		nbcells = be32_to_cpup(prop);
> +	if (!prop)
> +		goto free;
> +
> +	nbcells = be32_to_cpup(prop);
>  
> -	if (!prop || !nbcells) {
> -		pr_err("%s: #dma-cells property is missing or invalid\n",
> -		       __func__);
> -		kfree(ofdma);
> -		return -EINVAL;
> -	}
> +
> +	if (!nbcells)
> +		goto free;
>  
>  	ofdma->of_node = np;
>  	ofdma->of_dma_nbcells = nbcells;
> @@ -98,6 +97,11 @@ int of_dma_controller_register(struct device_node *np,
>  	mutex_unlock(&of_dma_lock);
>  
>  	return 0;
> +
> +free:
> +	pr_err("%s: #dma-cells property is missing or invalid\n", __func__);
> +	kfree(ofdma);
> +	return -EINVAL;
>  }
>  EXPORT_SYMBOL_GPL(of_dma_controller_register);
>  

