Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaLSO2s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:28:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53671 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaLSO2q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:28:46 -0500
Date: Fri, 19 Dec 2014 16:28:29 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, linux-sh@vger.kernel.org,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH RFC 2/5] s390: add pci_iomap_range
Message-ID: <20141219142829.GA13440@redhat.com>
References: <1418679168-1011-1-git-send-email-mst@redhat.com>
 <1418679168-1011-3-git-send-email-mst@redhat.com>
 <alpine.LFD.2.11.1412191456480.1794@denkbrett>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.11.1412191456480.1794@denkbrett>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 03:13:37PM +0100, Sebastian Ott wrote:
> On Mon, 15 Dec 2014, Michael S. Tsirkin wrote:
> > From: Michael S Tsirkin <mst@redhat.com>
> > 
> > Virtio drivers should map the part of the range they need, not
> > necessarily all of it.
> > To this end, support mapping ranges within BAR on s390.
> > Since multiple ranges can now be mapped within a BAR, we keep track of
> > the number of mappings created, and only clear out the mapping for a BAR
> > when this number reaches 0.
> > 
> 
> I can't say much about the users of this interface but in principle I'm
> OK with such a change.

I don't have an s390 system with pci for testing - could you help me out
by testing this and confirming it doesn't break things?

> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > ---
> >  arch/s390/include/asm/pci_io.h |  1 +
> >  arch/s390/pci/pci.c            | 34 +++++++++++++++++++++++++++-------
> >  2 files changed, 28 insertions(+), 7 deletions(-)
> > 
> > diff --git a/arch/s390/include/asm/pci_io.h b/arch/s390/include/asm/pci_io.h
> > index d194d54..25228b3 100644
> > --- a/arch/s390/include/asm/pci_io.h
> > +++ b/arch/s390/include/asm/pci_io.h
> > @@ -16,6 +16,7 @@
> >  struct zpci_iomap_entry {
> >  	u32 fh;
> >  	u8 bar;
> > +	u16 count;
> >  };
> > 
> >  extern struct zpci_iomap_entry *zpci_iomap_start;
> > diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> > index 2fa7b14..51cb653 100644
> > --- a/arch/s390/pci/pci.c
> > +++ b/arch/s390/pci/pci.c
> > @@ -259,7 +259,10 @@ void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
> >  }
> > 
> >  /* Create a virtual mapping cookie for a PCI BAR */
> > -void __iomem *pci_iomap(struct pci_dev *pdev, int bar, unsigned long max)
> > +void __iomem *pci_iomap_range(struct pci_dev *pdev,
> > +			      int bar,
> > +			      unsigned long offset,
> > +			      unsigned long max)
> >  {
> >  	struct zpci_dev *zdev =	get_zdev(pdev);
> >  	u64 addr;
> > @@ -270,14 +273,27 @@ void __iomem *pci_iomap(struct pci_dev *pdev, int bar, unsigned long max)
> > 
> >  	idx = zdev->bars[bar].map_idx;
> >  	spin_lock(&zpci_iomap_lock);
> > -	zpci_iomap_start[idx].fh = zdev->fh;
> > -	zpci_iomap_start[idx].bar = bar;
> > +	if (zpci_iomap_start[idx].count++) {
> > +		BUG_ON(zpci_iomap_start[idx].fh != zdev->fh ||
> > +		       zpci_iomap_start[idx].bar != bar);
> > +	} else {
> > +		zpci_iomap_start[idx].fh = zdev->fh;
> > +		zpci_iomap_start[idx].bar = bar;
> > +	}
> > +	/* Detect overrun */
> > +	BUG_ON(!zpci_iomap_start[idx].count);
> >  	spin_unlock(&zpci_iomap_lock);
> > 
> >  	addr = ZPCI_IOMAP_ADDR_BASE | ((u64) idx << 48);
> > -	return (void __iomem *) addr;
> > +	return (void __iomem *) addr + offset;
> >  }
> > -EXPORT_SYMBOL_GPL(pci_iomap);
> > +EXPORT_SYMBOL_GPL(pci_iomap_range);
> > +
> > +void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
> > +{
> > +	return pci_iomap_range(dev, bar, 0, maxlen);
> > +}
> > +EXPORT_SYMBOL(pci_iomap);
> 
> This was EXPORT_SYMBOL_GPL. I guess, for this patch, it should stay that
> way. ...Hm, everyone else has this stuff as EXPORT_SYMBOL looks like we
> should use that too.
> 
> Regards,
> Sebastian

OK, so you want two patches: one with new functionality,
one switching to EXPORT_SYMBOL?


> > 
> >  void pci_iounmap(struct pci_dev *pdev, void __iomem *addr)
> >  {
> > @@ -285,8 +301,12 @@ void pci_iounmap(struct pci_dev *pdev, void __iomem *addr)
> > 
> >  	idx = (((__force u64) addr) & ~ZPCI_IOMAP_ADDR_BASE) >> 48;
> >  	spin_lock(&zpci_iomap_lock);
> > -	zpci_iomap_start[idx].fh = 0;
> > -	zpci_iomap_start[idx].bar = 0;
> > +	/* Detect underrun */
> > +	BUG_ON(!zpci_iomap_start[idx].count);
> > +	if (!--zpci_iomap_start[idx].count) {
> > +		zpci_iomap_start[idx].fh = 0;
> > +		zpci_iomap_start[idx].bar = 0;
> > +	}
> >  	spin_unlock(&zpci_iomap_lock);
> >  }
> >  EXPORT_SYMBOL_GPL(pci_iounmap);
> > -- 
> > MST
> > 
> > 
