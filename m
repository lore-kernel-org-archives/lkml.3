Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3F1SpT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:45:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54346 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751513Ab3F1SpP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:45:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
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
Date: Fri, 28 Jun 2013 20:54:45 +0200
Message-ID: <4600759.u0rXpSLd62@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAErSpo7pLoiaOeCbL1yLjdSbW7n0E8NMfkLGYpj8N=bvYBRN5w@mail.gmail.com>
References: <1372177330-28013-1-git-send-email-mika.westerberg@linux.intel.com> <20130628095138.D5B7BE0090@blue.fi.intel.com> <CAErSpo7pLoiaOeCbL1yLjdSbW7n0E8NMfkLGYpj8N=bvYBRN5w@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 28, 2013 11:00:31 AM Bjorn Helgaas wrote:
> On Fri, Jun 28, 2013 at 3:51 AM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Bjorn Helgaas wrote:
> >> On Tue, Jun 25, 2013 at 10:22 AM, Mika Westerberg
> >> <mika.westerberg@linux.intel.com> wrote:
> >> > From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> >> >
> >> > With Thunderbolt you can chain devices: connect a new devices to plugged
> >> > one. In this case the slot is already enabled, but we still want to look
> >> > for new devices behind it.
> >> >
> >> > We're going to reuse enable_device() for rescan for new devices on the
> >> > enabled slot. Let's push the check up by stack.
> >> >
> >> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> >> > Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> >> > ---
> >> >  drivers/pci/hotplug/acpiphp_glue.c | 5 ++---
> >> >  1 file changed, 2 insertions(+), 3 deletions(-)
> >> >
> >> > diff --git a/drivers/pci/hotplug/acpiphp_glue.c b/drivers/pci/hotplug/acpiphp_glue.c
> >> > index 59df857..b983e29 100644
> >> > --- a/drivers/pci/hotplug/acpiphp_glue.c
> >> > +++ b/drivers/pci/hotplug/acpiphp_glue.c
> >> > @@ -688,9 +688,6 @@ static int __ref enable_device(struct acpiphp_slot *slot)
> >> >         int num, max, pass;
> >> >         LIST_HEAD(add_list);
> >> >
> >> > -       if (slot->flags & SLOT_ENABLED)
> >> > -               goto err_exit;
> >> > -
> >> >         list_for_each_entry(func, &slot->funcs, sibling)
> >> >                 acpiphp_bus_add(func);
> >> >
> >> > @@ -1242,6 +1239,8 @@ int acpiphp_enable_slot(struct acpiphp_slot *slot)
> >> >                 goto err_exit;
> >> >
> >> >         if (get_slot_status(slot) == ACPI_STA_ALL) {
> >> > +               if (slot->flags & SLOT_ENABLED)
> >> > +                       goto err_exit;
> >>
> >> Why do we check for SLOT_ENABLED at all?  I think we're handling a Bus
> >> Check notification, which means "re-enumerate on the device tree
> >> starting from the notification point."  It doesn't say anything about
> >> skipping the re-enumeration if we find a device that's already
> >> enabled.
> >>
> >> It seems like we ought to just re-enumerate all the way down in case a
> >> device was added farther down in the tree (which is what it sounds
> >> like Thunderbolt is doing).
> >
> > Currently (with patchset applied), we have two users of
> > acpiphp_enable_slot():
> >
> > - /sys/bus/pci/slots/*/power
> > - ACPI_NOTIFY_BUS_CHECK in _handle_hotplug_event_func().
> >
> > Both are not related to Thunderbolt.
> >
> > Although, I think remove the check is good idea, I prefer to keep it
> > separate from Thunderbolt enabling patchset, since it will change sysfs
> > ABI a bit and can potentially affect othe ACPI PCI hotplug
> > implementations.
> 
> I'll think about this some more, but if we can make a change that
> simplifies things and makes them more spec-compliant, and also happens
> to make Thunderbolt work, that sounds better than fixing Thunderbolt
> while leaving the wart there.
> 
> If we only fix Thunderbolt, it just feels like we're adding to an
> ever-growing "deferred maintenance" list.

I agree.

That change may be done in a separate patch, but it should be included in the
series.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
