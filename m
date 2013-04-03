Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762953Ab3DCXxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 19:53:49 -0400
Received: from mail-oa0-f50.google.com ([209.85.219.50]:44130 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762898Ab3DCXxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 19:53:47 -0400
MIME-Version: 1.0
In-Reply-To: <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com> <1362423859-18516-1-git-send-email-nhorman@tuxdriver.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 3 Apr 2013 17:53:27 -0600
Message-ID: <CAErSpo4=L9q+q5hqP2Avw6uceQwZiPuOzadhsqGpu6aP53PMbQ@mail.gmail.com>
Subject: Re: [PATCH v2] irq: add quirk for broken interrupt remapping on 55XX chipsets
To: Neil Horman <nhorman@tuxdriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        iommu@lists.linux-foundation.org, Yinghai Lu <yinghai@kernel.org>,
        Jiang Liu <jiang.liu@huawei.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc David and iommu list, Yinghai, Jiang]

On Mon, Mar 4, 2013 at 12:04 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
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
> give them a reminder that their systems are vulnurable to this problem.
>
> Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> CC: Prarit Bhargava <prarit@redhat.com>
> CC: Don Zickus <dzickus@redhat.com>
> CC: Don Dutile <ddutile@redhat.com>
> CC: Bjorn Helgaas <bhelgaas@google.com>
> CC: Asit Mallick <asit.k.mallick@intel.com>
> CC: linux-pci@vger.kernel.org
>
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
> ---
>  arch/x86/kernel/quirks.c | 18 ++++++++++++++++++
>  include/linux/pci_ids.h  |  2 ++
>  2 files changed, 20 insertions(+)
>
> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
> index 26ee48a..a718ea2 100644
> --- a/arch/x86/kernel/quirks.c
> +++ b/arch/x86/kernel/quirks.c
> @@ -5,6 +5,7 @@
>  #include <linux/irq.h>
>
>  #include <asm/hpet.h>
> +#include "../../../drivers/iommu/irq_remapping.h"
>
>  #if defined(CONFIG_X86_IO_APIC) && defined(CONFIG_SMP) && defined(CONFIG_PCI)
>
> @@ -567,3 +568,20 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
>                         quirk_amd_nb_node);
>
>  #endif
> +
> +static void intel_remapping_check(struct pci_dev *dev)
> +{
> +       u8 revision;
> +
> +       pci_read_config_byte(dev, PCI_REVISION_ID, &revision);
> +
> +       if ((revision == 0x13) && irq_remapping_enabled) {
> +                pr_warn(HW_ERR "This system BIOS has enabled interrupt remapping\n"
> +                        "on a chipset that contains an errata making that\n"
> +                        "feature unstable.  Please reboot with nointremap\n"
> +                        "added to the kernel command line and contact\n"
> +                        "your BIOS vendor for an update");
> +       }
> +}
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5520_IOHUB, intel_remapping_check);
> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_INTEL_5500_IOHUB, intel_remapping_check);

This started as an IOMMU change, and I'm not an expert in that area,
so I added David and the IOMMU list.  I'd rather have him deal with
this than me.

Is this something we can just *fix* in the kernel, e.g., by turning
off interrupt remapping ourselves, or does it have to be done before
the OS boots?

> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 31717bd..54027a6 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2732,6 +2732,8 @@
>  #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_RANK_REV2  0x2db2
>  #define PCI_DEVICE_ID_INTEL_LYNNFIELD_MC_CH2_TC_REV2    0x2db3
>  #define PCI_DEVICE_ID_INTEL_82855PM_HB 0x3340
> +#define PCI_DEVICE_ID_INTEL_5500_IOHUB 0x3403
> +#define PCI_DEVICE_ID_INTEL_5520_IOHUB 0x3406

For constants only used in one place, we just use the bare constant
(0x3403) in the quirk rather than editing pci_ids.h (see comment at
the top of that file).

>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG4  0x3429
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG5  0x342a
>  #define PCI_DEVICE_ID_INTEL_IOAT_TBG6  0x342b
> --
> 1.7.11.7
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-pci" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
