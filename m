Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab3AOMGl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:06:41 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:44128 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab3AOMGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:06:39 -0500
Message-ID: <50F5464A.7070704@gmail.com>
Date: Tue, 15 Jan 2013 13:06:34 +0100
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Shawn Guo <shawn.guo@linaro.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
References: <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com> <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com> <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com> <20121227045301.GB17472@x1.alien8.de> <20121228115022.GA28009@S2101-09.ap.freescale.net> <20121228124026.GB12918@x1.alien8.de> <alpine.LRH.2.00.1301071037010.5443@twin.jikos.cz> <20130112183619.GC10630@liondog.tnic> <CA+55aFw163CwK_MmUKY7zGFeck+Rxk_xs=BDrCAFpg-xac3vmQ@mail.gmail.com> <20130112131323.31d2a585.akpm@linux-foundation.org> <20130113000242.GD10630@liondog.tnic>
In-Reply-To: <20130113000242.GD10630@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 13-01-13 01:02, Borislav Petkov schreef:
> On Sat, Jan 12, 2013 at 01:13:23PM -0800, Andrew Morton wrote:
>> Florian has been taking a month or two's downtime (now expired, I
>> think) so I've been waiting for him to reappear to process this one for
>> 3.8.
>>
>> Meanwhile, I guess we could put it into mainline ;) It has been in
>> -next for a month.
>>
>> From: Alan Cox <alan@linux.intel.com>
>> Subject: fb: rework locking to fix lock ordering on takeover
>>
>> Adjust the console layer to allow a take over call where the caller
>> already holds the locks.  Make the fb layer lock in order.
>>
>> This is partly a band aid, the fb layer is terminally confused about the
>> locking rules it uses for its notifiers it seems.
>>
>> [akpm@linux-foundation.org: remove stray non-ascii char, tidy comment]
>> [akpm@linux-foundation.org: export do_take_over_console()]
>> Signed-off-by: Alan Cox <alan@linux.intel.com>
>> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
>> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Yes, that's the one, modulo Andrew's fixes, which I've been running.
> Irregardless, I'll run this one tomorrow just in case, because it
> triggers here so easily.
>
Just tested this patch on a macbook pro with i915 and radeon. First I get a nasty lockdep splat, then it locks up completely:

[   13.507373] fb: conflicting fb hw usage radeondrmfb vs EFI VGA - removing generic driver
[   13.507412] 
[   13.507413] ======================================================
[   13.507413] [ INFO: possible circular locking dependency detected ]
[   13.507414] 3.8.0-rc3-patser+ #910 Not tainted
[   13.507415] -------------------------------------------------------
[   13.507415] modprobe/554 is trying to acquire lock:
[   13.507421]  (console_lock){+.+.+.}, at: [<ffffffff813f6ca7>] unbind_con_driver+0x37/0x210
[   13.507422] 
[   13.507422] but task is already holding lock:
[   13.507425]  ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff8106d96d>] __blocking_notifier_call_chain+0x3d/0x80
[   13.507426] 
[   13.507426] which lock already depends on the new lock.
[   13.507426] 
[   13.507426] 
[   13.507426] the existing dependency chain (in reverse order) is:
[   13.507428] 
[   13.507428] -> #1 ((fb_notifier_list).rwsem){.+.+.+}:
[   13.507431]        [<ffffffff8109e946>] lock_acquire+0x96/0xc0
[   13.507434]        [<ffffffff816f8442>] down_read+0x42/0x57
[   13.507435]        [<ffffffff8106d96d>] __blocking_notifier_call_chain+0x3d/0x80
[   13.507437]        [<ffffffff8106d9c1>] blocking_notifier_call_chain+0x11/0x20
[   13.507439]        [<ffffffff8138e816>] fb_notifier_call_chain+0x16/0x20
[   13.507441]        [<ffffffff8138fd23>] register_framebuffer+0x1c3/0x2e0
[   13.507444]        [<ffffffff81cdfabf>] efifb_probe+0x402/0x489
[   13.507446]        [<ffffffff81412e0e>] platform_drv_probe+0x3e/0x70
[   13.507448]        [<ffffffff81410e96>] driver_probe_device+0x76/0x240
[   13.507450]        [<ffffffff81411103>] __driver_attach+0xa3/0xb0
[   13.507451]        [<ffffffff8140f2f6>] bus_for_each_dev+0x56/0x90
[   13.507452]        [<ffffffff814109f9>] driver_attach+0x19/0x20
[   13.507454]        [<ffffffff81410598>] bus_add_driver+0x188/0x270
[   13.507455]        [<ffffffff81411635>] driver_register+0x75/0x150
[   13.507457]        [<ffffffff814126a1>] platform_driver_register+0x41/0x50
[   13.507458]        [<ffffffff814126c6>] platform_driver_probe+0x16/0xa0
[   13.507460]        [<ffffffff81cdfdbd>] efifb_init+0x277/0x292
[   13.507462]        [<ffffffff810001fa>] do_one_initcall+0x3a/0x170
[   13.507464]        [<ffffffff816df85d>] kernel_init+0x11d/0x290
[   13.507466]        [<ffffffff817008ac>] ret_from_fork+0x7c/0xb0
[   13.507467] 
[   13.507467] -> #0 (console_lock){+.+.+.}:
[   13.507469]        [<ffffffff8109dccf>] __lock_acquire+0x168f/0x1d90
[   13.507471]        [<ffffffff8109e946>] lock_acquire+0x96/0xc0
[   13.507474]        [<ffffffff81048dff>] console_lock+0x6f/0x80
[   13.507475]        [<ffffffff813f6ca7>] unbind_con_driver+0x37/0x210
[   13.507477]        [<ffffffff8139dbe7>] fbcon_event_notify+0x477/0x920
[   13.507478]        [<ffffffff816fe318>] notifier_call_chain+0x58/0xb0
[   13.507479]        [<ffffffff8106d983>] __blocking_notifier_call_chain+0x53/0x80
[   13.507481]        [<ffffffff8106d9c1>] blocking_notifier_call_chain+0x11/0x20
[   13.507482]        [<ffffffff8138e816>] fb_notifier_call_chain+0x16/0x20
[   13.507484]        [<ffffffff8138f902>] do_unregister_framebuffer+0x62/0x100
[   13.507485]        [<ffffffff8138fb34>] do_remove_conflicting_framebuffers+0x154/0x180
[   13.507487]        [<ffffffff8138fe7a>] remove_conflicting_framebuffers+0x3a/0x60
[   13.507501]        [<ffffffffa02111a4>] radeon_pci_probe+0x84/0xc0 [radeon]
[   13.507503]        [<ffffffff813745c6>] local_pci_probe+0x46/0x80
[   13.507505]        [<ffffffff81375e19>] pci_device_probe+0xf9/0x120
[   13.507506]        [<ffffffff81410e96>] driver_probe_device+0x76/0x240
[   13.507507]        [<ffffffff81411103>] __driver_attach+0xa3/0xb0
[   13.507508]        [<ffffffff8140f2f6>] bus_for_each_dev+0x56/0x90
[   13.507510]        [<ffffffff814109f9>] driver_attach+0x19/0x20
[   13.507511]        [<ffffffff81410598>] bus_add_driver+0x188/0x270
[   13.507512]        [<ffffffff81411635>] driver_register+0x75/0x150
[   13.507514]        [<ffffffff81374e2f>] __pci_register_driver+0x5f/0x70
[   13.507520]        [<ffffffffa009773a>] drm_pci_init+0x11a/0x130 [drm]
[   13.507528]        [<ffffffffa02f30ec>] radeon_init+0xec/0x1000 [radeon]
[   13.507530]        [<ffffffff810001fa>] do_one_initcall+0x3a/0x170
[   13.507532]        [<ffffffff810a9fd2>] load_module+0x1a52/0x2020
[   13.507533]        [<ffffffff810aa671>] sys_init_module+0xd1/0x100
[   13.507535]        [<ffffffff81700952>] system_call_fastpath+0x16/0x1b
[   13.507535] 
[   13.507535] other info that might help us debug this:
[   13.507535] 
[   13.507535]  Possible unsafe locking scenario:
[   13.507535] 
[   13.507536]        CPU0                    CPU1
[   13.507536]        ----                    ----
[   13.507537]   lock((fb_notifier_list).rwsem);
[   13.507538]                                lock(console_lock);
[   13.507538]                                lock((fb_notifier_list).rwsem);
[   13.507539]   lock(console_lock);
[   13.507539] 
[   13.507539]  *** DEADLOCK ***
[   13.507539] 
[   13.507540] 5 locks held by modprobe/554:
[   13.507543]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff814110b3>] __driver_attach+0x53/0xb0
[   13.507545]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff814110c1>] __driver_attach+0x61/0xb0
[   13.507547]  #2:  (registration_lock){+.+.+.}, at: [<ffffffff8138fe6b>] remove_conflicting_framebuffers+0x2b/0x60
[   13.507550]  #3:  (&fb_info->lock){+.+.+.}, at: [<ffffffff8138ecd1>] lock_fb_info+0x21/0x60
[   13.507552]  #4:  ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff8106d96d>] __blocking_notifier_call_chain+0x3d/0x80
[   13.507552] 
[   13.507552] stack backtrace:
[   13.507554] Pid: 554, comm: modprobe Not tainted 3.8.0-rc3-patser+ #910
[   13.507554] Call Trace:
[   13.507557]  [<ffffffff816efd4e>] print_circular_bug+0x1fb/0x20c
[   13.507559]  [<ffffffff8109dccf>] __lock_acquire+0x168f/0x1d90
[   13.507561]  [<ffffffff8109b532>] ? mark_held_locks+0x82/0x130
[   13.507563]  [<ffffffff8109e946>] lock_acquire+0x96/0xc0
[   13.507565]  [<ffffffff813f6ca7>] ? unbind_con_driver+0x37/0x210
[   13.507566]  [<ffffffff8109b7cd>] ? trace_hardirqs_on+0xd/0x10
[   13.507568]  [<ffffffff81048dff>] console_lock+0x6f/0x80
[   13.507570]  [<ffffffff813f6ca7>] ? unbind_con_driver+0x37/0x210
[   13.507571]  [<ffffffff813f6ca7>] unbind_con_driver+0x37/0x210
[   13.507573]  [<ffffffff8109e953>] ? lock_acquire+0xa3/0xc0
[   13.507574]  [<ffffffff8139dbe7>] fbcon_event_notify+0x477/0x920
[   13.507576]  [<ffffffff816fe318>] notifier_call_chain+0x58/0xb0
[   13.507577]  [<ffffffff8106d983>] __blocking_notifier_call_chain+0x53/0x80
[   13.507579]  [<ffffffff8106d9c1>] blocking_notifier_call_chain+0x11/0x20
[   13.507580]  [<ffffffff8138e816>] fb_notifier_call_chain+0x16/0x20
[   13.507582]  [<ffffffff8138f902>] do_unregister_framebuffer+0x62/0x100
[   13.507584]  [<ffffffff8138fb34>] do_remove_conflicting_framebuffers+0x154/0x180
[   13.507586]  [<ffffffff8138fe7a>] remove_conflicting_framebuffers+0x3a/0x60
[   13.507597]  [<ffffffffa02111a4>] radeon_pci_probe+0x84/0xc0 [radeon]
[   13.507598]  [<ffffffff813745c6>] local_pci_probe+0x46/0x80
[   13.507600]  [<ffffffff81375e19>] pci_device_probe+0xf9/0x120
[   13.507601]  [<ffffffff81410e96>] driver_probe_device+0x76/0x240
[   13.507603]  [<ffffffff81411103>] __driver_attach+0xa3/0xb0
[   13.507604]  [<ffffffff81411060>] ? driver_probe_device+0x240/0x240
[   13.507606]  [<ffffffff8140f2f6>] bus_for_each_dev+0x56/0x90
[   13.507607]  [<ffffffff814109f9>] driver_attach+0x19/0x20
[   13.507608]  [<ffffffff81410598>] bus_add_driver+0x188/0x270
[   13.507610]  [<ffffffff81411635>] driver_register+0x75/0x150
[   13.507612]  [<ffffffff81374e2f>] __pci_register_driver+0x5f/0x70
[   13.507617]  [<ffffffffa009773a>] drm_pci_init+0x11a/0x130 [drm]
[   13.507619]  [<ffffffffa02f3000>] ? 0xffffffffa02f2fff
[   13.507620]  [<ffffffffa02f3000>] ? 0xffffffffa02f2fff
[   13.507628]  [<ffffffffa02f30ec>] radeon_init+0xec/0x1000 [radeon]
[   13.507630]  [<ffffffff810001fa>] do_one_initcall+0x3a/0x170
[   13.507632]  [<ffffffff810a9fd2>] load_module+0x1a52/0x2020
[   13.507633]  [<ffffffff810a71b0>] ? get_modinfo.isra.30+0xc0/0xc0
[   13.507635]  [<ffffffff8135166e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   13.507637]  [<ffffffff810aa671>] sys_init_module+0xd1/0x100
[   13.507639]  [<ffffffff81700952>] system_call_fastpath+0x16/0x1b

<...>

[   62.505111] INFO: task plymouthd:293 blocked for more than 30 seconds.
[   62.505113] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   62.505122] plymouthd       D 0000000000000246     0   293      1 0x00000000
[   62.505130]  ffff88016a293b18 0000000000000046 0000000000000000 0000000000000000
[   62.505135]  ffff88015ce12040 ffff88016a293fd8 ffff88016a293fd8 ffff88016a293fd8
[   62.505141]  ffff880153c66040 ffff88015ce12040 ffffffff81c30360 ffffffffa00bb1e0
[   62.505142] Call Trace:
[   62.505162]  [<ffffffff816f9224>] schedule+0x24/0x70
[   62.505178]  [<ffffffff816f9543>] schedule_preempt_disabled+0x13/0x20
[   62.505180]  [<ffffffff816f5de9>] mutex_lock_nested+0x179/0x390
[   62.505187]  [<ffffffffa00907f4>] ? drm_stub_open+0x54/0x170 [drm]
[   62.505193]  [<ffffffffa00907f4>] drm_stub_open+0x54/0x170 [drm]
[   62.505195]  [<ffffffff8113739c>] chrdev_open+0x9c/0x1a0
[   62.505197]  [<ffffffff81137300>] ? cdev_put+0x30/0x30
[   62.505200]  [<ffffffff81130cae>] do_dentry_open+0x26e/0x310
[   62.505201]  [<ffffffff81130eb0>] finish_open+0x30/0x40
[   62.505204]  [<ffffffff81140fee>] do_last+0x74e/0xea0
[   62.505206]  [<ffffffff8113e00d>] ? link_path_walk+0x23d/0x920
[   62.505208]  [<ffffffff811417ee>] path_openat+0xae/0x4c0
[   62.505210]  [<ffffffff8114237d>] do_filp_open+0x3d/0xa0
[   62.505213]  [<ffffffff8114fd0f>] ? __alloc_fd+0xcf/0x120
[   62.505215]  [<ffffffff811321f9>] do_sys_open+0xf9/0x1e0
[   62.505216]  [<ffffffff811322fc>] sys_open+0x1c/0x20
[   62.505218]  [<ffffffff81700952>] system_call_fastpath+0x16/0x1b
[   62.505219] INFO: lockdep is turned off.
[   62.505221] INFO: task modprobe:554 blocked for more than 30 seconds.
[   62.505221] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[   62.505223] modprobe        D 0000000000000000     0   554    539 0x00000002
[   62.505225]  ffff88015cf155a8 0000000000000046 0000000000000000 ffffffff81070dad
[   62.505227]  ffff88016a284040 ffff88015cf15fd8 ffff88015cf15fd8 ffff88015cf15fd8
[   62.505228]  ffffffff81c13440 ffff88016a284040 ffff88016fdfdf48 ffffffff81c220e0
[   62.505228] Call Trace:
[   62.505231]  [<ffffffff81070dad>] ? __wake_up+0x2d/0x70
[   62.505233]  [<ffffffff816f9224>] schedule+0x24/0x70
[   62.505234]  [<ffffffff816f57e5>] schedule_timeout+0x175/0x1b0
[   62.505237]  [<ffffffff81009996>] ? native_sched_clock+0x26/0x90
[   62.505239]  [<ffffffff816f84ee>] __down_common+0x97/0xe8
[   62.505241]  [<ffffffff816f859e>] __down+0x18/0x1a
[   62.505242]  [<ffffffff8106d81c>] down+0x3c/0x50
[   62.505246]  [<ffffffff81048db7>] console_lock+0x27/0x80
[   62.505248]  [<ffffffff8139b196>] set_con2fb_map+0x116/0x4c0
[   62.505250]  [<ffffffff8139d9bb>] fbcon_event_notify+0x24b/0x920
[   62.505252]  [<ffffffff816fe318>] notifier_call_chain+0x58/0xb0
[   62.505254]  [<ffffffff8106d983>] __blocking_notifier_call_chain+0x53/0x80
[   62.505255]  [<ffffffff8106d9c1>] blocking_notifier_call_chain+0x11/0x20
[   62.505257]  [<ffffffff8138e816>] fb_notifier_call_chain+0x16/0x20
[   62.505259]  [<ffffffff8138fd23>] register_framebuffer+0x1c3/0x2e0
[   62.505262]  [<ffffffffa0115e7b>] drm_fb_helper_single_fb_probe+0x1eb/0x320 [drm_kms_helper]
[   62.505265]  [<ffffffffa0116183>] drm_fb_helper_initial_config+0x1d3/0x260 [drm_kms_helper]
[   62.505268]  [<ffffffff8109b7cd>] ? trace_hardirqs_on+0xd/0x10
[   62.505288]  [<ffffffffa0253e1a>] radeon_fbdev_init+0xaa/0xf0 [radeon]
[   62.505301]  [<ffffffffa024e95b>] radeon_modeset_init+0x37b/0xa50 [radeon]
[   62.505313]  [<ffffffffa022b5c8>] radeon_driver_load_kms+0xe8/0x150 [radeon]
[   62.505319]  [<ffffffffa00974f9>] drm_get_pci_dev+0x179/0x2a0 [drm]
[   62.505331]  [<ffffffffa02111be>] radeon_pci_probe+0x9e/0xc0 [radeon]
[   62.505333]  [<ffffffff813745c6>] local_pci_probe+0x46/0x80
[   62.505335]  [<ffffffff81375e19>] pci_device_probe+0xf9/0x120
[   62.505337]  [<ffffffff81410e96>] driver_probe_device+0x76/0x240
[   62.505339]  [<ffffffff81411103>] __driver_attach+0xa3/0xb0
[   62.505341]  [<ffffffff81411060>] ? driver_probe_device+0x240/0x240
[   62.505342]  [<ffffffff8140f2f6>] bus_for_each_dev+0x56/0x90
[   62.505344]  [<ffffffff814109f9>] driver_attach+0x19/0x20
[   62.505345]  [<ffffffff81410598>] bus_add_driver+0x188/0x270
[   62.505347]  [<ffffffff81411635>] driver_register+0x75/0x150
[   62.505349]  [<ffffffff81374e2f>] __pci_register_driver+0x5f/0x70
[   62.505354]  [<ffffffffa009773a>] drm_pci_init+0x11a/0x130 [drm]
[   62.505356]  [<ffffffffa02f3000>] ? 0xffffffffa02f2fff
[   62.505358]  [<ffffffffa02f3000>] ? 0xffffffffa02f2fff
[   62.505367]  [<ffffffffa02f30ec>] radeon_init+0xec/0x1000 [radeon]
[   62.505369]  [<ffffffff810001fa>] do_one_initcall+0x3a/0x170
[   62.505372]  [<ffffffff810a9fd2>] load_module+0x1a52/0x2020
[   62.505373]  [<ffffffff810a71b0>] ? get_modinfo.isra.30+0xc0/0xc0
[   62.505375]  [<ffffffff8135166e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[   62.505377]  [<ffffffff810aa671>] sys_init_module+0xd1/0x100
[   62.505379]  [<ffffffff81700952>] system_call_fastpath+0x16/0x1b


