Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304AbaAVOBu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 09:01:50 -0500
Received: from cantor2.suse.de ([195.135.220.15]:36463 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755209AbaAVOBp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 09:01:45 -0500
Date: Wed, 22 Jan 2014 15:01:38 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org
Subject: kernfs: lockdep complains about kernfs_addrm_ctx
Message-ID: <alpine.LNX.2.00.1401221456080.27143@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

booting with current Linus' tree (df32e43a5) gives me this:

 INFO: trying to register non-static key.
 the code is fine but needs lockdep annotation.
 turning off the locking correctness validator.
 CPU: 1 PID: 105 Comm: udevd Not tainted 3.13.0-03477-gdf32e43 #1
 Hardware name: LENOVO 7470BN2/7470BN2, BIOS 6DET38WW (2.02 ) 12/19/2008
  0000000000000000 ffff880037ad3468 ffffffff8159701b ffff880037ad34e8
  ffffffff8109e317 0000000000000000 ffff880037ad4fd0 ffff880037ad34e8
  0000000000000000 ffff880037ad34b8 ffffffff00000000 0000000000000002
 Call Trace:
  [<ffffffff8159701b>] dump_stack+0x72/0x87
  [<ffffffff8109e317>] register_lock_class+0x497/0x4c0
  [<ffffffff810a1c2d>] __lock_acquire+0x7d/0x600
  [<ffffffff810a0cdd>] ? trace_hardirqs_on_caller+0x13d/0x1e0
  [<ffffffff810a22a1>] lock_acquire+0xf1/0x120
  [<ffffffff81215460>] ? kernfs_addrm_finish+0x30/0x50
  [<ffffffff81214cf9>] kernfs_deactivate+0xe9/0x130
  [<ffffffff81215460>] ? kernfs_addrm_finish+0x30/0x50
  [<ffffffff81215460>] kernfs_addrm_finish+0x30/0x50
  [<ffffffff812154d8>] kernfs_remove_by_name_ns+0x58/0xb0
  [<ffffffff810a0d8d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff81213081>] remove_files+0x41/0x80
  [<ffffffff81213106>] sysfs_remove_group+0x46/0xb0
  [<ffffffff812131a3>] sysfs_remove_groups+0x33/0x50
  [<ffffffff813e3fe3>] device_remove_attrs+0x63/0x90
  [<ffffffff813e413e>] device_del+0x12e/0x1f0
  [<ffffffff813e421d>] device_unregister+0x1d/0x60
  [<ffffffff81472d0a>] i2c_del_adapter+0x1ea/0x2b0
  [<ffffffffa01e2ff9>] intel_sdvo_init+0x1f9/0x6b0 [i915]
  [<ffffffff810a0cdd>] ? trace_hardirqs_on_caller+0x13d/0x1e0
  [<ffffffff810a0d8d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffffa0202dad>] ? gen4_read32+0x4d/0xd0 [i915]
  [<ffffffffa01c8550>] intel_setup_outputs+0x630/0x7a0 [i915]
  [<ffffffffa01cb490>] intel_modeset_init+0x380/0x480 [i915]
  [<ffffffffa01881d2>] i915_load_modeset_init+0xb2/0x230 [i915]
  [<ffffffffa018a410>] i915_driver_load+0x6b0/0x9a0 [i915]
  [<ffffffffa014418a>] drm_dev_register+0xba/0x210 [drm]
  [<ffffffffa014661d>] drm_get_pci_dev+0x9d/0x140 [drm]
  [<ffffffffa018662c>] i915_pci_probe+0x3c/0x80 [i915]
  [<ffffffff81326419>] local_pci_probe+0x49/0xa0
  [<ffffffff81326539>] __pci_device_probe+0xc9/0xf0
  [<ffffffff813e2ab4>] ? get_device+0x14/0x20
  [<ffffffff813267b6>] pci_device_probe+0x36/0x60
  [<ffffffff813e7329>] really_probe+0x79/0x350
  [<ffffffff813e7654>] driver_probe_device+0x54/0xb0
  [<ffffffff813e774b>] __driver_attach+0x9b/0xa0
  [<ffffffff813e76b0>] ? driver_probe_device+0xb0/0xb0
  [<ffffffff813e548b>] bus_for_each_dev+0x8b/0xb0
  [<ffffffff813e6fdc>] driver_attach+0x1c/0x20
  [<ffffffff813e6977>] bus_add_driver+0x137/0x250
  [<ffffffff813e7c88>] driver_register+0x58/0x110
  [<ffffffff813268c2>] __pci_register_driver+0x62/0x70
  [<ffffffffa01467cc>] drm_pci_init+0x10c/0x120 [drm]
  [<ffffffffa00bb000>] ? 0xffffffffa00bafff
  [<ffffffffa00bb05d>] i915_init+0x5d/0x6b [i915]
  [<ffffffff81000302>] do_one_initcall+0x132/0x190
  [<ffffffff810438e3>] ? set_memory_nx+0x43/0x50
  [<ffffffff810d2ded>] ? set_section_ro_nx+0x7d/0x80
  [<ffffffff810d323b>] do_init_module+0x7b/0x200
  [<ffffffff810d5585>] load_module+0x595/0x5e0
  [<ffffffff810d33c0>] ? do_init_module+0x200/0x200
  [<ffffffff810d577b>] SyS_init_module+0x9b/0xc0
  [<ffffffff815a5222>] system_call_fastpath+0x16/0x1b

I have started to look into the kernfs code now to debug this, but as I 
haven't been following it closely during the review phase, it might take 
some time before I familiarize myself with it; hence sending this as a 
heads-up.

-- 
Jiri Kosina
SUSE Labs
