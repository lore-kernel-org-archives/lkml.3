Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769AbaEFLll (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 07:41:41 -0400
Received: from mga03.intel.com ([143.182.124.21]:38597 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750736AbaEFLlg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 07:41:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,996,1389772800"; 
   d="scan'208";a="428198235"
Date: Tue, 6 May 2014 14:41:26 +0300
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Julius Werner <jwerner@chromium.org>
Cc: Mathias Nyman <mathias.nyman@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [regression 3.15-rc3] Resume from s4 broken by
 1f81b6d22a5980955b01e08cf27fb745dc9b686f
Message-ID: <20140506114126.GB18465@intel.com>
References: <20140505180530.GA18465@intel.com>
 <CAODwPW_57G+Lebe2Xarem9P-L6ePtAaZfy5kpNVEtgkWbc0FWw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAODwPW_57G+Lebe2Xarem9P-L6ePtAaZfy5kpNVEtgkWbc0FWw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 05, 2014 at 12:32:22PM -0700, Julius Werner wrote:
> Hmmm... very odd. I unfortunately don't have a machine that can easily
> do S4 at hand, but I did test this on an IVB with XHCI_RESET_ON_RESUME
> in S3 (essentially the same code path), and I didn't run into any
> problems.
> 
> How exactly does your machine fail on resume? Is it a kernel crash or
> just a hang? Can you try getting some debug output (by setting 'echo N
> > /sys/module/printk/parameters/console_suspend' and trying to catch
> the crash on the screen or a serial line, or maybe through pstore)? I
> really don't see much that could go wrong with this patch, so without
> more info it will be hard to understand your problem.
> 
> Also, I noticed that you have two HID devices plugged in during
> suspend. Does it make a difference if you have different devices (e.g.
> a mass storage stick) or none at all?

Looks like it doesn't like it when there's anything plugged into the
"SS" ports. I tried with just a HID keyboard or with just a hub. In
both cases it fails to resume. If I have nothing connected to the "SS"
ports then it resumes just fine.

I managed to catch something with ramoops. Looks like it's hitting
POISON_FREE when trying to delete some list entry.

Oops#1 Part1
<4>[  106.321876]  [<ffffffff8106bb10>] ? kthread_create_on_node+0x210/0x210
<4>[  106.321878]  [<ffffffff8151522c>] ret_from_fork+0x7c/0xb0
<4>[  106.321879]  [<ffffffff8106bb10>] ? kthread_create_on_node+0x210/0x210
<4>[  106.321879] ---[ end trace f5b8b9411bd5e24b ]---
<6>[  106.719552] PM: freeze of devices complete after 513.577 msecs
<6>[  106.720978] PM: late freeze of devices complete after 1.377 msecs
<6>[  106.723388] PM: noirq freeze of devices complete after 2.378 msecs
<6>[  106.723795] ACPI: Preparing to enter system sleep state S4
<6>[  106.727934] PM: Saving platform NVS memory
<4>[  106.740582] Disabling non-boot CPUs ...
<6>[  106.743252] kvm: disabling virtualization on CPU1
<6>[  106.743332] smpboot: CPU 1 is now offline
<6>[  106.750476] kvm: disabling virtualization on CPU2
<6>[  106.750518] smpboot: CPU 2 is now offline
<6>[  106.754634] kvm: disabling virtualization on CPU3
<6>[  106.754682] smpboot: CPU 3 is now offline
<6>[  106.758510] kvm: disabling virtualization on CPU4
<6>[  106.758817] smpboot: CPU 4 is now offline
<6>[  106.761210] kvm: disabling virtualization on CPU5
<6>[  106.761253] smpboot: CPU 5 is now offline
<6>[  106.763567] kvm: disabling virtualization on CPU6
<6>[  106.763596] smpboot: CPU 6 is now offline
<6>[  106.765906] kvm: disabling virtualization on CPU7
<6>[  106.765943] smpboot: CPU 7 is now offline
<6>[  106.766958] PM: Creating hibernation image:
<6>[  106.786249] PM: Need to copy 73589 pages
<6>[  106.768456] PM: Restoring platform NVS memory
<6>[  106.769104] microcode: CPU0 sig=0x306a9, pf=0x2, revision=0x19
<6>[  106.770518] Enabling non-boot CPUs ...
<6>[  106.771473] x86: Booting SMP configuration:
<6>[  106.771536] smpboot: Booting Node 0 Processor 1 APIC 0x2
<6>[  106.783221] CPU1 microcode updated early to revision 0x19, date = 2013-06-13
<6>[  106.783921] kvm: enabling virtualization on CPU1
<6>[  106.788131] microcode: CPU1 sig=0x306a9, pf=0x2, revision=0x19
<6>[  106.794579] CPU1 is up
<6>[  106.795048] smpboot: Booting Node 0 Processor 2 APIC 0x4
<6>[  106.806241] CPU2 microcode updated early to revision 0x19, date = 2013-06-13
<6>[  106.806963] kvm: enabling virtualization on CPU2
<6>[  106.811056] microcode: CPU2 sig=0x306a9, pf=0x2, revision=0x19
<6>[  106.817512] CPU2 is up
<6>[  106.817999] smpboot: Booting Node 0 Processor 3 APIC 0x6
<6>[  106.829157] CPU3 microcode updated early to revision 0x19, date = 2013-06-13
<6>[  106.829918] kvm: enabling virtualization on CPU3
<6>[  106.834104] microcode: CPU3 sig=0x306a9, pf=0x2, revision=0x19
<6>[  106.840666] CPU3 is up
<6>[  106.841118] smpboot: Booting Node 0 Processor 4 APIC 0x1
<6>[  106.852238] CPU4 microcode updated early to revision 0x19, date = 2013-06-13
<6>[  106.853485] kvm: enabling virtualization on CPU4
<6>[  106.857868] microcode: CPU4 sig=0x306a9, pf=0x2, revision=0x19
<6>[  106.864443] CPU4 is up
<6>[  106.864911] smpboot: Booting Node 0 Processor 5 APIC 0x3
<6>[  106.876633] kvm: enabling virtualization on CPU5
<6>[  106.881188] microcode: CPU5 sig=0x306a9, pf=0x2, revision=0x19
<6>[  106.887793] CPU5 is up
<6>[  106.888264] smpboot: Booting Node 0 Processor 6 APIC 0x5
<6>[  106.900006] kvm: enabling virtualization on CPU6
<6>[  106.904526] microcode: CPU6 sig=0x306a9, pf=0x2, revision=0x19
<6>[  106.911141] CPU6 is up
<6>[  106.911605] smpboot: Booting Node 0 Processor 7 APIC 0x7
<6>[  106.923408] kvm: enabling virtualization on CPU7
<6>[  106.928161] microcode: CPU7 sig=0x306a9, pf=0x2, revision=0x19
<6>[  106.934883] CPU7 is up
<6>[  106.957959] ACPI: Waking up from system sleep state S4
<6>[  106.990680] PM: noirq restore of devices complete after 11.474 msecs
<6>[  106.993975] PM: early restore of devices complete after 3.024 msecs
<4>[  107.046519] usb usb3: root hub lost power or was reset
<4>[  107.046549] usb usb1: root hub lost power or was reset
<4>[  107.046694] usb usb4: root hub lost power or was reset
<4>[  107.047230] xhci_hcd 0000:00:14.0: Slot 1 endpoint 2 not removed from BW list!
<4>[  107.047574] general protection fault: 0000 [#1] PREEMPT SMP 
<4>[  107.047768] usb usb2: root hub lost power or was reset
<4>[  107.048277] 
<4>[  107.049138] Modules linked in: x86_pkg_temp_thermal coretemp kvm_intel kvm aesni_intel aes_x86_64 glue_helper iTCO_wdt lrw i915 snd_hda_codec_hdmi
<4>[  107.050193] usb usb5: root hub lost power or was reset
<4>[  107.050196] usb usb6: root hub lost power or was reset
<7>[  107.050410] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
<7>[  107.050453] ehci-pci 0000:00:1a.0: cache line size of 64 is not supported
<7>[  107.051666] ehci-pci 0000:00:1d.0: cache line size of 64 is not supported
<7>[  107.052951] xhci_hcd 0000:04:00.0: irq 45 for MSI/MSI-X
<7>[  107.053018] xhci_hcd 0000:04:00.0: irq 46 for MSI/MSI-X
<7>[  107.053078] xhci_hcd 0000:04:00.0: irq 47 for MSI/MSI-X
<7>[  107.053137] xhci_hcd 0000:04:00.0: irq 48 for MSI/MSI-X
<7>[  107.053197] xhci_hcd 0000:04:00.0: irq 49 for MSI/MSI-X
<7>[  107.054698] xhci_hcd 0000:04:00.0: irq 50 for MSI/MSI-X
<7>[  107.054763] xhci_hcd 0000:04:00.0: irq 51 for MSI/MSI-X
<7>[  107.054830] xhci_hcd 0000:04:00.0: irq 52 for MSI/MSI-X
<4>[  107.057882]  snd_hda_codec_realtek hid_generic snd_hda_codec_generic gf128mul snd_hda_intel ablk_helper usbhid cryptd snd_hda_controller hid cfbfillrect snd_hda_codec cfbimgblt snd_hwdep snd_pcm i2c_algo_bit cfbcopyarea snd_timer drm_kms_helper psmouse snd drm lpc_ich pcspkr i2c_i801 mfd_core soundcore wmi evdev
<4>[  107.062030] CPU: 2 PID: 756 Comm: kworker/u16:2 Tainted: G        W     3.15.0-rc4-hang #16
<5>[  107.062068] sd 0:0:0:0: [sda] Starting disk
<4>[  107.062992] Hardware name:                  /DZ77BH-55K, BIOS BHZ7710H.86A.0100.2013.0517.0942 05/17/2013
<4>[  107.063454] Workqueue: events_unbound async_run_entry_fn
<4>[  107.063892] task: ffff88007cb58000 ti: ffff88007b6fc000 task.ti: ffff88007b6fc000
<4>[  107.064311] RIP: 0010:[<ffffffff812b2a99>]  [<ffffffff812b2a99>] __list_del_entry+0x29/0xd0
<4>[  107.064942] RSP: 0000:ffff88007b6fdb48  EFLAGS: 00010a83
<4>[  107.065446] RAX: 6b6b6b6b6b6b6b6b RBX: ffff88007b0ba1e8 RCX: dead000000200200
<4>[  107.065962] RDX: 6b6b6b6b6b6b6b6b RSI: ffff88007cb58750 RDI: ffff88007ac40318
<4>[  107.066479] RBP: ffff88007b6fdb48 R08: 0000000000000000 R09: 0000000000000001
<4>[  107.067024] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000003
<4>[  107.067528] R13: ffff88007b108000 R14: ffff88007b0ba160 R15: ffff88007ac40318
<4>[  107.068051] FS:  0000000000000000(0000) GS:ffff88007fc80000(0000) knlGS:0000000000000000
<4>[  107.068560] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
<4>[  107.068901] CR2: 0000000000000000 CR3: 0000000001a0e000 CR4: 00000000001407e0
<4>[  107.069247] Stack:
<4>[  107.069563]  ffff88007b6fdbb8 ffffffff81423d08 0000000000000001 ffff88007cad2290
<4>[  107.070156]  ffff88007b6fdb88 ffffffff812e4815 0000000000001580 0000000000000000
<4>[  107.070929]  ffff88007b6fdbb8 ffff88007b108000 ffff88007b0f7978 ffff88007b0f7978
<4>[  107.071788] Call Trace:
<4>[  107.072260]  [<ffffffff81423d08>] xhci_mem_cleanup+0x428/0x610
<4>[  107.072756]  [<ffffffff812e4815>] ? pci_disable_msi+0x45/0x50
<4>[  107.073193]  [<ffffffff8141c3e0>] xhci_resume+0x210/0x3a0
<4>[  107.073618]  [<ffffffff8140ba9d>] ? usb_enable_intel_xhci_ports+0xbd/0xd0
<4>[  107.074245]  [<ffffffff8142c266>] xhci_pci_resume+0x36/0x50
<4>[  107.074837]  [<ffffffff8140ac31>] resume_common+0xa1/0x150
<4>[  107.075460]  [<ffffffff812cca00>] ? pci_pm_default_resume+0x50/0x50
<4>[  107.076103]  [<ffffffff8140ad13>] hcd_pci_restore+0x13/0x20
<4>[  107.076692]  [<ffffffff812cca88>] pci_pm_restore+0x88/0xf0
<4>[  107.077282]  [<ffffffff813771ac>] ? device_resume+0x6c/0x1a0
<4>[  107.077902]  [<ffffffff8137677a>] dpm_run_callback+0x3a/0xe0
<4>[  107.078489]  [<ffffffff81514120>] ? _raw_spin_unlock_irq+0x30/0x60
<4>[  107.079119]  [<ffffffff813771ee>] device_resume+0xae/0x1a0
<4>[  107.079741]  [<ffffffff81377301>] async_resume+0x21/0x50
<4>[  107.080171]  [<ffffffff810719c6>] async_run_entry_fn+0x46/0x140
<4>[  107.080792]  [<ffffffff810640e4>] process_one_work+0x1f4/0x530
<4>[  107.081387]  [<ffffffff81064079>] ? process_one_work+0x189/0x530
<4>[  107.082019]  [<ffffffff8106487c>] worker_thread+0x11c/0x370
<4>[  107.082614]  [<ffffffff81064760>] ? rescuer_thread+0x300/0x300
<4>[  107.083236]  [<ffffffff8106bbf4>] kthread+0xe4/0x100
<4>[  107.083820]  [<ffffffff81514120>] ? _raw_spin_unlock_irq+0x30/0x60
<4>[  107.084441]  [<ffffffff8106bb10>] ? kthread_create_on_node+0x210/0x210
<4>[  107.085032]  [<ffffffff8151522c>] ret_from_fork+0x7c/0xb0
<4>[  107.085652]  [<ffffffff8106bb10>] ? kthread_create_on_node+0x210/0x210
<4>[  107.086251] Code: 1f 00 48 b9 00 01 10 00 00 00 ad de 55 48 8b 17 48 89 e5 48 8b 47 08 48 39 ca 74 29 48 b9 00 02 20 00 00 00 ad de 48 39 c8 74 7a <4c> 8b 00 4c 39 c7 75 53 4c 8b 42 08 4c 39 c7 75 2b 48 89 42 08 
<1>[  107.094025] RIP  [<ffffffff812b2a99>] __list_del_entry+0x29/0xd0
<4>[  107.094738]  RSP <ffff88007b6fdb48>
<4>[  107.095434] ---[ end trace f5b8b9411bd5e24c ]---

-- 
Ville Syrjälä
Intel OTC
