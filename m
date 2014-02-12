Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaBLPlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 10:41:03 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:33189 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaBLPlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 10:41:00 -0500
X-AuditID: cbfec7f4-b7f796d000005a13-00-52fb960a3414
Message-id: <52FB9602.1000805@samsung.com>
Date: Wed, 12 Feb 2014 16:40:50 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [BUG] Circular locking dependency - DRM/CMA/MM/hotplug/...
References: <20140211183543.GK26684@n2100.arm.linux.org.uk>
In-reply-to: <20140211183543.GK26684@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrGLMWRmVeSWpSXmKPExsVy+t/xK7pc034HGTTdYLfoPXeSyeLK1/ds
	FpseX2O1uLxrDpvF7cu8DqweLc09bB7bvz1g9bjffZzJY/OSeo/Pm+QCWKO4bFJSczLLUov0
	7RK4MtZ8fsdc0OpZMevXLKYGxmdWXYycHBICJhJPbj5nhLDFJC7cW8/WxcjFISSwlFFi54xF
	UM4nRom73U+YQKp4BbQkZvSdAbNZBFQl9s/8xQ5iswkYSnS97QJq4OAQFQiVmDdXD6JcUOLH
	5HssIHNEBPYzSnybsgasXljAXWLCi+lsILaQgLXEu6ZVYHFOARuJq/O6weYzC5hJPGpZxwxh
	y0tsXvOWeQIj/ywkc2chKZuFpGwBI/MqRtHU0uSC4qT0XEO94sTc4tK8dL3k/NxNjJCw/bKD
	cfExq0OMAhyMSjy8DJ6/goRYE8uKK3MPMUpwMCuJ8Bo1/w4S4k1JrKxKLcqPLyrNSS0+xMjE
	wSnVwFh02f/95rAIQbOEd5rb7i39Gqf6YOXUW9vL9Ir8hU/bxHx74uTIZXpug/kUQ7kr9gvk
	bzPaB/bMUny6p/WPQqTcnOmXhFQ+3v7hlNh8wLib1+nOgY8Lr//2ucNQ3q63kVM1fbJ/UBHD
	S72LTYePcwklZ+3tiRUouPL6/q4PJf/bkhep1rOWvVViKc5INNRiLipOBAC2bBujOQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-02-11 19:35, Russell King - ARM Linux wrote:
> The cubox-i4 just hit a new lockdep problem - not quite sure what to
> make of this - it looks like an interaction between quite a lot of
> locks - I suspect more than the lockdep code is reporting in its
> "Possible unsafe locking scenario" report.
>
> I'm hoping I've sent this to appropriate people...  if anyone thinks
> this needs to go to someone else, please forward it.  Thanks.

 From the attached log it looks like an issue (AB-BA deadlock) between
device mutex (&dev->struct_mutex) and mm semaphore (&mm->mmap_sem).
Similar issue has been discussed quite a long time ago in v4l2
subsystem:

https://www.mail-archive.com/linux-media@vger.kernel.org/msg38599.html
http://www.spinics.net/lists/linux-media/msg40225.html

Solving it probably requires some changes in DRM core. I see no direct
relation between this issue and CMA itself.

> ======================================================
> [ INFO: possible circular locking dependency detected ]
> 3.14.0-rc2+ #517 Tainted: G        W
> -------------------------------------------------------
> Xorg/805 is trying to acquire lock:
>   (cma_mutex){+.+.+.}, at: [<c03716f4>] dma_release_from_contiguous+0xb8/0xf8
>
> but task is already holding lock:
>   (&dev->struct_mutex){+.+...}, at: [<c03512ec>] drm_gem_object_handle_unreference_unlocked+0xdc/0x148
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
> -> #5 (&dev->struct_mutex){+.+...}:
>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
>         [<c0067c28>] lock_acquire+0xa0/0x130
>         [<c0698180>] mutex_lock_nested+0x5c/0x3ac
>         [<c0350c30>] drm_gem_mmap+0x40/0xdc
>         [<c03671d8>] drm_gem_cma_mmap+0x14/0x2c
>         [<c00ef4f4>] mmap_region+0x3ac/0x59c
>         [<c00ef9ac>] do_mmap_pgoff+0x2c8/0x370
>         [<c00dd730>] vm_mmap_pgoff+0x6c/0x9c
>         [<c00ee1fc>] SyS_mmap_pgoff+0x54/0x98
>         [<c000e6e0>] ret_fast_syscall+0x0/0x48
> -> #4 (&mm->mmap_sem){++++++}:
>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
>         [<c0067c28>] lock_acquire+0xa0/0x130
>         [<c00e6c5c>] might_fault+0x6c/0x94
>         [<c0335440>] con_set_unimap+0x158/0x27c
>         [<c032f800>] vt_ioctl+0x1298/0x1388
>         [<c0323f44>] tty_ioctl+0x168/0xbf4
>         [<c0115fac>] do_vfs_ioctl+0x84/0x664
>         [<c01165d0>] SyS_ioctl+0x44/0x64
>         [<c000e6e0>] ret_fast_syscall+0x0/0x48
> -> #3 (console_lock){+.+.+.}:
>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
>         [<c0067c28>] lock_acquire+0xa0/0x130
>         [<c006edcc>] console_lock+0x60/0x74
>         [<c006f7b8>] console_cpu_notify+0x28/0x34
>         [<c004904c>] notifier_call_chain+0x4c/0x8c
>         [<c004916c>] __raw_notifier_call_chain+0x1c/0x24
>         [<c0024124>] __cpu_notify+0x34/0x50
>         [<c002424c>] cpu_notify_nofail+0x18/0x24
>         [<c068e168>] _cpu_down+0x100/0x244
>         [<c068e2dc>] cpu_down+0x30/0x44
>         [<c036ef8c>] cpu_subsys_offline+0x14/0x18
>         [<c036af28>] device_offline+0x94/0xbc
>         [<c036b030>] online_store+0x4c/0x74
>         [<c0368d3c>] dev_attr_store+0x20/0x2c
>         [<c016b2e0>] sysfs_kf_write+0x54/0x58
>         [<c016eaa4>] kernfs_fop_write+0xc4/0x160
>         [<c0105a54>] vfs_write+0xbc/0x184
>         [<c0105dfc>] SyS_write+0x48/0x70
>         [<c000e6e0>] ret_fast_syscall+0x0/0x48
> -> #2 (cpu_hotplug.lock){+.+.+.}:
>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
>         [<c0067c28>] lock_acquire+0xa0/0x130
>         [<c0698180>] mutex_lock_nested+0x5c/0x3ac
>         [<c0024218>] get_online_cpus+0x3c/0x58
>         [<c00d0ab0>] lru_add_drain_all+0x24/0x190
>         [<c0101d3c>] migrate_prep+0x10/0x18
>         [<c00cba04>] alloc_contig_range+0xf4/0x30c
>         [<c0371588>] dma_alloc_from_contiguous+0x7c/0x130
>         [<c0018ef8>] __alloc_from_contiguous+0x38/0x12c
>         [<c0908694>] atomic_pool_init+0x74/0x128
>         [<c0008850>] do_one_initcall+0x3c/0x164
>         [<c0903c98>] kernel_init_freeable+0x104/0x1d0
>         [<c068de54>] kernel_init+0x10/0xec
>         [<c000e7a8>] ret_from_fork+0x14/0x2c
> -> #1 (lock){+.+...}:
>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
>         [<c0067c28>] lock_acquire+0xa0/0x130
>         [<c0698180>] mutex_lock_nested+0x5c/0x3ac
>         [<c00d0aa8>] lru_add_drain_all+0x1c/0x190
>         [<c0101d3c>] migrate_prep+0x10/0x18
>         [<c00cba04>] alloc_contig_range+0xf4/0x30c
>         [<c0371588>] dma_alloc_from_contiguous+0x7c/0x130
>         [<c0018ef8>] __alloc_from_contiguous+0x38/0x12c
>         [<c0908694>] atomic_pool_init+0x74/0x128
>         [<c0008850>] do_one_initcall+0x3c/0x164
>         [<c0903c98>] kernel_init_freeable+0x104/0x1d0
>         [<c068de54>] kernel_init+0x10/0xec
>         [<c000e7a8>] ret_from_fork+0x14/0x2c
> -> #0 (cma_mutex){+.+.+.}:
>         [<c0690850>] print_circular_bug+0x70/0x2f0
>         [<c0066f68>] __lock_acquire+0x1580/0x1ca0
>         [<c0067c28>] lock_acquire+0xa0/0x130
>         [<c0698180>] mutex_lock_nested+0x5c/0x3ac
>         [<c03716f4>] dma_release_from_contiguous+0xb8/0xf8
>         [<c00197a4>] __arm_dma_free.isra.11+0x194/0x218
>         [<c0019868>] arm_dma_free+0x1c/0x24
>         [<c0366e34>] drm_gem_cma_free_object+0x68/0xb8
>         [<c0351194>] drm_gem_object_free+0x30/0x38
>         [<c0351318>] drm_gem_object_handle_unreference_unlocked+0x108/0x148
>         [<c0351498>] drm_gem_handle_delete+0xb0/0x10c
>         [<c0351508>] drm_gem_dumb_destroy+0x14/0x18
>         [<c035e838>] drm_mode_destroy_dumb_ioctl+0x34/0x40
>         [<c034f918>] drm_ioctl+0x3f4/0x498
>         [<c0115fac>] do_vfs_ioctl+0x84/0x664
>         [<c01165d0>] SyS_ioctl+0x44/0x64
>         [<c000e6e0>] ret_fast_syscall+0x0/0x48
>
> other info that might help us debug this:
>
> Chain exists of: cma_mutex --> &mm->mmap_sem --> &dev->struct_mutex
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    lock(&dev->struct_mutex);
>                                 lock(&mm->mmap_sem);
>                                 lock(&dev->struct_mutex);
>    lock(cma_mutex);
>
>   *** DEADLOCK ***
>
> 1 lock held by Xorg/805:
>   #0:  (&dev->struct_mutex){+.+...}, at: [<c03512ec>] drm_gem_object_handle_unreference_unlocked+0xdc/0x148
>
> stack backtrace:
> CPU: 0 PID: 805 Comm: Xorg Tainted: G        W    3.14.0-rc2+ #517
> Backtrace:
> [<c00124e0>] (dump_backtrace) from [<c0012680>] (show_stack+0x18/0x1c)
>   r6:c0a869f0 r5:c0a8d540 r4:00000000 r3:00000000
> [<c0012668>] (show_stack) from [<c0693310>] (dump_stack+0x70/0x8c)
> [<c06932a0>] (dump_stack) from [<c0690a7c>] (print_circular_bug+0x29c/0x2f0)
>   r4:c0a79570 r3:e9338980
> [<c06907e0>] (print_circular_bug) from [<c0066f68>] (__lock_acquire+0x1580/0x1ca0)
>   r10:c0a6da70 r8:e9338dc8 r7:c10ed83c r6:00000001 r5:e9338db0 r4:e9338980
> [<c00659e8>] (__lock_acquire) from [<c0067c28>] (lock_acquire+0xa0/0x130)
>   r10:00000000 r9:00000002 r8:00000000 r7:00000000 r6:c099e3b0 r5:e8ca2000
>   r4:00000000
> [<c0067b88>] (lock_acquire) from [<c0698180>] (mutex_lock_nested+0x5c/0x3ac)
>   r10:e9338980 r9:ea16d010 r8:e8ca2000 r7:00000000 r6:c0ebe304 r5:c03716f4
>   r4:c099e378
> [<c0698124>] (mutex_lock_nested) from [<c03716f4>] (dma_release_from_contiguous+0xb8/0xf8)
>   r10:ebb00000 r9:ea16d010 r8:c0979cc8 r7:0002bb00 r6:000003fc r5:0003bb00
>   r4:c10f4a78
> [<c037163c>] (dma_release_from_contiguous) from [<c00197a4>] (__arm_dma_free.isra.11+0x194/0x218)
>   r6:003fc000 r5:ea7d8000 r4:ead4e000 r3:c001db4c
> [<c0019610>] (__arm_dma_free.isra.11) from [<c0019868>] (arm_dma_free+0x1c/0x24)
>   r10:e9902e20 r9:e8ca3e38 r8:e989e000 r7:e9902e58 r6:e9902f10 r5:e989e030
>   r4:e9aad540
> [<c001984c>] (arm_dma_free) from [<c0366e34>] (drm_gem_cma_free_object+0x68/0xb8)
> [<c0366dcc>] (drm_gem_cma_free_object) from [<c0351194>] (drm_gem_object_free+0x30/0x38)
>   r4:e9aad540
> [<c0351164>] (drm_gem_object_free) from [<c0351318>] (drm_gem_object_handle_unreference_unlocked+0x108/0x148)
> [<c0351210>] (drm_gem_object_handle_unreference_unlocked) from [<c0351498>] (drm_gem_handle_delete+0xb0/0x10c)
>   r5:e9aad540 r4:e9902e00
> [<c03513e8>] (drm_gem_handle_delete) from [<c0351508>] (drm_gem_dumb_destroy+0x14/0x18)
>   r10:c06e3448 r8:e8ca3e38 r7:e8ca2000 r6:e9902e00 r5:000000b4 r4:e8ca3e38
> [<c03514f4>] (drm_gem_dumb_destroy) from [<c035e838>] (drm_mode_destroy_dumb_ioctl+0x34/0x40)
> [<c035e804>] (drm_mode_destroy_dumb_ioctl) from [<c034f918>] (drm_ioctl+0x3f4/0x498)
>   r4:e989e000 r3:c035e804
> [<c034f524>] (drm_ioctl) from [<c0115fac>] (do_vfs_ioctl+0x84/0x664)
>   r10:00000000 r9:e8ca2000 r8:beeb6bb4 r7:e9824560 r6:c01165d0 r5:00000006
>   r4:e9b97300
> [<c0115f28>] (do_vfs_ioctl) from [<c01165d0>] (SyS_ioctl+0x44/0x64)
>   r10:00000000 r9:e8ca2000 r8:00000006 r7:c00464b4 r6:beeb6bb4 r5:e9b97300
>   r4:00000000
> [<c011658c>] (SyS_ioctl) from [<c000e6e0>] (ret_fast_syscall+0x0/0x48)
>   r8:c000e8a4 r7:00000036 r6:00000006 r5:c00464b4 r4:beeb6bb4
>

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

