Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757710AbbA2CPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:15:54 -0500
Received: from mail-qg0-f54.google.com ([209.85.192.54]:56323 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbbA2CPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:15:51 -0500
From: Vince Weaver <vincent.weaver@maine.edu>
X-Google-Original-From: Vince Weaver <vince@vincent-weaver-1.umelst.maine.edu>
Date: Wed, 28 Jan 2015 21:16:49 -0500 (EST)
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, Stephane Eranian <eranian@gmail.com>,
        jolsa@redhat.com, mark.rutland@arm.com, torvalds@linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [RFC][PATCH 2/3] perf: Add a bit of paranoia
In-Reply-To: <alpine.DEB.2.11.1501271621550.5038@vincent-weaver-1.umelst.maine.edu>
Message-ID: <alpine.DEB.2.11.1501282114320.8031@vincent-weaver-1.umelst.maine.edu>
References: <20150123125159.696530128@infradead.org> <20150123125834.150481799@infradead.org> <20150126162639.GA21418@twins.programming.kicks-ass.net> <alpine.DEB.2.11.1501271621550.5038@vincent-weaver-1.umelst.maine.edu>
User-Agent: Alpine 2.11 (DEB 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jan 2015, Vince Weaver wrote:

> On Mon, 26 Jan 2015, Peter Zijlstra wrote:
> 
> > I think the below should cure this; if we install a group leader it will
> > iterate the (still intact) group list and find its siblings and try and
> > install those too -- even though those still have the old event->ctx --
> > in the new ctx.
> 
> I've been fuzzing 24 hours (despite the blizzard) with this patch
> plus the original series on top of 3.19-rc6 on the Haswell machine and it 
> is looking good.

OK it took about 48 hours but I managed to generate this:

[162118.235829] ------------[ cut here ]------------
[162118.241388] WARNING: CPU: 5 PID: 13571 at kernel/events/core.c:1644 perf_remove_from_context+0xf5/0x120()
[162118.252183] Modules linked in: fuse x86_pkg_temp_thermal intel_powerclamp intel_rapl iosf_mbi coretemp kvm crct10dif_pclmul snd_hda_codec_realtek snd_hda_codec_hdmi snd_hda_codec_generic crc32_pclmul snd_hda_intel ghash_clmulni_intel snd_hda_controller aesni_intel snd_hda_codec aes_x86_64 snd_hwdep lrw gf128mul snd_pcm ppdev glue_helper xhci_pci mei_me iTCO_wdt iTCO_vendor_support i915 snd_timer drm_kms_helper snd drm ablk_helper lpc_ich mfd_core evdev pcspkr parport_pc psmouse cryptd soundcore i2c_i801 serio_raw parport xhci_hcd mei wmi tpm_tis tpm video battery button processor i2c_algo_bit sg sr_mod sd_mod cdrom ahci libahci e1000e ehci_pci libata ptp ehci_hcd crc32c_intel usbcore scsi_mod usb_common pps_core thermal fan thermal_sys
[162118.325574] CPU: 5 PID: 13571 Comm: perf_fuzzer Tainted: G        W      3.19.0-rc6+ #126
[162118.334984] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
[162118.343581]  ffffffff81a3f194 ffff8800c8463b48 ffffffff816b6761 0000000000000000
[162118.352277]  0000000000000000 ffff8800c8463b88 ffffffff8106dcda ffff8800c9286c40
[162118.360962]  ffff8800c8c01800 ffff8800c8c3a090 ffff8800c8c3a090 ffff8800c71b4800
[162118.369669] Call Trace:
[162118.372984]  [<ffffffff816b6761>] dump_stack+0x45/0x57
[162118.379170]  [<ffffffff8106dcda>] warn_slowpath_common+0x8a/0xc0
[162118.386267]  [<ffffffff8106ddca>] warn_slowpath_null+0x1a/0x20
[162118.393160]  [<ffffffff811554b5>] perf_remove_from_context+0xf5/0x120
[162118.400706]  [<ffffffff811571c5>] put_event+0x115/0x170
[162118.407004]  [<ffffffff81157101>] ? put_event+0x51/0x170
[162118.413340]  [<ffffffff816bc06e>] ? mutex_unlock+0xe/0x10
[162118.419792]  [<ffffffff81157255>] perf_release+0x15/0x20
[162118.426144]  [<ffffffff811e234f>] __fput+0xdf/0x1f0
[162118.432009]  [<ffffffff811e24ae>] ____fput+0xe/0x10
[162118.437895]  [<ffffffff8108bbc7>] task_work_run+0xa7/0xe0
[162118.444377]  [<ffffffff81070799>] do_exit+0x319/0xac0
[162118.450443]  [<ffffffff8107cc99>] ? get_signal+0xe9/0x770
[162118.456906]  [<ffffffff8107cf09>] ? get_signal+0x359/0x770
[162118.463427]  [<ffffffff81070fe4>] do_group_exit+0x54/0xe0
[162118.469887]  [<ffffffff8107ce46>] get_signal+0x296/0x770
[162118.476237]  [<ffffffff8105ded2>] ? __do_page_fault+0x1f2/0x580
[162118.483251]  [<ffffffff81013578>] do_signal+0x28/0xbb0
[162118.489392]  [<ffffffff8105e282>] ? do_page_fault+0x22/0x30
[162118.496055]  [<ffffffff81014170>] do_notify_resume+0x70/0x90
[162118.502811]  [<ffffffff816bf662>] retint_signal+0x48/0x86
[162118.509272] ---[ end trace 55752a03ec8ab978 ]---

