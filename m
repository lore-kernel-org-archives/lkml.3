Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082Ab3GaNgt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:36:49 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:46599 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759920Ab3GaNgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:36:42 -0400
Date: Wed, 31 Jul 2013 09:36:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Zhenzhong Duan <zhenzhong.duan@oracle.com>
Cc: linux-pci@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        xen-devel <xen-devel@lists.xen.org>, bhelgaas@google.com,
        Feng Jin <joe.jin@oracle.com>, "x86@kernel.org" <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 3/3 v2] Update x86_msi.restore_msi_irqs API param
Message-ID: <20130731133622.GA22594@phenom.dumpdata.com>
References: <51F7208D.60604@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <51F7208D.60604@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 30, 2013 at 10:10:21AM +0800, Zhenzhong Duan wrote:
> Change x86_msi.restore_msi_irqs(struct pci_dev *dev, int irq) to
> x86_msi.restore_msi_irqs(struct pci_dev *dev)
> 
> >From its naming, restore_msi_irqs is used to restore multiple msix irqs,
> param 'int irq' is unneeded. This could make code looks consistent in vm
> and bare metal.

Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Dom0 msix restore code could be optimized a bit with this change.

This part of the comment I don't think is needed.

Thanks!
> 
> Signed-off-by: Zhenzhong Duan <zhenzhong.duan@oracle.com>
> ---
>  arch/x86/include/asm/pci.h      |    8 ++++----
>  arch/x86/include/asm/x86_init.h |    2 +-
>  arch/x86/pci/xen.c              |    2 +-
>  drivers/pci/msi.c               |   17 ++++++++++++-----
>  4 files changed, 18 insertions(+), 11 deletions(-)
> 
> diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
> index d9e9e6c..40cbea4 100644
> --- a/arch/x86/include/asm/pci.h
> +++ b/arch/x86/include/asm/pci.h
> @@ -115,9 +115,9 @@ static inline void x86_teardown_msi_irq(unsigned int irq)
>  {
>  	x86_msi.teardown_msi_irq(irq);
>  }
> -static inline void x86_restore_msi_irqs(struct pci_dev *dev, int irq)
> +static inline void x86_restore_msi_irqs(struct pci_dev *dev)
>  {
> -	x86_msi.restore_msi_irqs(dev, irq);
> +	x86_msi.restore_msi_irqs(dev);
>  }
>  #define arch_setup_msi_irqs x86_setup_msi_irqs
>  #define arch_teardown_msi_irqs x86_teardown_msi_irqs
> @@ -127,14 +127,14 @@ static inline void x86_restore_msi_irqs(struct pci_dev *dev, int irq)
>  struct msi_desc;
>  int native_setup_msi_irqs(struct pci_dev *dev, int nvec, int type);
>  void native_teardown_msi_irq(unsigned int irq);
> -void native_restore_msi_irqs(struct pci_dev *dev, int irq);
> +void native_restore_msi_irqs(struct pci_dev *dev);
>  int setup_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc,
>  		  unsigned int irq_base, unsigned int irq_offset);
>  /* default to the implementation in drivers/lib/msi.c */
>  #define HAVE_DEFAULT_MSI_TEARDOWN_IRQS
>  #define HAVE_DEFAULT_MSI_RESTORE_IRQS
>  void default_teardown_msi_irqs(struct pci_dev *dev);
> -void default_restore_msi_irqs(struct pci_dev *dev, int irq);
> +void default_restore_msi_irqs(struct pci_dev *dev);
>  #else
>  #define native_setup_msi_irqs		NULL
>  #define native_teardown_msi_irq		NULL
> diff --git a/arch/x86/include/asm/x86_init.h b/arch/x86/include/asm/x86_init.h
> index 828a156..f58a9c7 100644
> --- a/arch/x86/include/asm/x86_init.h
> +++ b/arch/x86/include/asm/x86_init.h
> @@ -180,7 +180,7 @@ struct x86_msi_ops {
>  			       u8 hpet_id);
>  	void (*teardown_msi_irq)(unsigned int irq);
>  	void (*teardown_msi_irqs)(struct pci_dev *dev);
> -	void (*restore_msi_irqs)(struct pci_dev *dev, int irq);
> +	void (*restore_msi_irqs)(struct pci_dev *dev);
>  	int  (*setup_hpet_msi)(unsigned int irq, unsigned int id);
>  };
>  
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 48e8461..cdd869f 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -337,7 +337,7 @@ out:
>  	return ret;
>  }
>  
> -static void xen_initdom_restore_msi_irqs(struct pci_dev *dev, int irq)
> +static void xen_initdom_restore_msi_irqs(struct pci_dev *dev)
>  {
>  	int ret = 0;
>  
> diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
> index 922fb49..d4ccfeb 100644
> --- a/drivers/pci/msi.c
> +++ b/drivers/pci/msi.c
> @@ -214,7 +214,7 @@ void unmask_msi_irq(struct irq_data *data)
>  #endif /* CONFIG_GENERIC_HARDIRQS */
>  
>  #ifdef HAVE_DEFAULT_MSI_RESTORE_IRQS
> -void default_restore_msi_irqs(struct pci_dev *dev, int irq)
> +static void default_restore_msi_irq(struct pci_dev *dev, int irq)
>  {
>  	int pos;
>  	u16 control;
> @@ -244,6 +244,15 @@ void default_restore_msi_irqs(struct pci_dev *dev, int irq)
>  		}
>  	}
>  }
> +
> +void default_restore_msi_irqs(struct pci_dev *dev)
> +{
> +	struct msi_desc *entry;
> +
> +	list_for_each_entry(entry, &dev->msi_list, list) {
> +		default_restore_msi_irq(dev, entry->irq);
> +	}
> +}
>  #endif
>  
>  void __read_msi_msg(struct msi_desc *entry, struct msi_msg *msg)
> @@ -416,7 +425,7 @@ static void __pci_restore_msi_state(struct pci_dev *dev)
>  
>  	pci_intx_for_msi(dev, 0);
>  	msi_set_enable(dev, 0);
> -	arch_restore_msi_irqs(dev, dev->irq);
> +	arch_restore_msi_irqs(dev);
>  
>  	pci_read_config_word(dev, dev->msi_cap + PCI_MSI_FLAGS, &control);
>  	control &= ~PCI_MSI_FLAGS_QSIZE;
> @@ -440,9 +449,7 @@ static void __pci_restore_msix_state(struct pci_dev *dev)
>  	control |= PCI_MSIX_FLAGS_ENABLE | PCI_MSIX_FLAGS_MASKALL;
>  	pci_write_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, control);
>  
> -	list_for_each_entry(entry, &dev->msi_list, list) {
> -		arch_restore_msi_irqs(dev, entry->irq);
> -	}
> +	arch_restore_msi_irqs(dev);
>  
>  	control &= ~PCI_MSIX_FLAGS_MASKALL;
>  	pci_write_config_word(dev, dev->msix_cap + PCI_MSIX_FLAGS, control);
> -- 
> 1.7.3
> 
