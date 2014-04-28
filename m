Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932805AbaD1VLA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 17:11:00 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:37195 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932415AbaD1VK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 17:10:56 -0400
MIME-Version: 1.0
In-Reply-To: <20140419113111.GA8109@pd.tnic>
References: <20140419025308.2408.51252.stgit@amt.stowe>
	<20140419025316.2408.29771.stgit@amt.stowe>
	<20140419113111.GA8109@pd.tnic>
Date: Mon, 28 Apr 2014 15:10:55 -0600
Message-ID: <CAL-B5D0j8JXPTC87wsaArHVGPJxKphW8i0LCMYHR_2ck2S7AXA@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] x86/PCI: Add support for generic AMD hostbridges
From: Myron Stowe <myron.stowe@gmail.com>
To: Borislav Petkov <bp@suse.de>
Cc: Myron Stowe <myron.stowe@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        kim.naru@amd.com, daniel@numascale.com,
        Thomas Gleixner <tglx@linutronix.de>, mingo@redhat.com, hpa@zytor.com,
        x86 <x86@kernel.org>, sp@numascale.com,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 19, 2014 at 5:31 AM, Borislav Petkov <bp@suse.de> wrote:
> On Fri, Apr 18, 2014 at 08:53:16PM -0600, Myron Stowe wrote:
>> From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>>
>> AMD hostbridges gnenerally show up as PCI device 0:18.0.  This patch adds
>> logic to automatically probe the device at this location and check PCI
>> device class code.
>>
>> This patch supports platforms with the following AMD hostbridge types:
>> (K8, family10h, 11h, 12h, 14h 15h  and 16h processors).
>>
>> Reference(s):
>>   https://bugzilla.kernel.org/show_bug.cgi?id=72051
>>   Advanced Micro Devices (AMD), "BIOS and Kernel Developer's
>>   Guide (BKDG) for AMD Family 15h Models 00h-0fh Processors."  Section
>>   3.4 Device [1F:18]h Function 1 Configuration Registers; D18F1x[EC:E0]
>>   Configuration Map, 42301 Rev 3.12 - October 11, 2012.
>>
>> Signed-off-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
>> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
>> Tested-by: Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>
>> ---
>>
>>  arch/x86/pci/amd_bus.c |   71 ++++++++++++++++++++++++++++++++----------------
>>  1 files changed, 47 insertions(+), 24 deletions(-)
>>
>> diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
>> index e88f4c5..c8cd75c 100644
>> --- a/arch/x86/pci/amd_bus.c
>> +++ b/arch/x86/pci/amd_bus.c
>> @@ -11,27 +11,34 @@
>>
>>  #include "bus_numa.h"
>>
>> +#define AMD_NB_F0_NODE_ID                    0x60
>> +#define AMD_NB_F0_UNIT_ID                    0x64
>> +#define AMD_NB_F1_CONFIG_MAP_REG             0xe0
>> +
>> +#define RANGE_NUM                            16
>> +#define AMD_NB_F1_CONFIG_MAP_RANGES          4
>> +
>>  /*
>> - * This discovers the pcibus <-> node mapping on AMD K8.
>> - * also get peer root bus resource for io,mmio
>> + * This discovers the pcibus <-> node mapping on AMD K8, Family 10h, 12h,
>> + * 14h, 15h, and 16h processor based systems.  This also gets peer root bus
>> + * resources corresponding to I/O and MMIO addresses.
>>   */
>>
>> -struct pci_hostbridge_probe {
>> +struct amd_hostbridge {
>>       u32 bus;
>>       u32 slot;
>> -     u32 vendor;
>>       u32 device;
>>  };
>>
>> -static struct pci_hostbridge_probe pci_probes[] __initdata = {
>> -     { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
>> -     { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
>> -     { 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
>> -     { 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
>> +static struct amd_hostbridge hb_probes[] __initdata = {
>> +     /* Standard AMD Hostbriges are at bus 0x0 slot 0x18.
>> +      * In case of PCI_ANY_ID, the logic will try matching
>> +      * PCI_CLASS_BRIDGE_HOST instead.
>> +      */
>
> Standard kernel comment style:
>
> /*
>  * Something interesting for the code below.
>  * This is the second comment line.
>  */
>

I went ahead and made this change in patch 1/5 (even though most
non-functional changes are in patch 3/5) as it seems to belong here.

>> +     { 0x0 , 0x18, PCI_ANY_ID },
>> +     { 0xff, 0   , PCI_DEVICE_ID_AMD_10H_NB_HT },
>>  };
>>
>> -#define RANGE_NUM 16
>> -
>>  static struct pci_root_info __init *find_pci_root_info(int node, int link)
>>  {
>>       struct pci_root_info *info;
>> @@ -75,31 +82,47 @@ static int __init early_fill_mp_bus_info(void)
>
> Btw, this function is huuuge. It could use a splitup some day.
>

Yes, Suravee did split this up in patch 3/5

>>               return -1;
>>
>>       found = false;
>> -     for (i = 0; i < ARRAY_SIZE(pci_probes); i++) {
>> +     for (i = 0; i < ARRAY_SIZE(hb_probes); i++) {
>>               u32 id;
>>               u16 device;
>>               u16 vendor;
>> +             u32 class;
>>
>> -             bus = pci_probes[i].bus;
>> -             slot = pci_probes[i].slot;
>> +             bus = hb_probes[i].bus;
>> +             slot = hb_probes[i].slot;
>>               id = read_pci_config(bus, slot, 0, PCI_VENDOR_ID);
>> -
>>               vendor = id & 0xffff;
>>               device = (id>>16) & 0xffff;
>> -             if (pci_probes[i].vendor == vendor &&
>> -                 pci_probes[i].device == device) {
>> -                     found = true;
>> -                     break;
>> +             class = read_pci_config(bus, slot, 0,
>> +                     PCI_CLASS_REVISION) >> 16;
>> +
>> +             if (PCI_VENDOR_ID_AMD == vendor) {
>
> Flip comparison:
>
>                 if (vendor == PCI_VENDOR_ID_AMD)
>
> and then save yourself another indentation level:
>
>                 if (vendor != PCI_VENDOR_ID_AMD)
>                         continue;
>

Yes, much better

>> +                     if (hb_probes[i].device == device) {
>> +                             found = true;
>> +                             break;
>> +                     }
>> +
>> +                     if ((hb_probes[i].device == PCI_ANY_ID) &&
>> +                         (class == PCI_CLASS_BRIDGE_HOST)) {
>> +                             hb_probes[i].device = device;
>> +                             found = true;
>> +                             break;
>> +                     }
>>               }
>>       }
>>
>> -     if (!found)
>> +     if (!found) {
>> +             pr_warn("AMD hostbridge not found\n");
>>               return 0;
>> +     }
>
> I guess this should return a negative value... Not that it matters much
> from looking at the call site in the amd_postcore_init initcall.
>

Patch 3/5 cleans this up.

>>
>> -     for (i = 0; i < 4; i++) {
>> +     pr_debug("Found AMD hostbridge at %x:%x.0\n", bus, slot);
>
> Why not pr_info? I think this is useful info we want to print out at
> default level.

Sure, ok  ;)
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
