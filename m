Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879AbaJTPuV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 11:50:21 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:59171 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053AbaJTPuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 11:50:18 -0400
X-IronPort-AV: E=Sophos;i="5.04,756,1406592000"; 
   d="scan'208";a="184208420"
Message-ID: <1413820211.29506.9.camel@citrix.com>
Subject: Re: [PATCH v4 7/7] xen/arm: introduce GNTTABOP_cache_flush
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <david.vrabel@citrix.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>
Date: Mon, 20 Oct 2014 16:50:11 +0100
In-Reply-To: <1412941908-5850-7-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1410101244090.17038@kaball.uk.xensource.com>
	 <1412941908-5850-7-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 12:51 +0100, Stefano Stabellini wrote:
> Introduce support for new hypercall GNTTABOP_cache_flush.
> Use it to perform cache flashing on pages used for dma when necessary.
> 
> If GNTTABOP_cache_flush is supported by the hypervisor, we don't need to
> bounce dma map operations that involve foreign grants and non-coherent
> devices.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> ---
> 
> Changes in v4:
> - add comment;
> - avoid bouncing dma map operations that involve foreign grants and
> non-coherent devices if GNTTABOP_cache_flush is provided by Xen.
> 
> Changes in v3:
> - fix the cache maintenance op call to match what Linux does natively;
> - update the hypercall interface to match Xen.
> 
> Changes in v2:
> - update the hypercall interface to match Xen;
> - call the interface on a single page at a time.
> ---
>  arch/arm/xen/mm.c                   |   41 ++++++++++++++++++++++++++++++-----
>  include/xen/interface/grant_table.h |   19 ++++++++++++++++
>  2 files changed, 54 insertions(+), 6 deletions(-)
> 
> diff --git a/arch/arm/xen/mm.c b/arch/arm/xen/mm.c
> index 0c2a75a..21db123 100644
> --- a/arch/arm/xen/mm.c
> +++ b/arch/arm/xen/mm.c
> @@ -11,6 +11,7 @@
>  #include <linux/swiotlb.h>
>  
>  #include <xen/xen.h>
> +#include <xen/interface/grant_table.h>
>  #include <xen/interface/memory.h>
>  #include <xen/swiotlb-xen.h>
>  
> @@ -44,6 +45,8 @@ static inline void *kmap_high_get(struct page *page)
>  static inline void kunmap_high(struct page *page) {}
>  #endif
>  
> +static bool hypercall_flush = false;

Would be nice to include the word "cache" (or at least cflush) in this.

> -arch_initcall(xen_mm_init);
> +arch_initcall(xen_mm_init)

I think this is stray?

Acked-by: Ian Campbell <ian.campbell@citrix.com>

