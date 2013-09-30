Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab3I3PSi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 11:18:38 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:19856 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab3I3PSf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 11:18:35 -0400
Date: Mon, 30 Sep 2013 11:17:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Ian.Campbell@citrix.com,
        will.deacon@arm.com, linux@arm.linux.org.uk
Subject: Re: [PATCH v6 08/19] arm/xen: get_dma_ops: return xen_dma_ops if we
 are running on Xen
Message-ID: <20130930151712.GP3106@phenom.dumpdata.com>
References: <alpine.DEB.2.02.1309271653420.5498@kaball.uk.xensource.com>
 <1380298207-29151-8-git-send-email-stefano.stabellini@eu.citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1380298207-29151-8-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 05:09:56PM +0100, Stefano Stabellini wrote:
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> CC: will.deacon@arm.com
> CC: linux@arm.linux.org.uk

> ---
>  arch/arm/include/asm/dma-mapping.h |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 8807124..b638d6d 100644
> --- a/arch/arm/include/asm/dma-mapping.h
> +++ b/arch/arm/include/asm/dma-mapping.h
> @@ -12,17 +12,28 @@
>  #include <asm/memory.h>
>  #include <asm/cacheflush.h>
>  
> +#include <xen/xen.h>
> +#include <asm/xen/hypervisor.h>
> +
>  #define DMA_ERROR_CODE	(~0)
>  extern struct dma_map_ops arm_dma_ops;
>  extern struct dma_map_ops arm_coherent_dma_ops;
>  
> -static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> +static inline struct dma_map_ops *__get_dma_ops(struct device *dev)

How about calling it __generic_dma_ops ?


>  {
>  	if (dev && dev->archdata.dma_ops)
>  		return dev->archdata.dma_ops;
>  	return &arm_dma_ops;
>  }
>  
> +static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> +{
> +	if (xen_domain())
> +		return xen_dma_ops;
> +	else
> +		return __get_dma_ops(dev);


Could you explan (hopefully in the git commit description) why
we cannot over-write arm_dma_ops with xen_dma_ops?


Thank you.

> +}
> +
>  static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
>  {
>  	BUG_ON(!dev);
> -- 
> 1.7.2.5
> 
