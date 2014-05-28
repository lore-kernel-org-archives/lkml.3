Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932276AbaE1QCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 12:02:42 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:55587 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbaE1QCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 12:02:41 -0400
MIME-Version: 1.0
In-Reply-To: <537FE860.9000802@amd.com>
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521231817.26447.55150.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521233802.GA21575@pd.tnic> <CAErSpo4hcitey+jtZkgpbZsEswJJekStXONct9rrh0aQ_R0h8g@mail.gmail.com>
 <20140522191746.GL4383@pd.tnic> <CAErSpo7=0-xdnu4DQufu_6eS=6AYhnDRaQvzeiMEC5a=zKU0Jg@mail.gmail.com>
 <537E8ACF.6000103@amd.com> <CAErSpo6AMGPFELx+2qJXYaxaLRhk2F2J=wn4=gLgmvYGdLup7A@mail.gmail.com>
 <537FE860.9000802@amd.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 28 May 2014 10:02:20 -0600
Message-ID: <CAErSpo6Y=F5EYp+h9vroV5-Df48hp7ZpXzgS=_GqXd0Yt0_9pg@mail.gmail.com>
Subject: Re: [PATCH V5 3/4] x86/PCI: Stop enabling ECS for AMD CPUs after Fam16h
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: Borislav Petkov <bp@alien8.de>, Robert Richter <rric@kernel.org>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 23, 2014 at 6:31 PM, Suravee Suthikulanit
<suravee.suthikulpanit@amd.com> wrote:
> On 5/22/2014 9:54 PM, Bjorn Helgaas wrote:
>>
>> I've been poking around for recent dmesg logs that contain "PCI: Using
>> configuration type 1 for extended access", and there are quite a few.
>> In most cases there*is*  an MCFG table, but apparently we decide not
>>
>> to use it for some reason (unfortunately we don't print the specific
>> reason).  One example is at
>> https://bugzilla.kernel.org/show_bug.cgi?id=68591  .
>>
>> I'm going to go out on a limb and guess that Windows does not enable
>> ECS, so it probably uses ECAM.  Therefore, I suspect Linux's parsing
>> of MCFG is broken in some way, and we probably*could*  use ECAM in all
>>
>> these cases I'm seeing.
>>
>> It would probably be prudent to figure out why Linux is rejecting
>> these MCFG tables.  We'll probably see similar tables on Fam17h
>> systems, and if we continue rejecting them, and we don't turn on ECS,
>> we won't be able to access extended config space.
>>
>> I opened a bugzilla for this issue:
>> https://bugzilla.kernel.org/show_bug.cgi?id=76771
>>
>> I'm wavering on whether it's a good idea to put this patch in before
>> understanding the issue.  As much as I'd like to stop fiddling with
>> ECS, we'd likely end up with a v3.15 where extended config space
>> doesn't work on some Fam17h systems.
>
>
> So, I have located a system which presents issue with MMCONFIG. Here is my
> investigation:
>
> DEBUG: pci_io_ecs_init: pci_probe = 4000f
> ACPI: bus type PCI registered
> DEBUG: -----> pci_mmcfg_early_init
> DEBUG: pci_parse_mcfg
> PCI: MMCONFIG for domain 0000 [bus 00-01] at [mem 0xe0000000-0xe01fffff]
> (base 0xe0000000)
> DEBUG: pci_mmcfg_check_reserved
> DEBUG: is_mmconf_reserved: method = E820
> PCI: not using MMCONFIG
> DEBUG: pci_direct_init
> PCI: Using configuration type 1 for base access
>
> PCI: Using configuration type 1 for extended access
> ACPI: Added _OSI(Module Device)
> ACPI: Added _OSI(Processor Device)
> ACPI: Added _OSI(3.0 _SCP Extensions)
> ACPI: Added _OSI(Processor Aggregator Device)
> [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
> \_SB_:_OSC invalid UUID
> _OSC request data:1 1f
> ACPI: Interpreter enabled
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_]
> (20140214/hwxface-580)
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_]
> (20140214/hwxface-580)
> ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_]
> (20140214/hwxface-580)
> ACPI: (supports S0 S3 S5)
> ACPI: Using IOAPIC for interrupt routing
> DEBUG: ----> pci_mmcfg_late_init
> DEBUG: pci_parse_mcfg
> PCI: MMCONFIG for domain 0000 [bus 00-01] at [mem 0xe0000000-0xe01fffff]
> (base 0xe0000000)
> DEBUG: pci_mmcfg_check_reserved
> DEBUG: is_mmconf_reserved: method = ACPI motherboard resources
> PCI: MMCONFIG at [mem 0xe0000000-0xe01fffff] reserved in ACPI motherboard
> resources
>
> During pci_mmcfg_early_init(), the MMCONFIG failed because the range
> 0xe0000000 is not showing as reserved in the E820 mapping.  Here is the
> snippet of E820 mapping from the system:
> ........
> BIOS-e820: [mem 0x00000000c7eb0000-0x00000000c7ec0fff] ACPI data
> BIOS-e820: [mem 0x00000000c7ec1000-0x00000000c7ec2fff] ACPI NVS
> BIOS-e820: [mem 0x00000000c7ec3000-0x00000000c7efefff] reserved
> BIOS-e820: [mem 0x00000000c7f00000-0x00000000c7ffffff] reserved
> BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved
>
> However, during pci_mmcfg_late_init(), the area is reserved in the "ACPI
> motherboard resources", and the pci_mmcfg_check_reserved() does not fail
> here.  But this is too late since we already setup the "raw_pci_ext_ops" in
> the "arch/x86/pci/direct.c: pci_direct_init()" (during to use the IO_ECS.

Thanks for checking this out.  I'm going to going to drop the IO
ECS-related patch for now, and merge the others for v3.16 (the branch
is here: http://git.kernel.org/cgit/linux/kernel/git/helgaas/pci.git/log/?h=pci/amd-numa).

I don't understand why MCFG init is split into two phases, and I don't
have time to sort all that out before v3.16.

Bjorn
