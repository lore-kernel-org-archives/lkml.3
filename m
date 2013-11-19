Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3KSWFp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:05:45 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:51796 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab3KSWFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:05:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131119213557.3839.56953.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20131119212714.3839.52182.stgit@bhelgaas-glaptop.roam.corp.google.com>
	<20131119213557.3839.56953.stgit@bhelgaas-glaptop.roam.corp.google.com>
Date: Tue, 19 Nov 2013 15:05:42 -0700
Message-ID: <CAL-B5D3id0nh_Mt-ZZahWf5Z7WPjgV8-Eu=keXU0mDdgLPXmBQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] PCI: Support PCIe Capability Slot registers only
 for ports with slots
From: Myron Stowe <myron.stowe@gmail.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org, Myron Stowe <myron.stowe@redhat.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Amos Kong <kongjianjun@gmail.com>, Adam Lee <adam.lee@canonical.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Yuval Mintz <yuvalmin@broadcom.com>,
        Ben Hutchings <ben@decadent.org.uk>, Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 2:35 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Commit 6d3a1741f1e648cfbd5a0cc94477a0d5004c6f5e upstream.  This is part
> of the fix for https://bugzilla.kernel.org/show_bug.cgi?id=65211
>
> Previously we allowed callers to access Slot Capabilities, Status, and
> Control for Root Ports even if the Root Port did not implement a slot.
> This seems dubious because the spec only requires these registers if a
> slot is implemented.
>
> It's true that even Root Ports without slots must have *space* for these
> slot registers, because the Root Capabilities, Status, and Control
> registers are after the slot registers in the capability.  However,
> for a v1 PCIe Capability, the *semantics* of the slot registers are
> undefined unless a slot is implemented.
>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-By: Jiang Liu <jiang.liu@huawei.com>
> CC: stable@vger.kernel.org      # v3.7+
> ---
>  drivers/pci/access.c |    6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/pci/access.c b/drivers/pci/access.c
> index 9a46fa9135d9..061da8c3ab4b 100644
> --- a/drivers/pci/access.c
> +++ b/drivers/pci/access.c
> @@ -497,9 +497,9 @@ static inline bool pcie_cap_has_sltctl(const struct pci_dev *dev)
>  {
>         int type = pci_pcie_type(dev);
>
> -       return type == PCI_EXP_TYPE_ROOT_PORT ||
> -              (type == PCI_EXP_TYPE_DOWNSTREAM &&
> -               pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT);
> +       return (type == PCI_EXP_TYPE_ROOT_PORT ||
> +               type == PCI_EXP_TYPE_DOWNSTREAM) &&
> +              pcie_caps_reg(dev) & PCI_EXP_FLAGS_SLOT;
>  }
>
>  static inline bool pcie_cap_has_rtctl(const struct pci_dev *dev)
>

Acked-by: Myron Stowe <myron.stowe@redhat.com>

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
