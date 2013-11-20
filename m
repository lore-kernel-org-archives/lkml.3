Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab3KTXBQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 18:01:16 -0500
Received: from mail-ee0-f48.google.com ([74.125.83.48]:51565 "EHLO
	mail-ee0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab3KTXBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 18:01:14 -0500
Message-ID: <528D3F36.3050403@suse.cz>
Date: Thu, 21 Nov 2013 00:01:10 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: alexander.h.duyck@intel.com
CC: yinghai@kernel.org, alexander.h.duyck@intel.com,
        Bjorn Helgaas <bhelgaas@google.com>, Tejun Heo <tj@kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: [next] ton of "scheduling while atomic"
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm unable to boot my virtual machine since commit:
commit 961da7fb6b220d4ae7ec8cc8feb860f269a177e5
Author: Alexander Duyck <alexander.h.duyck@intel.com>
Date:   Mon Nov 18 10:59:59 2013 -0700

    PCI: Avoid unnecessary CPU switch when calling driver .probe() method

A revert of that patch helps.

This is because I receive a ton of (preempt_disable for .probe seems not
to be a good idea at all):
BUG: scheduling while atomic: swapper/0/1/0x00000002
3 locks held by swapper/0/1:
 #0:  (&__lockdep_no_validate__){......}, at: [<ffffffff814000b3>]
__driver_attach+0x53/0xb0
 #1:  (&__lockdep_no_validate__){......}, at: [<ffffffff814000c1>]
__driver_attach+0x61/0xb0
 #2:  (drm_global_mutex){+.+.+.}, at: [<ffffffff8135d981>]
drm_dev_register+0x21/0x1f0
Modules linked in:
CPU: 1 PID: 1 Comm: swapper/0 Tainted: G        W
3.12.0-next-20131120+ #4
Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
 ffff88002f512780 ffff88002dcc77d8 ffffffff816a90d4 0000000000000006
 ffff88002dcc8000 ffff88002dcc77f8 ffffffff816a5879 0000000000000006
 ffff88002dcc79d0 ffff88002dcc7868 ffffffff816adf5c ffff88002dcc8000
Call Trace:
 [<ffffffff816a90d4>] dump_stack+0x4e/0x71
 [<ffffffff816a5879>] __schedule_bug+0x5c/0x6c
 [<ffffffff816adf5c>] __schedule+0x7bc/0x820
 [<ffffffff816ae084>] schedule+0x24/0x70
 [<ffffffff816ad23d>] schedule_timeout+0x1bd/0x260
 [<ffffffff810cb33e>] ? mark_held_locks+0xae/0x140
 [<ffffffff816b344b>] ? _raw_spin_unlock_irq+0x2b/0x50
 [<ffffffff810cb4d5>] ? trace_hardirqs_on_caller+0x105/0x1d0
 [<ffffffff816aedf7>] wait_for_completion+0xa7/0x110
 [<ffffffff810b2da0>] ? try_to_wake_up+0x330/0x330
 [<ffffffff81404aab>] devtmpfs_create_node+0x11b/0x150
 [<ffffffff813fd0c6>] device_add+0x1f6/0x5b0
 [<ffffffff8140bec6>] ? pm_runtime_init+0x106/0x110
 [<ffffffff813fd499>] device_register+0x19/0x20
 [<ffffffff813fd58b>] device_create_groups_vargs+0xeb/0x110
 [<ffffffff813fd5f7>] device_create_vargs+0x17/0x20
 [<ffffffff813fd62c>] device_create+0x2c/0x30
 [<ffffffff8135d811>] ? drm_get_minor+0xc1/0x210
 [<ffffffff81168bd4>] ? kmem_cache_alloc+0xf4/0x100
 [<ffffffff813611a8>] drm_sysfs_device_add+0x58/0x90
 [<ffffffff8135d8d8>] drm_get_minor+0x188/0x210
 [<ffffffff8135dabc>] drm_dev_register+0x15c/0x1f0
 [<ffffffff8135fb68>] drm_get_pci_dev+0x98/0x150
 [<ffffffff813f8930>] cirrus_pci_probe+0xa0/0xd0
 [<ffffffff812b34f4>] pci_device_probe+0xa4/0x120
 [<ffffffff813ffe86>] driver_probe_device+0x76/0x250
 [<ffffffff81400103>] __driver_attach+0xa3/0xb0
 [<ffffffff81400060>] ? driver_probe_device+0x250/0x250
 [<ffffffff813fe10d>] bus_for_each_dev+0x5d/0xa0
 [<ffffffff813ff9a9>] driver_attach+0x19/0x20
 [<ffffffff813ff5af>] bus_add_driver+0x10f/0x210
 [<ffffffff81cc4355>] ? intel_no_opregion_vbt_callback+0x30/0x30
 [<ffffffff814007af>] driver_register+0x5f/0x100
 [<ffffffff81cc4355>] ? intel_no_opregion_vbt_callback+0x30/0x30
 [<ffffffff812b239f>] __pci_register_driver+0x5f/0x70
 [<ffffffff8135fd35>] drm_pci_init+0x115/0x130
 [<ffffffff81cc4355>] ? intel_no_opregion_vbt_callback+0x30/0x30
 [<ffffffff81cc4387>] cirrus_init+0x32/0x3b
 [<ffffffff8100032a>] do_one_initcall+0xfa/0x140
 [<ffffffff81c9efed>] kernel_init_freeable+0x1a5/0x23a
 [<ffffffff81c9e812>] ? do_early_param+0x8c/0x8c
 [<ffffffff816a0fc0>] ? rest_init+0xd0/0xd0
 [<ffffffff816a0fc9>] kernel_init+0x9/0x120
 [<ffffffff816b423c>] ret_from_fork+0x7c/0xb0
 [<ffffffff816a0fc0>] ? rest_init+0xd0/0xd0

thanks,
-- 
js
suse labs
