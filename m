Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932810Ab3FQLsf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 07:48:35 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:40187 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932388Ab3FQLsd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 07:48:33 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jiang Liu <jiang.liu@huawei.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        "Alexander E . Patrakov" <patrakov@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yijing Wang <wangyijing@huawei.com>, linux-acpi@vger.kernel.org,
        Jiang Liu <liuj97@gmail.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [BUGFIX v2 4/4] ACPIPHP: fix bug 56531 Sony VAIO VPCZ23A4R: can't assign mem/io after docking
Date: Mon, 17 Jun 2013 13:57:44 +0200
Message-ID: <2687673.vC9cKToZFb@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1371238081-32260-5-git-send-email-jiang.liu@huawei.com>
References: <1371238081-32260-1-git-send-email-jiang.liu@huawei.com> <1371238081-32260-5-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, June 15, 2013 03:28:01 AM Jiang Liu wrote:
> Please refer to https://bugzilla.kernel.org/show_bug.cgi?id=56531 for
> more information.
> 
> This issue is caused by differences in PCI resource assignment between
> boot time and runtime hotplug. On x86 platforms, OS respects PCI
> resource assignment from BIOS and only reassign resources for unassigned
> BARs at boot time. But with acpiphp, it ignores BIOS resource assignment
> and reassign all resources by itself.
> 
> If we have enough resources, reassigning all PCI resources should work
> too, but it may fail if we are under resource constraints. On the other
> handle, current PCI MMIO alignment algorithm may waste huge MMIO address
> space if we have some PCI devices with huge MMIO BARs.
> 
> On this Sony laptop, BIOS allocates limited MMIO resources for the dock
> station and the dock station has a gfx which has a 256MB MMIO BAR.
> So current acpiphp driver fails to allocate resources for most devices
> on the dock station.
> 
> So change acpiphp driver to follow boot time behavior to respect BIOS
> resource assignment.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Reported-by: Alexander E. Patrakov <patrakov@gmail.com>
> Tested-by: Alexander E. Patrakov <patrakov@gmail.com>
> Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> Cc: linux-acpi@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: <stable@vger.kernel.org>

The code is fine as far as I'm concerned, but I have one request. ->

> ---
>  drivers/pci/hotplug/acpiphp_glue.c | 7 +++++--
>  drivers/pci/pci.h                  | 5 +++++
>  drivers/pci/setup-bus.c            | 8 ++++----
>  3 files changed, 14 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> index a65203b..f4a53e9 100644
> --- a/drivers/pci/hotplug/acpiphp_glue.c
> +++ b/drivers/pci/hotplug/acpiphp_glue.c
> @@ -687,6 +687,7 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>  	struct pci_bus *bus = slot->bridge->pci_bus;
>  	struct acpiphp_func *func;
>  	int num, max, pass;
> +	LIST_HEAD(add_list);
>  
>  	if (slot->flags & SLOT_ENABLED)
>  		goto err_exit;
> @@ -711,13 +712,15 @@ static int __ref enable_device(struct acpiphp_slot *slot)
>  				max = pci_scan_bridge(bus, dev, max, pass);
>  				if (pass && dev->subordinate) {
>  					check_hotplug_bridge(slot, dev);
> -					pci_bus_size_bridges(dev->subordinate);

Please add a comment explaining why we need to do this here.

> +					pcibios_resource_survey_bus(dev->subordinate);
> +					__pci_bus_size_bridges(dev->subordinate,
> +							       &add_list);
>  				}
>  			}
>  		}
>  	}
>  
> -	pci_bus_assign_resources(bus);
> +	__pci_bus_assign_resources(bus, &add_list, NULL);
>  	acpiphp_sanitize_bus(bus);
>  	acpiphp_set_hpp_values(bus);
>  	acpiphp_set_acpi_region(slot);
> diff --git a/drivers/pci/pci.h b/drivers/pci/pci.h
> index 68678ed..d1182c4 100644
> --- a/drivers/pci/pci.h
> +++ b/drivers/pci/pci.h
> @@ -202,6 +202,11 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
>  		    struct resource *res, unsigned int reg);
>  int pci_resource_bar(struct pci_dev *dev, int resno, enum pci_bar_type *type);
>  void pci_configure_ari(struct pci_dev *dev);
> +void __ref __pci_bus_size_bridges(struct pci_bus *bus,
> +			struct list_head *realloc_head);
> +void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
> +				      struct list_head *realloc_head,
> +				      struct list_head *fail_head);
>  
>  /**
>   * pci_ari_enabled - query ARI forwarding status
> diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
> index 16abaaa..d254e23 100644
> --- a/drivers/pci/setup-bus.c
> +++ b/drivers/pci/setup-bus.c
> @@ -1044,7 +1044,7 @@ handle_done:
>  	;
>  }
>  
> -static void __ref __pci_bus_size_bridges(struct pci_bus *bus,
> +void __ref __pci_bus_size_bridges(struct pci_bus *bus,
>  			struct list_head *realloc_head)
>  {
>  	struct pci_dev *dev;
> @@ -1115,9 +1115,9 @@ void __ref pci_bus_size_bridges(struct pci_bus *bus)
>  }
>  EXPORT_SYMBOL(pci_bus_size_bridges);
>  
> -static void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
> -					 struct list_head *realloc_head,
> -					 struct list_head *fail_head)
> +void __ref __pci_bus_assign_resources(const struct pci_bus *bus,
> +				      struct list_head *realloc_head,
> +				      struct list_head *fail_head)
>  {
>  	struct pci_bus *b;
>  	struct pci_dev *dev;

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
