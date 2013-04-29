Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023Ab3D2HVg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 03:21:36 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59316 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970Ab3D2HVe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Mon, 29 Apr 2013 03:21:34 -0400
Message-Id: <517E3BC102000078000D1793@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 29 Apr 2013 08:22:09 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Alexander Gordeev" <agordeev@redhat.com>
Cc: "Joerg Roedel" <joro@8bytes.org>, "Bjorn Helgaas" <bhelgaas@google.com>,
        "Suresh Siddha" <suresh.b.siddha@intel.com>, <x86@kernel.org>,
        "Yinghai Lu" <yinghai@kernel.org>, "Ingo Molnar" <mingo@redhat.com>,
        <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>
Subject: Re: [PATCH -tip/apic 2/2] x86/MSI: Allocate as many
 multiple-MSIs as requested
References: <cover.1367160713.git.agordeev@redhat.com>
 <eb84d5e5d4af81aa38832c21e49d3276f780a048.1367160713.git.agordeev@redhat.com>
In-Reply-To: <eb84d5e5d4af81aa38832c21e49d3276f780a048.1367160713.git.agordeev@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 29.04.13 at 06:33, Alexander Gordeev <agordeev@redhat.com> wrote:
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -55,19 +55,19 @@ static int do_setup_msi_irqs(struct pci_dev *dev, int nvec)
>  	unsigned int irq;
>  	struct msi_desc *msidesc;
>  
> -	nvec = __roundup_pow_of_two(nvec);
> -
>  	WARN_ON(!list_is_singular(&dev->msi_list));
>  	msidesc = list_entry(dev->msi_list.next, struct msi_desc, list);
>  	WARN_ON(msidesc->irq);
>  	WARN_ON(msidesc->msi_attrib.multiple);
> +	WARN_ON(msidesc->nvec);
>  
>  	node = dev_to_node(&dev->dev);
>  	irq = __create_irqs(get_nr_irqs_gsi(), nvec, node);
>  	if (irq == 0)
>  		return -ENOSPC;
>  
> -	msidesc->msi_attrib.multiple = ilog2(nvec);
> +	msidesc->nvec = nvec;
> +	msidesc->msi_attrib.multiple = ilog2(__roundup_pow_of_two(nvec));
>  	for (sub_handle = 0; sub_handle < nvec; sub_handle++) {
>  		if (!sub_handle) {
>  			index = msi_alloc_remapped_irq(dev, irq, nvec);

This breaks the interface to IOMMU-specific code: While Intel's
implementation does bump the number of allocated IRTEs to a
power of 2, AMD's doesn't, and hence the tail entries in the block
that don't get allocated here can get used for another device,
thus creating a security hole when both devices aren't owned by
the same guest (with the host being considered a special kind of
guest for this purpose).

IOW, while you can conserve on the number of vectors allocated,
you can't on the IRTEs, and I think this should be taken care of in
the generic IOMMU code, not in the individual vendor
implementations.

Jan

