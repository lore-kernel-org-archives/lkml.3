Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751333AbaKEWpM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 17:45:12 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:60620 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750867AbaKEWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 17:45:08 -0500
Date: Wed, 5 Nov 2014 15:45:04 -0700
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [Patch Part2 v4 20/31] PCI/MSI: Kill redundant calling for
 irq_set_msi_desc() for MSIx interrupts
Message-ID: <20141105224504.GG6168@google.com>
References: <1415102525-9898-1-git-send-email-jiang.liu@linux.intel.com>
 <1415102525-9898-21-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415102525-9898-21-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 04, 2014 at 08:01:54PM +0800, Jiang Liu wrote:
> It's arch_setup_msi_irq()/arch_setup_msi_irqs()'s responsibility to call
> irq_set_msi_desc() to associate IRQ descriptors and MSI descriptors,
> so kill the redundant call of irq_set_msi_desc() for MSIx interrupts
> in PCI MSI core.

"MSI-X" in English text, "msix" in code.

The default arch_setup_msi_irq() in drivers/pci/msi.c doesn't call
irq_set_msi_desc().  Does it happen somewhere inside chip->setup_irq()?

I don't know how to verify that there are calls in all the places needed.
That makes me wonder if the factoring is wrong -- maybe irq_set_msi_desc()
could be done in some common place.

> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> ---
>  drivers/pci/msi.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index afe974600c7d..da181c59394b 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -685,7 +685,6 @@ static void msix_program_entries(struct pci_dev *dev,
>  						PCI_MSIX_ENTRY_VECTOR_CTRL;
>  
>  		entries[i].vector = entry->irq;
> -		irq_set_msi_desc(entry->irq, entry);
>  		entry->masked = readl(entry->mask_base + offset);
>  		msix_mask_irq(entry, 1);
>  		i++;
> -- 
> 1.7.10.4
> 
