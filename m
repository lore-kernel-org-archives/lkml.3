Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab3CGQ3W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Mar 2013 11:29:22 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:57781 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759538Ab3CGQ3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Mar 2013 11:29:19 -0500
MIME-Version: 1.0
In-Reply-To: <1362666556-10036-1-git-send-email-yxlraid@gmail.com>
References: <1362666556-10036-1-git-send-email-yxlraid@gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Thu, 7 Mar 2013 09:28:58 -0700
Message-ID: <CAErSpo7feQK7pXD=moA_hf=Y-j82oZZKwfDNzfo2Ea7i9VPxtA@mail.gmail.com>
Subject: Re: [PATCH 2/2] PCI: fix system hang issue of Marvell SATA host controller
To: yxlraid <yxlraid@gmail.com>
Cc: "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Xiangliang Yu <yuxiangl@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 7, 2013 at 7:29 AM,  <yxlraid@gmail.com> wrote:
> From: Xiangliang Yu <yuxiangl@marvell.com>
>
> Fix system hang issue: if first accessed resource file of BAR0 ~
> BAR4, system will hang after executing lspci command

This needs more explanation.  We've already read the BARs by the time
header quirks are run, so apparently it's not just the mere act of
accessing a BAR that causes a hang.

We need to know exactly what's going on here.  For example, do BARs
0-4 exist?  Does the device decode accesses to the regions described
by the BARs?  The PCI core has to know what resources the device uses,
so if the device decodes accesses, we can't just throw away the
start/end information.

> ---
>  drivers/pci/quirks.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
> index 0369fb6..d49f8dc 100644
> --- a/drivers/pci/quirks.c
> +++ b/drivers/pci/quirks.c
> @@ -44,6 +44,21 @@ static void quirk_mmio_always_on(struct pci_dev *dev)
>  DECLARE_PCI_FIXUP_CLASS_EARLY(PCI_ANY_ID, PCI_ANY_ID,
>                                 PCI_CLASS_BRIDGE_HOST, 8, quirk_mmio_always_on);
>
> +/* The BAR0 ~ BAR4 of Marvell 9125 device can't be accessed
> +*  by IO resource file, and need to skip the files
> +*/
> +static void quirk_marvell_mask_bar(struct pci_dev *dev)
> +{
> +       int i;
> +
> +       for (i = 0; i < 5; i++)
> +               if (dev->resource[i].start)
> +                       dev->resource[i].start =
> +                               dev->resource[i].end = 0;
> +}
> +DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_MARVELL_EXT, 0x9125,
> +                               quirk_marvell_mask_bar);
> +
>  /* The Mellanox Tavor device gives false positive parity errors
>   * Mark this device with a broken_parity_status, to allow
>   * PCI scanning code to "skip" this now blacklisted device.
> --
> 1.7.5.4
>
