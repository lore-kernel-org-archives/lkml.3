Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753969AbaIVMkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 08:40:55 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:54071 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753871AbaIVMkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 08:40:52 -0400
Message-ID: <542018CF.4010001@gmail.com>
Date: Mon, 22 Sep 2014 15:40:47 +0300
From: Kari Suvanto <kari.tj.suvanto@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, Sasha Levin <sasha.levin@oracle.com>
CC: Al Viro <viro@ZenIV.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        x86-ml <x86@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: fs: INFO: possible irq lock inversion dependency detected in
 kill_fasync
References: <53F29925.6030303@oracle.com> <54070EF5.6010102@oracle.com> <541B3DD8.6000801@oracle.com> <20140922110254.GA4510@pd.tnic>
In-Reply-To: <20140922110254.GA4510@pd.tnic>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> I get a similar splat with rc5+ + tip/master during simple boot. Adding
> more people to CC and leaving in the rest for reference.
> 
> [   13.627241] IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
> [   17.598601] sha256_ssse3: Using AVX optimized SHA-256 implementation
> [   36.527009] ip_tables: (C) 2000-2006 Netfilter Core Team
> [   54.867814] tun: Universal TUN/TAP device driver, 1.6
> [   54.872924] tun: (C) 1999-2004 Max Krasnyansky <maxk@qualcomm.com>
> [  646.712953] 
> [  646.714454] =========================================================
> [  646.720887] [ INFO: possible irq lock inversion dependency detected ]
> [  646.727326] 3.17.0-rc5+ #1 Not tainted
> [  646.731076] ---------------------------------------------------------
> [  646.737511] swapper/6/0 just changed the state of lock:
> [  646.742733]  (tasklist_lock){.?.+..}, at: [<ffffffff811894eb>] send_sigio+0x5b/0x1b0
> [  646.750539] but this lock took another, HARDIRQ-unsafe lock in the past:
> [  646.757233]  (&(&p->alloc_lock)->rlock){+.+...}
> [  646.757233] 
> [  646.757233] and interrupts could create inverse lock ordering between them.
> [  646.757233] 
> [  646.767783] 
> [  646.767783] other info that might help us debug this:
> [  646.774306]  Possible interrupt unsafe locking scenario:
> [  646.774306] 
> [  646.781088]        CPU0                    CPU1
> [  646.785619]        ----                    ----
> [  646.790147]   lock(&(&p->alloc_lock)->rlock);
> [  646.794550]                                local_irq_disable();
> [  646.800465]                                lock(tasklist_lock);
> [  646.806406]                                lock(&(&p->alloc_lock)->rlock);
> [  646.813302]   <Interrupt>
> [  646.815926]     lock(tasklist_lock);
> [  646.819530] 

I also get a similar splat but in my case the tasklist_lock is changed to event_lock

[   13.157233] 
[   13.157256] =========================================================
[   13.157272] [ INFO: possible irq lock inversion dependency detected ]
[   13.157288] 3.17.0-999-generic #201409212205 Not tainted
[   13.157304] ---------------------------------------------------------
[   13.157320] swapper/0/0 just changed the state of lock:
[   13.157337]  (&(&dev->event_lock)->rlock){-.....}, at: [<ffffffff81650415>] input_event+0x45/0x70
[   13.157420] but this lock took another, HARDIRQ-unsafe lock in the past:
[   13.157436]  (&(&p->alloc_lock)->rlock){+.+...}
[   13.157436] 
[   13.157436] and interrupts could create inverse lock ordering between them.
[   13.157436] 
[   13.157500] 
[   13.157500] other info that might help us debug this:
[   13.157517] Chain exists of:
[   13.157517]   &(&dev->event_lock)->rlock --> &(&client->buffer_lock)->rlock --> &(&p->alloc_lock)->rlock
[   13.157517] 
[   13.157631]  Possible interrupt unsafe locking scenario:
[   13.157631] 
[   13.157648]        CPU0                    CPU1
[   13.157665]        ----                    ----
[   13.157681]   lock(&(&p->alloc_lock)->rlock);
[   13.157730]                                local_irq_disable();
[   13.157747]                                lock(&(&dev->event_lock)->rlock);
[   13.157798]                                lock(&(&client->buffer_lock)->rlock);
[   13.157848]   <Interrupt>
[   13.157864]     lock(&(&dev->event_lock)->rlock);
[   13.157916] 
[   13.157916]  *** DEADLOCK ***
[   13.157916] 
[   13.157932] no locks held by swapper/0/0.
[   13.157948] 
[   13.157948] the shortest dependencies between 2nd lock and 1st lock:
[   13.157970]      -> (&(&p->alloc_lock)->rlock){+.+...} ops: 30001 {
[   13.158161]         HARDIRQ-ON-W at:
[   13.158193]                               [<ffffffff810dbfc8>] __lock_acquire+0x508/0xaf0
[   13.158227]                               [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.158260]                               [<ffffffff8184f199>] _raw_spin_lock+0x39/0x50
[   13.158295]                               [<ffffffff81236abe>] __set_task_comm+0x2e/0x240
[   13.158329]                               [<ffffffff810a8cc0>] kthreadd+0x30/0x220
[   13.158363]                               [<ffffffff8184ff7c>] ret_from_fork+0x7c/0xb0
[   13.158395]         SOFTIRQ-ON-W at:
[   13.158426]                               [<ffffffff810dbd83>] __lock_acquire+0x2c3/0xaf0
[   13.158459]                               [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.158491]                               [<ffffffff8184f199>] _raw_spin_lock+0x39/0x50
[   13.158524]                               [<ffffffff81236abe>] __set_task_comm+0x2e/0x240
[   13.158556]                               [<ffffffff810a8cc0>] kthreadd+0x30/0x220
[   13.158588]                               [<ffffffff8184ff7c>] ret_from_fork+0x7c/0xb0
[   13.158620]         INITIAL USE at:
[   13.158652]                              [<ffffffff810dbdd4>] __lock_acquire+0x314/0xaf0
[   13.158684]                              [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.158716]                              [<ffffffff8184f199>] _raw_spin_lock+0x39/0x50
[   13.158749]                              [<ffffffff81236abe>] __set_task_comm+0x2e/0x240
[   13.158782]                              [<ffffffff810a8cc0>] kthreadd+0x30/0x220
[   13.158815]                              [<ffffffff8184ff7c>] ret_from_fork+0x7c/0xb0
[   13.158847]       }
[   13.158864]       ... key      at: [<ffffffff8211d018>] __key.51912+0x0/0x8
[   13.158987]       ... acquired at:
[   13.159003]    [<ffffffff810dbea8>] __lock_acquire+0x3e8/0xaf0
[   13.159036]    [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.159068]    [<ffffffff8184f199>] _raw_spin_lock+0x39/0x50
[   13.159100]    [<ffffffff8109b21a>] do_prlimit+0x9a/0x200
[   13.159134]    [<ffffffff8109b3aa>] SyS_getrlimit+0x2a/0x70
[   13.159166]    [<ffffffff8185002d>] system_call_fastpath+0x16/0x1b
[   13.159198] 
[   13.159213]     -> (tasklist_lock){.+.+..} ops: 26642 {
[   13.159308]        HARDIRQ-ON-R at:
[   13.159339]                             [<ffffffff810dbd61>] __lock_acquire+0x2a1/0xaf0
[   13.159371]                             [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.159403]                             [<ffffffff8184f4ec>] _raw_read_lock+0x3c/0x50
[   13.159435]                             [<ffffffff810842d3>] do_wait+0xe3/0x3f0
[   13.159467]                             [<ffffffff81085894>] SyS_wait4+0x64/0xe0
[   13.159499]                             [<ffffffff8109c30b>] wait_for_helper+0x4b/0x70
[   13.159532]                             [<ffffffff8184ff7c>] ret_from_fork+0x7c/0xb0
[   13.159564]        SOFTIRQ-ON-R at:
[   13.159595]                             [<ffffffff810dbd83>] __lock_acquire+0x2c3/0xaf0
[   13.159627]                             [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.159659]                             [<ffffffff8184f4ec>] _raw_read_lock+0x3c/0x50
[   13.159691]                             [<ffffffff810842d3>] do_wait+0xe3/0x3f0
[   13.159723]                             [<ffffffff81085894>] SyS_wait4+0x64/0xe0
[   13.159843]                             [<ffffffff8109c30b>] wait_for_helper+0x4b/0x70
[   13.159875]                             [<ffffffff8184ff7c>] ret_from_fork+0x7c/0xb0
[   13.159908]        INITIAL USE at:
[   13.159939]                            [<ffffffff810dbdd4>] __lock_acquire+0x314/0xaf0
[   13.159971]                            [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.160003]                            [<ffffffff8184f875>] _raw_write_lock_irq+0x45/0x60
[   13.160035]                            [<ffffffff8107f06e>] copy_process.part.23+0xc9e/0x1e30
[   13.160067]                            [<ffffffff810803b1>] do_fork+0xd1/0x7d0
[   13.160099]                            [<ffffffff81080ad6>] kernel_thread+0x26/0x30
[   13.160131]                            [<ffffffff81832a46>] rest_init+0x26/0x150
[   13.160164]                            [<ffffffff81f5a112>] start_kernel+0x4aa/0x4b7
[   13.160196]                            [<ffffffff81f595ee>] x86_64_start_reservations+0x2a/0x2c
[   13.160228]                            [<ffffffff81f59733>] x86_64_start_kernel+0x143/0x152
[   13.160260]      }
[   13.160276]      ... key      at: [<ffffffff81e0f058>] tasklist_lock+0x18/0x40
[   13.160309]      ... acquired at:
[   13.160325]    [<ffffffff810dbea8>] __lock_acquire+0x3e8/0xaf0
[   13.160358]    [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.160390]    [<ffffffff8184f4ec>] _raw_read_lock+0x3c/0x50
[   13.160422]    [<ffffffff81243225>] send_sigio+0x55/0x160
[   13.160454]    [<ffffffff812433fc>] kill_fasync+0xcc/0x230
[   13.160487]    [<ffffffff81653cf4>] evdev_pass_values+0xe4/0x1b0
[   13.160520]    [<ffffffff8165438b>] evdev_events+0x1ab/0x250
[   13.160552]    [<ffffffff8164c707>] input_to_handler+0x97/0xf0
[   13.160670]    [<ffffffff8164f854>] input_pass_values.part.5+0x2c4/0x2f0
[   13.160703]    [<ffffffff8164ffa9>] input_handle_event+0x129/0x550
[   13.160736]    [<ffffffff816505d8>] input_inject_event+0x198/0x210
[   13.160768]    [<ffffffff816558a7>] evdev_write+0x197/0x220
[   13.160800]    [<ffffffff8122f0e7>] vfs_write+0xb7/0x1f0
[   13.160832]    [<ffffffff8122fb79>] SyS_write+0x49/0xb0
[   13.160863]    [<ffffffff8185002d>] system_call_fastpath+0x16/0x1b
[   13.160895] 
[   13.160911]    -> (&f->f_owner.lock){......} ops: 8 {
[   13.161005]       INITIAL USE at:
[   13.161036]                          [<ffffffff810dbdd4>] __lock_acquire+0x314/0xaf0
[   13.161068]                          [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.161101]                          [<ffffffff8184f875>] _raw_write_lock_irq+0x45/0x60
[   13.161133]                          [<ffffffff812425d1>] f_modown+0x31/0xd0
[   13.161165]                          [<ffffffff8124275b>] f_setown+0x8b/0x130
[   13.161197]                          [<ffffffff81242e51>] SyS_fcntl+0x341/0x6c0
[   13.161229]                          [<ffffffff8185002d>] system_call_fastpath+0x16/0x1b
[   13.161261]     }
[   13.161276]     ... key      at: [<ffffffff82e879a0>] __key.31267+0x0/0x8
[   13.161310]     ... acquired at:
[   13.161325]    [<ffffffff810dbea8>] __lock_acquire+0x3e8/0xaf0
[   13.161358]    [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.161390]    [<ffffffff8184f4ec>] _raw_read_lock+0x3c/0x50
[   13.161508]    [<ffffffff812431fa>] send_sigio+0x2a/0x160
[   13.161540]    [<ffffffff812433fc>] kill_fasync+0xcc/0x230
[   13.161571]    [<ffffffff81653cf4>] evdev_pass_values+0xe4/0x1b0
[   13.161603]    [<ffffffff8165438b>] evdev_events+0x1ab/0x250
[   13.161636]    [<ffffffff8164c707>] input_to_handler+0x97/0xf0
[   13.161667]    [<ffffffff8164f854>] input_pass_values.part.5+0x2c4/0x2f0
[   13.161700]    [<ffffffff8164ffa9>] input_handle_event+0x129/0x550
[   13.161733]    [<ffffffff816505d8>] input_inject_event+0x198/0x210
[   13.161764]    [<ffffffff816558a7>] evdev_write+0x197/0x220
[   13.161796]    [<ffffffff8122f0e7>] vfs_write+0xb7/0x1f0
[   13.161827]    [<ffffffff8122fb79>] SyS_write+0x49/0xb0
[   13.161858]    [<ffffffff8185002d>] system_call_fastpath+0x16/0x1b
[   13.161890] 
[   13.161906]   -> (&(&new->fa_lock)->rlock){......} ops: 1 {
[   13.162000]      INITIAL USE at:
[   13.162031]                        [<ffffffff810dbdd4>] __lock_acquire+0x314/0xaf0
[   13.162063]                        [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.162095]                        [<ffffffff8184fae1>] _raw_spin_lock_irqsave+0x51/0x70
[   13.162127]                        [<ffffffff812433ce>] kill_fasync+0x9e/0x230
[   13.162159]                        [<ffffffff81653cf4>] evdev_pass_values+0xe4/0x1b0
[   13.162191]                        [<ffffffff8165438b>] evdev_events+0x1ab/0x250
[   13.162223]                        [<ffffffff8164c707>] input_to_handler+0x97/0xf0
[   13.162342]                        [<ffffffff8164f854>] input_pass_values.part.5+0x2c4/0x2f0
[   13.162374]                        [<ffffffff8164ffa9>] input_handle_event+0x129/0x550
[   13.162406]                        [<ffffffff816505d8>] input_inject_event+0x198/0x210
[   13.162438]                        [<ffffffff816558a7>] evdev_write+0x197/0x220
[   13.162470]                        [<ffffffff8122f0e7>] vfs_write+0xb7/0x1f0
[   13.162502]                        [<ffffffff8122fb79>] SyS_write+0x49/0xb0
[   13.162534]                        [<ffffffff8185002d>] system_call_fastpath+0x16/0x1b
[   13.162566]    }
[   13.162582]    ... key      at: [<ffffffff82e882f4>] __key.36860+0x0/0x8
[   13.162614]    ... acquired at:
[   13.162630]    [<ffffffff810dbea8>] __lock_acquire+0x3e8/0xaf0
[   13.162662]    [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.162694]    [<ffffffff8184fae1>] _raw_spin_lock_irqsave+0x51/0x70
[   13.162726]    [<ffffffff814044f2>] fprop_reflect_period_percpu.isra.7+0x22/0xc0
[   13.162760]    [<ffffffff81404a21>] fprop_fraction_percpu+0xa1/0x120
[   13.162792]    [<ffffffff811b7811>] bdi_dirty_limit+0x31/0xc0
[   13.162825]    [<ffffffff8125ce5c>] over_bground_thresh+0x5c/0x80
[   13.162858]    [<ffffffff81261fa8>] bdi_writeback_workfn+0x238/0x910
[   13.162890]    [<ffffffff810a1b1f>] process_one_work+0x1df/0x7f0
[   13.162922]    [<ffffffff810a2251>] worker_thread+0x121/0x490
[   13.162954]    [<ffffffff810a7fcc>] kthread+0xfc/0x120
[   13.162986]    [<ffffffff8184ff7c>] ret_from_fork+0x7c/0xb0
[   13.163018] 
[   13.163034]  -> (&(&client->buffer_lock)->rlock){......} ops: 15 {
[   13.163214]     INITIAL USE at:
[   13.163245]                      [<ffffffff810dbdd4>] __lock_acquire+0x314/0xaf0
[   13.163278]                      [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.163310]                      [<ffffffff8184f199>] _raw_spin_lock+0x39/0x50
[   13.163342]                      [<ffffffff81653c6c>] evdev_pass_values+0x5c/0x1b0
[   13.163375]                      [<ffffffff8165438b>] evdev_events+0x1ab/0x250
[   13.163406]                      [<ffffffff8164c707>] input_to_handler+0x97/0xf0
[   13.163438]                      [<ffffffff8164f854>] input_pass_values.part.5+0x2c4/0x2f0
[   13.163470]                      [<ffffffff8164ffa9>] input_handle_event+0x129/0x550
[   13.163502]                      [<ffffffff81650429>] input_event+0x59/0x70
[   13.163534]                      [<ffffffffc04490b0>] snd_jack_report+0xd0/0xe0 [snd]
[   13.163570]                      [<ffffffffc066b828>] snd_hda_jack_report_sync+0xd8/0xe0 [snd_hda_codec]
[   13.163608]                      [<ffffffffc0623fca>] jack_callback+0x8a/0xa0 [snd_hda_codec_hdmi]
[   13.163640]                      [<ffffffffc062408b>] hdmi_unsol_event+0xab/0x140 [snd_hda_codec_hdmi]
[   13.163673]                      [<ffffffffc0661187>] process_unsol_events+0x67/0x80 [snd_hda_codec]
[   13.163706]                      [<ffffffff810a1b1f>] process_one_work+0x1df/0x7f0
[   13.163738]                      [<ffffffff810a2251>] worker_thread+0x121/0x490
[   13.163769]                      [<ffffffff810a7fcc>] kthread+0xfc/0x120
[   13.163801]                      [<ffffffff8184ff7c>] ret_from_fork+0x7c/0xb0
[   13.163833]   }
[   13.163849]   ... key      at: [<ffffffff82eb3018>] __key.29749+0x0/0x8
[   13.163881]   ... acquired at:
[   13.163897]    [<ffffffff810dbea8>] __lock_acquire+0x3e8/0xaf0
[   13.163930]    [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.164049]    [<ffffffff8184fae1>] _raw_spin_lock_irqsave+0x51/0x70
[   13.164080]    [<ffffffff810b7eb1>] try_to_wake_up+0x31/0x510
[   13.164113]    [<ffffffff810b8412>] default_wake_function+0x12/0x20
[   13.164146]    [<ffffffff812450b6>] pollwake+0x66/0x70
[   13.164177]    [<ffffffff810cf3a8>] __wake_up_common+0x58/0x90
[   13.164210]    [<ffffffff810cf65d>] __wake_up+0x3d/0x60
[   13.164241]    [<ffffffffc04449cb>] snd_ctl_notify+0x15b/0x1d0 [snd]
[   13.164276]    [<ffffffffc0448d94>] snd_kctl_jack_report+0x24/0x30 [snd]
[   13.164311]    [<ffffffffc066b810>] snd_hda_jack_report_sync+0xc0/0xe0 [snd_hda_codec]
[   13.164349]    [<ffffffffc0623fca>] jack_callback+0x8a/0xa0 [snd_hda_codec_hdmi]
[   13.164387]    [<ffffffffc062408b>] hdmi_unsol_event+0xab/0x140 [snd_hda_codec_hdmi]
[   13.164424]    [<ffffffffc0661187>] process_unsol_events+0x67/0x80 [snd_hda_codec]
[   13.164463]    [<ffffffff810a1b1f>] process_one_work+0x1df/0x7f0
[   13.164499]    [<ffffffff810a2251>] worker_thread+0x121/0x490
[   13.164536]    [<ffffffff810a7fcc>] kthread+0xfc/0x120
[   13.164573]    [<ffffffff8184ff7c>] ret_from_fork+0x7c/0xb0
[   13.164610] 
[   13.164628] -> (&(&dev->event_lock)->rlock){-.....} ops: 450 {
[   13.164735]    IN-HARDIRQ-W at:
[   13.164771]                     [<ffffffff810dc0fd>] __lock_acquire+0x63d/0xaf0
[   13.164808]                     [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.164845]                     [<ffffffff8184fae1>] _raw_spin_lock_irqsave+0x51/0x70
[   13.164969]                     [<ffffffff81650415>] input_event+0x45/0x70
[   13.165006]                     [<ffffffffc02fd0ff>] hidinput_report_event+0x3f/0x50 [hid]
[   13.165047]                     [<ffffffffc02fb248>] hid_report_raw_event+0x148/0x1c0 [hid]
[   13.165086]                     [<ffffffffc02fb3d2>] hid_input_report+0x112/0x190 [hid]
[   13.165125]                     [<ffffffffc0361cb2>] hid_irq_in+0xb2/0x250 [usbhid]
[   13.165165]                     [<ffffffff815ffa33>] __usb_hcd_giveback_urb+0x83/0x130
[   13.165203]                     [<ffffffff815ffbf3>] usb_hcd_giveback_urb+0x43/0x150
[   13.165240]                     [<ffffffff8164115f>] handle_tx_event+0x22f/0x12b0
[   13.165277]                     [<ffffffff81642496>] xhci_irq+0x2b6/0xa60
[   13.165314]                     [<ffffffff81642c51>] xhci_msi_irq+0x11/0x20
[   13.165351]                     [<ffffffff810f1291>] handle_irq_event_percpu+0x41/0x500
[   13.165389]                     [<ffffffff810f1791>] handle_irq_event+0x41/0x70
[   13.165426]                     [<ffffffff810f460f>] handle_edge_irq+0x7f/0x120
[   13.165463]                     [<ffffffff81020a92>] handle_irq+0x22/0x40
[   13.165500]                     [<ffffffff81853013>] do_IRQ+0x53/0x100
[   13.165537]                     [<ffffffff81850cf2>] ret_from_intr+0x0/0x1a
[   13.165574]                     [<ffffffff8169f337>] cpuidle_enter+0x17/0x20
[   13.165612]                     [<ffffffff810d01f1>] cpu_idle_loop+0x401/0x4e0
[   13.165649]                     [<ffffffff810d032b>] cpu_startup_entry+0x5b/0x60
[   13.165685]                     [<ffffffff81832b5d>] rest_init+0x13d/0x150
[   13.165723]                     [<ffffffff81f5a112>] start_kernel+0x4aa/0x4b7
[   13.165760]                     [<ffffffff81f595ee>] x86_64_start_reservations+0x2a/0x2c
[   13.165797]                     [<ffffffff81f59733>] x86_64_start_kernel+0x143/0x152
[   13.165922]    INITIAL USE at:
[   13.165958]                    [<ffffffff810dbdd4>] __lock_acquire+0x314/0xaf0
[   13.165995]                    [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.166032]                    [<ffffffff8184fae1>] _raw_spin_lock_irqsave+0x51/0x70
[   13.166068]                    [<ffffffff81650415>] input_event+0x45/0x70
[   13.166105]                    [<ffffffff81651cae>] perdevice_input_led_set+0x4e/0x70
[   13.166142]                    [<ffffffff81651ed0>] input_led_connect+0x1c0/0x230
[   13.166179]                    [<ffffffff8164f311>] input_register_device+0x4f1/0x5c0
[   13.166216]                    [<ffffffffc02fffbd>] hidinput_connect+0x33d/0x5f0 [hid]
[   13.166256]                    [<ffffffffc02fc4cd>] hid_connect+0x2fd/0x380 [hid]
[   13.166295]                    [<ffffffffc02fcba4>] hid_device_probe+0x144/0x160 [hid]
[   13.166334]                    [<ffffffff815409cd>] driver_probe_device+0x12d/0x3e0
[   13.166372]                    [<ffffffff81540d63>] __driver_attach+0xa3/0xb0
[   13.166408]                    [<ffffffff8153e7cb>] bus_for_each_dev+0x6b/0xb0
[   13.166445]                    [<ffffffff8154038e>] driver_attach+0x1e/0x20
[   13.166482]                    [<ffffffff8153ff68>] bus_add_driver+0x188/0x260
[   13.166518]                    [<ffffffff81541c04>] driver_register+0x64/0xf0
[   13.166555]                    [<ffffffffc02fa108>] __hid_register_driver+0x68/0xb0 [hid]
[   13.166594]                    [<ffffffffc02d501e>] load_misc_binary+0x1e/0x450 [binfmt_misc]
[   13.166633]                    [<ffffffff81002144>] do_one_initcall+0xd4/0x210
[   13.166671]                    [<ffffffff81124610>] load_module+0x1490/0x1d20
[   13.166709]                    [<ffffffff81125036>] SyS_finit_module+0x86/0xb0
[   13.166746]                    [<ffffffff8185002d>] system_call_fastpath+0x16/0x1b
[   13.166783]  }
[   13.166890]  ... key      at: [<ffffffff82eb2b14>] __key.28123+0x0/0x8
[   13.166926]  ... acquired at:
[   13.166944]    [<ffffffff810d9a29>] check_usage_forwards+0x169/0x170
[   13.166981]    [<ffffffff810db371>] mark_lock+0x1a1/0x2a0
[   13.167017]    [<ffffffff810dc0fd>] __lock_acquire+0x63d/0xaf0
[   13.167055]    [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.167091]    [<ffffffff8184fae1>] _raw_spin_lock_irqsave+0x51/0x70
[   13.167127]    [<ffffffff81650415>] input_event+0x45/0x70
[   13.167163]    [<ffffffffc02fd0ff>] hidinput_report_event+0x3f/0x50 [hid]
[   13.167203]    [<ffffffffc02fb248>] hid_report_raw_event+0x148/0x1c0 [hid]
[   13.167242]    [<ffffffffc02fb3d2>] hid_input_report+0x112/0x190 [hid]
[   13.167282]    [<ffffffffc0361cb2>] hid_irq_in+0xb2/0x250 [usbhid]
[   13.167321]    [<ffffffff815ffa33>] __usb_hcd_giveback_urb+0x83/0x130
[   13.167358]    [<ffffffff815ffbf3>] usb_hcd_giveback_urb+0x43/0x150
[   13.167395]    [<ffffffff8164115f>] handle_tx_event+0x22f/0x12b0
[   13.167432]    [<ffffffff81642496>] xhci_irq+0x2b6/0xa60
[   13.167469]    [<ffffffff81642c51>] xhci_msi_irq+0x11/0x20
[   13.167506]    [<ffffffff810f1291>] handle_irq_event_percpu+0x41/0x500
[   13.167543]    [<ffffffff810f1791>] handle_irq_event+0x41/0x70
[   13.167579]    [<ffffffff810f460f>] handle_edge_irq+0x7f/0x120
[   13.167616]    [<ffffffff81020a92>] handle_irq+0x22/0x40
[   13.167652]    [<ffffffff81853013>] do_IRQ+0x53/0x100
[   13.167689]    [<ffffffff81850cf2>] ret_from_intr+0x0/0x1a
[   13.167726]    [<ffffffff8169f337>] cpuidle_enter+0x17/0x20
[   13.167849]    [<ffffffff810d01f1>] cpu_idle_loop+0x401/0x4e0
[   13.167886]    [<ffffffff810d032b>] cpu_startup_entry+0x5b/0x60
[   13.167923]    [<ffffffff81832b5d>] rest_init+0x13d/0x150
[   13.167960]    [<ffffffff81f5a112>] start_kernel+0x4aa/0x4b7
[   13.167997]    [<ffffffff81f595ee>] x86_64_start_reservations+0x2a/0x2c
[   13.168033]    [<ffffffff81f59733>] x86_64_start_kernel+0x143/0x152
[   13.168070] 
[   13.168088] 
[   13.168088] stack backtrace:
[   13.168107] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-999-generic #201409212205
[   13.168126] Hardware name: MSI MS-7924/Z97M-G43(MS-7924), BIOS V1.5 07/22/2014
[   13.168144]  ffffffff81e1d4c0 ffff88041fa039b8 ffffffff8184569f 0000000000000000
[   13.168234]  ffffffff82be5960 ffff88041fa03a08 ffffffff8183e1b2 ffff88041fa03a30
[   13.168324]  ffffffff81cbf66c ffff88041fa03a1c 0000000000000000 ffffffff81e1dd58
[   13.168415] Call Trace:
[   13.168434]  <IRQ>  [<ffffffff8184569f>] dump_stack+0x4e/0x68
[   13.168475]  [<ffffffff8183e1b2>] print_irq_inversion_bug.part.37+0x1ae/0x1bd
[   13.168496]  [<ffffffff810d9a29>] check_usage_forwards+0x169/0x170
[   13.168517]  [<ffffffff810d98c0>] ? check_usage_backwards+0x170/0x170
[   13.168538]  [<ffffffff810db371>] mark_lock+0x1a1/0x2a0
[   13.168559]  [<ffffffff810dc0fd>] __lock_acquire+0x63d/0xaf0
[   13.168582]  [<ffffffffc02fafcd>] ? hid_input_field+0x11d/0x250 [hid]
[   13.168607]  [<ffffffff810dcd66>] lock_acquire+0xd6/0x2e0
[   13.168628]  [<ffffffff81650415>] ? input_event+0x45/0x70
[   13.168648]  [<ffffffff8184fae1>] _raw_spin_lock_irqsave+0x51/0x70
[   13.168669]  [<ffffffff81650415>] ? input_event+0x45/0x70
[   13.168691]  [<ffffffffc02fafcd>] ? hid_input_field+0x11d/0x250 [hid]
[   13.168716]  [<ffffffff81650415>] input_event+0x45/0x70
[   13.168738]  [<ffffffffc02fd0ff>] hidinput_report_event+0x3f/0x50 [hid]
[   13.168852]  [<ffffffffc02fb248>] hid_report_raw_event+0x148/0x1c0 [hid]
[   13.168879]  [<ffffffffc02fb3d2>] hid_input_report+0x112/0x190 [hid]
[   13.168905]  [<ffffffffc0361cb2>] hid_irq_in+0xb2/0x250 [usbhid]
[   13.168931]  [<ffffffff815ffa33>] __usb_hcd_giveback_urb+0x83/0x130
[   13.168951]  [<ffffffff815ffbf3>] usb_hcd_giveback_urb+0x43/0x150
[   13.168972]  [<ffffffff8164115f>] handle_tx_event+0x22f/0x12b0
[   13.168992]  [<ffffffff8164220c>] ? xhci_irq+0x2c/0xa60
[   13.169013]  [<ffffffff81642496>] xhci_irq+0x2b6/0xa60
[   13.169034]  [<ffffffff81642c51>] xhci_msi_irq+0x11/0x20
[   13.169055]  [<ffffffff810f1291>] handle_irq_event_percpu+0x41/0x500
[   13.169075]  [<ffffffff810f1791>] handle_irq_event+0x41/0x70
[   13.169096]  [<ffffffff810f45ae>] ? handle_edge_irq+0x1e/0x120
[   13.169117]  [<ffffffff810f460f>] handle_edge_irq+0x7f/0x120
[   13.169137]  [<ffffffff81020a92>] handle_irq+0x22/0x40
[   13.169158]  [<ffffffff81853013>] do_IRQ+0x53/0x100
[   13.169178]  [<ffffffff81850cf2>] common_interrupt+0x72/0x72
[   13.169198]  <EOI>  [<ffffffff8169eff5>] ? cpuidle_enter_state+0x75/0x300
[   13.169240]  [<ffffffff8169efee>] ? cpuidle_enter_state+0x6e/0x300
[   13.169260]  [<ffffffff8169f337>] cpuidle_enter+0x17/0x20
[   13.169280]  [<ffffffff810d01f1>] cpu_idle_loop+0x401/0x4e0
[   13.169301]  [<ffffffff810d032b>] cpu_startup_entry+0x5b/0x60
[   13.169322]  [<ffffffff81832b5d>] rest_init+0x13d/0x150
[   13.169342]  [<ffffffff81832a25>] ? rest_init+0x5/0x150
[   13.169363]  [<ffffffff81f81c95>] ? ftrace_init+0xc6/0x159
[   13.169383]  [<ffffffff81f5a112>] start_kernel+0x4aa/0x4b7
[   13.169404]  [<ffffffff81f59a58>] ? set_init_arg+0x55/0x55
[   13.169424]  [<ffffffff81f59120>] ? early_idt_handlers+0x120/0x120
[   13.169445]  [<ffffffff81f595ee>] x86_64_start_reservations+0x2a/0x2c
[   13.169466]  [<ffffffff81f59733>] x86_64_start_kernel+0x143/0x152



I also once saw "INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected" from send_sigio which might be related to this case so pasting it also here:
[    8.638031] ======================================================
[    8.638032] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
[    8.638034] 3.17.0-031700rc3-generic #201409031132 Not tainted
[    8.638034] ------------------------------------------------------
[    8.638036] Xorg/1171 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
[    8.638037]  (tasklist_lock){.+.+..}, at: [<ffffffff812342d5>] send_sigio+0x55/0x1d0
[    8.638043] 
[    8.638043] and this task is already holding:
[    8.638044]  (&f->f_owner.lock){......}, at: [<ffffffff812342aa>] send_sigio+0x2a/0x1d0
[    8.638047] which would create a new lock dependency:
[    8.638047]  (&f->f_owner.lock){......} -> (tasklist_lock){.+.+..}
[    8.638051] 
[    8.638051] but this new dependency connects a HARDIRQ-irq-safe lock:
[    8.638052]  (&(&dev->event_lock)->rlock#2){-.....}
[    8.638052] ... which became HARDIRQ-irq-safe at:
[    8.638054]   [<ffffffff810d3c1d>] __lock_acquire+0x66d/0xb50
[    8.638057]   [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638059]   [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[    8.638063]   [<ffffffff8162f7c5>] input_event+0x45/0x70
[    8.638065]   [<ffffffffc053e07f>] hidinput_report_event+0x3f/0x50 [hid]
[    8.638072]   [<ffffffffc053c1d8>] hid_report_raw_event+0x148/0x1c0 [hid]
[    8.638075]   [<ffffffffc053c362>] hid_input_report+0x112/0x190 [hid]
[    8.638077]   [<ffffffffc05a2c3c>] hid_irq_in+0x8c/0x210 [usbhid]
[    8.638079]   [<ffffffff815e0a73>] __usb_hcd_giveback_urb+0x83/0x130
[    8.638082]   [<ffffffff815e0c2f>] usb_hcd_giveback_urb+0x3f/0x140
[    8.638084]   [<ffffffff816207cf>] handle_tx_event+0x22f/0x12b0
[    8.638087]   [<ffffffff81621b06>] xhci_irq+0x2b6/0xa60
[    8.638089]   [<ffffffff816222c1>] xhci_msi_irq+0x11/0x20
[    8.638091]   [<ffffffff810e7e8e>] handle_irq_event_percpu+0x3e/0x340
[    8.638094]   [<ffffffff810e81cd>] handle_irq_event+0x3d/0x60
[    8.638096]   [<ffffffff810eafef>] handle_edge_irq+0x7f/0x120
[    8.638097]   [<ffffffff8101c85e>] handle_irq+0x1e/0x30
[    8.638101]   [<ffffffff8183738f>] do_IRQ+0x4f/0xf0
[    8.638103]   [<ffffffff81835072>] ret_from_intr+0x0/0x1a
[    8.638105]   [<ffffffff813f490d>] radix_tree_lookup+0xd/0x10
[    8.638108]   [<ffffffff8119e0da>] page_cache_next_hole+0x3a/0x50
[    8.638110]   [<ffffffff811acfd4>] ondemand_readahead+0x334/0x470
[    8.638112]   [<ffffffff811ad190>] page_cache_async_readahead+0x80/0xa0
[    8.638114]   [<ffffffff811a13d3>] filemap_fault+0x303/0x450
[    8.638116]   [<ffffffff811cbf59>] __do_fault+0x39/0x90
[    8.638118]   [<ffffffff811ce7df>] do_read_fault.isra.49+0x20f/0x2f0
[    8.638119]   [<ffffffff811d0618>] handle_mm_fault+0x7b8/0x10d0
[    8.638121]   [<ffffffff81066fe4>] __do_page_fault+0x1d4/0x5a0
[    8.638123]   [<ffffffff810673e1>] do_page_fault+0x31/0x70
[    8.638124]   [<ffffffff81836568>] page_fault+0x28/0x30
[    8.638126] 
[    8.638126] to a HARDIRQ-irq-unsafe lock:
[    8.638127]  (&(&p->alloc_lock)->rlock){+.+...}
[    8.638127] ... which became HARDIRQ-irq-unsafe at:
[    8.638129] ...  [<ffffffff810d3ae8>] __lock_acquire+0x538/0xb50
[    8.638131]   [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638132]   [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[    8.638135]   [<ffffffff81227f0a>] __set_task_comm+0x2a/0x150
[    8.638138]   [<ffffffff810a15c0>] kthreadd+0x30/0x220
[    8.638140]   [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[    8.638143] 
[    8.638143] other info that might help us debug this:
[    8.638143] 
[    8.638144] Chain exists of:
[    8.638144]   &(&dev->event_lock)->rlock#2 --> &f->f_owner.lock --> &(&p->alloc_lock)->rlock
[    8.638144] 
[    8.638147]  Possible interrupt unsafe locking scenario:
[    8.638147] 
[    8.638148]        CPU0                    CPU1
[    8.638148]        ----                    ----
[    8.638149]   lock(&(&p->alloc_lock)->rlock);
[    8.638150]                                local_irq_disable();
[    8.638151]                                lock(&(&dev->event_lock)->rlock#2);
[    8.638152]                                lock(&f->f_owner.lock);
[    8.638154]   <Interrupt>
[    8.638154]     lock(&(&dev->event_lock)->rlock#2);
[    8.638156] 
[    8.638156]  *** DEADLOCK ***
[    8.638156] 
[    8.638157] 9 locks held by Xorg/1171:
[    8.638158]  #0:  (&evdev->mutex){+.+...}, at: [<ffffffff8163486d>] evdev_write+0x8d/0x220
[    8.638161]  #1:  (&(&dev->event_lock)->rlock#2){-.....}, at: [<ffffffff8162f84e>] input_inject_event+0x5e/0x230
[    8.638165]  #2:  (rcu_read_lock){......}, at: [<ffffffff8162f835>] input_inject_event+0x45/0x230
[    8.638168]  #3:  (rcu_read_lock){......}, at: [<ffffffff8162e6e5>] input_pass_values.part.6+0x5/0x370
[    8.638171]  #4:  (rcu_read_lock){......}, at: [<ffffffff81634a05>] evdev_events+0x5/0x2f0
[    8.638174]  #5:  (&(&client->buffer_lock)->rlock){......}, at: [<ffffffff81632fd3>] evdev_pass_values+0x63/0x1c0
[    8.638177]  #6:  (rcu_read_lock){......}, at: [<ffffffff81234471>] kill_fasync+0x21/0x2a0
[    8.638180]  #7:  (&(&new->fa_lock)->rlock){......}, at: [<ffffffff812344ee>] kill_fasync+0x9e/0x2a0
[    8.638183]  #8:  (&f->f_owner.lock){......}, at: [<ffffffff812342aa>] send_sigio+0x2a/0x1d0
[    8.638186] 
[    8.638186] the dependencies between HARDIRQ-irq-safe lock and the holding lock:
[    8.638189]    -> (&(&dev->event_lock)->rlock#2){-.....} ops: 134 {
[    8.638192]       IN-HARDIRQ-W at:
[    8.638193]                           [<ffffffff810d3c1d>] __lock_acquire+0x66d/0xb50
[    8.638195]                           [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638197]                           [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[    8.638199]                           [<ffffffff8162f7c5>] input_event+0x45/0x70
[    8.638201]                           [<ffffffffc053e07f>] hidinput_report_event+0x3f/0x50 [hid]
[    8.638204]                           [<ffffffffc053c1d8>] hid_report_raw_event+0x148/0x1c0 [hid]
[    8.638207]                           [<ffffffffc053c362>] hid_input_report+0x112/0x190 [hid]
[    8.638209]                           [<ffffffffc05a2c3c>] hid_irq_in+0x8c/0x210 [usbhid]
[    8.638211]                           [<ffffffff815e0a73>] __usb_hcd_giveback_urb+0x83/0x130
[    8.638213]                           [<ffffffff815e0c2f>] usb_hcd_giveback_urb+0x3f/0x140
[    8.638215]                           [<ffffffff816207cf>] handle_tx_event+0x22f/0x12b0
[    8.638218]                           [<ffffffff81621b06>] xhci_irq+0x2b6/0xa60
[    8.638219]                           [<ffffffff816222c1>] xhci_msi_irq+0x11/0x20
[    8.638221]                           [<ffffffff810e7e8e>] handle_irq_event_percpu+0x3e/0x340
[    8.638224]                           [<ffffffff810e81cd>] handle_irq_event+0x3d/0x60
[    8.638226]                           [<ffffffff810eafef>] handle_edge_irq+0x7f/0x120
[    8.638228]                           [<ffffffff8101c85e>] handle_irq+0x1e/0x30
[    8.638231]                           [<ffffffff8183738f>] do_IRQ+0x4f/0xf0
[    8.638232]                           [<ffffffff81835072>] ret_from_intr+0x0/0x1a
[    8.638234]                           [<ffffffff813f490d>] radix_tree_lookup+0xd/0x10
[    8.638237]                           [<ffffffff8119e0da>] page_cache_next_hole+0x3a/0x50
[    8.638239]                           [<ffffffff811acfd4>] ondemand_readahead+0x334/0x470
[    8.638241]                           [<ffffffff811ad190>] page_cache_async_readahead+0x80/0xa0
[    8.638242]                           [<ffffffff811a13d3>] filemap_fault+0x303/0x450
[    8.638244]                           [<ffffffff811cbf59>] __do_fault+0x39/0x90
[    8.638246]                           [<ffffffff811ce7df>] do_read_fault.isra.49+0x20f/0x2f0
[    8.638248]                           [<ffffffff811d0618>] handle_mm_fault+0x7b8/0x10d0
[    8.638250]                           [<ffffffff81066fe4>] __do_page_fault+0x1d4/0x5a0
[    8.638251]                           [<ffffffff810673e1>] do_page_fault+0x31/0x70
[    8.638252]                           [<ffffffff81836568>] page_fault+0x28/0x30
[    8.638254]       INITIAL USE at:
[    8.638255]                          [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[    8.638257]                          [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638259]                          [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[    8.638261]                          [<ffffffff8162f7c5>] input_event+0x45/0x70
[    8.638263]                          [<ffffffffc01a1edb>] snd_jack_report+0xbb/0xe0 [snd]
[    8.638270]                          [<ffffffffc076a2f1>] __snd_hda_jack_add_kctl+0x151/0x160 [snd_hda_codec]
[    8.638276]                          [<ffffffffc076a314>] snd_hda_jack_add_kctl+0x14/0x20 [snd_hda_codec]
[    8.638280]                          [<ffffffffc04d36e4>] generic_hdmi_build_jack+0xd4/0x150 [snd_hda_codec_hdmi]
[    8.638282]                          [<ffffffffc04d50c6>] generic_hdmi_build_controls+0x46/0x210 [snd_hda_codec_hdmi]
[    8.638284]                          [<ffffffffc07693d5>] snd_hda_codec_build_controls+0x1c5/0x220 [snd_hda_codec]
[    8.638288]                          [<ffffffffc0769473>] snd_hda_build_controls+0x43/0xa0 [snd_hda_codec]
[    8.638291]                          [<ffffffffc035d365>] azx_mixer_create+0x15/0x20 [snd_hda_controller]
[    8.638294]                          [<ffffffffc0372751>] azx_probe_continue+0x361/0x710 [snd_hda_intel]
[    8.638296]                          [<ffffffffc0372b95>] azx_probe_work+0x15/0x20 [snd_hda_intel]
[    8.638298]                          [<ffffffff8109a5f3>] process_one_work+0x1e3/0x650
[    8.638300]                          [<ffffffff8109ab81>] worker_thread+0x121/0x490
[    8.638301]                          [<ffffffff810a0adc>] kthread+0xfc/0x120
[    8.638303]                          [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[    8.638305]     }
[    8.638305]     ... key      at: [<ffffffff82eae054>] __key.28093+0x0/0x8
[    8.638308]     ... acquired at:
[    8.638308]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[    8.638311]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638312]    [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[    8.638314]    [<ffffffffc019d7cb>] snd_ctl_notify+0x4b/0x1d0 [snd]
[    8.638318]    [<ffffffffc01a1be4>] snd_kctl_jack_report+0x24/0x30 [snd]
[    8.638321]    [<ffffffffc076a040>] snd_hda_jack_report_sync+0xc0/0xe0 [snd_hda_codec]
[    8.638327]    [<ffffffffc04d4f32>] jack_callback+0x82/0x90 [snd_hda_codec_hdmi]
[    8.638329]    [<ffffffffc04d4feb>] hdmi_unsol_event+0xab/0x140 [snd_hda_codec_hdmi]
[    8.638330]    [<ffffffffc0760187>] process_unsol_events+0x67/0x80 [snd_hda_codec]
[    8.638333]    [<ffffffff8109a5f3>] process_one_work+0x1e3/0x650
[    8.638334]    [<ffffffff8109ab81>] worker_thread+0x121/0x490
[    8.638336]    [<ffffffff810a0adc>] kthread+0xfc/0x120
[    8.638337]    [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[    8.638339] 
[    8.638340]   -> (&(&client->buffer_lock)->rlock){......} ops: 12 {
[    8.638342]      INITIAL USE at:
[    8.638343]                        [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[    8.638345]                        [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638346]                        [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[    8.638348]                        [<ffffffff81632fd3>] evdev_pass_values+0x63/0x1c0
[    8.638350]                        [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[    8.638352]                        [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[    8.638354]                        [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[    8.638355]                        [<ffffffff8162f361>] input_handle_event+0x121/0x540
[    8.638357]                        [<ffffffff8162f7d9>] input_event+0x59/0x70
[    8.638359]                        [<ffffffffc01a1ef0>] snd_jack_report+0xd0/0xe0 [snd]
[    8.638362]                        [<ffffffffc076a058>] snd_hda_jack_report_sync+0xd8/0xe0 [snd_hda_codec]
[    8.638366]                        [<ffffffffc04d4f32>] jack_callback+0x82/0x90 [snd_hda_codec_hdmi]
[    8.638367]                        [<ffffffffc04d4feb>] hdmi_unsol_event+0xab/0x140 [snd_hda_codec_hdmi]
[    8.638369]                        [<ffffffffc0760187>] process_unsol_events+0x67/0x80 [snd_hda_codec]
[    8.638372]                        [<ffffffff8109a5f3>] process_one_work+0x1e3/0x650
[    8.638373]                        [<ffffffff8109ab81>] worker_thread+0x121/0x490
[    8.638374]                        [<ffffffff810a0adc>] kthread+0xfc/0x120
[    8.638376]                        [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[    8.638378]    }
[    8.638378]    ... key      at: [<ffffffff82eae118>] __key.29718+0x0/0x8
[    8.638380]    ... acquired at:
[    8.638381]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[    8.638383]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638384]    [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[    8.638386]    [<ffffffff814170e2>] __percpu_counter_add+0x42/0x80
[    8.638388]    [<ffffffff812a77d6>] ext4_claim_free_clusters+0x36/0x40
[    8.638390]    [<ffffffff812ea133>] ext4_mb_new_blocks+0xa3/0x760
[    8.638392]    [<ffffffff812dd5a6>] ext4_ext_map_blocks+0x676/0x13c0
[    8.638394]    [<ffffffff812b0751>] ext4_map_blocks+0x151/0x500
[    8.638395]    [<ffffffff812d77ef>] ext4_alloc_file_blocks.isra.39+0xcf/0x2b0
[    8.638397]    [<ffffffff812df4af>] ext4_fallocate+0xef/0xb80
[    8.638398]    [<ffffffff8121e8d7>] do_fallocate+0x127/0x1c0
[    8.638400]    [<ffffffff8121e9b4>] SyS_fallocate+0x44/0x70
[    8.638402]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[    8.638404] 
[    8.638405]  -> (&(&new->fa_lock)->rlock){......} ops: 1 {
[    8.638407]     INITIAL USE at:
[    8.638408]                      [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[    8.638410]                      [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638411]                      [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[    8.638413]                      [<ffffffff812344ee>] kill_fasync+0x9e/0x2a0
[    8.638415]                      [<ffffffff81633063>] evdev_pass_values+0xf3/0x1c0
[    8.638417]                      [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[    8.638419]                      [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[    8.638420]                      [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[    8.638422]                      [<ffffffff8162f361>] input_handle_event+0x121/0x540
[    8.638424]                      [<ffffffff8162f988>] input_inject_event+0x198/0x230
[    8.638425]                      [<ffffffff8163497c>] evdev_write+0x19c/0x220
[    8.638427]                      [<ffffffff812208f7>] vfs_write+0xb7/0x1f0
[    8.638428]                      [<ffffffff81221359>] SyS_write+0x49/0xb0
[    8.638430]                      [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[    8.638432]   }
[    8.638432]   ... key      at: [<ffffffff82e84274>] __key.36822+0x0/0x8
[    8.638435]   ... acquired at:
[    8.638436]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[    8.638437]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638439]    [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[    8.638441]    [<ffffffff812342aa>] send_sigio+0x2a/0x1d0
[    8.638442]    [<ffffffff8123451c>] kill_fasync+0xcc/0x2a0
[    8.638444]    [<ffffffff81633063>] evdev_pass_values+0xf3/0x1c0
[    8.638445]    [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[    8.638447]    [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[    8.638449]    [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[    8.638450]    [<ffffffff8162f361>] input_handle_event+0x121/0x540
[    8.638452]    [<ffffffff8162f988>] input_inject_event+0x198/0x230
[    8.638453]    [<ffffffff8163497c>] evdev_write+0x19c/0x220
[    8.638455]    [<ffffffff812208f7>] vfs_write+0xb7/0x1f0
[    8.638456]    [<ffffffff81221359>] SyS_write+0x49/0xb0
[    8.638458]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[    8.638459] 
[    8.638460] -> (&f->f_owner.lock){......} ops: 8 {
[    8.638462]    INITIAL USE at:
[    8.638463]                    [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[    8.638465]                    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638466]                    [<ffffffff81833ba5>] _raw_write_lock_irq+0x45/0x60
[    8.638468]                    [<ffffffff81233687>] __f_setown+0x47/0xe0
[    8.638470]                    [<ffffffff812337bd>] f_setown+0x7d/0x120
[    8.638471]                    [<ffffffff81233f01>] SyS_fcntl+0x341/0x6c0
[    8.638473]                    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[    8.638475]  }
[    8.638475]  ... key      at: [<ffffffff82e83920>] __key.31233+0x0/0x8
[    8.638477]  ... acquired at:
[    8.638478]    [<ffffffff810d1a7a>] check_irq_usage+0x4a/0xc0
[    8.638479]    [<ffffffff810d2324>] validate_chain.isra.40+0x834/0x10e0
[    8.638481]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[    8.638483]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638484]    [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[    8.638486]    [<ffffffff812342d5>] send_sigio+0x55/0x1d0
[    8.638487]    [<ffffffff8123451c>] kill_fasync+0xcc/0x2a0
[    8.638489]    [<ffffffff81633063>] evdev_pass_values+0xf3/0x1c0
[    8.638490]    [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[    8.638492]    [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[    8.638494]    [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[    8.638495]    [<ffffffff8162f361>] input_handle_event+0x121/0x540
[    8.638497]    [<ffffffff8162f988>] input_inject_event+0x198/0x230
[    8.638498]    [<ffffffff8163497c>] evdev_write+0x19c/0x220
[    8.638500]    [<ffffffff812208f7>] vfs_write+0xb7/0x1f0
[    8.638501]    [<ffffffff81221359>] SyS_write+0x49/0xb0
[    8.638503]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[    8.638504] 
[    8.638505] 
[    8.638505] the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
[    8.638508]  -> (&(&p->alloc_lock)->rlock){+.+...} ops: 28696 {
[    8.638511]     HARDIRQ-ON-W at:
[    8.638512]                       [<ffffffff810d3ae8>] __lock_acquire+0x538/0xb50
[    8.638513]                       [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638515]                       [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[    8.638517]                       [<ffffffff81227f0a>] __set_task_comm+0x2a/0x150
[    8.638518]                       [<ffffffff810a15c0>] kthreadd+0x30/0x220
[    8.638520]                       [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[    8.638522]     SOFTIRQ-ON-W at:
[    8.638523]                       [<ffffffff810d38a3>] __lock_acquire+0x2f3/0xb50
[    8.638524]                       [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638526]                       [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[    8.638528]                       [<ffffffff81227f0a>] __set_task_comm+0x2a/0x150
[    8.638530]                       [<ffffffff810a15c0>] kthreadd+0x30/0x220
[    8.638531]                       [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[    8.638533]     INITIAL USE at:
[    8.638534]                      [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[    8.638535]                      [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638537]                      [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[    8.638539]                      [<ffffffff81227f0a>] __set_task_comm+0x2a/0x150
[    8.638541]                      [<ffffffff810a15c0>] kthreadd+0x30/0x220
[    8.638542]                      [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[    8.638544]   }
[    8.638544]   ... key      at: [<ffffffff82119008>] __key.51772+0x0/0x8
[    8.638546]   ... acquired at:
[    8.638547]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[    8.638548]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638550]    [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[    8.638552]    [<ffffffff81093eeb>] do_prlimit+0x9b/0x200
[    8.638554]    [<ffffffff8109407a>] SyS_getrlimit+0x2a/0x70
[    8.638556]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[    8.638558] 
[    8.638558] -> (tasklist_lock){.+.+..} ops: 26264 {
[    8.638561]    HARDIRQ-ON-R at:
[    8.638562]                     [<ffffffff810d3881>] __lock_acquire+0x2d1/0xb50
[    8.638563]                     [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638565]                     [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[    8.638567]                     [<ffffffff8107d796>] do_wait+0xb6/0x340
[    8.638568]                     [<ffffffff8107ed54>] SyS_wait4+0x64/0xe0
[    8.638569]                     [<ffffffff8109500b>] wait_for_helper+0x4b/0x70
[    8.638571]                     [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[    8.638573]    SOFTIRQ-ON-R at:
[    8.638574]                     [<ffffffff810d38a3>] __lock_acquire+0x2f3/0xb50
[    8.638575]                     [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638577]                     [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[    8.638579]                     [<ffffffff8107d796>] do_wait+0xb6/0x340
[    8.638580]                     [<ffffffff8107ed54>] SyS_wait4+0x64/0xe0
[    8.638581]                     [<ffffffff8109500b>] wait_for_helper+0x4b/0x70
[    8.638583]                     [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[    8.638585]    INITIAL USE at:
[    8.638585]                    [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[    8.638587]                    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638589]                    [<ffffffff81833ba5>] _raw_write_lock_irq+0x45/0x60
[    8.638591]                    [<ffffffff81078861>] copy_process.part.23+0xcf1/0x1e50
[    8.638593]                    [<ffffffff81079b6e>] do_fork+0xce/0x750
[    8.638594]                    [<ffffffff8107a216>] kernel_thread+0x26/0x30
[    8.638596]                    [<ffffffff81817bb3>] rest_init+0x23/0x140
[    8.638598]                    [<ffffffff81f590ee>] start_kernel+0x499/0x4a4
[    8.638600]                    [<ffffffff81f585ee>] x86_64_start_reservations+0x2a/0x2c
[    8.638602]                    [<ffffffff81f58733>] x86_64_start_kernel+0x143/0x152
[    8.638604]  }
[    8.638604]  ... key      at: [<ffffffff81e0f058>] tasklist_lock+0x18/0x40
[    8.638607]  ... acquired at:
[    8.638608]    [<ffffffff810d1a7a>] check_irq_usage+0x4a/0xc0
[    8.638610]    [<ffffffff810d2324>] validate_chain.isra.40+0x834/0x10e0
[    8.638611]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[    8.638613]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638614]    [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[    8.638616]    [<ffffffff812342d5>] send_sigio+0x55/0x1d0
[    8.638618]    [<ffffffff8123451c>] kill_fasync+0xcc/0x2a0
[    8.638619]    [<ffffffff81633063>] evdev_pass_values+0xf3/0x1c0
[    8.638621]    [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[    8.638623]    [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[    8.638624]    [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[    8.638626]    [<ffffffff8162f361>] input_handle_event+0x121/0x540
[    8.638628]    [<ffffffff8162f988>] input_inject_event+0x198/0x230
[    8.638629]    [<ffffffff8163497c>] evdev_write+0x19c/0x220
[    8.638631]    [<ffffffff812208f7>] vfs_write+0xb7/0x1f0
[    8.638632]    [<ffffffff81221359>] SyS_write+0x49/0xb0
[    8.638633]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[    8.638635] 
[    8.638636] 
[    8.638636] stack backtrace:
[    8.638638] CPU: 0 PID: 1171 Comm: Xorg Not tainted 3.17.0-031700rc3-generic #201409031132
[    8.638639] Hardware name: MSI MS-7924/Z97M-G43(MS-7924), BIOS V1.5 07/22/2014
[    8.638640]  ffffffff8285faa0 ffff880404003958 ffffffff81829c6a ffffffff82bd77a0
[    8.638642]  ffff880404003a58 ffffffff810d1a1a 0000000000000000 ffff880400000000
[    8.638644]  ffffffff00000001 ffff880404003ff8 ffffffff82c27d60 ffffffff82bd77a0
[    8.638646] Call Trace:
[    8.638650]  [<ffffffff81829c6a>] dump_stack+0x4d/0x66
[    8.638652]  [<ffffffff810d1a1a>] check_usage+0x50a/0x520
[    8.638655]  [<ffffffff81119536>] ? is_module_text_address+0x16/0x30
[    8.638657]  [<ffffffff810d1a7a>] check_irq_usage+0x4a/0xc0
[    8.638659]  [<ffffffff810d2324>] validate_chain.isra.40+0x834/0x10e0
[    8.638661]  [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[    8.638663]  [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[    8.638665]  [<ffffffff812342d5>] ? send_sigio+0x55/0x1d0
[    8.638667]  [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[    8.638668]  [<ffffffff812342d5>] ? send_sigio+0x55/0x1d0
[    8.638670]  [<ffffffff812342d5>] send_sigio+0x55/0x1d0
[    8.638671]  [<ffffffff8123451c>] kill_fasync+0xcc/0x2a0
[    8.638673]  [<ffffffff81234471>] ? kill_fasync+0x21/0x2a0
[    8.638675]  [<ffffffff81633063>] evdev_pass_values+0xf3/0x1c0
[    8.638677]  [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[    8.638679]  [<ffffffff81634a05>] ? evdev_events+0x5/0x2f0
[    8.638681]  [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[    8.638683]  [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[    8.638684]  [<ffffffff8162e6e5>] ? input_pass_values.part.6+0x5/0x370
[    8.638686]  [<ffffffff8162f361>] input_handle_event+0x121/0x540
[    8.638688]  [<ffffffff8162f988>] input_inject_event+0x198/0x230
[    8.638690]  [<ffffffff8162f835>] ? input_inject_event+0x45/0x230
[    8.638692]  [<ffffffff8163497c>] evdev_write+0x19c/0x220
[    8.638693]  [<ffffffff812208f7>] vfs_write+0xb7/0x1f0
[    8.638695]  [<ffffffff81221359>] SyS_write+0x49/0xb0
[    8.638697]  [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
