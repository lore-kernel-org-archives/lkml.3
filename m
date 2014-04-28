Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756903AbaD1Uuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:50:54 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:47979 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756788AbaD1Uuu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:50:50 -0400
MIME-Version: 1.0
In-Reply-To: <20140426091031.GA10166@pd.tnic>
References: <20140419025308.2408.51252.stgit@amt.stowe> <20140419025323.2408.88764.stgit@amt.stowe>
 <20140419135219.GC8109@pd.tnic> <20140420075936.GA19672@pd.tnic>
 <CAL-B5D1rJmf9vLSnV2izsXcbCu1idXsTsnSwoFRKFNTM7BnyfA@mail.gmail.com> <20140426091031.GA10166@pd.tnic>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 28 Apr 2014 14:50:29 -0600
Message-ID: <CAErSpo4Jqo_opj=QqjcquS_6HqckZfP5-oQHkmY5FSAyyLNYMg@mail.gmail.com>
Subject: Re: [PATCH v2 2/5] x86/PCI: Support additional MMIO range capabilities
To: Borislav Petkov <bp@suse.de>
Cc: Myron Stowe <myron.stowe@gmail.com>, Myron Stowe <myron.stowe@redhat.com>,
        linux-pci <linux-pci@vger.kernel.org>,
        Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
        Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>,
        kim.naru@amd.com, Daniel J Blueman <daniel@numascale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86 <x86@kernel.org>,
        Steffen Persvold <sp@numascale.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Robert Richter <rric@kernel.org>,
        Jan Beulich <JBeulich@suse.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Jan (24d9b70b8 author), Yinghai]

On Sat, Apr 26, 2014 at 3:10 AM, Borislav Petkov <bp@suse.de> wrote:
> + Robert.
>
> On Fri, Apr 25, 2014 at 04:24:31PM -0600, Myron Stowe wrote:
>> On Sun, Apr 20, 2014 at 1:59 AM, Borislav Petkov <bp@suse.de> wrote:
>> > Drop Andreas' old email address from CC as it keeps bouncing.
>> >
>> > On Sat, Apr 19, 2014 at 03:52:20PM +0200, Borislav Petkov wrote:
>> >> > -static void __init pci_enable_pci_io_ecs(void)
>> >> > +static void __init pci_enable_pci_io_ecs(u8 bus, u8 slot)
>> >> >  {
>> >> >  #ifdef CONFIG_AMD_NB
>> >> >     unsigned int i, n;
>> >> > +   u8 limit;
>> >> >
>> >> >     for (n = i = 0; !n && amd_nb_bus_dev_ranges[i].dev_limit; ++i) {
>> >> > -           u8 bus = amd_nb_bus_dev_ranges[i].bus;
>> >> > -           u8 slot = amd_nb_bus_dev_ranges[i].dev_base;
>> >> > -           u8 limit = amd_nb_bus_dev_ranges[i].dev_limit;
>> >> > +           /* Try matching for the bus range */
>> >> > +           if ((bus != amd_nb_bus_dev_ranges[i].bus) ||
>> >> > +               (slot != amd_nb_bus_dev_ranges[i].dev_base))
>> >> > +                   continue;
>> >> > +
>> >> > +           limit = amd_nb_bus_dev_ranges[i].dev_limit;
>> >> >
>> >> > +           /* Setup all northbridges within the range */
>> >> >             for (; slot < limit; ++slot) {
>> >> >                     u32 val = read_pci_config(bus, slot, 3, 0);
>> >> > -
>> >> > -                   if (!early_is_amd_nb(val))
>> >> > +                   if (!val)
>> >> >                             continue;
>> >> >
>> >> >                     val = read_pci_config(bus, slot, 3, 0x8c);
>> >> > @@ -375,13 +457,14 @@ static void __init pci_enable_pci_io_ecs(void)
>> >> >                             val |= ENABLE_CF8_EXT_CFG >> 32;
>> >>
>> >> What a fun shifting!
>> >>
>> >> Maybe you should do
>> >>
>> >> #define ENABLE_CF8_EXT_CFG    BIT(46 - 32)
>> >>
>> >> to show exactly what you mean and how the bit is defined in MSR NB_CFG1
>> >> and also show how the high 32-bits are mapped into F3x8c, while at it.
>> >>
>> >> And then you can drop the shifting at the call site.
>> >
>> > Ok, I see another fun with this ECS enabling:
>> >
>> > There's a enable_pci_io_ecs() which enables ECS through the NB_CFG MSR
>> > which is called as part of the notifier *and* there's a PCI write to
>> > that same bit in pci_enable_pci_io_ecs() which iterates over all NBs.
>> >
>> > So, AFAICT, we do it twice and the second time is not needed. Which
>> > means, you probably can drop pci_enable_pci_io_ecs() completely and use
>> > solely the notifier?
>>
>> It does look as if there is some duplication with respect to setting
>> MSR_AMD64_NB_CFG's (which is aliased at D18F3x8c [1])
>> ENABLE_CF8_EXT_CFG enable bit but there are at least a couple of
>> differences.
>>
>> enable_pci_io_ecs() only sets the bit on one NB whereas
>> pci_enable_pci_io_ecs iterates over all the NBs (as you mentioned
>> above).  The other difference has something to do with Xen; see the
>> origin of pci_enable_pci_io_ecs - commit 24d9b70b8.
>
> Of course it is xen - what else?! We do have to carry special code in
> baremetal just for it because it is special and we all can't seem to get
> enough of its crap.
>
> Oh well, I guess we should at least comment this and refer to 24d9b70b8
> so that the explanation is right there, in the code.

This is probably obvious, but my interest here is to (1) make sure all
systems in the field run well (so we need quirks to work around BIOS
and other issues), and (2) eliminate the need for kernel changes to
support future systems.  So far we seem to be concentrating on (1) and
neglecting (2), which means we're always reacting to things that are
broken.

This I/O ECS thing seems likely to cause future problems.  My
understanding (based on sec 2.8 of [1]) is that enable_pci_io_ecs()
and pci_enable_pci_io_ecs() are there to enable access to extended
config space (offsets 256-4095) via the 0xcf8/0xcfc I/O ports.

Per sec 4.1.1 of [2], we should be using ECAM (the memory-mapped
enhanced configuration mechanism, i.e., MMCONFIG) to access extended
config space, and the BIOS should supply an MCFG table.

So why do we need to enable I/O access to ECS on AMD chips at all?  Is
this a workaround for a broken BIOS that doesn't supply an MCFG table?

>From reading the path below, I think raw_pci_read() will use
pci_direct_conf1 for (domain 0 [cfg 0-255]).  For everything else, it
will use (a) pci_mmcfg if there's a valid MCFG or (b) pci_direct_conf1
if there's no MCFG and this is an AMD >= fam10h CPU, i.e.,
PCI_HAS_IO_ECS is set.

    pci_arch_init
      type = pci_direct_probe
      pci_mmcfg_early_init
        __pci_mmcfg_init
          pci_mmcfg_arch_init
            raw_pci_ext_ops = &pci_mmcfg
      pci_direct_init
        if (type == 1)
          raw_pci_ops = &pci_direct_conf1
          if (raw_pci_ext_ops)
            return
          if (!pci_probe & PCI_HAS_IO_ECS)
            return
          raw_pci_ext_ops = &pci_direct_conf1

I think we should try to get rid of amd_bus.c, e.g., only run
amd_postcore_init() for BIOS dates < 2015.  It looks like a crutch
that is perpetuating buggy BIOSes and costing us maintenance effort.
We don't need anything similar for Intel CPUs, and I don't see a
compelling reason why we need it for AMD.

Bjorn

[1] BIOS and Kernel Developer's Guide for AMD Family 15h Models
00h-0Fh Processors Rev 3.14 (document number 42301)
[2] PCI Firmware Specification, Rev 3.0, June 20, 2005
