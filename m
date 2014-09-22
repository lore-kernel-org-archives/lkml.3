Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834AbaIVLDG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 07:03:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45484 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753160AbaIVLDC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 07:03:02 -0400
Date: Mon, 22 Sep 2014 13:02:54 +0200
From: Borislav Petkov <bp@alien8.de>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        x86-ml <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: fs: INFO: possible irq lock inversion dependency detected in
 kill_fasync
Message-ID: <20140922110254.GA4510@pd.tnic>
References: <53F29925.6030303@oracle.com>
 <54070EF5.6010102@oracle.com>
 <541B3DD8.6000801@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <541B3DD8.6000801@oracle.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2014 at 04:17:28PM -0400, Sasha Levin wrote:
> Ping?
> 
> On 09/03/2014 08:52 AM, Sasha Levin wrote:
> > Ping? Still seeing it in -next.
> > 
> > On 08/18/2014 08:24 PM, Sasha Levin wrote:
> >> Hi all,
> >>
> >> While fuzzing with trinity inside a KVM tools guest running the latest -next
> >> kernel, I've stumbled on the following spew:

I get a similar splat with rc5+ + tip/master during simple boot. Adding
more people to CC and leaving in the rest for reference.

[   13.627241] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
[   17.598601] sha256_ssse3: Using AVX optimized SHA-256 implementation
[   36.527009] ip_tables: (C) 2000-2006 Netfilter Core Team
[   54.867814] tun: Universal TUN/TAP device driver, 1.6
[   54.872924] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
[  646.712953] 
[  646.714454] =========================================================
[  646.720887] [ INFO: possible irq lock inversion dependency detected ]
[  646.727326] 3.17.0-rc5+ #1 Not tainted
[  646.731076] ---------------------------------------------------------
[  646.737511] swapper/6/0 just changed the state of lock:
[  646.742733]  (tasklist_lock){.?.+..}, at: [<ffffffff811894eb>] send_sigio+0x5b/0x1b0
[  646.750539] but this lock took another, HARDIRQ-unsafe lock in the past:
[  646.757233]  (&(&p->alloc_lock)->rlock){+.+...}
[  646.757233] 
[  646.757233] and interrupts could create inverse lock ordering between them.
[  646.757233] 
[  646.767783] 
[  646.767783] other info that might help us debug this:
[  646.774306]  Possible interrupt unsafe locking scenario:
[  646.774306] 
[  646.781088]        CPU0                    CPU1
[  646.785619]        ----                    ----
[  646.790147]   lock(&(&p->alloc_lock)->rlock);
[  646.794550]                                local_irq_disable();
[  646.800465]                                lock(tasklist_lock);
[  646.806406]                                lock(&(&p->alloc_lock)->rlock);
[  646.813302]   <Interrupt>
[  646.815926]     lock(tasklist_lock);
[  646.819530] 
[  646.819530]  *** DEADLOCK ***
[  646.819530] 
[  646.825447] 7 locks held by swapper/6/0:
[  646.829369]  #0:  (&(&dev->event_lock)->rlock){-.....}, at: [<ffffffff8149959d>] input_event+0x4d/0x90
[  646.838752]  #1:  (rcu_read_lock){......}, at: [<ffffffff814986f5>] input_pass_values.part.3+0x5/0x360
[  646.848175]  #2:  (rcu_read_lock){......}, at: [<ffffffff8149e995>] evdev_events+0x5/0x2d0
[  646.856524]  #3:  (&(&client->buffer_lock)->rlock){-.....}, at: [<ffffffff8149db3c>] evdev_pass_values+0x5c/0x1c0
[  646.866868]  #4:  (rcu_read_lock){......}, at: [<ffffffff8118964f>] kill_fasync+0xf/0x290
[  646.875140]  #5:  (&(&new->fa_lock)->rlock){-.....}, at: [<ffffffff811896d6>] kill_fasync+0x96/0x290
[  646.884365]  #6:  (&f->f_owner.lock){.-....}, at: [<ffffffff811894b4>] send_sigio+0x24/0x1b0
[  646.892889] 
[  646.892889] the shortest dependencies between 2nd lock and 1st lock:
[  646.900758]  -> (&(&p->alloc_lock)->rlock){+.+...} ops: 46581 {
[  646.906773]     HARDIRQ-ON-W at:
[  646.910013]                       [<ffffffff81099dc3>] __lock_acquire+0x973/0x23e0
[  646.917602]                       [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  646.924842]                       [<ffffffff8162cbb1>] _raw_spin_lock+0x41/0x80
[  646.932169]                       [<ffffffff8117da99>] __set_task_comm+0x39/0x180
[  646.939664]                       [<ffffffff810732d5>] kthreadd+0x45/0x150
[  646.946556]                       [<ffffffff8162de6c>] ret_from_fork+0x7c/0xb0
[  646.953790]     SOFTIRQ-ON-W at:
[  646.957037]                       [<ffffffff81099dfb>] __lock_acquire+0x9ab/0x23e0
[  646.964618]                       [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  646.971859]                       [<ffffffff8162cbb1>] _raw_spin_lock+0x41/0x80
[  646.979188]                       [<ffffffff8117da99>] __set_task_comm+0x39/0x180
[  646.986688]                       [<ffffffff810732d5>] kthreadd+0x45/0x150
[  646.993583]                       [<ffffffff8162de6c>] ret_from_fork+0x7c/0xb0
[  647.000824]     INITIAL USE at:
[  647.003987]                      [<ffffffff81099879>] __lock_acquire+0x429/0x23e0
[  647.011487]                      [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  647.018634]                      [<ffffffff8162cbb1>] _raw_spin_lock+0x41/0x80
[  647.025875]                      [<ffffffff8117da99>] __set_task_comm+0x39/0x180
[  647.033290]                      [<ffffffff810732d5>] kthreadd+0x45/0x150
[  647.040097]                      [<ffffffff8162de6c>] ret_from_fork+0x7c/0xb0
[  647.047244]   }
[  647.049003]   ... key      at: [<ffffffff81cc99b8>] __key.47962+0x0/0x8
[  647.055638]   ... acquired at:
[  647.058694]    [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  647.064283]    [<ffffffff8162cbb1>] _raw_spin_lock+0x41/0x80
[  647.069964]    [<ffffffff81066465>] do_prlimit+0x205/0x250
[  647.075473]    [<ffffffff810664da>] SyS_getrlimit+0x2a/0x70
[  647.081058]    [<ffffffff8162df16>] system_call_fastpath+0x16/0x1b
[  647.087252] 
[  647.088744] -> (tasklist_lock){.?.+..} ops: 25047 {
[  647.093714]    IN-HARDIRQ-R at:
[  647.096867]                     [<ffffffff81099ff9>] __lock_acquire+0xba9/0x23e0
[  647.104275]                     [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  647.111341]                     [<ffffffff8162d104>] _raw_read_lock+0x44/0x80
[  647.118489]                     [<ffffffff811894eb>] send_sigio+0x5b/0x1b0
[  647.125384]                     [<ffffffff81189704>] kill_fasync+0xc4/0x290
[  647.132365]                     [<ffffffff8149db6d>] evdev_pass_values+0x8d/0x1c0
[  647.139865]                     [<ffffffff8149eb9c>] evdev_events+0x20c/0x2d0
[  647.147012]                     [<ffffffff81496a01>] input_to_handler+0x91/0x100
[  647.154427]                     [<ffffffff814989b4>] input_pass_values.part.3+0x2c4/0x360
[  647.162621]                     [<ffffffff814990ba>] input_handle_event+0xda/0x570
[  647.170207]                     [<ffffffff814995b0>] input_event+0x60/0x90
[  647.177094]                     [<ffffffff814cf86f>] hidinput_report_event+0x3f/0x50
[  647.184847]                     [<ffffffff814cd9fe>] hid_report_raw_event+0x29e/0x440
[  647.192687]                     [<ffffffff814cdcc1>] hid_input_report+0x121/0x1a0
[  647.200188]                     [<ffffffff814db920>] hid_irq_in+0x80/0x1f0
[  647.207073]                     [<ffffffff81455738>] __usb_hcd_giveback_urb+0x68/0x100
[  647.214999]                     [<ffffffff8145581a>] usb_hcd_giveback_urb+0x4a/0x140
[  647.222751]                     [<ffffffff81471d2b>] finish_urb+0x8b/0x150
[  647.229638]                     [<ffffffff81473325>] ohci_work.part.32+0x345/0x5c0
[  647.237216]                     [<ffffffff81476f10>] ohci_irq+0x200/0x280
[  647.244017]                     [<ffffffff81454d45>] usb_hcd_irq+0x25/0x40
[  647.250913]                     [<ffffffff810af669>] handle_irq_event_percpu+0x39/0x350
[  647.258933]                     [<ffffffff810af9c8>] handle_irq_event+0x48/0x70
[  647.266251]                     [<ffffffff810b2790>] handle_fasteoi_irq+0xa0/0x180
[  647.273832]                     [<ffffffff81005692>] handle_irq+0x22/0x40
[  647.280639]                     [<ffffffff81630908>] do_IRQ+0x68/0x110
[  647.287181]                     [<ffffffff8162ebac>] ret_from_intr+0x0/0x13
[  647.294162]                     [<ffffffff814c72a7>] cpuidle_enter+0x17/0x20
[  647.301228]                     [<ffffffff810905e1>] cpu_startup_entry+0x461/0x570
[  647.308809]                     [<ffffffff810360ed>] start_secondary+0x18d/0x1a0
[  647.316224]    HARDIRQ-ON-R at:
[  647.319384]                     [<ffffffff810997c3>] __lock_acquire+0x373/0x23e0
[  647.326790]                     [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  647.333884]                     [<ffffffff8162d104>] _raw_read_lock+0x44/0x80
[  647.341031]                     [<ffffffff810528f9>] do_wait+0xe9/0x370
[  647.347656]                     [<ffffffff81052f95>] SyS_wait4+0x75/0xf0
[  647.354369]                     [<ffffffff8162df16>] system_call_fastpath+0x16/0x1b
[  647.362036]    SOFTIRQ-ON-R at:
[  647.365190]                     [<ffffffff81099dfb>] __lock_acquire+0x9ab/0x23e0
[  647.372605]                     [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  647.379671]                     [<ffffffff8162d104>] _raw_read_lock+0x44/0x80
[  647.386842]                     [<ffffffff810528f9>] do_wait+0xe9/0x370
[  647.393470]                     [<ffffffff81052f95>] SyS_wait4+0x75/0xf0
[  647.400183]                     [<ffffffff8162df16>] system_call_fastpath+0x16/0x1b
[  647.407850]    INITIAL USE at:
[  647.410932]                    [<ffffffff81099879>] __lock_acquire+0x429/0x23e0
[  647.418253]                    [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  647.425233]                    [<ffffffff8162d5c7>] _raw_write_lock_irq+0x47/0x80
[  647.432726]                    [<ffffffff8104d3df>] copy_process.part.49+0xe7f/0x19f0
[  647.440564]                    [<ffffffff8104e117>] do_fork+0xe7/0x770
[  647.447114]                    [<ffffffff8104e7c6>] kernel_thread+0x26/0x30
[  647.454087]                    [<ffffffff81621453>] rest_init+0x23/0x140
[  647.460800]                    [<ffffffff81b9fe64>] start_kernel+0x404/0x411
[  647.467867]                    [<ffffffff81b9f469>] x86_64_start_reservations+0x2a/0x2c
[  647.475878]                    [<ffffffff81b9f562>] x86_64_start_kernel+0xf7/0xfb
[  647.483374]  }
[  647.485045]  ... key      at: [<ffffffff8190f098>] tasklist_lock+0x18/0x80
[  647.491940]  ... acquired at:
[  647.494911]    [<ffffffff81095eb2>] check_usage_forwards+0x152/0x160
[  647.501285]    [<ffffffff81096c68>] mark_lock+0x3d8/0x760
[  647.506700]    [<ffffffff81099ff9>] __lock_acquire+0xba9/0x23e0
[  647.512642]    [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  647.518236]    [<ffffffff8162d104>] _raw_read_lock+0x44/0x80
[  647.523910]    [<ffffffff811894eb>] send_sigio+0x5b/0x1b0
[  647.529324]    [<ffffffff81189704>] kill_fasync+0xc4/0x290
[  647.534833]    [<ffffffff8149db6d>] evdev_pass_values+0x8d/0x1c0
[  647.540852]    [<ffffffff8149eb9c>] evdev_events+0x20c/0x2d0
[  647.546526]    [<ffffffff81496a01>] input_to_handler+0x91/0x100
[  647.552460]    [<ffffffff814989b4>] input_pass_values.part.3+0x2c4/0x360
[  647.559174]    [<ffffffff814990ba>] input_handle_event+0xda/0x570
[  647.565287]    [<ffffffff814995b0>] input_event+0x60/0x90
[  647.570701]    [<ffffffff814cf86f>] hidinput_report_event+0x3f/0x50
[  647.576981]    [<ffffffff814cd9fe>] hid_report_raw_event+0x29e/0x440
[  647.583349]    [<ffffffff814cdcc1>] hid_input_report+0x121/0x1a0
[  647.589376]    [<ffffffff814db920>] hid_irq_in+0x80/0x1f0
[  647.594791]    [<ffffffff81455738>] __usb_hcd_giveback_urb+0x68/0x100
[  647.601244]    [<ffffffff8145581a>] usb_hcd_giveback_urb+0x4a/0x140
[  647.607523]    [<ffffffff81471d2b>] finish_urb+0x8b/0x150
[  647.612938]    [<ffffffff81473325>] ohci_work.part.32+0x345/0x5c0
[  647.619054]    [<ffffffff81476f10>] ohci_irq+0x200/0x280
[  647.624388]    [<ffffffff81454d45>] usb_hcd_irq+0x25/0x40
[  647.629803]    [<ffffffff810af669>] handle_irq_event_percpu+0x39/0x350
[  647.636350]    [<ffffffff810af9c8>] handle_irq_event+0x48/0x70
[  647.642198]    [<ffffffff810b2790>] handle_fasteoi_irq+0xa0/0x180
[  647.648312]    [<ffffffff81005692>] handle_irq+0x22/0x40
[  647.653632]    [<ffffffff81630908>] do_IRQ+0x68/0x110
[  647.658718]    [<ffffffff8162ebac>] ret_from_intr+0x0/0x13
[  647.664217]    [<ffffffff814c72a7>] cpuidle_enter+0x17/0x20
[  647.669812]    [<ffffffff810905e1>] cpu_startup_entry+0x461/0x570
[  647.675920]    [<ffffffff810360ed>] start_secondary+0x18d/0x1a0
[  647.681862] 
[  647.683359] 
[  647.683359] stack backtrace:
[  647.687718] CPU: 6 PID: 0 Comm: swapper/6 Not tainted 3.17.0-rc5+ #1
[  647.694065] Hardware name: To be filled by O.E.M. To be filled by O.E.M./M5A97 EVO R2.0, BIOS 1503 01/16/2013
[  647.703968]  ffffffff82814600 ffff88042e203648 ffffffff816257dc 0000000000000007
[  647.711467]  ffffffff82814600 ffff88042e203698 ffffffff81624b56 0000000000000002
[  647.718933]  ffffffff8184a8e7 ffff88042e203698 ffff88042b9ed678 ffff88042b9ecdc0
[  647.726383] Call Trace:
[  647.728828]  <IRQ>  [<ffffffff816257dc>] dump_stack+0x4f/0x7c
[  647.734608]  [<ffffffff81624b56>] print_irq_inversion_bug.part.31+0x1ba/0x1c9
[  647.741737]  [<ffffffff81095eb2>] check_usage_forwards+0x152/0x160
[  647.747915]  [<ffffffff81096c68>] mark_lock+0x3d8/0x760
[  647.753135]  [<ffffffff81095d60>] ? print_shortest_lock_dependencies+0x1d0/0x1d0
[  647.760525]  [<ffffffff81099ff9>] __lock_acquire+0xba9/0x23e0
[  647.766268]  [<ffffffff81099a13>] ? __lock_acquire+0x5c3/0x23e0
[  647.772185]  [<ffffffff8109c02e>] lock_acquire+0xbe/0x230
[  647.777580]  [<ffffffff811894eb>] ? send_sigio+0x5b/0x1b0
[  647.782978]  [<ffffffff8162d104>] _raw_read_lock+0x44/0x80
[  647.788457]  [<ffffffff811894eb>] ? send_sigio+0x5b/0x1b0
[  647.793854]  [<ffffffff811894eb>] send_sigio+0x5b/0x1b0
[  647.799078]  [<ffffffff811896d6>] ? kill_fasync+0x96/0x290
[  647.804562]  [<ffffffff81189704>] kill_fasync+0xc4/0x290
[  647.809870]  [<ffffffff8118964f>] ? kill_fasync+0xf/0x290
[  647.815268]  [<ffffffff8162cbdd>] ? _raw_spin_lock+0x6d/0x80
[  647.820924]  [<ffffffff8149db6d>] evdev_pass_values+0x8d/0x1c0
[  647.826754]  [<ffffffff8149eb9c>] evdev_events+0x20c/0x2d0
[  647.832236]  [<ffffffff8149e995>] ? evdev_events+0x5/0x2d0
[  647.837719]  [<ffffffff81496a01>] input_to_handler+0x91/0x100
[  647.843462]  [<ffffffff814989b4>] input_pass_values.part.3+0x2c4/0x360
[  647.849984]  [<ffffffff814986f5>] ? input_pass_values.part.3+0x5/0x360
[  647.856509]  [<ffffffff8162cda5>] ? _raw_spin_lock_irqsave+0x25/0x90
[  647.862856]  [<ffffffff8149959d>] ? input_event+0x4d/0x90
[  647.868253]  [<ffffffff814990ba>] input_handle_event+0xda/0x570
[  647.874167]  [<ffffffff8149959d>] ? input_event+0x4d/0x90
[  647.879566]  [<ffffffff814995b0>] input_event+0x60/0x90
[  647.884788]  [<ffffffff814cf86f>] hidinput_report_event+0x3f/0x50
[  647.890878]  [<ffffffff814cd9fe>] hid_report_raw_event+0x29e/0x440
[  647.897053]  [<ffffffff8162d011>] ? _raw_spin_unlock_irqrestore+0x41/0x90
[  647.903838]  [<ffffffff814cdcc1>] hid_input_report+0x121/0x1a0
[  647.909666]  [<ffffffff814db920>] hid_irq_in+0x80/0x1f0
[  647.914890]  [<ffffffff81455738>] __usb_hcd_giveback_urb+0x68/0x100
[  647.921153]  [<ffffffff8145581a>] usb_hcd_giveback_urb+0x4a/0x140
[  647.927242]  [<ffffffff81471d2b>] finish_urb+0x8b/0x150
[  647.932464]  [<ffffffff81473325>] ohci_work.part.32+0x345/0x5c0
[  647.938380]  [<ffffffff81476f10>] ohci_irq+0x200/0x280
[  647.943518]  [<ffffffff81454d45>] usb_hcd_irq+0x25/0x40
[  647.948739]  [<ffffffff810af669>] handle_irq_event_percpu+0x39/0x350
[  647.955089]  [<ffffffff810af9c8>] handle_irq_event+0x48/0x70
[  647.960746]  [<ffffffff810b2790>] handle_fasteoi_irq+0xa0/0x180
[  647.966661]  [<ffffffff81005692>] handle_irq+0x22/0x40
[  647.971797]  [<ffffffff81630908>] do_IRQ+0x68/0x110
[  647.976673]  [<ffffffff8162ebac>] common_interrupt+0x6c/0x6c
[  647.982325]  <EOI>  [<ffffffff814c6f4b>] ? cpuidle_enter_state+0x7b/0x310
[  647.989139]  [<ffffffff814c6f46>] ? cpuidle_enter_state+0x76/0x310
[  647.995314]  [<ffffffff814c72a7>] cpuidle_enter+0x17/0x20
[  648.000711]  [<ffffffff810905e1>] cpu_startup_entry+0x461/0x570
[  648.006628]  [<ffffffff810ce52c>] ? clockevents_register_device+0xbc/0x120
[  648.013496]  [<ffffffff810360ed>] start_secondary+0x18d/0x1a0

> >>
> >> [ 1132.334973] =========================================================
> >> [ 1132.336095] [ INFO: possible irq lock inversion dependency detected ]
> >> [ 1132.337056] 3.16.0-next-20140815-sasha-00034-g615561b #1071 Not tainted
> >> [ 1132.337922] ---------------------------------------------------------
> >> [ 1132.340751] trinity-main/8521 just changed the state of lock:
> >> [ 1132.342015] (&(&new->fa_lock)->rlock){-.....}, at: kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] but this lock took another, HARDIRQ-unsafe lock in the past:
> >> [ 1132.342761]  (&(&p->alloc_lock)->rlock){+.+...}
> >>
> >> and interrupts could create inverse lock ordering between them.
> >>
> >> [ 1132.342761]
> >> [ 1132.342761] other info that might help us debug this:
> >> [ 1132.342761] Chain exists of:
> >> &(&new->fa_lock)->rlock --> &f->f_owner.lock --> &(&p->alloc_lock)->rlock
> >> [ 1132.334973] =========================================================
> >> [ 1132.336095] [ INFO: possible irq lock inversion dependency detected ]
> >> [ 1132.337056] 3.16.0-next-20140815-sasha-00034-g615561b #1071 Not tainted
> >> [ 1132.337922] ---------------------------------------------------------
> >> [ 1132.340751] trinity-main/8521 just changed the state of lock:
> >> [ 1132.342015] (&(&new->fa_lock)->rlock){-.....}, at: kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] but this lock took another, HARDIRQ-unsafe lock in the past:
> >> [ 1132.342761]  (&(&p->alloc_lock)->rlock){+.+...}
> >>
> >> and interrupts could create inverse lock ordering between them.
> >>
> >> [ 1132.342761]
> >> [ 1132.342761] other info that might help us debug this:
> >> [ 1132.342761] Chain exists of:
> >> &(&new->fa_lock)->rlock --> &f->f_owner.lock --> &(&p->alloc_lock)->rlock
> >>
> >> [ 1132.342761]  Possible interrupt unsafe locking scenario:
> >> [ 1132.342761]
> >> [ 1132.342761]        CPU0                    CPU1
> >> [ 1132.342761]        ----                    ----
> >> [ 1132.342761]   lock(&(&p->alloc_lock)->rlock);
> >> [ 1132.342761]                                local_irq_disable();
> >> [ 1132.342761]                                lock(&(&new->fa_lock)->rlock);
> >> [ 1132.342761]                                lock(&f->f_owner.lock);
> >> [ 1132.342761]   <Interrupt>
> >> [ 1132.342761]     lock(&(&new->fa_lock)->rlock);
> >> [ 1132.342761]
> >> [ 1132.342761]  *** DEADLOCK ***
> >> [ 1132.342761]
> >> [ 1132.342761] 1 lock held by trinity-main/8521:
> >> [ 1132.342761] #0: (rcu_read_lock){......}, at: kill_fasync (fs/fcntl.c:731)
> >> [ 1132.342761]
> >> [ 1132.342761] the shortest dependencies between 2nd lock and 1st lock:
> >> [ 1132.342761]    -> (&(&p->alloc_lock)->rlock){+.+...} ops: 737341 {
> >> [ 1132.342761]       HARDIRQ-ON-W at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2802 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> >> [ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
> >> [ 1132.342761] kthreadd (kernel/kthread.c:489)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]       SOFTIRQ-ON-W at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> >> [ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
> >> [ 1132.342761] kthreadd (kernel/kthread.c:489)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]       INITIAL USE at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> >> [ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
> >> [ 1132.342761] kthreadd (kernel/kthread.c:489)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]     }
> >> [ 1132.342761] ... key at: __key.51842 (??:?)
> >> [ 1132.342761]     ... acquired at:
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> >> [ 1132.342761] do_prlimit (kernel/sys.c:1386)
> >> [ 1132.342761] SyS_getrlimit (kernel/sys.c:1276 kernel/sys.c:1270)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]
> >> [ 1132.342761]   -> (tasklist_lock){.+.+..} ops: 42693178 {
> >> [ 1132.342761]      HARDIRQ-ON-R at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2794 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] do_wait (./arch/x86/include/asm/current.h:14 kernel/exit.c:1490)
> >> [ 1132.342761] SyS_wait4 (kernel/exit.c:1620 kernel/exit.c:1588)
> >> [ 1132.342761] wait_for_helper (kernel/kmod.c:310)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]      SOFTIRQ-ON-R at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] do_wait (./arch/x86/include/asm/current.h:14 kernel/exit.c:1490)
> >> [ 1132.342761] SyS_wait4 (kernel/exit.c:1620 kernel/exit.c:1588)
> >> [ 1132.342761] wait_for_helper (kernel/kmod.c:310)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]      INITIAL USE at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_write_lock_irq (include/linux/rwlock_api_smp.h:197 kernel/locking/spinlock.c:311)
> >> [ 1132.342761] copy_process (./arch/x86/include/asm/current.h:14 kernel/fork.c:1465)
> >> [ 1132.342761] do_fork (kernel/fork.c:1644)
> >> [ 1132.342761] kernel_thread (kernel/fork.c:1693)
> >> [ 1132.342761] rest_init (init/main.c:404)
> >> [ 1132.342761] start_kernel (init/main.c:682)
> >> [ 1132.342761] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
> >> [ 1132.342761] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
> >> [ 1132.342761]    }
> >> [ 1132.342761] ... key at: tasklist_lock (??:?)
> >> [ 1132.342761]    ... acquired at:
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] send_sigio (fs/fcntl.c:517)
> >> [ 1132.342761] dnotify_handle_event (fs/notify/dnotify/dnotify.c:114)
> >> [ 1132.342761] send_to_group (fs/notify/fsnotify.c:183)
> >> [ 1132.342761] fsnotify (fs/notify/fsnotify.c:249)
> >> [ 1132.342761] notify_change (fs/attr.c:272)
> >> [ 1132.342761] chown_common (fs/open.c:581)
> >> [ 1132.342761] SyS_fchown (fs/open.c:647 fs/open.c:634)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]
> >> [ 1132.342761]  -> (&f->f_owner.lock){.+.+..} ops: 5967 {
> >> [ 1132.342761]     HARDIRQ-ON-R at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2794 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]     SOFTIRQ-ON-R at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]     INITIAL USE at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]   }
> >> [ 1132.342761] ... key at: __key.31497 (??:?)
> >> [ 1132.342761]   ... acquired at:
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] send_sigio (fs/fcntl.c:506)
> >> [ 1132.342761] kill_fasync (include/linux/spinlock.h:364 fs/fcntl.c:725 fs/fcntl.c:737)
> >> [ 1132.342761] wakeup_pipe_writers (fs/splice.c:727)
> >> [ 1132.342761] iter_file_splice_write (fs/splice.c:861 fs/splice.c:1054)
> >> [ 1132.342761] SyS_splice (fs/splice.c:1128 fs/splice.c:1393 fs/splice.c:1701 fs/splice.c:1684)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]
> >> [ 1132.342761] -> (&(&new->fa_lock)->rlock){-.....} ops: 4993 {
> >> [ 1132.342761]    IN-HARDIRQ-W at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
> >> [ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
> >> [ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
> >> [ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
> >> [ 1132.342761] irq_work_run (kernel/irq_work.c:170)
> >> [ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
> >> [ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
> >> [ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
> >> [ 1132.342761] do_fork (kernel/fork.c:1671)
> >> [ 1132.342761] SyS_clone (kernel/fork.c:1733)
> >> [ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
> >> [ 1132.342761]    INITIAL USE at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock_irq (include/linux/spinlock_api_smp.h:129 kernel/locking/spinlock.c:167)
> >> [ 1132.342761] fasync_remove_entry (include/linux/spinlock.h:359 fs/fcntl.c:595)
> >> [ 1132.342761] fasync_helper (fs/fcntl.c:698)
> >> [ 1132.342761] sock_fasync (net/socket.c:1211 (discriminator 7))
> >> [ 1132.342761] SyS_fcntl (fs/fcntl.c:70 fs/fcntl.c:274 fs/fcntl.c:378 fs/fcntl.c:363)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]  }
> >> [ 1132.342761] ... key at: __key.37041 (??:?)
> >> [ 1132.342761]  ... acquired at:
> >> [ 1132.342761] check_usage_forwards (kernel/locking/lockdep.c:2364)
> >> [ 1132.342761] mark_lock (kernel/locking/lockdep.c:2474 kernel/locking/lockdep.c:2922)
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
> >> [ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
> >> [ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
> >> [ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
> >> [ 1132.342761] irq_work_run (kernel/irq_work.c:170)
> >> [ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
> >> [ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
> >> [ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
> >> [ 1132.342761] do_fork (kernel/fork.c:1671)
> >> [ 1132.342761] SyS_clone (kernel/fork.c:1733)
> >> [ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
> >> [ 1132.342761]
> >> [ 1132.342761]
> >> [ 1132.342761] stack backtrace:
> >> [ 1132.342761] CPU: 10 PID: 8521 Comm: trinity-main Not tainted 3.16.0-next-20140815-sasha-00034-g615561b #1071
> >> [ 1132.342761]  ffff88071c003cb0 ffff88071c003c48 ffffffffb24a9798 ffffffffb651ed80
> >> [ 1132.342761]  ffff88071c003c90 ffffffffaf1cb19b ffff880714273d20 ffffffffb3740742
> >> [ 1132.342761]  ffff880714273000 ffffffffb3740742 ffff880714273d20 0000000000000002
> >> [ 1132.342761] Call Trace:
> >> [ 1132.342761] <IRQ> dump_stack (lib/dump_stack.c:52)
> >> [ 1132.342761] print_irq_inversion_bug (kernel/locking/lockdep.c:2339)
> >> [ 1132.342761] check_usage_forwards (kernel/locking/lockdep.c:2364)
> >> [ 1132.342761] mark_lock (kernel/locking/lockdep.c:2474 kernel/locking/lockdep.c:2922)
> >> [ 1132.342761] ? print_irq_inversion_bug (kernel/locking/lockdep.c:2349)
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
> >> [ 1132.342761] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.564837] FAULT_INJECTION: forcing a failure
> >> [ 1132.342761] ? kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
> >> [ 1132.342761] ? kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] ? kill_fasync (fs/fcntl.c:731)
> >> [ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
> >> [ 1132.342761] ? perf_event_reset (kernel/events/core.c:4337)
> >> [ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
> >> [ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
> >> [ 1132.342761] irq_work_run (kernel/irq_work.c:170)
> >> [ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
> >> [ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
> >> [ 1132.342761] <EOI> ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
> >> [ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
> >> [ 1132.342761] do_fork (kernel/fork.c:1671)
> >> [ 1132.342761] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:184 (discriminator 2))
> >> [ 1132.342761] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> >> [ 1132.342761] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
> >> [ 1132.342761] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
> >> [ 1132.342761] SyS_clone (kernel/fork.c:1733)
> >> [ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
> >> [ 1132.342761] ? tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]  Possible interrupt unsafe locking scenario:
> >> [ 1132.342761]
> >> [ 1132.342761]        CPU0                    CPU1
> >> [ 1132.342761]        ----                    ----
> >> [ 1132.342761]   lock(&(&p->alloc_lock)->rlock);
> >> [ 1132.342761]                                local_irq_disable();
> >> [ 1132.342761]                                lock(&(&new->fa_lock)->rlock);
> >> [ 1132.342761]                                lock(&f->f_owner.lock);
> >> [ 1132.342761]   <Interrupt>
> >> [ 1132.342761]     lock(&(&new->fa_lock)->rlock);
> >> [ 1132.342761]
> >> [ 1132.342761]  *** DEADLOCK ***
> >> [ 1132.342761]
> >> [ 1132.342761] 1 lock held by trinity-main/8521:
> >> [ 1132.342761] #0: (rcu_read_lock){......}, at: kill_fasync (fs/fcntl.c:731)
> >> [ 1132.342761]
> >> [ 1132.342761] the shortest dependencies between 2nd lock and 1st lock:
> >> [ 1132.342761]    -> (&(&p->alloc_lock)->rlock){+.+...} ops: 737341 {
> >> [ 1132.342761]       HARDIRQ-ON-W at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2802 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> >> [ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
> >> [ 1132.342761] kthreadd (kernel/kthread.c:489)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]       SOFTIRQ-ON-W at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> >> [ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
> >> [ 1132.342761] kthreadd (kernel/kthread.c:489)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]       INITIAL USE at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> >> [ 1132.342761] __set_task_comm (include/linux/spinlock.h:309 include/linux/jump_label.h:114 include/trace/events/task.h:33 fs/exec.c:1048)
> >> [ 1132.342761] kthreadd (kernel/kthread.c:489)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]     }
> >> [ 1132.342761] ... key at: __key.51842 (??:?)
> >> [ 1132.342761]     ... acquired at:
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock (include/linux/spinlock_api_smp.h:143 kernel/locking/spinlock.c:151)
> >> [ 1132.342761] do_prlimit (kernel/sys.c:1386)
> >> [ 1132.342761] SyS_getrlimit (kernel/sys.c:1276 kernel/sys.c:1270)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]
> >> [ 1132.342761]   -> (tasklist_lock){.+.+..} ops: 42693178 {
> >> [ 1132.342761]      HARDIRQ-ON-R at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2794 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] do_wait (./arch/x86/include/asm/current.h:14 kernel/exit.c:1490)
> >> [ 1132.342761] SyS_wait4 (kernel/exit.c:1620 kernel/exit.c:1588)
> >> [ 1132.342761] wait_for_helper (kernel/kmod.c:310)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]      SOFTIRQ-ON-R at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] do_wait (./arch/x86/include/asm/current.h:14 kernel/exit.c:1490)
> >> [ 1132.342761] SyS_wait4 (kernel/exit.c:1620 kernel/exit.c:1588)
> >> [ 1132.342761] wait_for_helper (kernel/kmod.c:310)
> >> [ 1132.342761] ret_from_fork (arch/x86/kernel/entry_64.S:348)
> >> [ 1132.342761]      INITIAL USE at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_write_lock_irq (include/linux/rwlock_api_smp.h:197 kernel/locking/spinlock.c:311)
> >> [ 1132.342761] copy_process (./arch/x86/include/asm/current.h:14 kernel/fork.c:1465)
> >> [ 1132.342761] do_fork (kernel/fork.c:1644)
> >> [ 1132.342761] kernel_thread (kernel/fork.c:1693)
> >> [ 1132.342761] rest_init (init/main.c:404)
> >> [ 1132.342761] start_kernel (init/main.c:682)
> >> [ 1132.342761] x86_64_start_reservations (arch/x86/kernel/head64.c:194)
> >> [ 1132.342761] x86_64_start_kernel (arch/x86/kernel/head64.c:183)
> >> [ 1132.342761]    }
> >> [ 1132.342761] ... key at: tasklist_lock (??:?)
> >> [ 1132.342761]    ... acquired at:
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] send_sigio (fs/fcntl.c:517)
> >> [ 1132.342761] dnotify_handle_event (fs/notify/dnotify/dnotify.c:114)
> >> [ 1132.342761] send_to_group (fs/notify/fsnotify.c:183)
> >> [ 1132.342761] fsnotify (fs/notify/fsnotify.c:249)
> >> [ 1132.342761] notify_change (fs/attr.c:272)
> >> [ 1132.342761] chown_common (fs/open.c:581)
> >> [ 1132.342761] SyS_fchown (fs/open.c:647 fs/open.c:634)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]
> >> [ 1132.342761]  -> (&f->f_owner.lock){.+.+..} ops: 5967 {
> >> [ 1132.342761]     HARDIRQ-ON-R at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2794 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]     SOFTIRQ-ON-R at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2806 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]     INITIAL USE at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] SyS_fcntl (fs/fcntl.c:197 fs/fcntl.c:308 fs/fcntl.c:378 fs/fcntl.c:363)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]   }
> >> [ 1132.342761] ... key at: __key.31497 (??:?)
> >> [ 1132.342761]   ... acquired at:
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_read_lock (include/linux/rwlock_api_smp.h:150 kernel/locking/spinlock.c:223)
> >> [ 1132.342761] send_sigio (fs/fcntl.c:506)
> >> [ 1132.342761] kill_fasync (include/linux/spinlock.h:364 fs/fcntl.c:725 fs/fcntl.c:737)
> >> [ 1132.342761] wakeup_pipe_writers (fs/splice.c:727)
> >> [ 1132.342761] iter_file_splice_write (fs/splice.c:861 fs/splice.c:1054)
> >> [ 1132.342761] SyS_splice (fs/splice.c:1128 fs/splice.c:1393 fs/splice.c:1701 fs/splice.c:1684)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]
> >> [ 1132.342761] -> (&(&new->fa_lock)->rlock){-.....} ops: 4993 {
> >> [ 1132.342761]    IN-HARDIRQ-W at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
> >> [ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
> >> [ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
> >> [ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
> >> [ 1132.342761] irq_work_run (kernel/irq_work.c:170)
> >> [ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
> >> [ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
> >> [ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
> >> [ 1132.342761] do_fork (kernel/fork.c:1671)
> >> [ 1132.342761] SyS_clone (kernel/fork.c:1733)
> >> [ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
> >> [ 1132.342761]    INITIAL USE at:
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:3144)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock_irq (include/linux/spinlock_api_smp.h:129 kernel/locking/spinlock.c:167)
> >> [ 1132.342761] fasync_remove_entry (include/linux/spinlock.h:359 fs/fcntl.c:595)
> >> [ 1132.342761] fasync_helper (fs/fcntl.c:698)
> >> [ 1132.342761] sock_fasync (net/socket.c:1211 (discriminator 7))
> >> [ 1132.342761] SyS_fcntl (fs/fcntl.c:70 fs/fcntl.c:274 fs/fcntl.c:378 fs/fcntl.c:363)
> >> [ 1132.342761] tracesys (arch/x86/kernel/entry_64.S:541)
> >> [ 1132.342761]  }
> >> [ 1132.342761] ... key at: __key.37041 (??:?)
> >> [ 1132.342761]  ... acquired at:
> >> [ 1132.342761] check_usage_forwards (kernel/locking/lockdep.c:2364)
> >> [ 1132.342761] mark_lock (kernel/locking/lockdep.c:2474 kernel/locking/lockdep.c:2922)
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
> >> [ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
> >> [ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
> >> [ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
> >> [ 1132.342761] irq_work_run (kernel/irq_work.c:170)
> >> [ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
> >> [ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
> >> [ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
> >> [ 1132.342761] do_fork (kernel/fork.c:1671)
> >> [ 1132.342761] SyS_clone (kernel/fork.c:1733)
> >> [ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
> >> [ 1132.342761]
> >> [ 1132.342761]
> >> [ 1132.342761] stack backtrace:
> >> [ 1132.342761] CPU: 10 PID: 8521 Comm: trinity-main Not tainted 3.16.0-next-20140815-sasha-00034-g615561b #1071
> >> [ 1132.342761]  ffff88071c003cb0 ffff88071c003c48 ffffffffb24a9798 ffffffffb651ed80
> >> [ 1132.342761]  ffff88071c003c90 ffffffffaf1cb19b ffff880714273d20 ffffffffb3740742
> >> [ 1132.342761]  ffff880714273000 ffffffffb3740742 ffff880714273d20 0000000000000002
> >> [ 1132.342761] Call Trace:
> >> [ 1132.342761] <IRQ> dump_stack (lib/dump_stack.c:52)
> >> [ 1132.342761] print_irq_inversion_bug (kernel/locking/lockdep.c:2339)
> >> [ 1132.342761] check_usage_forwards (kernel/locking/lockdep.c:2364)
> >> [ 1132.342761] mark_lock (kernel/locking/lockdep.c:2474 kernel/locking/lockdep.c:2922)
> >> [ 1132.342761] ? print_irq_inversion_bug (kernel/locking/lockdep.c:2349)
> >> [ 1132.342761] __lock_acquire (kernel/locking/lockdep.c:2785 kernel/locking/lockdep.c:3140)
> >> [ 1132.342761] ? kvm_clock_read (./arch/x86/include/asm/preempt.h:90 arch/x86/kernel/kvmclock.c:86)
> >> [ 1132.342761] ? sched_clock (./arch/x86/include/asm/paravirt.h:192 arch/x86/kernel/tsc.c:304)
> >> [ 1132.342761] lock_acquire (./arch/x86/include/asm/current.h:14 kernel/locking/lockdep.c:3610)
> >> [ 1132.564837] FAULT_INJECTION: forcing a failure
> >> [ 1132.342761] ? kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] _raw_spin_lock_irqsave (include/linux/spinlock_api_smp.h:117 kernel/locking/spinlock.c:159)
> >> [ 1132.342761] ? kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] kill_fasync (fs/fcntl.c:717 fs/fcntl.c:737)
> >> [ 1132.342761] ? kill_fasync (fs/fcntl.c:731)
> >> [ 1132.342761] perf_event_wakeup (kernel/events/core.c:4342)
> >> [ 1132.342761] ? perf_event_reset (kernel/events/core.c:4337)
> >> [ 1132.342761] perf_pending_event (kernel/events/core.c:4360)
> >> [ 1132.342761] irq_work_run_list (kernel/irq_work.c:159)
> >> [ 1132.342761] irq_work_run (kernel/irq_work.c:170)
> >> [ 1132.342761] smp_irq_work_interrupt (./arch/x86/include/asm/apic.h:660 arch/x86/kernel/irq_work.c:29)
> >> [ 1132.342761] irq_work_interrupt (arch/x86/kernel/entry_64.S:1046)
> >> [ 1132.342761] <EOI> ? _raw_spin_unlock_irqrestore (./arch/x86/include/asm/paravirt.h:809 include/linux/spinlock_api_smp.h:160 kernel/locking/spinlock.c:191)
> >> [ 1132.342761] wake_up_new_task (kernel/sched/core.c:2090)
> >> [ 1132.342761] do_fork (kernel/fork.c:1671)
> >> [ 1132.342761] ? context_tracking_user_exit (./arch/x86/include/asm/paravirt.h:809 (discriminator 2) kernel/context_tracking.c:184 (discriminator 2))
> >> [ 1132.342761] ? __this_cpu_preempt_check (lib/smp_processor_id.c:63)
> >> [ 1132.342761] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
> >> [ 1132.342761] ? trace_hardirqs_on (kernel/locking/lockdep.c:2609)
> >> [ 1132.342761] SyS_clone (kernel/fork.c:1733)
> >> [ 1132.342761] stub_clone (arch/x86/kernel/entry_64.S:636)
> >> [ 1132.342761] ? tracesys (arch/x86/kernel/entry_64.S:541)
> >>
> >>
> >> Thanks,
> >> Sash
> >>
> > 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
