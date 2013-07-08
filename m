Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab3GHUgT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Jul 2013 16:36:19 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:35240 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3GHUgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Jul 2013 16:36:17 -0400
MIME-Version: 1.0
In-Reply-To: <1373242613-4603-1-git-send-email-zhen-hual@hp.com>
References: <1373242613-4603-1-git-send-email-zhen-hual@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 8 Jul 2013 14:35:56 -0600
Message-ID: <CAErSpo6Kpw5VX5e5PUy8V4PdL6-rg14NdaXYOYHkAGm72GgHBg@mail.gmail.com>
Subject: Re: [PATCH 1/1] ia64/pci: set mmio decoding on for some host bridge
To: "Li, Zhen-Hua" <zhen-hual@hp.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 7, 2013 at 6:16 PM, Li, Zhen-Hua <zhen-hual@hp.com> wrote:
> On some IA64 platforms with intel PCI bridge, for example, HP BL890c i2
> with  Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port,
> when kernel tries to disable the mmio decoding on the PCI bridge devices,
> kernel may crash.
>
> And in the comment of function quirk_mmio_always_on, it also says:
> "But doing so (disable the mmio decoding) may cause problems on host bridge
>  and perhaps other key system devices"
>
> So, for these PCI bridges,  dev->mmio_always_on bit should be set to 1.
>
>
> Signed-off-by: Li, Zhen-Hua <zhen-hual@hp.com>
> ---
>  drivers/pci/quirks.c |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index e85d230..24b8024 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -44,6 +44,21 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>                                 PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
>
> +#ifdef CONFIG_IA64
> +/*
> + * On some IA64 platforms, for some intel PCI bridge devices, for example,
> + * the Intel Corporation 5520/5500/X58 I/O Hub PCI Express Root Port,
> + * disable the mmio decoding on these devices may cause system crash.
> + * So dev->mmio_always_on bit should be set to 1.
> + */
> +static void quirk_mmio_on_intel_pcibridge(struct pci_dev *dev)
> +{
> +       dev->mmio_always_on = 1;
> +}
> +DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
> +                       PCI_CLASS_BRIDGE_PCI, 8, quirk_mmio_on_intel_pcibridge);
> +#endif

The changelog and comment suggest an issue specific to Intel
5520/5500/X58, but the patch sets mmio_always_on for *all* PCI
bridges.

It claims to be specific to ia64 (and is only compiled there), but the
chipset is also used for x86.  You need to explain why the problem
only affects ia64.

Bjorn
