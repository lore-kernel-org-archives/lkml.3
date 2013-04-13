Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933015Ab3DMPmE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Apr 2013 11:42:04 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:37557 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607Ab3DMPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Apr 2013 11:41:51 -0400
Date: Sat, 13 Apr 2013 17:41:46 +0200
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: dri-devel@lists.freedesktop.org
Cc: linux-kernel@vger.kernel.org, airlied@linux.ie, daniel.vetter@ffwll.ch
Subject: drm: i915+fb: crtc->lock recursive locking deadlock on VT switch [>=
 3.9-rc1 regresion]
Message-ID: <20130413154146.GA8136@shrek.podlesie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

the drm_fb_helper_hotplug_event() locks all crtc->mutex locks by calling
drm_modeset_lock_all() and later calls drm_fb_helper_probe_connector_modes(),
which in case of i915 DRM driver effectively calls
intel_get_load_detect_pipe() that tries to lock crtc->mutex again.
This causes a deadlock, and can be in some cases triggered by VT
switch to framebuffer console on i915.

This bug is introduced in Linux 3.9-rc1 and still exists
in v3.9-rc6-183-gbf81710. Linux 3.8 is ok.

This deadlock is probably introduced by
commit 7b24056be6db7ce907baffdd4cf142ab774ea60c
(drm: don't hold crtc mutexes for connector ->detect callbacks).


Steps to reproduce (the deadlock occurs in almost all cases):
LCD panel connected to LVDS1, 915GM, HP nc6120
1. power on
2. $ startx
3. connect monitor to VGA1
4. $ xrandr --output VGA1 --mode 1600x1200 --right-of LVDS1
5. change VT, ALT + CTRL + F2

Krzysiek

...
[   62.995861] [drm:drm_helper_probe_single_connector_modes], [CONNECTOR:13:SVIDEO-1]
[   62.995870] [drm:intel_get_load_detect_pipe], [CONNECTOR:13:SVIDEO-1], [ENCODER:14:TV-14]
[   62.995873] 
[   62.995875] =============================================
[   62.995877] [ INFO: possible recursive locking detected ]
[   62.995881] 3.9.0-rc6-00184-gc875d9b #14 Not tainted
# v3.9-rc6-183-gbf81710 + one unrelated local patch.
[   62.995883] ---------------------------------------------
[   62.995885] X/1759 is trying to acquire lock:
[   62.995903]  (&crtc->mutex){+.+.+.}, at: [<803649e4>] intel_get_load_detect_pipe+0x164/0x3f0
[   62.995905] 
[   62.995905] but task is already holding lock:
[   62.995916]  (&crtc->mutex){+.+.+.}, at: [<8032d1da>] drm_modeset_lock_all+0x3a/0x50
[   62.995918] 
[   62.995918] other info that might help us debug this:
[   62.995920]  Possible unsafe locking scenario:
[   62.995920] 
[   62.995921]        CPU0
[   62.995923]        ----
[   62.995926]   lock(&crtc->mutex);
[   62.995930]   lock(&crtc->mutex);
[   62.995931] 
[   62.995931]  *** DEADLOCK ***
[   62.995931] 
[   62.995933]  May be due to missing lock nesting notation
[   62.995933] 
[   62.995936] 3 locks held by X/1759:
[   62.995948]  #0:  (console_lock){+.+.+.}, at: [<802fe726>] vt_ioctl+0xe26/0x1220
[   62.995958]  #1:  (&dev->mode_config.mutex){+.+.+.}, at: [<8032d1b5>] drm_modeset_lock_all+0x15/0x50
[   62.995968]  #2:  (&crtc->mutex){+.+.+.}, at: [<8032d1da>] drm_modeset_lock_all+0x3a/0x50
[   62.995970] 
[   62.995970] stack backtrace:
[   62.995974] Pid: 1759, comm: X Not tainted 3.9.0-rc6-00184-gc875d9b #14
[   62.995976] Call Trace:
[   62.995985]  [<8016d9f8>] __lock_acquire+0x748/0x19e0
[   62.995991]  [<80160008>] ? ktime_get+0xb8/0xf0
[   62.995998]  [<80155f6e>] ? local_clock+0x4e/0x60
[   62.996005]  [<8012c2c5>] ? log_store+0x2d5/0x3b0
[   62.996011]  [<8014fc83>] ? down_trylock+0x13/0x40
[   62.996017]  [<8016b655>] ? mark_held_locks+0x75/0xe0
[   62.996020]  [<8012d9b9>] ? vprintk_emit+0x159/0x4e0
[   62.996020]  [<8016f189>] lock_acquire+0x79/0x90
[   62.996020]  [<803649e4>] ? intel_get_load_detect_pipe+0x164/0x3f0
[   62.996020]  [<8050acf4>] mutex_lock_nested+0x54/0x310
[   62.996020]  [<803649e4>] ? intel_get_load_detect_pipe+0x164/0x3f0
[   62.996020]  [<803649e4>] ? intel_get_load_detect_pipe+0x164/0x3f0
[   62.996020]  [<80327c7a>] ? drm_ut_debug_printk+0x2a/0x50
[   62.996020]  [<803649e4>] intel_get_load_detect_pipe+0x164/0x3f0
[   62.996020]  [<80108707>] ? native_sched_clock+0x27/0xb0
[   62.996020]  [<80155bcc>] ? sched_clock_local.constprop.2+0x3c/0x170
[   62.996020]  [<8038061d>] intel_tv_detect+0x15d/0x570
[   62.996020]  [<8016b98b>] ? trace_hardirqs_off+0xb/0x10
[   62.996020]  [<80155f6e>] ? local_clock+0x4e/0x60
[   62.996020]  [<8012c2c5>] ? log_store+0x2d5/0x3b0
[   62.996020]  [<8014fc83>] ? down_trylock+0x13/0x40
[   62.996020]  [<8031dbd8>] drm_helper_probe_single_connector_modes+0x278/0x330
[   62.996020]  [<80319fc7>] drm_fb_helper_probe_connector_modes.isra.3+0x37/0x60
[   62.996020]  [<8031bfec>] drm_fb_helper_hotplug_event+0x6c/0xc0
[   62.996020]  [<8031c0d3>] drm_fb_helper_set_par+0x93/0xc0
[   62.996020]  [<802afdaa>] fb_set_var+0x1ea/0x4b0
[   62.996020]  [<8016d6bb>] ? __lock_acquire+0x40b/0x19e0
[   62.996020]  [<80108707>] ? native_sched_clock+0x27/0xb0
[   62.996020]  [<80155bcc>] ? sched_clock_local.constprop.2+0x3c/0x170
[   62.996020]  [<802b964a>] fbcon_blank+0x2aa/0x300
[   62.996020]  [<80307371>] do_unblank_screen+0x91/0x1a0
[   62.996020]  [<802fd876>] complete_change_console+0x56/0xe0
[   62.996020]  [<802fea3f>] vt_ioctl+0x113f/0x1220
[   62.996020]  [<8050d8c7>] ? _raw_spin_unlock+0x27/0x50
[   62.996020]  [<802fd900>] ? complete_change_console+0xe0/0xe0
[   62.996020]  [<802f438a>] tty_ioctl+0x26a/0xb70
[   62.996020]  [<80155bcc>] ? sched_clock_local.constprop.2+0x3c/0x170
[   62.996020]  [<802fd900>] ? complete_change_console+0xe0/0xe0
[   62.996020]  [<80155db5>] ? sched_clock_cpu+0x75/0xd0
[   62.996020]  [<8016b98b>] ? trace_hardirqs_off+0xb/0x10
[   62.996020]  [<80155f6e>] ? local_clock+0x4e/0x60
[   62.996020]  [<80169a2d>] ? put_lock_stats.isra.22+0xd/0x30
[   62.996020]  [<802f4120>] ? no_tty+0x20/0x20
[   62.996020]  [<801ca9c3>] do_vfs_ioctl+0x73/0x5d0
[   62.996020]  [<8014ede6>] ? up_read+0x16/0x30
[   62.996020]  [<8012548b>] ? __do_page_fault+0x1bb/0x470
[   62.996020]  [<801d6f18>] ? fget_light+0x2c8/0x410
[   62.996020]  [<8022fcc0>] ? reiserfs_sync_file+0x120/0x120
[   62.996020]  [<801caf57>] sys_ioctl+0x37/0x80
[   62.996020]  [<8050eb78>] sysenter_do_call+0x12/0x36
