Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934760AbaGYRX0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 13:23:26 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:44594 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120AbaGYRXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 13:23:23 -0400
Message-ID: <53D29285.7090103@hp.com>
Date: Fri, 25 Jul 2014 13:23:17 -0400
From: Waiman Long <waiman.long@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130109 Thunderbird/10.0.12
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: Linux 3.16-rc6
References: <CA+55aFzJKxzw_as9iGgeM=MdQ6trUkQLDuoEr8nxj88sOqQnQA@mail.gmail.com> <20140723095327.GA23131@pd.tnic> <CA+55aFzPs4uF=eR7jCnpyBtgWNRkX-uDfXeo5u34VEvT8_yyzw@mail.gmail.com> <20140724064353.GW9918@twins.programming.kicks-ass.net> <20140724084126.GB19239@pd.tnic> <20140724122513.GM19239@pd.tnic> <20140724125814.GX6758@twins.programming.kicks-ass.net> <CA+55aFynW5xSRQvY6xO+mxmt6yh7mFkMjy-pgJXpXNy8qDMcPA@mail.gmail.com> <20140724183643.GM3935@laptop> <53D16EC4.1000801@hp.com> <20140724214549.GU19239@pd.tnic>
In-Reply-To: <20140724214549.GU19239@pd.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 05:45 PM, Borislav Petkov wrote:
> On Thu, Jul 24, 2014 at 04:38:28PM -0400, Waiman Long wrote:
>> Borislav, can you apply the following patch on top of the lockdep
>> patch to see if it can fix the problem?
> It is too late here for me to test anything but the ingridients to
> reproduce are nothing special. Just grab a kvm guest and pick out the
> locking or so options out of the .config I sent previously. Then boot it
> a couple of times, it triggers pretty easy after a couple of tries.
>

Thank for the reply.

I was not able to reproduce the read_lock lockdep problem that you see 
in your test machine. However, I saw the following lockdep warning on a 
mutex when I enabled CONFIG_PROVE_LOCKING=y and CONFIG_LOCKDEP=y. My 
virtual machine is based on RHEL 7 beta with xfs filesystem, and the 
error happens for both plain 3.16-rc6 and tip/master+3.16-rc6.


[    7.821723] ======================================================
[    7.821725] [ INFO: possible circular locking dependency detected ]
[    7.821727] 3.16.0-rc6 #4 Not tainted
[    7.821727] -------------------------------------------------------
[    7.821728] kworker/3:1/276 is trying to acquire lock:
[    7.821747]  (&qdev->release_mutex){+.+.+.}, at: [<ffffffffa0151a2c>] 
qxl_alloc_release_reserved+0x6c/0x200 [qxl]
[    7.821749]
[    7.821749] but task is already holding lock:
[    7.821763]  (&fbdefio->lock){+.+.+.}, at: [<ffffffff8135ea65>] 
fb_deferred_io_work+0x35/0xd0
[    7.821765]
[    7.821765] which lock already depends on the new lock.
[    7.821765]
[    7.821766]
[    7.821766] the existing dependency chain (in reverse order) is:
[    7.821770]
[    7.821770] -> #4 (&fbdefio->lock){+.+.+.}:
[    7.821781]        [<ffffffff810b2078>] __lock_acquire+0x3a8/0xc40
[    7.821785]        [<ffffffff810b29c0>] lock_acquire+0xb0/0x140
[    7.821793]        [<ffffffff81636add>] mutex_lock_nested+0x5d/0x4d0
[    7.821796]        [<ffffffff8135e866>] fb_deferred_io_mkwrite+0x46/0x120
[    7.821803]        [<ffffffff8118534d>] do_page_mkwrite+0x3d/0x70
[    7.821807]        [<ffffffff81188376>] 
do_shared_fault.isra.52+0x66/0x1d0
[    7.821811]        [<ffffffff81189524>] handle_mm_fault+0x474/0x1080
[    7.821819]        [<ffffffff81048ea1>] __do_page_fault+0x191/0x530
[    7.821822]        [<ffffffff810492f1>] trace_do_page_fault+0x41/0x100
[    7.821828]        [<ffffffff81043569>] do_async_page_fault+0x29/0xe0
[    7.821834]        [<ffffffff8163d608>] async_page_fault+0x28/0x30
[    7.821841]
[    7.821841] -> #3 (&mm->mmap_sem){++++++}:
[    7.821844]        [<ffffffff810b2078>] __lock_acquire+0x3a8/0xc40
[    7.821846]        [<ffffffff810b29c0>] lock_acquire+0xb0/0x140
[    7.821849]        [<ffffffff81185220>] might_fault+0x70/0xa0
[    7.821858]        [<ffffffff811e4ad1>] filldir+0x91/0x120
[    7.821904]        [<ffffffffa018253e>] 
xfs_dir2_block_getdents.isra.12+0x1ae/0x200 [xfs]
[    7.821916]        [<ffffffffa01826f9>] xfs_readdir+0x109/0x150 [xfs]
[    7.821928]        [<ffffffffa018436b>] xfs_file_readdir+0x2b/0x40 [xfs]
[    7.821931]        [<ffffffff811e48be>] iterate_dir+0xae/0x140
[    7.821933]        [<ffffffff811e4dba>] SyS_getdents+0x8a/0x120
[    7.821935]        [<ffffffff8163b6e9>] system_call_fastpath+0x16/0x1b
[    7.821937]
[    7.821937] -> #2 (&xfs_dir_ilock_class){++++.+}:
[    7.821940]        [<ffffffff810b2078>] __lock_acquire+0x3a8/0xc40
[    7.821942]        [<ffffffff810b29c0>] lock_acquire+0xb0/0x140
[    7.821945]        [<ffffffff810abd74>] down_read_nested+0x44/0x90
[    7.821965]        [<ffffffffa01c8d82>] xfs_ilock+0xd2/0x100 [xfs]
[    7.821982]        [<ffffffffa01c8e24>] 
xfs_ilock_attr_map_shared+0x34/0x40 [xfs]
[    7.821997]        [<ffffffffa019e5a7>] xfs_attr_get+0xb7/0x160 [xfs]
[    7.822013]        [<ffffffffa01986a7>] xfs_xattr_get+0x37/0x50 [xfs]
[    7.822013]        [<ffffffff811f6a7f>] generic_getxattr+0x4f/0x70
[    7.822013]        [<ffffffff8127ce60>] 
inode_doinit_with_dentry+0x150/0x640
[    7.822013]        [<ffffffff8127d428>] sb_finish_set_opts+0xd8/0x270
[    7.822013]        [<ffffffff8127d84f>] selinux_set_mnt_opts+0x28f/0x5e0
[    7.822013]        [<ffffffff8127dc08>] superblock_doinit+0x68/0xd0
[    7.822013]        [<ffffffff8127dc80>] delayed_superblock_init+0x10/0x20
[    7.822013]        [<ffffffff811d45c2>] iterate_supers+0xb2/0x110
[    7.822013]        [<ffffffff8127e713>] selinux_complete_init+0x33/0x40
[    7.822013]        [<ffffffff8128cea4>] security_load_policy+0xf4/0x600
[    7.822013]        [<ffffffff8128008c>] sel_write_load+0xac/0x750
[    7.822013]        [<ffffffff811d0b9a>] vfs_write+0xba/0x1f0
[    7.822013]        [<ffffffff811d1749>] SyS_write+0x49/0xb0
[    7.822013]        [<ffffffff8163b6e9>] system_call_fastpath+0x16/0x1b
[    7.822013]
[    7.822013] -> #1 (&isec->lock){+.+.+.}:
[    7.822013]        [<ffffffff810b2078>] __lock_acquire+0x3a8/0xc40
[    7.822013]        [<ffffffff810b29c0>] lock_acquire+0xb0/0x140
[    7.822013]        [<ffffffff81636add>] mutex_lock_nested+0x5d/0x4d0
[    7.822013]        [<ffffffff8127cdb5>] 
inode_doinit_with_dentry+0xa5/0x640
[    7.822013]        [<ffffffff8127defc>] selinux_d_instantiate+0x1c/0x20
[    7.822013]        [<ffffffff812732fb>] security_d_instantiate+0x1b/0x30
[    7.822013]        [<ffffffff811e8810>] d_instantiate+0x50/0x70
[    7.822013]        [<ffffffff811747f0>] __shmem_file_setup+0xe0/0x1d0
[    7.822013]        [<ffffffff811748f0>] shmem_file_setup+0x10/0x20
[    7.822013]        [<ffffffffa00d718b>] drm_gem_object_init+0x2b/0x40 
[drm]
[    7.822013]        [<ffffffffa014cfce>] qxl_bo_create+0x7e/0x1a0 [qxl]
[    7.822013]        [<ffffffffa0151b50>] 
qxl_alloc_release_reserved+0x190/0x200 [qxl]
[    7.822013]        [<ffffffffa014f6ec>] qxl_draw_opaque_fb+0x7c/0x390 
[qxl]
[    7.822013]        [<ffffffffa014bc8e>] 
qxl_fb_imageblit_internal+0x3e/0x40 [qxl]
[    7.822013]        [<ffffffffa014c17e>] qxl_fb_imageblit+0x6e/0x1a0 [qxl]
[    7.822013]        [<ffffffff813522a4>] soft_cursor+0x1b4/0x250
[    7.822013]        [<ffffffff81351b63>] bit_cursor+0x623/0x660
[    7.822013]        [<ffffffff8134df5b>] fbcon_cursor+0x13b/0x1c0
[    7.822013]        [<ffffffff813b5c98>] hide_cursor+0x28/0xa0
[    7.822013]        [<ffffffff813b77a8>] redraw_screen+0x168/0x240
[    7.822013]        [<ffffffff813b8181>] vc_do_resize+0x481/0x4b0
[    7.822013]        [<ffffffff813b81cf>] vc_resize+0x1f/0x30
[    7.822013]        [<ffffffff8134fb1c>] fbcon_init+0x35c/0x590
[    7.822013]        [<ffffffff813b5ef8>] visual_init+0xb8/0x120
[    7.822013]        [<ffffffff813b85a3>] do_bind_con_driver+0x163/0x330
[    7.822013]        [<ffffffff813b8d44>] do_take_over_console+0x114/0x1c0
[    7.822013]        [<ffffffff8134b3c3>] do_fbcon_takeover+0x63/0xd0
[    7.822013]        [<ffffffff813507a5>] fbcon_event_notify+0x6b5/0x800
[    7.822013]        [<ffffffff8108628c>] notifier_call_chain+0x4c/0x70
[    7.822013]        [<ffffffff81086553>] 
__blocking_notifier_call_chain+0x53/0x70
[    7.822013]        [<ffffffff81086586>] 
blocking_notifier_call_chain+0x16/0x20
[    7.822013]        [<ffffffff81356e0b>] fb_notifier_call_chain+0x1b/0x20
[    7.822013]        [<ffffffff8135905c>] register_framebuffer+0x1ec/0x330
[    7.822013]        [<ffffffffa013cb9e>] 
drm_fb_helper_initial_config+0x2fe/0x4b0 [drm_kms_helper]
[    7.822013]        [<ffffffffa014ccfb>] qxl_fbdev_init+0xab/0xd0 [qxl]
[    7.822013]        [<ffffffffa014aded>] qxl_modeset_init+0x1fd/0x240 
[qxl]
[    7.822013]        [<ffffffffa0148ca8>] qxl_driver_load+0x88/0xc0 [qxl]
[    7.822013]        [<ffffffffa00db90d>] drm_dev_register+0xad/0x100 [drm]
[    7.822013]        [<ffffffffa00de46f>] drm_get_pci_dev+0x8f/0x1f0 [drm]
[    7.822013]        [<ffffffffa01482ab>] qxl_pci_probe+0x1b/0x40 [qxl]
[    7.822013]        [<ffffffff8132ad65>] local_pci_probe+0x45/0xa0
[    7.822013]        [<ffffffff8132c031>] pci_device_probe+0xd1/0x130
[    7.822013]        [<ffffffff813e6f80>] driver_probe_device+0x90/0x3c0
[    7.822013]        [<ffffffff813e7383>] __driver_attach+0x93/0xa0
[    7.822013]        [<ffffffff813e4f2b>] bus_for_each_dev+0x6b/0xb0
[    7.822013]        [<ffffffff813e69ee>] driver_attach+0x1e/0x20
[    7.822013]        [<ffffffff813e65f8>] bus_add_driver+0x188/0x260
[    7.822013]        [<ffffffff813e7b54>] driver_register+0x64/0xf0
[    7.822013]        [<ffffffff8132a6f0>] __pci_register_driver+0x60/0x70
[    7.822013]        [<ffffffffa00de6da>] drm_pci_init+0x10a/0x140 [drm]
[    7.822013]        [<ffffffffa015b03e>] 
cdrom_dummy_generic_packet+0x3e/0x40 [cdrom]
[    7.822013]        [<ffffffff810002fc>] do_one_initcall+0xbc/0x200
[    7.822013]        [<ffffffff810e714d>] load_module+0x162d/0x1a90
[    7.822013]        [<ffffffff810e7746>] SyS_finit_module+0x86/0xb0
[    7.822013]        [<ffffffff8163b6e9>] system_call_fastpath+0x16/0x1b
[    7.822013]
[    7.822013] -> #0 (&qdev->release_mutex){+.+.+.}:
[    7.822013]        [<ffffffff810b030c>] 
validate_chain.isra.36+0x110c/0x11b0
[    7.822013]        [<ffffffff810b2078>] __lock_acquire+0x3a8/0xc40
[    7.822013]        [<ffffffff810b29c0>] lock_acquire+0xb0/0x140
[    7.822013]        [<ffffffff81636add>] mutex_lock_nested+0x5d/0x4d0
[    7.822013]        [<ffffffffa0151a2c>] 
qxl_alloc_release_reserved+0x6c/0x200 [qxl]
[    7.822013]        [<ffffffffa014f6ec>] qxl_draw_opaque_fb+0x7c/0x390 
[qxl]
[    7.822013]        [<ffffffffa014bdb1>] 
qxl_fb_dirty_flush+0x121/0x160 [qxl]
[    7.822013]        [<ffffffffa014be90>] qxl_deferred_io+0xa0/0xb0 [qxl]
[    7.822013]        [<ffffffff8135eaae>] fb_deferred_io_work+0x7e/0xd0
[    7.822013]        [<ffffffff8107a0b5>] process_one_work+0x1f5/0x510
[    7.822013]        [<ffffffff8107ab4d>] worker_thread+0x11d/0x520
[    7.822013]        [<ffffffff81081760>] kthread+0xf0/0x110
[    7.822013]        [<ffffffff8163b63c>] ret_from_fork+0x7c/0xb0
[    7.822013]
[    7.822013] other info that might help us debug this:
[    7.822013]
[    7.822013] Chain exists of:
[    7.822013] &qdev->release_mutex --> &mm->mmap_sem --> &fbdefio->lock
[    7.822013]
[    7.822013]  Possible unsafe locking scenario:
[    7.822013]
[    7.822013]        CPU0                    CPU1
[    7.822013]        ----                    ----
[    7.822013]   lock(&fbdefio->lock);
[    7.822013]                                lock(&mm->mmap_sem);
[    7.822013]                                lock(&fbdefio->lock);
[    7.822013]   lock(&qdev->release_mutex);
[    7.822013]
[    7.822013]  *** DEADLOCK ***
[    7.822013]
[    7.822013] 3 locks held by kworker/3:1/276:
[    7.822013]  #0:  ("events"){.+.+.+}, at: [<ffffffff8107a053>] 
process_one_work+0x193/0x510
[    7.822013]  #1:  ((&(&info->deferred_work)->work)){+.+.+.}, at: 
[<ffffffff8107a053>] process_one_work+0x193/0x510
[    7.822013]  #2:  (&fbdefio->lock){+.+.+.}, at: [<ffffffff8135ea65>] 
fb_deferred_io_work+0x35/0xd0
[    7.822013]
[    7.822013] stack backtrace:
[    7.822013] CPU: 3 PID: 276 Comm: kworker/3:1 Not tainted 3.16.0-rc6 #4
[    7.822013] Hardware name: Red Hat KVM, BIOS Bochs 01/01/2011
[    7.822013] Workqueue: events fb_deferred_io_work
[    7.822013]  ffffffff8268aa90 ffff8807df2ff8e8 ffffffff8163182a 
ffffffff826ba5f0
[    7.822013]  ffff8807df2ff928 ffffffff8162b0d5 ffff8807df2ff960 
ffff8807df2ddb50
[    7.822013]  ffff8807df2ddb50 0000000000000002 ffff8807df2dcec0 
0000000000000003
[    7.822013] Call Trace:
[    7.822013]  [<ffffffff8163182a>] dump_stack+0x45/0x56
[    7.822013]  [<ffffffff8162b0d5>] print_circular_bug+0x1f9/0x207
[    7.822013]  [<ffffffff810b030c>] validate_chain.isra.36+0x110c/0x11b0
[    7.822013]  [<ffffffff810ad89b>] ? 
add_lock_to_list.isra.22.constprop.43+0x7b/0xf0
[    7.822013]  [<ffffffff8100c1b9>] ? sched_clock+0x9/0x10
[    7.822013]  [<ffffffff810b2078>] __lock_acquire+0x3a8/0xc40
[    7.822013]  [<ffffffff810b29c0>] lock_acquire+0xb0/0x140
[    7.822013]  [<ffffffffa0151a2c>] ? 
qxl_alloc_release_reserved+0x6c/0x200 [qxl]
[    7.822013]  [<ffffffff81636add>] mutex_lock_nested+0x5d/0x4d0
[    7.822013]  [<ffffffffa0151a2c>] ? 
qxl_alloc_release_reserved+0x6c/0x200 [qxl]
[    7.822013]  [<ffffffffa0151a2c>] ? 
qxl_alloc_release_reserved+0x6c/0x200 [qxl]
[    7.822013]  [<ffffffff8163a957>] ? _raw_spin_unlock+0x27/0x30
[    7.822013]  [<ffffffffa0151598>] ? qxl_release_alloc+0x98/0x100 [qxl]
[    7.822013]  [<ffffffffa0151a2c>] 
qxl_alloc_release_reserved+0x6c/0x200 [qxl]
[    7.822013]  [<ffffffffa014f6ec>] qxl_draw_opaque_fb+0x7c/0x390 [qxl]
[    7.822013]  [<ffffffffa014e3e3>] ? qxl_io_log+0x63/0x70 [qxl]
[    7.822013]  [<ffffffffa014bdb1>] qxl_fb_dirty_flush+0x121/0x160 [qxl]
[    7.822013]  [<ffffffffa014be90>] qxl_deferred_io+0xa0/0xb0 [qxl]
[    7.822013]  [<ffffffff8135eaae>] fb_deferred_io_work+0x7e/0xd0
[    7.822013]  [<ffffffff8107a0b5>] process_one_work+0x1f5/0x510
[    7.822013]  [<ffffffff8107a053>] ? process_one_work+0x193/0x510
[    7.822013]  [<ffffffff8107ab4d>] worker_thread+0x11d/0x520
[    7.822013]  [<ffffffff8107aa30>] ? create_and_start_worker+0x60/0x60
[    7.822013]  [<ffffffff81081760>] kthread+0xf0/0x110
[    7.822013]  [<ffffffff81081670>] ? kthread_create_on_node+0x220/0x220
[    7.822013]  [<ffffffff8163b63c>] ret_from_fork+0x7c/0xb0
[    7.822013]  [<ffffffff81081670>] ? kthread_create_on_node+0x220/0x220
[    7.988039] hardirqs last  enabled at (361): [<ffffffff81048f85>] 
__do_page_fault+0x275/0x530
[    7.988039] hardirqs last disabled at (360): [<ffffffff8163d826>] 
error_sti+0x5/0x6
[    7.988039] softirqs last  enabled at (0): [<ffffffff8105ad8b>] 
copy_process.part.22+0x66b/0x1d40
[    7.988039] softirqs last disabled at (0): [<          
(null)>]           (null)


