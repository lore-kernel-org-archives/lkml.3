Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaH2WJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 18:09:15 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54218 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750889AbaH2WJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 18:09:14 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com
Cc: konrad.wilk@oracle.com, rdunlap@infradead.org, tony.luck@intel.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jiang.liu@linux.intel.com, grant.likely@linaro.org,
        amanual@openmailbox.org, yinghai@kernel.org, joro@8bytes.org,
        bp@alien8.de, benh@kernel.crashing.org, bhelgaas@google.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, irq, PCI: Keep IRQ assignment for runtime power management
Date: Sat, 30 Aug 2014 00:28:26 +0200
Message-ID: <2725061.eyECLCDiSG@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <2861943.vnKplTpJ6Z@vostro.rjw.lan>
References: <1409304383-18806-1-git-send-email-jiang.liu@linux.intel.com> <tip-9eabc99a635a77cbf0948ce17d3cbc2b51680d4a@git.kernel.org> <2861943.vnKplTpJ6Z@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, August 30, 2014 12:09:17 AM Rafael J. Wysocki wrote:
> On Friday, August 29, 2014 04:40:14 AM tip-bot for Jiang Liu wrote:
> > Commit-ID:  9eabc99a635a77cbf0948ce17d3cbc2b51680d4a
> > Gitweb:     http://git.kernel.org/tip/9eabc99a635a77cbf0948ce17d3cbc2b51680d4a
> > Author:     Jiang Liu <jiang.liu@linux.intel.com>
> > AuthorDate: Fri, 29 Aug 2014 17:26:23 +0800
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Fri, 29 Aug 2014 13:38:00 +0200
> > 
> > x86, irq, PCI: Keep IRQ assignment for runtime power management
> > 
> > Now IOAPIC driver dynamically allocates IRQ numbers for IOAPIC pins.
> > We need to keep IRQ assignment for PCI devices during runtime power
> > management, otherwise it may cause failure of device wakeups.
> > 
> > Commit 3eec595235c17a7 "x86, irq, PCI: Keep IRQ assignment for PCI
> > devices during suspend/hibernation" has fixed the issue for suspend/
> > hibernation, we also need the same fix for runtime device sleep too.
> >
> > Fix: https://bugzilla.kernel.org/show_bug.cgi?id=83271
> > Reported-and-Tested-by: EmanueL Czirai <amanual@openmailbox.org>
> > Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
> > Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Cc: Tony Luck <tony.luck@intel.com>
> > Cc: Joerg Roedel <joro@8bytes.org>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: EmanueL Czirai <amanual@openmailbox.org>
> > Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
> > Cc: Bjorn Helgaas <bhelgaas@google.com>
> > Cc: Randy Dunlap <rdunlap@infradead.org>
> > Cc: Yinghai Lu <yinghai@kernel.org>
> > Cc: Borislav Petkov <bp@alien8.de>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Link: http://lkml.kernel.org/r/1409304383-18806-1-git-send-email-jiang.liu@linux.intel.com
> > Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> 
> This patch is incorrect, can you please drop it/revert it?

Well, I'm actually not sure that it is correct, but also it is not as
outright incorrect as I thought.

The problem is that dev->power.runtime_status generally cannot be relied
on outside of dev.power->lock, but if mp_should_keep_irq() is guaranteed
to be executed from a callback run by rpm_suspend() for dev, then the
value will be RPM_SUSPENDING.

I'm not quite sure that this always is the case, however.


> > ---
> >  arch/x86/include/asm/io_apic.h |  2 ++
> >  arch/x86/kernel/apic/io_apic.c | 12 ++++++++++++
> >  arch/x86/pci/intel_mid_pci.c   |  2 +-
> >  arch/x86/pci/irq.c             |  2 +-
> >  drivers/acpi/pci_irq.c         |  4 ++++
> >  5 files changed, 20 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> > index 0aeed5c..478c490 100644
> > --- a/arch/x86/include/asm/io_apic.h
> > +++ b/arch/x86/include/asm/io_apic.h
> > @@ -227,6 +227,8 @@ static inline void io_apic_modify(unsigned int apic, unsigned int reg, unsigned
> >  
> >  extern void io_apic_eoi(unsigned int apic, unsigned int vector);
> >  
> > +extern bool mp_should_keep_irq(struct device *dev);
> > +
> >  #else  /* !CONFIG_X86_IO_APIC */
> >  
> >  #define io_apic_assign_pci_irqs 0
> > diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> > index 40a4aa3..337ce5a 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -3959,6 +3959,18 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
> >  	return ret;
> >  }
> >  
> > +bool mp_should_keep_irq(struct device *dev)
> > +{
> > +	if (dev->power.is_prepared)
> > +		return true;
> > +#ifdef	CONFIG_PM_RUNTIME
> > +	if (dev->power.runtime_status == RPM_SUSPENDING)
> > +		return true;
> > +#endif
> > +
> > +	return false;
> > +}
> > +
> >  /* Enable IOAPIC early just for system timer */
> >  void __init pre_init_apic_IRQ0(void)
> >  {
> > diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
> > index 3865116..b9958c3 100644
> > --- a/arch/x86/pci/intel_mid_pci.c
> > +++ b/arch/x86/pci/intel_mid_pci.c
> > @@ -229,7 +229,7 @@ static int intel_mid_pci_irq_enable(struct pci_dev *dev)
> >  
> >  static void intel_mid_pci_irq_disable(struct pci_dev *dev)
> >  {
> > -	if (!dev->dev.power.is_prepared && dev->irq > 0)
> > +	if (!mp_should_keep_irq(&dev->dev) && dev->irq > 0)
> >  		mp_unmap_irq(dev->irq);
> >  }
> >  
> > diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
> > index bc1a2c3..eb500c2 100644
> > --- a/arch/x86/pci/irq.c
> > +++ b/arch/x86/pci/irq.c
> > @@ -1256,7 +1256,7 @@ static int pirq_enable_irq(struct pci_dev *dev)
> >  
> >  static void pirq_disable_irq(struct pci_dev *dev)
> >  {
> > -	if (io_apic_assign_pci_irqs && !dev->dev.power.is_prepared &&
> > +	if (io_apic_assign_pci_irqs && !mp_should_keep_irq(&dev->dev) &&
> >  	    dev->irq) {
> >  		mp_unmap_irq(dev->irq);
> >  		dev->irq = 0;
> > diff --git a/drivers/acpi/pci_irq.c b/drivers/acpi/pci_irq.c
> > index c96887d..6e6b80e 100644
> > --- a/drivers/acpi/pci_irq.c
> > +++ b/drivers/acpi/pci_irq.c
> > @@ -484,6 +484,10 @@ void acpi_pci_irq_disable(struct pci_dev *dev)
> >  	/* Keep IOAPIC pin configuration when suspending */
> >  	if (dev->dev.power.is_prepared)
> >  		return;
> > +#ifdef	CONFIG_PM_RUNTIME
> > +	if (dev->dev.power.runtime_status == RPM_SUSPENDING)
> > +		return;
> > +#endif
> >  
> >  	entry = acpi_pci_irq_lookup(dev, pin);
> >  	if (!entry)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
