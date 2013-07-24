Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751435Ab3GXMMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 08:12:49 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37650 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750909Ab3GXMMr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 08:12:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 0/30] ACPI / hotplug / PCI: Major rework + Thunderbolt workarounds
Date: Wed, 24 Jul 2013 14:22:50 +0200
Message-ID: <3731352.ObxOHG6eQe@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQURY5WFFJekPHV_s0HPi8uhKzSDOLSXHAkyLPf1=i8oAw@mail.gmail.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <3215120.cRBBS5jciE@vostro.rjw.lan> <CAE9FiQURY5WFFJekPHV_s0HPi8uhKzSDOLSXHAkyLPf1=i8oAw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 23, 2013 07:20:53 PM Yinghai Lu wrote:
> On Tue, Jul 23, 2013 at 2:39 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Ugh, stupid bug, sorry about it.  We try to unregister something that may have
> > not been registered.
> >
> > Can you please check if the appended patch helps (on top of
> > linux-pm.git/linux-next)?
> >
> > Rafael
> >
> >
> > ---
> >  drivers/pci/hotplug/acpiphp_glue.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > ===================================================================
> > --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> > +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -340,6 +340,7 @@ static acpi_status register_slot(acpi_ha
> >
> >                 retval = acpiphp_register_hotplug_slot(slot, sun);
> >                 if (retval) {
> > +                       slot->slot = NULL;
> >                         bridge->nr_slots--;
> >                         if (retval == -EBUSY)
> >                                 warn("Slot %llu already registered by another "
> > @@ -429,7 +430,8 @@ static void cleanup_bridge(struct acpiph
> >                                         err("failed to remove notify handler\n");
> >                         }
> >                 }
> > -               acpiphp_unregister_hotplug_slot(slot);
> > +               if (slot->slot)
> > +                       acpiphp_unregister_hotplug_slot(slot);
> >         }
> >
> >         mutex_lock(&bridge_mutex);
> >
> 
> yes, that fixes the problem. Thanks

Great, thanks for testing!

I'm adding this to the series (after commit 7342798):

---
From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Subject: ACPI / hotplug / PCI: Fix NULL pointer dereference in cleanup_bridge()

After commit bbd34fc (ACPI / hotplug / PCI: Register all devices
under the given bridge) register_slot() is called for all PCI
devices under a given bridge that have corresponding objects in
the ACPI namespace, but it calls acpiphp_register_hotplug_slot()
only for devices satisfying specific criteria.  Still,
cleanup_bridge() calls acpiphp_unregister_hotplug_slot() for all
objects created by register_slot(), although it should only call it
for the ones that acpiphp_register_hotplug_slot() has been called
for (successfully).  This causes a NULL pointer to be dereferenced
by the acpiphp_unregister_hotplug_slot() executed by cleanup_bridge()
if the object it is called for has not been passed to
acpiphp_register_hotplug_slot().

To fix this problem, check if the 'slot' field of the object passed
to acpiphp_unregister_hotplug_slot() in cleanup_bridge() is not NULL,
which only is the case if acpiphp_register_hotplug_slot() has been
executed for that object.  In addition to that, make register_slot()
reset the 'slot' field to NULL if acpiphp_register_hotplug_slot() has
failed for the given object to prevent stale pointers from being
used by acpiphp_unregister_hotplug_slot().

Reported-and-tested-by: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/pci/hotplug/acpiphp_glue.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
===================================================================
--- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
+++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
@@ -340,6 +340,7 @@ static acpi_status register_slot(acpi_ha
 
 		retval = acpiphp_register_hotplug_slot(slot, sun);
 		if (retval) {
+			slot->slot = NULL;
 			bridge->nr_slots--;
 			if (retval == -EBUSY)
 				warn("Slot %llu already registered by another "
@@ -429,7 +430,8 @@ static void cleanup_bridge(struct acpiph
 					err("failed to remove notify handler\n");
 			}
 		}
-		acpiphp_unregister_hotplug_slot(slot);
+		if (slot->slot)
+			acpiphp_unregister_hotplug_slot(slot);
 	}
 
 	mutex_lock(&bridge_mutex);

