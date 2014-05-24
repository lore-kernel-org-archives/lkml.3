Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751253AbaEXAbh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 20:31:37 -0400
Received: from mail-bn1lp0141.outbound.protection.outlook.com ([207.46.163.141]:47686
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751010AbaEXAbf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 20:31:35 -0400
X-WSS-ID: 0N61YSG-07-5AL-02
X-M-MSG: 
Message-ID: <537FE860.9000802@amd.com>
Date: Fri, 23 May 2014 19:31:28 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Borislav Petkov <bp@alien8.de>, Robert Richter <rric@kernel.org>,
        "Daniel J Blueman" <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH V5 3/4] x86/PCI: Stop enabling ECS for AMD CPUs after
 Fam16h
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521231817.26447.55150.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521233802.GA21575@pd.tnic>
 <CAErSpo4hcitey+jtZkgpbZsEswJJekStXONct9rrh0aQ_R0h8g@mail.gmail.com>
 <20140522191746.GL4383@pd.tnic>
 <CAErSpo7=0-xdnu4DQufu_6eS=6AYhnDRaQvzeiMEC5a=zKU0Jg@mail.gmail.com>
 <537E8ACF.6000103@amd.com>
 <CAErSpo6AMGPFELx+2qJXYaxaLRhk2F2J=wn4=gLgmvYGdLup7A@mail.gmail.com>
In-Reply-To: <CAErSpo6AMGPFELx+2qJXYaxaLRhk2F2J=wn4=gLgmvYGdLup7A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(6009001)(428001)(24454002)(51704005)(189002)(199002)(479174003)(377454003)(99396002)(65956001)(64706001)(47776003)(50466002)(50986999)(54356999)(101416001)(87266999)(20776003)(76482001)(64126003)(81342001)(46102001)(79102001)(85852003)(65806001)(83072002)(59896001)(4396001)(86362001)(80022001)(65816999)(92726001)(77982001)(36756003)(83322001)(80316001)(84676001)(19580395003)(74662001)(102836001)(83506001)(74502001)(23676002)(575784001)(92566001)(97736001)(21056001)(76176999)(44976005)(87936001)(77096999)(33656002)(31966008)(81542001)(68736004)(15975445006);DIR:OUT;SFP:;SCL:1;SRVR:BY2PR0201MB0568;H:atltwp01.amd.com;FPR:;MLV:sfv;PTR:InfoDomainNonexistent;MX:1;A:1;LANG:en;
X-Forefront-PRVS: 02213C82F8
Authentication-Results: spf=none (sender IP is 165.204.84.221)
 smtp.mailfrom=Suravee.Suthikulpanit@amd.com; 
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/22/2014 9:54 PM, Bjorn Helgaas wrote:
> I've been poking around for recent dmesg logs that contain "PCI: Using
> configuration type 1 for extended access", and there are quite a few.
> In most cases there*is*  an MCFG table, but apparently we decide not
> to use it for some reason (unfortunately we don't print the specific
> reason).  One example is at
> https://bugzilla.kernel.org/show_bug.cgi?id=68591  .
>
> I'm going to go out on a limb and guess that Windows does not enable
> ECS, so it probably uses ECAM.  Therefore, I suspect Linux's parsing
> of MCFG is broken in some way, and we probably*could*  use ECAM in all
> these cases I'm seeing.
>
> It would probably be prudent to figure out why Linux is rejecting
> these MCFG tables.  We'll probably see similar tables on Fam17h
> systems, and if we continue rejecting them, and we don't turn on ECS,
> we won't be able to access extended config space.
>
> I opened a bugzilla for this issue:
> https://bugzilla.kernel.org/show_bug.cgi?id=76771
>
> I'm wavering on whether it's a good idea to put this patch in before
> understanding the issue.  As much as I'd like to stop fiddling with
> ECS, we'd likely end up with a v3.15 where extended config space
> doesn't work on some Fam17h systems.

So, I have located a system which presents issue with MMCONFIG. Here is 
my investigation:

DEBUG: pci_io_ecs_init: pci_probe = 4000f
ACPI: bus type PCI registered
DEBUG: -----> pci_mmcfg_early_init
DEBUG: pci_parse_mcfg
PCI: MMCONFIG for domain 0000 [bus 00-01] at [mem 0xe0000000-0xe01fffff] 
(base 0xe0000000)
DEBUG: pci_mmcfg_check_reserved
DEBUG: is_mmconf_reserved: method = E820
PCI: not using MMCONFIG
DEBUG: pci_direct_init
PCI: Using configuration type 1 for base access
PCI: Using configuration type 1 for extended access
ACPI: Added _OSI(Module Device)
ACPI: Added _OSI(Processor Device)
ACPI: Added _OSI(3.0 _SCP Extensions)
ACPI: Added _OSI(Processor Aggregator Device)
[Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
\_SB_:_OSC invalid UUID
_OSC request data:1 1f
ACPI: Interpreter enabled
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S1_] 
(20140214/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S2_] 
(20140214/hwxface-580)
ACPI Exception: AE_NOT_FOUND, While evaluating Sleep State [\_S4_] 
(20140214/hwxface-580)
ACPI: (supports S0 S3 S5)
ACPI: Using IOAPIC for interrupt routing
DEBUG: ----> pci_mmcfg_late_init
DEBUG: pci_parse_mcfg
PCI: MMCONFIG for domain 0000 [bus 00-01] at [mem 0xe0000000-0xe01fffff] 
(base 0xe0000000)
DEBUG: pci_mmcfg_check_reserved
DEBUG: is_mmconf_reserved: method = ACPI motherboard resources
PCI: MMCONFIG at [mem 0xe0000000-0xe01fffff] reserved in ACPI 
motherboard resources

During pci_mmcfg_early_init(), the MMCONFIG failed because the range 
0xe0000000 is not showing as reserved in the E820 mapping.  Here is the 
snippet of E820 mapping from the system:
........
BIOS-e820: [mem 0x00000000c7eb0000-0x00000000c7ec0fff] ACPI data
BIOS-e820: [mem 0x00000000c7ec1000-0x00000000c7ec2fff] ACPI NVS
BIOS-e820: [mem 0x00000000c7ec3000-0x00000000c7efefff] reserved
BIOS-e820: [mem 0x00000000c7f00000-0x00000000c7ffffff] reserved
BIOS-e820: [mem 0x00000000fec00000-0x00000000fec0ffff] reserved

However, during pci_mmcfg_late_init(), the area is reserved in the "ACPI 
motherboard resources", and the pci_mmcfg_check_reserved() does not fail 
here.  But this is too late since we already setup the "raw_pci_ext_ops" 
in the "arch/x86/pci/direct.c: pci_direct_init()" (during to use the IO_ECS.

Suravee
