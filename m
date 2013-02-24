Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759138Ab3BXRby (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 12:31:54 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:33412 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758730Ab3BXRbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 12:31:50 -0500
Message-ID: <512A4E83.5090901@lwfinger.net>
Date: Sun, 24 Feb 2013 11:31:47 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130105 Thunderbird/17.0.2
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        =?UTF-8?B?TWljaGE=?= =?UTF-8?B?ZWwgQsO8c2No?= <m@bues.ch>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Lockdep splat when unloading b43
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the current wireless-testing tree, unloading b43 produces the lockdep log 
splat copied below. My understanding of locking is deficient, and I would like 
to learn. Any help on understanding this problem is appreciated.

Larry


[ 3093.900871] ======================================================
[ 3093.900873] [ INFO: possible circular locking dependency detected ]
[ 3093.900876] 3.8.0-wl+ #117 Not tainted
[ 3093.900878] -------------------------------------------------------
[ 3093.900880] modprobe/5557 is trying to acquire lock:
[ 3093.900883]  ((&wl->firmware_load)){+.+.+.}, at: [<ffffffff81062160>] 
flush_work+0x0/0x2a0
[ 3093.900895]
[ 3093.900895] but task is already holding lock:
[ 3093.900897]  (rtnl_mutex){+.+.+.}, at: [<ffffffff813bd7d2>] rtnl_lock+0x12/0x20
[ 3093.900905]
[ 3093.900905] which lock already depends on the new lock.
[ 3093.900905]
[ 3093.900908]
[ 3093.900908] the existing dependency chain (in reverse order) is:
[ 3093.900911]
[ 3093.900911] -> #1 (rtnl_mutex){+.+.+.}:
[ 3093.900915]        [<ffffffff810a4bf6>] lock_acquire+0xa6/0x1e0
[ 3093.900922]        [<ffffffff81458769>] mutex_lock_nested+0x69/0x370
[ 3093.900927]        [<ffffffff813bd7d2>] rtnl_lock+0x12/0x20
[ 3093.900931]        [<ffffffffa03e613c>] wiphy_register+0x59c/0x6c0 [cfg80211]
[ 3093.900965]        [<ffffffffa050556b>] ieee80211_register_hw+0x37b/0x820 
[mac80211]
[ 3093.901000]        [<ffffffffa047a0bc>] b43_request_firmware+0x8c/0x180 [b43]
[ 3093.901014]        [<ffffffff81063d0d>] process_one_work+0x19d/0x6f0
[ 3093.901019]        [<ffffffff81064635>] worker_thread+0x155/0x400
[ 3093.901023]        [<ffffffff81069b86>] kthread+0xd6/0xe0
[ 3093.901028]        [<ffffffff8145c2fc>] ret_from_fork+0x7c/0xb0
[ 3093.901033]
[ 3093.901033] -> #0 ((&wl->firmware_load)){+.+.+.}:
[ 3093.901037]        [<ffffffff810a3d3e>] __lock_acquire+0x14ee/0x1d60
[ 3093.901041]        [<ffffffff810a4bf6>] lock_acquire+0xa6/0x1e0
[ 3093.901045]        [<ffffffff81062198>] flush_work+0x38/0x2a0
[ 3093.901049]        [<ffffffff8106337b>] __cancel_work_timer+0x7b/0xd0
[ 3093.901053]        [<ffffffff810633eb>] cancel_work_sync+0xb/0x10
[ 3093.901057]        [<ffffffffa047acd5>] b43_wireless_core_stop+0x75/0x250 [b43]
[ 3093.901065]        [<ffffffffa047aefc>] b43_op_stop+0x4c/0x90 [b43]
[ 3093.901072]        [<ffffffffa053f067>] ieee80211_stop_device+0x67/0x290 
[mac80211]
[ 3093.901095]        [<ffffffffa0521499>] ieee80211_do_stop+0x4e9/0x9e0 [mac80211]
[ 3093.901112]        [<ffffffffa05219a5>] ieee80211_stop+0x15/0x20 [mac80211]
[ 3093.901129]        [<ffffffff813aa8ad>] __dev_close_many+0x8d/0xd0
[ 3093.901134]        [<ffffffff813aa9b3>] dev_close_many+0x83/0xf0
[ 3093.901137]        [<ffffffff813aaadf>] rollback_registered_many+0xbf/0x2c0
[ 3093.901140]        [<ffffffff813aacf6>] unregister_netdevice_many+0x16/0x70
[ 3093.901144]        [<ffffffffa0523a99>] 
ieee80211_remove_interfaces+0xe9/0x1a0 [mac80211]
[ 3093.901161]        [<ffffffffa050513a>] ieee80211_unregister_hw+0x5a/0x110 
[mac80211]
[ 3093.901176]        [<ffffffffa047984a>] b43_ssb_remove+0x8a/0xd0 [b43]
[ 3093.901184]        [<ffffffffa00fb3eb>] ssb_device_remove+0x2b/0x40 [ssb]
[ 3093.901192]        [<ffffffff812d9f81>] __device_release_driver+0x61/0xd0
[ 3093.901198]        [<ffffffff812da878>] driver_detach+0xc8/0xd0
[ 3093.901202]        [<ffffffff812d9d68>] bus_remove_driver+0x88/0xe0
[ 3093.901206]        [<ffffffff812dad4a>] driver_unregister+0x5a/0x90
[ 3093.901209]        [<ffffffffa00fba0d>] ssb_driver_unregister+0xd/0x10 [ssb]
[ 3093.901215]        [<ffffffffa04a7ac4>] b43_exit+0x10/0x37 [b43]
[ 3093.901223]        [<ffffffff810b0d3a>] sys_delete_module+0x13a/0x290
[ 3093.901228]        [<ffffffff8145c3a9>] system_call_fastpath+0x16/0x1b
[ 3093.901231]
[ 3093.901231] other info that might help us debug this:
[ 3093.901231]
[ 3093.901235]  Possible unsafe locking scenario:
[ 3093.901235]
[ 3093.901238]        CPU0                    CPU1
[ 3093.901239]        ----                    ----
[ 3093.901241]   lock(rtnl_mutex);
[ 3093.901244]                                lock((&wl->firmware_load));
[ 3093.901247]                                lock(rtnl_mutex);
[ 3093.901250]   lock((&wl->firmware_load));
[ 3093.901253]
[ 3093.901253]  *** DEADLOCK ***
[ 3093.901253]
[ 3093.901257] 3 locks held by modprobe/5557:
[ 3093.901259]  #0:  (&__lockdep_no_validate__){......}, at: 
[<ffffffff812da7fc>] driver_detach+0x4c/0xd0
[ 3093.901266]  #1:  (&__lockdep_no_validate__){......}, at: 
[<ffffffff812da80a>] driver_detach+0x5a/0xd0
[ 3093.901273]  #2:  (rtnl_mutex){+.+.+.}, at: [<ffffffff813bd7d2>] 
rtnl_lock+0x12/0x20
[ 3093.901279]
[ 3093.901279] stack backtrace:
[ 3093.901283] Pid: 5557, comm: modprobe Not tainted 3.8.0-wl+ #117
[ 3093.901286] Call Trace:
[ 3093.901291]  [<ffffffff81453b1a>] print_circular_bug+0x28e/0x29f
[ 3093.901295]  [<ffffffff810a3d3e>] __lock_acquire+0x14ee/0x1d60
[ 3093.901302]  [<ffffffff81011dba>] ? save_stack_trace+0x2a/0x50
[ 3093.901306]  [<ffffffff810a4bf6>] lock_acquire+0xa6/0x1e0
[ 3093.901311]  [<ffffffff81062160>] ? work_cpu+0x20/0x20
[ 3093.901315]  [<ffffffff81062198>] flush_work+0x38/0x2a0
[ 3093.901319]  [<ffffffff81062160>] ? work_cpu+0x20/0x20
[ 3093.901323]  [<ffffffff810a557c>] ? mark_held_locks+0x8c/0x110
[ 3093.901329]  [<ffffffff81052d27>] ? del_timer+0x57/0x70
[ 3093.901334]  [<ffffffff81063368>] ? __cancel_work_timer+0x68/0xd0
[ 3093.901338]  [<ffffffff810a5705>] ? trace_hardirqs_on_caller+0x105/0x190
[ 3093.901343]  [<ffffffff8106337b>] __cancel_work_timer+0x7b/0xd0
[ 3093.901347]  [<ffffffff810633eb>] cancel_work_sync+0xb/0x10
[ 3093.901355]  [<ffffffffa047acd5>] b43_wireless_core_stop+0x75/0x250 [b43]
[ 3093.901364]  [<ffffffffa047aefc>] b43_op_stop+0x4c/0x90 [b43]
[ 3093.901384]  [<ffffffffa053f067>] ieee80211_stop_device+0x67/0x290 [mac80211]
[ 3093.901402]  [<ffffffffa0521499>] ieee80211_do_stop+0x4e9/0x9e0 [mac80211]
[ 3093.901407]  [<ffffffff813cb0b1>] ? dev_deactivate_many+0x231/0x2f0
[ 3093.901425]  [<ffffffffa05219a5>] ieee80211_stop+0x15/0x20 [mac80211]
[ 3093.901429]  [<ffffffff813aa8ad>] __dev_close_many+0x8d/0xd0
[ 3093.901433]  [<ffffffff813aa9b3>] dev_close_many+0x83/0xf0
[ 3093.901437]  [<ffffffff813aaadf>] rollback_registered_many+0xbf/0x2c0
[ 3093.901441]  [<ffffffff813aacf6>] unregister_netdevice_many+0x16/0x70
[ 3093.901459]  [<ffffffffa0523a99>] ieee80211_remove_interfaces+0xe9/0x1a0 
[mac80211]
[ 3093.901475]  [<ffffffffa050513a>] ieee80211_unregister_hw+0x5a/0x110 [mac80211]
[ 3093.901484]  [<ffffffffa047984a>] b43_ssb_remove+0x8a/0xd0 [b43]
[ 3093.901490]  [<ffffffffa00fb3eb>] ssb_device_remove+0x2b/0x40 [ssb]
[ 3093.901495]  [<ffffffff812d9f81>] __device_release_driver+0x61/0xd0
[ 3093.901499]  [<ffffffff812da878>] driver_detach+0xc8/0xd0
[ 3093.901504]  [<ffffffff812d9d68>] bus_remove_driver+0x88/0xe0
[ 3093.901508]  [<ffffffff812dad4a>] driver_unregister+0x5a/0x90
[ 3093.901515]  [<ffffffffa00fba0d>] ssb_driver_unregister+0xd/0x10 [ssb]
[ 3093.901524]  [<ffffffffa04a7ac4>] b43_exit+0x10/0x37 [b43]
[ 3093.901528]  [<ffffffff810b0d3a>] sys_delete_module+0x13a/0x290
[ 3093.901532]  [<ffffffff810a5705>] ? trace_hardirqs_on_caller+0x105/0x190
[ 3093.901538]  [<ffffffff8121affe>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 3093.901542]  [<ffffffff8145c3a9>] system_call_fastpath+0x16/0x1b
[ 3093.901685] b43-phy1 debug: Wireless interface stopped
