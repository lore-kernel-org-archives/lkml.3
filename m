Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab3FDVUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 17:20:50 -0400
Received: from cantor2.suse.de ([195.135.220.15]:50572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751311Ab3FDVUs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 17:20:48 -0400
Date: Tue, 4 Jun 2013 23:20:42 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Borislav Petkov <bp@alien8.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: NOHZ: WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule,
 round 2
In-Reply-To: <20130517135641.GF23035@pd.tnic>
Message-ID: <alpine.LNX.2.00.1306042319360.6750@pobox.suse.cz>
References: <alpine.LNX.2.00.1305091423460.23038@pobox.suse.cz> <20130509125040.GF27333@pd.tnic> <20130509125859.GG27333@pd.tnic> <20130515184528.GO4442@linux.vnet.ibm.com> <20130515224358.GF11783@pd.tnic> <20130515235512.GT4442@linux.vnet.ibm.com>
 <20130517135641.GF23035@pd.tnic>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 May 2013, Borislav Petkov wrote:

> commit f7ea0fd639c2c48d3c61b6eec75362be290c6874
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Mon May 13 21:40:27 2013 +0200
> 
>     tick: Don't invoke tick_nohz_stop_sched_tick() if the cpu is offline
> 
> Now, when I halt the box, I see these splats originating from cpufreq's
> od_dbs_timer adding a workqueue which does add_timer_on:
> 
> 
> [   49.338878] EXT4-fs (sda7): re-mounted. Opts: (null)
> [   51.502417] kvm: exiting hardware virtualization
> [   51.597330] ACPI: Preparing to enter system sleep state S5
> [   51.603147] Disabling non-boot CPUs ...
> [   51.616759] ------------[ cut here ]------------
> [   51.621460] WARNING: at arch/x86/kernel/smp.c:123 native_smp_send_reschedule+0x58/0x60()
> [   51.629638] Modules linked in: ext2 vfat fat loop snd_hda_codec_hdmi usbhid snd_hda_codec_realtek coretemp kvm_intel kvm snd_hda_intel snd_hda_codec crc32_pclmul crc32c_intel ghash_clmulni_intel snd_hwdep snd_pcm aesni_intel sb_edac aes_x86_64 ehci_pci snd_page_alloc glue_helper snd_timer xhci_hcd snd iTCO_wdt iTCO_vendor_support ehci_hcd edac_core lpc_ich acpi_cpufreq lrw gf128mul ablk_helper cryptd mperf usbcore usb_common soundcore mfd_core dcdbas evdev pcspkr processor i2c_i801 button microcode
> [   51.675581] CPU: 0 PID: 244 Comm: kworker/1:1 Tainted: G        W    3.10.0-rc1+ #10
> [   51.683407] Hardware name: Dell Inc. Precision T3600/0PTTT9, BIOS A08 01/24/2013
> [   51.690901] Workqueue: events od_dbs_timer
> [   51.695069]  0000000000000009 ffff88043a2f5b68 ffffffff8161441c ffff88043a2f5ba8
> [   51.702602]  ffffffff8103e540 0000000000000033 0000000000000001 ffff88043d5f8000
> [   51.710136]  00000000ffff0ce1 0000000000000001 ffff88044fc4fc08 ffff88043a2f5bb8
> [   51.717691] Call Trace:
> [   51.720191]  [<ffffffff8161441c>] dump_stack+0x19/0x1b
> [   51.725396]  [<ffffffff8103e540>] warn_slowpath_common+0x70/0xa0
> [   51.731473]  [<ffffffff8103e58a>] warn_slowpath_null+0x1a/0x20
> [   51.737378]  [<ffffffff81025628>] native_smp_send_reschedule+0x58/0x60
> [   51.744013]  [<ffffffff81072cfd>] wake_up_nohz_cpu+0x2d/0xa0
> [   51.749745]  [<ffffffff8104f6bf>] add_timer_on+0x8f/0x110
> [   51.755214]  [<ffffffff8105f6fe>] __queue_delayed_work+0x16e/0x1a0
> [   51.761470]  [<ffffffff8105f251>] ? try_to_grab_pending+0xd1/0x1a0
> [   51.767724]  [<ffffffff8105f78a>] mod_delayed_work_on+0x5a/0xa0
> [   51.773719]  [<ffffffff814f6b5d>] gov_queue_work+0x4d/0xc0
> [   51.779271]  [<ffffffff814f60cb>] od_dbs_timer+0xcb/0x170
> [   51.784734]  [<ffffffff8105e75d>] process_one_work+0x1fd/0x540
> [   51.790634]  [<ffffffff8105e6f2>] ? process_one_work+0x192/0x540
> [   51.796711]  [<ffffffff8105ef22>] worker_thread+0x122/0x380
> [   51.802350]  [<ffffffff8105ee00>] ? rescuer_thread+0x320/0x320
> [   51.808264]  [<ffffffff8106634a>] kthread+0xea/0xf0
> [   51.813200]  [<ffffffff81066260>] ? flush_kthread_worker+0x150/0x150
> [   51.819644]  [<ffffffff81623d5c>] ret_from_fork+0x7c/0xb0

Just to not let this thread sleep -- I am seeing this as well, even with 
current Linus' tree (git HEAD == aa4f608).

-- 
Jiri Kosina
SUSE Labs
