Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751500AbaBZJ3O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:29:14 -0500
Received: from mail.skyhub.de ([78.46.96.112]:38293 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751192AbaBZJ3K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:29:10 -0500
Date: Wed, 26 Feb 2014 10:29:03 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140226092903.GA22639@pd.tnic>
References: <20140224162400.GE16457@pd.tnic>
 <20140224201943.GA4397@pd.tnic>
 <530CBB3D.3080604@zytor.com>
 <CABPqkBR4bR9U1bhTtA02gDVR0aZ7iXBfg87jPLHfhrZVeFF8_g@mail.gmail.com>
 <20140225163010.GG24636@pd.tnic>
 <CABPqkBT3O2VwV48OC9TgCLKrEnC_qokxU8_odMZQ+d+55wdKgA@mail.gmail.com>
 <20140225173946.GH24636@pd.tnic>
 <CABPqkBTk+KA2kd7Qge2SkNXebDoh9Ntc2L_E3p2k42sbMxoYXw@mail.gmail.com>
 <20140225221027.GB21559@pd.tnic>
 <CABPqkBSH-cHDZ16y0WMyJ2e-kmJ6G_8DkJXPDa7pc4Hp63xG4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBSH-cHDZ16y0WMyJ2e-kmJ6G_8DkJXPDa7pc4Hp63xG4g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 26, 2014 at 07:56:58AM +0100, Stephane Eranian wrote:
> > Also IVB, model 58?
> >
> Yes.

Right, so it must be chipset-specific.

> > Dunno. What do you mean by "pm callbacks" exactly? I don't know that
> > code so I have to ask.
> >
> power management callbacks.

Ok, just as I thought. But why would they be relevant if this happens
very early during boot?

> > #define PCI_DEVICE_ID_INTEL_IVB_IMC     0x0154
> Yes. Needs to point to the DRAM controller.

It seems I have it :-)

$ lspci -xxx -s 00.0
00:00.0 Host bridge: Intel Corporation 3rd Gen Core processor DRAM Controller (rev 09)
00: 86 80 54 01 06 00 90 20 09 00 00 06 00 00 00 00
	  ^^^^^

10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 aa 17 fa 21
30: 00 00 00 00 e0 00 00 00 00 00 00 00 00 00 00 00
40: 01 90 d1 fe 00 00 00 00 01 00 d1 fe 00 00 00 00
50: 11 02 00 00 11 00 00 00 07 00 90 df 01 00 00 db
60: 05 00 00 f8 00 00 00 00 01 80 d1 fe 00 00 00 00
70: 00 00 00 fe 01 00 00 00 00 0c 00 fe 7f 00 00 00
80: 10 11 11 11 11 11 11 00 1a 00 00 00 00 00 00 00
90: 01 00 00 fe 01 00 00 00 01 00 50 1e 02 00 00 00
a0: 01 00 00 00 02 00 00 00 01 00 60 1e 02 00 00 00
b0: 01 00 a0 db 01 00 80 db 01 00 00 db 01 00 a0 df
c0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
d0: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
e0: 09 00 0c 01 9b 61 00 e2 d0 00 e8 76 00 00 00 00
f0: 00 00 00 01 00 00 00 00 c8 0f 09 00 00 00 00 00

Anyway, here's some more debugging output and some more staring:

So we're correctly getting 0x154 and then snb_uncore_imc_init_box()
tries to ioremap 0xfed10000 but this fails the resource map check with:

[    0.485356] resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01

and the pnp 00:01 device already partially occupies that range (from
/proc/iomem):

  fed10000-fed13fff : pnp 00:01

Oh, and snb_uncore_imc_init_box() gets that address from
SNB_UNCORE_PCI_IMC_BAR_OFFSET and SNB_UNCORE_PCI_IMC_BAR_OFFSET+4 and
they start at offset 0x48 in the PCI config space above, i.e.

40: 01 90 d1 fe 00 00 00 00 01 00 d1 fe 00 00 00 00
			    ^^^^^^^^^^^^^^^^^^^^^^^

which is 0x000000fed10001 (the 0x1 bit disappears after addr &= ~(PAGE_SIZE - 1);)

So I'm guessing it is time to talk to platform guys and ask them why
they're putting SNB_UNCORE_PCI_IMC_BAR_OFFSET{,+4} in an overlapping
range with pnp 00:01.

[    0.484023] PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
[    0.484108] software IO TLB [mem 0xcac30000-0xcec30000] (64MB) mapped at [ffff8800cac30000-ffff8800cec2ffff]
[    0.484971] DBG: will get device: 0x8086:154
[    0.485054] DBG: Got device, bus: 0x0
[    0.485254] DBG: ioremapping addr: 0xfed10000
[    0.485356] resource map sanity check conflict: 0xfed10000 0xfed15fff 0xfed10000 0xfed13fff pnp 00:01
[    0.485460] ------------[ cut here ]------------
[    0.485544] WARNING: CPU: 2 PID: 1 at arch/x86/mm/ioremap.c:171 __ioremap_caller+0x372/0x380()
[    0.485643] Info: mapping multiple BARs. Your kernel is fine.
[    0.485709] Modules linked in:
[    0.485935] CPU: 2 PID: 1 Comm: swapper/0 Not tainted 3.14.0-rc4+ #6
[    0.486019] Hardware name: LENOVO 2320CTO/2320CTO, BIOS G2ET86WW (2.06 ) 11/13/2012
[    0.486117]  00000000000000ab ffff880213d01ad8 ffffffff81611339 0000000000000006
[    0.486411]  ffff880213d01b28 ffff880213d01b18 ffffffff8104e9cc ffff880213d01b08
[    0.488308]  ffffc90000c58000 00000000fed10000 00000000fed10000 0000000000006000
[    0.488595] Call Trace:
[    0.488671]  [<ffffffff81611339>] dump_stack+0x4f/0x7c
[    0.488754]  [<ffffffff8104e9cc>] warn_slowpath_common+0x8c/0xc0
[    0.488877]  [<ffffffff8104eab6>] warn_slowpath_fmt+0x46/0x50
[    0.488966]  [<ffffffff8103f1f2>] __ioremap_caller+0x372/0x380
[    0.489052]  [<ffffffff810211b6>] ? snb_uncore_imc_init_box+0x76/0xa0
[    0.489137]  [<ffffffff8103f257>] ioremap_nocache+0x17/0x20
[    0.489221]  [<ffffffff810211b6>] snb_uncore_imc_init_box+0x76/0xa0
[    0.489307]  [<ffffffff81022935>] uncore_pci_probe+0xe5/0x1e0
[    0.489391]  [<ffffffff812d488e>] local_pci_probe+0x4e/0xa0
[    0.489474]  [<ffffffff81418a69>] ? get_device+0x19/0x20
[    0.489558]  [<ffffffff812d5ce1>] pci_device_probe+0xe1/0x130
[    0.489642]  [<ffffffff8141d3db>] driver_probe_device+0x7b/0x240
[    0.489726]  [<ffffffff8141d64b>] __driver_attach+0xab/0xb0
[    0.489834]  [<ffffffff8141d5a0>] ? driver_probe_device+0x240/0x240
[    0.489920]  [<ffffffff8141b72e>] bus_for_each_dev+0x5e/0x90
[    0.490003]  [<ffffffff8141ceee>] driver_attach+0x1e/0x20
[    0.490086]  [<ffffffff8141ca67>] bus_add_driver+0x117/0x230
[    0.490170]  [<ffffffff8141dd44>] driver_register+0x64/0xf0
[    0.490251]  [<ffffffff812d4c24>] __pci_register_driver+0x64/0x70
[    0.490337]  [<ffffffff81d0319b>] ? uncore_types_init+0x19c/0x19c
[    0.490421]  [<ffffffff81d03331>] intel_uncore_init+0x196/0x462
[    0.490504]  [<ffffffff81d0319b>] ? uncore_types_init+0x19c/0x19c
[    0.490591]  [<ffffffff8100029e>] do_one_initcall+0x4e/0x170
[    0.490676]  [<ffffffff81071100>] ? parse_args+0x50/0x360
[    0.490762]  [<ffffffff81cfbfb8>] kernel_init_freeable+0x106/0x19a
[    0.490863]  [<ffffffff81cfb83b>] ? do_early_param+0x86/0x86
[    0.490948]  [<ffffffff81607f00>] ? rest_init+0xd0/0xd0
[    0.491032]  [<ffffffff81607f0e>] kernel_init+0xe/0xf0
[    0.491116]  [<ffffffff81621fac>] ret_from_fork+0x7c/0xb0
[    0.491199]  [<ffffffff81607f00>] ? rest_init+0xd0/0xd0
[    0.491289] ---[ end trace b31a7f760e34b24a ]---
[    0.491547] RAPL PMU detected, hw unit 2^-16 Joules, API unit is 2^-32 Joules, 3 fixed counters 163840 ms ovfl timer
[    0.493962] futex hash table entries: 1024 (order: 5, 131072 bytes)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
