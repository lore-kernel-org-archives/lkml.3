Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082AbaA1KxT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 05:53:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55473 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810AbaA1KxR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 05:53:17 -0500
Date: Tue, 28 Jan 2014 11:53:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Jan Kara <jack@suse.cz>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fanotify use after free.
In-Reply-To: <20140127234017.GA7868@quack.suse.cz>
Message-ID: <alpine.LNX.2.00.1401281151100.3763@pobox.suse.cz>
References: <20140122062730.GA25601@redhat.com> <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com> <20140122233622.GB27916@quack.suse.cz> <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com> <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
 <20140123150540.GD28796@quack.suse.cz> <alpine.LNX.2.00.1401231607120.581@pobox.suse.cz> <20140123235549.GA7363@quack.suse.cz> <alpine.LNX.2.00.1401240825470.581@pobox.suse.cz> <20140127234017.GA7868@quack.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Jan 2014, Jan Kara wrote:

>   Hum, still no luck with reproduction (either on physical machine or with
> KVM). Anyway, I've looked at the code again and the previous patch had a
> stupid bug (passing different pointer to fsnotify_destroy_event() than we
> should have), plus also the merging function in fanotify was too
> aggressive. Can you try the attached patch? It boots for me but that means
> nothing since I cannot reproduce the issue... Thanks!

I am attaching dmesg with the patch applied; I've removed irrelevant 
parts.

There is a GPF, followed by scheduling in atomic context, followed by slab 
corruption, followed by another scheduling while atomic and leak of 
preempt_count.

[    0.000000] Initializing cgroup subsys cpuset
[    5.081301] systemd-udevd[332]: starting version 195
[    5.083694] random: nonblocking pool is initialized
[    5.299400] systemd-journald[307]: Received SIGUSR1
[    5.625120] general protection fault: 0000 [#1] SMP 
[    5.626464] Modules linked in: acpi_cpufreq autofs4 uhci_hcd ehci_hcd i915 drm_kms_helper drm usbcore i2c_algo_bit usb_common button video edd fan processor ata_generic thermal thermal_sys
[    5.628008] CPU: 0 PID: 302 Comm: systemd-readahe Not tainted 3.13.0-03478-gae75a37 #1
[    5.628008] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[    5.628008] task: ffff8800364b04d0 ti: ffff8800734b8000 task.ti: ffff8800734b8000
[    5.628008] RIP: 0010:[<ffffffff810a51e7>]  [<ffffffff810a51e7>] do_raw_spin_lock+0x17/0x160
[    5.628008] RSP: 0018:ffff8800734b9c68  EFLAGS: 00010282
[    5.628008] RAX: ffff8800364b04d0 RBX: 6b6b6b6b6b6b6beb RCX: 0000000000000000
[    5.628008] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6beb
[    5.628008] RBP: ffff8800734b9c88 R08: 0000000000000002 R09: 0000000000000000
[    5.628008] R10: 0000000000000000 R11: 0000000000000000 R12: 6b6b6b6b6b6b6beb
[    5.628008] R13: ffff880035d0db28 R14: 0000000000000020 R15: ffff880037fffd50
[    5.628008] FS:  00007fd2f4728700(0000) GS:ffff88007c200000(0000) knlGS:0000000000000000
[    5.628008] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    5.628008] CR2: 00007fa7dc98c000 CR3: 0000000037f3b000 CR4: 00000000000007f0
[    5.628008] Stack:
[    5.628008]  6b6b6b6b6b6b6beb 6b6b6b6b6b6b6beb 6b6b6b6b6b6b6beb ffff880035d0db28
[    5.628008]  ffff8800734b9ca8 ffffffff8159c5ac ffffffff812fe111 6b6b6b6b6b6b6beb
[    5.628008]  ffff8800734b9cc8 ffffffff812fe111 ffff8800734b9cf8 6b6b6b6b6b6b6b6b
[    5.628008] Call Trace:
[    5.628008]  [<ffffffff8159c5ac>] _raw_spin_lock+0x3c/0x50
[    5.628008]  [<ffffffff812fe111>] ? lockref_put_or_lock+0x11/0x40
[    5.628008]  [<ffffffff812fe111>] lockref_put_or_lock+0x11/0x40
[    5.628008]  [<ffffffff811b1442>] dput+0x22/0x130
[    5.628008]  [<ffffffff811a3d45>] path_put+0x15/0x30
[    5.628008]  [<ffffffff811e0bcc>] fanotify_free_event+0x1c/0x40
[    5.628008]  [<ffffffff811dd7ac>] fsnotify_destroy_event+0x1c/0x30
[    5.628008]  [<ffffffff811e1052>] fanotify_handle_event+0x342/0x390
[    5.628008]  [<ffffffff811a3d4d>] ? path_put+0x1d/0x30
[    5.628008]  [<ffffffff811dd18b>] send_to_group+0xfb/0x180
[    5.628008]  [<ffffffff811dd290>] ? fsnotify+0x80/0x2d0
[    5.628008]  [<ffffffff811ab325>] ? do_filp_open+0x45/0xa0
[    5.628008]  [<ffffffff811dd3d4>] fsnotify+0x1c4/0x2d0
[    5.628008]  [<ffffffff811987ad>] do_sys_open+0x1ad/0x220
[    5.628008]  [<ffffffff812fdd7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    5.628008]  [<ffffffff81198859>] SyS_open+0x19/0x20
[    5.628008]  [<ffffffff815a5222>] system_call_fastpath+0x16/0x1b
[    5.628008] Code: 0d 7e 81 48 89 df e8 29 ff ff ff eb 94 0f 1f 80 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <81> 7f 04 ad 4e ad de 74 0c 48 c7 c6 b5 0d 7e 81 e8 f4 fe ff ff 
[    5.628008] RIP  [<ffffffff810a51e7>] do_raw_spin_lock+0x17/0x160
[    5.628008]  RSP <ffff8800734b9c68>
[    5.683491] ---[ end trace 5b4e9ae52ab9b0f6 ]---
[    5.685076] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:20
[    5.686578] in_atomic(): 1, irqs_disabled(): 0, pid: 302, name: systemd-readahe
[    5.688058] INFO: lockdep is turned off.
[    5.689503] CPU: 0 PID: 302 Comm: systemd-readahe Tainted: G      D      3.13.0-03478-gae75a37 #1
[    5.690966] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[    5.692464]  ffff8800364b04d0 ffff8800734b9a68 ffffffff8159703b ffff8800734b9a88
[    5.694027]  ffffffff8107f621 ffffffff81a3d000 ffff88003641c750 ffff8800734b9aa8
[    5.695555]  ffffffff8159b50f ffff8800364b04d0 ffff8800364b04d0 ffff8800734b9ad8
[    5.697111] Call Trace:
[    5.698595]  [<ffffffff8159703b>] dump_stack+0x72/0x87
[    5.700108]  [<ffffffff8107f621>] __might_sleep+0xe1/0x100
[    5.701623]  [<ffffffff8159b50f>] down_read+0x1f/0x60
[    5.703133]  [<ffffffff810627ff>] exit_signals+0x1f/0x140
[    5.704661]  [<ffffffff81079491>] ? blocking_notifier_call_chain+0x11/0x20
[    5.706105]  [<ffffffff81052844>] do_exit+0xb4/0x4b0
[    5.707470]  [<ffffffff8159e23c>] oops_end+0xdc/0xe0
[    5.708845]  [<ffffffff81005f86>] die+0x56/0x90
[    5.710229]  [<ffffffff8159dea2>] do_general_protection+0x162/0x170
[    5.711545]  [<ffffffff8159d40c>] ? restore_args+0x30/0x30
[    5.712883]  [<ffffffff8159d592>] general_protection+0x22/0x30
[    5.714213]  [<ffffffff810a51e7>] ? do_raw_spin_lock+0x17/0x160
[    5.715491]  [<ffffffff8159c5ac>] _raw_spin_lock+0x3c/0x50
[    5.716781]  [<ffffffff812fe111>] ? lockref_put_or_lock+0x11/0x40
[    5.718113]  [<ffffffff812fe111>] lockref_put_or_lock+0x11/0x40
[    5.719390]  [<ffffffff811b1442>] dput+0x22/0x130
[    5.720681]  [<ffffffff811a3d45>] path_put+0x15/0x30
[    5.721984]  [<ffffffff811e0bcc>] fanotify_free_event+0x1c/0x40
[    5.723243]  [<ffffffff811dd7ac>] fsnotify_destroy_event+0x1c/0x30
[    5.724507]  [<ffffffff811e1052>] fanotify_handle_event+0x342/0x390
[    5.725779]  [<ffffffff811a3d4d>] ? path_put+0x1d/0x30
[    5.727014]  [<ffffffff811dd18b>] send_to_group+0xfb/0x180
[    5.728258]  [<ffffffff811dd290>] ? fsnotify+0x80/0x2d0
[    5.729515]  [<ffffffff811ab325>] ? do_filp_open+0x45/0xa0
[    5.730734]  [<ffffffff811dd3d4>] fsnotify+0x1c4/0x2d0
[    5.731945]  [<ffffffff811987ad>] do_sys_open+0x1ad/0x220
[    5.733169]  [<ffffffff812fdd7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    5.734456]  [<ffffffff81198859>] SyS_open+0x19/0x20
[    5.735681]  [<ffffffff815a5222>] system_call_fastpath+0x16/0x1b
[    5.736933] note: systemd-readahe[302] exited with preempt_count 1
[    5.738378] BUG: scheduling while atomic: systemd-readahe/302/0x00000002
[    5.739652] INFO: lockdep is turned off.
[    5.740925] Modules linked in: acpi_cpufreq autofs4 uhci_hcd ehci_hcd i915 drm_kms_helper drm usbcore i2c_algo_bit usb_common button video edd fan processor ata_generic thermal thermal_sys
[    5.743781] CPU: 0 PID: 302 Comm: systemd-readahe Tainted: G      D      3.13.0-03478-gae75a37 #1
[    5.745231] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[    5.746708]  ffff88007c213a00 ffff8800734b96e8 ffffffff8159703b ffff8800734b9708
[    5.748190]  ffffffff810810f1 ffff88007c213a00 0000000000000000 ffff8800734b9838
[    5.749690]  ffffffff815978ac ffff8800734b9748 ffff8800734b9758 ffff8800734b8010
[    5.751161] Call Trace:
[    5.752635]  [<ffffffff8159703b>] dump_stack+0x72/0x87
[    5.754126]  [<ffffffff810810f1>] __schedule_bug+0x61/0x80
[    5.755551]  [<ffffffff815978ac>] __schedule+0xbc/0x7c0
[    5.756925]  [<ffffffff8105defc>] ? mod_timer+0x14c/0x1f0
[    5.758302]  [<ffffffff815980f4>] schedule+0x24/0x70
[    5.759632]  [<ffffffff81597215>] schedule_timeout+0x1c5/0x210
[    5.760982]  [<ffffffff8159915f>] ? wait_for_completion+0xcf/0x120
[    5.762327]  [<ffffffff810a0d8d>] ? trace_hardirqs_on+0xd/0x10
[    5.763630]  [<ffffffff81599167>] wait_for_completion+0xd7/0x120
[    5.764935]  [<ffffffff81083330>] ? try_to_wake_up+0x250/0x250
[    5.766261]  [<ffffffff810b93bf>] ? srcu_reschedule+0x4f/0xf0
[    5.767521]  [<ffffffff810b965c>] __synchronize_srcu+0xec/0x130
[    5.768775]  [<ffffffff810b96e0>] ? srcu_barrier+0x10/0x10
[    5.770059]  [<ffffffff810b96c8>] synchronize_srcu+0x18/0x20
[    5.771302]  [<ffffffff811ddbdd>] fsnotify_destroy_group+0x1d/0x40
[    5.772550]  [<ffffffff811dfdf1>] inotify_release+0x21/0x50
[    5.773814]  [<ffffffff8119b2dd>] __fput+0xbd/0x2b0
[    5.775055]  [<ffffffff8119b569>] ____fput+0x9/0x10
[    5.776311]  [<ffffffff81070f41>] task_work_run+0xb1/0xe0
[    5.777577]  [<ffffffff81052979>] do_exit+0x1e9/0x4b0
[    5.778803]  [<ffffffff8159e23c>] oops_end+0xdc/0xe0
[    5.780027]  [<ffffffff81005f86>] die+0x56/0x90
[    5.781264]  [<ffffffff8159dea2>] do_general_protection+0x162/0x170
[    5.782472]  [<ffffffff8159d40c>] ? restore_args+0x30/0x30
[    5.783687]  [<ffffffff8159d592>] general_protection+0x22/0x30
[    5.784917]  [<ffffffff810a51e7>] ? do_raw_spin_lock+0x17/0x160
[    5.786160]  [<ffffffff8159c5ac>] _raw_spin_lock+0x3c/0x50
[    5.787367]  [<ffffffff812fe111>] ? lockref_put_or_lock+0x11/0x40
[    5.788606]  [<ffffffff812fe111>] lockref_put_or_lock+0x11/0x40
[    5.789848]  [<ffffffff811b1442>] dput+0x22/0x130
[    5.791073]  [<ffffffff811a3d45>] path_put+0x15/0x30
[    5.792324]  [<ffffffff811e0bcc>] fanotify_free_event+0x1c/0x40
[    5.793589]  [<ffffffff811dd7ac>] fsnotify_destroy_event+0x1c/0x30
[    5.794809]  [<ffffffff811e1052>] fanotify_handle_event+0x342/0x390
[    5.796040]  [<ffffffff811a3d4d>] ? path_put+0x1d/0x30
[    5.797283]  [<ffffffff811dd18b>] send_to_group+0xfb/0x180
[    5.798505]  [<ffffffff811dd290>] ? fsnotify+0x80/0x2d0
[    5.799732]  [<ffffffff811ab325>] ? do_filp_open+0x45/0xa0
[    5.800970]  [<ffffffff811dd3d4>] fsnotify+0x1c4/0x2d0
[    5.802219]  [<ffffffff811987ad>] do_sys_open+0x1ad/0x220
[    5.803461]  [<ffffffff812fdd7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    5.804729]  [<ffffffff81198859>] SyS_open+0x19/0x20
[    5.805970]  [<ffffffff815a5222>] system_call_fastpath+0x16/0x1b
[ ... snip ... ]
[    5.968718] Slab corruption (Tainted: G      D W   ): fanotify_event_info start=ffff880035d2a798, len=64
[    5.968923] hub 7-0:1.0: USB hub found
[    5.971406] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[    5.972756] Last user: [<ffffffff811e0be4>](fanotify_free_event+0x34/0x40)
[    5.974098] 030: 6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b a5  kkkkkkkk....kkk.
[    5.974837] hub 7-0:1.0: 6 ports detected
[    5.976799] Prev obj: start=ffff880035d2a740, len=64
[    5.978189] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[    5.979526] Last user: [<ffffffff811e0be4>](fanotify_free_event+0x34/0x40)
[    5.980910] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    5.982307] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    5.983691] Next obj: start=ffff880035d2a7f0, len=64
[    5.985070] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[    5.986455] Last user: [<ffffffff811e0be4>](fanotify_free_event+0x34/0x40)
[    5.987835] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    5.989248] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[ ... snip ... ]
[    7.044083] usb 2-1: new full-speed USB device number 4 using uhci_hcd
[    7.131735] general protection fault: 0000 [#2] SMP 
[    7.131842] Slab corruption (Tainted: G      D W   ): fanotify_event_info start=ffff880035da5320, len=64
[    7.131844] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[    7.131850] Last user: [<ffffffff811e0be4>](fanotify_free_event+0x34/0x40)
[    7.131853] 030: 6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b a5  kkkkkkkk....kkk.
[    7.131854] Prev obj: start=ffff880035da52c8, len=64
[    7.131855] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[    7.131857] Last user: [<ffffffff811e0be4>](fanotify_free_event+0x34/0x40)
[    7.131859] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    7.131861] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    7.131862] Next obj: start=ffff880035da5378, len=64
[    7.131863] Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
[    7.131864] Last user: [<ffffffff811e0be4>](fanotify_free_event+0x34/0x40)
[    7.131866] 000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    7.131868] 010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
[    7.135045] Modules linked in: cpufreq_conservative cpufreq_userspace snd_hda_codec_conexant cpufreq_powersave snd_hda_codec_generic snd_hda_intel snd_hda_codec snd_hwdep snd_pcm thinkpad_acpi kvm_intel snd_seq iTCO_wdt iTCO_vendor_support kvm iwldvm mac80211 snd_timer snd_seq_device btusb bluetooth iwlwifi sg cfg80211 e1000e snd ptp pcspkr lpc_ich i2c_i801 mfd_core rfkill pps_core ehci_pci wmi soundcore battery ac tpm_tis tpm acpi_cpufreq autofs4 uhci_hcd ehci_hcd i915 drm_kms_helper drm usbcore i2c_algo_bit usb_common button video edd fan processor ata_generic thermal thermal_sys
[    7.135045] CPU: 1 PID: 757 Comm: grep Tainted: G      D W    3.13.0-03478-gae75a37 #1
[    7.135045] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[    7.135045] task: ffff8800362fddd0 ti: ffff880036d42000 task.ti: ffff880036d42000
[    7.135045] RIP: 0010:[<ffffffff810a51e7>]  [<ffffffff810a51e7>] do_raw_spin_lock+0x17/0x160
[    7.135045] RSP: 0018:ffff880036d43c68  EFLAGS: 00010282
[    7.135045] RAX: ffff8800362fddd0 RBX: 6b6b6b6b6b6b6beb RCX: 0000000000000000
[    7.135045] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6beb
[    7.135045] RBP: ffff880036d43c88 R08: 0000000000000002 R09: 0000000000000000
[    7.135045] R10: 0000000000000000 R11: 0000000000000000 R12: 6b6b6b6b6b6b6beb
[    7.135045] R13: ffff880035d0db28 R14: 0000000000000020 R15: ffff880037900310
[    7.135045] FS:  0000000000000000(0000) GS:ffff88007c280000(0000) knlGS:0000000000000000
[    7.135045] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.135045] CR2: 00007fff296c9f54 CR3: 0000000079067000 CR4: 00000000000007e0
[    7.135045] Stack:
[    7.135045]  6b6b6b6b6b6b6beb 6b6b6b6b6b6b6beb 6b6b6b6b6b6b6beb ffff880035d0db28
[    7.135045]  ffff880036d43ca8 ffffffff8159c5ac ffffffff812fe111 6b6b6b6b6b6b6beb
[    7.135045]  ffff880036d43cc8 ffffffff812fe111 ffff880036d43cf8 6b6b6b6b6b6b6b6b
[    7.135045] Call Trace:
[    7.135045]  [<ffffffff8159c5ac>] _raw_spin_lock+0x3c/0x50
[    7.135045]  [<ffffffff812fe111>] ? lockref_put_or_lock+0x11/0x40
[    7.135045]  [<ffffffff812fe111>] lockref_put_or_lock+0x11/0x40
[    7.135045]  [<ffffffff811b1442>] dput+0x22/0x130
[    7.135045]  [<ffffffff811a3d45>] path_put+0x15/0x30
[    7.135045]  [<ffffffff811e0bcc>] fanotify_free_event+0x1c/0x40
[    7.135045]  [<ffffffff811dd7ac>] fsnotify_destroy_event+0x1c/0x30
[    7.135045]  [<ffffffff811e1052>] fanotify_handle_event+0x342/0x390
[    7.135045]  [<ffffffff815a0c84>] ? __do_page_fault+0x2c4/0x480
[    7.135045]  [<ffffffff811dd18b>] send_to_group+0xfb/0x180
[    7.135045]  [<ffffffff811dd290>] ? fsnotify+0x80/0x2d0
[    7.135045]  [<ffffffff811ab325>] ? do_filp_open+0x45/0xa0
[    7.135045]  [<ffffffff811dd3d4>] fsnotify+0x1c4/0x2d0
[    7.135045]  [<ffffffff811987ad>] do_sys_open+0x1ad/0x220
[    7.135045]  [<ffffffff812fdd7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    7.135045]  [<ffffffff81198859>] SyS_open+0x19/0x20
[    7.135045]  [<ffffffff815a5222>] system_call_fastpath+0x16/0x1b
[    7.135045] Code: 0d 7e 81 48 89 df e8 29 ff ff ff eb 94 0f 1f 80 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <81> 7f 04 ad 4e ad de 74 0c 48 c7 c6 b5 0d 7e 81 e8 f4 fe ff ff 
[    7.135045] RIP  [<ffffffff810a51e7>] do_raw_spin_lock+0x17/0x160
[    7.135045]  RSP <ffff880036d43c68>
[    7.212496] ---[ end trace 5b4e9ae52ab9b0f7 ]---
[    7.214048] BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:20
[    7.214049] in_atomic(): 1, irqs_disabled(): 0, pid: 757, name: grep
[    7.214050] INFO: lockdep is turned off.
[    7.214051] CPU: 1 PID: 757 Comm: grep Tainted: G      D W    3.13.0-03478-gae75a37 #1
[    7.214052] Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
[    7.214055]  ffff8800362fddd0 ffff880036d43a68 ffffffff8159703b ffff880036d43a88
[    7.214057]  ffffffff8107f621 ffffffff81a3d000 ffff880037946cd0 ffff880036d43aa8
[    7.214059]  ffffffff8159b50f ffff8800362fddd0 ffff8800362fddd0 ffff880036d43ad8
[    7.214060] Call Trace:
[    7.214071]  [<ffffffff8159703b>] dump_stack+0x72/0x87
[    7.214074]  [<ffffffff8107f621>] __might_sleep+0xe1/0x100
[    7.214076]  [<ffffffff8159b50f>] down_read+0x1f/0x60
[    7.214079]  [<ffffffff810627ff>] exit_signals+0x1f/0x140
[    7.214083]  [<ffffffff81079491>] ? blocking_notifier_call_chain+0x11/0x20
[    7.214086]  [<ffffffff81052844>] do_exit+0xb4/0x4b0
[    7.214089]  [<ffffffff8159e23c>] oops_end+0xdc/0xe0
[    7.214092]  [<ffffffff81005f86>] die+0x56/0x90
[    7.214095]  [<ffffffff8159dea2>] do_general_protection+0x162/0x170
[    7.214097]  [<ffffffff8159d40c>] ? restore_args+0x30/0x30
[    7.214099]  [<ffffffff8159d592>] general_protection+0x22/0x30
[    7.214102]  [<ffffffff810a51e7>] ? do_raw_spin_lock+0x17/0x160
[    7.214104]  [<ffffffff8159c5ac>] _raw_spin_lock+0x3c/0x50
[    7.214107]  [<ffffffff812fe111>] ? lockref_put_or_lock+0x11/0x40
[    7.214109]  [<ffffffff812fe111>] lockref_put_or_lock+0x11/0x40
[    7.214113]  [<ffffffff811b1442>] dput+0x22/0x130
[    7.214115]  [<ffffffff811a3d45>] path_put+0x15/0x30
[    7.214117]  [<ffffffff811e0bcc>] fanotify_free_event+0x1c/0x40
[    7.214119]  [<ffffffff811dd7ac>] fsnotify_destroy_event+0x1c/0x30
[    7.214121]  [<ffffffff811e1052>] fanotify_handle_event+0x342/0x390
[    7.214124]  [<ffffffff815a0c84>] ? __do_page_fault+0x2c4/0x480
[    7.214127]  [<ffffffff811dd18b>] send_to_group+0xfb/0x180
[    7.214129]  [<ffffffff811dd290>] ? fsnotify+0x80/0x2d0
[    7.214131]  [<ffffffff811ab325>] ? do_filp_open+0x45/0xa0
[    7.214134]  [<ffffffff811dd3d4>] fsnotify+0x1c4/0x2d0
[    7.214136]  [<ffffffff811987ad>] do_sys_open+0x1ad/0x220
[    7.214139]  [<ffffffff812fdd7e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    7.214141]  [<ffffffff81198859>] SyS_open+0x19/0x20
[    7.214143]  [<ffffffff815a5222>] system_call_fastpath+0x16/0x1b
[    7.214145] note: grep[757] exited with preempt_count 1

-- 
Jiri Kosina
SUSE Labs
