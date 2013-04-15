Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab3DOQ2V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 12:28:21 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48586 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab3DOQ2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 12:28:17 -0400
Date: Mon, 15 Apr 2013 12:28:06 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Don Dutile <ddutile@redhat.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH v7] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
Message-ID: <20130415162806.GB3505@hmsreliant.think-freely.org>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1366024734-12011-1-git-send-email-nhorman@tuxdriver.com>
 <CAErSpo5-EeAZbTyyoEfqGjS_SXN4P_APjdU7k+oPC3XKbgbwtw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5-EeAZbTyyoEfqGjS_SXN4P_APjdU7k+oPC3XKbgbwtw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 15, 2013 at 09:30:36AM -0600, Bjorn Helgaas wrote:
> On Mon, Apr 15, 2013 at 5:18 AM, Neil Horman <nhorman@tuxdriver.com> wrote:
> > A few years back intel published a spec update:
> > http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
> >
> > For the 5520 and 5500 chipsets which contained an errata (specificially errata
> > 53), which noted that these chipsets can't properly do interrupt remapping, and
> > as a result the recommend that interrupt remapping be disabled in bios.  While
> > many vendors have a bios update to do exactly that, not all do, and of course
> > not all users update their bios to a level that corrects the problem.  As a
> > result, occasionally interrupts can arrive at a cpu even after affinity for that
> > interrupt has be moved, leading to lost or spurrious interrupts (usually
> > characterized by the message:
> > kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
> >
> > There have been several incidents recently of people seeing this error, and
> > investigation has shown that they have system for which their BIOS level is such
> > that this feature was not properly turned off.  As such, it would be good to
> > give them a reminder that their systems are vulnurable to this problem.  For
> > details of those that reported the problem, please see:
> > https://bugzilla.redhat.com/show_bug.cgi?id=887006
> >
> > Signed-off-by: Neil Horman <nhorman@tuxdriver.com>
> > CC: Prarit Bhargava <prarit@redhat.com>
> > CC: Don Zickus <dzickus@redhat.com>
> > CC: Don Dutile <ddutile@redhat.com>
> > CC: Bjorn Helgaas <bhelgaas@google.com>
> > CC: Asit Mallick <asit.k.mallick@intel.com>
> > CC: David Woodhouse <dwmw2@infradead.org>
> > CC: linux-pci@vger.kernel.org
> > CC: Joerg Roedel <joro@8bytes.org>
> > CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >
> > Change notes:
> >
> > v2)
> >
> > * Moved the quirk to the x86 arch, since consensus seems to be that the 55XX
> > chipset series is x86 only.  I decided however to keep the quirk as a regular
> > quirk, not an early_quirk.  Early quirks have no way currently to determine if
> > BIOS has properly disabled the feature in the iommu, at least not without
> > significant hacking, and since its quite possible this will be a short lived
> > quirk, should Don Z's workaround code prove successful (and it looks like it may
> > well), I don't think that necessecary.
> >
> > * Removed the WARNING banner from the quirk, and added the HW_ERR token to the
> > string, I opted to leave the newlines in place however, as I really couldnt
> > find a way to keep the text on a single line is still legible from a code
> > perspective.  I think theres enough language in there that using cscope on just
> > about any substring however will turn it up, and again, this may be a short
> > lived quirk.
> >
> > v3)
> >
> > * Removed defines from pci_ids.h, and used direct id values as per request from
> > Bjorn.
> >
> > v4)
> >
> > * Converted pr_warn to WARN_TAINT(TAINT_FIRMWARE_WORKAROUND) as per David
> > Woodhouse
> >
> > v5)
> >
> > * Moved check to an early quirk, and flagged the broken chip, so we could
> > reasonably disable irq remapping during bootup.
> >
> > v6)
> >
> > * Clean up of stupid extra thrash in quirks.c
> >
> > v7)
> >
> > * Move broken check to intel_irq_remapping.c
> > * Fixed another typo
> > * Finally made the reference bugzilla public
> > ---
> >  arch/x86/kernel/early-quirks.c      | 25 +++++++++++++++++++++++++
> >  drivers/iommu/intel_irq_remapping.c | 10 ++++++++++
> >  drivers/iommu/irq_remapping.c       | 12 ++++++++++++
> >  drivers/iommu/irq_remapping.h       |  1 +
> >  4 files changed, 48 insertions(+)
> >
> > diff --git a/arch/x86/kernel/early-quirks.c b/arch/x86/kernel/early-quirks.c
> > index 3755ef4..bfa3139 100644
> > --- a/arch/x86/kernel/early-quirks.c
> > +++ b/arch/x86/kernel/early-quirks.c
> > @@ -192,6 +192,27 @@ static void __init ati_bugs_contd(int num, int slot, int func)
> >  }
> >  #endif
> >
> > +#ifdef CONFIG_IRQ_REMAP
> > +static void __init intel_remapping_check(int num, int slot, int func)
> > +{
> > +       u8 revision;
> > +
> > +       revision = pci_read_config_byte(num, slot, func , PCI_REVISION_ID);
> > +
> > +       /*
> > +        * Revision 0x13 of this chipset supports irq remapping
> > +        * but has an erratum that breaks its behavior, flag it as such
> > +        */
> > +       if (revision == 0x13)
> > +               irq_remap_broken = 1;
> > +
> > +}
> > +#else
> > +static void __init intel_remapping_check(int num, int slot, int func)
> > +{
> > +}
> > +#endif
> > +
> >  #define QFLAG_APPLY_ONCE       0x1
> >  #define QFLAG_APPLIED          0x2
> >  #define QFLAG_DONE             (QFLAG_APPLY_ONCE|QFLAG_APPLIED)
> > @@ -221,6 +242,10 @@ static struct chipset early_qrk[] __initdata = {
> >           PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
> >         { PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
> >           PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
> > +       { PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
> > +         PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
> > +       { PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
> > +         PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
> >         {}
> >  };
> >
> > diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
> > index f3b8f23..5b19b2d 100644
> > --- a/drivers/iommu/intel_irq_remapping.c
> > +++ b/drivers/iommu/intel_irq_remapping.c
> > @@ -524,6 +524,16 @@ static int __init intel_irq_remapping_supported(void)
> >
> >         if (disable_irq_remap)
> >                 return 0;
> > +       if (irq_remap_broken) {
> > +               WARN_TAINT(1, TAINT_FIRMWARE_WORKAROUND,
> > +                          "This system BIOS has enabled interrupt remapping\n"
> > +                          "on a chipset that contains an erratum making that\n"
> > +                          "feature unstable.  To maintain system stability\n"
> > +                          "interrupt remapping is being disabled.  Please\n"
> > +                          "contact your BIOS vendor for an update\n");
> > +               disable_irq_remap = 1;
> > +               return 0;
> > +       }
> >
> >         if (!dmar_ir_support())
> >                 return 0;
> > diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
> > index d56f8c1..2b56e92 100644
> > --- a/drivers/iommu/irq_remapping.c
> > +++ b/drivers/iommu/irq_remapping.c
> > @@ -19,6 +19,7 @@
> >  int irq_remapping_enabled;
> >
> >  int disable_irq_remap;
> > +int irq_remap_broken;
> >  int disable_sourceid_checking;
> >  int no_x2apic_optout;
> >
> > @@ -216,6 +217,17 @@ int irq_remapping_supported(void)
> >         if (disable_irq_remap)
> >                 return 0;
> >
> > +       if (irq_remap_broken) {
> > +               WARN_TAINT(1, TAIN_FIRMWARE_WORKAROUND,
> > +                          "This system BIOS has enabled interrupt remapping\n"
> > +                          "on a chipset that contains an erratum making that\n"
> > +                          "feature unstable.  Please reboot with nointremap\n"
> > +                          "added to the kernel command line and contact\n"
> > +                          "your BIOS vendor for an update");
> > +               disable_irq_remap = 1;
> > +               return 0;
> > +       }
> > +
> 
> I think you probably intended to drop the change to this file, since
> you moved it to intel_irq_remapping.c.  If you did intend to keep it,
> s/TAIN_/TAINT_/.
Damnit, yes, sorry.  Not sure how that snuck back in there.  I know I had
removed it.  Perhaps I forgot to commit that part of the change.

Neil

