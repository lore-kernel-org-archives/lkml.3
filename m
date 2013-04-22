Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab3DVVdJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:33:09 -0400
Received: from mail.skyhub.de ([78.46.96.112]:50734 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752969Ab3DVVdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:33:07 -0400
Date: Mon, 22 Apr 2013 23:33:03 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: Takashi Iwai <tiwai@suse.de>, x86-ml <x86@kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: irq 16: nobody cared
Message-ID: <20130422213303.GB4415@pd.tnic>
References: <20130420185330.GA4654@pd.tnic>
 <20130420235206.GA3509@linux.vnet.ibm.com>
 <20130421103403.GA4594@pd.tnic>
 <20130421163002.GB3509@linux.vnet.ibm.com>
 <s5hfvyj55ke.wl%tiwai@suse.de>
 <20130422091310.GA4637@pd.tnic>
 <s5hzjwq53ec.wl%tiwai@suse.de>
 <alpine.LFD.2.02.1304221432570.21884@ionos>
 <20130422142356.GA4658@pd.tnic>
 <20130422144402.GK3509@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130422144402.GK3509@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22, 2013 at 07:44:02AM -0700, Paul E. McKenney wrote:
> Would it make sense to try shutting off the hardware, waiting (say)
> 100 milliseconds, then diabling the irq?  (Hey, had to ask!)

Ok, after a whole day of debugging, here's what tglx and I found out
(Thomas, please correct me if I've misinterpreted something):

When we suspend, we do the following things:

* suspend/freeze devices
* build hibernation image
* resume/thaw devices
* write out image to swap
* enter S5

Below's how it looks like in dmesg (the azx_resume is debugging output
to show us when we resume the audio crap).

Now, when we resume the devices to write out the image, the hda_intel
thing gets an interrupt on irq line 16.

What's puzzling is that

1) HDA's INTSTS status register says no IRQ occurred
2) HDA's PCI status register says no IRQ is active
3) however, (IO)APIC says an IRQ is pending

The azx_interrupt() IRQ handler looks at the INTSTS and since there's no
status bit set, it returns IRQ_NONE.

After 99900 retries, the spurious IRQ detection triggers and we disable
IRQ 16.

Now, the RCU expedited grace periods patch only brown-paper-bags this
issue because the IRQ is still pending but we don't wait a couple of
seconds before powering off the machine to actually trigger the spurious
IRQ detection.

However, paulmck wants to take this patch anyway and for an unrelated
reason or simply because he's greedy that way :-)

Further action is to try to find out why this IRQ is still there when
the device gets enabled.

That should be all for now.

[ 1442.248431] PM: Marking nosave pages: [mem 0xba9ba000-0xbca4dfff]
[ 1442.256534] PM: Marking nosave pages: [mem 0xbca4f000-0xbcc54fff]
[ 1442.256542] PM: Marking nosave pages: [mem 0xbd083000-0xbd7f3fff]
[ 1442.256571] PM: Marking nosave pages: [mem 0xbd800000-0x100000fff]
[ 1442.257147] PM: Basic memory bitmaps created
[ 1442.257147] PM: Syncing filesystems ... done.
[ 1442.294602] Freezing user space processes ... (elapsed 0.01 seconds) done.
[ 1442.315451] PM: Preallocating image memory... done (allocated 168444 pages)
[ 1442.826308] PM: Allocated 673776 kbytes in 0.50 seconds (1347.55 MB/s)
[ 1442.833410] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
[ 1443.579467] [drm] PCIE gen 2 link speeds already enabled
[ 1443.579583] serial 00:09: activated
[ 1443.582498] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[ 1443.582557] radeon 0000:01:00.0: WB enabled
[ 1443.582559] radeon 0000:01:00.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff880428eefc00
[ 1443.582561] radeon 0000:01:00.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff880428eefc0c
[ 1443.588070] azx_resume: irq: -1, after PCI_D0
162] azx_resume: irq: -1, after restore_state
[ 1443.588256] azx_resume: irq: -1, after set_master
[ 1443.588258] azx_resume: irq: -1, msi
[ 1443.588528] azx_resume: irq: 90, after acquire_irq
[ 1443.588530] azx_resume: irq: 90, after init_pci
[ 1443.588983] azx_resume: irq: -1, after PCI_D0
[ 1443.589059] azx_resume: irq: -1, after restore_state
[ 1443.589189] azx_resume: irq: -1, after set_master
[ 1443.589218] azx_resume: irq: 16, after acquire_irq
[ 1443.589227] azx_resume: irq: 16, after init_pci
[ 1443.590827] azx_resume: irq: 90, after init_chip
[ 1443.590982] azx_resume: irq: 90, after hda_resume
[ 1443.590986] azx_resume: irq: 90, exit
[ 1443.593278] azx_resume: irq: 16, after init_chip
[ 1443.613761] [drm] ring test on 0 succeeded in 0 usecs
[ 1443.613819] [drm] ring test on 3 succeeded in 1 usecs
[ 1443.613837] [drm] ib test on ring 0 succeeded in 0 usecs
[ 1443.613852] [drm] ib test on ring 3 succeeded in 1 usecs
[ 1443.763299] r8169 0000:02:00.0 eth0: link down
[ 1443.764763] azx_resume: irq: 16, after hda_resume
[ 1443.764765] azx_resume: irq: 16, exit
[ 1443.882924] ata7: SATA link down (SStatus 0 SControl 300)
[ 1443.888956] ata5: SATA link down (SStatus 0 SControl 300)
[ 1443.897831] ata6: SATA link down (SStatus 0 SControl 300)
[ 1444.037878] ata3: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1444.046092] ata2: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
[ 1444.054510] ata4: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[ 1444.064691] ata4.00: configured for UDMA/133
[ 1444.071386] ata3.00: configured for UDMA/133
[ 1444.077579] ata2.00: configured for UDMA/133
[ 1444.430017] PM: thaw of devices complete after 852.888 msecs
[ 1444.439553] PM: writing image.
[ 1444.446508] PM: Using 3 thread(s) for compression.
[ 1444.446508] PM: Compressing and saving image data (171542 pages)...
[ 1444.461242] PM: Image saving progress:   0%
[ 1444.712573] PM: Image saving progress:  10%
[ 1444.911138] PM: Image saving progress:  20%
[ 1445.235778] PM: Image saving progress:  30%
[ 1445.268331] r8169 0000:02:00.0 eth0: link up
[ 1445.713293] PM: Image saving progress:  40%
[ 1446.067955] PM: Image saving progress:  50%
[ 1446.269045] PM: Image saving progress:  60%
[ 1447.010418] PM: Image saving progress:  90%
[ 1447.249890] PM: Image saving progress: 100%
[ 1447.275236] PM: Image saving done.
[ 1447.279229] PM: Wrote 686168 kbytes in 2.81 seconds (244.18 MB/s)
[ 1447.286362] PM: S|
[ 1447.640958] kvm: exiting hardware virtualization
[ 1447.648264] sd 3:0:0:0: [sdc] Synchronizing SCSI cache
[ 1447.654329] sd 3:0:0:0: [sdc] Stopping disk
[ 1448.184498] sd 2:0:0:0: [sdb] Synchronizing SCSI cache
[ 1448.191528] sd 2:0:0:0: [sdb] Stopping disk
[ 1449.065339] sd 1:0:0:0: [sda] Synchronizing SCSI cache
[ 1449.072924] sd 1:0:0:0: [sda] Stopping disk
[ 1449.112649] pcieport 0000:00:04.0: System wakeup enabled by ACPI
[ 1449.134864] ACPI: Preparing to enter system sleep state S5
[ 1449.141054] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[ 1451.616441] Call Trace:
[ 1451.620521]  <IRQ>  [<ffffffff810b729d>] __report_bad_irq+0x3d/0xe0
[ 1451.628446]  [<ffffffff810b7736>] note_interrupt+0x1a6/0x1f0
[ 1451.635730]  [<ffffffff8134ddc6>] ? add_interrupt_randomness+0x26/0x180
[ 1451.644003]  [<ffffffff810b4f2b>] handle_irq_event_percpu+0xcb/0x3a0
[ 1451.652058]  [<ffffffff810b5248>] handle_irq_event+0x48/0x70
[ 1451.659437]  [<ffffffff8159ba7d>] ? _raw_spin_lock+0x6d/0x80
[ 1451.666764]  [<ffffffff810b826e>] ? handle_fasteoi_irq+0x1e/0xf0
[ 1451.674457]  [<ffffffff810b82aa>] handle_fasteoi_irq+0x5a/0xf0
[ 1451.681959]  [<ffffffff810042a2>] handle_irq+0x22/0x40
[ 1451.688791]  [<ffffffff8159f04a>] do_IRQ+0x5a/0xd0
[ 1451.695296]  [<ffffffff8159cbaf>] common_interrupt+0x6f/0x6f
[ 1451.702672]  <EOI>  [<ffffffff8107a775>] ? sched_clock_cpu+0xc5/0x120
[ 1451.710934]  [<ffffffff8144f703>] ? cpuidle_wrap_enter+0x53/0x90
[ 1451.718745]  [<ffffffff8144f6ff>] ? cpuidle_wrap_enter+0x4f/0x90
[ 1451.726568]  [<ffffffff8144ebc0>] cpuidle_enter_tk+0x10/0x20
[ 1451.734033]  [<ffffffff8144f265>] cpuidle_idle_call+0xb5/0x390
[ 1451.741673]  [<ffffffff8100c12e>] arch_cpu_idle+0xe/0x30
[ 1451.748793]  [<ffffffff8108d3ee>] cpu_startup_entry+0x7e/0x3d0
[ 1451.756433]  [<ffffffff8158d364>] start_secondary+0x1b7/0x1bb
[ 1451.763984] handlers:
[ 1451.768074] [<ffffffff814b6ce0>] azx_interrupt
[ 1451.774386] Disabling IRQ #16
[ 1464.581166] acpi_power_off called

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
