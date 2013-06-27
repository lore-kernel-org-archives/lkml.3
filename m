Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753916Ab3F0M6f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 08:58:35 -0400
Received: from mga01.intel.com ([192.55.52.88]:59698 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753571Ab3F0M6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 08:58:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,952,1363158000"; 
   d="scan'208";a="361418102"
Date: Thu, 27 Jun 2013 16:02:29 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 2/6] PCI: acpiphp: enable_device(): rescan even if no new
 devices on slot
Message-ID: <20130627130229.GT9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-3-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo4hvH08bNrObYODFVcwhhiGOj4cKntyJD6Aw6CjecgCow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4hvH08bNrObYODFVcwhhiGOj4cKntyJD6Aw6CjecgCow@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 05:37:58PM -0600, Bjorn Helgaas wrote:
> On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > pci_scan_slot() returns number of new devices connected *directly*
> > connected to the slot. Current enable_device() checks the return value
> > and stops if it doesn't see a new device.
> >
> > In Thunderbolt chaining case the new device can be deeper in hierarchy, so
> > do the rescan anyway.
> >
> > Because of that we must make sure that pcibios_resource_survey_bus() and
> > check_hotplug_bridge() get called only for a just found bus and not the
> > ones already added to the system. Failure to do so will lead to resource
> > conflicts.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/pci/hotplug/acpiphp_glue.c | 18 +++++++-----------
> >  1 file changed, 7 insertions(+), 11 deletions(-)
> >
> > diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> > index b983e29..80a6ea1 100644
> > --- a/drivers/pci/hotplug/acpiphp_glue.c
> > +++ b/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -685,18 +685,13 @@ static int __ref enable_device(struct acpiphp_slot *slot)
> >         struct pci_dev *dev;
> >         struct pci_bus *bus = slot->bridge->pci_bus;
> >         struct acpiphp_func *func;
> > -       int num, max, pass;
> > +       int max, pass;
> >         LIST_HEAD(add_list);
> >
> >         list_for_each_entry(func, &slot->funcs, sibling)
> >                 acpiphp_bus_add(func);
> >
> > -       num = pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
> > -       if (num == 0) {
> > -               /* Maybe only part of funcs are added. */
> > -               dbg("No new device found\n");
> > -               goto err_exit;
> > -       }
> > +       pci_scan_slot(bus, PCI_DEVFN(slot->device, 0));
> >
> >         max = acpiphp_max_busnr(bus);
> >         for (pass = 0; pass < 2; pass++) {
> 
> I think this is two logical changes: the change below looks like it
> could by done by itself first, followed by the change above.

Indeed. We'll going to drop the second change completely.

> 
> > @@ -707,8 +702,11 @@ static int __ref enable_device(struct acpiphp_slot *slot)
> >                             dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
> >                                 max = pci_scan_bridge(bus, dev, max, pass);
> >                                 if (pass && dev->subordinate) {
> > -                                       check_hotplug_bridge(slot, dev);
> > -                                       pcibios_resource_survey_bus(dev->subordinate);
> > +                                       if (!dev->subordinate->is_added) {
> > +                                               check_hotplug_bridge(slot, dev);
> > +                                               pcibios_resource_survey_bus(
> > +                                                       dev->subordinate);
> 
> It's a shame that pcibios_resource_survey_bus() can't be called twice.
>  It would be nice if it were smart enough to notice on the second call
> that "oh, resources have already been assigned, so there's nothing
> more to be done."  Did you look to see whether that's feasible?

I didn't but now that you mentioned I went and checked. I'm pretty sure we
can handle it there in the next revision and drop this change.
