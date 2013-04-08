Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934854Ab3DHRRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 13:17:46 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:54788 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757706Ab3DHRRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 13:17:43 -0400
MIME-Version: 1.0
In-Reply-To: <5162E266.6080002@redhat.com>
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com>
 <1365190294-9061-1-git-send-email-nhorman@tuxdriver.com> <CAErSpo6z8oqiaUBCieUMsS_c5xvVFUDbHqVO_eBBde3uv2=zcg@mail.gmail.com>
 <5162E266.6080002@redhat.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 8 Apr 2013 11:17:23 -0600
Message-ID: <CAErSpo5DNe-x6Fi3i6K=9xnd47d-T-q4_bH0tiud_8Ak2eL=TQ@mail.gmail.com>
Subject: Re: [PATCH v6] irq: add quirk for broken interrupt remapping on 55XX chipsets
To: Don Dutile <ddutile@redhat.com>
Cc: Neil Horman <nhorman@tuxdriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Joerg Roedel <joro@8bytes.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Joerg, Konrad]

On Mon, Apr 8, 2013 at 9:29 AM, Don Dutile <ddutile@redhat.com> wrote:
> On 04/05/2013 09:55 PM, Bjorn Helgaas wrote:
>>
>> On Fri, Apr 5, 2013 at 1:31 PM, Neil Horman<nhorman@tuxdriver.com>  wrote:
>>>
>>> A few years back intel published a spec update:
>>>
>>> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
>>>
>>> For the 5520 and 5500 chipsets which contained an errata (specificially
>>> errata
>>> 53), which noted that these chipsets can't properly do interrupt
>>> remapping, and
>>> as a result the recommend that interrupt remapping be disabled in bios.
>>> While
>>> many vendors have a bios update to do exactly that, not all do, and of
>>> course
>>> not all users update their bios to a level that corrects the problem.  As
>>> a
>>> result, occasionally interrupts can arrive at a cpu even after affinity
>>> for that
>>> interrupt has be moved, leading to lost or spurrious interrupts (usually
>>> characterized by the message:
>>> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
>>>
>>> There have been several incidents recently of people seeing this error,
>>> and
>>> investigation has shown that they have system for which their BIOS level
>>> is such
>>> that this feature was not properly turned off.  As such, it would be good
>>> to
>>> give them a reminder that their systems are vulnurable to this problem.
>>
>>
>> I'd still like to mention the bugzilla URL in the changelog
>> (https://bugzilla.redhat.com/show_bug.cgi?id=887006) if it can be made
>> public.
>>
>>> ...
>>
>>
>>> diff --git a/arch/x86/kernel/early-quirks.c
>>> b/arch/x86/kernel/early-quirks.c
>>> index 3755ef4..bfa3139 100644
>>> --- a/arch/x86/kernel/early-quirks.c
>>> +++ b/arch/x86/kernel/early-quirks.c
>>> @@ -192,6 +192,27 @@ static void __init ati_bugs_contd(int num, int slot,
>>> int func)
>>>   }
>>>   #endif
>>>
>>> +#ifdef CONFIG_IRQ_REMAP
>>> +static void __init intel_remapping_check(int num, int slot, int func)
>>> +{
>>> +       u8 revision;
>>> +
>>> +       revision = pci_read_config_byte(num, slot, func ,
>>> PCI_REVISION_ID);
>>> +
>>> +       /*
>>> +        * Revision 0x13 of this chipset supports irq remapping
>>> +        * but has an erratum that breaks its behavior, flag it as such
>>> +        */
>>> +       if (revision == 0x13)
>>> +               irq_remap_broken = 1;
>>> +
>>> +}
>>> +#else
>>> +static void __init intel_remapping_check(int num, int slot, int func)
>>> +{
>>> +}
>>> +#endif
>>> +
>>>   #define QFLAG_APPLY_ONCE       0x1
>>>   #define QFLAG_APPLIED          0x2
>>>   #define QFLAG_DONE             (QFLAG_APPLY_ONCE|QFLAG_APPLIED)
>>> @@ -221,6 +242,10 @@ static struct chipset early_qrk[] __initdata = {
>>>            PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs },
>>>          { PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS,
>>>            PCI_CLASS_SERIAL_SMBUS, PCI_ANY_ID, 0, ati_bugs_contd },
>>> +       { PCI_VENDOR_ID_INTEL, 0x3403, PCI_CLASS_BRIDGE_HOST,
>>> +         PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
>>> +       { PCI_VENDOR_ID_INTEL, 0x3406, PCI_CLASS_BRIDGE_HOST,
>>> +         PCI_BASE_CLASS_BRIDGE, 0, intel_remapping_check },
>>>          {}
>>>   };
>>>
>>> diff --git a/drivers/iommu/irq_remapping.c
>>> b/drivers/iommu/irq_remapping.c
>>> index d56f8c1..2b56e92 100644
>>> --- a/drivers/iommu/irq_remapping.c
>>> +++ b/drivers/iommu/irq_remapping.c
>>> @@ -19,6 +19,7 @@
>>>   int irq_remapping_enabled;
>>>
>>>   int disable_irq_remap;
>>> +int irq_remap_broken;
>>>   int disable_sourceid_checking;
>>>   int no_x2apic_optout;
>>>
>>> @@ -216,6 +217,17 @@ int irq_remapping_supported(void)
>>>          if (disable_irq_remap)
>>>                  return 0;
>>>
>>> +       if (irq_remap_broken) {
>>> +               WARN_TAINT(1, TAIN_FIRMWARE_WORKAROUND,
>>
>>
>> This looks like a typo (s/TAIN/TAINT/).
>>
>>> +                          "This system BIOS has enabled interrupt
>>> remapping\n"
>>> +                          "on a chipset that contains an erratum making
>>> that\n"
>>> +                          "feature unstable.  Please reboot with
>>> nointremap\n"
>>> +                          "added to the kernel command line and
>>> contact\n"
>>> +                          "your BIOS vendor for an update");
>>
>>
>> I suspect your updated message won't mention "nointremap", but if it
>> does, Documentation/kernel-parameters.txt says that option is
>> deprecated and "intremap=off" should be used instead.
>>
>>> +               disable_irq_remap = 1;
>>
>>AMD
>> Tell me if I have this correct:
>>
>> Before this patch, we had interrupt remapping enabled and
>> virtualization enabled.  This is safe, but devices might need resets
>> to deal with lost or spurious interrupts.
>>
> Bigger then that -- system reboots are often necessary, and for
> virtualization,
> that means not just the lost of the device, but all guests running on that
> host.
>
>
>> After this patch, these same machines will by default have interrupt
>> remapping disabled and virtualization enabled.  The lost or spurious
>> interrupt problem should be gone, but we now have the IRQ injection
>> security bug.
>>
> IRQ injection security bug *if* device-assignment of a PCI(e) device
> to a KVM guest is done.  To do so, requires kvm to be loaded with
> a parameter to allow device-assignment w/o intr-remapping (b/c certain
> chipsets
> didn't have intr-remap support complete until this past summer).
> So, a sysadmin would have to consciously enable this security vulnerability,
> and is only a vulnerability if (a) the guest is not well known/behaved or
> (b) the assigned device goes-bonkers/breaks.
> This vulnerability has been known and in existence since the beginning of
> device-assignment; intr-remap is the way to isolate it.
> The end result on this (rev of this) chip set is the equivalent of running
> device-assignment on a (2009 era) Q35 chipset -- a VT-d1 (IOMMU-only,
> no-intr-remap) capable chipset.

Thanks for the details, Don.  It makes sense to me to disable
intr-remap on this chipset and handle it like an older machine that's
not capable of intr-remap at all.  The IRQ injection issue should be
no worse than on those older machines.

I don't care whether the "if (irq_remap_broken)" test is in
irq_remapping.c or intel_irq_remapping.c.  The quirk itself, where we
actually look at config space, is clearly Intel-specific, but there
could easily be similar AMD quirks that could also set
irq_remap_broken.  In that case, it would make sense to have the test
in the common code.

Other than the fact that the quirk looks at PCI config space to find
the revision, this really isn't a PCI patch, so I hope somebody else
will take care of this.  From MAINTAINERS, it looks like nobody else
wants irq_remapping.c either :)  I cc'd Joerg and Konrad, who have
made many of the recent changes.

Bjorn
