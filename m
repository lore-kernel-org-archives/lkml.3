Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933449Ab3GRSyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 14:54:16 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:49658 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932812Ab3GRSyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 14:54:14 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PCI <linux-pci@vger.kernel.org>, Jiang Liu <liuj97@gmail.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH 4/30] ACPI / hotplug / PCI: Hotplug context objects for bridges and functions
Date: Thu, 18 Jul 2013 21:04:11 +0200
Message-ID: <3688658.K73mT4hj2a@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAE9FiQWjzZ6b1aGgL9OjNZF00hvwaEZJb7ABxjaVbS5FwNwpSQ@mail.gmail.com>
References: <26431283.HJCKsss0rt@vostro.rjw.lan> <5282264.ht9aNfCcNl@vostro.rjw.lan> <CAE9FiQWjzZ6b1aGgL9OjNZF00hvwaEZJb7ABxjaVbS5FwNwpSQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 17, 2013 07:00:33 PM Yinghai Lu wrote:
> On Wed, Jul 17, 2013 at 4:17 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> >
> > When either a new hotplug bridge or a new hotplug function is added
> > by the ACPI-based PCI hotplug (ACPIPHP) code, attach a context object
> > to its ACPI handle to store hotplug-related information in it.  To
> > start with, put the handle's bridge and function pointers into that
> > object.  Count references to the context objects and drop them when
> > they are not needed any more.
> >
> > First of all, this makes it possible to find out if the given bridge
> > has been registered as a function already in a much more
> > straightforward way and acpiphp_bridge_handle_to_function() can be
> > dropped (Yay!).
> >
> > This also will allow some more simplifications to be made going
> > forward.
> >
> > Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > ---
> >  drivers/pci/hotplug/acpiphp.h      |   10 ++
> >  drivers/pci/hotplug/acpiphp_glue.c |  179 ++++++++++++++++++++++++++++---------
> >  2 files changed, 146 insertions(+), 43 deletions(-)
> 
> no, more lines are added.

Well, that's what 'quilt refresh --diffstat' tells me, quite consistently.

Have you actually counted them?

> > Index: linux-pm/drivers/pci/hotplug/acpiphp.h
> > ===================================================================
> > --- linux-pm.orig/drivers/pci/hotplug/acpiphp.h
> > +++ linux-pm/drivers/pci/hotplug/acpiphp.h
> > @@ -49,6 +49,7 @@
> >  #define info(format, arg...) printk(KERN_INFO "%s: " format, MY_NAME , ## arg)
> >  #define warn(format, arg...) printk(KERN_WARNING "%s: " format, MY_NAME , ## arg)
> >
> > +struct acpiphp_context;
> >  struct acpiphp_bridge;
> >  struct acpiphp_slot;
> >
> > @@ -77,6 +78,7 @@ struct acpiphp_bridge {
> >         struct kref ref;
> >         acpi_handle handle;
> >
> > +       struct acpiphp_context *context;
> >         /* Ejectable PCI-to-PCI bridge (PCI bridge and PCI function) */
> >         struct acpiphp_func *func;
> >
> > @@ -119,6 +121,7 @@ struct acpiphp_slot {
> >   * typically 8 objects per slot (i.e. for each PCI function)
> >   */
> >  struct acpiphp_func {
> > +       struct acpiphp_context *context;
> >         struct acpiphp_slot *slot;      /* parent */
> >
> >         struct list_head sibling;
> > @@ -128,6 +131,13 @@ struct acpiphp_func {
> >         u32             flags;          /* see below */
> >  };
> >
> > +struct acpiphp_context {
> > +       acpi_handle handle;
> > +       struct acpiphp_func *func;
> > +       struct acpiphp_bridge *bridge;
> > +       unsigned int refcount;
> > +};
> > +
> >  /*
> >   * struct acpiphp_attention_info - device specific attention registration
> >   *
> > Index: linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > ===================================================================
> > --- linux-pm.orig/drivers/pci/hotplug/acpiphp_glue.c
> > +++ linux-pm/drivers/pci/hotplug/acpiphp_glue.c
> > @@ -55,6 +55,7 @@
> >
> >  static LIST_HEAD(bridge_list);
> >  static DEFINE_MUTEX(bridge_mutex);
> > +static DEFINE_MUTEX(acpiphp_context_lock);
> >
> >  #define MY_NAME "acpiphp_glue"
> >
> > @@ -79,6 +80,74 @@ is_pci_dock_device(acpi_handle handle, u
> >         }
> >  }
> >
> > +static void acpiphp_context_handler(acpi_handle handle, void *context)
> > +{
> > +       /* Intentionally empty. */
> > +}
> > +
> > +/**
> > + * acpiphp_init_context - Create hotplug context and grab a reference to it.
> > + * @handle: ACPI object handle to create the context for.
> > + *
> > + * Call under acpiphp_context_lock.
> > + */
> > +static struct acpiphp_context *acpiphp_init_context(acpi_handle handle)
> > +{
> > +       struct acpiphp_context *context;
> > +       acpi_status status;
> > +
> > +       context = kzalloc(sizeof(*context), GFP_KERNEL);
> > +       if (!context)
> > +               return NULL;
> > +
> > +       context->handle = handle;
> > +       context->refcount = 1;
> > +       status = acpi_attach_data(handle, acpiphp_context_handler, context);
> > +       if (ACPI_FAILURE(status)) {
> > +               kfree(context);
> > +               return NULL;
> > +       }
> > +       return context;
> > +}
> > +
> > +/**
> > + * acpiphp_get_context - Get hotplug context and grab a reference to it.
> > + * @handle: ACPI object handle to get the context for.
> > + *
> > + * Call under acpiphp_context_lock.
> > + */
> > +static struct acpiphp_context *acpiphp_get_context(acpi_handle handle)
> > +{
> > +       struct acpiphp_context *context = NULL;
> > +       acpi_status status;
> > +       void *data;
> > +
> > +       status = acpi_get_data(handle, acpiphp_context_handler, &data);
> > +       if (ACPI_SUCCESS(status)) {
> > +               context = data;
> > +               context->refcount++;
> > +       }
> > +       return context;
> > +}
> > +
> > +/**
> > + * acpiphp_put_context - Drop a reference to ACPI hotplug context.
> > + * @handle: ACPI object handle to put the context for.
> > + *
> > + * The context object is removed if there are no more references to it.
> > + *
> > + * Call under acpiphp_context_lock.
> > + */
> > +static void acpiphp_put_context(struct acpiphp_context *context)
> > +{
> > +       if (--context->refcount)
> > +               return;
> > +
> > +       WARN_ON(context->func || context->bridge);
> > +       acpi_detach_data(context->handle, acpiphp_context_handler);
> > +       kfree(context);
> > +}
> > +
> >  static inline void get_bridge(struct acpiphp_bridge *bridge)
> >  {
> >         kref_get(&bridge->ref);
> > @@ -91,25 +160,37 @@ static inline void put_bridge(struct acp
> >
> >  static void free_bridge(struct kref *kref)
> >  {
> > +       struct acpiphp_context *context;
> >         struct acpiphp_bridge *bridge;
> >         struct acpiphp_slot *slot, *next;
> >         struct acpiphp_func *func, *tmp;
> >
> > +       mutex_lock(&acpiphp_context_lock);
> > +
> >         bridge = container_of(kref, struct acpiphp_bridge, ref);
> >
> >         list_for_each_entry_safe(slot, next, &bridge->slots, node) {
> >                 list_for_each_entry_safe(func, tmp, &slot->funcs, sibling) {
> > +                       context = func->context;
> > +                       context->func = NULL;
> > +                       acpiphp_put_context(context);
> >                         kfree(func);
> >                 }
> >                 kfree(slot);
> >         }
> >
> > -       /* Release reference acquired by acpiphp_bridge_handle_to_function() */
> > +       /* Release the reference acquired by acpiphp_enumerate_slots(). */
> >         if ((bridge->flags & BRIDGE_HAS_EJ0) && bridge->func)
> >                 put_bridge(bridge->func->slot->bridge);
> > +
> >         put_device(&bridge->pci_bus->dev);
> >         pci_dev_put(bridge->pci_dev);
> > +       context = bridge->context;
> > +       context->bridge = NULL;
> > +       acpiphp_put_context(context);
> >         kfree(bridge);
> > +
> > +       mutex_unlock(&acpiphp_context_lock);
> >  }
> >
> >  /*
> > @@ -194,10 +275,11 @@ static void acpiphp_dock_release(void *d
> >  }
> >
> >  /* callback routine to register each ACPI PCI slot object */
> > -static acpi_status
> > -register_slot(acpi_handle handle, u32 lvl, void *context, void **rv)
> > +static acpi_status register_slot(acpi_handle handle, u32 lvl, void *data,
> > +                                void **rv)
> >  {
> > -       struct acpiphp_bridge *bridge = (struct acpiphp_bridge *)context;
> > +       struct acpiphp_bridge *bridge = data;
> > +       struct acpiphp_context *context;
> >         struct acpiphp_slot *slot;
> >         struct acpiphp_func *newfunc;
> >         acpi_status status = AE_OK;
> > @@ -230,6 +312,18 @@ register_slot(acpi_handle handle, u32 lv
> >         newfunc->handle = handle;
> >         newfunc->function = function;
> >
> > +       mutex_lock(&acpiphp_context_lock);
> > +       context = acpiphp_init_context(handle);
> > +       if (!context) {
> > +               mutex_unlock(&acpiphp_context_lock);
> > +               acpi_handle_err(handle, "No hotplug context\n");
> > +               kfree(newfunc);
> > +               return AE_NOT_EXIST;
> > +       }
> > +       newfunc->context = context;
> > +       context->func = newfunc;
> > +       mutex_unlock(&acpiphp_context_lock);
> > +
> >         if (acpi_has_method(handle, "_EJ0"))
> >                 newfunc->flags = FUNC_HAS_EJ0;
> >
> > @@ -266,8 +360,8 @@ register_slot(acpi_handle handle, u32 lv
> >         if (!found) {
> >                 slot = kzalloc(sizeof(struct acpiphp_slot), GFP_KERNEL);
> >                 if (!slot) {
> > -                       kfree(newfunc);
> > -                       return AE_NO_MEMORY;
> > +                       status = AE_NO_MEMORY;
> > +                       goto err_out;
> >                 }
> >
> >                 slot->bridge = bridge;
> > @@ -291,7 +385,9 @@ register_slot(acpi_handle handle, u32 lv
> >                         else
> >                                 warn("acpiphp_register_hotplug_slot failed "
> >                                         "(err code = 0x%x)\n", retval);
> > -                       goto err_exit;
> > +
> > +                       status = AE_OK;
> > +                       goto err;
> >                 }
> >         }
> >
> > @@ -329,15 +425,20 @@ register_slot(acpi_handle handle, u32 lv
> >
> >         return AE_OK;
> >
> > - err_exit:
> > + err:
> >         bridge->nr_slots--;
> >         mutex_lock(&bridge_mutex);
> >         list_del(&slot->node);
> >         mutex_unlock(&bridge_mutex);
> >         kfree(slot);
> > -       kfree(newfunc);
> >
> > -       return AE_OK;
> > + err_out:
> > +       mutex_lock(&acpiphp_context_lock);
> > +       context->func = NULL;
> > +       acpiphp_put_context(context);
> > +       mutex_unlock(&acpiphp_context_lock);
> > +       kfree(newfunc);
> > +       return status;
> >  }
> >
> >
> > @@ -352,32 +453,6 @@ static int detect_ejectable_slots(acpi_h
> >         return found;
> >  }
> >
> > -
> > -/* find acpiphp_func from acpiphp_bridge */
> > -static struct acpiphp_func *acpiphp_bridge_handle_to_function(acpi_handle handle)
> > -{
> > -       struct acpiphp_bridge *bridge;
> > -       struct acpiphp_slot *slot;
> > -       struct acpiphp_func *func = NULL;
> > -
> > -       mutex_lock(&bridge_mutex);
> > -       list_for_each_entry(bridge, &bridge_list, list) {
> > -               list_for_each_entry(slot, &bridge->slots, node) {
> > -                       list_for_each_entry(func, &slot->funcs, sibling) {
> > -                               if (func->handle == handle) {
> > -                                       get_bridge(func->slot->bridge);
> > -                                       mutex_unlock(&bridge_mutex);
> > -                                       return func;
> > -                               }
> > -                       }
> > -               }
> > -       }
> > -       mutex_unlock(&bridge_mutex);
> > -
> > -       return NULL;
> > -}
> > -
> > -
> >  static struct acpiphp_bridge *acpiphp_handle_to_bridge(acpi_handle handle)
> >  {
> >         struct acpiphp_bridge *bridge;
> > @@ -1108,6 +1183,7 @@ static void handle_hotplug_event_func(ac
> >   */
> >  void acpiphp_enumerate_slots(struct pci_bus *bus)
> >  {
> > +       struct acpiphp_context *context;
> >         struct acpiphp_bridge *bridge;
> >         acpi_handle handle;
> >         acpi_status status;
> > @@ -1120,8 +1196,8 @@ void acpiphp_enumerate_slots(struct pci_
> >                 return;
> >
> >         bridge = kzalloc(sizeof(struct acpiphp_bridge), GFP_KERNEL);
> > -       if (bridge == NULL) {
> > -               err("out of memory\n");
> > +       if (!bridge) {
> > +               acpi_handle_err(handle, "No memory for bridge object\n");
> >                 return;
> >         }
> >
> 
> can you put this change in another patch?

Yes, I can, but is it worth it?

> > @@ -1131,6 +1207,21 @@ void acpiphp_enumerate_slots(struct pci_
> >         bridge->pci_dev = pci_dev_get(bus->self);
> >         bridge->pci_bus = bus;
> >
> > +       mutex_lock(&acpiphp_context_lock);
> > +       context = acpiphp_get_context(handle);
> > +       if (!context) {
> > +               context = acpiphp_init_context(handle);
> > +               if (!context) {
> > +                       mutex_unlock(&acpiphp_context_lock);
> > +                       acpi_handle_err(handle, "No hotplug context\n");
> > +                       kfree(bridge);
> > +                       return;
> > +               }
> > +       }
> > +       bridge->context = context;
> > +       context->bridge = bridge;
> > +       mutex_unlock(&acpiphp_context_lock);
> > +
> >         /*
> >          * Grab a ref to the subordinate PCI bus in case the bus is
> >          * removed via PCI core logical hotplug. The ref pins the bus
> > @@ -1169,13 +1260,15 @@ void acpiphp_enumerate_slots(struct pci_
> >
> >         dbg("found ejectable p2p bridge\n");
> >         bridge->flags |= BRIDGE_HAS_EJ0;
> > -       bridge->func = acpiphp_bridge_handle_to_function(bridge->handle);
> > -       if (bridge->func) {
> > -               status = acpi_remove_notify_handler(bridge->func->handle,
> > -                                                   ACPI_SYSTEM_NOTIFY,
> > +       if (context->func) {
> > +               get_bridge(context->func->slot->bridge);
> > +               bridge->func = context->func;
> > +               handle = context->handle;
> > +               WARN_ON(bridge->handle != handle);
> > +               status = acpi_remove_notify_handler(handle, ACPI_SYSTEM_NOTIFY,
> >                                                     handle_hotplug_event_func);
> >                 if (ACPI_FAILURE(status))
> > -                       acpi_handle_err(bridge->func->handle,
> > +                       acpi_handle_err(handle,
> >                                         "failed to remove notify handler\n");
> >         }
> >         return;
> >
-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
