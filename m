Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab3GANwF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 09:52:05 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:56082 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab3GANwC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 09:52:02 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        "Ronciak, John" <john.ronciak@intel.com>,
        "Penner, Miles J" <miles.j.penner@intel.com>,
        Bruce Allan <bruce.w.allan@intel.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/6] PCI: acpiphp: do not check for SLOT_ENABLED in enable_device()
Date: Mon, 01 Jul 2013 16:01:37 +0200
Message-ID: <1530651.ees8hXMYoR@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130701093217.GG9294@intel.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com> <4600759.u0rXpSLd62@vostro.rjw.lan> <20130701093217.GG9294@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 01, 2013 12:32:17 PM Mika Westerberg wrote:
> On Fri, Jun 28, 2013 at 08:54:45PM +0200, Rafael J. Wysocki wrote:
> > On Friday, June 28, 2013 11:00:31 AM Bjorn Helgaas wrote:
> > > On Fri, Jun 28, 2013 at 3:51 AM, Kirill A. Shutemov
> > > <kirill.shutemov@linux.intel.com> wrote:
> > > > Bjorn Helgaas wrote:
> > > >> On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
> > > >> <mika.westerberg@linux.intel.com> wrote:
> > > >> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> > > >> >
> > > >> > With Thunderbolt you can chain devices: connect a new devices to plugged
> > > >> > one. In this case the slot is already enabled, but we still want to look
> > > >> > for new devices behind it.
> > > >> >
> > > >> > We're going to reuse enable_device() for rescan for new devices on the
> > > >> > enabled slot. Let's push the check up by stack.
> > > >> >
> > > >> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > > >> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> > > >> > ---
> > > >> >  drivers/pci/hotplug/acpiphp_glue.c | 5 ++---
> > > >> >  1 file changed, 2 insertions(+), 3 deletions(-)
> > > >> >
> > > >> > diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> > > >> > index 59df857..b983e29 100644
> > > >> > --- a/drivers/pci/hotplug/acpiphp_glue.c
> > > >> > +++ b/drivers/pci/hotplug/acpiphp_glue.c
> > > >> > @@ -688,9 +688,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
> > > >> >         int num, max, pass;
> > > >> >         LIST_HEAD(add_list);
> > > >> >
> > > >> > -       if (slot->flags & SLOT_ENABLED)
> > > >> > -               goto err_exit;
> > > >> > -
> > > >> >         list_for_each_entry(func, &slot->funcs, sibling)
> > > >> >                 acpiphp_bus_add(func);
> > > >> >
> > > >> > @@ -1242,6 +1239,8 @@ int acpiphp_enable_slot(struct acpiphp_slot *slot)
> > > >> >                 goto err_exit;
> > > >> >
> > > >> >         if (get_slot_status(slot) == ACPI_STA_ALL) {
> > > >> > +               if (slot->flags & SLOT_ENABLED)
> > > >> > +                       goto err_exit;
> > > >>
> > > >> Why do we check for SLOT_ENABLED at all?  I think we're handling a Bus
> > > >> Check notification, which means "re-enumerate on the device tree
> > > >> starting from the notification point."  It doesn't say anything about
> > > >> skipping the re-enumeration if we find a device that's already
> > > >> enabled.
> > > >>
> > > >> It seems like we ought to just re-enumerate all the way down in case a
> > > >> device was added farther down in the tree (which is what it sounds
> > > >> like Thunderbolt is doing).
> > > >
> > > > Currently (with patchset applied), we have two users of
> > > > acpiphp_enable_slot():
> > > >
> > > > - /sys/bus/pci/slots/*/power
> > > > - ACPI_NOTIFY_BUS_CHECK in _handle_hotplug_event_func().
> > > >
> > > > Both are not related to Thunderbolt.
> > > >
> > > > Although, I think remove the check is good idea, I prefer to keep it
> > > > separate from Thunderbolt enabling patchset, since it will change sysfs
> > > > ABI a bit and can potentially affect othe ACPI PCI hotplug
> > > > implementations.
> > > 
> > > I'll think about this some more, but if we can make a change that
> > > simplifies things and makes them more spec-compliant, and also happens
> > > to make Thunderbolt work, that sounds better than fixing Thunderbolt
> > > while leaving the wart there.
> > > 
> > > If we only fix Thunderbolt, it just feels like we're adding to an
> > > ever-growing "deferred maintenance" list.
> > 
> > I agree.
> > 
> > That change may be done in a separate patch, but it should be included in the
> > series.
> 
> Given the fact that SLOT_ENABLED is only checked in acpiphp_enable_slot()
> (after this patch) and that /sys/bus/pci/slots/*/power uses SLOT_POWEREDON
> anyway, should we remove the whole flag?

Sure, if it is not necessary any more, we should remove it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
