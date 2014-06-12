Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaFLHiv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 03:38:51 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:35420 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932252AbaFLHit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 03:38:49 -0400
X-Original-SENDERIP: 10.177.220.145
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Thu, 12 Jun 2014 16:42:47 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>, kvm@vger.kernel.org,
        linux-mm@kvack.org, Gleb Natapov <gleb@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alexander Graf <agraf@suse.de>, kvm-ppc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paolo Bonzini <pbonzini@redhat.com>, linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 06/10] CMA: generalize CMA reserved area management
 functionality
Message-ID: <20140612074246.GB20199@js1304-P5Q-DELUXE>
References: <1402543307-29800-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1402543307-29800-7-git-send-email-iamjoonsoo.kim@lge.com>
 <20140612071311.GJ12415@bbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140612071311.GJ12415@bbox>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2014 at 04:13:11PM +0900, Minchan Kim wrote:
> On Thu, Jun 12, 2014 at 12:21:43PM +0900, Joonsoo Kim wrote:
> > Currently, there are two users on CMA functionality, one is the DMA
> > subsystem and the other is the kvm on powerpc. They have their own code
> > to manage CMA reserved area even if they looks really similar.
> > >From my guess, it is caused by some needs on bitmap management. Kvm side
> > wants to maintain bitmap not for 1 page, but for more size. Eventually it
> > use bitmap where one bit represents 64 pages.
> > 
> > When I implement CMA related patches, I should change those two places
> > to apply my change and it seem to be painful to me. I want to change
> > this situation and reduce future code management overhead through
> > this patch.
> > 
> > This change could also help developer who want to use CMA in their
> > new feature development, since they can use CMA easily without
> > copying & pasting this reserved area management code.
> > 
> > In previous patches, we have prepared some features to generalize
> > CMA reserved area management and now it's time to do it. This patch
> > moves core functions to mm/cma.c and change DMA APIs to use
> > these functions.
> > 
> > There is no functional change in DMA APIs.
> > 
> > v2: There is no big change from v1 in mm/cma.c. Mostly renaming.
> > 
> > Acked-by: Michal Nazarewicz <mina86@mina86.com>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> 
> Acutally, I want to remove bool return of cma_release but it's not
> a out of scope in this patchset.
> 
> Acked-by: Minchan Kim <minchan@kernel.org>
> 
> > 
> > diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> > index 00e13ce..4eac559 100644
> > --- a/drivers/base/Kconfig
> > +++ b/drivers/base/Kconfig
> > @@ -283,16 +283,6 @@ config CMA_ALIGNMENT
> >  
> >  	  If unsure, leave the default value "8".
> >  
> > -config CMA_AREAS
> > -	int "Maximum count of the CMA device-private areas"
> > -	default 7
> > -	help
> > -	  CMA allows to create CMA areas for particular devices. This parameter
> > -	  sets the maximum number of such device private CMA areas in the
> > -	  system.
> > -
> > -	  If unsure, leave the default value "7".
> > -
> >  endif
> >  
> >  endmenu
> > diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
> > index 9bc9340..f177f73 100644
> > --- a/drivers/base/dma-contiguous.c
> > +++ b/drivers/base/dma-contiguous.c
> > @@ -24,25 +24,10 @@
> >  
> >  #include <linux/memblock.h>
> >  #include <linux/err.h>
> > -#include <linux/mm.h>
> > -#include <linux/mutex.h>
> > -#include <linux/page-isolation.h>
> >  #include <linux/sizes.h>
> > -#include <linux/slab.h>
> > -#include <linux/swap.h>
> > -#include <linux/mm_types.h>
> >  #include <linux/dma-contiguous.h>
> >  #include <linux/log2.h>
> 
> Should we remain log2.h in here?
> 

We should remove it. I will fix it.

Thanks.

