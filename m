Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaJZQbp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 12:31:45 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:46720 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaJZQbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 12:31:44 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: dmaengine@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 09/11] dmaengine: sh: Remove chancnt affectations
Date: Sun, 26 Oct 2014 18:31:44 +0200
Message-ID: <4174219.1JRhVA0YgA@avalon>
User-Agent: KMail/4.12.5 (Linux/3.16.5-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <1413450063-23829-10-git-send-email-maxime.ripard@free-electrons.com>
References: <1413450063-23829-1-git-send-email-maxime.ripard@free-electrons.com> <1413450063-23829-10-git-send-email-maxime.ripard@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

Thank you for the patch.

On Thursday 16 October 2014 11:01:01 Maxime Ripard wrote:
> chanctnt is already filled by dma_async_device_register, which uses the
> channel list to know how much channels there is.
> 
> Since it's already filled, we can safely remove it from the drivers' probe
> function.
> 
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
>  drivers/dma/sh/rcar-audmapp.c | 2 --
>  drivers/dma/sh/rcar-hpbdma.c  | 2 --
>  drivers/dma/sh/shdma-base.c   | 2 +-
>  drivers/dma/sh/shdmac.c       | 2 --
>  drivers/dma/sh/sudmac.c       | 2 --
>  5 files changed, 1 insertion(+), 9 deletions(-)
> 
> diff --git a/drivers/dma/sh/rcar-audmapp.c b/drivers/dma/sh/rcar-audmapp.c
> index dabbf0aba2e9..fd1005e58551 100644
> --- a/drivers/dma/sh/rcar-audmapp.c
> +++ b/drivers/dma/sh/rcar-audmapp.c
> @@ -248,7 +248,6 @@ static int audmapp_chan_probe(struct platform_device
> *pdev,
> 
>  static void audmapp_chan_remove(struct audmapp_device *audev)
>  {
> -	struct dma_device *dma_dev = &audev->shdma_dev.dma_dev;
>  	struct shdma_chan *schan;
>  	int i;
> 
> @@ -256,7 +255,6 @@ static void audmapp_chan_remove(struct audmapp_device
> *audev) BUG_ON(!schan);
>  		shdma_chan_remove(schan);
>  	}
> -	dma_dev->chancnt = 0;
>  }
> 
>  static struct dma_chan *audmapp_of_xlate(struct of_phandle_args *dma_spec,
> diff --git a/drivers/dma/sh/rcar-hpbdma.c b/drivers/dma/sh/rcar-hpbdma.c
> index b212d9471ab5..5ab921865ffe 100644
> --- a/drivers/dma/sh/rcar-hpbdma.c
> +++ b/drivers/dma/sh/rcar-hpbdma.c
> @@ -619,7 +619,6 @@ error:
> 
>  static void hpb_dmae_chan_remove(struct hpb_dmae_device *hpbdev)
>  {
> -	struct dma_device *dma_dev = &hpbdev->shdma_dev.dma_dev;
>  	struct shdma_chan *schan;
>  	int i;
> 
> @@ -628,7 +627,6 @@ static void hpb_dmae_chan_remove(struct hpb_dmae_device
> *hpbdev)
> 
>  		shdma_chan_remove(schan);
>  	}
> -	dma_dev->chancnt = 0;
>  }
> 
>  static int hpb_dmae_remove(struct platform_device *pdev)
> diff --git a/drivers/dma/sh/shdma-base.c b/drivers/dma/sh/shdma-base.c
> index 42d497416196..ed5b0993edfa 100644
> --- a/drivers/dma/sh/shdma-base.c
> +++ b/drivers/dma/sh/shdma-base.c
> @@ -951,7 +951,7 @@ void shdma_chan_probe(struct shdma_dev *sdev,
>  	/* Add the channel to DMA device channel list */
>  	list_add_tail(&schan->dma_chan.device_node,
>  			&sdev->dma_dev.channels);
> -	sdev->schan[sdev->dma_dev.chancnt++] = schan;
> +	sdev->schan[id] = schan;
>  }
>  EXPORT_SYMBOL(shdma_chan_probe);
> 
> diff --git a/drivers/dma/sh/shdmac.c b/drivers/dma/sh/shdmac.c
> index 58eb85770eba..b65317c6ea4e 100644
> --- a/drivers/dma/sh/shdmac.c
> +++ b/drivers/dma/sh/shdmac.c
> @@ -572,7 +572,6 @@ err_no_irq:
> 
>  static void sh_dmae_chan_remove(struct sh_dmae_device *shdev)
>  {
> -	struct dma_device *dma_dev = &shdev->shdma_dev.dma_dev;
>  	struct shdma_chan *schan;
>  	int i;
> 
> @@ -581,7 +580,6 @@ static void sh_dmae_chan_remove(struct sh_dmae_device
> *shdev)
> 
>  		shdma_chan_remove(schan);
>  	}
> -	dma_dev->chancnt = 0;
>  }
> 
>  static void sh_dmae_shutdown(struct platform_device *pdev)
> diff --git a/drivers/dma/sh/sudmac.c b/drivers/dma/sh/sudmac.c
> index 3ce103909896..69a5c7b87ee0 100644
> --- a/drivers/dma/sh/sudmac.c
> +++ b/drivers/dma/sh/sudmac.c
> @@ -295,7 +295,6 @@ err_no_irq:
> 
>  static void sudmac_chan_remove(struct sudmac_device *su_dev)
>  {
> -	struct dma_device *dma_dev = &su_dev->shdma_dev.dma_dev;
>  	struct shdma_chan *schan;
>  	int i;
> 
> @@ -304,7 +303,6 @@ static void sudmac_chan_remove(struct sudmac_device
> *su_dev)
> 
>  		shdma_chan_remove(schan);
>  	}
> -	dma_dev->chancnt = 0;
>  }
> 
>  static dma_addr_t sudmac_slave_addr(struct shdma_chan *schan)

-- 
Regards,

Laurent Pinchart

