Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886AbaFYI6E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 04:58:04 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:33746 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751755AbaFYI5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 04:57:38 -0400
Date: Wed, 25 Jun 2014 09:57:04 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] arm/gic: Add supports for GICv2m MSI(-X)
Message-ID: <20140625085703.GB29789@leverpostej>
References: <1403569980-12913-1-git-send-email-suravee.suthikulpanit@amd.com>
 <1403569980-12913-3-git-send-email-suravee.suthikulpanit@amd.com>
 <20140624101111.GD5856@leverpostej>
 <53AA3A3A.2050401@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53AA3A3A.2050401@amd.com>
Thread-Topic: [PATCH 2/2] arm/gic: Add supports for GICv2m MSI(-X)
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 03:55:54AM +0100, Suravee Suthikulanit wrote:
> Mark,
> 
> Thank you for all your comments. Please see my reply below. I have 
> omitted the minor ones.

Likewise.

> >> +static void free_msi_irq(struct gicv2m_msi_data *data, unsigned int irq)
> >> +{
> >> +       int pos;
> >> +
> >> +       spin_lock(&data->msi_cnt_lock);
> >> +
> >> +       pos = irq - data->spi_start;
> >> +       if (pos >= 0 && pos < data->max_spi_cnt)
> >
> > Should either of these cases ever happen?
> 
> This is to check if the irq provided is within the MSI range.

Sure, but surely this should only be called for the correct set of MSI
IRQs? Allowing this to be called for arbitrary interrupts without
reporting an error sounds wrong.

[...]

> >> +static int gicv2m_setup_msi_irq(struct msi_chip *chip, struct pci_dev *pdev,
> >> +                     struct msi_desc *desc)
> >> +{
> >> +       int avail, irq = 0;
> >> +       struct msi_msg msg;
> >> +       phys_addr_t addr;
> >> +       struct gicv2m_msi_data *data = to_gicv2m_msi_data(chip);
> >> +
> >> +       if (data == NULL) {
> >
> > If container_of returns NULL, you have bigger problems.
> 
> It was just sanity check. But, if you think this is obvious, I'll remove 
> this check then.

The issue is you check for NULL _after_ you've performed some pointer
arithmetic. Because the msi_chip is the first element of
gicv2m_msi_data, to_gicv2m_msi_data is currently an identity function
with some type casting, but we should rely on that here. What if the
msi_chip were moved to later in gicv2m_msi_data?

If you want to check for NULL, check chip before
to_gicv2m_msi_data(chip).

[...]

> >> +       /*
> >> +       * MSI_TYPER:
> >> +       *     [31:26] Reserved
> >> +       *     [25:16] lowest SPI assigned to MSI
> >> +       *     [15:10] Reserved
> >> +       *     [9:0]   Numer of SPIs assigned to MSI
> >> +       */
> >> +       val = __raw_readl(msi->base + MSI_TYPER);
> >
> > Are you sure you want to use __raw_readl?
> >
> Probably not.  I am replacing this with ioread32(msi->base + MSI_TYPER).

It's probably better to use readl() or a readl_relaxed() here for
consistency with the rest of the ARM code, but otherwise that sounds
sane.

Thanks,
Mark.
