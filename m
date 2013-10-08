Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756737Ab3JHW53 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 18:57:29 -0400
Received: from mail-db9lp0250.outbound.messaging.microsoft.com ([213.199.154.250]:20451
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756129Ab3JHW51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 18:57:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VS-3(zz98dI936eI1432Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzzz2dh2a8h839h93fhd24hf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h1155h)
Message-ID: <1381273037.7979.298.camel@snotra.buserror.net>
Subject: Re: [PATCH 1/7] powerpc: Add interface to get msi region information
From: Scott Wood <scottwood@freescale.com>
To: Bharat Bhushan <r65777@freescale.com>
CC: <alex.williamson@redhat.com>, <joro@8bytes.org>,
        <benh@kernel.crashing.org>, <galak@kernel.crashing.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-pci@vger.kernel.org>, <agraf@suse.de>,
        <iommu@lists.linux-foundation.org>,
        Bharat Bhushan <Bharat.Bhushan@freescale.com>
Date: Tue, 8 Oct 2013 17:57:17 -0500
In-Reply-To: <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
References: <1379575763-2091-1-git-send-email-Bharat.Bhushan@freescale.com>
	 <1379575763-2091-2-git-send-email-Bharat.Bhushan@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-09-19 at 12:59 +0530, Bharat Bhushan wrote:
> @@ -376,6 +405,7 @@ static int fsl_of_msi_probe(struct platform_device *dev)
>  	int len;
>  	u32 offset;
>  	static const u32 all_avail[] = { 0, NR_MSI_IRQS };
> +	static int bank_index;
>  
>  	match = of_match_device(fsl_of_msi_ids, &dev->dev);
>  	if (!match)
> @@ -419,8 +449,8 @@ static int fsl_of_msi_probe(struct platform_device *dev)
>  				dev->dev.of_node->full_name);
>  			goto error_out;
>  		}
> -		msi->msiir_offset =
> -			features->msiir_offset + (res.start & 0xfffff);
> +		msi->msiir = res.start + features->msiir_offset;
> +		printk("msi->msiir = %llx\n", msi->msiir);

dev_dbg or remove

>  	}
>  
>  	msi->feature = features->fsl_pic_ip;
> @@ -470,6 +500,7 @@ static int fsl_of_msi_probe(struct platform_device *dev)
>  		}
>  	}
>  
> +	msi->bank_index = bank_index++;

What if multiple MSIs are boing probed in parallel?  bank_index is not
atomic.

> diff --git a/arch/powerpc/sysdev/fsl_msi.h b/arch/powerpc/sysdev/fsl_msi.h
> index 8225f86..6bd5cfc 100644
> --- a/arch/powerpc/sysdev/fsl_msi.h
> +++ b/arch/powerpc/sysdev/fsl_msi.h
> @@ -29,12 +29,19 @@ struct fsl_msi {
>  	struct irq_domain *irqhost;
>  
>  	unsigned long cascade_irq;
> -
> -	u32 msiir_offset; /* Offset of MSIIR, relative to start of CCSR */
> +	dma_addr_t msiir; /* MSIIR Address in CCSR */

Are you sure dma_addr_t is right here, versus phys_addr_t?  It implies
that it's the output of the DMA API, but I don't think the DMA API is
used in the MSI driver.  Perhaps it should be, but we still want the raw
physical address to pass on to VFIO.

>  	void __iomem *msi_regs;
>  	u32 feature;
>  	int msi_virqs[NR_MSI_REG];
>  
> +	/*
> +	 * During probe each bank is assigned a index number.
> +	 * index number ranges from 0 to 2^32.
> +	 * Example  MSI bank 1 = 0
> +	 * MSI bank 2 = 1, and so on.
> +	 */
> +	int bank_index;

2^32 doesn't fit in "int" (nor does 2^32 - 1).

Just say that indices start at 0.

-Scott



