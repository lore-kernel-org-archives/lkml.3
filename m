Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753817Ab3FQSYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 14:24:18 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:59605 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751283Ab3FQSYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 14:24:16 -0400
Date: Mon, 17 Jun 2013 12:24:12 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Jiang Liu <jiang.liu@huawei.com>,
        "Rafael J . Wysocki" <rjw@sisk.pl>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Gu Zheng <guz.fnst@cn.fujitsu.com>, Toshi Kani <toshi.kani@hp.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing@huawei.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3, part2 20/20] PCI, ARM: use hotplug-safe PCI bus
 iterators to walk PCI buses
Message-ID: <20130617182412.GB4233@google.com>
References: <1369583597-3801-1-git-send-email-jiang.liu@huawei.com>
 <1369583597-3801-21-git-send-email-jiang.liu@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369583597-3801-21-git-send-email-jiang.liu@huawei.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 26, 2013 at 11:53:17PM +0800, Jiang Liu wrote:
> Enhance ARM architecture specific code to use new hotplug-safe PCI
> bus iterators to walk PCI buses.
> 
> Change pcibios_report_status implementation so that it doesn't access
> pci_root_buses global list. The pci_root_buses list will be scheduled
> to be removed.
> 
> Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Thierry Reding <thierry.reding@avionic-design.de>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/kernel/bios32.c           | 13 +------------
>  arch/arm/mach-footbridge/dc21285.c | 12 +++++++++++-
>  2 files changed, 12 insertions(+), 13 deletions(-)
> 
> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index b2ed73c..50ebbe8 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
> @@ -22,7 +22,7 @@ static int debug_pci;
>   * We can't use pci_find_device() here since we are
>   * called from interrupt context.
>   */
> -static void pcibios_bus_report_status(struct pci_bus *bus, u_int status_mask, int warn)
> +void pcibios_bus_report_status(struct pci_bus *bus, u_int status_mask, int warn)
>  {
>  	struct pci_dev *dev;
>  
> @@ -55,17 +55,6 @@ static void pcibios_bus_report_status(struct pci_bus *bus, u_int status_mask, in
>  			pcibios_bus_report_status(dev->subordinate, status_mask, warn);
>  }
>  
> -void pcibios_report_status(u_int status_mask, int warn)
> -{
> -	struct list_head *l;
> -
> -	list_for_each(l, &pci_root_buses) {
> -		struct pci_bus *bus = pci_bus_b(l);
> -
> -		pcibios_bus_report_status(bus, status_mask, warn);
> -	}
> -}
> -
>  /*
>   * We don't use this to fix the device, but initialisation of it.
>   * It's not the correct use for this, but it works.
> diff --git a/arch/arm/mach-footbridge/dc21285.c b/arch/arm/mach-footbridge/dc21285.c
> index a7cd2cf..a0f1d01 100644
> --- a/arch/arm/mach-footbridge/dc21285.c
> +++ b/arch/arm/mach-footbridge/dc21285.c
> @@ -35,7 +35,16 @@
>  				  PCI_STATUS_PARITY) << 16)
>  
>  extern int setup_arm_irq(int, struct irqaction *);
> -extern void pcibios_report_status(u_int status_mask, int warn);
> +extern void pcibios_report_bus_status(struct pci_bus *bus, u_int status_mask,
> +				      int warn);
> +
> +static struct pci_bus *dc21285_root_bus;
> +
> +static void pcibios_report_status(u_int status_mask, int warn)
> +{
> +	if (dc21285_root_bus)
> +		pcibios_report_bus_status(dc21285_root_bus, status_mask, warn);
> +}
>  
>  static unsigned long
>  dc21285_base_address(struct pci_bus *bus, unsigned int devfn)
> @@ -376,5 +385,6 @@ void __init dc21285_preinit(void)
>  
>  void __init dc21285_postinit(void)
>  {
> +	dc21285_root_bus = pci_get_next_root_bus(NULL);

It seems sort of ugly to scan the bus in pcibios_init_hw(), which
*returns* the struct pci_bus, then search for it here.  Why can't
we just remember the bus we scanned?

It's also a little dubious that we only do pcibios_report_status()
for footbridge.  That makes it look like it's debug code that might
not be necessary at all.

>  	register_isa_ports(DC21285_PCI_MEM, DC21285_PCI_IO, 0);
>  }
> -- 
> 1.8.1.2
> 
