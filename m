Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaAMT3q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:29:46 -0500
Received: from mail-ig0-f174.google.com ([209.85.213.174]:41852 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751543AbaAMT3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:29:44 -0500
MIME-Version: 1.0
In-Reply-To: <1386256104-20624-1-git-send-email-betty.dall@hp.com>
References: <1386256104-20624-1-git-send-email-betty.dall@hp.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 13 Jan 2014 12:29:23 -0700
Message-ID: <CAErSpo6VeD=TbrtCkXPkUwMT8Edz7bdBQHAimvW1v8bMrmdR9g@mail.gmail.com>
Subject: Re: [PATCH] PCI/ACPI: Use PCIe segment in the ACPI HEST AER error sources
To: Betty Dall <betty.dall@hp.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Moore, Robert" <robert.moore@intel.com>,
        Lv Zheng <lv.zheng@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 5, 2013 at 8:08 AM, Betty Dall <betty.dall@hp.com> wrote:
> In the discussion for this set of patches: https://lkml.org/lkml/2013/6/6/517,
> Bjorn Helgaas pointed out that the ACPI HEST AER error sources do not have the
> PCIe segment number associated with the bus. I worked with the ACPI spec and
> got this change to definition of the "Bus" field into the recently released
> ACPI Spec 5.0a section 18.3.2.3-5:
>
> "Identifies the PCI Bus and Segment of the device. The Bus is
> encoded in bits 0-7. For systems that expose multiple PCI
> segment groups, the segment number is encoded in bits 8-23
> and bits 24-31 must be zero. For systems that do not expose
> multiple PCI segment groups, bits 8-31 must be zero. If the
> GLOBAL flag is specified, this field is ignored."
>
> This patch makes use of the new definition in the only place in the kernel
> that uses the acpi_hest_aer_common's bus field.
>
> Signed-off-by: Betty Dall <betty.dall@hp.com>

I cherry picked 36f3615152c1 ("ACPICA: Add helper macros to extract
bus/segment numbers from HEST table.") and applied the aerdrv_acpi.c
change to pci/aer for v3.14, thanks!

Bjorn

> ---
>
>  drivers/pci/pcie/aer/aerdrv_acpi.c |    8 ++++----
>  include/acpi/actbl1.h              |   11 ++++++++++-
>  2 files changed, 14 insertions(+), 5 deletions(-)
>
>
> diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
> index cf611ab..93f852b 100644
> --- a/drivers/pci/pcie/aer/aerdrv_acpi.c
> +++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
> @@ -23,10 +23,10 @@
>  static inline int hest_match_pci(struct acpi_hest_aer_common *p,
>                                  struct pci_dev *pci)
>  {
> -       return  (0           == pci_domain_nr(pci->bus) &&
> -                p->bus      == pci->bus->number &&
> -                p->device   == PCI_SLOT(pci->devfn) &&
> -                p->function == PCI_FUNC(pci->devfn));
> +       return   ACPI_HEST_SEGMENT(p->bus) == pci_domain_nr(pci->bus) &&
> +                ACPI_HEST_BUS(p->bus)     == pci->bus->number &&
> +                p->device                 == PCI_SLOT(pci->devfn) &&
> +                p->function               == PCI_FUNC(pci->devfn);
>  }
>
>  static inline bool hest_match_type(struct acpi_hest_header *hest_hdr,
> diff --git a/include/acpi/actbl1.h b/include/acpi/actbl1.h
> index 556c83ee..0c7428b 100644
> --- a/include/acpi/actbl1.h
> +++ b/include/acpi/actbl1.h
> @@ -457,7 +457,7 @@ struct acpi_hest_aer_common {
>         u8 enabled;
>         u32 records_to_preallocate;
>         u32 max_sections_per_record;
> -       u32 bus;
> +       u32 bus;                /* bus: bits 0-7; segment: bits 8-23 */
>         u16 device;
>         u16 function;
>         u16 device_control;
> @@ -473,6 +473,15 @@ struct acpi_hest_aer_common {
>  #define ACPI_HEST_FIRMWARE_FIRST        (1)
>  #define ACPI_HEST_GLOBAL                (1<<1)
>
> +/*
> + * The segment/bus of the PCIe device is encoded in the bus field
> + * of the acpi_hest_aer_common structure as follows:
> + *      23:8 = segment
> + *      7:0 = bus
> + */
> +#define ACPI_HEST_SEGMENT(bus)         (((bus) >> 8) & 0xFFFF)
> +#define ACPI_HEST_BUS(bus)             ((bus) & 0xFF)
> +
>  /* Hardware Error Notification */
>
>  struct acpi_hest_notify {
