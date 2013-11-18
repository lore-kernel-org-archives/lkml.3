Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab3KRRiq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 12:38:46 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:46398 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751503Ab3KRRij (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 12:38:39 -0500
MIME-Version: 1.0
In-Reply-To: <1384767652-20567-1-git-send-email-adam.lee@canonical.com>
References: <1384767652-20567-1-git-send-email-adam.lee@canonical.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 18 Nov 2013 10:38:17 -0700
Message-ID: <CAErSpo7bERHRbBNOzb6g+666jMmFXQvv2T2U6dv82fVh1dU5kA@mail.gmail.com>
Subject: Re: [PATCH] pci: check PCI_EXP_FLAGS_SLOT before setting hotplug bridge
To: Adam Lee <adam.lee@canonical.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Amos Kong <kongjianjun@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>, Thomas Renninger <trenn@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Myron, Amos, Thomas, Ben]

On Mon, Nov 18, 2013 at 2:40 AM, Adam Lee <adam.lee@canonical.com> wrote:
> This patch adds the PCI_EXP_FLAGS_SLOT check back before setting
> hotplug bridge, which is omitted by an API switching commit,
> 59875ae489609b2267548dc85160c5f0f0c6f9d4 "PCI/core: Use PCI Express
> Capability accessors".
>
> Some Lenovo laptops hang in booting without this fix.

What kernel version hangs?  I suspect you might be missing 6d3a1741f1
("PCI: Support PCIe Capability Slot registers only for ports with
slots"), because it *looks* like the current kernel should work
correctly even without your patch.

If you're missing 6d3a1741f1, I think it's better to fix the hang by
pulling in that patch because it has the potential to fix other bugs
as well.  I should have marked that commit for stable, but I didn't
realize at the time that it might fix an actual bug.

This was part of a short series:

1) d3694d4fa3 PCI: Allow PCIe Capability link-related register access
for switches
2) c8b303d020 PCI: Remove PCIe Capability version checks
3) 6d3a1741f1 PCI: Support PCIe Capability Slot registers only for
ports with slots
4) fed2451512 PCI: Remove pcie_cap_has_devctl()

You might also want d3694d4fa3.  Without it, we won't read Link
registers for switch ports, which could also cause problems, though I
don't have an example to point at.  I'm pretty sure the others (2 and
4) are simplifications only and won't actually fix anything.

Bjorn

> Signed-off-by: Adam Lee <adam.lee@canonical.com>
> ---
>  drivers/pci/probe.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 5e14f5a..b93d5ac 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -992,8 +992,13 @@ void set_pcie_port_type(struct pci_dev *pdev)
>
>  void set_pcie_hotplug_bridge(struct pci_dev *pdev)
>  {
> +       u16 reg16;
>         u32 reg32;
>
> +       pcie_capability_read_word(pdev, PCI_EXP_FLAGS, &reg16);
> +       if (!(reg16 & PCI_EXP_FLAGS_SLOT))
> +               return;
> +
>         pcie_capability_read_dword(pdev, PCI_EXP_SLTCAP, &reg32);
>         if (reg32 & PCI_EXP_SLTCAP_HPC)
>                 pdev->is_hotplug_bridge = 1;
> --
> 1.8.4.3
>
