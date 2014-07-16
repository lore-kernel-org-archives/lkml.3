Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760519AbaGPAIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 20:08:49 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:49809 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754376AbaGPAIf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 20:08:35 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: Re: [PATCH] ACPI / hotplug: Simplify acpi_set_hp_context()
Date: Wed, 16 Jul 2014 02:26:49 +0200
Message-ID: <3209405.HZhsMWGyTv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAErSpo5BYyC-A3qXE2OsgkkGJg8Lvr2B+ASMJ63N-S9xm8wUow@mail.gmail.com>
References: <5388095.MjHqc07ajT@vostro.rjw.lan> <CAErSpo5BYyC-A3qXE2OsgkkGJg8Lvr2B+ASMJ63N-S9xm8wUow@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 15, 2014 02:56:29 PM Bjorn Helgaas wrote:
> On Mon, Jul 14, 2014 at 2:36 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > Since all of the acpi_set_hp_context() callers pass at least one NULL
> > function pointer and one caller passes NULL function pointers only
> > to it, drop function pointer arguments from acpi_set_hp_context()
> > and make the callers initialize the function pointers in struct
> > acpi_hotplug_context by themselves before passing it to
> > acpi_set_hp_context().
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>

Thanks! [And for the other one too.]

> > ---
> >  drivers/acpi/scan.c                |    4 +++-
> >  drivers/pci/hotplug/acpiphp_glue.c |    7 ++++---
> >  include/acpi/acpi_bus.h            |    8 +-------
> >  3 files changed, 8 insertions(+), 11 deletions(-)
> >
> > Index: linux-pm/include/acpi/acpi_bus.h
> > ===================================================================
> > --- linux-pm.orig/include/acpi/acpi_bus.h
> > +++ linux-pm/include/acpi/acpi_bus.h
> > @@ -372,15 +372,9 @@ static inline void acpi_set_device_statu
> >  }
> >
> >  static inline void acpi_set_hp_context(struct acpi_device *adev,
> > -                                      struct acpi_hotplug_context *hp,
> > -                                      int (*notify)(struct acpi_device *, u32),
> > -                                      void (*uevent)(struct acpi_device *, u32),
> > -                                      void (*fixup)(struct acpi_device *))
> > +                                      struct acpi_hotplug_context *hp)
> >  {
> >         hp->self = adev;
> > -       hp->notify = notify;
> > -       hp->uevent = uevent;
> > -       hp->fixup = fixup;
> >         adev->hp = hp;
> >  }
> >
> > Index: linux-pm/drivers/acpi/scan.c
> > ===================================================================
> > --- linux-pm.orig/drivers/acpi/scan.c
> > +++ linux-pm/drivers/acpi/scan.c
> > @@ -77,7 +77,9 @@ void acpi_initialize_hp_context(struct a
> >                                 void (*uevent)(struct acpi_device *, u32))
> >  {
> >         acpi_lock_hp_context();
> > -       acpi_set_hp_context(adev, hp, notify, uevent, NULL);
> > +       hp->notify = notify;
> > +       hp->uevent = uevent;
> > +       acpi_set_hp_context(adev, hp);
> >         acpi_unlock_hp_context();
> >  }
> >  EXPORT_SYMBOL_GPL(acpi_initialize_hp_context);
> > Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > ===================================================================
> > --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> > +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -80,8 +80,9 @@ static struct acpiphp_context *acpiphp_i
> >                 return NULL;
> >
> >         context->refcount = 1;
> > -       acpi_set_hp_context(adev, &context->hp, acpiphp_hotplug_notify, NULL,
> > -                           acpiphp_post_dock_fixup);
> > +       context->hp.notify = acpiphp_hotplug_notify;
> > +       context->hp.fixup = acpiphp_post_dock_fixup;
> > +       acpi_set_hp_context(adev, &context->hp);
> >         return context;
> >  }
> >
> > @@ -876,7 +877,7 @@ void acpiphp_enumerate_slots(struct pci_
> >                         goto err;
> >
> >                 root_context->root_bridge = bridge;
> > -               acpi_set_hp_context(adev, &root_context->hp, NULL, NULL, NULL);
> > +               acpi_set_hp_context(adev, &root_context->hp);
> >         } else {
> >                 struct acpiphp_context *context;
> >
> >

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
