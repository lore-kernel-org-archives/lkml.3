Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab3AMLip (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jan 2013 06:38:45 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:48357 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab3AMLin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jan 2013 06:38:43 -0500
Date: Sun, 13 Jan 2013 14:38:20 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Dave Airlie <airlied@redhat.com>
Cc: Dave Jones <davej@redhat.com>, dri-devel@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: radeon causing sleeping function called from invalid context
Message-ID: <20130113113820.GA2503@swordfish>
References: <20130113012717.GA2673@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130113012717.GA2673@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (01/12/13 20:27), Dave Jones wrote:
> BUG: sleeping function called from invalid context at mm/slub.c:925
> in_atomic(): 1, irqs_disabled(): 0, pid: 566, name: Xorg
> INFO: lockdep is turned off.
> Pid: 566, comm: Xorg Not tainted 3.8.0-rc3+ #49
> Call Trace:
>  [<ffffffff81087ad1>] __might_sleep+0x141/0x200
>  [<ffffffff8119eddb>] kmem_cache_alloc_trace+0x4b/0x2a0
>  [<ffffffffa0083fb3>] ttm_bo_move_accel_cleanup+0x1d3/0x330 [ttm]
>  [<ffffffffa00c5418>] radeon_move_blit.isra.4+0xf8/0x160 [radeon]
>  [<ffffffffa00c5db0>] radeon_bo_move+0xb0/0x1f0 [radeon]
>  [<ffffffffa00820ed>] ttm_bo_handle_move_mem+0x27d/0x5d0 [ttm]
>  [<ffffffff8108dd51>] ? get_parent_ip+0x11/0x50
>  [<ffffffffa0083307>] ttm_bo_move_buffer+0x127/0x140 [ttm]
>  [<ffffffffa008717d>] ? ttm_eu_list_ref_sub+0x3d/0x60 [ttm]
>  [<ffffffffa00833c2>] ttm_bo_validate+0xa2/0x120 [ttm]
>  [<ffffffffa00c6f45>] radeon_bo_list_validate+0x75/0x90 [radeon]
>  [<ffffffffa00dca22>] radeon_cs_ioctl+0x582/0x950 [radeon]
>  [<ffffffffa002e573>] drm_ioctl+0x4d3/0x580 [drm]
>  [<ffffffffa00dc4a0>] ? radeon_cs_finish_pages+0xf0/0xf0 [radeon]
>  [<ffffffff811c49f9>] do_vfs_ioctl+0x99/0x5a0
>  [<ffffffff812cd3d7>] ? file_has_perm+0x97/0xb0
>  [<ffffffff81103715>] ? rcu_eqs_exit+0x65/0xb0
>  [<ffffffff811c4f91>] sys_ioctl+0x91/0xb0
>  [<ffffffff81695ad4>] tracesys+0xdd/0xe2
> 

I see lots of these [mostly from page fault], the following one (quick and dirty) works for me.

----

Forbid ttm_buffer_object_transfer() sleeping in ISR context, do not pass 
__GFP_WAIT flag to kzalloc():

BUG: sleeping function called from invalid context at mm/slub.c:925
in_atomic(): 1, irqs_disabled(): 0, pid: 2179, name: X
3 locks held by X/2179:
 #0:  (&mm->mmap_sem){++++++}, at: [<ffffffff815fac53>] __do_page_fault+0xf3/0x590
 #1:  (&rdev->pm.mclk_lock){++++.+}, at: [<ffffffff81428e40>] radeon_ttm_fault+0x40/0x70
 #2:  (&(&bdev->fence_lock)->rlock){+.+.+.}, at: [<ffffffff813f3227>] ttm_bo_move_accel_cleanup+0x57/0x330
Pid: 2179, comm: X Not tainted 3.8.0-rc3-dbg-01259-gbdac2d4-dirty #1500
Call Trace:
 [<ffffffff8107adea>] __might_sleep+0x14a/0x200
 [<ffffffff811649c3>] kmem_cache_alloc_trace+0x153/0x240
 [<ffffffff813f33a3>] ttm_bo_move_accel_cleanup+0x1d3/0x330
 [<ffffffff814292e8>] radeon_move_blit.isra.6+0xf8/0x160
 [<ffffffff81429a90>] radeon_bo_move+0xb0/0x1f0
 [<ffffffff813f14b5>] ttm_bo_handle_move_mem+0x275/0x5c0
 [<ffffffff813f26f7>] ttm_bo_move_buffer+0x127/0x140
 [<ffffffff813f27b2>] ttm_bo_validate+0xa2/0x130
 [<ffffffff8142b0ed>] radeon_bo_fault_reserve_notify+0xad/0xe0
 [<ffffffff813f4600>] ttm_bo_vm_fault+0x60/0x370
 [<ffffffff81428e51>] radeon_ttm_fault+0x51/0x70
 [<ffffffff8114150a>] __do_fault+0x6a/0x540
 [<ffffffff81144771>] handle_pte_fault+0x91/0x810
 [<ffffffff815fac53>] ? __do_page_fault+0xf3/0x590
 [<ffffffff811464c1>] handle_mm_fault+0x231/0x330
 [<ffffffff815facbc>] __do_page_fault+0x15c/0x590
 [<ffffffff81184cd9>] ? do_vfs_ioctl+0x99/0x580
 [<ffffffff815ff7c9>] ? sysret_check+0x22/0x5d
 [<ffffffff815fb11b>] do_page_fault+0x2b/0x50
 [<ffffffff815f79a8>] page_fault+0x28/0x30


Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/gpu/drm/ttm/ttm_bo_util.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo_util.c b/drivers/gpu/drm/ttm/ttm_bo_util.c
index d73d6e3..92e0dea 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_util.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_util.c
@@ -422,7 +422,7 @@ static int ttm_buffer_object_transfer(struct ttm_buffer_object *bo,
 	struct ttm_bo_device *bdev = bo->bdev;
 	struct ttm_bo_driver *driver = bdev->driver;
 
-	fbo = kzalloc(sizeof(*fbo), GFP_KERNEL);
+	fbo = kzalloc(sizeof(*fbo), __GFP_IO | __GFP_FS);
 	if (!fbo)
 		return -ENOMEM;
 
