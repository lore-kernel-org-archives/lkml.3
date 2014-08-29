Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751792AbaH2XFn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 19:05:43 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:61050 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751624AbaH2XFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 19:05:41 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        EmanueL Czirai <amanual@openmailbox.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [Patch v4] x86, irq, PCI: Keep IRQ assignment for runtime power management
Date: Sat, 30 Aug 2014 01:24:53 +0200
Message-ID: <8823237.zCdVqYrZ5W@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAJZ5v0ikimRs4XJihULUdS-ZtU=xBMJECbKmzpUf1ZnzXijihQ@mail.gmail.com>
References: <1409304383-18806-1-git-send-email-jiang.liu@linux.intel.com> <CAJZ5v0ikimRs4XJihULUdS-ZtU=xBMJECbKmzpUf1ZnzXijihQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 29, 2014 04:42:34 PM Rafael J. Wysocki wrote:
> On Fri, Aug 29, 2014 at 11:26 AM, Jiang Liu <jiang.liu@linux.intel.com> wrote:
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
> > ---
> >  arch/x86/include/asm/io_apic.h |    2 ++
> >  arch/x86/kernel/apic/io_apic.c |   12 ++++++++++++
> >  arch/x86/pci/intel_mid_pci.c   |    2 +-
> >  arch/x86/pci/irq.c             |    2 +-
> >  drivers/acpi/pci_irq.c         |    4 ++++
> >  5 files changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
> > index 0aeed5ca356e..478c490f3654 100644
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
> > index 29290f554e79..1e9a921d9701 100644
> > --- a/arch/x86/kernel/apic/io_apic.c
> > +++ b/arch/x86/kernel/apic/io_apic.c
> > @@ -3946,6 +3946,18 @@ int mp_set_gsi_attr(u32 gsi, int trigger, int polarity, int node)
> >         return ret;
> >  }
> >
> > +bool mp_should_keep_irq(struct device *dev)
> > +{
> > +       if (dev->power.is_prepared)
> > +               return true;
> > +#ifdef CONFIG_PM_RUNTIME
> > +       if (dev->power.runtime_status == RPM_SUSPENDING)
> > +               return true;
> > +#endif
> 
> No, you can't do that.  It is racy and incorrect.

Well, maybe not.

> Please give me some time for looking into this.

So I guess the intended check is "Am I running in a suspend callback"?

Rafael

