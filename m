Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314AbaAWPFo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 10:05:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932295AbaAWPFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 10:05:41 -0500
Date: Thu, 23 Jan 2014 16:05:40 +0100
From: Jan Kara <jack@suse.cz>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fanotify use after free.
Message-ID: <20140123150540.GD28796@quack.suse.cz>
References: <20140122062730.GA25601@redhat.com>
 <CA+55aFxnv050RqhhLBbsvV4=dcu-_ZXokbhmuO8Y4zVcvVJ6OQ@mail.gmail.com>
 <20140122233622.GB27916@quack.suse.cz>
 <CA+55aFwzb7rJate=r0Sgi_N7FStNtJS_PvfgPSGaczPPgeUZvg@mail.gmail.com>
 <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1401231120360.581@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 23-01-14 11:23:53, Jiri Kosina wrote:
> On Wed, 22 Jan 2014, Linus Torvalds wrote:
> 
> > > But refcounting seems like an overkill for this - there is exactly one
> > > fanotify_response_event structure iff it is a permission event. So
> > > something like the (completely untested) attached patch should fix the
> > > problem. But I agree it's a bit ugly so we might want something different.
> > > I'll try to think about something better tomorrow.
> > 
> > Ok, In the meantime, Dave, can you verify whether this hacky patch
> > fixes your problem?
> 
> I reported the same slab corruption yesterday as well here:
> 
> 	https://lkml.org/lkml/2014/1/22/173
> 
> With the patch applied, I am still seeing the slab corruption, preceeded 
> by GPF (which is not there without the patch) in 
> lockref_put_or_lock(&dentry->d_lockref) in dput():
  Hmm, OK. Can you please send me your .config? I'll try to reproduce this
myself.
	
								Honza

> 
>  general protection fault: 0000 [#1] SMP 
>  Modules linked in: tpm_tis(+) tpm wmi acpi_cpufreq autofs4 uhci_hcd ehci_hcd i915 drm_kms_helper drm i2c_algo_bit button usbcore video usb_common edd fan processor ata_generic thermal thermal_sys
>  CPU: 1 PID: 275 Comm: systemd-readahe Not tainted 3.13.0-03478-g670d0ac #1
>  Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
>  task: ffff880037c09150 ti: ffff88007359e000 task.ti: ffff88007359e000
>  RIP: 0010:[<ffffffff810a51e7>]  [<ffffffff810a51e7>] do_raw_spin_lock+0x17/0x160
>  RSP: 0018:ffff88007359fc78  EFLAGS: 00010286
>  RAX: ffff880037c09150 RBX: 6b6b6b6b6b6b6beb RCX: 0000000000000000
>  tpm_tis 00:09: 1.2 TPM (device-id 0x1020, rev-id 6)
>  tpm_tis 00:09: Intel iTPM workaround enabled
>  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 6b6b6b6b6b6b6beb
>  RBP: ffff88007359fc98 R08: 0000000000000002 R09: 0000000000000000
>  R10: 0000000000000000 R11: 0000000000000000 R12: 6b6b6b6b6b6b6beb
>  R13: ffff880037310690 R14: 0000000000000020 R15: ffff880036dbfc10
>  FS:  00007fa953e4a700(0000) GS:ffff88007c280000(0000) knlGS:0000000000000000
>  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>  CR2: 00007fff76a10258 CR3: 000000003659c000 CR4: 00000000000007e0
>  Stack:
>   6b6b6b6b6b6b6beb 6b6b6b6b6b6b6beb 6b6b6b6b6b6b6beb ffff880037310690
>   ffff88007359fcb8 ffffffff8159c59c ffffffff812fe101 6b6b6b6b6b6b6beb
>   ffff88007359fcd8 ffffffff812fe101 ffff88007359fd08 6b6b6b6b6b6b6b6b
>  Call Trace:
>   [<ffffffff8159c59c>] _raw_spin_lock+0x3c/0x50
>   [<ffffffff812fe101>] ? lockref_put_or_lock+0x11/0x40
>   [<ffffffff812fe101>] lockref_put_or_lock+0x11/0x40
>   [<ffffffff811b1442>] dput+0x22/0x130
>   [<ffffffff811a3d45>] path_put+0x15/0x30
>   [<ffffffff811e0bc5>] fanotify_free_event+0x15/0x40
>   [<ffffffff811dd7ac>] fsnotify_destroy_event+0x1c/0x30
>   [<ffffffff811e1041>] fanotify_handle_event+0x341/0x390
>   [<ffffffff811dd18b>] send_to_group+0xfb/0x180
>   [<ffffffff811dd290>] ? fsnotify+0x80/0x2d0
>   [<ffffffff811ab325>] ? do_filp_open+0x45/0xa0
>   [<ffffffff811dd3d4>] fsnotify+0x1c4/0x2d0
>   [<ffffffff811987ad>] do_sys_open+0x1ad/0x220
>   [<ffffffff812fdd6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>   [<ffffffff81198859>] SyS_open+0x19/0x20
>   [<ffffffff815a5222>] system_call_fastpath+0x16/0x1b
>  Code: 0d 7e 81 48 89 df e8 29 ff ff ff eb 94 0f 1f 80 00 00 00 00 55 48 89 e5 48 83 ec 20 48 89 5d e8 4c 89 65 f0 48 89 fb 4c 89 6d f8 <81> 7f 04 ad 4e ad de 74 0c 48 c7 c6 b5 0d 7e 81 e8 f4 fe ff ff 
>  RIP  [<ffffffff810a51e7>] do_raw_spin_lock+0x17/0x160
>   RSP <ffff88007359fc78>
>  ---[ end trace 7a918209ee213d28 ]---
>  BUG: sleeping function called from invalid context at kernel/locking/rwsem.c:20
>  in_atomic(): 1, irqs_disabled(): 0, pid: 275, name: systemd-readahe
>  INFO: lockdep is turned off.
>  CPU: 1 PID: 275 Comm: systemd-readahe Tainted: G      D      3.13.0-03478-g670d0ac #1
>  Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
>   ffff880037c09150 ffff88007359fa78 ffffffff8159702b ffff88007359fa98
>   ffffffff8107f621 ffffffff81a3d000 ffff880037b98d90 ffff88007359fab8
>   ffffffff8159b4ff ffff880037c09150 ffff880037c09150 ffff88007359fae8
>  Call Trace:
>   [<ffffffff8159702b>] dump_stack+0x72/0x87
>   [<ffffffff8107f621>] __might_sleep+0xe1/0x100
>   [<ffffffff8159b4ff>] down_read+0x1f/0x60
>   [<ffffffff810627ff>] exit_signals+0x1f/0x140
>   [<ffffffff81079491>] ? blocking_notifier_call_chain+0x11/0x20
>   [<ffffffff81052844>] do_exit+0xb4/0x4b0
>   [<ffffffff8159e23c>] oops_end+0xdc/0xe0
>   [<ffffffff81005f86>] die+0x56/0x90
>   [<ffffffff8159dea2>] do_general_protection+0x162/0x170
>   [<ffffffff8159d40c>] ? restore_args+0x30/0x30
>   [<ffffffff8159d592>] general_protection+0x22/0x30
>   [<ffffffff810a51e7>] ? do_raw_spin_lock+0x17/0x160
>   [<ffffffff8159c59c>] _raw_spin_lock+0x3c/0x50
>   [<ffffffff812fe101>] ? lockref_put_or_lock+0x11/0x40
>   [<ffffffff812fe101>] lockref_put_or_lock+0x11/0x40
>   [<ffffffff811b1442>] dput+0x22/0x130
>   [<ffffffff811a3d45>] path_put+0x15/0x30
>   [<ffffffff811e0bc5>] fanotify_free_event+0x15/0x40
>   [<ffffffff811dd7ac>] fsnotify_destroy_event+0x1c/0x30
>   [<ffffffff811e1041>] fanotify_handle_event+0x341/0x390
>   [<ffffffff811dd18b>] send_to_group+0xfb/0x180
>   [<ffffffff811dd290>] ? fsnotify+0x80/0x2d0
>   [<ffffffff811ab325>] ? do_filp_open+0x45/0xa0
>   [<ffffffff811dd3d4>] fsnotify+0x1c4/0x2d0
>   [<ffffffff811987ad>] do_sys_open+0x1ad/0x220
>   [<ffffffff812fdd6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>   [<ffffffff81198859>] SyS_open+0x19/0x20
>   [<ffffffff815a5222>] system_call_fastpath+0x16/0x1b
>  note: systemd-readahe[275] exited with preempt_count 1
>  BUG: scheduling while atomic: systemd-readahe/275/0x00000002
>  INFO: lockdep is turned off.
>  Modules linked in: tpm_tis(+) tpm wmi acpi_cpufreq autofs4 uhci_hcd ehci_hcd i915 drm_kms_helper drm i2c_algo_bit button usbcore video usb_common edd fan processor ata_generic thermal thermal_sys
>  CPU: 1 PID: 275 Comm: systemd-readahe Tainted: G      D      3.13.0-03478-g670d0ac #1
>  Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
>   ffff88007c293a00 ffff88007359f6f8 ffffffff8159702b ffff88007359f718
>   ffffffff810810f1 ffff88007c293a00 0000000000000001 ffff88007359f848
>   ffffffff8159789c ffff88007359f758 ffff88007359f768 ffff88007359e010
>  Call Trace:
>   [<ffffffff8159702b>] dump_stack+0x72/0x87
>   [<ffffffff810810f1>] __schedule_bug+0x61/0x80
>   [<ffffffff8159789c>] __schedule+0xbc/0x7c0
>   [<ffffffff8105defc>] ? mod_timer+0x14c/0x1f0
>   [<ffffffff815980e4>] schedule+0x24/0x70
>   [<ffffffff81597205>] schedule_timeout+0x1c5/0x210
>   [<ffffffff8159914f>] ? wait_for_completion+0xcf/0x120
>   [<ffffffff810a0d8d>] ? trace_hardirqs_on+0xd/0x10
>   [<ffffffff81599157>] wait_for_completion+0xd7/0x120
>   [<ffffffff81083330>] ? try_to_wake_up+0x250/0x250
>   [<ffffffff810b93bf>] ? srcu_reschedule+0x4f/0xf0
>   [<ffffffff810b965c>] __synchronize_srcu+0xec/0x130
>   [<ffffffff810b96e0>] ? srcu_barrier+0x10/0x10
>   [<ffffffff810b96c8>] synchronize_srcu+0x18/0x20
>   [<ffffffff811ddbdd>] fsnotify_destroy_group+0x1d/0x40
>   [<ffffffff811dfdf1>] inotify_release+0x21/0x50
>   [<ffffffff8119b2dd>] __fput+0xbd/0x2b0
>   [<ffffffff8119b569>] ____fput+0x9/0x10
>   [<ffffffff81070f41>] task_work_run+0xb1/0xe0
>   [<ffffffff81052979>] do_exit+0x1e9/0x4b0
>   [<ffffffff8159e23c>] oops_end+0xdc/0xe0
>   [<ffffffff81005f86>] die+0x56/0x90
>   [<ffffffff8159dea2>] do_general_protection+0x162/0x170
>   [<ffffffff8159d40c>] ? restore_args+0x30/0x30
>   [<ffffffff8159d592>] general_protection+0x22/0x30
>   [<ffffffff810a51e7>] ? do_raw_spin_lock+0x17/0x160
>   [<ffffffff8159c59c>] _raw_spin_lock+0x3c/0x50
>   [<ffffffff812fe101>] ? lockref_put_or_lock+0x11/0x40
>   [<ffffffff812fe101>] lockref_put_or_lock+0x11/0x40
>   [<ffffffff811b1442>] dput+0x22/0x130
>   [<ffffffff811a3d45>] path_put+0x15/0x30
>   [<ffffffff811e0bc5>] fanotify_free_event+0x15/0x40
>   [<ffffffff811dd7ac>] fsnotify_destroy_event+0x1c/0x30
>   [<ffffffff811e1041>] fanotify_handle_event+0x341/0x390
>   [<ffffffff811dd18b>] send_to_group+0xfb/0x180
>   [<ffffffff811dd290>] ? fsnotify+0x80/0x2d0
>   [<ffffffff811ab325>] ? do_filp_open+0x45/0xa0
>   [<ffffffff811dd3d4>] fsnotify+0x1c4/0x2d0
>   [<ffffffff811987ad>] do_sys_open+0x1ad/0x220
>   [<ffffffff812fdd6e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
>   [<ffffffff81198859>] SyS_open+0x19/0x20
>   [<ffffffff815a5222>] system_call_fastpath+0x16/0x1b
>  ACPI: AC Adapter [AC] (on-line)
>  Slab corruption (Tainted: G      D W   ): fanotify_event_info start=ffff880037310690, len=64
>  Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
>  Last user: [<ffffffff811e0bdd>](fanotify_free_event+0x2d/0x40)
>  030: 6b 6b 6b 6b 6b 6b 6b 6b 00 00 00 00 6b 6b 6b a5  kkkkkkkk....kkk.
>  Prev obj: start=ffff880037310638, len=64
>  Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
>  Last user: [<ffffffff811e0bdd>](fanotify_free_event+0x2d/0x40)
>  000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>  010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>  Next obj: start=ffff8800373106e8, len=64
>  Redzone: 0x9f911029d74e35b/0x9f911029d74e35b.
>  Last user: [<ffffffff811e0bdd>](fanotify_free_event+0x2d/0x40)
>  000: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
>  010: 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
> 
> -- 
> Jiri Kosina
> SUSE Labs
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
