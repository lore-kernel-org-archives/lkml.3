Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764005Ab3DDR1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 13:27:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763701Ab3DDR1k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 13:27:40 -0400
Message-ID: <515DB7F6.8010502@redhat.com>
Date: Thu, 04 Apr 2013 13:27:18 -0400
From: Don Dutile <ddutile@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.11) Gecko/20121116 Thunderbird/10.0.11
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Neil Horman <nhorman@tuxdriver.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prarit Bhargava <prarit@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Asit Mallick <asit.k.mallick@intel.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH v4] irq: add quirk for broken interrupt remapping on 55XX
 chipsets
References: <1362158276-4901-1-git-send-email-nhorman@tuxdriver.com> <1365088091-10862-1-git-send-email-nhorman@tuxdriver.com> <CAE9FiQUq8m_2fpyRrLweCZwR7cqFBfbZrt9ZeK-PVL3Puxjp0g@mail.gmail.com>
In-Reply-To: <CAE9FiQUq8m_2fpyRrLweCZwR7cqFBfbZrt9ZeK-PVL3Puxjp0g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/04/2013 12:16 PM, Yinghai Lu wrote:
> On Thu, Apr 4, 2013 at 8:08 AM, Neil Horman<nhorman@tuxdriver.com>  wrote:
>> A few years back intel published a spec update:
>> http://www.intel.com/content/dam/doc/specification-update/5520-and-5500-chipset-ioh-specification-update.pdf
>>
>> For the 5520 and 5500 chipsets which contained an errata (specificially errata
>> 53), which noted that these chipsets can't properly do interrupt remapping, and
>> as a result the recommend that interrupt remapping be disabled in bios.  While
>> many vendors have a bios update to do exactly that, not all do, and of course
>> not all users update their bios to a level that corrects the problem.  As a
>> result, occasionally interrupts can arrive at a cpu even after affinity for that
>> interrupt has be moved, leading to lost or spurrious interrupts (usually
>> characterized by the message:
>> kernel: do_IRQ: 7.71 No irq handler for vector (irq -1)
>>
>> There have been several incidents recently of people seeing this error, and
>> investigation has shown that they have system for which their BIOS level is such
>> that this feature was not properly turned off.  As such, it would be good to
>> give them a reminder that their systems are vulnurable to this problem.
>>
>> Signed-off-by: Neil Horman<nhorman@tuxdriver.com>
>> CC: Prarit Bhargava<prarit@redhat.com>
>> CC: Don Zickus<dzickus@redhat.com>
>> CC: Don Dutile<ddutile@redhat.com>
>> CC: Bjorn Helgaas<bhelgaas@google.com>
>> CC: Asit Mallick<asit.k.mallick@intel.com>
>> CC: David Woodhouse<dwmw2@infradead.org>
>> CC: linux-pci@vger.kernel.org
>> ---
>>
>> Change notes:
>>
>> v2)
>>
>> * Moved the quirk to the x86 arch, since consensus seems to be that the 55XX
>> chipset series is x86 only.  I decided however to keep the quirk as a regular
>> quirk, not an early_quirk.  Early quirks have no way currently to determine if
>> BIOS has properly disabled the feature in the iommu, at least not without
>> significant hacking, and since its quite possible this will be a short lived
>> quirk, should Don Z's workaround code prove successful (and it looks like it may
>> well), I don't think that necessecary.
>>
>> * Removed the WARNING banner from the quirk, and added the HW_ERR token to the
>> string, I opted to leave the newlines in place however, as I really couldnt
>> find a way to keep the text on a single line is still legible from a code
>> perspective.  I think theres enough language in there that using cscope on just
>> about any substring however will turn it up, and again, this may be a short
>> lived quirk.
>>
>> v3)
>>
>> * Removed defines from pci_ids.h, and used direct id values as per request from
>> Bjorn.
>>
>> v4)
>>
>> * Converted pr_warn to WARN_TAINT(TAINT_FIRMWARE_WORKAROUND) as per David
>> Woodhouse
>> ---
>>   arch/x86/kernel/quirks.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
>>
>> diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
>> index 26ee48a..eb0785d 100644
>> --- a/arch/x86/kernel/quirks.c
>> +++ b/arch/x86/kernel/quirks.c
>> @@ -5,6 +5,7 @@
>>   #include<linux/irq.h>
>>
>>   #include<asm/hpet.h>
>> +#include "../../../drivers/iommu/irq_remapping.h"
>>
>>   #if defined(CONFIG_X86_IO_APIC)&&  defined(CONFIG_SMP)&&  defined(CONFIG_PCI)
>>
>> @@ -567,3 +568,20 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AMD, PCI_DEVICE_ID_AMD_15H_NB_F5,
>>                          quirk_amd_nb_node);
>>
>>   #endif
>> +
>> +static void intel_remapping_check(struct pci_dev *dev)
>> +{
>> +       u8 revision;
>> +
>> +       pci_read_config_byte(dev, PCI_REVISION_ID,&revision);
>> +
>> +       WARN_TAINT(((revision == 0x13)&&  irq_remapping_enabled),
>> +                  TAINT_FIRMWARE_WORKAROUND,
>> +                   "This system BIOS has enabled interrupt remapping\n"
>> +                   "on a chipset that contains an erratum making that\n"
>> +                   "feature unstable.  Please reboot with nointremap\n"
>> +                   "added to the kernel command line and contact\n"
>> +                   "your BIOS vendor for an update");
>> +}
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3406, intel_remapping_check);
>> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_INTEL, 0x3403, intel_remapping_check);
>
> No, you only address my one request, move to arch/x86 directory.
>
> You need to move the quirk to early_quirk to append nointremap to
> avoid extra rebooting.
>
> Thanks
>
> Yinghai
The pci-dev's of all the (minimally, root, 5500-chipset) pci-dev's are known/scanned/created by that time?

