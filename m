Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964792Ab3CSUkf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:40:35 -0400
Received: from mailout02.c08.mtsvc.net ([205.186.168.190]:38954 "EHLO
	mailout02.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754805Ab3CSUkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:40:33 -0400
Message-ID: <1363725620.3413.29.camel@thor.lan>
Subject: Re: [Nouveau] nouveau lockdep splat
From: Peter Hurley <peter@hurleysoftware.com>
To: Borislav Petkov <bp@alien8.de>, Ben Skeggs <bskeggs@redhat.com>
Cc: Lucas Stach <dev@lynxeye.de>, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@linux.ie>
Date: Tue, 19 Mar 2013 16:40:20 -0400
In-Reply-To: <20130319202432.GC4570@pd.tnic>
References: <20130304211608.GD22274@pd.tnic>
	 <1362501052.1933.2.camel@antimon> <20130319202432.GC4570@pd.tnic>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ adding Ben Skeggs and Dave Airlie ]

On Tue, 2013-03-19 at 21:24 +0100, Borislav Petkov wrote:
> On Tue, Mar 05, 2013 at 05:30:52PM +0100, Lucas Stach wrote:
> > Dropping Tegra ML, it's not the place where Nouveau mails should go.
> > Adding Nouveau ML and Maarten, who probably knows Lockdep+Nouveau best.
> 
> Ok,
> 
> with the hope of having the right people on CC now (finally, thanks
> Lucas :-)), here's the same splat on -rc3. Someone better take a look
> soonish, please:

Also happens in next (on nv50 hardware).

> [    0.541078] [drm] No driver support for vblank timestamp query.
> [    0.541272] nouveau  [     DRM] 3 available performance level(s)
> [    0.541276] nouveau  [     DRM] 0: core 135MHz shader 270MHz memory 135MHz voltage 900mV
> [    0.541280] nouveau  [     DRM] 1: core 405MHz shader 810MHz memory 405MHz voltage 900mV
> [    0.541284] nouveau  [     DRM] 3: core 520MHz shader 1230MHz memory 790MHz voltage 900mV
> [    0.541287] nouveau  [     DRM] c: core 405MHz shader 810MHz memory 405MHz voltage 900mV
> [    0.559846] nouveau  [     DRM] MM: using COPY for buffer copies
> [    0.625371] nouveau  [     DRM] allocated 1920x1080 fb: 0x70000, bo ffff88043b54f000
> [    0.625441] fbcon: nouveaufb (fb0) is primary device
> [    0.625555] 
> [    0.625556] =============================================
> [    0.625556] [ INFO: possible recursive locking detected ]
> [    0.625557] 3.9.0-rc3+ #25 Not tainted
> [    0.625557] ---------------------------------------------
> [    0.625558] swapper/0/1 is trying to acquire lock:
> [    0.625562]  (&dmac->lock){+.+...}, at: [<ffffffff8141bb63>] evo_wait+0x43/0xf0
> [    0.625562] 
> [    0.625562] but task is already holding lock:
> [    0.625564]  (&dmac->lock){+.+...}, at: [<ffffffff8141bb63>] evo_wait+0x43/0xf0
> [    0.625565] 
> [    0.625565] other info that might help us debug this:
> [    0.625565]  Possible unsafe locking scenario:
> [    0.625565] 
> [    0.625565]        CPU0
> [    0.625565]        ----
> [    0.625566]   lock(&dmac->lock);
> [    0.625567]   lock(&dmac->lock);
> [    0.625567] 
> [    0.625567]  *** DEADLOCK ***
> [    0.625567] 
> [    0.625567]  May be due to missing lock nesting notation
> [    0.625567] 
> [    0.625568] 10 locks held by swapper/0/1:
> [    0.625570]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff814337cb>] __driver_attach+0x5b/0xb0
> [    0.625572]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff814337d9>] __driver_attach+0x69/0xb0
> [    0.625575]  #2:  (drm_global_mutex){+.+.+.}, at: [<ffffffff8135a8e6>] drm_get_pci_dev+0xc6/0x2d0
> [    0.625578]  #3:  (registration_lock){+.+.+.}, at: [<ffffffff812c8fc5>] register_framebuffer+0x25/0x310
> [    0.625581]  #4:  (&fb_info->lock){+.+.+.}, at: [<ffffffff812c7ed6>] lock_fb_info+0x26/0x60
> [    0.625583]  #5:  (console_lock){+.+.+.}, at: [<ffffffff812c915a>] register_framebuffer+0x1ba/0x310
> [    0.625585]  #6:  ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff810695c2>] __blocking_notifier_call_chain+0x42/0x80
> [    0.625587]  #7:  (&dev->mode_config.mutex){+.+.+.}, at: [<ffffffff8135e61a>] drm_modeset_lock_all+0x2a/0x70
> [    0.625589]  #8:  (&crtc->mutex){+.+.+.}, at: [<ffffffff8135e644>] drm_modeset_lock_all+0x54/0x70
> [    0.625591]  #9:  (&dmac->lock){+.+...}, at: [<ffffffff8141bb63>] evo_wait+0x43/0xf0
> [    0.625591] 
> [    0.625591] stack backtrace:
> [    0.625592] Pid: 1, comm: swapper/0 Not tainted 3.9.0-rc3+ #25
> [    0.625593] Call Trace:
> [    0.625595]  [<ffffffff810953fb>] __lock_acquire+0x76b/0x1c20
> [    0.625597]  [<ffffffff8137f4ec>] ? dcb_table+0x1ac/0x2a0
> [    0.625599]  [<ffffffff81096e1a>] lock_acquire+0x8a/0x120
> [    0.625600]  [<ffffffff8141bb63>] ? evo_wait+0x43/0xf0
> [    0.625602]  [<ffffffff81615432>] ? mutex_lock_nested+0x292/0x330
> [    0.625603]  [<ffffffff8161520e>] mutex_lock_nested+0x6e/0x330
> [    0.625605]  [<ffffffff8141bb63>] ? evo_wait+0x43/0xf0
> [    0.625606]  [<ffffffff810976eb>] ? mark_held_locks+0x9b/0x100
> [    0.625607]  [<ffffffff8141bb63>] evo_wait+0x43/0xf0
> [    0.625609]  [<ffffffff8141e603>] nv50_display_flip_next+0x713/0x7a0
> [    0.625611]  [<ffffffff8161562e>] ? mutex_unlock+0xe/0x10
> [    0.625612]  [<ffffffff8141bc47>] ? evo_kick+0x37/0x40
> [    0.625613]  [<ffffffff8141e88e>] nv50_crtc_commit+0x10e/0x230
> [    0.625615]  [<ffffffff8134c295>] drm_crtc_helper_set_mode+0x365/0x510
> [    0.625617]  [<ffffffff8134d68e>] drm_crtc_helper_set_config+0xa4e/0xb70
> [    0.625618]  [<ffffffff8135f731>] drm_mode_set_config_internal+0x31/0x70
> [    0.625619]  [<ffffffff8134b791>] drm_fb_helper_set_par+0x71/0xf0
> [    0.625621]  [<ffffffff812d4234>] fbcon_init+0x514/0x5a0
> [    0.625623]  [<ffffffff8132cbfc>] visual_init+0xbc/0x120
> [    0.625624]  [<ffffffff8132f2b3>] do_bind_con_driver+0x163/0x320
> [    0.625625]  [<ffffffff8132f541>] do_take_over_console+0x61/0x70
> [    0.625627]  [<ffffffff812d2853>] do_fbcon_takeover+0x63/0xc0
> [    0.625628]  [<ffffffff812d652d>] fbcon_event_notify+0x5fd/0x700
> [    0.625629]  [<ffffffff8161c91d>] notifier_call_chain+0x4d/0x70
> [    0.625630]  [<ffffffff810695d8>] __blocking_notifier_call_chain+0x58/0x80
> [    0.625631]  [<ffffffff81069616>] blocking_notifier_call_chain+0x16/0x20
> [    0.625633]  [<ffffffff812c79cb>] fb_notifier_call_chain+0x1b/0x20
> [    0.625634]  [<ffffffff812c9168>] register_framebuffer+0x1c8/0x310
> [    0.625635]  [<ffffffff8134b4c1>] drm_fb_helper_initial_config+0x371/0x520
> [    0.625637]  [<ffffffff8134a5f7>] ? drm_fb_helper_single_add_all_connectors+0x47/0xf0
> [    0.625639]  [<ffffffff81140c4e>] ? kmem_cache_alloc_trace+0xee/0x150
> [    0.625641]  [<ffffffff8140579e>] nouveau_fbcon_init+0x10e/0x160
> [    0.625643]  [<ffffffff813f5f8a>] nouveau_drm_load+0x40a/0x5d0
> [    0.625644]  [<ffffffff81430d5e>] ? device_register+0x1e/0x30
> [    0.625645]  [<ffffffff8135c076>] ? drm_sysfs_device_add+0x86/0xb0
> [    0.625647]  [<ffffffff8135a9a6>] drm_get_pci_dev+0x186/0x2d0
> [    0.625649]  [<ffffffff812b0fdb>] ? __pci_set_master+0x2b/0x90
> [    0.625650]  [<ffffffff813f63ba>] nouveau_drm_probe+0x26a/0x2c0
> [    0.625652]  [<ffffffff812b5045>] ? pci_match_device+0xd5/0xe0
> [    0.625654]  [<ffffffff812b51c6>] pci_device_probe+0x136/0x150
> [    0.625655]  [<ffffffff814335d6>] driver_probe_device+0x76/0x210
> [    0.625656]  [<ffffffff8143381b>] __driver_attach+0xab/0xb0
> [    0.625657]  [<ffffffff81433770>] ? driver_probe_device+0x210/0x210
> [    0.625658]  [<ffffffff814317cd>] bus_for_each_dev+0x5d/0xa0
> [    0.625659]  [<ffffffff8143301e>] driver_attach+0x1e/0x20
> [    0.625660]  [<ffffffff81432c01>] bus_add_driver+0x111/0x280
> [    0.625662]  [<ffffffff81d22af1>] ? ttm_init+0x62/0x62
> [    0.625663]  [<ffffffff81433ed7>] driver_register+0x77/0x170
> [    0.625665]  [<ffffffff81d22af1>] ? ttm_init+0x62/0x62
> [    0.625666]  [<ffffffff812b4184>] __pci_register_driver+0x64/0x70
> [    0.625668]  [<ffffffff8135ac05>] drm_pci_init+0x115/0x130
> [    0.625669]  [<ffffffff81d22af1>] ? ttm_init+0x62/0x62
> [    0.625670]  [<ffffffff81d22af1>] ? ttm_init+0x62/0x62
> [    0.625671]  [<ffffffff81d22b3e>] nouveau_drm_init+0x4d/0x4f
> [    0.625673]  [<ffffffff81000312>] do_one_initcall+0x122/0x170
> [    0.625675]  [<ffffffff81cf7f49>] kernel_init_freeable+0x108/0x197
> [    0.625676]  [<ffffffff81cf781c>] ? do_early_param+0x8c/0x8c
> [    0.625678]  [<ffffffff815ff110>] ? rest_init+0xe0/0xe0
> [    0.625679]  [<ffffffff815ff11e>] kernel_init+0xe/0xf0
> [    0.625681]  [<ffffffff81620fdc>] ret_from_fork+0x7c/0xb0
> [    0.625682]  [<ffffffff815ff110>] ? rest_init+0xe0/0xe0
> [    0.697046] Console: switching to colour frame buffer device 240x67
> [    0.735951] nouveau 0000:03:00.0: fb0: nouveaufb frame buffer device
> [    0.736451] nouveau 0000:03:00.0: registered panic notifier
> [    0.736955] [drm] Initialized nouveau 1.1.0 20120801 for 0000:03:00.0 on minor 0
> 


