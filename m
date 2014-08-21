Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752855AbaHUQ7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 12:59:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:56252 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865AbaHUQ7o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 12:59:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,909,1406617200"; 
   d="scan'208";a="579982075"
Date: Thu, 21 Aug 2014 19:57:28 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Grant Likely <grant.likely@linaro.org>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        x86@kernel.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Patch V4 29/42] x86, irq: introduce two helper functions to
 support irqdomain map operation
Message-ID: <20140821165728.GV1660@lahna.fi.intel.com>
References: <1402302011-23642-1-git-send-email-jiang.liu@linux.intel.com>
 <1402302011-23642-30-git-send-email-jiang.liu@linux.intel.com>
 <20140821141729.GT1660@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821141729.GT1660@lahna.fi.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 05:17:29PM +0300, Mika Westerberg wrote:
> On Mon, Jun 09, 2014 at 04:19:58PM +0800, Jiang Liu wrote:
> > Currently there are multiple entries to program IOAPIC pins, such as
> > io_apic_setup_irq_pin_once(), io_apic_set_pci_routing() and
> > setup_IO_APIC_irq_extra() etc.
> > 
> > This patch introduces two functions to help consolidate the code to
> > program IOAPIC pins. Function mp_set_pin_attr() is used to optionally
> > set trigger, polarity and NUMA node property for an IOAPIC pin.
> > If mp_set_pin_attr() is not invoked for a pin, the default configuration
> > from BIOS will be used.
> > 
> > Function mp_irqdomain_map() is an common implementation of irqdomain map()
> > operation. It figures out attribures for pin and then actually programs
> > the IOAPIC pin. We hope this will be the only entrance for programming
> > IOAPIC pin.
> > 
> > And the flow will:
> > 1) caller such as xxx_pci_irq_enable figures out pin attributes.
> > 2) Invoke mp_set_pin_attr() to set attributes for a pin. If the pin has
> >    already bin programmed,  mp_set_pin_attr() will aslo detects attribute
> >    confictions.
> > 3) Invoke mp_map_pin_to_irq()
> > 3.1) If IRQ has already been assigned, return irq_find_mapping()
> > 3.2) Else irq_create_mapping()
> > 		->irq_domain_associate()
> > 			->mp_irqdomain_map()
> > 				->io_apic_setup_irq_pin()
> > 
> > So every pin will only programmed once by mp_irqdomain_map(), so we
> > could kill io_apic_setup_irq_pin_once(), io_apic_set_pci_routing() and
> > setup_IO_APIC_irq_extra() etc.
> > 
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> > ---
> >  arch/x86/include/asm/io_apic.h |    5 ++
> >  arch/x86/kernel/apic/io_apic.c |   99 +++++++++++++++++++++++++++++++++++++++-
> >  2 files changed, 103 insertions(+), 1 deletion(-)
> > 
> > diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> > index 3e4bea3a52b1..c53587868590 100644
> > --- a/arch/x86/include/asm/io_apic.h
> > +++ b/arch/x86/include/asm/io_apic.h
> > @@ -173,7 +173,9 @@ enum ioapic_domain_type {
> >  };
> >  
> >  struct device_node;
> > +struct irq_domain;
> >  struct irq_domain_ops;
> > +
> >  struct ioapic_domain_cfg {
> >  	enum ioapic_domain_type		type;
> >  	const struct irq_domain_ops	*ops;
> > @@ -192,6 +194,9 @@ extern u32 mp_pin_to_gsi(int ioapic, int pin);
> >  extern int mp_map_gsi_to_irq(u32 gsi, unsigned int flags);
> >  extern void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
> >  				      struct ioapic_domain_cfg *cfg);
> > +extern int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
> > +			    irq_hw_number_t hwirq);
> > +extern int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node);
> >  extern void __init pre_init_apic_IRQ0(void);
> >  
> >  extern void mp_save_irq(struct mpc_intsrc *m);
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index 9c5f70699a80..61aae90f7e23 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -87,6 +87,14 @@ static DEFINE_RAW_SPINLOCK(vector_lock);
> >  static DEFINE_MUTEX(ioapic_mutex);
> >  static unsigned int ioapic_dynirq_base;
> >  
> > +struct mp_pin_info {
> > +	int trigger;
> > +	int polarity;
> > +	int node;
> > +	int set;
> > +	u32 count;
> > +};
> > +
> >  static struct ioapic {
> >  	/*
> >  	 * # of IRQ routing registers
> > @@ -102,6 +110,7 @@ static struct ioapic {
> >  	struct mp_ioapic_gsi  gsi_config;
> >  	struct ioapic_domain_cfg irqdomain_cfg;
> >  	struct irq_domain *irqdomain;
> > +	struct mp_pin_info *pin_info;
> >  	DECLARE_BITMAP(pin_programmed, MP_MAX_IOAPIC_PIN + 1);
> >  } ioapics[MAX_IO_APICS];
> >  
> > @@ -147,6 +156,11 @@ static inline int mp_init_irq_at_boot(int ioapic, int irq)
> >  	return ioapic == 0 || (irq >= 0 && irq < nr_legacy_irqs());
> >  }
> >  
> > +static inline struct mp_pin_info *mp_pin_info(int ioapic_idx, int pin)
> > +{
> > +	return ioapics[ioapic_idx].pin_info + pin;
> > +}
> > +
> >  static inline struct irq_domain *mp_ioapic_irqdomain(int ioapic)
> >  {
> >  	return ioapics[ioapic].irqdomain;
> > @@ -1006,6 +1020,7 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
> >  {
> >  	int irq;
> >  	struct irq_domain *domain = mp_ioapic_irqdomain(ioapic);
> > +	struct mp_pin_info *info = mp_pin_info(ioapic, pin);
> >  
> >  	/*
> >  	 * Don't use irqdomain to manage ISA IRQs because there may be
> > @@ -1034,6 +1049,13 @@ static int mp_map_pin_to_irq(u32 gsi, int idx, int ioapic, int pin,
> >  	irq = irq_find_mapping(domain, pin);
> >  	if (irq <= 0 && (flags & IOAPIC_MAP_ALLOC))
> >  		irq = alloc_irq_from_domain(domain, gsi, pin);
> > +
> > +	if (flags & IOAPIC_MAP_ALLOC) {
> > +		if (irq > 0)
> > +			info->count++;
> > +		else if (info->count == 0)
> > +			info->set = 0;
> > +	}
> >  	mutex_unlock(&ioapic_mutex);
> >  
> >  	return irq > 0 ? irq : -1;
> > @@ -2923,18 +2945,27 @@ out:
> >  
> >  static int mp_irqdomain_create(int ioapic)
> >  {
> > +	size_t size;
> >  	int hwirqs = mp_ioapic_pin_count(ioapic);
> >  	struct ioapic *ip = &ioapics[ioapic];
> >  	struct ioapic_domain_cfg *cfg = &ip->irqdomain_cfg;
> >  	struct mp_ioapic_gsi *gsi_cfg = mp_ioapic_gsi_routing(ioapic);
> >  
> > +	size = sizeof(struct mp_pin_info) * mp_ioapic_pin_count(ioapic);
> > +	ip->pin_info = kzalloc(size, GFP_KERNEL);
> > +	if (!ip->pin_info)
> > +		return -ENOMEM;
> > +
> >  	if (cfg->type == IOAPIC_DOMAIN_INVALID)
> >  		return 0;
> >  
> >  	ip->irqdomain = irq_domain_add_linear(cfg->dev, hwirqs, cfg->ops,
> >  					      (void *)(long)ioapic);
> > -	if(!ip->irqdomain)
> > +	if(!ip->irqdomain) {
> > +		kfree(ip->pin_info);
> > +		ip->pin_info = NULL;
> >  		return -ENOMEM;
> > +	}
> >  
> >  	if (cfg->type == IOAPIC_DOMAIN_LEGACY ||
> >  	    cfg->type == IOAPIC_DOMAIN_STRICT)
> > @@ -3898,6 +3929,72 @@ void __init mp_register_ioapic(int id, u32 address, u32 gsi_base,
> >  	nr_ioapics++;
> >  }
> >  
> > +int mp_irqdomain_map(struct irq_domain *domain, unsigned int virq,
> > +		     irq_hw_number_t hwirq)
> > +{
> > +	int ioapic = (int)(long)domain->host_data;
> > +	struct mp_pin_info *info = mp_pin_info(ioapic, hwirq);
> > +	struct io_apic_irq_attr attr;
> > +
> > +	/*
> > +	 * Skip the timer IRQ if there's a quirk handler installed and if it
> > +	 * returns 1:
> > +	 */
> > +	if (apic->multi_timer_check &&
> > +	    apic->multi_timer_check(ioapic, virq))
> > +		return 0;
> > +
> > +	/* Get default attribute if not set by caller yet */
> > +	if (!info->set) {
> > +		u32 gsi = mp_pin_to_gsi(ioapic, hwirq);
> > +
> > +		if (acpi_get_override_irq(gsi, &info->trigger,
> > +					  &info->polarity) < 0) {
> 
> Sadly this seems to break LPSS ACPI enumerated devices.
> 
> Before this change /proc/interrupts say:
> 
>    0:         14          0          0          0   IO-APIC-edge      timer
>    1:         10          0          0          0   IO-APIC-edge      i8042
>    4:         79          0          0          0   IO-APIC-edge      serial
>    5:         52          0          0          0   IO-APIC-fasteoi   mmc0
>    6:          0          0          0          0   IO-APIC-fasteoi   dw_dmac
>    7:          0          0          0          0   IO-APIC-fasteoi   INT3432:00, INT3433:00
>    8:          1          0          0          0   IO-APIC-edge      rtc0
>    9:        174          0          0          0   IO-APIC-fasteoi   acpi
>   57:        476          0          0          0   PCI-MSI-edge      xhci_hcd
>   58:         17          0          0          0   PCI-MSI-edge      snd_hda_intel
> 
> After the change it looks like this:
> 
>   0:         14          0          0          0   IO-APIC-edge      timer
>   1:         10          0          0          0   IO-APIC-edge      i8042
>   4:         64          0          0          0   IO-APIC-edge      serial
>   5:          0          0          0          0   IO-APIC-edge      mmc0
>   6:          0          0          0          0   IO-APIC-edge      dw_dmac
>   7:          0          0          0          0   IO-APIC-edge      INT3432:00, INT3433:00
>   8:          1          0          0          0   IO-APIC-edge      rtc0
>   9:        173          0          0          0   IO-APIC-fasteoi   acpi
>  41:        471          0          0          0   PCI-MSI-edge      xhci_hcd
>  42:         17          0          0          0   PCI-MSI-edge      snd_hda_intel
> 
> Notice the interrupt triggering of IRQs 5, 6, and 7 has changed from level to
> edge. I also see this printed on the console:
> 
> [    1.676685] Failed to set pin attr for GSI6
> [    1.691708] Failed to set pin attr for GSI7
> [    1.706750] Failed to set pin attr for GSI7
> [    1.721768] Failed to set pin attr for GSI13
> [    1.736765] Failed to set pin attr for GSI5
> [    1.838342] Failed to set pin attr for GSI6
> 
> Any ideas how to get that fixed?
> 
> We used to handle this in drivers/acpi/resource.c:acpi_dev_get_irqresource() so
> that only IRQ() and IRQNoFlags() ACPI resources resort calling
> acpi_get_override_irq(). Now that doesn't help anymore.

There's also a bugzilla bug filed about this here where touchpad stopped
working:

https://bugzilla.kernel.org/show_bug.cgi?id=82601
