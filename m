Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaIWKBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 06:01:11 -0400
Received: from sym2.noone.org ([178.63.92.236]:33466 "EHLO sym2.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbaIWKBK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 06:01:10 -0400
Date: Tue, 23 Sep 2014 12:01:07 +0200
From: Tobias Klauser <tklauser@distanz.ch>
To: Mark Einon <mark.einon@gmail.com>
Cc: gregkh@linuxfoundation.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH linux-next] et131x: Promote staging et131x driver to
 drivers/net
Message-ID: <20140923100106.GE4657@distanz.ch>
References: <1411421283-25073-1-git-send-email-mark.einon@gmail.com>
 <20140923072251.GD4657@distanz.ch>
 <20140923094614.GA5130@leicester.auvation.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140923094614.GA5130@leicester.auvation.com>
X-Editor: Vi IMproved 7.3
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-23 at 11:46:15 +0200, Mark Einon <mark.einon@gmail.com> wrote:
> On Tue, Sep 23, 2014 at 09:22:53AM +0200, Tobias Klauser wrote:
> 
> Hi Tobias,
> 
> Thanks for the details review. I've replied below -
> 
> [...]
> > > +/* et131x_rx_dma_memory_alloc
> > > + *
> > > + * Allocates Free buffer ring 1 for sure, free buffer ring 0 if required,
> > > + * and the Packet Status Ring.
> > > + */
> > > +static int et131x_rx_dma_memory_alloc(struct et131x_adapter *adapter)
> > > +{
> > > +	u8 id;
> > > +	u32 i, j;
> > > +	u32 bufsize;
> > > +	u32 psr_size;
> > > +	u32 fbr_chunksize;
> > > +	struct rx_ring *rx_ring = &adapter->rx_ring;
> > > +	struct fbr_lookup *fbr;
> > > +
> > > +	/* Alloc memory for the lookup table */
> > > +	rx_ring->fbr[0] = kmalloc(sizeof(*fbr), GFP_KERNEL);
> > > +	if (rx_ring->fbr[0] == NULL)
> > > +		return -ENOMEM;
> > > +	rx_ring->fbr[1] = kmalloc(sizeof(*fbr), GFP_KERNEL);
> > > +	if (rx_ring->fbr[1] == NULL)
> > > +		return -ENOMEM;
> > 
> > If you fail here, et131x_rx_dma_memory_free() will be called by
> > et131x_adapter_memory_free() in the error handling path which in turn
> > will access the members of the already allocated rx_ring->fbr[0] (e.g.
> > ->buffsize). Since it is allocated with kmalloc() these members contain
> > arbitrary values and cause problems in et131x_rx_dma_memory_free(). I'
> > suggest to do the cleanup (i.e. free rx_ring->fbr[0] directly here and
> > not call et131x_rx_dma_memory_free() in the error handling path. You
> > might want to check that memory allocation failures are properly handled
> > in the rest of the driver as well. There are multiple other cases where
> > et131x_adapter_memory_free() is called on partially
> > allocated/initialized memory.
> > 
> 
> I don't think this is the case - the members of rx_ring->fbr[x] are not
> accessed unless this pointer is non-NULL in et131x_rx_dma_memory_free()
> (see code snippet below), which is exactly why the kmalloc code above
> would fail, so buffsize never gets accessed and the code is cleaned up
> correctly.  Actually, for further explanation, this thread discusses
> these changes:
> 
> http://www.spinics.net/lists/linux-driver-devel/msg42128.html

Hm, won't rx_ring->fbr[0] be accessed, since it was successfully
allocated? However, it isn't properly initialized, so at least the
->ring_virtaddr will get accessed and if this is non-NULL by accident
also further members?

> > > +/* et131x_rx_dma_memory_free - Free all memory allocated within this module */
> > > +static void et131x_rx_dma_memory_free(struct et131x_adapter *adapter)
> > > +{
> 
> [...]
> 
> > > +	/* Free Free Buffer Rings */
> > > +	for (id = 0; id < NUM_FBRS; id++) {
> > > +		fbr = rx_ring->fbr[id];
> > > +
> > > +		if (!fbr || !fbr->ring_virtaddr)
> > > +			continue;
> > > +
> > > +		/* First the packet memory */
> > > +		for (ii = 0; ii < fbr->num_entries / FBR_CHUNKS; ii++) {
> > > +			if (fbr->mem_virtaddrs[ii]) {
> > > +				bufsize = fbr->buffsize * FBR_CHUNKS;
> 
> [...]
> 
> > > +static SIMPLE_DEV_PM_OPS(et131x_pm_ops, et131x_suspend, et131x_resume);
> > > +#define ET131X_PM_OPS (&et131x_pm_ops)
> > > +#else
> > > +#define ET131X_PM_OPS NULL
> > > +#endif
> > 
> > No need for the #define here, just assigne et131x_pm_ops to .driver.pm
> > directly, its members will be NULL and thus never called. Also, you can
> > make et131x_pm_ops const.
> 
> Ok, I can change this.
> 
> Btw, this appears to be a fairly standard way of using .driver.pm among
> ethernet drivers, e.g. see 3com/3c59x.c, atheros, marvell... - perhaps
> there is a case for changing all instances of this code?

Yes, this would probably make sense. Looks like a good job for a
coccinelle patch.
