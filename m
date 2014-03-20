Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbaCTNgH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:36:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:40273 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757244AbaCTNgE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:36:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,694,1389772800"; 
   d="scan'208";a="476389608"
Message-ID: <1395322553.2721.7.camel@rzhang1-mobl4>
Subject: RE: Info: mapping multiple BARs. Your kernel is fine.
From: Zhang Rui <rui.zhang@intel.com>
To: Stephane Eranian <eranian@google.com>
Cc: "Lu, Aaron" <aaron.lu@intel.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Borislav Petkov <bp@alien8.de>, lkml <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Linux PCI <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Yinghai Lu <yinghai@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Yan, Zheng Z" <zheng.z.yan@intel.com>
Date: Thu, 20 Mar 2014 21:35:53 +0800
In-Reply-To: <744357E9AAD1214791ACBA4B0B9092630121F3B7@SHSMSX101.ccr.corp.intel.com>
References: <20140224162400.GE16457@pd.tnic>
	 <4205942.Tp8ltEsv6e@vostro.rjw.lan>	<532A514C.5010106@intel.com>
	 <744357E9AAD1214791ACBA4B0B9092630121F201@SHSMSX101.ccr.corp.intel.com>
	 <CABPqkBTyti0owCA_cWf9GcvYnOSvbMQpRC29rgpicjW1iYBjYQ@mail.gmail.com>
	 <744357E9AAD1214791ACBA4B0B9092630121F3B7@SHSMSX101.ccr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-20 at 07:53 +0000, Zhang, Rui wrote:
> 
> > -----Original Message-----
> > From: Stephane Eranian [mailto:eranian@google.com]
> > Sent: Thursday, March 20, 2014 11:35 AM
> > To: Zhang, Rui
> > Cc: Lu, Aaron; Rafael J. Wysocki; Borislav Petkov; lkml; x86@kernel.org;
> > Bjorn Helgaas; Linux PCI; ACPI Devel Maling List; Yinghai Lu; H. Peter
> > Anvin; Yan, Zheng Z
> > Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
> > Importance: High
> > 
> > On Thu, Mar 20, 2014 at 4:03 AM, Zhang, Rui <rui.zhang@intel.com> wrote:
> > >
> > >
> > >> -----Original Message-----
> > >> From: Lu, Aaron
> > >> Sent: Thursday, March 20, 2014 10:24 AM
> > >> To: Rafael J. Wysocki; Borislav Petkov
> > >> Cc: lkml; x86@kernel.org; Bjorn Helgaas; Linux PCI; ACPI Devel
> > Maling
> > >> List; Zhang, Rui; Yinghai Lu; H. Peter Anvin; Stephane Eranian
> > >> Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
> > >> Importance: High
> > >>
> > >> On 03/15/2014 10:15 PM, Rafael J. Wysocki wrote:
> > >> > [CC list rearranged]
> > >> >
> > >> > On Monday, February 24, 2014 05:24:00 PM Borislav Petkov wrote:
> > >> >> This started happening this morning after booting -rc4+tip, let's
> > >> add
> > >> >> *everybody* to CC :-)
> > >> >>
> > >> >> We have intel_uncore_init, snb_uncore_imc_init_box,
> > >> >> uncore_pci_probe and other goodies on the stack.
> > >> >
> > >> > I've just gone throught this.
> > >> >
> > >> > So the problem is that we have the PNP "system" driver whose only
> > >> > purpose seems to be to reserve system resources so that the PCI
> > >> > layer doesn't assign them to new devices on hotplug (disclaimer: I
> > >> > didn't invent it, I only read the code and comments in there).
> > >>
> > >> And to PCI devices which have uninitialized BARs.
> > >>
> > >> >
> > >> > It does that for ACPI device objects having the "PNP0C02" and
> > >> "PNP0C01" IDs.
> > >> >
> > >> > Apparently, snb_uncore_imc_init_box() steps on a range already
> > >> > reserved by that driver on your box.  And this doesn't seem to be
> > a
> > >> > coincidence, because the ACPI device object in question probably
> > >> > *does* correspond to the memory controller that the uncore driver
> > >> attempts to use.
> > >> >
> > >> > I'm not sure how to address that right now to be honest.  Arguably,
> > >> > the PNP "system" driver should be replaced with something saner,
> > >> > but still the resources it claims need to be kept out of reach of
> > >> > the PCI's resource allocation code.
> > >>
> > >> The quirk_system_pci_resources is meant to disable PNP devices'
> > >> resource if they collide with any known PCI device's BAR. I'm not
> > >> sure why it doesn't work here, perhaps the uncore PCI device doesn't
> > >> have a BAR that falls in the PNP device's resource window?
> > >>
> > > I've talked with Yan Zheng, and I was told that this resource
> > "0xfed10000 - 0xfed15fff"
> > > is got from PCI device register directly, which is not in its BAR
> > range.
> > > Thus IMO, it is impossible for PNP layer to be aware of this resource.
> > >
> > That is not what the perf_event code does. Nothing is hardcoded except
> > the IMC PCI device ids. The BAR offset is hardcoded that's all. The
> > 0xfed10000 is discovered.
> > 
> The resource length is also hardcoded to 0x6000, right?
> This is probably a problem, because
> only if the resource length read from PCI config space is larger than 0x4000,
> drivers/pnp/quirks.c will detect the conflict and disable the PNP0C02
> resource 0xfed10000 - 0xfed13fff, and the PCI device can request this
> resource successfully.
> In order to check this, can you please attach the dmesg output after boot?
> 
sorry, one correction here, I should say,
if the resource length read from PCI config space is smaller than
0x4000, the problem still exists because drivers/pnp/quirks.c do not
think this is a conflict.
But if the resource length read from PCI config space is larger than
0x4000, drivers/pnp/quirks.c can detect this conflict and prevent
resource 0xfed10000 - 0xfed13fff from being reserved.

thanks,
rui

> Thanks,
> rui
> 
> > > BTW, about drivers/pnp/system.c, if its ONLY purpose is to prevent
> > > those resources from being allocated to uninitialized PCI devices,
> > > then IMO, the best way to do this is make PCI bus handle those
> > > PNP0C01/PNP0C02 resources directly, probably via a platform callback,
> > > say, 1. make drivers/pnp/system.c a no-op for PNPACPI, by checking
> > pnp_dev->protocol.
> > > 2. introduce acpi_check_reserved_resource() to parsing
> > PNP0C01/PNP0C02 resources.
> > > 3. in PCI bus, invoke acpi_check_reserved_resource() when assigning
> > >    resources to PCI devices.
> > >
> > > Thanks,
> > > rui
> > >
> > >> Thanks,
> > >> Aaron
> > >>
> > >> >
> > >> >> ...
> > >> >> [    0.488998] software IO TLB [mem 0xcac30000-0xcec30000] (64MB)
> > >> mapped at [ffff8800cac30000-ffff8800cec2ffff]
> > >> >> [    0.489975] resource map sanity check conflict: 0xfed10000
> > >> 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01
> > >> >> [    0.490079] ------------[ cut here ]------------
> > >> >> [    0.490204] WARNING: CPU: 2 PID: 1 at
> > arch/x86/mm/ioremap.c:171
> > >> __ioremap_caller+0x372/0x380()
> > >> >> [    0.490306] Info: mapping multiple BARs. Your kernel is fine.
> > >> >> [    0.490371] Modules linked in:
> > >> >> [    0.490558] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.14.0-
> > rc4+
> > >> #1
> > >> >> [    0.490642] Hardware name: LENOVO 2320CTO/2320CTO, BIOS
> > G2ET86WW
> > >> (2.06 ) 11/13/2012
> > >> >> [    0.490742]  00000000000000ab ffff880213d01ad8
> > ffffffff816112e3
> > >> 0000000000000006
> > >> >> [    0.491032]  ffff880213d01b28 ffff880213d01b18
> > ffffffff8104e9bc
> > >> ffff880213d01b08
> > >> >> [    0.491343]  ffffc90000c58000 00000000fed10000
> > 00000000fed10000
> > >> 0000000000006000
> > >> >> [    0.491631] Call Trace:
> > >> >> [    0.493337]  [<ffffffff816112e3>] dump_stack+0x4f/0x7c
> > >> >> [    0.493420]  [<ffffffff8104e9bc>]
> > warn_slowpath_common+0x8c/0xc0
> > >> >> [    0.493503]  [<ffffffff8104eaa6>] warn_slowpath_fmt+0x46/0x50
> > >> >> [    0.493588]  [<ffffffff8103f1e2>] __ioremap_caller+0x372/0x380
> > >> >> [    0.493674]  [<ffffffff810211a2>] ?
> > >> snb_uncore_imc_init_box+0x62/0x90
> > >> >> [    0.493761]  [<ffffffff8103f247>] ioremap_nocache+0x17/0x20
> > >> >> [    0.493846]  [<ffffffff810211a2>]
> > >> snb_uncore_imc_init_box+0x62/0x90
> > >> >> [    0.493933]  [<ffffffff81022925>] uncore_pci_probe+0xe5/0x1e0
> > >> >> [    0.494020]  [<ffffffff812d487e>] local_pci_probe+0x4e/0xa0
> > >> >> [    0.494104]  [<ffffffff81418a59>] ? get_device+0x19/0x20
> > >> >> [    0.494213]  [<ffffffff812d5cd1>] pci_device_probe+0xe1/0x130
> > >> >> [    0.494300]  [<ffffffff8141d3cb>]
> > driver_probe_device+0x7b/0x240
> > >> >> [    0.494385]  [<ffffffff8141d63b>] __driver_attach+0xab/0xb0
> > >> >> [    0.494469]  [<ffffffff8141d590>] ?
> > >> driver_probe_device+0x240/0x240
> > >> >> [    0.494551]  [<ffffffff8141b71e>] bus_for_each_dev+0x5e/0x90
> > >> >> [    0.494634]  [<ffffffff8141cede>] driver_attach+0x1e/0x20
> > >> >> [    0.494718]  [<ffffffff8141ca57>] bus_add_driver+0x117/0x230
> > >> >> [    0.494802]  [<ffffffff8141dd34>] driver_register+0x64/0xf0
> > >> >> [    0.494884]  [<ffffffff812d4c14>]
> > __pci_register_driver+0x64/0x70
> > >> >> [    0.494972]  [<ffffffff81d0319b>] ?
> > uncore_types_init+0x19c/0x19c
> > >> >> [    0.495056]  [<ffffffff81d03312>]
> > intel_uncore_init+0x177/0x41c
> > >> >> [    0.495155]  [<ffffffff81d0319b>] ?
> > uncore_types_init+0x19c/0x19c
> > >> >> [    0.495242]  [<ffffffff8100029e>] do_one_initcall+0x4e/0x170
> > >> >> [    0.495326]  [<ffffffff81071100>] ? parse_args+0x60/0x360
> > >> >> [    0.495411]  [<ffffffff81cfbfb8>]
> > >> kernel_init_freeable+0x106/0x19a
> > >> >> [    0.495497]  [<ffffffff81cfb83b>] ? do_early_param+0x86/0x86
> > >> >> [    0.495582]  [<ffffffff81607ef0>] ? rest_init+0xd0/0xd0
> > >> >> [    0.495666]  [<ffffffff81607efe>] kernel_init+0xe/0xf0
> > >> >> [    0.495749]  [<ffffffff81621f6c>] ret_from_fork+0x7c/0xb0
> > >> >> [    0.495831]  [<ffffffff81607ef0>] ? rest_init+0xd0/0xd0
> > >> >> [    0.495921] ---[ end trace 428f365c054d9a01 ]---
> > >> >> [    0.496196] RAPL PMU detected, hw unit 2^-16 Joules, API unit
> > is
> > >> 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
> > >> >> [    0.498598] futex hash table entries: 1024 (order: 5, 131072
> > >> bytes)
> > >> >> [    0.498833] audit: initializing netlink subsys (disabled)
> > >> >> [    0.499024] audit: type=2000 audit(1393259866.477:1):
> > initialized
> > >> >> ...
> > >> >>
> > >> >>
> > >> >
> > >
> N�����r��y���b�X��ǧv�^�)޺{.n�+����{�i�b�{ay�ʇڙ�,j��f���h���z��w������j:+v���w�j�m��������zZ+�����ݢj"��!�i


