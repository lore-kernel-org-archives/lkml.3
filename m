Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937095Ab3DJQbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 12:31:25 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:50200 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937045Ab3DJQbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 12:31:23 -0400
MIME-Version: 1.0
In-Reply-To: <1365098483-26821-2-git-send-email-juhosg@openwrt.org>
References: <1365098483-26821-1-git-send-email-juhosg@openwrt.org> <1365098483-26821-2-git-send-email-juhosg@openwrt.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 10 Apr 2013 10:31:02 -0600
Message-ID: <CAErSpo4ih-Kgp4LxX1MDodac-eoPo=Mu1d6ex8oNnaEEc_GQnw@mail.gmail.com>
Subject: Re: [PATCH 2/2] MIPS: implement pcibios_get_phb_of_node
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
> The of_node field of the device assigned to a
> PCI bus is used during scanning of the PCI bus.
> However on MIPS, the of_node field is assigned
> only after the bus has been scanned.
>
> Implement the architecture specific version of
> 'pcibios_get_phb_of_node'. Which ensures that the
> PCI driver core will initialize the of_node field
> before starting the scan.
>
> Also remove the local assignment of bus->dev.of_node,
> it is not needed after the patch.
>
> Signed-off-by: Gabor Juhos <juhosg@openwrt.org>

I removed the __weak annotation from include/linux/pci.h and applied
this patch to my pci/gabor-get-of-node.  Give it a try and make sure
it solves your problem.  If so, and Ralph approves, I can push both
for v3.10.  It should appear at
http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/gabor-get-of-node
soon.

Or if you prefer, you can take them through the MIPS tree.

Bjorn

> ---
>  arch/mips/pci/pci.c |    8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/mips/pci/pci.c b/arch/mips/pci/pci.c
> index 0872f12..594e60d 100644
> --- a/arch/mips/pci/pci.c
> +++ b/arch/mips/pci/pci.c
> @@ -115,7 +115,6 @@ static void pcibios_scanbus(struct pci_controller *hose)
>                         pci_bus_assign_resources(bus);
>                         pci_enable_bridges(bus);
>                 }
> -               bus->dev.of_node = hose->of_node;
>         }
>  }
>
> @@ -169,6 +168,13 @@ void pci_load_of_ranges(struct pci_controller *hose, struct device_node *node)
>                 }
>         }
>  }
> +
> +struct device_node *pcibios_get_phb_of_node(struct pci_bus *bus)
> +{
> +       struct pci_controller *hose = bus->sysdata;
> +
> +       return of_node_get(hose->of_node);
> +}
>  #endif
>
>  static DEFINE_MUTEX(pci_scan_mutex);
> --
> 1.7.10
>
