Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756929AbbAZSCl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 13:02:41 -0500
Received: from mail-qc0-f181.google.com ([209.85.216.181]:33345 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755285AbbAZSCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 13:02:38 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Mon, 26 Jan 2015 13:03:47 -0500 (EST)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, eranian@gmail.com, jolsa@redhat.com,
        mark.rutland@arm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [RFC][PATCH 0/3] perf fixes
In-Reply-To: <alpine.DEB.2.11.1501260925370.30598@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1501261300570.30598@vincent-weaver-1.umelst.maine.edu>
References: <20150123125159.696530128@infradead.org> <alpine.DEB.2.11.1501260925370.30598@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Jan 2015, Vince Weaver wrote:

> I applied this to (just before) 3.19-rc6 and let it run on my 
> troublemaking Haswell machine overnight.  It is looking good!

spoke too soon, managed to trigger one of the new warnings you added.

This is
        WARN_ON_ONCE(event->ctx != ctx);
in event_sched_out()

[42437.159176] ------------[ cut here ]------------
[42437.164613] WARNING: CPU: 1 PID: 15433 at kernel/events/core.c:1525 event_sched_out.isra.72+0x25e/0x2c0()
[42437.175338] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic snd_hda_intel crct10dif_pclmul snd_hda_controller crc32_pclmul ppdev ghash_clmulni_intel iTCO_wdt iTCO_vendor_support aesni_intel aes_x86_64 lpc_ich mfd_core evdev lrw mei_me i915 psmouse snd_hda_codec mei xhci_pci gf128mul i2c_i801 serio_raw xhci_hcd glue_helper snd_hwdep snd_pcm ablk_helper cryptd snd_timer drm_kms_helper parport_pc parport tpm_tis pcspkr snd tpm drm battery video soundcore wmi i2c_algo_bit button processor sg sr_mod sd_mod cdrom ehci_pci ehci_hcd ahci libahci e1000e libata ptp usbcore scsi_mod usb_common pps_core crc32c_intel thermal fan thermal_sys
[42437.248890] CPU: 1 PID: 15433 Comm: perf_fuzzer Tainted: G        W      3.19.0-rc5+ #125
[42437.258294] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[42437.266772]  ffffffff81a3f194 ffff8800c83bfbc8 ffffffff816b6741 0000000000000000
[42437.275427]  0000000000000000 ffff8800c83bfc08 ffffffff8106dcda 01926893541204d2
[42437.284054]  ffff8800c69a4800 ffff88011ea5ced0 ffff88011ea5ced4 ffff880118ce4000
[42437.292660] Call Trace:
[42437.295915]  [<ffffffff816b6741>] dump_stack+0x45/0x57
[42437.302023]  [<ffffffff8106dcda>] warn_slowpath_common+0x8a/0xc0
[42437.309080]  [<ffffffff8106ddca>] warn_slowpath_null+0x1a/0x20
[42437.315950]  [<ffffffff811587ee>] event_sched_out.isra.72+0x25e/0x2c0
[42437.323445]  [<ffffffff811588c1>] group_sched_out+0x71/0xd0
[42437.330045]  [<ffffffff8101d90a>] ? native_sched_clock+0x2a/0x90
[42437.337116]  [<ffffffff81158d2e>] ctx_sched_out+0xee/0x150
[42437.343610]  [<ffffffff81158dcb>] task_ctx_sched_out+0x3b/0x80
[42437.350461]  [<ffffffff8115a489>] __perf_install_in_context+0x79/0x1e0
[42437.358073]  [<ffffffff81154570>] remote_function+0x50/0x60
[42437.364702]  [<ffffffff810ef53e>] generic_exec_single+0x12e/0x190
[42437.371828]  [<ffffffff81154520>] ? task_clock_event_add+0x40/0x40
[42437.379083]  [<ffffffff810ef607>] smp_call_function_single+0x67/0xa0
[42437.386491]  [<ffffffff81153419>] task_function_call+0x49/0x60
[42437.393364]  [<ffffffff8115a410>] ? perf_cpu_hrtimer_handler+0x270/0x270
[42437.401167]  [<ffffffff811549fb>] perf_install_in_context+0x8b/0x100
[42437.408611]  [<ffffffff8115e082>] SYSC_perf_event_open+0x892/0xc60
[42437.415841]  [<ffffffff8115e89e>] SyS_perf_event_open+0xe/0x10
[42437.422680]  [<ffffffff816be6ad>] system_call_fastpath+0x16/0x1b
[42437.429728] ---[ end trace 963de0bbaca247a8 ]---

