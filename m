Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753379Ab3DKFrt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 01:47:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38530 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab3DKFrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 01:47:47 -0400
Date: Thu, 11 Apr 2013 13:47:40 +0800
From: dyoung@redhat.com
To: linux-kernel@vger.kernel.org
Subject: cirrusfb: possible circular locking dependency
Message-ID: <51664e7c.4GhG4Hz0IvwaH1lm%dyoung@redhat.com>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lockdep is complaining about below, I see it often in kvm guests,
False postive?

[  600.383445] ======================================================
[  600.383447] [ INFO: possible circular locking dependency detected ]
[  600.383452] 3.9.0-rc5+ #71 Not tainted
[  600.383454] -------------------------------------------------------
[  600.383458] kworker/0:2/1254 is trying to acquire lock:
[  600.383475]  (&fb_info->lock){+.+.+.}, at: [<ffffffff812e5c92>] lock_fb_info+0x18/0x37
[  600.383477] 
[  600.383477] but task is already holding lock:
[  600.383490]  (console_lock){+.+.+.}, at: [<ffffffff8135410f>] console_callback+0xb/0xf5
[  600.383491] 
[  600.383491] which lock already depends on the new lock.
[  600.383491] 
[  600.383493] 
[  600.383493] the existing dependency chain (in reverse order) is:
[  600.383499] 
[  600.383499] -> #1 (console_lock){+.+.+.}:
[  600.383509]        [<ffffffff8107e52b>] lock_acquire+0xa3/0x115
[  600.383516]        [<ffffffff8103596a>] console_lock+0x59/0x5b
[  600.383522]        [<ffffffff812e7598>] register_framebuffer+0x20d/0x284
[  600.383530]        [<ffffffff812f69dd>] cirrusfb_pci_register+0x57a/0x617
[  600.383537]        [<ffffffff812d7f2e>] pci_device_probe+0x6b/0xb1
[  600.383544]        [<ffffffff813749d2>] driver_probe_device+0x117/0x2ef
[  600.383549]        [<ffffffff81374bf8>] __driver_attach+0x4e/0x6f
[  600.383554]        [<ffffffff81372e2b>] bus_for_each_dev+0x57/0x89
[  600.383559]        [<ffffffff8137438e>] driver_attach+0x19/0x1b
[  600.383564]        [<ffffffff81374004>] bus_add_driver+0x11d/0x242
[  600.383569]        [<ffffffff813751b7>] driver_register+0x8e/0x114
[  600.383575]        [<ffffffff812d73be>] __pci_register_driver+0x5d/0x62
[  600.383584]        [<ffffffff81a32f0c>] cirrusfb_init+0x52/0xc0
[  600.383594]        [<ffffffff8100026c>] do_one_initcall+0x7a/0x136
[  600.383600]        [<ffffffff81a0ae9b>] kernel_init_freeable+0x141/0x1d0
[  600.383609]        [<ffffffff815aa359>] kernel_init+0x9/0xcc
[  600.383615]        [<ffffffff815cd57c>] ret_from_fork+0x7c/0xb0
[  600.383621] 
[  600.383621] -> #0 (&fb_info->lock){+.+.+.}:
[  600.383627]        [<ffffffff8107dd25>] __lock_acquire+0xae5/0xe78
[  600.383632]        [<ffffffff8107e52b>] lock_acquire+0xa3/0x115
[  600.383642]        [<ffffffff815c494a>] __mutex_lock_common+0x44/0x32e
[  600.383648]        [<ffffffff815c4cf3>] mutex_lock_nested+0x2a/0x31
[  600.383653]        [<ffffffff812e5c92>] lock_fb_info+0x18/0x37
[  600.383661]        [<ffffffff812ef905>] fbcon_blank+0x168/0x1ee
[  600.383668]        [<ffffffff81351a6d>] do_blank_screen+0x13e/0x1d8
[  600.383675]        [<ffffffff813541cf>] console_callback+0xcb/0xf5
[  600.383684]        [<ffffffff8104cf89>] process_one_work+0x1e8/0x38c
[  600.383691]        [<ffffffff8104d922>] worker_thread+0x130/0x1df
[  600.383699]        [<ffffffff81055144>] kthread+0xac/0xb4
[  600.383703]        [<ffffffff815cd57c>] ret_from_fork+0x7c/0xb0
[  600.383705] 
[  600.383705] other info that might help us debug this:
[  600.383705] 
[  600.383707]  Possible unsafe locking scenario:
[  600.383707] 
[  600.383708]        CPU0                    CPU1
[  600.383710]        ----                    ----
[  600.383713]   lock(console_lock);
[  600.383717]                                lock(&fb_info->lock);
[  600.383720]                                lock(console_lock);
[  600.383724]   lock(&fb_info->lock);
[  600.383725] 
[  600.383725]  *** DEADLOCK ***
[  600.383725] 
[  600.383728] 3 locks held by kworker/0:2/1254:
[  600.383739]  #0:  (events){.+.+.+}, at: [<ffffffff8104cf11>] process_one_work+0x170/0x38c
[  600.383749]  #1:  (console_work){+.+...}, at: [<ffffffff8104cf11>] process_one_work+0x170/0x38c
[  600.383759]  #2:  (console_lock){+.+.+.}, at: [<ffffffff8135410f>] console_callback+0xb/0xf5
[  600.383761] 
[  600.383761] stack backtrace:
[  600.383765] Pid: 1254, comm: kworker/0:2 Not tainted 3.9.0-rc5+ #71
[  600.383767] Call Trace:
[  600.383775]  [<ffffffff815bddc8>] print_circular_bug+0x1f8/0x209
[  600.383782]  [<ffffffff8107dd25>] __lock_acquire+0xae5/0xe78
[  600.383788]  [<ffffffff812f5e48>] ? cirrusfb_set_blitter+0x169/0x178
[  600.383794]  [<ffffffff8107e52b>] lock_acquire+0xa3/0x115
[  600.383799]  [<ffffffff812e5c92>] ? lock_fb_info+0x18/0x37
[  600.383807]  [<ffffffff815c494a>] __mutex_lock_common+0x44/0x32e
[  600.383811]  [<ffffffff812e5c92>] ? lock_fb_info+0x18/0x37
[  600.383816]  [<ffffffff812e5c92>] ? lock_fb_info+0x18/0x37
[  600.383823]  [<ffffffff812f27d2>] ? bit_clear+0xa7/0xb4
[  600.383831]  [<ffffffff815c4cf3>] mutex_lock_nested+0x2a/0x31
[  600.383836]  [<ffffffff812e5c92>] lock_fb_info+0x18/0x37
[  600.383842]  [<ffffffff812ef905>] fbcon_blank+0x168/0x1ee
[  600.383848]  [<ffffffff815c6ad3>] ? _raw_spin_unlock_irqrestore+0x40/0x4d
[  600.383855]  [<ffffffff8107c3ef>] ? trace_hardirqs_on_caller+0x112/0x1ad
[  600.383860]  [<ffffffff815c6adb>] ? _raw_spin_unlock_irqrestore+0x48/0x4d
[  600.383868]  [<ffffffff810424f5>] ? try_to_del_timer_sync+0x50/0x5c
[  600.383875]  [<ffffffff810425a4>] ? del_timer_sync+0xa3/0xc9
[  600.383881]  [<ffffffff81042501>] ? try_to_del_timer_sync+0x5c/0x5c
[  600.383887]  [<ffffffff81351a6d>] do_blank_screen+0x13e/0x1d8
[  600.383894]  [<ffffffff813541cf>] console_callback+0xcb/0xf5
[  600.383901]  [<ffffffff8104cf89>] process_one_work+0x1e8/0x38c
[  600.383908]  [<ffffffff8104cf11>] ? process_one_work+0x170/0x38c
[  600.383915]  [<ffffffff8104d922>] worker_thread+0x130/0x1df
[  600.383922]  [<ffffffff8104d7f2>] ? manage_workers+0x245/0x245
[  600.383928]  [<ffffffff81055144>] kthread+0xac/0xb4
[  600.383936]  [<ffffffff81055098>] ? __kthread_parkme+0x60/0x60
[  600.383941]  [<ffffffff815cd57c>] ret_from_fork+0x7c/0xb0
[  600.383948]  [<ffffffff81055098>] ? __kthread_parkme+0x60/0x60
