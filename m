Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059Ab3IEQw4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 12:52:56 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:42065 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3IEQwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 12:52:54 -0400
X-IronPort-AV: E=Sophos;i="4.90,848,1371081600"; 
   d="scan'208";a="48570117"
Date: Thu, 5 Sep 2013 17:39:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Julien Grall <julien.grall@citrix.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux@arm.linux.org.uk>,
        <Ian.Campbell@citrix.com>, <will.deacon@arm.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <ben-linux@fluff.org>, <kgene.kim@samsung.com>,
        <linux-samsung-soc@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH v5 02/13] arm: introduce a global dma_ops
 pointer
In-Reply-To: <5224A47A.3010704@citrix.com>
Message-ID: <alpine.DEB.2.02.1309051736130.6397@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1308291917290.6397@kaball.uk.xensource.com> <1377801154-29215-2-git-send-email-stefano.stabellini@eu.citrix.com> <5224A47A.3010704@citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Sep 2013, Julien Grall wrote:
> On 08/29/2013 07:32 PM, Stefano Stabellini wrote:
> > Initially set dma_ops to arm_dma_ops.
> > 
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > Acked-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > CC: will.deacon@arm.com
> > CC: linux@arm.linux.org.uk
> > 
> > 
> > Changes in v3:
> > -  keep using arm_dma_ops in dmabounce.
> > ---
> >  arch/arm/include/asm/dma-mapping.h |    3 ++-
> >  arch/arm/mm/dma-mapping.c          |    3 +++
> >  2 files changed, 5 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> > index 0982206..7d6e4f9 100644
> > --- a/arch/arm/include/asm/dma-mapping.h
> > +++ b/arch/arm/include/asm/dma-mapping.h
> > @@ -13,6 +13,7 @@
> >  #include <asm/cacheflush.h>
> >  
> >  #define DMA_ERROR_CODE	(~0)
> > +extern struct dma_map_ops *dma_ops;
> 
> Hi,
> 
> I tried to build your swiotlb patch series for the Arndale. I have a compilation
> error because dma_ops is already used in samsung sound driver (sound/soc/samsung/dma.c).
> 
> This small fix allow me to built this serie for the Arndale.
> Do I need to send it separately?

This looks like a good fix, I'll append it to the series


> =======================================================================
> commit 73d4ceded87f52fa958b92d8d8d65be485e90857
> Author: Julien Grall <julien.grall@linaro.org>
> Date:   Mon Sep 2 15:36:35 2013 +0100
> 
>     ASoC: Samsung: Rename dma_ops by samsung_dma_ops
>     
>     The commit "arm: introduce a global dma_ops pointer" introduce compilation issue
>     when CONFIG_SND_SOC_SAMSUNG is enabled.
>     
>     sound/soc/samsung/dma.c:345:27: error: conflicting types for 'dma_ops'
>     /local/home/julien/works/arndale/linux/arch/arm/include/asm/dma-mapping.h:16:28:
>     note: previous declaration of 'dma_ops' was here
>     
>     Signed-off-by: Julien Grall <julien.grall@linaro.org>
> 
> diff --git a/sound/soc/samsung/dma.c b/sound/soc/samsung/dma.c
> index ddea134..c341603 100644
> --- a/sound/soc/samsung/dma.c
> +++ b/sound/soc/samsung/dma.c
> @@ -342,7 +342,7 @@ static int dma_mmap(struct snd_pcm_substream *substream,
>                                      runtime->dma_bytes);
>  }
>  
> -static struct snd_pcm_ops dma_ops = {
> +static struct snd_pcm_ops samsung_dma_ops = {
>         .open           = dma_open,
>         .close          = dma_close,
>         .ioctl          = snd_pcm_lib_ioctl,
> @@ -429,7 +429,7 @@ out:
>  }
>  
>  static struct snd_soc_platform_driver samsung_asoc_platform = {
> -       .ops            = &dma_ops,
> +       .ops            = &samsung_dma_ops,
>         .pcm_new        = dma_new,
>         .pcm_free       = dma_free_dma_buffers,
>  };
> 
> -- 
> Julien Grall
> 
