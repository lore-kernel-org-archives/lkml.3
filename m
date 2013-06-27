Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680Ab3F0NW6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 09:22:58 -0400
Received: from mga02.intel.com ([134.134.136.20]:15601 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751530Ab3F0NW5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 09:22:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,952,1363158000"; 
   d="scan'208";a="360474907"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
In-Reply-To: <CAErSpo4Ks+8PPvpscWZE7LrRd-daOzV-kJi6Oim42A+nZnp3HQ@mail.gmail.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com>
 <1372177330-28013-2-git-send-email-mika.westerberg@linux.intel.com>
 <CAErSpo4Ks+8PPvpscWZE7LrRd-daOzV-kJi6Oim42A+nZnp3HQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] PCI: acpiphp: do not check for SLOT_ENABLED in
 enable_device()
Content-Transfer-Encoding: 7bit
Message-Id: <20130627132545.3C8A4E0090@blue.fi.intel.com>
Date: Thu, 27 Jun 2013 16:25:45 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bjorn Helgaas wrote:
> On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
> <mika.westerberg@linux.intel.com> wrote:
> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >
> > With Thunderbolt you can chain devices: connect a new devices to plugged
> > one. In this case the slot is already enabled, but we still want to look
> > for new devices behind it.
> >
> > We're going to reuse enable_device() for rescan for new devices on the
> > enabled slot. Let's push the check up by stack.
> >
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > ---
> >  drivers/pci/hotplug/acpiphp_glue.c | 5 ++---
> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >
> > diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> > index 59df857..b983e29 100644
> > --- a/drivers/pci/hotplug/acpiphp_glue.c
> > +++ b/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -688,9 +688,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
> >         int num, max, pass;
> >         LIST_HEAD(add_list);
> >
> > -       if (slot->flags & SLOT_ENABLED)
> > -               goto err_exit;
> > -
> >         list_for_each_entry(func, &slot->funcs, sibling)
> >                 acpiphp_bus_add(func);
> >
> > @@ -1242,6 +1239,8 @@ int acpiphp_enable_slot(struct acpiphp_slot *slot)
> >                 goto err_exit;
> >
> >         if (get_slot_status(slot) == ACPI_STA_ALL) {
> > +               if (slot->flags & SLOT_ENABLED)
> > +                       goto err_exit;
> 
> Why do we check for SLOT_ENABLED at all?  I think we're handling a Bus
> Check notification, which means "re-enumerate on the device tree
> starting from the notification point."  It doesn't say anything about
> skipping the re-enumeration if we find a device that's already
> enabled.
> 
> It seems like we ought to just re-enumerate all the way down in case a
> device was added farther down in the tree (which is what it sounds
> like Thunderbolt is doing).

Okay, we will do more cleanup here.

The tricky part here is that acpiphp_enable_slot() is exposed to userspace
directly: /sys/bus/pci/slots/*/power files.

I wounder if complete drop of the check is an ABI change.

-- 
 Kirill A. Shutemov
