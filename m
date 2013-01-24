Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3AXT6l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 14:58:41 -0500
Received: from mail-bk0-f50.google.com ([209.85.214.50]:62693 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755386Ab3AXT6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 14:58:34 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <1359048860.21908.17.camel@jlt4.sipsolutions.net>
References: <1359048860.21908.17.camel@jlt4.sipsolutions.net>
Date: Thu, 24 Jan 2013 20:58:32 +0100
X-Google-Sender-Auth: -sruwBg22sq8O1gr5_6tdmcf78I
Message-ID: <CAKMK7uFT+fEL=adyLjQEr_7JRpE5RSUbdiyFyb2GpvEGfV4Ezw@mail.gmail.com>
Subject: Re: circular locking warning during suspend
From: Daniel Vetter <daniel@ffwll.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 6:34 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Hi,
>
> I didn't find this reported, but maybe it has been, I didn't search for
> too long. I'm using 3.8.0-rc4 (plus wireless bits), and lockdep is
> unhappy. Note that I am booting with "no_console_suspend".

Patches for the know issues around consolo_lock vs fbdev_notifier are in -mm:

  http://ozlabs.org/~akpm/mmots/broken-out/fb-rework-locking-to-fix-lock-ordering-on-takeover.patch
  http://ozlabs.org/~akpm/mmots/broken-out/fb-yet-another-band-aid-
for-fixing-lockdep-mess.patch

Unfortunately the patches seem to be stuck there for now despite quite
a few reports about this (including seemingly relevant background
noise about hangs in distro bugzillas).
-Daniel

>
> [   73.320586] ======================================================
> [   73.320587] [ INFO: possible circular locking dependency detected ]
> [   73.320592] 3.8.0-rc4-wl-67484-g04fa847 #106 Tainted: G        W
> [   73.320594] -------------------------------------------------------
> [   73.320597] kworker/u:9/2574 is trying to acquire lock:
> [   73.320614]  ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff8106f94a>] __blocking_notifier_call_chain+0x5a/0xd0
> [   73.320616]
> [   73.320616] but task is already holding lock:
> [   73.320627]  (console_lock){+.+.+.}, at: [<ffffffff81323c80>] i915_drm_freeze+0x90/0xe0
> [   73.320628]
> [   73.320628] which lock already depends on the new lock.
> [   73.320628]
> [   73.320629]
> [   73.320629] the existing dependency chain (in reverse order) is:
> [   73.320635]
> [   73.320635] -> #1 (console_lock){+.+.+.}:
> [   73.320642]        [<ffffffff810a13e6>] lock_acquire+0x96/0x1e0
> [   73.320647]        [<ffffffff8103bda7>] console_lock+0x77/0x80
> [   73.320654]        [<ffffffff812e2fda>] register_con_driver+0x3a/0x150
> [   73.320660]        [<ffffffff812e4b4f>] take_over_console+0x2f/0x70
> [   73.320666]        [<ffffffff81287d53>] fbcon_takeover+0x63/0xc0
> [   73.320671]        [<ffffffff8128baa5>] fbcon_event_notify+0x615/0x720
> [   73.320677]        [<ffffffff814b56ed>] notifier_call_chain+0x5d/0x110
> [   73.320683]        [<ffffffff8106f964>] __blocking_notifier_call_chain+0x74/0xd0
> [   73.320689]        [<ffffffff8106f9d6>] blocking_notifier_call_chain+0x16/0x20
> [   73.320695]        [<ffffffff8127ce6b>] fb_notifier_call_chain+0x1b/0x20
> [   73.320700]        [<ffffffff8127e625>] register_framebuffer+0x1c5/0x300
> [   73.320707]        [<ffffffff813021bc>] drm_fb_helper_single_fb_probe+0x1fc/0x330
> [   73.320712]        [<ffffffff813024d2>] drm_fb_helper_initial_config+0x1e2/0x250
> [   73.320718]        [<ffffffff81374cea>] intel_fbdev_init+0x8a/0xc0
> [   73.320724]        [<ffffffff81329527>] i915_driver_load+0xbc7/0xe00
> [   73.320730]        [<ffffffff81311bbe>] drm_get_pci_dev+0x18e/0x2d0
> [   73.320735]        [<ffffffff8132407b>] i915_pci_probe+0x3b/0x90
> [   73.320741]        [<ffffffff8126f036>] pci_device_probe+0xa6/0xf0
> [   73.320747]        [<ffffffff8138765c>] driver_probe_device+0x7c/0x240
> [   73.320752]        [<ffffffff813878bc>] __driver_attach+0x9c/0xa0
> [   73.320757]        [<ffffffff813857d6>] bus_for_each_dev+0x56/0x90
> [   73.320762]        [<ffffffff8138711e>] driver_attach+0x1e/0x20
> [   73.320767]        [<ffffffff81386cd8>] bus_add_driver+0x1a8/0x270
> [   73.320772]        [<ffffffff81387fa8>] driver_register+0x78/0x160
> [   73.320777]        [<ffffffff8126de65>] __pci_register_driver+0x65/0x70
> [   73.320782]        [<ffffffff81311e17>] drm_pci_init+0x117/0x130
> [   73.320789]        [<ffffffff81c81871>] i915_init+0x66/0x68
> [   73.320796]        [<ffffffff810002f2>] do_one_initcall+0x122/0x170
> [   73.320801]        [<ffffffff8149af8c>] kernel_init+0x13c/0x2b0
> [   73.320807]        [<ffffffff814b9d5c>] ret_from_fork+0x7c/0xb0
> [   73.320813]
> [   73.320813] -> #0 ((fb_notifier_list).rwsem){.+.+.+}:
> [   73.320818]        [<ffffffff810a0c1e>] __lock_acquire+0x1aee/0x1be0
> [   73.320823]        [<ffffffff810a13e6>] lock_acquire+0x96/0x1e0
> [   73.320829]        [<ffffffff814af21e>] down_read+0x4e/0x98
> [   73.320835]        [<ffffffff8106f94a>] __blocking_notifier_call_chain+0x5a/0xd0
> [   73.320841]        [<ffffffff8106f9d6>] blocking_notifier_call_chain+0x16/0x20
> [   73.320846]        [<ffffffff8127ce6b>] fb_notifier_call_chain+0x1b/0x20
> [   73.320851]        [<ffffffff8127d5de>] fb_set_suspend+0x4e/0x60
> [   73.320856]        [<ffffffff81374e65>] intel_fbdev_set_suspend+0x25/0x30
> [   73.320862]        [<ffffffff81323c8d>] i915_drm_freeze+0x9d/0xe0
> [   73.320867]        [<ffffffff813242ea>] i915_pm_suspend+0x4a/0xa0
> [   73.320872]        [<ffffffff8126e2b4>] pci_pm_suspend+0x74/0x140
> [   73.320878]        [<ffffffff8138f12c>] dpm_run_callback.isra.3+0x3c/0x80
> [   73.320883]        [<ffffffff8138f255>] __device_suspend+0xe5/0x200
> [   73.320888]        [<ffffffff8138fa1f>] async_suspend+0x1f/0xa0
> [   73.320892]        [<ffffffff81070762>] async_run_entry_fn+0x92/0x1c0
> [   73.320898]        [<ffffffff81060198>] process_one_work+0x208/0x750
> [   73.320903]        [<ffffffff81060ad0>] worker_thread+0x160/0x450
> [   73.320909]        [<ffffffff810676b2>] kthread+0xf2/0x100
> [   73.320915]        [<ffffffff814b9d5c>] ret_from_fork+0x7c/0xb0
> [   73.320917]
> [   73.320917] other info that might help us debug this:
> [   73.320917]
> [   73.320918]  Possible unsafe locking scenario:
> [   73.320918]
> [   73.320919]        CPU0                    CPU1
> [   73.320921]        ----                    ----
> [   73.320924]   lock(console_lock);
> [   73.320927]                                lock((fb_notifier_list).rwsem);
> [   73.320931]                                lock(console_lock);
> [   73.320934]   lock((fb_notifier_list).rwsem);
> [   73.320935]
> [   73.320935]  *** DEADLOCK ***
> [   73.320935]
> [   73.320937] 4 locks held by kworker/u:9/2574:
> [   73.320947]  #0:  (events_unbound){.+.+.+}, at: [<ffffffff81060127>] process_one_work+0x197/0x750
> [   73.320955]  #1:  ((&entry->work)){+.+.+.}, at: [<ffffffff81060127>] process_one_work+0x197/0x750
> [   73.320964]  #2:  (&__lockdep_no_validate__){......}, at: [<ffffffff8138f228>] __device_suspend+0xb8/0x200
> [   73.320974]  #3:  (console_lock){+.+.+.}, at: [<ffffffff81323c80>] i915_drm_freeze+0x90/0xe0
> [   73.320975]
> [   73.320975] stack backtrace:
> [   73.320979] Pid: 2574, comm: kworker/u:9 Tainted: G        W    3.8.0-rc4-wl-67484-g04fa847 #106
> [   73.320981] Call Trace:
> [   73.320990]  [<ffffffff814a8c8c>] print_circular_bug+0x1fc/0x20e
> [   73.320996]  [<ffffffff810a0c1e>] __lock_acquire+0x1aee/0x1be0
> [   73.321016]  [<ffffffff810a13e6>] lock_acquire+0x96/0x1e0
> [   73.321029]  [<ffffffff814af21e>] down_read+0x4e/0x98
> [   73.321041]  [<ffffffff8106f94a>] __blocking_notifier_call_chain+0x5a/0xd0
> [   73.321047]  [<ffffffff8106f9d6>] blocking_notifier_call_chain+0x16/0x20
> [   73.321053]  [<ffffffff8127ce6b>] fb_notifier_call_chain+0x1b/0x20
> [   73.321058]  [<ffffffff8127d5de>] fb_set_suspend+0x4e/0x60
> [   73.321063]  [<ffffffff81374e65>] intel_fbdev_set_suspend+0x25/0x30
> [   73.321069]  [<ffffffff81323c8d>] i915_drm_freeze+0x9d/0xe0
> [   73.321075]  [<ffffffff813242ea>] i915_pm_suspend+0x4a/0xa0
> [   73.321080]  [<ffffffff8126e2b4>] pci_pm_suspend+0x74/0x140
> [   73.321091]  [<ffffffff8138f12c>] dpm_run_callback.isra.3+0x3c/0x80
> [   73.321096]  [<ffffffff8138f255>] __device_suspend+0xe5/0x200
> [   73.321102]  [<ffffffff8138fa1f>] async_suspend+0x1f/0xa0
> [   73.321107]  [<ffffffff81070762>] async_run_entry_fn+0x92/0x1c0
> [   73.321113]  [<ffffffff81060198>] process_one_work+0x208/0x750
> [   73.321142]  [<ffffffff81060ad0>] worker_thread+0x160/0x450
> [   73.321153]  [<ffffffff810676b2>] kthread+0xf2/0x100
> [   73.321173]  [<ffffffff814b9d5c>] ret_from_fork+0x7c/0xb0
>
> johannes
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel



-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
