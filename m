Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758122AbaD2PRI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 11:17:08 -0400
Received: from mail-by2lp0240.outbound.protection.outlook.com ([207.46.163.240]:7231
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757927AbaD2PRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 11:17:05 -0400
X-WSS-ID: 0N4ST4A-07-7R3-02
X-M-MSG: 
Message-ID: <535FC269.2000808@amd.com>
Date: Tue, 29 Apr 2014 10:16:57 -0500
From: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>
CC: Bjorn Helgaas <bhelgaas@google.com>, Robert Richter <rric@kernel.org>,
        Myron Stowe <myron.stowe@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        linux-pci <linux-pci@vger.kernel.org>, <kim.naru@amd.com>,
        Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, "Jan Beulich" <JBeulich@suse.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range capabilities
References: <20140419025308.2408.51252.stgit@amt.stowe>
 <20140419025323.2408.88764.stgit@amt.stowe> <20140419135219.GC8109@pd.tnic>
 <20140420075936.GA19672@pd.tnic>
 <CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com>
 <20140426091031.GA10166@pd.tnic>
 <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
 <20140428214036.GA32143@pd.tnic> <20140429073309.GE10997@alberich>
 <20140429102013.GA4726@pd.tnic>
In-Reply-To: <20140429102013.GA4726@pd.tnic>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-EOPAttributedMessage: 0
X-Forefront-Antispam-Report: CIP:165.204.84.221;CTRY:US;IPV:NLI;IPV:NLI;EFV:NLI;SFV:NSPM;SFS:(10009001)(6009001)(428001)(199002)(189002)(24454002)(479174003)(377454003)(51704005)(47776003)(79102001)(81342001)(65806001)(87936001)(97736001)(20776003)(80022001)(84676001)(101416001)(50986999)(83506001)(65956001)(92726001)(46102001)(54356999)(59896001)(44976005)(80316001)(83322001)(92566001)(76482001)(2009001)(81542001)(23676002)(50466002)(4396001)(36756003)(74502001)(77982001)(99396002)(76176999)(87266999)(64126003)(31966008)(80976001)(33656001)(77096999)(74662001)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BLUPR02MB114;H:atltwp01.amd.com;FPR:EC94F656.AE3EDC90.39D3997B.609FCD1.20374;MLV:sfv;PTR:InfoDomainNonexistent;A:1;MX:1;LANG:en;
X-Forefront-PRVS: 0196A226D1
X-OriginatorOrg: amd4.onmicrosoft.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/29/2014 5:20 AM, Borislav Petkov wrote:
> On Tue, Apr 29, 2014 at 09:33:09AM +0200, Andreas Herrmann wrote:
>> I am sure, it's because some server systems had MMIO ECS access not
>> enabled in BIOS. I can't remember which systems were affected.
>
If you are referring to accessing PCI ECS ranges via 0xCF8, then yes, 
BIOS disable this as described below in the BKDG.

"The BIOS may use either configuration space access mechanism during 
boot. Before booting the OS, BIOS must disable IO access to ECS, enable 
MMIO configuration and build an ACPI defined MCFG table. BIOS ACPI code 
must use MMIO to access configuration space."

> Ok, now AMD people: what's the story with IO ECS, can we assume that on
> everything after F10h, BIOS has a sensible MCFG and we can limit this to
> F10h only? I like Bjorn's idea but we need to make sure a working MCFG
> is ubiquitous.
>
> Which begs the real question: Suravee, why are you even touching IO ECS
> provided F15h and later have a MCFG? Or, do they?
>

As I was trying to generalize the logic inside amd_bus.c, which seems to 
be used mainly as a fallback mechanism, I tried to maintain the existing 
code, which does many things:
     1. Setup numa_node information (if PXM doesn't exist)
     2. Probe NB for MMIO resources (if MCFG doesn't exist)
     3. Probe NB for IO resources
     4. Setup IO ECS

In the new code, the IO ECS was needed to retrieve the 
AMD_NB_F1_MMIO_BASE_LIMIT_HI_REG (offset 0x180) during the early 
initialization as part of (2) logic. However, this register exists only 
on the newer systems.  However, as you mentioned, for (2) we can assume 
that the MCFG exists for most of the systems (family10h and later), and 
should be used instead.

The main purpose of this patch set is mainly to deal with the the node 
information (1).  So, we might need to split these all up and handle 
them separately as needed where (2) and (3) will be used as fallback for 
older systems where MCFG does not exist. I am not sure if where we need (4).

Suravee

