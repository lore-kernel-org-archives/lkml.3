Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab3BDX1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 18:27:08 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:42553 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755434Ab3BDX1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 18:27:05 -0500
Message-ID: <1360020294.23235.2.camel@thor.lan>
Subject: Re: [PATCH] drm/nouveau: add lockdep annotations
From: Peter Hurley <peter@hurleysoftware.com>
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>, Ben Skeggs <bskeggs@redhat.com>,
        nouveau@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Dave Airlie <airlied@linux.ie>, Daniel J Blueman <daniel@quora.org>,
        Arend van Spriel <arend@broadcom.com>
Date: Mon, 04 Feb 2013 18:24:54 -0500
In-Reply-To: <51102F40.2090008@canonical.com>
References: <CAMVG2svkJruzveuozb8RFK_j1BxqDOwBco=Aida9S680_toNiQ@mail.gmail.com>
	 <20130204213041.GA3433@joi.lan> <51102F40.2090008@canonical.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.3-0pjh1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maarten

On Mon, 2013-02-04 at 22:59 +0100, Maarten Lankhorst wrote:
> Op 04-02-13 22:30, Marcin Slusarz schreef:
> > 1) Lockdep thinks all nouveau subdevs belong to the same class and can be
> > locked in arbitrary order, which is not true (at least in general case).
> > Tell it to distinguish subdevs by (o)class type.
> Apart from this specific case, is there any other reason why we require being able to nest 2 subdev locks?
> 
> Add a NVOBJ_FLAG_CREATE_EXCLUSIVE flag to nouveau_engctx_create and return -EBUSY if there is any existing object. Problem solved, and lockdep is still generic.
> 
> > 2) DRM client can be locked under user client lock - tell lockdep to put DRM
> > client lock in a separate class.
> Can you copy paste a typical lockdep splat for this? Also this should be a separate patch. :-)

PS - Deep call chain. Has anyone looked into max stack depth yet?

[    5.995881] =============================================
[    5.995886] [ INFO: possible recursive locking detected ]
[    5.995892] 3.8.0-next-20130125+ttypatch-xeon+lockdep #20130125+ttypatch Not tainted
[    5.995898] ---------------------------------------------
[    5.995904] modprobe/275 is trying to acquire lock:
[    5.995909]  (&subdev->mutex){+.+.+.}, at: [<ffffffffa00d10b8>] nouveau_instobj_create_+0x48/0x90 [nouveau]
[    5.995955] 
[    5.995955] but task is already holding lock:
[    5.995961]  (&subdev->mutex){+.+.+.}, at: [<ffffffffa00da3b5>] nv50_disp_data_ctor+0x65/0xd0 [nouveau]
[    5.995989] 
[    5.995989] other info that might help us debug this:
[    5.995995]  Possible unsafe locking scenario:
[    5.995995] 
[    5.996001]        CPU0
[    5.996004]        ----
[    5.996005]   lock(&subdev->mutex);
[    5.996005]   lock(&subdev->mutex);
[    5.996005] 
[    5.996005]  *** DEADLOCK ***
[    5.996005] 
[    5.996005]  May be due to missing lock nesting notation
[    5.996005] 
[    5.996005] 4 locks held by modprobe/275:
[    5.996005]  #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff8146fa5b>] __driver_attach+0x5b/0xb0
[    5.996005]  #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff8146fa69>] __driver_attach+0x69/0xb0
[    5.996005]  #2:  (drm_global_mutex){+.+.+.}, at: [<ffffffffa0028d86>] drm_get_pci_dev+0xc6/0x2d0 [drm]
[    5.996005]  #3:  (&subdev->mutex){+.+.+.}, at: [<ffffffffa00da3b5>] nv50_disp_data_ctor+0x65/0xd0 [nouveau]
[    5.996005] 
[    5.996005] stack backtrace:
[    5.996005] Pid: 275, comm: modprobe Not tainted 3.8.0-next-20130125+ttypatch-xeon+lockdep #20130125+ttypatch
[    5.996005] Call Trace:
[    5.996005]  [<ffffffff810bd437>] __lock_acquire+0x687/0x1a70
[    5.996005]  [<ffffffff810bf70b>] ? mark_held_locks+0x9b/0x100
[    5.996005]  [<ffffffff810bf87d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[    5.996005]  [<ffffffff810bf91d>] ? trace_hardirqs_on+0xd/0x10
[    5.996005]  [<ffffffff8170a87a>] ? _raw_write_unlock_irqrestore+0x4a/0x90
[    5.996005]  [<ffffffff810bedc8>] lock_acquire+0x98/0x150
[    5.996005]  [<ffffffffa00d10b8>] ? nouveau_instobj_create_+0x48/0x90 [nouveau]
[    5.996005]  [<ffffffffa00d10b8>] ? nouveau_instobj_create_+0x48/0x90 [nouveau]
[    5.996005]  [<ffffffff81707f60>] mutex_lock_nested+0x50/0x390
[    5.996005]  [<ffffffffa00d10b8>] ? nouveau_instobj_create_+0x48/0x90 [nouveau]
[    5.996005]  [<ffffffffa00b6376>] ? nouveau_object_ref+0x46/0xd0 [nouveau]
[    5.996005]  [<ffffffffa00b64b5>] ? nouveau_object_create_+0x65/0xa0 [nouveau]
[    5.996005]  [<ffffffffa00d10b8>] nouveau_instobj_create_+0x48/0x90 [nouveau]
[    5.996005]  [<ffffffffa00d1be1>] nv50_instobj_ctor+0x51/0xf0 [nouveau]
[    5.996005]  [<ffffffffa00b62a8>] nouveau_object_ctor+0x38/0xc0 [nouveau]
[    5.996005]  [<ffffffffa00d1b36>] nv50_instmem_alloc+0x26/0x30 [nouveau]
[    5.996005]  [<ffffffffa00b49a7>] nouveau_gpuobj_create_+0x247/0x2f0 [nouveau]
[    5.996005]  [<ffffffff8170afed>] ? _raw_spin_unlock_irqrestore+0x6d/0x90
[    5.996005]  [<ffffffff810bf87d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
[    5.996005]  [<ffffffffa00b34dc>] nouveau_engctx_create_+0x26c/0x2b0 [nouveau]
[    5.996005]  [<ffffffffa00da411>] nv50_disp_data_ctor+0xc1/0xd0 [nouveau]
[    5.996005]  [<ffffffffa00b62a8>] nouveau_object_ctor+0x38/0xc0 [nouveau]
[    5.996005]  [<ffffffffa00b6b82>] nouveau_object_new+0x112/0x240 [nouveau]
[    5.996005]  [<ffffffffa0155fe5>] nv50_display_create+0x1a5/0x890 [nouveau]
[    5.996005]  [<ffffffff8107837b>] ? __cancel_work_timer+0x8b/0xe0
[    5.996005]  [<ffffffffa013c80b>] nouveau_display_create+0x3cb/0x670 [nouveau]
[    5.996005]  [<ffffffffa012ba0f>] nouveau_drm_load+0x26f/0x590 [nouveau]
[    5.996005]  [<ffffffff8146caee>] ? device_register+0x1e/0x30
[    5.996005]  [<ffffffffa002a626>] ? drm_sysfs_device_add+0x86/0xb0 [drm]
[    5.996005]  [<ffffffffa0028e46>] drm_get_pci_dev+0x186/0x2d0 [drm]
[    5.996005]  [<ffffffffa012bf9a>] nouveau_drm_probe+0x26a/0x2c0 [nouveau]
[    5.996005]  [<ffffffff8170afca>] ? _raw_spin_unlock_irqrestore+0x4a/0x90
[    5.996005]  [<ffffffff81393a8b>] local_pci_probe+0x4b/0x80
[    5.996005]  [<ffffffff81393da1>] pci_device_probe+0x111/0x120
[    5.996005]  [<ffffffff8146f6eb>] driver_probe_device+0x8b/0x3a0
[    5.996005]  [<ffffffff8146faab>] __driver_attach+0xab/0xb0
[    5.996005]  [<ffffffff8146fa00>] ? driver_probe_device+0x3a0/0x3a0
[    5.996005]  [<ffffffff8146d635>] bus_for_each_dev+0x55/0x90
[    5.996005]  [<ffffffff8146f12e>] driver_attach+0x1e/0x20
[    5.996005]  [<ffffffff8146ebe1>] bus_add_driver+0x121/0x2b0
[    5.996005]  [<ffffffffa01ad000>] ? 0xffffffffa01acfff
[    5.996005]  [<ffffffff814701b7>] driver_register+0x77/0x170
[    5.996005]  [<ffffffffa01ad000>] ? 0xffffffffa01acfff
[    5.996005]  [<ffffffff81392b14>] __pci_register_driver+0x64/0x70
[    5.996005]  [<ffffffffa00290aa>] drm_pci_init+0x11a/0x130 [drm]
[    5.996005]  [<ffffffffa01ad000>] ? 0xffffffffa01acfff
[    5.996005]  [<ffffffffa01ad000>] ? 0xffffffffa01acfff
[    5.996005]  [<ffffffffa01ad04d>] nouveau_drm_init+0x4d/0x1000 [nouveau]
[    5.996005]  [<ffffffff8100215a>] do_one_initcall+0x12a/0x180
[    5.996005]  [<ffffffff810cc6a7>] load_module+0x12f7/0x1be0
[    5.996005]  [<ffffffff8137ce20>] ? ddebug_proc_open+0xd0/0xd0
[    5.996005]  [<ffffffff8136993e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    5.996005]  [<ffffffff810cd067>] sys_init_module+0xd7/0x120
[    5.996005]  [<ffffffff81712f59>] system_call_fastpath+0x16/0x1b


