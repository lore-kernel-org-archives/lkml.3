Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757151Ab3CEQkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 11:40:15 -0500
Received: from ns.km20343-01.keymachine.de ([84.19.182.79]:53164 "EHLO
	km20343-01.keymachine.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753855Ab3CEQkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 11:40:13 -0500
X-Greylist: delayed 559 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Mar 2013 11:40:13 EST
Message-ID: <1362501052.1933.2.camel@antimon>
Subject: Re: nouveau lockdep splat
From: Lucas Stach <dev@lynxeye.de>
To: Borislav Petkov <bp@alien8.de>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
Date: Tue, 05 Mar 2013 17:30:52 +0100
In-Reply-To: <20130304211608.GD22274@pd.tnic>
References: <20130304211608.GD22274@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3 (3.6.3-2.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dropping Tegra ML, it's not the place where Nouveau mails should go.
Adding Nouveau ML and Maarten, who probably knows Lockdep+Nouveau best.

Am Montag, den 04.03.2013, 22:16 +0100 schrieb Borislav Petkov:
> New -rc1, so let the stabilization games begin.
> 
> I see the following on rc1, let me know if you need more info.
> 
> 
> [    0.633617] =============================================
> [    0.633618] [ INFO: possible recursive locking detected ]
> [    0.633618] 3.9.0-rc1 #2 Not tainted
> [    0.633619] ---------------------------------------------
> [    0.633619] swapper/0/1 is trying to acquire lock:
> [    0.633623]  (&dmac->lock){+.+...}, at: [<ffffffff8141bb53>] evo_wait+0x43/0xf0
> [    0.633624] 
> [    0.633624] but task is already holding lock:
> [    0.633626]  (&dmac->lock){+.+...}, at: [<ffffffff8141bb53>] evo_wait+0x43/0xf0
> [    0.633626] 
> [    0.633626] other info that might help us debug this:
> [    0.633626]  Possible unsafe locking scenario:
> [    0.633626] 
> [    0.633626]        CPU0
> [    0.633627]        ----
> [    0.633627]   lock(&dmac->lock);
> [    0.633628]   lock(&dmac->lock);
> [    0.633628] 
> [    0.633628]  *** DEADLOCK ***
> [    0.633628] 
> [    0.633628]  May be due to missing lock nesting notation
> [    0.633628] 
> [    0.633629] 10 locks held by swapper/0/1:
> [    0.633632]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff8143375b>] __driver_attach+0x5b/0xb0
> [    0.633633]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff81433769>] __driver_attach+0x69/0xb0
> [    0.633636]  #2:  (drm_global_mutex){+.+.+.}, at: [<ffffffff8135a8f6>] drm_get_pci_dev+0xc6/0x2d0
> [    0.633640]  #3:  (registration_lock){+.+.+.}, at: [<ffffffff812c8e75>] register_framebuffer+0x25/0x310
> [    0.633642]  #4:  (&fb_info->lock){+.+.+.}, at: [<ffffffff812c7d86>] lock_fb_info+0x26/0x60
> [    0.633644]  #5:  (console_lock){+.+.+.}, at: [<ffffffff812c900a>] register_framebuffer+0x1ba/0x310
> [    0.633646]  #6:  ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff810694d2>] __blocking_notifier_call_chain+0x42/0x80
> [    0.633648]  #7:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff8135e63a>] drm_modeset_lock_all+0x2a/0x70
> [    0.633650]  #8:  (&crtc->mutex){+.+.+.}, at: [<ffffffff8135e664>] drm_modeset_lock_all+0x54/0x70
> [    0.633652]  #9:  (&dmac->lock){+.+...}, at: [<ffffffff8141bb53>] evo_wait+0x43/0xf0
> [    0.633652] 
> [    0.633652] stack backtrace:
> [    0.633653] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc1 #2
> [    0.633654] Call Trace:
> [    0.633656]  [<ffffffff8109524b>] __lock_acquire+0x76b/0x1c20
> [    0.633658]  [<ffffffff8137f50c>] ? dcb_table+0x1ac/0x2a0
> [    0.633659]  [<ffffffff8141bb53>] ? evo_wait+0x43/0xf0
> [    0.633660]  [<ffffffff81096c6a>] lock_acquire+0x8a/0x120
> [    0.633662]  [<ffffffff8141bb53>] ? evo_wait+0x43/0xf0
> [    0.633664]  [<ffffffff815eaf52>] ? mutex_lock_nested+0x292/0x330
> [    0.633665]  [<ffffffff815ead2e>] mutex_lock_nested+0x6e/0x330
> [    0.633667]  [<ffffffff8141bb53>] ? evo_wait+0x43/0xf0
> [    0.633668]  [<ffffffff815eb0b7>] ? __mutex_unlock_slowpath+0xc7/0x150
> [    0.633669]  [<ffffffff8141bb53>] evo_wait+0x43/0xf0
> [    0.633671]  [<ffffffff8141e569>] nv50_display_flip_next+0x749/0x7d0
> [    0.633672]  [<ffffffff8141bc37>] ? evo_kick+0x37/0x40
> [    0.633674]  [<ffffffff8141e7ee>] nv50_crtc_commit+0x10e/0x230
> [    0.633676]  [<ffffffff8134c2a5>] drm_crtc_helper_set_mode+0x365/0x510
> [    0.633677]  [<ffffffff8134d69e>] drm_crtc_helper_set_config+0xa4e/0xb70
> [    0.633679]  [<ffffffff8135f751>] drm_mode_set_config_internal+0x31/0x70
> [    0.633680]  [<ffffffff8134b7a1>] drm_fb_helper_set_par+0x71/0xf0
> [    0.633682]  [<ffffffff812d40e4>] fbcon_init+0x514/0x5a0
> [    0.633683]  [<ffffffff8132cbdc>] visual_init+0xbc/0x120
> [    0.633685]  [<ffffffff8132f293>] do_bind_con_driver+0x163/0x320
> [    0.633686]  [<ffffffff8132f521>] do_take_over_console+0x61/0x70
> [    0.633687]  [<ffffffff812d2703>] do_fbcon_takeover+0x63/0xc0
> [    0.633689]  [<ffffffff812d63dd>] fbcon_event_notify+0x5fd/0x700
> [    0.633690]  [<ffffffff815f23fd>] notifier_call_chain+0x4d/0x70
> [    0.633691]  [<ffffffff810694e8>] __blocking_notifier_call_chain+0x58/0x80
> [    0.633692]  [<ffffffff81069526>] blocking_notifier_call_chain+0x16/0x20
> [    0.633694]  [<ffffffff812c787b>] fb_notifier_call_chain+0x1b/0x20
> [    0.633695]  [<ffffffff812c9018>] register_framebuffer+0x1c8/0x310
> [    0.633696]  [<ffffffff8134b4d1>] drm_fb_helper_initial_config+0x371/0x520
> [    0.633697]  [<ffffffff8134a607>] ? drm_fb_helper_single_add_all_connectors+0x47/0xf0
> [    0.633700]  [<ffffffff81140a5e>] ? kmem_cache_alloc_trace+0xee/0x150
> [    0.633701]  [<ffffffff8140578e>] nouveau_fbcon_init+0x10e/0x160
> [    0.633703]  [<ffffffff813f5f8a>] nouveau_drm_load+0x40a/0x5d0
> [    0.633705]  [<ffffffff81430cee>] ? device_register+0x1e/0x30
> [    0.633706]  [<ffffffff8135c086>] ? drm_sysfs_device_add+0x86/0xb0
> [    0.633708]  [<ffffffff8135a9b6>] drm_get_pci_dev+0x186/0x2d0
> [    0.633710]  [<ffffffff812b0eab>] ? __pci_set_master+0x2b/0x90
> [    0.633711]  [<ffffffff813f63ba>] nouveau_drm_probe+0x26a/0x2c0
> [    0.633713]  [<ffffffff812b4f15>] ? pci_match_device+0xd5/0xe0
> [    0.633714]  [<ffffffff812b5096>] pci_device_probe+0x136/0x150
> [    0.633715]  [<ffffffff81433566>] driver_probe_device+0x76/0x210
> [    0.633716]  [<ffffffff814337ab>] __driver_attach+0xab/0xb0
> [    0.633717]  [<ffffffff81433700>] ? driver_probe_device+0x210/0x210
> [    0.633718]  [<ffffffff8143175d>] bus_for_each_dev+0x5d/0xa0
> [    0.633719]  [<ffffffff81432fae>] driver_attach+0x1e/0x20
> [    0.633720]  [<ffffffff81432b91>] bus_add_driver+0x111/0x280
> [    0.633722]  [<ffffffff81b21cf6>] ? ttm_init+0x62/0x62
> [    0.633724]  [<ffffffff81433e67>] driver_register+0x77/0x170
> [    0.633725]  [<ffffffff81b21cf6>] ? ttm_init+0x62/0x62
> [    0.633726]  [<ffffffff812b4054>] __pci_register_driver+0x64/0x70
> [    0.633728]  [<ffffffff8135ac15>] drm_pci_init+0x115/0x130
> [    0.633729]  [<ffffffff81b21cf6>] ? ttm_init+0x62/0x62
> [    0.633730]  [<ffffffff81b21cf6>] ? ttm_init+0x62/0x62
> [    0.633731]  [<ffffffff81b21d43>] nouveau_drm_init+0x4d/0x4f
> [    0.633732]  [<ffffffff81000312>] do_one_initcall+0x122/0x170
> [    0.633734]  [<ffffffff81af6f49>] kernel_init_freeable+0x108/0x197
> [    0.633735]  [<ffffffff81af681c>] ? do_early_param+0x8c/0x8c
> [    0.633737]  [<ffffffff815d4d20>] ? rest_init+0xe0/0xe0
> [    0.633738]  [<ffffffff815d4d2e>] kernel_init+0xe/0xf0
> [    0.633740]  [<ffffffff815f6b1c>] ret_from_fork+0x7c/0xb0
> [    0.633741]  [<ffffffff815d4d20>] ? rest_init+0xe0/0xe0
> 


