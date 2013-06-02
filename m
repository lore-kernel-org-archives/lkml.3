Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463Ab3FBAia (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 20:38:30 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:51658 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752586Ab3FBAi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 20:38:26 -0400
MIME-Version: 1.0
In-Reply-To: <1369924769-17183-2-git-send-email-betty.dall@hp.com>
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com> <1369924769-17183-2-git-send-email-betty.dall@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Sat, 1 Jun 2013 18:38:05 -0600
Message-ID: <CAErSpo6KV28p3QRoz-Xx=xMjsFaY7sCho8HN2W_M-DntrNk+Ag@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] PCI/AER: Fix incorrect return from aer_hest_parse()
To: Betty Dall <betty.dall@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Huang Ying <ying.huang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "Moore, Robert" <robert.moore@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Bob for ACPI HEST spec questions]

On Thu, May 30, 2013 at 8:39 AM, Betty Dall <betty.dall@hp.com> wrote:
> The function aer_hest_parse() is called to determine if the given
> PCI device is firmware first or not. The code loops through each
> section of the HEST table to look for a match. The bug is that
> the function always returns whether the last HEST section is firmware
> first. The fix stops the iteration once the info.firmware_first
> variable is set.  This is similar to how the function aer_hest_parse_aff()
> stops the iteration.
>
> Signed-off-by: Betty Dall <betty.dall@hp.com>
> ---
>
>  drivers/pci/pcie/aer/aerdrv_acpi.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
> index 5194a7d..39b8671 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -42,6 +42,9 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
>         u8 bridge = 0;
>         int ff = 0;
>
> +       if (info->firmware_first)
> +               return 0;
> +
>         switch (hest_hdr->type) {
>         case ACPI_HEST_TYPE_AER_ROOT_PORT:
>                 pcie_type = PCI_EXP_TYPE_ROOT_PORT;

Not related directly to your patch, Betty, but I can't figure out why
the ACPI spec defines the HEST structures for PCIe as it does.  I'm
looking at ACPI 5.0, sec 18.3.2.3 - 18.3.2.5.

1) The PCIe Root Port, PCIe Device, and PCIe/PCI-X Bridge structures
all include Bus, Device, and Function fields.  But there's no Segment.
 The current Linux code (hest_match_pci()) assumes HEST records can
only apply to PCI domain 0.  Is Linux missing something, or is the
HEST really this limited?

2) Doesn't the fact that the HEST structures include a bus number mean
that the OS cannot reassign bus numbers?  I guess maybe we could still
reassign them if we kept track of the mapping back to the original
values.

3) It's interesting that the only choices seem to be "global" or "list
every device."  There's no "apply to this device and the subtree under
it," so I guess if you want HEST to apply to hot-added devices,
"global" is the only thing that makes sense?

Bjorn
