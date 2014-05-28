Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753182AbaE1SEu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 14:04:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44562 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751158AbaE1SEs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 14:04:48 -0400
Message-ID: <1401300278.2412.52.camel@ul30vt.home>
Subject: Re: [PATCH v4 05/16] PCI: quirk dma_alias_devfn for Marvell devices
From: Alex Williamson <alex.williamson@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, iommu@lists.linux-foundation.org,
        acooks@gmail.com, linux-kernel@vger.kernel.org, eddy0596@gmail.com,
        linux@horizon.com
Date: Wed, 28 May 2014 12:04:38 -0600
In-Reply-To: <20140528175530.GR11907@google.com>
References: <20140522230230.2856.40017.stgit@bling.home>
	 <20140522230755.2856.19714.stgit@bling.home>
	 <20140528175530.GR11907@google.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-28 at 11:55 -0600, Bjorn Helgaas wrote:
> On Thu, May 22, 2014 at 05:07:55PM -0600, Alex Williamson wrote:
> > Several Marvell devices and a JMicron device have a similar DMA
> > requester ID problem to Ricoh, except they use function 1 as the
> > PCIe requester ID.  Add a quirk for these to populate the DMA
> > function alias bitmap.
> 
> What's the DMA function alias bitmap?

Guess I missed updating this comment for v4.  Let me know if you have
other comments and I can either resend this individually or respin the
series.  Thanks,

Alex

> > Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> > ---
> >  drivers/pci/quirks.c |   36 ++++++++++++++++++++++++++++++++++++
> >  1 file changed, 36 insertions(+)
> > 
> > diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> > index bc8ebd9..923689f 100644
> > --- a/drivers/pci/quirks.c
> > +++ b/drivers/pci/quirks.c
> > @@ -3349,6 +3349,42 @@ static void quirk_dma_func0_alias(struct pci_dev *dev)
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe832, quirk_dma_func0_alias);
> >  DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_RICOH, 0xe476, quirk_dma_func0_alias);
> >  
> > +static void quirk_dma_func1_alias(struct pci_dev *dev)
> > +{
> > +	if (PCI_FUNC(dev->devfn) != 1) {
> > +		dev->dma_alias_devfn = PCI_DEVFN(PCI_SLOT(dev->devfn), 1);
> > +		dev->dev_flags |= PCI_DEV_FLAGS_DMA_ALIAS_DEVFN;
> > +	}
> > +}
> > +
> > +/*
> > + * Marvell 88SE9123 uses function 1 as the requester ID for DMA.  In some
> > + * SKUs function 1 is present and is a legacy IDE controller, in other
> > + * SKUs this function is not present, making this a ghost requester.
> > + * https://bugzilla.kernel.org/show_bug.cgi?id=42679
> > + */
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9123,
> > +			 quirk_dma_func1_alias);
> > +/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c14 */
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9130,
> > +			 quirk_dma_func1_alias);
> > +/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c47 + c57 */
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9172,
> > +			 quirk_dma_func1_alias);
> > +/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c59 */
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x917a,
> > +			 quirk_dma_func1_alias);
> > +/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c46 */
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x91a0,
> > +			 quirk_dma_func1_alias);
> > +/* https://bugzilla.kernel.org/show_bug.cgi?id=42679#c49 */
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9230,
> > +			 quirk_dma_func1_alias);
> > +/* https://bugs.gentoo.org/show_bug.cgi?id=497630 */
> > +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_JMICRON,
> > +			 PCI_DEVICE_ID_JMICRON_JMB388_ESD,
> > +			 quirk_dma_func1_alias);
> > +
> >  static struct pci_dev *pci_func_0_dma_source(struct pci_dev *dev)
> >  {
> >  	if (!PCI_FUNC(dev->devfn))
> > 



