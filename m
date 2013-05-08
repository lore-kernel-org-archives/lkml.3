Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939Ab3EHVxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 17:53:01 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:39477 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750881Ab3EHVw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 17:52:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Lance Ortiz <lance.ortiz@hp.com>
Cc: bhelgaas@google.com, lance_ortiz@hotmail.com, jiang.liu@huawei.com,
        tony.luck@intel.com, bp@alien8.de, rostedt@goodmis.org,
        mchehab@redhat.com, linux-acpi@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aerdrv: Move cper_print_pcie() out of interrupt context
Date: Thu, 09 May 2013 00:01:21 +0200
Message-ID: <2598827.AVAqMcfGuF@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130508171519.26724.63307.stgit@grignak.americas.hpqcorp.net>
References: <20130508171519.26724.63307.stgit@grignak.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 08, 2013 11:15:19 AM Lance Ortiz wrote:
> The following warning was seen on 3.9 when a corrected PCIe error was being
> handled by the AER subsystem.
> 
> WARNING: at .../drivers/pci/search.c:214 pci_get_dev_by_id+0x8a/0x90()
> 
> This occurred because code was added to the function cper_print_pcie() that
> calls the pci_get_domain_bus_and_slot() function.

Do you know which commit added that code?

> cper_print_pcie() is called
> in an interrupt context and pci_get* functions are not supposed to be called
> in that context hence the warning.
> 
> The solution is to move the call to cper_print_aer() out of the interrupt
> context and into aer_recover_queue() to avoid any warnings when calling
> pci_get* functions.

The way the changes are described here isn't particularly clear to me.  I'd say
something like

  If cper_print_aer() is called by aer_recover_work_func(), there won't be any
  reason to call it from cper_print_pcie() any more, in which case all of the
  problematic code needed only to prepare for the cper_print_aer() call,
  including the invocation of pci_get_domain_bus_and_slot() causing the warning
  to be printed, may be removed from there.  Make that happen."

Also, since aer_recover_work_func() is going to be the only existing caller of
cper_print_aer() after this change, as far as I can say, and it doesn't use the
function's first argument, that argument should be dropped entirely.

Thanks,
Rafael


> Signed-off-by: Lance Ortiz <lance.ortiz@hp.com>
> ---
> 
>  drivers/acpi/apei/cper.c           |   18 ------------------
>  drivers/acpi/apei/ghes.c           |    3 ++-
>  drivers/pci/pcie/aer/aerdrv_core.c |    6 +++++-
>  include/linux/aer.h                |    2 +-
>  4 files changed, 8 insertions(+), 21 deletions(-)
> 
> diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
> index 1e5d8a4..8713229 100644
> --- a/drivers/acpi/apei/cper.c
> +++ b/drivers/acpi/apei/cper.c
> @@ -250,10 +250,6 @@ static const char *cper_pcie_port_type_strs[] = {
>  static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  			    const struct acpi_hest_generic_data *gdata)
>  {
> -#ifdef CONFIG_ACPI_APEI_PCIEAER
> -	struct pci_dev *dev;
> -#endif
> -
>  	if (pcie->validation_bits & CPER_PCIE_VALID_PORT_TYPE)
>  		printk("%s""port_type: %d, %s\n", pfx, pcie->port_type,
>  		       pcie->port_type < ARRAY_SIZE(cper_pcie_port_type_strs) ?
> @@ -285,20 +281,6 @@ static void cper_print_pcie(const char *pfx, const struct cper_sec_pcie *pcie,
>  		printk(
>  	"%s""bridge: secondary_status: 0x%04x, control: 0x%04x\n",
>  	pfx, pcie->bridge.secondary_status, pcie->bridge.control);
> -#ifdef CONFIG_ACPI_APEI_PCIEAER
> -	dev = pci_get_domain_bus_and_slot(pcie->device_id.segment,
> -			pcie->device_id.bus, pcie->device_id.function);
> -	if (!dev) {
> -		pr_err("PCI AER Cannot get PCI device %04x:%02x:%02x.%d\n",
> -			pcie->device_id.segment, pcie->device_id.bus,
> -			pcie->device_id.slot, pcie->device_id.function);
> -		return;
> -	}
> -	if (pcie->validation_bits & CPER_PCIE_VALID_AER_INFO)
> -		cper_print_aer(pfx, dev, gdata->error_severity,
> -				(struct aer_capability_regs *) pcie->aer_info);
> -	pci_dev_put(dev);
> -#endif
>  }
>  
>  static const char *apei_estatus_section_flag_strs[] = {
> diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> index d668a8a..f2084b5 100644
> --- a/drivers/acpi/apei/ghes.c
> +++ b/drivers/acpi/apei/ghes.c
> @@ -454,7 +454,8 @@ static void ghes_do_proc(struct ghes *ghes,
>  				aer_severity = cper_severity_to_aer(sev);
>  				aer_recover_queue(pcie_err->device_id.segment,
>  						  pcie_err->device_id.bus,
> -						  devfn, aer_severity);
> +						  devfn, aer_severity,
> +						  pcie_err->aer_info);
>  			}
>  
>  		}
> diff --git a/drivers/pci/pcie/aer/aerdrv_core.c b/drivers/pci/pcie/aer/aerdrv_core.c
> index 564d97f..26aec0f 100644
> --- a/drivers/pci/pcie/aer/aerdrv_core.c
> +++ b/drivers/pci/pcie/aer/aerdrv_core.c
> @@ -582,6 +582,7 @@ struct aer_recover_entry
>  	u8	devfn;
>  	u16	domain;
>  	int	severity;
> +	u8	*regs;
>  };
>  
>  static DEFINE_KFIFO(aer_recover_ring, struct aer_recover_entry,
> @@ -595,7 +596,7 @@ static DEFINE_SPINLOCK(aer_recover_ring_lock);
>  static DECLARE_WORK(aer_recover_work, aer_recover_work_func);
>  
>  void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
> -		       int severity)
> +		       int severity, u8 *aer_regs)
>  {
>  	unsigned long flags;
>  	struct aer_recover_entry entry = {
> @@ -603,6 +604,7 @@ void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
>  		.devfn		= devfn,
>  		.domain		= domain,
>  		.severity	= severity,
> +		.regs		= aer_regs,
>  	};
>  
>  	spin_lock_irqsave(&aer_recover_ring_lock, flags);
> @@ -629,6 +631,8 @@ static void aer_recover_work_func(struct work_struct *work)
>  			       PCI_SLOT(entry.devfn), PCI_FUNC(entry.devfn));
>  			continue;
>  		}
> +		cper_print_aer("", pdev, entry.severity,
> +				(struct aer_capability_regs *)entry.regs);
>  		do_recovery(pdev, entry.severity);
>  		pci_dev_put(pdev);
>  	}
> diff --git a/include/linux/aer.h b/include/linux/aer.h
> index ec10e1b..a5c1583 100644
> --- a/include/linux/aer.h
> +++ b/include/linux/aer.h
> @@ -53,6 +53,6 @@ extern void cper_print_aer(const char *prefix, struct pci_dev *dev,
>  			   int cper_severity, struct aer_capability_regs *aer);
>  extern int cper_severity_to_aer(int cper_severity);
>  extern void aer_recover_queue(int domain, unsigned int bus, unsigned int devfn,
> -			      int severity);
> +			      int severity,  u8 *aer_regs);
>  #endif //_AER_H_
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
