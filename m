Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752797Ab3F1RtN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 13:49:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37303 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752470Ab3F1RtL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 13:49:11 -0400
Message-ID: <1372441744.30572.765.camel@ul30vt.home>
Subject: Re: [ 102/127] iommu/amd: Workaround for ERBT1312
From: Alex Williamson <alex.williamson@redhat.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: Joerg Roedel <joro@8bytes.org>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 28 Jun 2013 11:49:04 -0600
In-Reply-To: <20130628181136.52d00e9c@dualc.maya.org>
References: <lhtAZ-q1-5@gated-at.bofh.it> <lhtB1-q1-53@gated-at.bofh.it>
	 <20130628181136.52d00e9c@dualc.maya.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-28 at 18:11 +0200, Andreas Hartmann wrote:
> Hello Joerg, hello Alex,
> 
> the subsequent patch and the patch "iommu/amd: Re-enable IOMMU event log
> interrupt after handling." 925fe08bce38d1ff052fe2209b9e2b8d5fbb7f98
> spread /var/log/messages with the following line (> 700 lines/second)
> right after loading vfio:
> 
> AMD-Vi: Event logged [IO_PAGE_FAULT device=00:14.0 domain=0x0000 address=0x000000fdf9103300 flags=0x0600]

That's interesting, I PXE boot my system from one NIC then use a
different NIC for the iSCSI root.  The PXE boot NIC now screams like
this, _until_ I attach it to vfio, then it quiets down.

> lspci -vvvs 0:14.0
> 00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 42)
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr- Stepping- SERR- FastB2B- DisINTx+
>         Status: Cap- 66MHz+ UDF- FastB2B- ParErr- DEVSEL=medium >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
> 
> 
> Besides the enormous pollution I couldn't see any malfunction at all.
> At first, I didn't realised it at all (-> the SSD was fast enough to
> cover it silently). I saw it the first time I rebooted because X didn't start any more because
> the /var partition was completely full. 
> 
> I removed the two mentioned patches and all is working
> fine again as before.
> 
> Any idea?

Not really without some digging.  I wonder if it's a new event each time
or if something is just not clearing a previous event.  ISTR that a boot
used to often, but not always, generate a couple faults between the
IOMMU being enabled and the NIC driver being loaded.  All the faults I
see are to the same address, so my guess is that it's getting replayed.
Thanks,

Alex

> Greg Kroah-Hartman wrote:
> > 3.9-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Joerg Roedel <joro@8bytes.org>
> > 
> > commit d3263bc29706e42f74d8800807c2dedf320d77f1 upstream.
> > 
> > Work around an IOMMU  hardware bug where clearing the
> > EVT_INT or PPR_INT bit in the status register may race with
> > the hardware trying to set it again. When not handled the
> > bit might not be cleared and we lose all future event or ppr
> > interrupts.
> > 
> > Reported-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > Signed-off-by: Joerg Roedel <joro@8bytes.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > ---
> >  drivers/iommu/amd_iommu.c |   34 ++++++++++++++++++++++++++--------
> >  1 file changed, 26 insertions(+), 8 deletions(-)
> > 
> > --- a/drivers/iommu/amd_iommu.c
> > +++ b/drivers/iommu/amd_iommu.c
> > @@ -700,14 +700,23 @@ retry:
> >  
> >  static void iommu_poll_events(struct amd_iommu *iommu)
> >  {
> > -	u32 head, tail;
> > +	u32 head, tail, status;
> >  	unsigned long flags;
> >  
> > -	/* enable event interrupts again */
> > -	writel(MMIO_STATUS_EVT_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
> > -
> >  	spin_lock_irqsave(&iommu->lock, flags);
> >  
> > +	/* enable event interrupts again */
> > +	do {
> > +		/*
> > +		 * Workaround for Erratum ERBT1312
> > +		 * Clearing the EVT_INT bit may race in the hardware, so read
> > +		 * it again and make sure it was really cleared
> > +		 */
> > +		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
> > +		writel(MMIO_STATUS_EVT_INT_MASK,
> > +		       iommu->mmio_base + MMIO_STATUS_OFFSET);
> > +	} while (status & MMIO_STATUS_EVT_INT_MASK);
> > +
> >  	head = readl(iommu->mmio_base + MMIO_EVT_HEAD_OFFSET);
> >  	tail = readl(iommu->mmio_base + MMIO_EVT_TAIL_OFFSET);
> >  
> > @@ -744,16 +753,25 @@ static void iommu_handle_ppr_entry(struc
> >  static void iommu_poll_ppr_log(struct amd_iommu *iommu)
> >  {
> >  	unsigned long flags;
> > -	u32 head, tail;
> > +	u32 head, tail, status;
> >  
> >  	if (iommu->ppr_log == NULL)
> >  		return;
> >  
> > -	/* enable ppr interrupts again */
> > -	writel(MMIO_STATUS_PPR_INT_MASK, iommu->mmio_base + MMIO_STATUS_OFFSET);
> > -
> >  	spin_lock_irqsave(&iommu->lock, flags);
> >  
> > +	/* enable ppr interrupts again */
> > +	do {
> > +		/*
> > +		 * Workaround for Erratum ERBT1312
> > +		 * Clearing the PPR_INT bit may race in the hardware, so read
> > +		 * it again and make sure it was really cleared
> > +		 */
> > +		status = readl(iommu->mmio_base + MMIO_STATUS_OFFSET);
> > +		writel(MMIO_STATUS_PPR_INT_MASK,
> > +		       iommu->mmio_base + MMIO_STATUS_OFFSET);
> > +	} while (status & MMIO_STATUS_PPR_INT_MASK);
> > +
> >  	head = readl(iommu->mmio_base + MMIO_PPR_HEAD_OFFSET);
> >  	tail = readl(iommu->mmio_base + MMIO_PPR_TAIL_OFFSET);
> >  



