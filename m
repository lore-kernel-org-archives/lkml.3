Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbaEAPJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:09:55 -0400
Received: from casper.infradead.org ([85.118.1.10]:40910 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaEAPJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:09:53 -0400
Date: Thu, 1 May 2014 17:09:48 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Vince Weaver <vincent.weaver@maine.edu>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [perf] more perf_fuzzer memory corruption
Message-ID: <20140501150948.GR11096@twins.programming.kicks-ass.net>
References: <alpine.DEB.2.10.1404242243220.12717@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281017590.18996@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1404281447570.18996@vincent-weaver-1.umelst.maine.edu>
 <20140429094632.GP27561@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291411220.22490@vincent-weaver-1.umelst.maine.edu>
 <20140429190108.GB30445@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1404291534520.22490@vincent-weaver-1.umelst.maine.edu>
 <20140430184437.GH17778@laptop.programming.kicks-ass.net>
 <alpine.DEB.2.10.1405011003360.18142@vincent-weaver-1.umelst.maine.edu>
 <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405011023400.18142@vincent-weaver-1.umelst.maine.edu>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 01, 2014 at 10:27:45AM -0400, Vince Weaver wrote:
> On Thu, 1 May 2014, Vince Weaver wrote:
> 
> > On Wed, 30 Apr 2014, Peter Zijlstra wrote:
> > 
> > > Vince, could you add the below to whatever tracing muck you already
> > > have?
> 
> and this might be what you're looking for.  This is with a different 
> random seed than the one I've used for other traces, your patch changes 
> the syscall behavior enough that the one I was using before wasn't going 
> down the same path.
> 
> This WARNING is
> WARN_ON(event->hlist_entry.pprev && event->hlist_entry.pprev != LIST_POISON2);
> 
> [ 1554.910867] ------------[ cut here ]------------
> [ 1554.919535] WARNING: CPU: 5 PID: 16431 at kernel/events/core.c:3232 __free_event+0x86/0x90()
> [ 1554.931534] Modules linked in: fuse snd_hda_codec_hdmi x86_pkg_temp_thermal intel_powerclamp coretemp i915 kvm snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller crct10dif_pclmul drm_kms_helper snd_hda_codec crc32_pclmul ghash_clmulni_intel aesni_intel snd_hwdep snd_pcm drm snd_seq aes_x86_64 lrw evdev parport_pc iTCO_wdt gf128mul snd_timer tpm_tis snd_seq_device glue_helper i2c_i801 snd iTCO_vendor_support ablk_helper cryptd parport psmouse pcspkr serio_raw button processor video battery i2c_algo_bit i2c_core tpm wmi lpc_ich mfd_core mei_me mei soundcore sg sd_mod sr_mod crc_t10dif crct10dif_common cdrom ahci libahci ehci_pci xhci_hcd ehci_hcd libata e1000e scsi_mod ptp usbcore crc32c_intel pps_core usb_common fan thermal thermal_sys
> [ 1555.010748] CPU: 5 PID: 16431 Comm: perf_fuzzer Tainted: G        W     3.15.0-rc1+ #92
> [ 1555.020142] Hardware name: LENOVO 10AM000AUS/SHARKBAY, BIOS FBKT72AUS 01/26/2014
> [ 1555.028924]  0000000000000009 ffff880117147b78 ffffffff81649790 0000000000000000
> [ 1555.037771]  ffff880117147bb0 ffffffff810646ad ffff880116daf800 0000000000000000
> [ 1555.046611]  ffff880036e45a10 ffff8800cde07588 ffff880116dafaa0 ffff880117147bc0
> [ 1555.055490] Call Trace:
> [ 1555.058963]  [<ffffffff81649790>] dump_stack+0x45/0x56
> [ 1555.065357]  [<ffffffff810646ad>] warn_slowpath_common+0x7d/0xa0
> [ 1555.072646]  [<ffffffff8106478a>] warn_slowpath_null+0x1a/0x20
> [ 1555.079740]  [<ffffffff81132e56>] __free_event+0x86/0x90
> [ 1555.086298]  [<ffffffff811339c9>] _free_event+0xc9/0x200
> [ 1555.092859]  [<ffffffff81133c78>] put_event+0x178/0x1f0
> [ 1555.099293]  [<ffffffff81133b68>] ? put_event+0x68/0x1f0
> [ 1555.105853]  [<ffffffff81133d12>] perf_release+0x12/0x20
> [ 1555.112422]  [<ffffffff811b64ec>] __fput+0xdc/0x1e0
> [ 1555.118576]  [<ffffffff811b663e>] ____fput+0xe/0x10
> [ 1555.124630]  [<ffffffff81085137>] task_work_run+0xa7/0xe0
> [ 1555.131307]  [<ffffffff81066d5c>] do_exit+0x2cc/0xa50
> [ 1555.137606]  [<ffffffff81076949>] ? get_signal_to_deliver+0x249/0x650
> [ 1555.145356]  [<ffffffff8106756c>] do_group_exit+0x4c/0xc0
> [ 1555.151970]  [<ffffffff81076991>] get_signal_to_deliver+0x291/0x650
> [ 1555.159542]  [<ffffffff81012438>] do_signal+0x48/0x990
> [ 1555.165869]  [<ffffffff81655592>] ? do_page_fault+0x22/0x30
> [ 1555.172645]  [<ffffffff81012df0>] do_notify_resume+0x70/0xa0
> [ 1555.179484]  [<ffffffff81651abc>] retint_signal+0x48/0x8c
> [ 1555.185991] ---[ end trace 41ec7a21bb260463 ]---
> [ 1556.112904] Slab corruption (Tainted: G        W    ): kmalloc-2048 start=ffff880116daf800, len=2048
> [ 1556.126221] 040: 6b 6b 6b 6b 6b 6b 6b 6b a8 75 36 ca 00 88 ff ff  kkkkkkkk.u6.....
> [ 1556.137243] Prev obj: start=ffff880116daf000, len=2048
> [ 1556.145566] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> [ 1556.156292] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> 
> I can try slapping ftrace on and getting a trace if you want.
> 
> I've been using
> trace-cmd record -e kmem -e raw_syscalls -p function -l '*perf*' -n 'perf_event_task_tick'
> 
> which is a compromise between log size and info, but as you've seen it 
> loses useful info, especially all the things in core.c that don't
> include *perf*.
> 

/proc/sys/kernel/traceoff_on_warning

Is also useful, it disables tracing the moment a warn/bug hits.

But yes please!
