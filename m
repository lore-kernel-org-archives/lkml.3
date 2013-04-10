Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936911Ab3DJPrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 11:47:04 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:33569 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760638Ab3DJPrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 11:47:01 -0400
MIME-Version: 1.0
In-Reply-To: <1365098483-26821-1-git-send-email-juhosg@openwrt.org>
References: <1365098483-26821-1-git-send-email-juhosg@openwrt.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 10 Apr 2013 09:46:40 -0600
Message-ID: <CAErSpo5OrFCaax++wA+iUoHEDG=fwAJXRe=B6EEQS=EEQ5iKWw@mail.gmail.com>
Subject: Re: [PATCH 1/2] pci/of: remove weak annotation of pcibios_get_phb_of_node
To: Gabor Juhos <juhosg@openwrt.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mips@linux-mips.org" <linux-mips@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 12:01 PM, Gabor Juhos <juhosg@openwrt.org> wrote:
> Due to the __weak annotation in the forward declaration
> of the 'pcibios_get_phb_of_node' function GCC will emit
> a weak symbol for this functions even if the actual
> implementation does not use the weak attribute.
>
> If an architecture tries to override the function
> by providing its own implementation there will be
> multiple weak symbols with the same name in the
> object files. When the kernel is linked from the
> object files the linking order determines which
> implementation will be used in the final image.
>
> On x86 and on powerpc the architecture specific
> version gets used:
>
>   $ readelf -s  arch/x86/kernel/built-in.o drivers/pci/built-in.o \
>     vmlinux.o | grep pcibios_get_phb_of_node
>     3338: 00029b80    86 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
>     1701: 00012710    77 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
>    52072: 0002a170    86 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
>   $
>
>   $ powerpc-openwrt-linux-uclibc-readelf -s arch/powerpc/kernel/built-in.o \
>     drivers/pci/built-in.o vmlinux.o | grep pcibios_get_phb_of_node
>     1001: 0000cbb8    12 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
>     1484: 0001471c    88 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
>    28652: 0000d6f8    12 FUNC    WEAK   DEFAULT    1 pcibios_get_phb_of_node
>   $
>
> However on MIPS, the linker puts the default
> implementation into the final image:
>
>   $ mipsel-openwrt-linux-readelf -s arch/mips/pci/built-in.o \
>     drivers/pci/built-in.o vmlinux.o | grep pcibios_get_phb_of_node
>       86: 0000046c    12 FUNC    WEAK   DEFAULT    2 pcibios_get_phb_of_node
>     1430: 00012e2c   104 FUNC    WEAK   DEFAULT    2 pcibios_get_phb_of_node
>    31898: 0017e4ec   104 FUNC    WEAK   DEFAULT    2 pcibios_get_phb_of_node
>   $
>
> Rename the default implementation and remove the
> __weak annotation of that. This ensures that there
> will be no multiple weak symbols with the same name
> in the object files. In order to keep the expected
> behaviour, call the architecture specific function
> if the weak symbol is resolved.
>
> Also move the renamed function to the top instead
> of adding a new forward declaration for that.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>
> ---
> Notes:
>
> Unfortunately I'm not a binutils/gcc expert, so
> I don't know if this is the expected behaviour
> of those or not.
>
> Removing the __weak annotation from the forward
> declaration of 'pcibios_get_phb_of_node' in
> 'include/linux/pci.h' also fixes the problem.
>
> The microblaze architecture also provides its own
> implementation. The behaviour of that is not tested
> but I assume that the linker chooses the arch specific
> implementation on that as well similarly to the
> x86/powerpc.
>
> The MIPS version is implemented in the followup
> patch.
>
> Removing the __weak annotation from the forward
> declaration of 'pcibios_get_phb_of_node' in
> 'include/linux/pci.h' also fixes the problem.

I think removing the __weak annotation from the declaration in
include/linux/pci.h is the correct solution.

__weak is an attribute of a function definition, not an attribute of
the interface, so I don't think it makes any sense to have it in
pci.h.

Bjorn

> -Gabor
> ---
>  drivers/pci/of.c |   41 +++++++++++++++++++++++------------------
>  1 file changed, 23 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/pci/of.c b/drivers/pci/of.c
> index f092993..5794840 100644
> --- a/drivers/pci/of.c
> +++ b/drivers/pci/of.c
> @@ -15,10 +15,32 @@
>  #include <linux/of_pci.h>
>  #include "pci.h"
>
> +static struct device_node *__pcibios_get_phb_of_node(struct pci_bus *bus)
> +{
> +       /* This should only be called for PHBs */
> +       if (WARN_ON(bus->self || bus->parent))
> +               return NULL;
> +
> +       if (pcibios_get_phb_of_node)
> +               return pcibios_get_phb_of_node(bus);
> +
> +       /* Look for a node pointer in either the intermediary device we
> +        * create above the root bus or it's own parent. Normally only
> +        * the later is populated.
> +        */
> +       if (bus->bridge->of_node)
> +               return of_node_get(bus->bridge->of_node);
> +       if (bus->bridge->parent && bus->bridge->parent->of_node)
> +               return of_node_get(bus->bridge->parent->of_node);
> +
> +       return NULL;
> +}
> +
>  void pci_set_of_node(struct pci_dev *dev)
>  {
>         if (!dev->bus->dev.of_node)
>                 return;
> +
>         dev->dev.of_node = of_pci_find_child_device(dev->bus->dev.of_node,
>                                                     dev->devfn);
>  }
> @@ -32,7 +54,7 @@ void pci_release_of_node(struct pci_dev *dev)
>  void pci_set_bus_of_node(struct pci_bus *bus)
>  {
>         if (bus->self == NULL)
> -               bus->dev.of_node = pcibios_get_phb_of_node(bus);
> +               bus->dev.of_node = __pcibios_get_phb_of_node(bus);
>         else
>                 bus->dev.of_node = of_node_get(bus->self->dev.of_node);
>  }
> @@ -42,20 +64,3 @@ void pci_release_bus_of_node(struct pci_bus *bus)
>         of_node_put(bus->dev.of_node);
>         bus->dev.of_node = NULL;
>  }
> -
> -struct device_node * __weak pcibios_get_phb_of_node(struct pci_bus *bus)
> -{
> -       /* This should only be called for PHBs */
> -       if (WARN_ON(bus->self || bus->parent))
> -               return NULL;
> -
> -       /* Look for a node pointer in either the intermediary device we
> -        * create above the root bus or it's own parent. Normally only
> -        * the later is populated.
> -        */
> -       if (bus->bridge->of_node)
> -               return of_node_get(bus->bridge->of_node);
> -       if (bus->bridge->parent && bus->bridge->parent->of_node)
> -               return of_node_get(bus->bridge->parent->of_node);
> -       return NULL;
> -}
> --
> 1.7.10
>
