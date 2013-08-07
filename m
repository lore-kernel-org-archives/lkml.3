Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3HGGcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 02:32:18 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:34799 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753953Ab3HGGcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 02:32:15 -0400
MIME-Version: 1.0
In-Reply-To: <7877671.J2kQMTu2H0@vostro.rjw.lan>
References: <7877671.J2kQMTu2H0@vostro.rjw.lan>
Date: Wed, 7 Aug 2013 14:32:14 +0800
Message-ID: <CAOLK0pxSH54nqwcJYXe9uGXffKCRnpuK+1t9HWyvneoWt2yLdA@mail.gmail.com>
Subject: Re: [PATCH] ACPI: Try harder to resolve _ADR collisions for bridges
From: Lan Tianyu <lantianyu1986@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Lan Tianyu <tianyu.lan@intel.com>,
        Peter Wu <lekensteyn@gmail.com>, Vladimir Lalov <mail@vlalov.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/8/7 Rafael J. Wysocki <rjw@sisk.pl>:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> In theory, under a given ACPI namespace node there should be only
> one child device object with _ADR whose value matches a given bus
> address exactly.  In practice, however, there are systems in which
> multiple child device objects under a given parent have _ADR matching
> exactly the same address.  In those cases we use _STA to determine
> which of the multiple matching devices is enabled, since some systems
> are known to indicate which ACPI device object to associate with the
> given physical (usually PCI) device this way.
>
> Unfortunately, as it turns out, there are systems in which many
> device objects under the same parent have _ADR matching exactly the
> same bus address and none of them has _STA, in which case they all
> should be regarded as enabled according to the spec.  Still, if
> those device objects are supposed to represent bridges (e.g. this
> is the case for device objects corresponding to PCIe ports), we can
> try harder and skip the ones that have no child device objects in the
> ACPI namespace.  With luck, we can avoid using device objects that we
> are not expected to use this way.
>
> Although this only works for bridges whose children also have ACPI
> namespace representation, it is sufficient to address graphics
> adapter detection issues on some systems, so rework the code finding
> a matching device ACPI handle for a given bus address to implement
> this idea.
>
> Introduce a new function, acpi_find_child(), taking three arguments:
> the ACPI handle of the device's parent, a bus address suitable for
> the device's bus type and a bool indicating if the device is a
> bridge and make it work as outlined above.  Reimplement the function
> currently used for this purpose, acpi_get_child(), as a call to
> acpi_find_child() with the last argument set to 'false' and make
> the PCI subsystem use acpi_find_child() with the bridge information
> passed as the last argument to it.  [Lan Tianyu notices that it is
> not sufficient to use pci_is_bridge() for that, because the device's
> subordinate pointer hasn't been set yet at this point, so use
> hdr_type instead.]
>
> This change fixes a regression introduced inadvertently by commit
> 33f767d (ACPI: Rework acpi_get_child() to be more efficient) which
> overlooked the fact that for acpi_walk_namespace() "post-order" means
> "after all children have been visited" rather than "on the way back",
> so for device objects without children and for namespace walks of
> depth 1, as in the acpi_get_child() case, the "post-order" callbacks
> ordering is actually the same as the ordering of "pre-order" ones.
> Since that commit changed the namespace walk in acpi_get_child() to
> terminate after finding the first matching object instead of going
> through all of them and returning the last one, it effectively
> changed the result returned by that function in some rare cases and
> that led to problems (the switch from a "pre-order" to a "post-order"
> callback was supposed to prevent that from happening, but it was
> ineffective).
>
> As it turns out, the systems where the change made by commit
> 33f767d actually matters are those where there are multiple ACPI
> device objects representing the same PCIe port (which effectively
> is a bridge).  Moreover, only one of them, and the one we are
> expected to use, has child device objects in the ACPI namespace,
> so the regression can be addressed as described above.
>

Reviewed-by: Lan Tianyu <tianyu.lan@intel.com>

> References: https://bugzilla.kernel.org/show_bug.cgi?id=60561
> Reported-by: Peter Wu <lekensteyn@gmail.com>
> Tested-by: Vladimir Lalov <mail@vlalov.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Cc: 3.9+ <stable@vger.kernel.org> # 3.9+
> ---
>  drivers/acpi/glue.c     |   99 +++++++++++++++++++++++++++++++++++++++---------
>  drivers/pci/pci-acpi.c  |   14 ++++--
>  include/acpi/acpi_bus.h |    6 ++
>  3 files changed, 97 insertions(+), 22 deletions(-)
>
> Index: linux-pm/drivers/acpi/glue.c
> ===================================================================
> --- linux-pm.orig/drivers/acpi/glue.c
> +++ linux-pm/drivers/acpi/glue.c
> @@ -79,34 +79,99 @@ static struct acpi_bus_type *acpi_get_bu
>         return ret;
>  }
>
> -static acpi_status do_acpi_find_child(acpi_handle handle, u32 lvl_not_used,
> -                                     void *addr_p, void **ret_p)
> +static acpi_status acpi_dev_check(acpi_handle handle, u32 lvl_not_used,
> +                                 void *not_used, void **ret_p)
>  {
> -       unsigned long long addr, sta;
> -       acpi_status status;
> +       struct acpi_device *adev = NULL;
>
> -       status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &addr);
> -       if (ACPI_SUCCESS(status) && addr == *((u64 *)addr_p)) {
> +       acpi_bus_get_device(handle, &adev);
> +       if (adev) {
>                 *ret_p = handle;
> -               status = acpi_bus_get_status_handle(handle, &sta);
> -               if (ACPI_SUCCESS(status) && (sta & ACPI_STA_DEVICE_ENABLED))
> -                       return AE_CTRL_TERMINATE;
> +               return AE_CTRL_TERMINATE;
>         }
>         return AE_OK;
>  }
>
> -acpi_handle acpi_get_child(acpi_handle parent, u64 address)
> +static bool acpi_dev_suitable(acpi_handle handle, bool is_bridge)
>  {
> -       void *ret = NULL;
> +       unsigned long long sta;
> +       acpi_status status;
>
> -       if (!parent)
> -               return NULL;
> +       status = acpi_bus_get_status_handle(handle, &sta);
> +       if (ACPI_FAILURE(status) || !(sta & ACPI_STA_DEVICE_ENABLED))
> +               return false;
> +
> +       if (is_bridge) {
> +               void *test = NULL;
> +
> +               /* Check if this object has at least one child device. */
> +               acpi_walk_namespace(ACPI_TYPE_DEVICE, handle, 1, acpi_dev_check,
> +                                   NULL, NULL, &test);
> +               return !!test;
> +       }
> +       return true;
> +}
>
> -       acpi_walk_namespace(ACPI_TYPE_DEVICE, parent, 1, NULL,
> -                           do_acpi_find_child, &address, &ret);
> -       return (acpi_handle)ret;
> +struct find_child_context {
> +       u64 addr;
> +       bool is_bridge;
> +       acpi_handle ret;
> +       bool ret_checked;
> +};
> +
> +static acpi_status do_find_child(acpi_handle handle, u32 lvl_not_used,
> +                                void *data, void **not_used)
> +{
> +       struct find_child_context *context = data;
> +       unsigned long long addr;
> +       acpi_status status;
> +
> +       status = acpi_evaluate_integer(handle, METHOD_NAME__ADR, NULL, &addr);
> +       if (ACPI_FAILURE(status) || addr != context->addr)
> +               return AE_OK;
> +
> +       if (!context->ret) {
> +               /* This is the first matching object.  Save its handle. */
> +               context->ret = handle;
> +               return AE_OK;
> +       }
> +       /*
> +        * There is one more matching object with the same _ADR value.  That
> +        * really shouldn't happen, so we are kind of beyond the scope of the
> +        * spec here.  We have to choose which one to return, though.
> +        *
> +        * First, check if the previously found object is good enough and return
> +        * its handle if so.  Second, check the same for the object that we've
> +        * just found.
> +        */
> +       if (!context->ret_checked) {
> +               if (acpi_dev_suitable(context->ret, context->is_bridge))
> +                       return AE_CTRL_TERMINATE;
> +               else
> +                       context->ret_checked = true;
> +       }
> +       if (acpi_dev_suitable(handle, context->is_bridge)) {
> +               context->ret = handle;
> +               return AE_CTRL_TERMINATE;
> +       }
> +       return AE_OK;
> +}
> +
> +acpi_handle acpi_find_child(acpi_handle parent, u64 addr, bool is_bridge)
> +{
> +       if (parent) {
> +               struct find_child_context context = {
> +                       .addr = addr,
> +                       .is_bridge = is_bridge,
> +               };
> +
> +               acpi_walk_namespace(ACPI_TYPE_DEVICE, parent, 1, do_find_child,
> +                                   NULL, &context, NULL);
> +               return context.ret;
> +       }
> +       return NULL;
>  }
> -EXPORT_SYMBOL(acpi_get_child);
> +EXPORT_SYMBOL_GPL(acpi_find_child);
>
>  int acpi_bind_one(struct device *dev, acpi_handle handle)
>  {
> Index: linux-pm/include/acpi/acpi_bus.h
> ===================================================================
> --- linux-pm.orig/include/acpi/acpi_bus.h
> +++ linux-pm/include/acpi/acpi_bus.h
> @@ -439,7 +439,11 @@ struct acpi_pci_root {
>  };
>
>  /* helper */
> -acpi_handle acpi_get_child(acpi_handle, u64);
> +acpi_handle acpi_find_child(acpi_handle, u64, bool);
> +static inline acpi_handle acpi_get_child(acpi_handle handle, u64 addr)
> +{
> +       return acpi_find_child(handle, addr, false);
> +}
>  int acpi_is_root_bridge(acpi_handle);
>  struct acpi_pci_root *acpi_pci_find_root(acpi_handle handle);
>  #define DEVICE_ACPI_HANDLE(dev) ((acpi_handle)ACPI_HANDLE(dev))
> Index: linux-pm/drivers/pci/pci-acpi.c
> ===================================================================
> --- linux-pm.orig/drivers/pci/pci-acpi.c
> +++ linux-pm/drivers/pci/pci-acpi.c
> @@ -309,13 +309,19 @@ void acpi_pci_remove_bus(struct pci_bus
>  /* ACPI bus type */
>  static int acpi_pci_find_device(struct device *dev, acpi_handle *handle)
>  {
> -       struct pci_dev * pci_dev;
> -       u64     addr;
> +       struct pci_dev *pci_dev = to_pci_dev(dev);
> +       /*
> +        * pci_is_bridge() is not suitable here, because pci_dev->subordinate
> +        * is set only after acpi_pci_find_device() has been called for the
> +        * given device.
> +        */
> +       bool is_bridge = pci_dev->hdr_type == PCI_HEADER_TYPE_BRIDGE
> +                       || pci_dev->hdr_type == PCI_HEADER_TYPE_CARDBUS;
> +       u64 addr;
>
> -       pci_dev = to_pci_dev(dev);
>         /* Please ref to ACPI spec for the syntax of _ADR */
>         addr = (PCI_SLOT(pci_dev->devfn) << 16) | PCI_FUNC(pci_dev->devfn);
> -       *handle = acpi_get_child(DEVICE_ACPI_HANDLE(dev->parent), addr);
> +       *handle = acpi_find_child(ACPI_HANDLE(dev->parent), addr, is_bridge);
>         if (!*handle)
>                 return -ENODEV;
>         return 0;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best regards
Tianyu Lan
