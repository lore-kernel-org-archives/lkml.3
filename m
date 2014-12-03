Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751503AbaLCTBs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 14:01:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49298 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbaLCTBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 14:01:44 -0500
Date: Wed, 3 Dec 2014 14:00:45 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
Message-ID: <20141203190045.GB32005@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Chris Mason <clm@fb.com>, Mike Galbraith <umgwanakikbuti@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	=?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>,
	Sasha Levin <sasha.levin@oracle.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <547bbe36.48548c0a.105c.779c@mx.google.com>
 <20141201191431.GA17385@linux.vnet.ibm.com>
 <547ccf74.a5198c0a.25de.26d9@mx.google.com>
 <CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
 <20141201230339.GA20487@ret.masoncoding.com>
 <1417529606.3924.26.camel@maggy.simpson.net>
 <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
 <1417540493.21136.3@mail.thefacebook.com>
 <20141203184111.GA32005@redhat.com>
 <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzLprvtdLGDXgRr=k3QqO824uQSzbxT-b4vu_4pryMtSA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 03, 2014 at 10:45:57AM -0800, Linus Torvalds wrote:
 > On Wed, Dec 3, 2014 at 10:41 AM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > I've been stuck on this kernel for a few days now trying to prove it
 > > good/bad one way or the other, and I'm leaning towards good, given
 > > that it recovers, even though the traces look similar.
 > 
 > Ugh. But this does *not* happen with 3.16, right? Even the non-fatal case?

correct. at least not in any of the runs that I did to date.

 > If so, I'd be inclined to call it "bad". But there might well be two
 > bugs: one that makes that NMI watchdog trigger, and another one that
 > then makes it be a hard lockup. I'd think it would be good to figure
 > out the "NMI watchdog starts triggering" one first, though.

I think you're right.

So right after sending my last mail, I rebooted, and restarted the run
on the same kernel again.

As I was writing this mail, this happened.

[  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c178:20182]

and that's all that made it over the console. I couldn't log in via ssh,
and thought "ah-ha, so it IS bad".  I walked over to reboot it, and
found I could actually log in on the console. check out this dmesg..

[  503.683055] Clocksource tsc unstable (delta = -95946009388 ns)
[  503.692038] Switched to clocksource hpet
[  524.420897] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c178:20182]
[  524.420972] Modules linked in: fuse tun rfcomm llc2 af_key nfnetlink scsi_transport_iscsi can_bcm bnep can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm nfsd auth_rpcgss oid_registry nfs_acl lockd sunrpc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec crct10dif_pclmul crc32c_intel ghash_clmulni_intel e1000e snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer microcode snd serio_raw pcspkr usb_debug ptp pps_core shpchp soundcore
[  524.421288] CPU: 0 PID: 20182 Comm: trinity-c178 Not tainted 3.17.0-rc1+ #112
[  524.421351] task: ffff8801cd63c4d0 ti: ffff8801d2138000 task.ti: ffff8801d2138000
[  524.421377] RIP: 0010:[<ffffffff8136968d>]  [<ffffffff8136968d>] copy_user_handle_tail+0x6d/0x90
[  524.421411] RSP: 0018:ffff8801d213bf00  EFLAGS: 00000202
[  524.421430] RAX: 000000000007a8d9 RBX: ffffffff817b2c64 RCX: 0000000000000000
[  524.421455] RDX: 0000000000056ddc RSI: ffff88023412baf5 RDI: ffff88023412baf4
[  524.421480] RBP: ffff8801d213bf00 R08: 0000000000000000 R09: 0000000000000000
[  524.421504] R10: 0000000000000100 R11: 0000000000000000 R12: ffffffff817b92d0
[  524.421528] R13: 00007f6a24fe0000 R14: ffff8801d2138000 R15: 0000000000000001
[  524.421552] FS:  00007f6a24fd0740(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
[  524.421579] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  524.421600] CR2: 00007f6a24fe0000 CR3: 00000002053c8000 CR4: 00000000001407f0
[  524.421624] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  524.421648] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  524.421672] Stack:
[  524.421683]  ffff8801d213bf78 ffffffff812e4a85 00007f6a2452f068 0000000000000000
[  524.421716]  ffffffff3fffffff 00000000000003e8 00007f6a2452f000 00000000000000f8
[  524.421748]  0000000000000000 00000000a417dc9d 00000000000000f8 00007f6a2452f000
[  524.421781] Call Trace:
[  524.422754]  [<ffffffff812e4a85>] SyS_add_key+0xd5/0x240
[  524.423736]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  524.424713] Code: c0 74 d3 85 d2 89 d0 74 39 85 c9 74 35 45 31 c0 eb 0c 0f 1f 40 00 83 ea 01 74 17 48 89 f7 48 8d 77 01 44 89 c1 0f 1f 00 c6 07 00 <0f> 1f 00 85 c9 74 e4 0f 1f 00 5d c3 0f 1f 80 00 00 00 00 31 c0 
[  524.426861] sending NMI to other CPUs:
[  524.427867] NMI backtrace for cpu 3
[  524.428868] CPU: 3 PID: 20165 Comm: trinity-c161 Not tainted 3.17.0-rc1+ #112
[  524.430914] task: ffff8801fe67dbc0 ti: ffff8801fe70c000 task.ti: ffff8801fe70c000
[  524.431951] RIP: 0010:[<ffffffff810f99da>]  [<ffffffff810f99da>] generic_exec_single+0xea/0x1a0
[  524.433004] RSP: 0018:ffff8801fe70fc40  EFLAGS: 00000202
[  524.434051] RAX: 0000000000000000 RBX: ffff8801fe70fc40 RCX: 0000000000000038
[  524.435108] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[  524.436165] RBP: ffff8801fe70fc90 R08: ffff880242bfa3f0 R09: 0000000000000000
[  524.437221] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  524.438278] R13: 0000000000000001 R14: ffff880238ef1290 R15: ffffffff8115fd30
[  524.439339] FS:  00007f6a24fd0740(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[  524.440415] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  524.441494] CR2: 00007f6a23446001 CR3: 00000001cd627000 CR4: 00000000001407e0
[  524.442579] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  524.443665] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  524.444749] Stack:
[  524.445825]  0000000000000000 ffffffff8115fd30 ffff880238ef1290 0000000000000003
[  524.446926]  00000000af3b5f31 00000000ffffffff 0000000000000000 ffffffff8115fd30
[  524.448028]  ffff880238ef1290 0000000000000001 ffff8801fe70fcd0 ffffffff810f9b5a
[  524.449115] Call Trace:
[  524.450179]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  524.451259]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  524.452334]  [<ffffffff810f9b5a>] smp_call_function_single+0x6a/0xe0
[  524.453411]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  524.454483]  [<ffffffff8116036a>] perf_event_read+0xca/0xd0
[  524.455549]  [<ffffffff81160400>] perf_event_read_value+0x90/0xe0
[  524.456618]  [<ffffffff81161b1e>] perf_read+0x20e/0x360
[  524.457689]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  524.458761]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  524.459827]  [<ffffffff811dfdd3>] do_loop_readv_writev+0x63/0x90
[  524.460887]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  524.461944]  [<ffffffff811e1c97>] do_readv_writev+0x267/0x280
[  524.462996]  [<ffffffff81375a47>] ? debug_smp_processor_id+0x17/0x20
[  524.464029]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  524.465040]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[  524.466027]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  524.466995]  [<ffffffff817b1377>] ? _raw_spin_unlock_irq+0x37/0x60
[  524.467940]  [<ffffffff810e672a>] ? do_setitimer+0x1ca/0x250
[  524.468874]  [<ffffffff811e1ce9>] vfs_readv+0x39/0x50
[  524.469791]  [<ffffffff811e1dac>] SyS_readv+0x5c/0x100
[  524.470689]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  524.471568] Code: 00 4c 1d 00 48 89 de 48 03 14 c5 e0 af d1 81 48 89 df e8 5a 47 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 4d d0 65 48 33 0c 25 28 00 00 00 
[  524.473500] NMI backtrace for cpu 1
[  524.473584] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 45.633 msecs
[  524.475347] CPU: 1 PID: 20241 Comm: trinity-c237 Not tainted 3.17.0-rc1+ #112
[  524.477246] task: ffff8801e32c16f0 ti: ffff88008696c000 task.ti: ffff88008696c000
[  524.478212] RIP: 0010:[<ffffffff810f99d8>]  [<ffffffff810f99d8>] generic_exec_single+0xe8/0x1a0
[  524.479189] RSP: 0018:ffff88008696fc40  EFLAGS: 00000202
[  524.480152] RAX: ffff880062d6bc00 RBX: ffff88008696fc40 RCX: ffff880062d6bc40
[  524.481130] RDX: ffff8802441d4c00 RSI: ffff88008696fc40 RDI: ffff88008696fc40
[  524.482108] RBP: ffff88008696fc90 R08: 0000000000000001 R09: 0000000000000001
[  524.483084] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  524.484051] R13: 0000000000000001 R14: ffff880238ef1bd8 R15: ffffffff8115fd30
[  524.485022] FS:  00007f6a24fd0740(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[  524.486001] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  524.486975] CR2: 0000000000000000 CR3: 00000000869c1000 CR4: 00000000001407e0
[  524.487952] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  524.488935] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  524.489891] Stack:
[  524.490817]  ffff880062d6bc40 ffffffff8115fd30 ffff880238ef1bd8 0000000000000003
[  524.491770]  00000000d88cff08 00000000ffffffff 0000000000000000 ffffffff8115fd30
[  524.492729]  ffff880238ef1bd8 0000000000000001 ffff88008696fcd0 ffffffff810f9b5a
[  524.493684] Call Trace:
[  524.494611]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  524.495530]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  524.496433]  [<ffffffff810f9b5a>] smp_call_function_single+0x6a/0xe0
[  524.497334]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  524.498227]  [<ffffffff8116036a>] perf_event_read+0xca/0xd0
[  524.499117]  [<ffffffff81160400>] perf_event_read_value+0x90/0xe0
[  524.500007]  [<ffffffff81161b1e>] perf_read+0x20e/0x360
[  524.500895]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  524.501786]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  524.502668]  [<ffffffff811dfdd3>] do_loop_readv_writev+0x63/0x90
[  524.503548]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  524.504419]  [<ffffffff811e1c97>] do_readv_writev+0x267/0x280
[  524.505295]  [<ffffffff81375a47>] ? debug_smp_processor_id+0x17/0x20
[  524.506172]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  524.507045]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[  524.507911]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  524.508774]  [<ffffffff817b1377>] ? _raw_spin_unlock_irq+0x37/0x60
[  524.509634]  [<ffffffff810e672a>] ? do_setitimer+0x1ca/0x250
[  524.510488]  [<ffffffff811e1ce9>] vfs_readv+0x39/0x50
[  524.511330]  [<ffffffff811e1dac>] SyS_readv+0x5c/0x100
[  524.512180]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  524.513026] Code: c7 c2 00 4c 1d 00 48 89 de 48 03 14 c5 e0 af d1 81 48 89 df e8 5a 47 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 <f3> 90 f6 43 18 01 75 f8 31 c0 48 8b 4d d0 65 48 33 0c 25 28 00 
[  524.514900] NMI backtrace for cpu 2
[  524.514903] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 87.033 msecs
[  524.516709] CPU: 2 PID: 20160 Comm: trinity-c156 Not tainted 3.17.0-rc1+ #112
[  524.518568] task: ffff88006b945bc0 ti: ffff880062d68000 task.ti: ffff880062d68000
[  524.519521] RIP: 0010:[<ffffffff810f99de>]  [<ffffffff810f99de>] generic_exec_single+0xee/0x1a0
[  524.520488] RSP: 0018:ffff880062d6bc40  EFLAGS: 00000202
[  524.521456] RAX: ffff8801fe70fc00 RBX: ffff880062d6bc40 RCX: ffff8801fe70fc40
[  524.522424] RDX: ffff8802441d4c00 RSI: ffff880062d6bc40 RDI: ffff880062d6bc40
[  524.523394] RBP: ffff880062d6bc90 R08: 0000000000000001 R09: 0000000000000001
[  524.524360] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  524.525325] R13: 0000000000000001 R14: ffff880238ef5cd0 R15: ffffffff8115fd30
[  524.526293] FS:  00007f6a24fd0740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[  524.527269] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  524.528248] CR2: 00000000019ca288 CR3: 000000007a7bb000 CR4: 00000000001407e0
[  524.529238] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  524.530230] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  524.531200] Stack:
[  524.532141]  ffff8801fe70fc40 ffffffff8115fd30 ffff880238ef5cd0 0000000000000003
[  524.533104]  000000008b5d668d 00000000ffffffff 0000000000000000 ffffffff8115fd30
[  524.534065]  ffff880238ef5cd0 0000000000000001 ffff880062d6bcd0 ffffffff810f9b5a
[  524.535014] Call Trace:
[  524.535938]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  524.536854]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  524.537756]  [<ffffffff810f9b5a>] smp_call_function_single+0x6a/0xe0
[  524.538648]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  524.539536]  [<ffffffff8116036a>] perf_event_read+0xca/0xd0
[  524.540425]  [<ffffffff81160400>] perf_event_read_value+0x90/0xe0
[  524.541317]  [<ffffffff81161b1e>] perf_read+0x20e/0x360
[  524.542202]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  524.543089]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  524.543967]  [<ffffffff811dfdd3>] do_loop_readv_writev+0x63/0x90
[  524.544840]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  524.545709]  [<ffffffff811e1c97>] do_readv_writev+0x267/0x280
[  524.546581]  [<ffffffff81375a47>] ? debug_smp_processor_id+0x17/0x20
[  524.547455]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  524.548327]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[  524.549188]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  524.550046]  [<ffffffff817b1377>] ? _raw_spin_unlock_irq+0x37/0x60
[  524.550905]  [<ffffffff810e672a>] ? do_setitimer+0x1ca/0x250
[  524.551755]  [<ffffffff811e1ce9>] vfs_readv+0x39/0x50
[  524.552600]  [<ffffffff811e1dac>] SyS_readv+0x5c/0x100
[  524.553444]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  524.554281] Code: 48 89 de 48 03 14 c5 e0 af d1 81 48 89 df e8 5a 47 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 4d d0 65 48 33 0c 25 28 00 00 00 0f 85 8e 00 
[  524.556148] INFO: NMI handler (arch_trigger_all_cpu_backtrace_handler) took too long to run: 128.279 msecs
[  548.406844] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [trinity-c178:20182]
[  548.407766] Modules linked in: fuse tun rfcomm llc2 af_key nfnetlink scsi_transport_iscsi can_bcm bnep can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm nfsd auth_rpcgss oid_registry nfs_acl lockd sunrpc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec crct10dif_pclmul crc32c_intel ghash_clmulni_intel e1000e snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer microcode snd serio_raw pcspkr usb_debug ptp pps_core shpchp soundcore
[  548.412860] CPU: 0 PID: 20182 Comm: trinity-c178 Tainted: G             L 3.17.0-rc1+ #112
[  548.414955] task: ffff8801cd63c4d0 ti: ffff8801d2138000 task.ti: ffff8801d2138000
[  548.416020] RIP: 0010:[<ffffffff8136968d>]  [<ffffffff8136968d>] copy_user_handle_tail+0x6d/0x90
[  548.417110] RSP: 0018:ffff8801d213bf00  EFLAGS: 00000202
[  548.418188] RAX: 000000000007a8d9 RBX: ffffffff817b2c64 RCX: 0000000000000000
[  548.419278] RDX: 0000000000056ddc RSI: ffff88023412baf5 RDI: ffff88023412baf4
[  548.420372] RBP: ffff8801d213bf00 R08: 0000000000000000 R09: 0000000000000000
[  548.421473] R10: 0000000000000100 R11: 0000000000000000 R12: ffffffff817b92d0
[  548.422576] R13: 00007f6a24fe0000 R14: ffff8801d2138000 R15: 0000000000000001
[  548.423662] FS:  00007f6a24fd0740(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
[  548.424731] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  548.425801] CR2: 00007f6a24fe0000 CR3: 00000002053c8000 CR4: 00000000001407f0
[  548.426870] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  548.427923] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  548.428956] Stack:
[  548.429968]  ffff8801d213bf78 ffffffff812e4a85 00007f6a2452f068 0000000000000000
[  548.430992]  ffffffff3fffffff 00000000000003e8 00007f6a2452f000 00000000000000f8
[  548.432009]  0000000000000000 00000000a417dc9d 00000000000000f8 00007f6a2452f000
[  548.433023] Call Trace:
[  548.434031]  [<ffffffff812e4a85>] SyS_add_key+0xd5/0x240
[  548.435046]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  548.436057] Code: c0 74 d3 85 d2 89 d0 74 39 85 c9 74 35 45 31 c0 eb 0c 0f 1f 40 00 83 ea 01 74 17 48 89 f7 48 8d 77 01 44 89 c1 0f 1f 00 c6 07 00 <0f> 1f 00 85 c9 74 e4 0f 1f 00 5d c3 0f 1f 80 00 00 00 00 31 c0 
[  548.438271] sending NMI to other CPUs:
[  548.439311] NMI backtrace for cpu 3
[  548.440341] CPU: 3 PID: 20165 Comm: trinity-c161 Tainted: G             L 3.17.0-rc1+ #112
[  548.442472] task: ffff8801fe67dbc0 ti: ffff8801fe70c000 task.ti: ffff8801fe70c000
[  548.443553] RIP: 0010:[<ffffffff810f99de>]  [<ffffffff810f99de>] generic_exec_single+0xee/0x1a0
[  548.444639] RSP: 0018:ffff8801fe70fc40  EFLAGS: 00000202
[  548.445718] RAX: 0000000000000000 RBX: ffff8801fe70fc40 RCX: 0000000000000038
[  548.446803] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[  548.447882] RBP: ffff8801fe70fc90 R08: ffff880242bfa3f0 R09: 0000000000000000
[  548.448957] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  548.450039] R13: 0000000000000001 R14: ffff880238ef1290 R15: ffffffff8115fd30
[  548.451120] FS:  00007f6a24fd0740(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[  548.452211] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  548.453305] CR2: 00007f6a23446001 CR3: 00000001cd627000 CR4: 00000000001407e0
[  548.454411] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  548.455515] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  548.456617] Stack:
[  548.457711]  0000000000000000 ffffffff8115fd30 ffff880238ef1290 0000000000000003
[  548.458831]  00000000af3b5f31 00000000ffffffff 0000000000000000 ffffffff8115fd30
[  548.459954]  ffff880238ef1290 0000000000000001 ffff8801fe70fcd0 ffffffff810f9b5a
[  548.461078] Call Trace:
[  548.462187]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  548.463310]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  548.464425]  [<ffffffff810f9b5a>] smp_call_function_single+0x6a/0xe0
[  548.465541]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  548.466656]  [<ffffffff8116036a>] perf_event_read+0xca/0xd0
[  548.467772]  [<ffffffff81160400>] perf_event_read_value+0x90/0xe0
[  548.468887]  [<ffffffff81161b1e>] perf_read+0x20e/0x360
[  548.470003]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  548.471127]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  548.472230]  [<ffffffff811dfdd3>] do_loop_readv_writev+0x63/0x90
[  548.473310]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  548.474375]  [<ffffffff811e1c97>] do_readv_writev+0x267/0x280
[  548.475432]  [<ffffffff81375a47>] ? debug_smp_processor_id+0x17/0x20
[  548.476470]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  548.477486]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[  548.478479]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  548.479452]  [<ffffffff817b1377>] ? _raw_spin_unlock_irq+0x37/0x60
[  548.480402]  [<ffffffff810e672a>] ? do_setitimer+0x1ca/0x250
[  548.481346]  [<ffffffff811e1ce9>] vfs_readv+0x39/0x50
[  548.482266]  [<ffffffff811e1dac>] SyS_readv+0x5c/0x100
[  548.483164]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  548.484050] Code: 48 89 de 48 03 14 c5 e0 af d1 81 48 89 df e8 5a 47 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 4d d0 65 48 33 0c 25 28 00 00 00 0f 85 8e 00 
[  548.485991] NMI backtrace for cpu 2
[  548.486903] CPU: 2 PID: 20160 Comm: trinity-c156 Tainted: G             L 3.17.0-rc1+ #112
[  548.488787] task: ffff88006b945bc0 ti: ffff880062d68000 task.ti: ffff880062d68000
[  548.489743] RIP: 0010:[<ffffffff810f99da>]  [<ffffffff810f99da>] generic_exec_single+0xea/0x1a0
[  548.490709] RSP: 0018:ffff880062d6bc40  EFLAGS: 00000202
[  548.491667] RAX: ffff8801fe70fc00 RBX: ffff880062d6bc40 RCX: ffff8801fe70fc40
[  548.492629] RDX: ffff8802441d4c00 RSI: ffff880062d6bc40 RDI: ffff880062d6bc40
[  548.493590] RBP: ffff880062d6bc90 R08: 0000000000000001 R09: 0000000000000001
[  548.494553] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  548.495511] R13: 0000000000000001 R14: ffff880238ef5cd0 R15: ffffffff8115fd30
[  548.496462] FS:  00007f6a24fd0740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[  548.497423] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  548.498382] CR2: 00000000019ca288 CR3: 000000007a7bb000 CR4: 00000000001407e0
[  548.499347] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  548.500305] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  548.501264] Stack:
[  548.502193]  ffff8801fe70fc40 ffffffff8115fd30 ffff880238ef5cd0 0000000000000003
[  548.503131]  000000008b5d668d 00000000ffffffff 0000000000000000 ffffffff8115fd30
[  548.504073]  ffff880238ef5cd0 0000000000000001 ffff880062d6bcd0 ffffffff810f9b5a
[  548.505015] Call Trace:
[  548.505940]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  548.506857]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  548.507753]  [<ffffffff810f9b5a>] smp_call_function_single+0x6a/0xe0
[  548.508639]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  548.509518]  [<ffffffff8116036a>] perf_event_read+0xca/0xd0
[  548.510391]  [<ffffffff81160400>] perf_event_read_value+0x90/0xe0
[  548.511261]  [<ffffffff81161b1e>] perf_read+0x20e/0x360
[  548.512130]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  548.513005]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  548.513877]  [<ffffffff811dfdd3>] do_loop_readv_writev+0x63/0x90
[  548.514740]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  548.515600]  [<ffffffff811e1c97>] do_readv_writev+0x267/0x280
[  548.516451]  [<ffffffff81375a47>] ? debug_smp_processor_id+0x17/0x20
[  548.517313]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  548.518177]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[  548.519031]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  548.519878]  [<ffffffff817b1377>] ? _raw_spin_unlock_irq+0x37/0x60
[  548.520719]  [<ffffffff810e672a>] ? do_setitimer+0x1ca/0x250
[  548.521563]  [<ffffffff811e1ce9>] vfs_readv+0x39/0x50
[  548.522397]  [<ffffffff811e1dac>] SyS_readv+0x5c/0x100
[  548.523224]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  548.524052] Code: 00 4c 1d 00 48 89 de 48 03 14 c5 e0 af d1 81 48 89 df e8 5a 47 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 <f6> 43 18 01 75 f8 31 c0 48 8b 4d d0 65 48 33 0c 25 28 00 00 00 
[  548.525897] NMI backtrace for cpu 1
[  548.526765] CPU: 1 PID: 20241 Comm: trinity-c237 Tainted: G             L 3.17.0-rc1+ #112
[  548.528575] task: ffff8801e32c16f0 ti: ffff88008696c000 task.ti: ffff88008696c000
[  548.529499] RIP: 0010:[<ffffffff810f99de>]  [<ffffffff810f99de>] generic_exec_single+0xee/0x1a0
[  548.530433] RSP: 0018:ffff88008696fc40  EFLAGS: 00000202
[  548.531363] RAX: ffff880062d6bc00 RBX: ffff88008696fc40 RCX: ffff880062d6bc40
[  548.532305] RDX: ffff8802441d4c00 RSI: ffff88008696fc40 RDI: ffff88008696fc40
[  548.533244] RBP: ffff88008696fc90 R08: 0000000000000001 R09: 0000000000000001
[  548.534181] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  548.535114] R13: 0000000000000001 R14: ffff880238ef1bd8 R15: ffffffff8115fd30
[  548.536048] FS:  00007f6a24fd0740(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[  548.536995] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  548.537936] CR2: 0000000000000000 CR3: 00000000869c1000 CR4: 00000000001407e0
[  548.538888] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  548.539842] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  548.540795] Stack:
[  548.541745]  ffff880062d6bc40 ffffffff8115fd30 ffff880238ef1bd8 0000000000000003
[  548.542699]  00000000d88cff08 00000000ffffffff 0000000000000000 ffffffff8115fd30
[  548.543640]  ffff880238ef1bd8 0000000000000001 ffff88008696fcd0 ffffffff810f9b5a
[  548.544574] Call Trace:
[  548.545491]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  548.546404]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  548.547297]  [<ffffffff810f9b5a>] smp_call_function_single+0x6a/0xe0
[  548.548179]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  548.549053]  [<ffffffff8116036a>] perf_event_read+0xca/0xd0
[  548.549920]  [<ffffffff81160400>] perf_event_read_value+0x90/0xe0
[  548.550789]  [<ffffffff81161b1e>] perf_read+0x20e/0x360
[  548.551651]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  548.552520]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  548.553388]  [<ffffffff811dfdd3>] do_loop_readv_writev+0x63/0x90
[  548.554247]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  548.555103]  [<ffffffff811e1c97>] do_readv_writev+0x267/0x280
[  548.555952]  [<ffffffff81375a47>] ? debug_smp_processor_id+0x17/0x20
[  548.556809]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  548.557665]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[  548.558511]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  548.559352]  [<ffffffff817b1377>] ? _raw_spin_unlock_irq+0x37/0x60
[  548.560189]  [<ffffffff810e672a>] ? do_setitimer+0x1ca/0x250
[  548.561021]  [<ffffffff811e1ce9>] vfs_readv+0x39/0x50
[  548.561847]  [<ffffffff811e1dac>] SyS_readv+0x5c/0x100
[  548.562664]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  548.563483] Code: 48 89 de 48 03 14 c5 e0 af d1 81 48 89 df e8 5a 47 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 4d d0 65 48 33 0c 25 28 00 00 00 0f 85 8e 00 
[  564.237567] INFO: rcu_preempt self-detected stall on CPU
[  564.238434] 	0: (23495594 ticks this GP) idle=ee5/140000000000001/0 softirq=31067/31067 
[  564.239318] 	 (t=6000 jiffies g=12425 c=12424 q=0)
[  564.240203] Task dump for CPU 0:
[  564.241078] trinity-c178    R  running task    13424 20182  19467 0x10000008
[  564.241975]  ffff8801cd63c4d0 00000000a417dc9d ffff880244003dc8 ffffffff810a4406
[  564.242880]  ffffffff810a4372 0000000000000000 ffffffff81c50240 0000000000000086
[  564.243789]  ffff880244003de0 ffffffff810a83e9 0000000000000001 ffff880244003e10
[  564.244697] Call Trace:
[  564.245597]  <IRQ>  [<ffffffff810a4406>] sched_show_task+0x116/0x180
[  564.246511]  [<ffffffff810a4372>] ? sched_show_task+0x82/0x180
[  564.247420]  [<ffffffff810a83e9>] dump_cpu_task+0x39/0x40
[  564.248337]  [<ffffffff810d6360>] rcu_dump_cpu_stacks+0xa0/0xe0
[  564.249247]  [<ffffffff810ddba3>] rcu_check_callbacks+0x503/0x810
[  564.250155]  [<ffffffff81375a63>] ? __this_cpu_preempt_check+0x13/0x20
[  564.251069]  [<ffffffff810e5c93>] ? hrtimer_run_queues+0x43/0x130
[  564.251985]  [<ffffffff810e43e7>] update_process_times+0x47/0x70
[  564.252902]  [<ffffffff810f4c8a>] tick_sched_timer+0x4a/0x1a0
[  564.253796]  [<ffffffff810e4a71>] ? __run_hrtimer+0x81/0x250
[  564.254671]  [<ffffffff810e4a71>] __run_hrtimer+0x81/0x250
[  564.255541]  [<ffffffff810f4c40>] ? tick_init_highres+0x20/0x20
[  564.256404]  [<ffffffff810e5697>] hrtimer_interrupt+0x107/0x260
[  564.257251]  [<ffffffff81031cc4>] local_apic_timer_interrupt+0x34/0x60
[  564.258086]  [<ffffffff817b4b8f>] smp_apic_timer_interrupt+0x3f/0x60
[  564.258907]  [<ffffffff817b2faf>] apic_timer_interrupt+0x6f/0x80
[  564.259721]  <EOI>  [<ffffffff817b2c64>] ? retint_restore_args+0xe/0xe
[  564.260541]  [<ffffffff8136968d>] ? copy_user_handle_tail+0x6d/0x90
[  564.261360]  [<ffffffff812e4a85>] SyS_add_key+0xd5/0x240
[  564.262176]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  572.432766] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [trinity-c156:20160]
[  572.433593] Modules linked in: fuse tun rfcomm llc2 af_key nfnetlink scsi_transport_iscsi can_bcm bnep can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm nfsd auth_rpcgss oid_registry nfs_acl lockd sunrpc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec crct10dif_pclmul crc32c_intel ghash_clmulni_intel e1000e snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer microcode snd serio_raw pcspkr usb_debug ptp pps_core shpchp soundcore
[  572.438194] CPU: 2 PID: 20160 Comm: trinity-c156 Tainted: G             L 3.17.0-rc1+ #112
[  572.440070] task: ffff88006b945bc0 ti: ffff880062d68000 task.ti: ffff880062d68000
[  572.441020] RIP: 0010:[<ffffffff810f99de>]  [<ffffffff810f99de>] generic_exec_single+0xee/0x1a0
[  572.441982] RSP: 0018:ffff880062d6bc40  EFLAGS: 00000202
[  572.442935] RAX: ffff8801fe70fc00 RBX: ffffffff817b2c64 RCX: ffff8801fe70fc40
[  572.443898] RDX: ffff8802441d4c00 RSI: ffff880062d6bc40 RDI: ffff880062d6bc40
[  572.444868] RBP: ffff880062d6bc90 R08: 0000000000000001 R09: 0000000000000001
[  572.445836] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880062d6bbb8
[  572.446808] R13: 0000000000406040 R14: ffff880062d68000 R15: ffff88006b945bc0
[  572.447777] FS:  00007f6a24fd0740(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[  572.448759] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  572.449742] CR2: 00000000019ca288 CR3: 000000007a7bb000 CR4: 00000000001407e0
[  572.450733] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  572.451722] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  572.452710] Stack:
[  572.453692]  ffff8801fe70fc40 ffffffff8115fd30 ffff880238ef5cd0 0000000000000003
[  572.454698]  000000008b5d668d 00000000ffffffff 0000000000000000 ffffffff8115fd30
[  572.455712]  ffff880238ef5cd0 0000000000000001 ffff880062d6bcd0 ffffffff810f9b5a
[  572.456721] Call Trace:
[  572.457721]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  572.458732]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  572.459736]  [<ffffffff810f9b5a>] smp_call_function_single+0x6a/0xe0
[  572.460745]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  572.461748]  [<ffffffff8116036a>] perf_event_read+0xca/0xd0
[  572.462763]  [<ffffffff81160400>] perf_event_read_value+0x90/0xe0
[  572.463776]  [<ffffffff81161b1e>] perf_read+0x20e/0x360
[  572.464765]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  572.465738]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  572.466709]  [<ffffffff811dfdd3>] do_loop_readv_writev+0x63/0x90
[  572.467669]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  572.468627]  [<ffffffff811e1c97>] do_readv_writev+0x267/0x280
[  572.469586]  [<ffffffff81375a47>] ? debug_smp_processor_id+0x17/0x20
[  572.470543]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  572.471493]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[  572.472442]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  572.473386]  [<ffffffff817b1377>] ? _raw_spin_unlock_irq+0x37/0x60
[  572.474322]  [<ffffffff810e672a>] ? do_setitimer+0x1ca/0x250
[  572.475260]  [<ffffffff811e1ce9>] vfs_readv+0x39/0x50
[  572.476186]  [<ffffffff811e1dac>] SyS_readv+0x5c/0x100
[  572.477112]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  572.478038] Code: 48 89 de 48 03 14 c5 e0 af d1 81 48 89 df e8 5a 47 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 4d d0 65 48 33 0c 25 28 00 00 00 0f 85 8e 00 
[  572.480077] sending NMI to other CPUs:
[  572.481045] NMI backtrace for cpu 1
[  572.482011] CPU: 1 PID: 20241 Comm: trinity-c237 Tainted: G             L 3.17.0-rc1+ #112
[  572.484001] task: ffff8801e32c16f0 ti: ffff88008696c000 task.ti: ffff88008696c000
[  572.485020] RIP: 0010:[<ffffffff810f99de>]  [<ffffffff810f99de>] generic_exec_single+0xee/0x1a0
[  572.486053] RSP: 0018:ffff88008696fc40  EFLAGS: 00000202
[  572.487084] RAX: ffff880062d6bc00 RBX: ffff88008696fc40 RCX: ffff880062d6bc40
[  572.488124] RDX: ffff8802441d4c00 RSI: ffff88008696fc40 RDI: ffff88008696fc40
[  572.489163] RBP: ffff88008696fc90 R08: 0000000000000001 R09: 0000000000000001
[  572.490199] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  572.491231] R13: 0000000000000001 R14: ffff880238ef1bd8 R15: ffffffff8115fd30
[  572.492262] FS:  00007f6a24fd0740(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[  572.493299] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  572.494343] CR2: 0000000000000000 CR3: 00000000869c1000 CR4: 00000000001407e0
[  572.495380] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  572.496396] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  572.497393] Stack:
[  572.498357]  ffff880062d6bc40 ffffffff8115fd30 ffff880238ef1bd8 0000000000000003
[  572.499325]  00000000d88cff08 00000000ffffffff 0000000000000000 ffffffff8115fd30
[  572.500276]  ffff880238ef1bd8 0000000000000001 ffff88008696fcd0 ffffffff810f9b5a
[  572.501223] Call Trace:
[  572.502140]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  572.503053]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  572.503947]  [<ffffffff810f9b5a>] smp_call_function_single+0x6a/0xe0
[  572.504837]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  572.505720]  [<ffffffff8116036a>] perf_event_read+0xca/0xd0
[  572.506600]  [<ffffffff81160400>] perf_event_read_value+0x90/0xe0
[  572.507477]  [<ffffffff81161b1e>] perf_read+0x20e/0x360
[  572.508350]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  572.509229]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  572.510102]  [<ffffffff811dfdd3>] do_loop_readv_writev+0x63/0x90
[  572.510968]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  572.511828]  [<ffffffff811e1c97>] do_readv_writev+0x267/0x280
[  572.512689]  [<ffffffff81375a47>] ? debug_smp_processor_id+0x17/0x20
[  572.513556]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  572.514413]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[  572.515267]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  572.516114]  [<ffffffff817b1377>] ? _raw_spin_unlock_irq+0x37/0x60
[  572.516958]  [<ffffffff810e672a>] ? do_setitimer+0x1ca/0x250
[  572.517794]  [<ffffffff811e1ce9>] vfs_readv+0x39/0x50
[  572.518627]  [<ffffffff811e1dac>] SyS_readv+0x5c/0x100
[  572.519462]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  572.520291] Code: 48 89 de 48 03 14 c5 e0 af d1 81 48 89 df e8 5a 47 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 4d d0 65 48 33 0c 25 28 00 00 00 0f 85 8e 00 
[  572.522141] NMI backtrace for cpu 3
[  572.523018] CPU: 3 PID: 20165 Comm: trinity-c161 Tainted: G             L 3.17.0-rc1+ #112
[  572.524827] task: ffff8801fe67dbc0 ti: ffff8801fe70c000 task.ti: ffff8801fe70c000
[  572.525748] RIP: 0010:[<ffffffff810f99de>]  [<ffffffff810f99de>] generic_exec_single+0xee/0x1a0
[  572.526677] RSP: 0018:ffff8801fe70fc40  EFLAGS: 00000202
[  572.527605] RAX: 0000000000000000 RBX: ffff8801fe70fc40 RCX: 0000000000000038
[  572.528545] RDX: 00000000000000ff RSI: 0000000000000008 RDI: 0000000000000000
[  572.529480] RBP: ffff8801fe70fc90 R08: ffff880242bfa3f0 R09: 0000000000000000
[  572.530416] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  572.531350] R13: 0000000000000001 R14: ffff880238ef1290 R15: ffffffff8115fd30
[  572.532287] FS:  00007f6a24fd0740(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[  572.533230] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  572.534174] CR2: 00007f6a23446001 CR3: 00000001cd627000 CR4: 00000000001407e0
[  572.535133] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  572.536091] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  572.537048] Stack:
[  572.537979]  0000000000000000 ffffffff8115fd30 ffff880238ef1290 0000000000000003
[  572.538915]  00000000af3b5f31 00000000ffffffff 0000000000000000 ffffffff8115fd30
[  572.539850]  ffff880238ef1290 0000000000000001 ffff8801fe70fcd0 ffffffff810f9b5a
[  572.540790] Call Trace:
[  572.541711]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  572.542629]  [<ffffffff8115fd30>] ? perf_duration_warn+0x70/0x70
[  572.543522]  [<ffffffff810f9b5a>] smp_call_function_single+0x6a/0xe0
[  572.544408]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  572.545285]  [<ffffffff8116036a>] perf_event_read+0xca/0xd0
[  572.546154]  [<ffffffff81160400>] perf_event_read_value+0x90/0xe0
[  572.547027]  [<ffffffff81161b1e>] perf_read+0x20e/0x360
[  572.547890]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  572.548765]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  572.549637]  [<ffffffff811dfdd3>] do_loop_readv_writev+0x63/0x90
[  572.550497]  [<ffffffff81161910>] ? cpu_clock_event_init+0x40/0x40
[  572.551353]  [<ffffffff811e1c97>] do_readv_writev+0x267/0x280
[  572.552210]  [<ffffffff81375a47>] ? debug_smp_processor_id+0x17/0x20
[  572.553066]  [<ffffffff810bffc6>] ? lock_release_holdtime.part.24+0xe6/0x160
[  572.553924]  [<ffffffff810a2c5d>] ? get_parent_ip+0xd/0x50
[  572.554775]  [<ffffffff810a2dbb>] ? preempt_count_sub+0x6b/0xf0
[  572.555618]  [<ffffffff817b1377>] ? _raw_spin_unlock_irq+0x37/0x60
[  572.556453]  [<ffffffff810e672a>] ? do_setitimer+0x1ca/0x250
[  572.557284]  [<ffffffff811e1ce9>] vfs_readv+0x39/0x50
[  572.558111]  [<ffffffff811e1dac>] SyS_readv+0x5c/0x100
[  572.558934]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  572.559756] Code: 48 89 de 48 03 14 c5 e0 af d1 81 48 89 df e8 5a 47 27 00 84 c0 75 46 45 85 ed 74 11 f6 43 18 01 74 0b 0f 1f 00 f3 90 f6 43 18 01 <75> f8 31 c0 48 8b 4d d0 65 48 33 0c 25 28 00 00 00 0f 85 8e 00 
[  572.561589] NMI backtrace for cpu 0
[  572.562451] CPU: 0 PID: 20182 Comm: trinity-c178 Tainted: G             L 3.17.0-rc1+ #112
[  572.564252] task: ffff8801cd63c4d0 ti: ffff8801d2138000 task.ti: ffff8801d2138000
[  572.565166] RIP: 0010:[<ffffffff8103cc16>]  [<ffffffff8103cc16>] read_hpet+0x16/0x20
[  572.566090] RSP: 0018:ffff880244003e70  EFLAGS: 00000046
[  572.567011] RAX: 00000000e8dd201c RBX: 000000000001cc86 RCX: ffff8802441d1118
[  572.567939] RDX: 0000000000010001 RSI: ffffffff81a86870 RDI: ffffffff81c28680
[  572.568869] RBP: ffff880244003e70 R08: 0000000000000000 R09: 0000000000000000
[  572.569802] R10: 0000000000000000 R11: 0000000000000000 R12: 000000854428057e
[  572.570732] R13: ffff8802441ce060 R14: ffff8802441cda80 R15: 0000008baf2377a5
[  572.571665] FS:  00007f6a24fd0740(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
[  572.572608] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  572.573555] CR2: 00007f6a24fe0000 CR3: 00000002053c8000 CR4: 00000000001407f0
[  572.574508] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  572.575459] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  572.576414] Stack:
[  572.577362]  ffff880244003e98 ffffffff810eb574 ffffffff810f4c63 ffff8801d213be58
[  572.578323]  ffff880244003f40 ffff880244003ec8 ffffffff810f4c63 ffff8802441cda80
[  572.579255]  ffff8802441ce060 ffff880244003f40 ffff8802441cdb08 ffff880244003f08
[  572.580181] Call Trace:
[  572.581092]  <IRQ> 

[  572.581988]  [<ffffffff810eb574>] ktime_get+0x94/0x120
[  572.582865]  [<ffffffff810f4c63>] ? tick_sched_timer+0x23/0x1a0
[  572.583735]  [<ffffffff810f4c63>] tick_sched_timer+0x23/0x1a0
[  572.584592]  [<ffffffff810e4a71>] __run_hrtimer+0x81/0x250
[  572.585447]  [<ffffffff810f4c40>] ? tick_init_highres+0x20/0x20
[  572.586297]  [<ffffffff810e5697>] hrtimer_interrupt+0x107/0x260
[  572.587148]  [<ffffffff81031cc4>] local_apic_timer_interrupt+0x34/0x60
[  572.588004]  [<ffffffff817b4b8f>] smp_apic_timer_interrupt+0x3f/0x60
[  572.588859]  [<ffffffff817b2faf>] apic_timer_interrupt+0x6f/0x80
[  572.589705]  <EOI> 

[  572.590542]  [<ffffffff817b2c64>] ? retint_restore_args+0xe/0xe
[  572.591379]  [<ffffffff8136968d>] ? copy_user_handle_tail+0x6d/0x90
[  572.592225]  [<ffffffff812e4a85>] SyS_add_key+0xd5/0x240
[  572.593071]  [<ffffffff817b2264>] tracesys+0xdd/0xe2
[  572.593901] Code: 00 29 c7 ba 00 00 00 00 b8 c2 ff ff ff 83 ff 7f 5d 0f 4f c2 c3 0f 1f 44 00 00 55 48 8b 05 a3 0c 0b 01 48 89 e5 8b 80 f0 00 00 00 <89> c0 5d c3 66 0f 1f 44 00 00 0f 1f 44 00 00 8b 0d d9 0b 0b 01 
[  599.566886] [sched_delayed] sched: RT throttling activated
[  599.573324] end_request: I/O error, dev sda, sector 0
[  624.402393] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 23s! [swapper/2:0]
[  624.403521] Modules linked in: fuse tun rfcomm llc2 af_key nfnetlink scsi_transport_iscsi can_bcm bnep can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm nfsd auth_rpcgss oid_registry nfs_acl lockd sunrpc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec crct10dif_pclmul crc32c_intel ghash_clmulni_intel e1000e snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer microcode snd serio_raw pcspkr usb_debug ptp pps_core shpchp soundcore
[  624.409477] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.17.0-rc1+ #112
[  624.411931] task: ffff880242b744d0 ti: ffff880242414000 task.ti: ffff880242414000
[  624.413170] RIP: 0010:[<ffffffff81645849>]  [<ffffffff81645849>] cpuidle_enter_state+0x79/0x1c0
[  624.414396] RSP: 0018:ffff880242417e60  EFLAGS: 00000246
[  624.415614] RAX: 0000000000000000 RBX: ffff880242b744d0 RCX: 0000000000000019
[  624.416843] RDX: 20c49ba5e353f7cf RSI: 000000000003cd60 RDI: 002e512580cfca6e
[  624.418074] RBP: ffff880242417e98 R08: 000000008bafc4e0 R09: 0000000000000000
[  624.419397] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880242417df0
[  624.420626] R13: ffffffff810bfc5e R14: ffff880242417dd0 R15: 0000000000000210
[  624.421864] FS:  0000000000000000(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[  624.423132] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  624.424380] CR2: 00007f15cfbaf000 CR3: 0000000001c11000 CR4: 00000000001407e0
[  624.425640] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  624.426904] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  624.428164] Stack:
[  624.429393]  0000009177337316 ffffffff81cae7f0 ffffffff81d1d290 ffffe8ffff204da8
[  624.430630]  ffff880242414000 ffffffff81cae620 ffff880242414000 ffff880242417ea8
[  624.431865]  ffffffff81645a47 ffff880242417f10 ffffffff810b9fb4 ffff880242417fd8
[  624.433085] Call Trace:
[  624.434242]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[  624.435413]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[  624.436588]  [<ffffffff8102ff37>] start_secondary+0x237/0x340
[  624.437761] Code: d0 48 89 df ff 50 48 41 89 c5 e8 b3 5c aa ff 44 8b 63 04 49 89 c7 0f 1f 44 00 00 e8 a2 19 b0 ff fb 48 ba cf f7 53 e3 a5 9b c4 20 <4c> 2b 7d c8 4c 89 f8 49 c1 ff 3f 48 f7 ea b8 ff ff ff 7f 48 c1 
[  624.440251] sending NMI to other CPUs:
[  624.441500] NMI backtrace for cpu 1
[  624.442624] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G             L 3.17.0-rc1+ #112
[  624.444912] task: ffff880242b716f0 ti: ffff88024240c000 task.ti: ffff88024240c000
[  624.446070] RIP: 0010:[<ffffffff813c9e65>]  [<ffffffff813c9e65>] intel_idle+0xd5/0x180
[  624.447236] RSP: 0018:ffff88024240fe20  EFLAGS: 00000046
[  624.448397] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  624.449570] RDX: 0000000000000000 RSI: ffff88024240ffd8 RDI: 0000000000000001
[  624.450735] RBP: ffff88024240fe50 R08: 000000008bafc4e0 R09: 0000000000000000
[  624.451894] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[  624.453053] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024240c000
[  624.454213] FS:  0000000000000000(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[  624.455369] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  624.456531] CR2: 0000000000497120 CR3: 0000000001c11000 CR4: 00000000001407e0
[  624.457707] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  624.458881] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  624.460056] Stack:
[  624.461220]  000000014240c000 0d2996f8aba02290 ffffe8ffff004da8 0000000000000005
[  624.462418]  ffffffff81cae620 0000000000000001 ffff88024240fe98 ffffffff81645825
[  624.463622]  000000917994f078 ffffffff81cae7f0 ffffffff81d1d290 ffffe8ffff004da8
[  624.464826] Call Trace:
[  624.466015]  [<ffffffff81645825>] cpuidle_enter_state+0x55/0x1c0
[  624.467220]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[  624.468415]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[  624.469607]  [<ffffffff8102ff37>] start_secondary+0x237/0x340
[  624.470800] Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[  624.473394] NMI backtrace for cpu 0
[  624.474616] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.17.0-rc1+ #112
[  624.477061] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[  624.478299] RIP: 0010:[<ffffffff813c9e65>]  [<ffffffff813c9e65>] intel_idle+0xd5/0x180
[  624.479544] RSP: 0018:ffffffff81c03e68  EFLAGS: 00000046
[  624.480766] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  624.481964] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[  624.483137] RBP: ffffffff81c03e98 R08: 000000008bafc4e0 R09: 0000000000000000
[  624.484284] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[  624.485403] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[  624.486516] FS:  0000000000000000(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
[  624.487613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  624.488690] CR2: 00007fd405db1000 CR3: 0000000001c11000 CR4: 00000000001407f0
[  624.489768] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  624.490837] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  624.491894] Stack:
[  624.492941]  0000000081c00000 b6e98a804d03933a ffffe8fffee04da8 0000000000000005
[  624.494017]  ffffffff81cae620 0000000000000000 ffffffff81c03ee0 ffffffff81645825
[  624.495096]  000000917a0eca81 ffffffff81cae7f0 ffffffff81d1d290 ffffe8fffee04da8
[  624.496174] Call Trace:
[  624.497229]  [<ffffffff81645825>] cpuidle_enter_state+0x55/0x1c0
[  624.498294]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[  624.499348]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[  624.500403]  [<ffffffff8179d7a0>] rest_init+0xc0/0xd0
[  624.501458]  [<ffffffff8179d6e5>] ? rest_init+0x5/0xd0
[  624.502507]  [<ffffffff81eff009>] start_kernel+0x475/0x496
[  624.503549]  [<ffffffff81efe98d>] ? set_init_arg+0x53/0x53
[  624.504585]  [<ffffffff81efe57b>] x86_64_start_reservations+0x2a/0x2c
[  624.505627]  [<ffffffff81efe66e>] x86_64_start_kernel+0xf1/0xf4
[  624.506655] Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[  624.508927] NMI backtrace for cpu 3
[  624.510061] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.17.0-rc1+ #112
[  624.512303] task: ffff880242b72de0 ti: ffff880242418000 task.ti: ffff880242418000
[  624.513284] RIP: 0010:[<ffffffff813c9e65>]  [<ffffffff813c9e65>] intel_idle+0xd5/0x180
[  624.514281] RSP: 0000:ffff88024241be20  EFLAGS: 00000046
[  624.515289] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  624.516286] RDX: 0000000000000000 RSI: ffff88024241bfd8 RDI: 0000000000000003
[  624.517264] RBP: ffff88024241be50 R08: 000000008bafc4e0 R09: 0000000000000000
[  624.518235] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[  624.519205] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242418000
[  624.520169] FS:  0000000000000000(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[  624.521142] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  624.522100] CR2: 00000000013a4738 CR3: 0000000001c11000 CR4: 00000000001407e0
[  624.523105] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  624.524063] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  624.525039] Stack:
[  624.526003]  0000000342418000 1e8c3d4850bfa337 ffffe8ffff404da8 0000000000000005
[  624.526991]  ffffffff81cae620 0000000000000003 ffff88024241be98 ffffffff81645825
[  624.527953]  000000917994f2a7 ffffffff81cae7f0 ffffffff81d1d290 ffffe8ffff404da8
[  624.528926] Call Trace:
[  624.529911]  [<ffffffff81645825>] cpuidle_enter_state+0x55/0x1c0
[  624.530911]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[  624.531883]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[  624.532905]  [<ffffffff8102ff37>] start_secondary+0x237/0x340
[  624.533877] Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[  652.386003] NMI watchdog: BUG: soft lockup - CPU#2 stuck for 22s! [swapper/2:0]
[  652.388580] Modules linked in: fuse tun rfcomm llc2 af_key nfnetlink scsi_transport_iscsi can_bcm bnep can_raw nfc caif_socket caif af_802154 ieee802154 phonet af_rxrpc bluetooth can pppoe pppox ppp_generic slhc irda crc_ccitt rds rose x25 atm netrom appletalk ipx p8023 psnap p8022 llc ax25 cfg80211 rfkill coretemp hwmon x86_pkg_temp_thermal kvm_intel kvm nfsd auth_rpcgss oid_registry nfs_acl lockd sunrpc snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_codec_generic snd_hda_intel snd_hda_controller snd_hda_codec crct10dif_pclmul crc32c_intel ghash_clmulni_intel e1000e snd_hwdep snd_seq snd_seq_device snd_pcm snd_timer microcode snd serio_raw pcspkr usb_debug ptp pps_core shpchp soundcore
[  652.394750] CPU: 2 PID: 0 Comm: swapper/2 Tainted: G             L 3.17.0-rc1+ #112
[  652.397225] task: ffff880242b744d0 ti: ffff880242414000 task.ti: ffff880242414000
[  652.398457] RIP: 0010:[<ffffffff81645849>]  [<ffffffff81645849>] cpuidle_enter_state+0x79/0x1c0
[  652.399711] RSP: 0018:ffff880242417e60  EFLAGS: 00000246
[  652.400953] RAX: 0000000000000000 RBX: ffff880242b744d0 RCX: 0000000000000019
[  652.402203] RDX: 20c49ba5e353f7cf RSI: 0000000000039e2e RDI: 002e6b0e8bd4c66e
[  652.403446] RBP: ffff880242417e98 R08: 000000008bafc4e0 R09: 0000000000000000
[  652.404695] R10: 0000000000000000 R11: 0000000000000000 R12: ffff880242417df0
[  652.405953] R13: ffffffff810bfc5e R14: ffff880242417dd0 R15: 00000000000001da
[  652.407176] FS:  0000000000000000(0000) GS:ffff880244400000(0000) knlGS:0000000000000000
[  652.408441] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  652.409679] CR2: 00007f15cfbaf000 CR3: 0000000001c11000 CR4: 00000000001407e0
[  652.410923] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  652.412173] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  652.413415] Stack:
[  652.414652]  00000097fc215a08 ffffffff81cae7f0 ffffffff81d1d290 ffffe8ffff204da8
[  652.415906]  ffff880242414000 ffffffff81cae620 ffff880242414000 ffff880242417ea8
[  652.417138]  ffffffff81645a47 ffff880242417f10 ffffffff810b9fb4 ffff880242417fd8
[  652.418379] Call Trace:
[  652.419637]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[  652.420917]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[  652.422192]  [<ffffffff8102ff37>] start_secondary+0x237/0x340
[  652.423462] Code: d0 48 89 df ff 50 48 41 89 c5 e8 b3 5c aa ff 44 8b 63 04 49 89 c7 0f 1f 44 00 00 e8 a2 19 b0 ff fb 48 ba cf f7 53 e3 a5 9b c4 20 <4c> 2b 7d c8 4c 89 f8 49 c1 ff 3f 48 f7 ea b8 ff ff ff 7f 48 c1 
[  652.426104] sending NMI to other CPUs:
[  652.427302] NMI backtrace for cpu 0
[  652.428449] CPU: 0 PID: 0 Comm: swapper/0 Tainted: G             L 3.17.0-rc1+ #112
[  652.430736] task: ffffffff81c164c0 ti: ffffffff81c00000 task.ti: ffffffff81c00000
[  652.431882] RIP: 0010:[<ffffffff813c9e65>]  [<ffffffff813c9e65>] intel_idle+0xd5/0x180
[  652.433036] RSP: 0018:ffffffff81c03e68  EFLAGS: 00000046
[  652.434181] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  652.435341] RDX: 0000000000000000 RSI: ffffffff81c03fd8 RDI: 0000000000000000
[  652.436491] RBP: ffffffff81c03e98 R08: 000000008bafc4e0 R09: 0000000000000000
[  652.437642] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[  652.438797] R13: 0000000000000032 R14: 0000000000000004 R15: ffffffff81c00000
[  652.439945] FS:  0000000000000000(0000) GS:ffff880244000000(0000) knlGS:0000000000000000
[  652.441093] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  652.442234] CR2: 00007f00bcc2c000 CR3: 0000000001c11000 CR4: 00000000001407f0
[  652.443388] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  652.444540] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  652.445680] Stack:
[  652.446808]  0000000081c00000 b6e98a804d03933a ffffe8fffee04da8 0000000000000005
[  652.447959]  ffffffff81cae620 0000000000000000 ffffffff81c03ee0 ffffffff81645825
[  652.449111]  00000097ff1f0b6f ffffffff81cae7f0 ffffffff81d1d290 ffffe8fffee04da8
[  652.450261] Call Trace:
[  652.451392]  [<ffffffff81645825>] cpuidle_enter_state+0x55/0x1c0
[  652.452539]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[  652.453682]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[  652.454825]  [<ffffffff8179d7a0>] rest_init+0xc0/0xd0
[  652.455942]  [<ffffffff8179d6e5>] ? rest_init+0x5/0xd0
[  652.457036]  [<ffffffff81eff009>] start_kernel+0x475/0x496
[  652.458123]  [<ffffffff81efe98d>] ? set_init_arg+0x53/0x53
[  652.459218]  [<ffffffff81efe57b>] x86_64_start_reservations+0x2a/0x2c
[  652.460320]  [<ffffffff81efe66e>] x86_64_start_kernel+0xf1/0xf4
[  652.461419] Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[  652.463812] NMI backtrace for cpu 3
[  652.464973] CPU: 3 PID: 0 Comm: swapper/3 Tainted: G             L 3.17.0-rc1+ #112
[  652.467190] task: ffff880242b72de0 ti: ffff880242418000 task.ti: ffff880242418000
[  652.468248] RIP: 0010:[<ffffffff813c9e65>]  [<ffffffff813c9e65>] intel_idle+0xd5/0x180
[  652.469309] RSP: 0018:ffff88024241be20  EFLAGS: 00000046
[  652.470336] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  652.471368] RDX: 0000000000000000 RSI: ffff88024241bfd8 RDI: 0000000000000003
[  652.472378] RBP: ffff88024241be50 R08: 000000008bafc4e0 R09: 0000000000000000
[  652.473383] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[  652.474378] R13: 0000000000000032 R14: 0000000000000004 R15: ffff880242418000
[  652.475366] FS:  0000000000000000(0000) GS:ffff880244600000(0000) knlGS:0000000000000000
[  652.476385] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  652.477389] CR2: 00000000013a4738 CR3: 0000000001c11000 CR4: 00000000001407e0
[  652.478379] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  652.479371] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  652.480366] Stack:
[  652.481327]  0000000342418000 1e8c3d4850bfa337 ffffe8ffff404da8 0000000000000005
[  652.482326]  ffffffff81cae620 0000000000000003 ffff88024241be98 ffffffff81645825
[  652.483326]  00000097ff1b9892 ffffffff81cae7f0 ffffffff81d1d290 ffffe8ffff404da8
[  652.484332] Call Trace:
[  652.485323]  [<ffffffff81645825>] cpuidle_enter_state+0x55/0x1c0
[  652.486345]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[  652.487338]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[  652.488335]  [<ffffffff8102ff37>] start_secondary+0x237/0x340
[  652.489322] Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 
[  652.491493] NMI backtrace for cpu 1
[  652.492553] CPU: 1 PID: 0 Comm: swapper/1 Tainted: G             L 3.17.0-rc1+ #112
[  652.494553] task: ffff880242b716f0 ti: ffff88024240c000 task.ti: ffff88024240c000
[  652.495559] RIP: 0010:[<ffffffff813c9e65>]  [<ffffffff813c9e65>] intel_idle+0xd5/0x180
[  652.496585] RSP: 0018:ffff88024240fe20  EFLAGS: 00000046
[  652.497569] RAX: 0000000000000032 RBX: 0000000000000010 RCX: 0000000000000001
[  652.498545] RDX: 0000000000000000 RSI: ffff88024240ffd8 RDI: 0000000000000001
[  652.499502] RBP: ffff88024240fe50 R08: 000000008bafc4e0 R09: 0000000000000000
[  652.500452] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000005
[  652.501398] R13: 0000000000000032 R14: 0000000000000004 R15: ffff88024240c000
[  652.502342] FS:  0000000000000000(0000) GS:ffff880244200000(0000) knlGS:0000000000000000
[  652.503290] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  652.504236] CR2: 00007fecce638ab8 CR3: 0000000001c11000 CR4: 00000000001407e0
[  652.505195] DR0: 00007f6670c66000 DR1: 0000000000000000 DR2: 0000000000000000
[  652.506202] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000600
[  652.507177] Stack:
[  652.508136]  000000014240c000 0d2996f8aba02290 ffffe8ffff004da8 0000000000000005
[  652.509122]  ffffffff81cae620 0000000000000001 ffff88024240fe98 ffffffff81645825
[  652.510113]  00000097ff1b96a9 ffffffff81cae7f0 ffffffff81d1d290 ffffe8ffff004da8
[  652.511130] Call Trace:
[  652.512121]  [<ffffffff81645825>] cpuidle_enter_state+0x55/0x1c0
[  652.513102]  [<ffffffff81645a47>] cpuidle_enter+0x17/0x20
[  652.514086]  [<ffffffff810b9fb4>] cpu_startup_entry+0x384/0x410
[  652.515078]  [<ffffffff8102ff37>] start_secondary+0x237/0x340
[  652.516085] Code: 31 d2 65 48 8b 34 25 08 ba 00 00 48 8d 86 38 c0 ff ff 48 89 d1 0f 01 c8 48 8b 86 38 c0 ff ff a8 08 75 08 b1 01 4c 89 e8 0f 01 c9 <65> 48 8b 0c 25 08 ba 00 00 f0 80 a1 3a c0 ff ff df 0f ae f0 48 



It kept spewing lockups over and over.
Something weird that jumped out to me was this:

[  599.573324] end_request: I/O error, dev sda, sector 0

User trinity was running under did not have permission
to read block device directly, so that's just.. creepy.
Hopefully not a sign of impending disk death.

	Dave

