Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab3F0NAK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:00:10 -0400
Received: from mga09.intel.com ([134.134.136.24]:31694 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab3F0NAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:00:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,952,1363158000"; 
   d="scan'208";a="336374200"
Date: Thu, 27 Jun 2013 16:04:04 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        John Ronciak <john.ronciak@intel.com>,
        Miles J Penner <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>
Subject: Re: [PATCH 2/6] PCI: acpiphp: enable_device(): rescan even if no new
 devices on slot
Message-ID: <20130627130404.GU9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-3-git-send-email-mika.westerberg@linux.intel.com>
 <CAE9FiQWy9E_s34DKOtoYcZoYTdgLCfwjiuSVPSk1ncpHYAWG0g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQWy9E_s34DKOtoYcZoYTdgLCfwjiuSVPSk1ncpHYAWG0g@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 06:20:24PM -0700, Yinghai Lu wrote:
> On Tue, Jun 25, 2013 at 9:22 AM, Mika Westerberg
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
> > +                                       }
> 
> No,
> this change will totally disable calling
> check_hotplug_bridge/pcibios_resource_survey_bus()
> 
> as pci_scan_bridge/pci_scan_child_bus will set dev->subordinate->is_added...
> 
> Please note: recently is_added setting is moved early before
> pci_bus_add_devices...

OK, thanks.

We will handle this in pcibios_resource_survey_bus() instead as suggested
by Bjorn.
