Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876AbaIWN4Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 09:56:24 -0400
Received: from mail-qc0-f169.google.com ([209.85.216.169]:37882 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751688AbaIWN4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 09:56:22 -0400
MIME-Version: 1.0
In-Reply-To: <1410085687-11273-1-git-send-email-vidyas@nvidia.com>
References: <1410085687-11273-1-git-send-email-vidyas@nvidia.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 23 Sep 2014 07:56:01 -0600
Message-ID: <CAErSpo7CX3XiuNZO8tXYVN2tUJudObFKVBthHfxf9mPS6hE6Cg@mail.gmail.com>
Subject: Re: [PATCH v4] ARM: fix debug prints relevant to PCI devices
To: Vidya Sagar <sagar.tv@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Yijing Wang <wangyijing@huawei.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Will Deacon <will.deacon@arm.com>,
        Stephen Warren <swarren@nvidia.com>, Krishna Thota <kthota@nvidia.com>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2014 at 4:28 AM, Vidya Sagar <sagar.tv@gmail.com> wrote:
> From: Vidya Sagar <sagar.tv@gmail.com>
>
> As per PCIe spec, fast back-to-back transactions feature
> is not applicable to PCIe devices. Hence, do not print
> that fast back-to-back trasactions are disabled when
> there is a PCIe device found on the bus
>
> Signed-off-by: Vidya Sagar <sagar.tv@gmail.com>
> ---
> v4:
> * initialized 'has_pcie_dev' to 'false'
>
> v3:
> * removed KERN_INFO from pr_info() which was not removed by mistake in previous patch
>
> v2:
> * Modified has_pcie_dev type to bool and used pci_is_pcie() instead of pci_pcie_cap()
> * replaced printk with pr_info
>
>  arch/arm/kernel/bios32.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)

This doesn't require any coordination with the PCI core, so I was just
leaving this up to the arch.  But I guess I can at least give you my
opinion :)

> diff --git a/arch/arm/kernel/bios32.c b/arch/arm/kernel/bios32.c
> index 17a26c1..03c56ba 100644
> --- a/arch/arm/kernel/bios32.c
> +++ b/arch/arm/kernel/bios32.c
> @@ -290,6 +290,7 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>  {
>         struct pci_dev *dev;
>         u16 features = PCI_COMMAND_SERR | PCI_COMMAND_PARITY | PCI_COMMAND_FAST_BACK;
> +       bool has_pcie_dev = false;
>
>         /*
>          * Walk the devices on this bus, working out what we can
> @@ -298,6 +299,8 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>         list_for_each_entry(dev, &bus->devices, bus_list) {
>                 u16 status;
>
> +               if (!has_pcie_dev)
> +                       has_pcie_dev = pci_is_pcie(dev);
>                 pci_read_config_word(dev, PCI_STATUS, &status);
>
>                 /*
> @@ -354,9 +357,11 @@ void pcibios_fixup_bus(struct pci_bus *bus)
>
>         /*
>          * Report what we did for this bus
> +        * (only if the bus doesn't have any PCIe devices)
>          */
> -       printk(KERN_INFO "PCI: bus%d: Fast back to back transfers %sabled\n",
> -               bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");
> +       if (!has_pcie_dev)
> +               pr_info("PCI: bus%d: Fast back to back transfers %sabled\n",
> +                       bus->number, (features & PCI_COMMAND_FAST_BACK) ? "en" : "dis");

My first choice would be to just drop the printk altogether.

If we want to keep the printk, it should be enough to test "bus->self
&& !pci_is_pcie(bus->self)" to see whether Fast Back-to-Back can be
enabled.

Personally, I would like to see everything in the file converted to
use dev_printk so it's consistent with the PCI core.  That would be a
separate patch, and there might be other instances under arch/arm,
too.

>  }
>  EXPORT_SYMBOL(pcibios_fixup_bus);
>
> --
> 1.8.1.5
>
