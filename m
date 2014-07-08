Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647AbaGHMzW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 08:55:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28966 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754250AbaGHMzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 08:55:19 -0400
Message-ID: <53BBEA2E.60905@redhat.com>
Date: Tue, 08 Jul 2014 14:55:10 +0200
From: Maurizio Lombardi <mlombard@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Aaron Lu <aaron.lu@intel.com>
CC: Jens Axboe <axboe@fb.com>, Ming Lei <ming.lei@canonical.com>,
        Jet Chen <jet.chen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        lkp@01.org
Subject: Re: [Merge branch 'for] BUG: unable to handle kernel NULL pointer
 dereference at 0000000000000028
References: <53bbad38.bUEV+/Tm2WTBCfJH%fengguang.wu@intel.com> <53BBB30F.7020304@intel.com>
In-Reply-To: <53BBB30F.7020304@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/08/2014 10:59 AM, Aaron Lu wrote:
> 
> [ 1010.593031]  sda: unknown partition table
> [ 1010.598052] sd 2:0:0:0: [sda] Attached SCSI disk
> [ 1012.893125] sd 2:0:0:0: [sda] Synchronizing SCSI cache
> [ 1012.895934] BUG: unable to handle kernel NULL pointer dereference at 0000000000000028
> [ 1012.896336] IP: [<ffffffff813cf880>] blk_throtl_drain+0x30/0x150

Looks like it is crashing here:

void blk_throtl_drain(struct request_queue *q)
        __releases(q->queue_lock) __acquires(q->queue_lock)
{
        struct throtl_data *td = q->td;
        struct blkcg_gq *blkg;
        struct cgroup_subsys_state *pos_css;
        struct bio *bio;
        int rw;

        queue_lockdep_assert_held(q);
        rcu_read_lock();

        /*
         * Drain each tg while doing post-order walk on the blkg tree, so
         * that all bios are propagated to td->service_queue.  It'd be
         * better to walk service_queue tree directly but blkg walk is
         * easier.
         */
        blkg_for_each_descendant_post(blkg, pos_css, td->queue->root_blkg)   <--------------
                tg_drain_bios(&blkg_to_tg(blkg)->service_queue);

#define blkg_for_each_descendant_post(d_blkg, pos_css, p_blkg)          \
        css_for_each_descendant_post((pos_css), &(p_blkg)->blkcg->css)  \    <--------------
                if (((d_blkg) = __blkg_lookup(css_to_blkcg(pos_css),    \
                                              (p_blkg)->q, false)))

The code tries to access to the blkcg pointer (offset 0x0028 of the blkcg_gq structure);
so the root_blkg pointer is NULL, hence the kernel panic.

So, IMO, what happens is that the root_blkg pointer is set to NULL by the blkg_destroy_all() function well before
we reach the blk_throtl_drain() function.

void blkcg_exit_queue(struct request_queue *q)
{
        spin_lock_irq(q->queue_lock);
        blkg_destroy_all(q);      <---- This is the point where the root_blkg pointer is destroyed (if I understand the code correctly)
        spin_unlock_irq(q->queue_lock);

        blk_throtl_exit(q);       <---- This is the function which will execute blk_throtl_drain()
}

Jens, Ming, do you have any idea?

Regards,
Maurizio Lombardi


> [ 1012.896336] PGD 0 
> [ 1012.896336] Oops: 0000 [#1] SMP 
> [ 1012.896336] Modules linked in: sd_mod scsi_debug(-) crct10dif_generic crc_t10dif crct10dif_common loop ipmi_watchdog ipmi_msghandler dm_mod fuse sg sr_mod cdrom ata_generic pata_acpi parport_pc parport floppy snd_pcm snd_timer snd cirrus ata_piix soundcore syscopyarea pcspkr sysfillrect sysimgblt ttm drm_kms_helper libata drm i2c_piix4
> [ 1012.896336] CPU: 1 PID: 8020 Comm: rmmod Not tainted 3.16.0-rc3-01927-ge376abf #1
> [ 1012.896336] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [ 1012.896336] task: ffff8801151a0000 ti: ffff880079668000 task.ti: ffff880079668000
> [ 1012.896336] RIP: 0010:[<ffffffff813cf880>]  [<ffffffff813cf880>] blk_throtl_drain+0x30/0x150
> [ 1012.896336] RSP: 0018:ffff88007966bb60  EFLAGS: 00010046
> [ 1012.896336] RAX: 0000000000000000 RBX: ffff8800bdbba6e8 RCX: ffff88007dea1a20
> [ 1012.896336] RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> [ 1012.896336] RBP: ffff88007966bb78 R08: 0000000000000000 R09: 0000000000000046
> [ 1012.896336] R10: ffff88007966bb78 R11: 0000000000000246 R12: ffff8800bdbba6e8
> [ 1012.896336] R13: ffff880091ba3800 R14: ffff8800bdbbad40 R15: ffff880030a13120
> [ 1012.896336] FS:  00007fa159320700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
> [ 1012.896336] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1012.896336] CR2: 0000000000000028 CR3: 000000007f42e000 CR4: 00000000000006e0
> [ 1012.896336] Stack:
> [ 1012.896336]  ffff8800bdbba6e8 0000000000000000 ffff8800bdbbad50 ffff88007966bb88
> [ 1012.896336]  ffffffff813cc8ce ffff88007966bbb8 ffffffff813b1aac ffff8800bdbba6e8
> [ 1012.896336]  ffffffff81cf9200 ffff8800bdbba6e8 ffff880030a13000 ffff88007966bbd0
> [ 1012.896336] Call Trace:
> [ 1012.896336]  [<ffffffff813cc8ce>] blkcg_drain_queue+0xe/0x10
> [ 1012.896336]  [<ffffffff813b1aac>] __blk_drain_queue+0x7c/0x180
> [ 1012.896336]  [<ffffffff813b1c3e>] blk_queue_bypass_start+0x8e/0xd0
> [ 1012.896336]  [<ffffffff813cba88>] blkcg_deactivate_policy+0x38/0x140
> [ 1012.896336]  [<ffffffff813cfad4>] blk_throtl_exit+0x34/0x50
> [ 1012.896336]  [<ffffffff813cc918>] blkcg_exit_queue+0x48/0x70
> [ 1012.896336]  [<ffffffff813b5306>] blk_release_queue+0x26/0x100
> [ 1012.896336]  [<ffffffff813dd9e7>] kobject_cleanup+0x77/0x1b0
> [ 1012.896336]  [<ffffffff813dd898>] kobject_put+0x28/0x60
> [ 1012.896336]  [<ffffffff813ae945>] blk_put_queue+0x15/0x20
> [ 1012.896336]  [<ffffffff8151e6bb>] scsi_device_dev_release_usercontext+0xbb/0x120
> [ 1012.896336]  [<ffffffff81087647>] execute_in_process_context+0x67/0x70
> [ 1012.896336]  [<ffffffff8151e5fc>] scsi_device_dev_release+0x1c/0x20
> [ 1012.896336]  [<ffffffff814dfab2>] device_release+0x32/0xa0
> [ 1012.896336]  [<ffffffff813dd9e7>] kobject_cleanup+0x77/0x1b0
> [ 1012.896336]  [<ffffffff813dd898>] kobject_put+0x28/0x60
> [ 1012.896336]  [<ffffffff814dfda7>] put_device+0x17/0x20
> [ 1012.896336]  [<ffffffff8151f109>] __scsi_remove_device+0xa9/0xe0
> [ 1012.896336]  [<ffffffff8151d6b4>] scsi_forget_host+0x64/0x70
> [ 1012.896336]  [<ffffffff81511bb7>] scsi_remove_host+0x77/0x120
> [ 1012.896336]  [<ffffffffa01e15a9>] sdebug_driver_remove+0x29/0x90 [scsi_debug]
> [ 1012.896336]  [<ffffffff814e403f>] __device_release_driver+0x7f/0xf0
> [ 1012.896336]  [<ffffffff814e40d3>] device_release_driver+0x23/0x30
> [ 1012.896336]  [<ffffffff814e39d8>] bus_remove_device+0x108/0x180
> [ 1012.896336]  [<ffffffff814e02d9>] device_del+0x129/0x1c0
> [ 1012.896336]  [<ffffffff814e038e>] device_unregister+0x1e/0x60
> [ 1012.896336]  [<ffffffffa01e0efc>] sdebug_remove_adapter+0x4c/0x70 [scsi_debug]
> [ 1012.896336]  [<ffffffffa01e552d>] scsi_debug_exit+0x19/0xaec [scsi_debug]
> [ 1012.896336]  [<ffffffff810ea51e>] SyS_delete_module+0x12e/0x1c0
> [ 1012.896336]  [<ffffffff810536b9>] ? do_async_page_fault+0x29/0xe0
> [ 1012.896336]  [<ffffffff81836b88>] ? async_page_fault+0x28/0x30
> [ 1012.896336]  [<ffffffff81834ba9>] system_call_fastpath+0x16/0x1b
> [ 1012.896336] Code: 55 65 ff 04 25 a0 c7 00 00 48 89 e5 41 55 41 54 49 89 fc 53 4c 8b af 40 07 00 00 49 8b 85 a0 00 00 00 31 ff 48 8b 80 c8 05 00 00 <48> 8b 70 28 e8 37 7f d2 ff 48 85 c0 48 89 c3 74 61 0f 1f 80 00 
> [ 1012.896336] RIP  [<ffffffff813cf880>] blk_throtl_drain+0x30/0x150
> [ 1012.896336]  RSP <ffff88007966bb60>
> [ 1012.896336] CR2: 0000000000000028
> [ 1012.896336] ------------[ cut here ]------------
> [ 1012.896336] kernel BUG at arch/x86/mm/pageattr.c:216!
> [ 1012.896336] invalid opcode: 0000 [#2] SMP 
> [ 1012.896336] Modules linked in: sd_mod scsi_debug(-) crct10dif_generic crc_t10dif crct10dif_common loop ipmi_watchdog ipmi_msghandler dm_mod fuse sg sr_mod cdrom ata_generic pata_acpi parport_pc parport floppy snd_pcm snd_timer snd cirrus ata_piix soundcore syscopyarea pcspkr sysfillrect sysimgblt ttm drm_kms_helper libata drm i2c_piix4
> [ 1012.896336] CPU: 1 PID: 8020 Comm: rmmod Not tainted 3.16.0-rc3-01927-ge376abf #1
> [ 1012.896336] Hardware name: Bochs Bochs, BIOS Bochs 01/01/2011
> [ 1012.896336] task: ffff8801151a0000 ti: ffff880079668000 task.ti: ffff880079668000
> [ 1012.896336] RIP: 0010:[<ffffffff8105bbd3>]  [<ffffffff8105bbd3>] change_page_attr_set_clr+0x433/0x440
> [ 1012.896336] RSP: 0018:ffff88007966aec8  EFLAGS: 00010046
> [ 1012.896336] RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000010
> [ 1012.896336] RDX: 0000000000002200 RSI: 0000000000000000 RDI: 0000000080000000
> [ 1012.896336] RBP: ffff88007966af58 R08: 800000007c3c2163 R09: 000000000007c3c2
> [ 1012.896336] R10: ffffea0001f58000 R11: ffffffff813db659 R12: 0000000000000000
> [ 1012.896336] R13: 0000000000000010 R14: 0000000000000004 R15: 0000000000000005
> [ 1012.896336] FS:  00007fa159320700(0000) GS:ffff88011fc80000(0000) knlGS:0000000000000000
> [ 1012.896336] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> [ 1012.896336] CR2: 0000000000000028 CR3: 000000007f42e000 CR4: 00000000000006e0
> [ 1012.896336] Stack:
> [ 1012.896336]  0000000200000000 0000000000000000 0000000000000000 ffff880100000200
> [ 1012.896336]  ffff8801151a0000 0000000000000000 0000000000000000 0000000000000010
> [ 1012.896336]  0000000000000000 0000000500000001 000000000007c3c2 0000020000000000
> [ 1012.896336] Call Trace:
> [ 1012.896336]  [<ffffffff8105bf26>] _set_pages_array+0xe6/0x130
> [ 1012.896336]  [<ffffffff8105bfa3>] set_pages_array_wc+0x13/0x20
> [ 1012.896336]  [<ffffffffa00ca02f>] ttm_set_pages_caching+0x2f/0x70 [ttm]
> [ 1012.896336]  [<ffffffffa00ca174>] ttm_alloc_new_pages.isra.6+0xb4/0x180 [ttm]
> [ 1012.896336]  [<ffffffffa00caa63>] ttm_pool_populate+0x3c3/0x4d0 [ttm]
> [ 1012.896336]  [<ffffffffa00e920e>] cirrus_ttm_tt_populate+0xe/0x10 [cirrus]
> [ 1012.896336]  [<ffffffffa00c7571>] ttm_bo_move_memcpy+0x5d1/0x680 [ttm]
> [ 1012.896336]  [<ffffffff8118dffe>] ? map_vm_area+0x2e/0x40
> [ 1012.896336]  [<ffffffffa00c3289>] ? ttm_tt_init+0x69/0xb0 [ttm]
> [ 1012.896336]  [<ffffffffa00e91b8>] cirrus_bo_move+0x18/0x20 [cirrus]
> [ 1012.896336]  [<ffffffffa00c4d45>] ttm_bo_handle_move_mem+0x265/0x5b0 [ttm]
> [ 1012.896336]  [<ffffffffa00c56a6>] ? ttm_bo_mem_space+0x116/0x340 [ttm]
> [ 1012.896336]  [<ffffffffa00c5d6f>] ttm_bo_validate+0x21f/0x230 [ttm]
> [ 1012.896336]  [<ffffffffa00e99a2>] cirrus_bo_push_sysram+0x82/0xe0 [cirrus]
> [ 1012.896336]  [<ffffffffa00e7bf5>] cirrus_crtc_do_set_base.isra.8.constprop.10+0x75/0x400 [cirrus]
> [ 1012.896336]  [<ffffffffa00e83c9>] cirrus_crtc_mode_set+0x449/0x4d0 [cirrus]
> [ 1012.896336]  [<ffffffffa00588e9>] drm_crtc_helper_set_mode+0x2b9/0x4f0 [drm_kms_helper]
> [ 1012.896336]  [<ffffffffa005966f>] drm_crtc_helper_set_config+0x87f/0xaa0 [drm_kms_helper]
> [ 1012.896336]  [<ffffffff818325fe>] ? __ww_mutex_lock+0x2e/0xaa
> [ 1012.896336]  [<ffffffffa001a124>] drm_mode_set_config_internal+0x64/0xf0 [drm]
> [ 1012.896336]  [<ffffffffa005c324>] drm_fb_helper_pan_display+0x94/0xf0 [drm_kms_helper]
> [ 1012.896336]  [<ffffffff8143f959>] fb_pan_display+0xc9/0x190
> [ 1012.896336]  [<ffffffff81439b10>] bit_update_start+0x20/0x50
> [ 1012.896336]  [<ffffffff814395c2>] fbcon_switch+0x3a2/0x550
> [ 1012.896336]  [<ffffffff814b10d9>] redraw_screen+0x189/0x240
> [ 1012.896336]  [<ffffffff8143fcce>] ? fb_blank+0x9e/0xc0
> [ 1012.896336]  [<ffffffff81436b5a>] fbcon_blank+0x20a/0x2d0
> [ 1012.896336]  [<ffffffff810c91cc>] ? wake_up_klogd+0x3c/0x50
> [ 1012.896336]  [<ffffffff810c93d8>] ? console_unlock+0x1f8/0x440
> [ 1012.896336]  [<ffffffff81079133>] ? __internal_add_timer+0x113/0x130
> [ 1012.896336]  [<ffffffff8107917f>] ? internal_add_timer+0x2f/0x70
> [ 1012.896336]  [<ffffffff8107b1b2>] ? mod_timer+0x142/0x1f0
> [ 1012.896336]  [<ffffffff814b1bf8>] do_unblank_screen+0xb8/0x200
> [ 1012.896336]  [<ffffffff814b1d50>] unblank_screen+0x10/0x20
> [ 1012.896336]  [<ffffffff813ea3c9>] bust_spinlocks+0x19/0x40
> [ 1012.896336]  [<ffffffff81017718>] oops_end+0x38/0x150
> [ 1012.896336]  [<ffffffff81823e09>] no_context+0x2b3/0x2c0
> [ 1012.896336]  [<ffffffff81823e89>] __bad_area_nosemaphore+0x73/0x1ca
> [ 1012.896336]  [<ffffffff81823ff3>] bad_area_nosemaphore+0x13/0x15
> [ 1012.896336]  [<ffffffff81058c90>] __do_page_fault+0x90/0x550
> [ 1012.896336]  [<ffffffff810a6148>] ? __enqueue_entity+0x78/0x80
> [ 1012.896336]  [<ffffffff810acca1>] ? enqueue_entity+0x291/0xba0
> [ 1012.896336]  [<ffffffff81053d47>] ? kvm_clock_read+0x27/0x40
> [ 1012.896336]  [<ffffffff810abc32>] ? check_preempt_wakeup+0x162/0x230
> [ 1012.896336]  [<ffffffff8109e715>] ? check_preempt_curr+0x85/0xa0
> [ 1012.896336]  [<ffffffff8109e749>] ? ttwu_do_wakeup+0x19/0xe0
> [ 1012.896336]  [<ffffffff81059201>] trace_do_page_fault+0x41/0x130
> [ 1012.896336]  [<ffffffff810536b9>] do_async_page_fault+0x29/0xe0
> [ 1012.896336]  [<ffffffff81836b88>] async_page_fault+0x28/0x30
> [ 1012.896336]  [<ffffffff813cf880>] ? blk_throtl_drain+0x30/0x150
> [ 1012.896336]  [<ffffffff813cc8ce>] blkcg_drain_queue+0xe/0x10
> [ 1012.896336]  [<ffffffff813b1aac>] __blk_drain_queue+0x7c/0x180
> [ 1012.896336]  [<ffffffff813b1c3e>] blk_queue_bypass_start+0x8e/0xd0
> [ 1012.896336]  [<ffffffff813cba88>] blkcg_deactivate_policy+0x38/0x140
> [ 1012.896336]  [<ffffffff813cfad4>] blk_throtl_exit+0x34/0x50
> [ 1012.896336]  [<ffffffff813cc918>] blkcg_exit_queue+0x48/0x70
> [ 1012.896336]  [<ffffffff813b5306>] blk_release_queue+0x26/0x100
> [ 1012.896336]  [<ffffffff813dd9e7>] kobject_cleanup+0x77/0x1b0
> [ 1012.896336]  [<ffffffff813dd898>] kobject_put+0x28/0x60
> [ 1012.896336]  [<ffffffff813ae945>] blk_put_queue+0x15/0x20
> [ 1012.896336]  [<ffffffff8151e6bb>] scsi_device_dev_release_usercontext+0xbb/0x120
> [ 1012.896336]  [<ffffffff81087647>] execute_in_process_context+0x67/0x70
> [ 1012.896336]  [<ffffffff8151e5fc>] scsi_device_dev_release+0x1c/0x20
> [ 1012.896336]  [<ffffffff814dfab2>] device_release+0x32/0xa0
> [ 1012.896336]  [<ffffffff813dd9e7>] kobject_cleanup+0x77/0x1b0
> [ 1012.896336]  [<ffffffff813dd898>] kobject_put+0x28/0x60
> [ 1012.896336]  [<ffffffff814dfda7>] put_device+0x17/0x20
> [ 1012.896336]  [<ffffffff8151f109>] __scsi_remove_device+0xa9/0xe0
> [ 1012.896336]  [<ffffffff8151d6b4>] scsi_forget_host+0x64/0x70
> [ 1012.896336]  [<ffffffff81511bb7>] scsi_remove_host+0x77/0x120
> [ 1012.896336]  [<ffffffffa01e15a9>] sdebug_driver_remove+0x29/0x90 [scsi_debug]
> [ 1012.896336]  [<ffffffff814e403f>] __device_release_driver+0x7f/0xf0
> [ 1012.896336]  [<ffffffff814e40d3>] device_release_driver+0x23/0x30
> [ 1012.896336]  [<ffffffff814e39d8>] bus_remove_device+0x108/0x180
> [ 1012.896336]  [<ffffffff814e02d9>] device_del+0x129/0x1c0
> [ 1012.896336]  [<ffffffff814e038e>] device_unregister+0x1e/0x60
> [ 1012.896336]  [<ffffffffa01e0efc>] sdebug_remove_adapter+0x4c/0x70 [scsi_debug]
> [ 1012.896336]  [<ffffffffa01e552d>] scsi_debug_exit+0x19/0xaec [scsi_debug]
> [ 1012.896336]  [<ffffffff810ea51e>] SyS_delete_module+0x12e/0x1c0
> [ 1012.896336]  [<ffffffff810536b9>] ? do_async_page_fault+0x29/0xe0
> [ 1012.896336]  [<ffffffff81836b88>] ? async_page_fault+0x28/0x30
> [ 1012.896336]  [<ffffffff81834ba9>] system_call_fastpath+0x16/0x1b
> [ 1012.896336] Code: ff ff 48 8b 4d 80 e9 9f fc ff ff 0f 0b 0f 0b be ba 00 00 00 48 c7 c7 e8 cb ae 81 89 4d 80 e8 d5 15 01 00 8b 4d 80 e9 04 ff ff ff <0f> 0b 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48 89 
> [ 1012.896336] RIP  [<ffffffff8105bbd3>] change_page_attr_set_clr+0x433/0x440
> [ 1012.896336]  RSP <ffff88007966aec8>
> [ 1012.896336] ---[ end trace 86a5a05a2d9e9cde ]---
> [ 1012.896336] Kernel panic - not syncing: Fatal exception
> 
> 
> 
> Disclaimer:
> Results have been estimated based on internal Intel analysis and are provided
> for informational purposes only. Any difference in system hardware or software
> design or configuration may affect actual performance.
> 
> Thanks,
> Aaron
> 
