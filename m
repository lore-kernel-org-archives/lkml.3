Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935114Ab3DOXC6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 19:02:58 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:50389 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932513Ab3DOXC5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 19:02:57 -0400
MIME-Version: 1.0
In-Reply-To: <1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
	<1366065677-3431-1-git-send-email-nhorman@tuxdriver.com>
Date: Mon, 15 Apr 2013 16:02:56 -0700
X-Google-Sender-Auth: zT6nkx9eKEZjBZwBIqD9-n3LrkY
Message-ID: <CAE9FiQU_4ix-mc3aL6nrZD6fexm_52jV-=W-But=eTfx6=U0uA@mail.gmail.com>
Subject: Re: [PATCH v9] irq: add quirk for broken interrupt remapping on 55XX chipsets
From: Yinghai Lu <yinghai@kernel.org>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?ISO-8859-2?Q?Arkadiusz_Mi=B6kiewicz?= <arekm@maven.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 3:41 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> A few years back intel published a spec update:
> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
>
> For the 5520 and 5500 chipsets which contained an errata (specificially errata
> 53), which noted that these chipsets can't properly do interrupt remapping, and
> as a result the recommend that interrupt remapping be disabled in bios.  While
> many vendors have a bios update to do exactly that, not all do, and of course
> not all users update their bios to a level that corrects the problem.  As a
> result, occasionally interrupts can arrive at a cpu even after affinity for that
> interrupt has be moved, leading to lost or spurrious interrupts (usually
> characterized by the message:
> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
>
> There have been several incidents recently of people seeing this error, and
> investigation has shown that they have system for which their BIOS level is such
> that this feature was not properly turned off.  As such, it would be good to
> give them a reminder that their systems are vulnurable to this problem.  For
> details of those that reported the problem, please see:
> https://bugzilla.redhat.com/show_bug.cgi?id=887006
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: Don Zickus <dzickus@redhat.com>
> CC: Don Dutile <ddutile@redhat.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Asit Mallick <asit.k.mallick@intel.com>
> CC: David Woodhouse <dwmw2@infradead.org>
> CC: linux-pci@vger.kernel.org
> CC: Joerg Roedel <joro@8bytes.org>
> CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> CC: Arkadiusz Miśkiewicz <arekm@maven.pl>
> ---
>
> Change notes:
>
> v2)
>
> * Moved the quirk to the x86 arch, since consensus seems to be that the 55XX
> chipset series is x86 only.  I decided however to keep the quirk as a regular
> quirk, not an early_quirk.  Early quirks have no way currently to determine if
> BIOS has properly disabled the feature in the iommu, at least not without
> significant hacking, and since its quite possible this will be a short lived
> quirk, should Don Z's workaround code prove successful (and it looks like it may
> well), I don't think that necessecary.
>
> * Removed the WARNING banner from the quirk, and added the HW_ERR token to the
> string, I opted to leave the newlines in place however, as I really couldnt
> find a way to keep the text on a single line is still legible from a code
> perspective.  I think theres enough language in there that using cscope on just
> about any substring however will turn it up, and again, this may be a short
> lived quirk.
>
> v3)
>
> * Removed defines from pci_ids.h, and used direct id values as per request from
> Bjorn.
>
> v4)
>
> * Converted pr_warn to WARN_TAINT(TAINT_FIRMWARE_WORKAROUND) as per David
> Woodhouse
>
> v5)
>
> * Moved check to an early quirk, and flagged the broken chip, so we could
> reasonably disable irq remapping during bootup.
>
> v6)
>
> * Clean up of stupid extra thrash in quirks.c
>
> v7)
>
> * Move broken check to intel_irq_remapping.c
> * Fixed another typo
> * Finally made the reference bugzilla public
>
> v8)
>
> * Removed extraneous code from irq_remapping_enabled
>
> v9)
>
> * Fix stupid build break from rushing to shuffle simmilar header files about
>   Thanks to Arkadiusz Miśkiewicz  for pointing it out
> ---
>  arch/x86/kernel/early-quirks.c      | 26 ++++++++++++++++++++++++++
>  drivers/iommu/intel_irq_remapping.c | 10 ++++++++++
>  drivers/iommu/irq_remapping.c       |  1 +
>  drivers/iommu/irq_remapping.h       |  2 ++
>  4 files changed, 39 insertions(+)
>
> diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> index 3755ef4..ef4ac6c 100644
> --- a/arch/x86/kernel/early-quirks.c
> +++ b/arch/x86/kernel/early-quirks.c
> @@ -18,6 +18,7 @@
>  #include <asm/apic.h>
>  #include <asm/iommu.h>
>  #include <asm/gart.h>
> +#include "../drivers/iommu/irq_remapping.h"

looks ugly.

>
>  static void __init fix_hypertransport_config(int num, int slot, int func)
>  {
> @@ -192,6 +193,27 @@ static void __init ati_bugs_contd(int num, int slot, int func)
>  }
>  #endif
>
> +#ifdef CONFIG_IRQ_REMAP
> +static void __init intel_remapping_check(int num, int slot, int func)
> +{
> +       u8 revision;
> +
> +       revision = read_pci_config_byte(num, slot, func, PCI_REVISION_ID);
> +
> +       /*
> +        * Revision 0x13 of this chipset supports irq remapping
> +        * but has an erratum that breaks its behavior, flag it as such
> +        */
> +       if (revision == 0x13)
> +               irq_remap_broken = 1;

change to more specific like:

intel_55xx_rev13_found?

> +
> +}
> +#else
> +static void __init intel_remapping_check(int num, int slot, int func)
> +{
> +}
> +#endif
> +
>  #define QFLAG_APPLY_ONCE       0x1
>  #define QFLAG_APPLIED          0x2
>  #define QFLAG_DONE             (QFLAG_APPLY_ONCE|QFLAG_APPLIED)
> @@ -221,6 +243,10 @@ static struct chipset early_qrk[] __initdata = {
>           PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
>         { PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
>           PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
> +       { PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
> +         PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
> +       { PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
> +         PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
>         {}
>  };
>
> diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> index f3b8f23..5b19b2d 100644
> --- a/drivers/iommu/intel_irq_remapping.c
> +++ b/drivers/iommu/intel_irq_remapping.c
> @@ -524,6 +524,16 @@ static int __init intel_irq_remapping_supported(void)
>
>         if (disable_irq_remap)
>                 return 0;
> +       if (irq_remap_broken) {
> +               WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
> +                          "This system BIOS has enabled interrupt remapping\n"
> +                          "on a chipset that contains an erratum making that\n"
> +                          "feature unstable.  To maintain system stability\n"
> +                          "interrupt remapping is being disabled.  Please\n"
> +                          "contact your BIOS vendor for an update\n");
> +               disable_irq_remap = 1;
> +               return 0;
> +       }
>
>         if (!dmar_ir_support())
>                 return 0;
> diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> index d56f8c1..04d975f 100644
> --- a/drivers/iommu/irq_remapping.c
> +++ b/drivers/iommu/irq_remapping.c
> @@ -19,6 +19,7 @@
>  int irq_remapping_enabled;
>
>  int disable_irq_remap;
> +int irq_remap_broken;
>  int disable_sourceid_checking;
>  int no_x2apic_optout;
>
> diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
> index ecb6376..90c4dae 100644
> --- a/drivers/iommu/irq_remapping.h
> +++ b/drivers/iommu/irq_remapping.h
> @@ -32,6 +32,7 @@ struct pci_dev;
>  struct msi_msg;
>
>  extern int disable_irq_remap;
> +extern int irq_remap_broken;
>  extern int disable_sourceid_checking;
>  extern int no_x2apic_optout;
>  extern int irq_remapping_enabled;
> @@ -89,6 +90,7 @@ extern struct irq_remap_ops amd_iommu_irq_ops;
>
>  #define irq_remapping_enabled 0
>  #define disable_irq_remap     1
> +#define irq_remap_broken      0

this one is needed

>
>  #endif /* CONFIG_IRQ_REMAP */
>
> --
> 1.8.1.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
