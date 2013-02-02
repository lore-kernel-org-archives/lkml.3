Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757702Ab3BBOYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 09:24:33 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:53031 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab3BBOYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 09:24:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 2 Feb 2013 15:24:03 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Mark Einon <mark.einon@gmail.com>
Cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: [PATCH] firewire: Fix ohci free_irq() warning
Message-ID: <20130202152403.3d6b6437@stein>
In-Reply-To: <CANK3SE0SWLpnETpwVZsM2BRsH8jfOt59=fBLf8JshwRVPVOOYw@mail.gmail.com>
References: <1359410988-3740-1-git-send-email-mark.einon@gmail.com>
	<20130129000149.5fa5b0c3@stein>
	<CANK3SE0w08n1RSzqy5dV4eAymAfmnb-a+T9UfVSxw-+3fP-PVA@mail.gmail.com>
	<20130129170423.0f83cd31@stein>
	<CANK3SE0SWLpnETpwVZsM2BRsH8jfOt59=fBLf8JshwRVPVOOYw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 30 Mark Einon wrote:
> On 29 January 2013 16:04, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> > Added Cc: linux-pm.
> >
> > On Jan 29 Mark Einon wrote:
> >> On 28 January 2013 23:01, Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
> >> > On Jan 28 Mark Einon wrote:
> >> >> This patch fixes the kernel warning generated when putting an MSI MS-1727
> >> >> GT740 laptop into suspend mode. The call sequence in this case calls
> >> >> free_irq() twice, once in pci_remove() and once then in pci_suspend().
> >> >
> >> > You mean /first/ in pci_suspend() and /then/ in pci_remove() on the
> >> > already suspended devices, right?
> >>
> >> Yes, I did. The call sequence is suspend then resume. My bad.
> 
> Correction above : s/resume/remove
> 
> >>
> >> >
> >> > Because the other way around, first pci_remove(), then pci_suspend(),
> >> > surely must not appen.  And if it does, the bug is elsewhere but not in
> >> > firewire-ohci.
> >> >
> >> > On that note, is pci_suspend() -> pci_remove() actually a legal state
> >> > transition that must be handled by drivers?
> >>
> >> It's happening on the Ubuntu 12.10 distro which performs the suspend
> >> then remove sequence. I assumed that was normal.
> >
> > Maybe a parent device (PCI bridge or the likes) of the OHCI is
> > requested to be removed during suspend or is being removed during
> > resume, thereby causing a removal request to the OHCI?
> >
> > Or the suspend method of firewire-ohci exited with an error return code...
> > but then the suspend sequence would be rolled back, not the offending
> > device be removed, right?
> >
> > In any case, could you check the dmesg right before the warning which you
> > already posted --- and right after it too --- whether there is an
> > indication what else was going on?
> 
> It looks like the remove call actually happens on the wakeup sequence
> - although I've not yet found the time to investigate further.

OK.  I, as a naive driver maintainer, expect a sequence like
   [suspend request] -> suspend() -> [if ret==0, suspended state] ->
   [resume request] -> resume() -> ...
but what apparently happens is
   [suspend request] -> suspend() -> [if ret==0, suspended state] ->
   [resume request] -> remove() -> ...

If you had an ExpressCard or CardBus controller, then it could of course
happen that the PC is suspended, then the controller card physically
removed, and then a resume been requested.  Question to all:  Would the
driver's resume() method be called on the MIA device be called, or would
the driver's remove() method be called in such a case?

However, this is not what happened in your case:  According to the
hardware information which you provided below, you have a PCI Express
controller which is apparently soldered onto the mainboard, and it is not
obvious to me why the ACPI wake-up is causing this controller attempted to
be removed.

Still, I am not clear on the following two questions:

  - Why is this happening on your laptop at all?

  - Must Linux PCI kernel drivers (or any kernel device drivers supporting
    PM suspend/ remove) be prepared to handle direct state transitions from
    [suspended] to [remove]?

> The lines preceding the crash are:
> 
> Jan 30 23:22:53 msilap kernel: [ 7682.288190] ACPI: Low-level resume complete
> Jan 30 23:22:53 msilap kernel: [ 7682.288228] PM: Restoring platform NVS memory
> Jan 30 23:22:53 msilap kernel: [ 7682.288644] Enabling non-boot CPUs ...
> Jan 30 23:22:53 msilap kernel: [ 7682.288713] smpboot: Booting Node 0 Processor 1 APIC 0x2
> Jan 30 23:22:53 msilap kernel: [ 7682.301963] hpet: hpet3 irq 41 for MSI
> Jan 30 23:22:53 msilap kernel: [ 7682.301978] CPU1 is up
> Jan 30 23:22:53 msilap kernel: [ 7682.302040] smpboot: Booting Node 0 Processor 2 APIC 0x4
> Jan 30 23:22:53 msilap kernel: [ 7682.315394] hpet: hpet4 irq 42 for MSI
> Jan 30 23:22:53 msilap kernel: [ 7682.315408] CPU2 is up
> Jan 30 23:22:53 msilap kernel: [ 7682.315470] smpboot: Booting Node 0 Processor 3 APIC 0x6
> Jan 30 23:22:53 msilap kernel: [ 7682.328815] hpet: hpet5 irq 43 for MSI
> Jan 30 23:22:53 msilap kernel: [ 7682.328828] CPU3 is up
> Jan 30 23:22:53 msilap kernel: [ 7682.328882] smpboot: Booting Node 0 Processor 4 APIC 0x1
> Jan 30 23:22:53 msilap kernel: [ 7682.342256] hpet: hpet6 irq 44 for MSI
> Jan 30 23:22:53 msilap kernel: [ 7682.342269] CPU4 is up
> Jan 30 23:22:53 msilap kernel: [ 7682.342327] smpboot: Booting Node 0 Processor 5 APIC 0x3
> Jan 30 23:22:53 msilap kernel: [ 7682.355737] CPU5 is up
> Jan 30 23:22:53 msilap kernel: [ 7682.355797] smpboot: Booting Node 0 Processor 6 APIC 0x5
> Jan 30 23:22:53 msilap kernel: [ 7682.369213] CPU6 is up
> Jan 30 23:22:53 msilap kernel: [ 7682.369272] smpboot: Booting Node 0 Processor 7 APIC 0x7
> Jan 30 23:22:53 msilap kernel: [ 7682.382720] CPU7 is up
> Jan 30 23:22:53 msilap kernel: [ 7682.388801] ACPI: Waking up from system sleep state S3
> Jan 30 23:22:53 msilap kernel: [ 7682.403997] ------------[ cut here ]------------
> Jan 30 23:22:53 msilap kernel: [ 7682.404007] WARNING: at /home/mark/Source/linux/kernel/irq/manage.c:1248 __free_irq+0xa3/0x1e0()
> <snip>
> 
> then after the first crash trace:
> 
> Jan 30 23:22:53 msilap kernel: [ 7682.404181] ---[ end trace 1a4f0a37b1022aad ]---
> Jan 30 23:22:53 msilap kernel: [ 7682.404211] firewire_ohci 0000:07:00.0: removed fw-ohci device
> Jan 30 23:22:53 msilap kernel: [ 7682.404327] ------------[ cut here ]------------
> Jan 30 23:22:53 msilap kernel: [ 7682.404330] WARNING: at /home/mark/Source/linux/kernel/irq/manage.c:1248 __free_irq+0xa3/0x1e0()
> Jan 30 23:22:53 msilap kernel: [ 7682.404330] Hardware name: MS-1727
> Jan 30 23:22:53 msilap kernel: [ 7682.404331] Trying to free already-free IRQ 16
> Jan 30 23:22:53 msilap kernel: [ 7682.404363] Modules linked in: ip6table_filter ip6_tables ebtable_nat ebtables nf_conntrack_ipv4 nf_defrag_ipv4 xt_state nf_conntrack ipt_REJECT xt_CHECKSUM iptable_mangle xt_tcpudp iptable_filter bnep rfcomm ip_tables bluetooth x_tables bridge stp llc parport_pc ppdev binfmt_misc arc4 nouveau iwldvm mac80211 snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec iwlwifi coretemp kvm_intel snd_hwdep kvm
> snd_pcm ttm cfg80211 snd_seq_midi snd_rawmidi drm_kms_helper snd_seq_midi_event drm snd_seq snd_timer snd_seq_device joydev snd
> microcode i7core_edac i2c_algo_bit psmouse soundcore edac_core jmb38x_ms msi_wmi serio_raw video memstick mxm_wmi lpc_ich
> sparse_keymap mac_hid wmi snd_page_alloc acpiphp lp parport r8169 firewire_ohci(O) sdhci_pci firewire_core(O) sdhci crc_itu_t
> Jan 30 23:22:53 msilap kernel: [ 7682.404365] Pid: 5968, comm: kworker/0:2 Tainted: G        W  O 3.8.0-rc5-next-20130128+ #6
> Jan 30 23:22:53 msilap kernel: [ 7682.404366] Call Trace:
> Jan 30 23:22:53 msilap kernel: [ 7682.404369]  [<ffffffff810589af>] warn_slowpath_common+0x7f/0xc0
> Jan 30 23:22:53 msilap kernel: [ 7682.404371]  [<ffffffff81058aa6>] warn_slowpath_fmt+0x46/0x50
> Jan 30 23:22:53 msilap kernel: [ 7682.404374]  [<ffffffff81044c69>] ? default_spin_lock_flags+0x9/0x10
> Jan 30 23:22:53 msilap kernel: [ 7682.404376]  [<ffffffff810eabc3>] __free_irq+0xa3/0x1e0
> Jan 30 23:22:53 msilap kernel: [ 7682.404378]  [<ffffffff810ead54>] free_irq+0x54/0xc0
> Jan 30 23:22:53 msilap kernel: [ 7682.404384]  [<ffffffffa000968a>] sdhci_remove_host+0x6a/0x190 [sdhci]
> Jan 30 23:22:53 msilap kernel: [ 7682.404389]  [<ffffffffa002f3ff>] sdhci_pci_remove_slot+0x4f/0xc0 [sdhci_pci]
> Jan 30 23:22:53 msilap kernel: [ 7682.404394]  [<ffffffffa002fa70>] sdhci_pci_remove+0x50/0xa0 [sdhci_pci]
> Jan 30 23:22:53 msilap kernel: [ 7682.404398]  [<ffffffff8137ff26>] pci_device_remove+0x46/0xc0
> Jan 30 23:22:53 msilap kernel: [ 7682.404402]  [<ffffffff81456f3c>] __device_release_driver+0x7c/0xe0
> Jan 30 23:22:53 msilap kernel: [ 7682.404404]  [<ffffffff814571ac>] device_release_driver+0x2c/0x40
> Jan 30 23:22:53 msilap kernel: [ 7682.404406]  [<ffffffff814569b1>] bus_remove_device+0xe1/0x120
> Jan 30 23:22:53 msilap kernel: [ 7682.404409]  [<ffffffff8145403a>] device_del+0x11a/0x1b0
> Jan 30 23:22:53 msilap kernel: [ 7682.404411]  [<ffffffff81379d94>] pci_stop_bus_device+0x94/0xa0
> Jan 30 23:22:53 msilap kernel: [ 7682.404414]  [<ffffffff81379f36>] pci_stop_and_remove_bus_device+0x16/0x30
> Jan 30 23:22:53 msilap kernel: [ 7682.404419]  [<ffffffffa0028b36>] acpiphp_disable_slot+0xf6/0x1a0 [acpiphp]
> Jan 30 23:22:53 msilap kernel: [ 7682.404424]  [<ffffffffa0027716>] ? get_slot_status+0x46/0xc0 [acpiphp]
> Jan 30 23:22:53 msilap kernel: [ 7682.404428]  [<ffffffffa0028c0d>] acpiphp_check_bridge.isra.13+0x2d/0xf0 [acpiphp]
> Jan 30 23:22:53 msilap kernel: [ 7682.404433]  [<ffffffffa0029247>] _handle_hotplug_event_bridge+0x2e7/0x410 [acpiphp]
> Jan 30 23:22:53 msilap kernel: [ 7682.404436]  [<ffffffff813bdc64>] ? acpi_os_execute_deferred+0x2d/0x32
> Jan 30 23:22:53 msilap kernel: [ 7682.404439]  [<ffffffff8117df25>] ? kfree+0x105/0x140
> Jan 30 23:22:53 msilap kernel: [ 7682.404441]  [<ffffffff81077249>] process_one_work+0x159/0x4c0
> Jan 30 23:22:53 msilap kernel: [ 7682.404444]  [<ffffffff8107895e>] worker_thread+0x15e/0x4a0
> Jan 30 23:22:53 msilap kernel: [ 7682.404446]  [<ffffffff81078800>] ? manage_workers+0x2a0/0x2a0
> Jan 30 23:22:53 msilap kernel: [ 7682.404448]  [<ffffffff8107df60>] kthread+0xc0/0xd0
> Jan 30 23:22:53 msilap kernel: [ 7682.404450]  [<ffffffff8107dea0>] ? kthread_create_on_node+0x130/0x130
> Jan 30 23:22:53 msilap kernel: [ 7682.404452]  [<ffffffff816d756c>] ret_from_fork+0x7c/0xb0
> Jan 30 23:22:53 msilap kernel: [ 7682.404454]  [<ffffffff8107dea0>] ? kthread_create_on_node+0x130/0x130
> Jan 30 23:22:53 msilap kernel: [ 7682.404456] ---[ end trace 1a4f0a37b1022aae ]---

As a side note:  The sdhci driver (which is used by the sdhci-pci
driver here) is featuring the same issue as firewire-ohci does:  It is
calling free_irq() in its suspend() method, and this is in conflict with
the free_irq() in its remove() method.

> >
> > Also, what are the parent devices of the OHCI according to "lspci -tv" (or
> > what else can show PCI topology)?
> 
> I ran 'lshw' on the machine, which may be of more use. The relevant
> output is (removing parts not associated with the firewire device):
> 
> msilap
>     description: Notebook
>     product: MS-1727 (To be filled by O.E.M.)
>     vendor: MICRO-STAR INTERNATIONAL CO., LTD
>     version: REV:1.0
>     serial: FFFFFFFF
>     width: 64 bits
>     capabilities: smbios-2.6 dmi-2.6 vsyscall32
>     configuration: boot=normal chassis=notebook family=To be filled by O.E.M. sku=To be filled by O.E.M. uuid=00020003-0004-0005-0006-000700080009
>   *-core
>        description: Motherboard
>        product: MS-1727
>        vendor: MICRO-STAR INTERNATIONAL CO., LTD
>        physical id: 0
>        version: REV:1.0
>        serial: BSS-0123456789
>        slot: To be filled by O.E.M.
>      *-pci:0
>           description: Host bridge
>           product: Core Processor DMI
>           vendor: Intel Corporation
>           physical id: 100
>           bus info: pci@0000:00:00.0
>           version: 11
>           width: 32 bits
>           clock: 33MHz
>         *-pci:4
>              description: PCI bridge
>              product: 5 Series/3400 Series Chipset PCI Express Root Port 5
>              vendor: Intel Corporation
>              physical id: 1c.4
>              bus info: pci@0000:00:1c.4
>              version: 05
>              width: 32 bits
>              clock: 33MHz
>              capabilities: pci pciexpress msi pm normal_decode bus_master cap_list
>              configuration: driver=pcieport
>              resources: irq:16 ioport:9000(size=4096) memory:d4600000-d59fffff ioport:d9d00000(size=2097152)

So, is this Intel PCIe Root Complex acting up and losing contact to other
endpoints at resume, or is the JMicron endpoint pretending to be
nonexistent at resume, or what else is happening?

>            *-firewire
>                 description: FireWire (IEEE 1394)
>                 product: IEEE 1394 Host Controller
>                 vendor: JMicron Technology Corp.
>                 physical id: 0
>                 bus info: pci@0000:07:00.0
>                 version: 00
>                 width: 32 bits
>                 clock: 33MHz
>                 capabilities: pm pciexpress msi ohci bus_master cap_list
>                 configuration: driver=firewire_ohci latency=0
>                 resources: irq:16 memory:d4607000-d46077ff memory:d4606000-d460607f memory:d4605000-d460507f memory:d4604000-d460407f
>            *-generic:0
>                 description: System peripheral
>                 product: SD/MMC Host Controller
>                 vendor: JMicron Technology Corp.
>                 physical id: 0.1
>                 bus info: pci@0000:07:00.1
>                 version: 00
>                 width: 32 bits
>                 clock: 33MHz
>                 capabilities: pm pciexpress msi bus_master cap_list
>                 configuration: driver=sdhci-pci latency=0
>                 resources: irq:16 memory:d4603000-d46030ff
>            *-generic:1 UNCLAIMED
>                 description: SD Host controller
>                 product: Standard SD Host Controller
>                 vendor: JMicron Technology Corp.
>                 physical id: 0.2
>                 bus info: pci@0000:07:00.2
>                 version: 00
>                 width: 32 bits
>                 clock: 33MHz
>                 capabilities: pm pciexpress msi cap_list
>                 configuration: latency=0
>                 resources: memory:d4602000-d46020ff
>            *-generic:2
>                 description: System peripheral
>                 product: MS Host Controller
>                 vendor: JMicron Technology Corp.
>                 physical id: 0.3
>                 bus info: pci@0000:07:00.3
>                 version: 00
>                 width: 32 bits
>                 clock: 33MHz
>                 capabilities: pm pciexpress msi bus_master cap_list
>                 configuration: driver=jmb38x_ms latency=0
>                 resources: irq:16 memory:d4601000-d46010ff
>            *-generic:3 UNCLAIMED
>                 description: System peripheral
>                 product: xD Host Controller
>                 vendor: JMicron Technology Corp.
>                 physical id: 0.4
>                 bus info: pci@0000:07:00.4
>                 version: 00
>                 width: 32 bits
>                 clock: 33MHz
>                 capabilities: pm pciexpress msi bus_master cap_list
>                 configuration: latency=0
>                 resources: memory:d4600000-d46000ff

This seems to be a JMicron JMB388, which is a PCIe combination device with
OHCI-1394 1.1 link and 1394A:2000 PHY, and a 4-in-1 memory card reader
for MMC/SD...SDXC/MS/xD cards. 
-- 
Stefan Richter
-=====-===-= --=- ---=-
http://arcgraph.de/sr/
