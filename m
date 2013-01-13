Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab3AMNTJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 08:19:09 -0500
Received: from norkia.v3.sk ([91.210.183.14]:53557 "EHLO norkia.v3.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755047Ab3AMNTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 08:19:07 -0500
Subject: Re: [PATCH 2/2] dma: mv_xor: do not sync the DMA buffer after
 being deallocated
From: Lubomir Rintel <lkundrak@v3.sk>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
In-Reply-To: <20130104171033.4a244c3d@skate>
References: <1356636228-23096-1-git-send-email-lkundrak@v3.sk>
	 <1356636228-23096-2-git-send-email-lkundrak@v3.sk>
	 <20130104171033.4a244c3d@skate>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Jan 2013 14:18:57 +0100
Message-ID: <1358083137.13136.1.camel@hobbes>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-24.el6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-01-04 at 17:10 +0100, Thomas Petazzoni wrote:
> Dear Lubomir Rintel,
> 
> On Thu, 27 Dec 2012 20:23:48 +0100, Lubomir Rintel wrote:
> 
> >  	dma_sync_single_for_cpu(dma_chan->device->dev, dest_dma,
> >  				MV_XOR_TEST_SIZE, DMA_FROM_DEVICE);
> > +	dma_unmap_single(dma_chan->device->dev, dest_dma, MV_XOR_TEST_SIZE,
> > +			 DMA_FROM_DEVICE);
> 
> I would assume that dma_unmap_single() implies a
> dma_sync_single_for_cpu() since you're unmapping the DMA buffer. So if
> you use dma_unmap_single(), I think you can remove the call to
> dma_sync_single_for_cpu().

Yes, it indeed seems to be the case (comment for arm_dma_unmap_page():
"After this call, reads by the CPU to the buffer are guaranteed to see
whatever the device wrote there.".

> >  	dma_sync_single_for_cpu(dma_chan->device->dev, dest_dma,
> >  				PAGE_SIZE, DMA_FROM_DEVICE);
> > +	dma_unmap_page(dma_chan->device->dev, dest_dma, PAGE_SIZE,
> > +		       DMA_FROM_DEVICE);
> 
> Ditto.
> 
> Also, the mv_xor_memcpy_self_test() function not only dma_map_single()
> the destination buffer, but also the source buffer. So presumably, the
> source buffer should also be dma_unmap_single()'d.
> 
> And for the mv_xor_xor_self_test() function, multiple source buffers
> are dma_map_page()'d, so they should all be dma_unmap_page()'d I guess,
> not only the destination buffer.

Those get released by the mv_xor_run_tx_complete_actions() callback.

I will follow up with an updated patch.

Regards,
Lubo

