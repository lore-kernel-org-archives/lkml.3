Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab3JRMXf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 08:23:35 -0400
Received: from smtp.citrix.com ([66.165.176.89]:10936 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752599Ab3JRMXe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 08:23:34 -0400
X-IronPort-AV: E=Sophos;i="4.93,522,1378857600"; 
   d="scan'208";a="64959884"
Date: Fri, 18 Oct 2013 13:22:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <konrad.wilk@oracle.com>,
        <Ian.Campbell@citrix.com>, <will.deacon@arm.com>,
        <linux@arm.linux.org.uk>
Subject: Re: [PATCH v8 08/19] arm/xen: get_dma_ops: return xen_dma_ops if we
 are running as xen_initial_domain
In-Reply-To: <1382031814-8782-8-git-send-email-stefano.stabellini@eu.citrix.com>
Message-ID: <alpine.DEB.2.02.1310181319300.26077@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1310171833520.26077@kaball.uk.xensource.com> <1382031814-8782-8-git-send-email-stefano.stabellini@eu.citrix.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,
are you OK with this patch?


On Thu, 17 Oct 2013, Stefano Stabellini wrote:
> We can't simply override arm_dma_ops with xen_dma_ops because devices
> are allowed to have their own dma_ops and they take precedence over
> arm_dma_ops. When running on Xen as initial domain, we always want
> xen_dma_ops to be the one in use.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> Suggested-by: Catalin Marinas <catalin.marinas@arm.com>
> CC: will.deacon@arm.com
> CC: linux@arm.linux.org.uk
> 
> Changes in v7:
> - return xen_dma_ops only if we are the initial domain;
> - rename __get_dma_ops to __generic_dma_ops.
> ---
>  arch/arm/include/asm/dma-mapping.h |   13 ++++++++++++-
>  1 files changed, 12 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
> index 01b5a3d..f5945d4 100644
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
> +static inline struct dma_map_ops *__generic_dma_ops(struct device *dev)
>  {
>  	if (dev && dev->archdata.dma_ops)
>  		return dev->archdata.dma_ops;
>  	return &arm_dma_ops;
>  }
>  
> +static inline struct dma_map_ops *get_dma_ops(struct device *dev)
> +{
> +	if (xen_initial_domain())
> +		return xen_dma_ops;
> +	else
> +		return __generic_dma_ops(dev);
> +}
> +
>  static inline void set_dma_ops(struct device *dev, struct dma_map_ops *ops)
>  {
>  	BUG_ON(!dev);
> -- 
> 1.7.2.5
> 
