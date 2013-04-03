Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762325Ab3DCQBc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 12:01:32 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:11160 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761607Ab3DCQBY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 12:01:24 -0400
X-IronPort-AV: E=Sophos;i="4.87,402,1363132800"; 
   d="scan'208";a="16454446"
Date: Wed, 3 Apr 2013 17:01:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Jan Beulich <JBeulich@suse.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        xen-devel <xen-devel@lists.xen.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen: drop tracking of IRQ vector
In-Reply-To: <515C5E6202000078000CA6BE@nat28.tlf.novell.com>
Message-ID: <alpine.DEB.2.02.1304031701100.5078@kaball.uk.xensource.com>
References: <515C5E6202000078000CA6BE@nat28.tlf.novell.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 3 Apr 2013, Jan Beulich wrote:
> For quite a few Xen versions, this wasn't the IRQ vector anymore
> anyway, and it is not being used by the kernel for anything. Hence
> drop the field from struct irq_info, and respective function
> parameters.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

> ---
>  arch/x86/pci/xen.c   |    6 +++---
>  drivers/xen/events.c |   13 ++++---------
>  include/xen/events.h |    3 +--
>  3 files changed, 8 insertions(+), 14 deletions(-)
> 
> --- 3.9-rc5/arch/x86/pci/xen.c
> +++ 3.9-rc5-xen-irq-no-vector/arch/x86/pci/xen.c
> @@ -177,7 +177,7 @@ static int xen_setup_msi_irqs(struct pci
>  		goto error;
>  	i = 0;
>  	list_for_each_entry(msidesc, &dev->msi_list, list) {
> -		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, v[i], 0,
> +		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, v[i],
>  					       (type == PCI_CAP_ID_MSIX) ?
>  					       "pcifront-msi-x" :
>  					       "pcifront-msi",
> @@ -244,7 +244,7 @@ static int xen_hvm_setup_msi_irqs(struct
>  			dev_dbg(&dev->dev,
>  				"xen: msi already bound to pirq=%d\n", pirq);
>  		}
> -		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, pirq, 0,
> +		irq = xen_bind_pirq_msi_to_irq(dev, msidesc, pirq,
>  					       (type == PCI_CAP_ID_MSIX) ?
>  					       "msi-x" : "msi",
>  					       DOMID_SELF);
> @@ -326,7 +326,7 @@ static int xen_initdom_setup_msi_irqs(st
>  		}
>  
>  		ret = xen_bind_pirq_msi_to_irq(dev, msidesc,
> -					       map_irq.pirq, map_irq.index,
> +					       map_irq.pirq,
>  					       (type == PCI_CAP_ID_MSIX) ?
>  					       "msi-x" : "msi",
>  						domid);
> --- 3.9-rc5/drivers/xen/events.c
> +++ 3.9-rc5-xen-irq-no-vector/drivers/xen/events.c
> @@ -85,8 +85,7 @@ enum xen_irq_type {
>   * event channel - irq->event channel mapping
>   * cpu - cpu this event channel is bound to
>   * index - type-specific information:
> - *    PIRQ - vector, with MSB being "needs EIO", or physical IRQ of the HVM
> - *           guest, or GSI (real passthrough IRQ) of the device.
> + *    PIRQ - physical IRQ, GSI, flags, and owner domain
>   *    VIRQ - virq number
>   *    IPI - IPI vector
>   *    EVTCHN -
> @@ -105,7 +104,6 @@ struct irq_info {
>  		struct {
>  			unsigned short pirq;
>  			unsigned short gsi;
> -			unsigned char vector;
>  			unsigned char flags;
>  			uint16_t domid;
>  		} pirq;
> @@ -211,7 +209,6 @@ static void xen_irq_info_pirq_init(unsig
>  				   unsigned short evtchn,
>  				   unsigned short pirq,
>  				   unsigned short gsi,
> -				   unsigned short vector,
>  				   uint16_t domid,
>  				   unsigned char flags)
>  {
> @@ -221,7 +218,6 @@ static void xen_irq_info_pirq_init(unsig
>  
>  	info->u.pirq.pirq = pirq;
>  	info->u.pirq.gsi = gsi;
> -	info->u.pirq.vector = vector;
>  	info->u.pirq.domid = domid;
>  	info->u.pirq.flags = flags;
>  }
> @@ -714,7 +710,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gs
>  		goto out;
>  	}
>  
> -	xen_irq_info_pirq_init(irq, 0, pirq, gsi, irq_op.vector, DOMID_SELF,
> +	xen_irq_info_pirq_init(irq, 0, pirq, gsi, DOMID_SELF,
>  			       shareable ? PIRQ_SHAREABLE : 0);
>  
>  	pirq_query_unmask(irq);
> @@ -762,8 +758,7 @@ int xen_allocate_pirq_msi(struct pci_dev
>  }
>  
>  int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
> -			     int pirq, int vector, const char *name,
> -			     domid_t domid)
> +			     int pirq, const char *name, domid_t domid)
>  {
>  	int irq, ret;
>  
> @@ -776,7 +771,7 @@ int xen_bind_pirq_msi_to_irq(struct pci_
>  	irq_set_chip_and_handler_name(irq, &xen_pirq_chip, handle_edge_irq,
>  			name);
>  
> -	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, domid, 0);
> +	xen_irq_info_pirq_init(irq, 0, pirq, 0, domid, 0);
>  	ret = irq_set_msi_desc(irq, msidesc);
>  	if (ret < 0)
>  		goto error_irq;
> --- 3.9-rc5/include/xen/events.h
> +++ 3.9-rc5-xen-irq-no-vector/include/xen/events.h
> @@ -90,8 +90,7 @@ int xen_bind_pirq_gsi_to_irq(unsigned gs
>  int xen_allocate_pirq_msi(struct pci_dev *dev, struct msi_desc *msidesc);
>  /* Bind an PSI pirq to an irq. */
>  int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
> -			     int pirq, int vector, const char *name,
> -			     domid_t domid);
> +			     int pirq, const char *name, domid_t domid);
>  #endif
>  
>  /* De-allocates the above mentioned physical interrupt. */
> 
> 
> 
