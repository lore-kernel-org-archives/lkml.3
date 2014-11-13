Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933769AbaKMSTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 13:19:31 -0500
Received: from smarthost01b.mail.zen.net.uk ([212.23.1.3]:56347 "EHLO
	smarthost01b.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932648AbaKMST3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 13:19:29 -0500
Message-ID: <1415902763.1787.8.camel@linaro.org>
Subject: Re: [PATCH] dmaengine: pl330: Fix linker error "undefined reference
 to `__aeabi_uldivmod'"
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Joe Perches <joe@perches.com>
Cc: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Nov 2014 18:19:23 +0000
In-Reply-To: <1415898172.4223.1.camel@perches.com>
References: <1415896047.1787.4.camel@linaro.org>
	 <1415898172.4223.1.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01b-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 09:02 -0800, Joe Perches wrote:
> On Thu, 2014-11-13 at 16:27 +0000, Jon Medhurst (Tixy) wrote:
> > 32-bit ARM kernels may have a 64-bit dma_addr_t but have no
> > implementation of the compiler helper for 64-bit unsigned division,
> > therefore the use of the modulo operator in pl330_prep_dma_memcpy causes
> > the link error "undefined reference to `__aeabi_uldivmod'"
> > 
> > As the burst value is always a power of two we can fix the problem, and
> > make the code more efficient, by replacing "% burst" with "& (burst-1)".
> > 
> > Reported-by: kbuild test robot <fengguang.wu@intel.com>
> > Signed-off-by: Jon Medhurst <tixy@linaro.org>
> > ---
> > 
> > Vinod. I haven't added a 'Fixes:' line because I was unsure if the patch
> > in linux-next is part of a stable branch or if the SHA1 might change
> > before hitting mainline. If it stable then the line should be...
> > 
> > Fixes: 63369d0a96dc ("dmaengine: pl330: Align DMA memcpy operations to MFIFO width")
> > 
> > 
> >  drivers/dma/pl330.c | 5 +----
> >  1 file changed, 1 insertion(+), 4 deletions(-)
> > 
> > diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
> > index 38c9617..52c4c62 100644
> > --- a/drivers/dma/pl330.c
> > +++ b/drivers/dma/pl330.c
> > @@ -2464,11 +2464,8 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
> >  	 * parameters because our DMA programming algorithm doesn't cope with
> >  	 * transfers which straddle an entry in the DMA device's MFIFO.
> >  	 */
> > -	while (burst > 1) {
> > -		if (!((src | dst | len) % burst))
> > -			break;
> > +	while ((src | dst | len) & (burst - 1))
> >  		burst /= 2;
> > -	}
> 
> Maybe something like:
> 
> 	div = ffs(src | dst | len);
> 	if (burst > 1 && div)
> 		burst >>= div;

That doesn't work, the code is trying to limit burst to make it a factor
of src, dst and len, so it would need to be something like

	div = ffs(src | dst | len);
	if (div)
 		burst = min(burst, 1 << div);

There are many ways to code the limiting of the burst width, but as it
starts out as the data bus width the DMA can handle (maximum 16 bytes)
then at most we'll be going round the existing while loop 4 times so I
don't think it's that much overhead, and probably less code size than
using ffs.

And as the driver has been broken for the unaligned memcpy case since
the day it was added then I can't see that anyone is actually using it
that way anyway, so all existing users (if any) must already be doing
bus aligned copies and the current while loop will iterate zero times.

That's probably enough bikeshedding from me :-)
 
> ?
> 
> dunno if dma_addr_t src or dst can ever be a 64 bit value
> for AMBA or not.

The pl330 TRM I have and the current Linux driver explicitly have 32-bit
addresses, so you would need an IOMMU to access addresses above 4GB.

-- 
Tixy



