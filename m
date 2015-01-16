Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753492AbbAPKMK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 05:12:10 -0500
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:37116 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813AbbAPKME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 05:12:04 -0500
Date: Fri, 16 Jan 2015 11:11:56 +0100 (CET)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@denkbrett
To: "Michael S. Tsirkin" <mst@redhat.com>
cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Cornelia Huck <cornelia.huck@de.ibm.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 10/16] s390: add pci_iomap_range
In-Reply-To: <1421256142-11512-11-git-send-email-mst@redhat.com>
Message-ID: <alpine.LFD.2.11.1501161051380.1742@denkbrett>
References: <1421256142-11512-1-git-send-email-mst@redhat.com> <1421256142-11512-11-git-send-email-mst@redhat.com>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011610-0021-0000-0000-00000291175F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Jan 2015, Michael S. Tsirkin wrote:
> Virtio drivers should map the part of the range they need, not
> necessarily all of it.
> To this end, support mapping ranges within BAR on s390.
> Since multiple ranges can now be mapped within a BAR, we keep track of
> the number of mappings created, and only clear out the mapping for a BAR
> when this number reaches 0.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Tested-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Heiko, Martin, can you please ack merging this through the virtio tree?
> This was lightly tested by Sebastian Ott.
> 
>  arch/s390/include/asm/pci_io.h |  1 +
>  arch/s390/pci/pci.c            | 34 +++++++++++++++++++++++++++-------
>  2 files changed, 28 insertions(+), 7 deletions(-)
> 
> diff --git a/arch/s390/include/asm/pci_io.h b/arch/s390/include/asm/pci_io.h
> index f664e96..1a9a98d 100644
> --- a/arch/s390/include/asm/pci_io.h
> +++ b/arch/s390/include/asm/pci_io.h
> @@ -16,6 +16,7 @@
>  struct zpci_iomap_entry {
>  	u32 fh;
>  	u8 bar;
> +	u16 count;
>  };
> 
>  extern struct zpci_iomap_entry *zpci_iomap_start;
> diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
> index 3290f11..753a567 100644
> --- a/arch/s390/pci/pci.c
> +++ b/arch/s390/pci/pci.c
> @@ -259,7 +259,10 @@ void __iowrite64_copy(void __iomem *to, const void *from, size_t count)
>  }
> 
>  /* Create a virtual mapping cookie for a PCI BAR */
> -void __iomem *pci_iomap(struct pci_dev *pdev, int bar, unsigned long max)
> +void __iomem *pci_iomap_range(struct pci_dev *pdev,
> +			      int bar,
> +			      unsigned long offset,
> +			      unsigned long max)
>  {
>  	struct zpci_dev *zdev =	get_zdev(pdev);
>  	u64 addr;
> @@ -270,14 +273,27 @@ void __iomem *pci_iomap(struct pci_dev *pdev, int bar, unsigned long max)
> 
>  	idx = zdev->bars[bar].map_idx;
>  	spin_lock(&zpci_iomap_lock);
> -	zpci_iomap_start[idx].fh = zdev->fh;
> -	zpci_iomap_start[idx].bar = bar;
> +	if (zpci_iomap_start[idx].count++) {
> +		BUG_ON(zpci_iomap_start[idx].fh != zdev->fh ||
> +		       zpci_iomap_start[idx].bar != bar);
> +	} else {
> +		zpci_iomap_start[idx].fh = zdev->fh;
> +		zpci_iomap_start[idx].bar = bar;
> +	}
> +	/* Detect overrun */
> +	BUG_ON(!zpci_iomap_start[idx].count);
>  	spin_unlock(&zpci_iomap_lock);
> 
>  	addr = ZPCI_IOMAP_ADDR_BASE | ((u64) idx << 48);
> -	return (void __iomem *) addr;
> +	return (void __iomem *) addr + offset;
>  }
> -EXPORT_SYMBOL_GPL(pci_iomap);
> +EXPORT_SYMBOL_GPL(pci_iomap_range);
> +
> +void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
> +{
> +	return pci_iomap_range(dev, bar, 0, maxlen);
> +}
> +EXPORT_SYMBOL(pci_iomap);

As discussed earlier, could you please leave that as EXPORT_SYMBOL_GPL.
If there's a reason to have these interfaces as EXPORT_SYMBOL, we could
change all of them in an extra patch.

With this change integrated you can add
Acked-by: Sebastian Ott <sebott@linux.vnet.ibm.com>

Regards,
Sebastian

> 
>  void pci_iounmap(struct pci_dev *pdev, void __iomem *addr)
>  {
> @@ -285,8 +301,12 @@ void pci_iounmap(struct pci_dev *pdev, void __iomem *addr)
> 
>  	idx = (((__force u64) addr) & ~ZPCI_IOMAP_ADDR_BASE) >> 48;
>  	spin_lock(&zpci_iomap_lock);
> -	zpci_iomap_start[idx].fh = 0;
> -	zpci_iomap_start[idx].bar = 0;
> +	/* Detect underrun */
> +	BUG_ON(!zpci_iomap_start[idx].count);
> +	if (!--zpci_iomap_start[idx].count) {
> +		zpci_iomap_start[idx].fh = 0;
> +		zpci_iomap_start[idx].bar = 0;
> +	}
>  	spin_unlock(&zpci_iomap_lock);
>  }
>  EXPORT_SYMBOL_GPL(pci_iounmap);
> -- 
> MST
> 
> 

