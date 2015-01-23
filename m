Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746AbbAWXIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 18:08:51 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:64563 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752532AbbAWXIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 18:08:45 -0500
Date: Fri, 23 Jan 2015 17:08:41 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Rusty Russell <rusty@rustcorp.com.au>, cornelia.huck@de.ibm.com,
        linux-pci@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        linux-arch@vger.kernel.org
Subject: Re: [PATCH v3 09/16] pci: add pci_iomap_range
Message-ID: <20150123230841.GS29776@google.com>
References: <1421256142-11512-1-git-send-email-mst@redhat.com>
 <1421256142-11512-10-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421256142-11512-10-git-send-email-mst@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 07:27:54PM +0200, Michael S. Tsirkin wrote:
> Virtio drivers should map the part of the BAR they need, not necessarily
> all of it.
> 
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: linux-pci@vger.kernel.org
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>

Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Sorry it took so long for me to notice these!

> ---
> 
> Bjorn, can you please ack this for merging through the virtio tree?
> 
>  include/asm-generic/pci_iomap.h | 10 ++++++++++
>  lib/pci_iomap.c                 | 35 ++++++++++++++++++++++++++++++-----
>  2 files changed, 40 insertions(+), 5 deletions(-)
> 
> diff --git a/include/asm-generic/pci_iomap.h b/include/asm-generic/pci_iomap.h
> index ce37349..7389c87 100644
> --- a/include/asm-generic/pci_iomap.h
> +++ b/include/asm-generic/pci_iomap.h
> @@ -15,6 +15,9 @@ struct pci_dev;
>  #ifdef CONFIG_PCI
>  /* Create a virtual mapping cookie for a PCI BAR (memory or IO) */
>  extern void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long max);
> +extern void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
> +				     unsigned long offset,
> +				     unsigned long maxlen);
>  /* Create a virtual mapping cookie for a port on a given PCI device.
>   * Do not call this directly, it exists to make it easier for architectures
>   * to override */
> @@ -30,6 +33,13 @@ static inline void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned lon
>  {
>  	return NULL;
>  }
> +
> +static inline void __iomem *pci_iomap_range(struct pci_dev *dev, int bar,
> +					    unsigned long offset,
> +					    unsigned long maxlen)
> +{
> +	return NULL;
> +}
>  #endif
>  
>  #endif /* __ASM_GENERIC_IO_H */
> diff --git a/lib/pci_iomap.c b/lib/pci_iomap.c
> index 0d83ea8..bcce5f1 100644
> --- a/lib/pci_iomap.c
> +++ b/lib/pci_iomap.c
> @@ -10,10 +10,11 @@
>  
>  #ifdef CONFIG_PCI
>  /**
> - * pci_iomap - create a virtual mapping cookie for a PCI BAR
> + * pci_iomap_range - create a virtual mapping cookie for a PCI BAR
>   * @dev: PCI device that owns the BAR
>   * @bar: BAR number
> - * @maxlen: length of the memory to map
> + * @offset: map memory at the given offset in BAR
> + * @maxlen: max length of the memory to map
>   *
>   * Using this function you will get a __iomem address to your device BAR.
>   * You can access it using ioread*() and iowrite*(). These functions hide
> @@ -21,16 +22,21 @@
>   * you expect from them in the correct way.
>   *
>   * @maxlen specifies the maximum length to map. If you want to get access to
> - * the complete BAR without checking for its length first, pass %0 here.
> + * the complete BAR from offset to the end, pass %0 here.
>   * */
> -void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
> +void __iomem *pci_iomap_range(struct pci_dev *dev,
> +			      int bar,
> +			      unsigned long offset,
> +			      unsigned long maxlen)
>  {
>  	resource_size_t start = pci_resource_start(dev, bar);
>  	resource_size_t len = pci_resource_len(dev, bar);
>  	unsigned long flags = pci_resource_flags(dev, bar);
>  
> -	if (!len || !start)
> +	if (len <= offset || !start)
>  		return NULL;
> +	len -= offset;
> +	start += offset;
>  	if (maxlen && len > maxlen)
>  		len = maxlen;
>  	if (flags & IORESOURCE_IO)
> @@ -43,6 +49,25 @@ void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
>  	/* What? */
>  	return NULL;
>  }
> +EXPORT_SYMBOL(pci_iomap_range);
>  
> +/**
> + * pci_iomap - create a virtual mapping cookie for a PCI BAR
> + * @dev: PCI device that owns the BAR
> + * @bar: BAR number
> + * @maxlen: length of the memory to map
> + *
> + * Using this function you will get a __iomem address to your device BAR.
> + * You can access it using ioread*() and iowrite*(). These functions hide
> + * the details if this is a MMIO or PIO address space and will just do what
> + * you expect from them in the correct way.
> + *
> + * @maxlen specifies the maximum length to map. If you want to get access to
> + * the complete BAR without checking for its length first, pass %0 here.
> + * */
> +void __iomem *pci_iomap(struct pci_dev *dev, int bar, unsigned long maxlen)
> +{
> +	return pci_iomap_range(dev, bar, 0, maxlen);
> +}
>  EXPORT_SYMBOL(pci_iomap);
>  #endif /* CONFIG_PCI */
> -- 
> MST
> 
