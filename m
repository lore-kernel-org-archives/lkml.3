Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab3GWBkg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:40:36 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:33891 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753536Ab3GWBke (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:40:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH v2 1/8] x86/PCI: prevent re-allocation of already existing bridge and ROM resources
Date: Tue, 23 Jul 2013 03:50:36 +0200
Message-ID: <2765266.7xyo4HkKBQ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo5=-32QSZ_RtLgU_67gMF6RVcnTAG6oKJ_Uz7uf4pXRkA@mail.gmail.com>
References: <1372860295-8306-1-git-send-email-mika.westerberg@linux.intel.com> <CAErSpo7=ed3=P7ab9zYB23qnwe8Z-ghRfCEurskpcNW5m86j8g@mail.gmail.com> <CAErSpo5=-32QSZ_RtLgU_67gMF6RVcnTAG6oKJ_Uz7uf4pXRkA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 22, 2013 07:18:38 PM Bjorn Helgaas wrote:
> On Mon, Jul 22, 2013 at 6:08 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> > On Wed, Jul 3, 2013 at 8:04 AM, Mika Westerberg
> > <mika.westerberg@linux.intel.com> wrote:
> >> In hotplug case (especially with Thunderbolt enabled systems) we might need
> >> to call pcibios_resource_survey_bus() several times for a bus. The function
> >> ends up calling pci_claim_resource() for each bridge resource that then
> >> fails claiming that the resource exists already (which it does). Once this
> >> happens the resource is invalidated thus preventing devices behind the
> >> bridge to allocate their resources.
> >>
> >> To fix this we do what has been done in pcibios_allocate_dev_resources()
> >> and check 'parent' of the given resource. If it is non-NULL it means that
> >> the resource has been allocated already and we can skip it. We do the same
> >> for ROM resources as well.
> >>
> >> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >
> > This looks reasonable to me.
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks a lot!

> > However, the use of "r->parent" to determine whether the resource is
> > already allocated is nothing specific to x86.  So I think we might be
> > missing an opportunity to make this more consistent across
> > architectures.  I looked at other callers of pci_claim_resource() for
> > bridge and ROM resources, and it looks like we might be able to make
> > similar changes in:
> >
> >   frv pcibios_allocate_bus_resources()
> >   ia64 pcibios_fixup_resources() (via pcibios_fixup_bridge_resources())
> >   mn10300 pcibios_allocate_bus_resources()
> >   mn10300 pcibios_assign_resources() (ROM)
> >   mn10300 pcibios_fixup_device_resources()
> >   parisc lba_fixup_bus()
> >
> > I really hate the idea of fixing something for x86 but not for other
> > arches, so maybe somebody could take a deeper look at this and see if
> > it would make sense to change the other arches, too.
> >
> > Bjorn
> >
> >> ---
> >>  arch/x86/pci/i386.c | 4 ++++
> >>  1 file changed, 4 insertions(+)
> >>
> >> diff --git a/arch/x86/pci/i386.c b/arch/x86/pci/i386.c
> >> index 94919e3..db6b1ab 100644
> >> --- a/arch/x86/pci/i386.c
> >> +++ b/arch/x86/pci/i386.c
> >> @@ -210,6 +210,8 @@ static void pcibios_allocate_bridge_resources(struct pci_dev *dev)
> >>                 r = &dev->resource[idx];
> >>                 if (!r->flags)
> >>                         continue;
> >> +               if (r->parent)  /* Already allocated */
> >> +                       continue;
> >>                 if (!r->start || pci_claim_resource(dev, idx) < 0) {
> >>                         /*
> >>                          * Something is wrong with the region.
> >> @@ -318,6 +320,8 @@ static void pcibios_allocate_dev_rom_resource(struct pci_dev *dev)
> >>         r = &dev->resource[PCI_ROM_RESOURCE];
> >>         if (!r->flags || !r->start)
> >>                 return;
> >> +       if (r->parent) /* Already allocated */
> >> +               return;
> >>
> >>         if (pci_claim_resource(dev, PCI_ROM_RESOURCE) < 0) {
> >>                 r->end -= r->start;
> >> --
> >> 1.8.3.2
> >>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
