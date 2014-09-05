Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546AbaIEQVI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:21:08 -0400
Received: from mail-lb0-f196.google.com ([209.85.217.196]:37115 "EHLO
	mail-lb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaIEQVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:21:05 -0400
Message-ID: <5409E2EB.4080000@gmail.com>
Date: Fri, 05 Sep 2014 19:20:59 +0300
From: Kari Suvanto <kari.tj.suvanto@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: INFO: possible irq lock inversion dependency detected
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I noticed, with next/master tree, this lockdep splat and at least I could not find any discussion about this by googling:
[   33.105722] =========================================================
[   33.105722] [ INFO: possible irq lock inversion dependency detected ]
[   33.105724] 3.17.0-031700rc3-generic #201409031132 Not tainted
[   33.105724] ---------------------------------------------------------
[   33.105725] swapper/0/0 just changed the state of lock:
[   33.105726]  (&(&dev->event_lock)->rlock#2){-.....}, at: [<ffffffff8162f7c5>] input_event+0x45/0x70
[   33.105733] but this lock took another, HARDIRQ-unsafe lock in the past:
[   33.105734]  (&(&p->alloc_lock)->rlock){+.+...}
[   33.105734]
[   33.105734] and interrupts could create inverse lock ordering between them.
[   33.105734]
[   33.105736]
[   33.105736] other info that might help us debug this:
[   33.105737] Chain exists of:
[   33.105737]   &(&dev->event_lock)->rlock#2 --> &(&client->buffer_lock)->rlock --> &(&p->alloc_lock)->rlock
[   33.105737]
[   33.105740]  Possible interrupt unsafe locking scenario:
[   33.105740]
[   33.105740]        CPU0                    CPU1
[   33.105741]        ----                    ----
[   33.105742]   lock(&(&p->alloc_lock)->rlock);
[   33.105743]                                local_irq_disable();
[   33.105743]                                lock(&(&dev->event_lock)->rlock#2);
[   33.105745]                                lock(&(&client->buffer_lock)->rlock);
[   33.105746]   <Interrupt>
[   33.105747]     lock(&(&dev->event_lock)->rlock#2);
[   33.105748]
[   33.105748]  *** DEADLOCK ***
[   33.105748]
[   33.105749] no locks held by swapper/0/0.
[   33.105750]
[   33.105750] the shortest dependencies between 2nd lock and 1st lock:
[   33.105755]      -> (&(&p->alloc_lock)->rlock){+.+...} ops: 30838 {
[   33.105757]         HARDIRQ-ON-W at:
[   33.105758]                               [<ffffffff810d3ae8>] __lock_acquire+0x538/0xb50
[   33.105761]                               [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105763]                               [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[   33.105766]                               [<ffffffff81227f0a>] __set_task_comm+0x2a/0x150
[   33.105769]                               [<ffffffff810a15c0>] kthreadd+0x30/0x220
[   33.105772]                               [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[   33.105774]         SOFTIRQ-ON-W at:
[   33.105775]                               [<ffffffff810d38a3>] __lock_acquire+0x2f3/0xb50
[   33.105776]                               [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105778]                               [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[   33.105780]                               [<ffffffff81227f0a>] __set_task_comm+0x2a/0x150
[   33.105782]                               [<ffffffff810a15c0>] kthreadd+0x30/0x220
[   33.105783]                               [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[   33.105785]         INITIAL USE at:
[   33.105786]                              [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[   33.105787]                              [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105789]                              [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[   33.105791]                              [<ffffffff81227f0a>] __set_task_comm+0x2a/0x150
[   33.105792]                              [<ffffffff810a15c0>] kthreadd+0x30/0x220
[   33.105794]                              [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[   33.105796]       }
[   33.105796]       ... key      at: [<ffffffff82119008>] __key.51772+0x0/0x8
[   33.105799]       ... acquired at:
[   33.105799]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[   33.105801]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105802]    [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[   33.105804]    [<ffffffff81093eeb>] do_prlimit+0x9b/0x200
[   33.105806]    [<ffffffff8109407a>] SyS_getrlimit+0x2a/0x70
[   33.105808]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[   33.105810]
[   33.105811]     -> (tasklist_lock){.+.+..} ops: 26419 {
[   33.105813]        HARDIRQ-ON-R at:
[   33.105813]                             [<ffffffff810d3881>] __lock_acquire+0x2d1/0xb50
[   33.105815]                             [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105817]                             [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[   33.105818]                             [<ffffffff8107d796>] do_wait+0xb6/0x340
[   33.105820]                             [<ffffffff8107ed54>] SyS_wait4+0x64/0xe0
[   33.105822]                             [<ffffffff8109500b>] wait_for_helper+0x4b/0x70
[   33.105824]                             [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[   33.105825]        SOFTIRQ-ON-R at:
[   33.105826]                             [<ffffffff810d38a3>] __lock_acquire+0x2f3/0xb50
[   33.105828]                             [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105829]                             [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[   33.105831]                             [<ffffffff8107d796>] do_wait+0xb6/0x340
[   33.105833]                             [<ffffffff8107ed54>] SyS_wait4+0x64/0xe0
[   33.105834]                             [<ffffffff8109500b>] wait_for_helper+0x4b/0x70
[   33.105836]                             [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[   33.105837]        INITIAL USE at:
[   33.105838]                            [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[   33.105840]                            [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105842]                            [<ffffffff81833ba5>] _raw_write_lock_irq+0x45/0x60
[   33.105843]                            [<ffffffff81078861>] copy_process.part.23+0xcf1/0x1e50
[   33.105846]                            [<ffffffff81079b6e>] do_fork+0xce/0x750
[   33.105847]                            [<ffffffff8107a216>] kernel_thread+0x26/0x30
[   33.105849]                            [<ffffffff81817bb3>] rest_init+0x23/0x140
[   33.105851]                            [<ffffffff81f590ee>] start_kernel+0x499/0x4a4
[   33.105853]                            [<ffffffff81f585ee>] x86_64_start_reservations+0x2a/0x2c
[   33.105855]                            [<ffffffff81f58733>] x86_64_start_kernel+0x143/0x152
[   33.105857]      }
[   33.105858]      ... key      at: [<ffffffff81e0f058>] tasklist_lock+0x18/0x40
[   33.105860]      ... acquired at:
[   33.105861]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[   33.105863]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105864]    [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[   33.105866]    [<ffffffff812342d5>] send_sigio+0x55/0x1d0
[   33.105868]    [<ffffffff8123451c>] kill_fasync+0xcc/0x2a0
[   33.105870]    [<ffffffff81633063>] evdev_pass_values+0xf3/0x1c0
[   33.105871]    [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[   33.105873]    [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[   33.105875]    [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[   33.105876]    [<ffffffff8162f361>] input_handle_event+0x121/0x540
[   33.105878]    [<ffffffff8162f988>] input_inject_event+0x198/0x230
[   33.105880]    [<ffffffff8163497c>] evdev_write+0x19c/0x220
[   33.105881]    [<ffffffff812208f7>] vfs_write+0xb7/0x1f0
[   33.105883]    [<ffffffff81221359>] SyS_write+0x49/0xb0
[   33.105884]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[   33.105886]
[   33.105887]    -> (&f->f_owner.lock){......} ops: 8 {
[   33.105889]       INITIAL USE at:
[   33.105890]                          [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[   33.105891]                          [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105893]                          [<ffffffff81833ba5>] _raw_write_lock_irq+0x45/0x60
[   33.105895]                          [<ffffffff81233687>] __f_setown+0x47/0xe0
[   33.105896]                          [<ffffffff812337bd>] f_setown+0x7d/0x120
[   33.105897]                          [<ffffffff81233f01>] SyS_fcntl+0x341/0x6c0
[   33.105899]                          [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[   33.105901]     }
[   33.105901]     ... key      at: [<ffffffff82e83920>] __key.31233+0x0/0x8
[   33.105905]     ... acquired at:
[   33.105905]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[   33.105907]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105908]    [<ffffffff8183382c>] _raw_read_lock+0x3c/0x50
[   33.105910]    [<ffffffff812342aa>] send_sigio+0x2a/0x1d0
[   33.105911]    [<ffffffff8123451c>] kill_fasync+0xcc/0x2a0
[   33.105913]    [<ffffffff81633063>] evdev_pass_values+0xf3/0x1c0
[   33.105914]    [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[   33.105916]    [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[   33.105918]    [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[   33.105919]    [<ffffffff8162f361>] input_handle_event+0x121/0x540
[   33.105921]    [<ffffffff8162f988>] input_inject_event+0x198/0x230
[   33.105922]    [<ffffffff8163497c>] evdev_write+0x19c/0x220
[   33.105924]    [<ffffffff812208f7>] vfs_write+0xb7/0x1f0
[   33.105925]    [<ffffffff81221359>] SyS_write+0x49/0xb0
[   33.105926]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[   33.105928]
[   33.105928]   -> (&(&new->fa_lock)->rlock){......} ops: 1 {
[   33.105930]      INITIAL USE at:
[   33.105931]                        [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[   33.105933]                        [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105934]                        [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[   33.105936]                        [<ffffffff812344ee>] kill_fasync+0x9e/0x2a0
[   33.105938]                        [<ffffffff81633063>] evdev_pass_values+0xf3/0x1c0
[   33.105939]                        [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[   33.105941]                        [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[   33.105942]                        [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[   33.105944]                        [<ffffffff8162f361>] input_handle_event+0x121/0x540
[   33.105946]                        [<ffffffff8162f988>] input_inject_event+0x198/0x230
[   33.105947]                        [<ffffffff8163497c>] evdev_write+0x19c/0x220
[   33.105949]                        [<ffffffff812208f7>] vfs_write+0xb7/0x1f0
[   33.105950]                        [<ffffffff81221359>] SyS_write+0x49/0xb0
[   33.105951]                        [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[   33.105953]    }
[   33.105953]    ... key      at: [<ffffffff82e84274>] __key.36822+0x0/0x8
[   33.105955]    ... acquired at:
[   33.105956]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[   33.105957]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105959]    [<ffffffff8182ef4b>] mutex_lock_nested+0x6b/0x4e0
[   33.105960]    [<ffffffff812a3f6e>] kernfs_fop_open+0x16e/0x360
[   33.105963]    [<ffffffff8121dcff>] do_dentry_open+0x1ff/0x350
[   33.105965]    [<ffffffff8121e030>] finish_open+0x40/0x50
[   33.105967]    [<ffffffff8123108a>] do_last+0xc0a/0x13c0
[   33.105968]    [<ffffffff812318fb>] path_openat+0xbb/0x680
[   33.105970]    [<ffffffff812326ea>] do_filp_open+0x3a/0x90
[   33.105971]    [<ffffffff8121f8d8>] do_sys_open+0x128/0x220
[   33.105973]    [<ffffffff8121f9ee>] SyS_open+0x1e/0x20
[   33.105974]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[   33.105976]
[   33.105977]  -> (&(&client->buffer_lock)->rlock){......} ops: 15 {
[   33.105979]     INITIAL USE at:
[   33.105980]                      [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[   33.105981]                      [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.105983]                      [<ffffffff818334e9>] _raw_spin_lock+0x39/0x50
[   33.105984]                      [<ffffffff81632fd3>] evdev_pass_values+0x63/0x1c0
[   33.105986]                      [<ffffffff81634bd3>] evdev_events+0x1d3/0x2f0
[   33.105988]                      [<ffffffff8162ba77>] input_to_handler+0x97/0xf0
[   33.105989]                      [<ffffffff8162e9ac>] input_pass_values.part.6+0x2cc/0x370
[   33.105991]                      [<ffffffff8162f361>] input_handle_event+0x121/0x540
[   33.105992]                      [<ffffffff8162f7d9>] input_event+0x59/0x70
[   33.105994]                      [<ffffffffc0234ef0>] snd_jack_report+0xd0/0xe0 [snd]
[   33.106000]                      [<ffffffffc0393058>] snd_hda_jack_report_sync+0xd8/0xe0 [snd_hda_codec]
[   33.106006]                      [<ffffffffc042ff32>] jack_callback+0x82/0x90 [snd_hda_codec_hdmi]
[   33.106008]                      [<ffffffffc042ffeb>] hdmi_unsol_event+0xab/0x140 [snd_hda_codec_hdmi]
[   33.106010]                      [<ffffffffc0389187>] process_unsol_events+0x67/0x80 [snd_hda_codec]
[   33.106013]                      [<ffffffff8109a5f3>] process_one_work+0x1e3/0x650
[   33.106014]                      [<ffffffff8109ab81>] worker_thread+0x121/0x490
[   33.106015]                      [<ffffffff810a0adc>] kthread+0xfc/0x120
[   33.106017]                      [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[   33.106019]   }
[   33.106020]   ... key      at: [<ffffffff82eae118>] __key.29718+0x0/0x8
[   33.106022]   ... acquired at:
[   33.106023]    [<ffffffff810d39c8>] __lock_acquire+0x418/0xb50
[   33.106025]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.106026]    [<ffffffff8182ef4b>] mutex_lock_nested+0x6b/0x4e0
[   33.106028]    [<ffffffff812a3f6e>] kernfs_fop_open+0x16e/0x360
[   33.106029]    [<ffffffff8121dcff>] do_dentry_open+0x1ff/0x350
[   33.106031]    [<ffffffff8121e030>] finish_open+0x40/0x50
[   33.106033]    [<ffffffff8123108a>] do_last+0xc0a/0x13c0
[   33.106034]    [<ffffffff812318fb>] path_openat+0xbb/0x680
[   33.106035]    [<ffffffff812326ea>] do_filp_open+0x3a/0x90
[   33.106036]    [<ffffffff8121f8d8>] do_sys_open+0x128/0x220
[   33.106038]    [<ffffffff8121f9ee>] SyS_open+0x1e/0x20
[   33.106040]    [<ffffffff8183436d>] system_call_fastpath+0x1a/0x1f
[   33.106041]
[   33.106042] -> (&(&dev->event_lock)->rlock#2){-.....} ops: 176 {
[   33.106044]    IN-HARDIRQ-W at:
[   33.106045]                     [<ffffffff810d3c1d>] __lock_acquire+0x66d/0xb50
[   33.106047]                     [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.106048]                     [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[   33.106050]                     [<ffffffff8162f7c5>] input_event+0x45/0x70
[   33.106052]                     [<ffffffffc03cc07f>] hidinput_report_event+0x3f/0x50 [hid]
[   33.106054]                     [<ffffffffc03ca1d8>] hid_report_raw_event+0x148/0x1c0 [hid]
[   33.106057]                     [<ffffffffc03ca362>] hid_input_report+0x112/0x190 [hid]
[   33.106059]                     [<ffffffffc03eac3c>] hid_irq_in+0x8c/0x210 [usbhid]
[   33.106061]                     [<ffffffff815e0a73>] __usb_hcd_giveback_urb+0x83/0x130
[   33.106063]                     [<ffffffff815e0c2f>] usb_hcd_giveback_urb+0x3f/0x140
[   33.106065]                     [<ffffffff816207cf>] handle_tx_event+0x22f/0x12b0
[   33.106068]                     [<ffffffff81621b06>] xhci_irq+0x2b6/0xa60
[   33.106069]                     [<ffffffff816222c1>] xhci_msi_irq+0x11/0x20
[   33.106071]                     [<ffffffff810e7e8e>] handle_irq_event_percpu+0x3e/0x340
[   33.106073]                     [<ffffffff810e81cd>] handle_irq_event+0x3d/0x60
[   33.106075]                     [<ffffffff810eafef>] handle_edge_irq+0x7f/0x120
[   33.106076]                     [<ffffffff8101c85e>] handle_irq+0x1e/0x30
[   33.106079]                     [<ffffffff8183738f>] do_IRQ+0x4f/0xf0
[   33.106081]                     [<ffffffff81835072>] ret_from_intr+0x0/0x1a
[   33.106082]                     [<ffffffff8167c147>] cpuidle_enter+0x17/0x20
[   33.106084]                     [<ffffffff810c7bb1>] cpu_idle_loop+0x401/0x4e0
[   33.106086]                     [<ffffffff810c7ceb>] cpu_startup_entry+0x5b/0x60
[   33.106087]                     [<ffffffff81817cca>] rest_init+0x13a/0x140
[   33.106088]                     [<ffffffff81f590ee>] start_kernel+0x499/0x4a4
[   33.106090]                     [<ffffffff81f585ee>] x86_64_start_reservations+0x2a/0x2c
[   33.106092]                     [<ffffffff81f58733>] x86_64_start_kernel+0x143/0x152
[   33.106094]    INITIAL USE at:
[   33.106094]                    [<ffffffff810d38f4>] __lock_acquire+0x344/0xb50
[   33.106096]                    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.106098]                    [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[   33.106099]                    [<ffffffff8162f7c5>] input_event+0x45/0x70
[   33.106101]                    [<ffffffffc0234edb>] snd_jack_report+0xbb/0xe0 [snd]
[   33.106105]                    [<ffffffffc03932f1>] __snd_hda_jack_add_kctl+0x151/0x160 [snd_hda_codec]
[   33.106109]                    [<ffffffffc0393314>] snd_hda_jack_add_kctl+0x14/0x20 [snd_hda_codec]
[   33.106112]                    [<ffffffffc042e6e4>] generic_hdmi_build_jack+0xd4/0x150 [snd_hda_codec_hdmi]
[   33.106114]                    [<ffffffffc04300c6>] generic_hdmi_build_controls+0x46/0x210 [snd_hda_codec_hdmi]
[   33.106116]                    [<ffffffffc03923d5>] snd_hda_codec_build_controls+0x1c5/0x220 [snd_hda_codec]
[   33.106120]                    [<ffffffffc0392473>] snd_hda_build_controls+0x43/0xa0 [snd_hda_codec]
[   33.106123]                    [<ffffffffc03bf365>] azx_mixer_create+0x15/0x20 [snd_hda_controller]
[   33.106125]                    [<ffffffffc03ae751>] azx_probe_continue+0x361/0x710 [snd_hda_intel]
[   33.106127]                    [<ffffffffc03aeb95>] azx_probe_work+0x15/0x20 [snd_hda_intel]
[   33.106129]                    [<ffffffff8109a5f3>] process_one_work+0x1e3/0x650
[   33.106130]                    [<ffffffff8109ab81>] worker_thread+0x121/0x490
[   33.106132]                    [<ffffffff810a0adc>] kthread+0xfc/0x120
[   33.106134]                    [<ffffffff818342bc>] ret_from_fork+0x7c/0xb0
[   33.106135]  }
[   33.106136]  ... key      at: [<ffffffff82eae054>] __key.28093+0x0/0x8
[   33.106138]  ... acquired at:
[   33.106138]    [<ffffffff810d150a>] check_usage_forwards+0x17a/0x180
[   33.106140]    [<ffffffff810d2e71>] mark_lock+0x1a1/0x2a0
[   33.106141]    [<ffffffff810d3c1d>] __lock_acquire+0x66d/0xb50
[   33.106143]    [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.106145]    [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[   33.106146]    [<ffffffff8162f7c5>] input_event+0x45/0x70
[   33.106148]    [<ffffffffc03cc07f>] hidinput_report_event+0x3f/0x50 [hid]
[   33.106151]    [<ffffffffc03ca1d8>] hid_report_raw_event+0x148/0x1c0 [hid]
[   33.106153]    [<ffffffffc03ca362>] hid_input_report+0x112/0x190 [hid]
[   33.106155]    [<ffffffffc03eac3c>] hid_irq_in+0x8c/0x210 [usbhid]
[   33.106157]    [<ffffffff815e0a73>] __usb_hcd_giveback_urb+0x83/0x130
[   33.106159]    [<ffffffff815e0c2f>] usb_hcd_giveback_urb+0x3f/0x140
[   33.106160]    [<ffffffff816207cf>] handle_tx_event+0x22f/0x12b0
[   33.106162]    [<ffffffff81621b06>] xhci_irq+0x2b6/0xa60
[   33.106164]    [<ffffffff816222c1>] xhci_msi_irq+0x11/0x20
[   33.106165]    [<ffffffff810e7e8e>] handle_irq_event_percpu+0x3e/0x340
[   33.106167]    [<ffffffff810e81cd>] handle_irq_event+0x3d/0x60
[   33.106169]    [<ffffffff810eafef>] handle_edge_irq+0x7f/0x120
[   33.106170]    [<ffffffff8101c85e>] handle_irq+0x1e/0x30
[   33.106172]    [<ffffffff8183738f>] do_IRQ+0x4f/0xf0
[   33.106174]    [<ffffffff81835072>] ret_from_intr+0x0/0x1a
[   33.106175]    [<ffffffff8167c147>] cpuidle_enter+0x17/0x20
[   33.106177]    [<ffffffff810c7bb1>] cpu_idle_loop+0x401/0x4e0
[   33.106178]    [<ffffffff810c7ceb>] cpu_startup_entry+0x5b/0x60
[   33.106179]    [<ffffffff81817cca>] rest_init+0x13a/0x140
[   33.106181]    [<ffffffff81f590ee>] start_kernel+0x499/0x4a4
[   33.106182]    [<ffffffff81f585ee>] x86_64_start_reservations+0x2a/0x2c
[   33.106184]    [<ffffffff81f58733>] x86_64_start_kernel+0x143/0x152
[   33.106185]
[   33.106186]
[   33.106186] stack backtrace:
[   33.106188] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 3.17.0-031700rc3-generic #201409031132
[   33.106189] Hardware name: MSI MS-7924/Z97M-G43(MS-7924), BIOS V1.5 07/22/2014
[   33.106190]  ffffffff81e1d4c0 ffff88041ba03a60 ffffffff81829c6a ffffffff82bd7620
[   33.106192]  ffff88041ba03aa0 ffffffff81822ff3 ffffffff81cbcf5e 0000000000000000
[   33.106193]  ffffffff81e1dd58 ffffffff81e1d4c0 ffffffff81cbcf5e ffffffff82bd7620
[   33.106195] Call Trace:
[   33.106196]  <IRQ>  [<ffffffff81829c6a>] dump_stack+0x4d/0x66
[   33.106200]  [<ffffffff81822ff3>] print_irq_inversion_bug.part.38+0x1ac/0x1b8
[   33.106203]  [<ffffffff810d150a>] check_usage_forwards+0x17a/0x180
[   33.106205]  [<ffffffff8102b0bb>] ? save_stack_trace+0x2b/0x50
[   33.106206]  [<ffffffff810d1390>] ? check_usage_backwards+0x180/0x180
[   33.106208]  [<ffffffff810d2e71>] mark_lock+0x1a1/0x2a0
[   33.106210]  [<ffffffff810d3c1d>] __lock_acquire+0x66d/0xb50
[   33.106212]  [<ffffffffc03edd76>] ? hiddev_send_event.isra.3+0xe6/0x100 [usbhid]
[   33.106214]  [<ffffffff810d48f9>] lock_acquire+0xa9/0x200
[   33.106216]  [<ffffffff8162f7c5>] ? input_event+0x45/0x70
[   33.106218]  [<ffffffff81833e01>] _raw_spin_lock_irqsave+0x51/0x70
[   33.106219]  [<ffffffff8162f7c5>] ? input_event+0x45/0x70
[   33.106221]  [<ffffffff8162f7c5>] input_event+0x45/0x70
[   33.106224]  [<ffffffffc03cc07f>] hidinput_report_event+0x3f/0x50 [hid]
[   33.106226]  [<ffffffffc03ca1d8>] hid_report_raw_event+0x148/0x1c0 [hid]
[   33.106228]  [<ffffffff8183372f>] ? _raw_spin_unlock_irqrestore+0x5f/0x70
[   33.106230]  [<ffffffffc03ca362>] hid_input_report+0x112/0x190 [hid]
[   33.106232]  [<ffffffffc03eac3c>] hid_irq_in+0x8c/0x210 [usbhid]
[   33.106234]  [<ffffffff815e0a73>] __usb_hcd_giveback_urb+0x83/0x130
[   33.106236]  [<ffffffff815e0c2f>] usb_hcd_giveback_urb+0x3f/0x140
[   33.106238]  [<ffffffff816207cf>] handle_tx_event+0x22f/0x12b0
[   33.106240]  [<ffffffff8162187c>] ? xhci_irq+0x2c/0xa60
[   33.106241]  [<ffffffff81621b06>] xhci_irq+0x2b6/0xa60
[   33.106243]  [<ffffffff816222c1>] xhci_msi_irq+0x11/0x20
[   33.106245]  [<ffffffff810e7e8e>] handle_irq_event_percpu+0x3e/0x340
[   33.106247]  [<ffffffff810e81cd>] handle_irq_event+0x3d/0x60
[   33.106249]  [<ffffffff810eafef>] handle_edge_irq+0x7f/0x120
[   33.106251]  [<ffffffff8101c85e>] handle_irq+0x1e/0x30
[   33.106253]  [<ffffffff8183738f>] do_IRQ+0x4f/0xf0
[   33.106254]  [<ffffffff81835072>] common_interrupt+0x72/0x72
[   33.106255]  <EOI>  [<ffffffff8167be05>] ? cpuidle_enter_state+0x75/0x300
[   33.106258]  [<ffffffff8167c147>] cpuidle_enter+0x17/0x20
[   33.106260]  [<ffffffff810c7bb1>] cpu_idle_loop+0x401/0x4e0
[   33.106261]  [<ffffffff810c7ceb>] cpu_startup_entry+0x5b/0x60
[   33.106262]  [<ffffffff81817cca>] rest_init+0x13a/0x140
[   33.106264]  [<ffffffff81817b95>] ? rest_init+0x5/0x140
[   33.106266]  [<ffffffff81f590ee>] start_kernel+0x499/0x4a4
[   33.106267]  [<ffffffff81f58a4e>] ? set_init_arg+0x53/0x53
[   33.106269]  [<ffffffff81f58120>] ? early_idt_handlers+0x120/0x120
[   33.106271]  [<ffffffff81f585ee>] x86_64_start_reservations+0x2a/0x2c
[   33.106272]  [<ffffffff81f58733>] x86_64_start_kernel+0x143/0x152


I have fixed lockdep discussed here: https://lkml.org/lkml/2014/8/25/515 but as I'm not sure if my fix was any good I also tried to revert commit causing that and still I see this.

I have not tried bisecting yet but tried to check if anything has changed around those locks recently but did not spot anything obvious yet.

-Kari
