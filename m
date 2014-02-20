Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaBTJEG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 04:04:06 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:50034 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754810AbaBTJEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 04:04:00 -0500
Date: Thu, 20 Feb 2014 12:03:39 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        devel@driverdev.osuosl.org, mark.einon@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] et131x: fix allocation failures
Message-ID: <20140220090339.GW26722@mwanda>
References: <20140217141252.26738.33549.stgit@alan.etchedpixels.co.uk>
 <874n3v52fo.fsf@will.lan>
 <20140219114315.5af78dfe@alan.etchedpixels.co.uk>
 <8738jefpta.fsf@will.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8738jefpta.fsf@will.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 11:03:45AM +0800, Zhao, Gang wrote:
> On Wed, 2014-02-19 at 19:43:15 +0800, One Thousand Gnomes wrote:
> > On Wed, 19 Feb 2014 09:14:19 +0800
> > "Zhao\, Gang" <gamerh2o@gmail.com> wrote:
> >
> >> Alan, thanks for resending this patch. But it seems you overlooked
> >> something we discussed earlier.
> >> 
> >> On Mon, 2014-02-17 at 22:13:08 +0800, Alan wrote:
> >> > We should check the ring allocations don't fail.
> >> > If we get a fail we need to clean up properly. The allocator assumes the
> >> > deallocator will be used on failure, but it isn't. Make sure the
> >> > right deallocator is always called and add a missing check against
> >> > fbr allocation failure.
> >> >
> >> > [v2]: Correct check logic
> >> >
> >> > Signed-off-by: Alan Cox <alan@linux.intel.com>
> >> > ---
> >> >  drivers/staging/et131x/et131x.c |    9 +++++++--
> >> >  1 file changed, 7 insertions(+), 2 deletions(-)
> >> >
> >> > diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
> >> > index 6413500..cc600df 100644
> >> > --- a/drivers/staging/et131x/et131x.c
> >> > +++ b/drivers/staging/et131x/et131x.c
> >> > @@ -2124,7 +2124,11 @@ static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
> >> >  
> >> >  	/* Alloc memory for the lookup table */
> >> >  	rx_ring->fbr[0] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
> >> > +	if (rx_ring->fbr[0] == NULL)
> >> > +		return -ENOMEM;
> >> >  	rx_ring->fbr[1] = kmalloc(sizeof(struct fbr_lookup), GFP_KERNEL);
> >> > +	if (rx_ring->fbr[1] == NULL)
> >> > +		return -ENOMEM;
> >> 
> >> Shouldn't rx_ring->fbr[0] be freed when allocation of rx_ring->fbr[1]
> >> fails ? Or we will leak memory here.
> >
> > No.. the tx_dma_memory_free and rx_dma_memory_free functions are
> > designed to handle incomplete set up. They are now called on incomplete
> > setup and will clean up all the resources.
> >
> 
> Yes, you are right. By calling {tx, rx}_dma_memory_free the memory will
> be freed.
> 
> But I think a comment is needed here, to make this more clear ? Without
> proper comment the above code looks a little strange to let one think
> it's right. :)

No.  We don't need a comment.  If people start adding kfree() calls
all over the place without thinking then we are already screwed and no
comment is going to help us.

regards,
dan carpenter

