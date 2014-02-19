Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbaBSLng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 06:43:36 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:32844 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752632AbaBSLne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 06:43:34 -0500
Date: Wed, 19 Feb 2014 11:43:15 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "Zhao\, Gang" <gamerh2o@gmail.com>
Cc: devel@driverdev.osuosl.org, mark.einon@gmail.com,
        linux-kernel@vger.kernel.org, greg@kroah.com
Subject: Re: [PATCH] et131x: fix allocation failures
Message-ID: <20140219114315.5af78dfe@alan.etchedpixels.co.uk>
In-Reply-To: <874n3v52fo.fsf@will.lan>
References: <20140217141252.26738.33549.stgit@alan.etchedpixels.co.uk>
	<874n3v52fo.fsf@will.lan>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Feb 2014 09:14:19 +0800
"Zhao\, Gang" <gamerh2o@gmail.com> wrote:

> Alan, thanks for resending this patch. But it seems you overlooked
> something we discussed earlier.
> 
> On Mon, 2014-02-17 at 22:13:08 +0800, Alan wrote:
> > We should check the ring allocations don't fail.
> > If we get a fail we need to clean up properly. The allocator assumes the
> > deallocator will be used on failure, but it isn't. Make sure the
> > right deallocator is always called and add a missing check against
> > fbr allocation failure.
> >
> > [v2]: Correct check logic
> >
> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> > ---
> >  drivers/staging/et131x/et131x.c |    9 +++++++--
> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> > index 6413500..cc600df 100644
> > --- a/drivers/staging/et131x/et131x.c
> > +++ b/drivers/staging/et131x/et131x.c
> > @@ -2124,7 +2124,11 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
> >  
> >  	/* Alloc memory for the lookup table */
> >  	rx_ring->fbr[0] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
> > +	if (rx_ring->fbr[0] == NULL)
> > +		return -ENOMEM;
> >  	rx_ring->fbr[1] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
> > +	if (rx_ring->fbr[1] == NULL)
> > +		return -ENOMEM;
> 
> Shouldn't rx_ring->fbr[0] be freed when allocation of rx_ring->fbr[1]
> fails ? Or we will leak memory here.

No.. the tx_dma_memory_free and rx_dma_memory_free functions are
designed to handle incomplete set up. They are now called on incomplete
setup and will clean up all the resources.

> > @@ -3591,6 +3595,7 @@ static int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
> >  	if (status) {
> >  		dev_err(&adapter->pdev->dev,
> >  			  "et131x_tx_dma_memory_alloc FAILED\n");
> > +		et131x_tx_dma_memory_free(adapter);
> >  		return status;
> >  	}
> >  	/* Receive buffer memory allocation */
> > @@ -3598,7 +3603,7 @@ static int et131x_adapter_memory_alloc(struct et131x_adapter *adapter)
> >  	if (status) {
> >  		dev_err(&adapter->pdev->dev,
> >  			  "et131x_rx_dma_memory_alloc FAILED\n");
> > -		et131x_tx_dma_memory_free(adapter);
> > +		et131x_adapter_memory_free(adapter);
> >  		return status;
> >  	}
> >  

Which is what these changes are about.

Whoever wrote the allocator and cleanup methods arranged (except for the
rx_ring->fbr cases) that the free method should be called on a failure.
It looks as if somewhere along the line of the driver development whoever
wrote the higher level bits didn't understand that.

Alan
