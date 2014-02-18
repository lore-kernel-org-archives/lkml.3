Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952AbaBRO0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:26:45 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:48997 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548AbaBROZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:25:25 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-ae-53036d52c669
Message-id: <53036D51.2070502@samsung.com>
Date: Tue, 18 Feb 2014 15:25:21 +0100
From: Marek Szyprowski <m.szyprowski@samsung.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101
 Thunderbird/24.3.0
MIME-version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Michal Nazarewicz <mina86@mina86.com>
Subject: Re: [BUG] Circular locking dependency - DRM/CMA/MM/hotplug/...
References: <20140211183543.GK26684@n2100.arm.linux.org.uk>
 <52FB9602.1000805@samsung.com> <20140212163317.GQ26684@n2100.arm.linux.org.uk>
In-reply-to: <20140212163317.GQ26684@n2100.arm.linux.org.uk>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t/xa7pBuczBBjMWylv0njvJZHHl63s2
	i02Pr7FaXN41h83i9mVeiwXHW1gd2DxamnvYPLZ/e8Dqcb/7OJPH5iX1Huv+vGLy+LxJLoAt
	issmJTUnsyy1SN8ugSvj7+XLjAUHfCsuTnnA2MC4yrKLkZNDQsBE4vb9bjYIW0ziwr31QDYH
	h5DAUkaJE6xdjFxA5idGiTevr4HV8ApoSXw8tgHMZhFQlTh59jkjiM0mYCjR9bYLrFdUIFRi
	3lw9iHJBiR+T77GA2CICphLXHj1jBpnJLLCZUaLz7g6wXmEBd4kJL6azQSzrYZS4MOEwM0iC
	U8BG4vrqXrBlzAJmEo9a1jFD2PISm9e8ZZ7AKDALyZJZSMpmISlbwMi8ilE0tTS5oDgpPddI
	rzgxt7g0L10vOT93EyMkwL/uYFx6zOoQowAHoxIP7wdlpmAh1sSy4srcQ4wSHMxKIryaUczB
	QrwpiZVVqUX58UWlOanFhxiZODilGhhvVkjnG8WZiya/8XbLqZ3uKlVkIqJ0ePtc5soj1wV4
	/nFOZVQSPfM+t+DPjLQtV3Puntigsf+Mz7xW8Y7UWvv5XOZ265xc/7Vdmrv84OG3K0rjJE5N
	TrkVJ3KZU/mRwyKWPc69Nx9k1TUlJq0RMMr4p/fwP/cGaYcYbka3Odd9o+VznvpEJSixFGck
	GmoxFxUnAgDx1vr3TgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 2014-02-12 17:33, Russell King - ARM Linux wrote:
> On Wed, Feb 12, 2014 at 04:40:50PM +0100, Marek Szyprowski wrote:
> > Hello,
> >
> > On 2014-02-11 19:35, Russell King - ARM Linux wrote:
> >> The cubox-i4 just hit a new lockdep problem - not quite sure what to
> >> make of this - it looks like an interaction between quite a lot of
> >> locks - I suspect more than the lockdep code is reporting in its
> >> "Possible unsafe locking scenario" report.
> >>
> >> I'm hoping I've sent this to appropriate people...  if anyone thinks
> >> this needs to go to someone else, please forward it.  Thanks.
> >
> > From the attached log it looks like an issue (AB-BA deadlock) between
> > device mutex (&dev->struct_mutex) and mm semaphore (&mm->mmap_sem).
> > Similar issue has been discussed quite a long time ago in v4l2
> > subsystem:
>
> I think there's more locks involved than just those two.
>
> > https://www.mail-archive.com/linux-media@vger.kernel.org/msg38599.html
> > http://www.spinics.net/lists/linux-media/msg40225.html
> >
> > Solving it probably requires some changes in DRM core. I see no direct
> > relation between this issue and CMA itself.
>
> I don't think so - the locking in DRM is pretty sane. Let's take a
> look:
>
> >> the existing dependency chain (in reverse order) is:
> >> -> #5 (&dev->struct_mutex){+.+...}:
> >>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
> >>         [<c0067c28>] lock_acquire+0xa0/0x130
> >>         [<c0698180>] mutex_lock_nested+0x5c/0x3ac
> >>         [<c0350c30>] drm_gem_mmap+0x40/0xdc
> >>         [<c03671d8>] drm_gem_cma_mmap+0x14/0x2c
> >>         [<c00ef4f4>] mmap_region+0x3ac/0x59c
> >>         [<c00ef9ac>] do_mmap_pgoff+0x2c8/0x370
> >>         [<c00dd730>] vm_mmap_pgoff+0x6c/0x9c
> >>         [<c00ee1fc>] SyS_mmap_pgoff+0x54/0x98
> >>         [<c000e6e0>] ret_fast_syscall+0x0/0x48
>
> vm_mmap_pgoff() takes mm->mmap_sem before calling do_mmap_pgoff().
> So, this results in the following locking order:
>
> 	mm->mmap_sem
> 	dev->struct_mutex
>
> >> -> #4 (&mm->mmap_sem){++++++}:
> >>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
> >>         [<c0067c28>] lock_acquire+0xa0/0x130
> >>         [<c00e6c5c>] might_fault+0x6c/0x94
> >>         [<c0335440>] con_set_unimap+0x158/0x27c
> >>         [<c032f800>] vt_ioctl+0x1298/0x1388
> >>         [<c0323f44>] tty_ioctl+0x168/0xbf4
> >>         [<c0115fac>] do_vfs_ioctl+0x84/0x664
> >>         [<c01165d0>] SyS_ioctl+0x44/0x64
> >>         [<c000e6e0>] ret_fast_syscall+0x0/0x48
>
> vt_ioctl() takes the console lock, so this results in:
>
> 	console_lock
> 	mm->mmap_sem
>
> >> -> #3 (console_lock){+.+.+.}:
> >>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
> >>         [<c0067c28>] lock_acquire+0xa0/0x130
> >>         [<c006edcc>] console_lock+0x60/0x74
> >>         [<c006f7b8>] console_cpu_notify+0x28/0x34
> >>         [<c004904c>] notifier_call_chain+0x4c/0x8c
> >>         [<c004916c>] __raw_notifier_call_chain+0x1c/0x24
> >>         [<c0024124>] __cpu_notify+0x34/0x50
> >>         [<c002424c>] cpu_notify_nofail+0x18/0x24
> >>         [<c068e168>] _cpu_down+0x100/0x244
> >>         [<c068e2dc>] cpu_down+0x30/0x44
> >>         [<c036ef8c>] cpu_subsys_offline+0x14/0x18
> >>         [<c036af28>] device_offline+0x94/0xbc
> >>         [<c036b030>] online_store+0x4c/0x74
> >>         [<c0368d3c>] dev_attr_store+0x20/0x2c
> >>         [<c016b2e0>] sysfs_kf_write+0x54/0x58
> >>         [<c016eaa4>] kernfs_fop_write+0xc4/0x160
> >>         [<c0105a54>] vfs_write+0xbc/0x184
> >>         [<c0105dfc>] SyS_write+0x48/0x70
> >>         [<c000e6e0>] ret_fast_syscall+0x0/0x48
>
> cpu_down() takes cpu_hotplug.lock, so here we have:
>
> 	cpu_hotplug.lock
> 	console_lock
>
> >> -> #2 (cpu_hotplug.lock){+.+.+.}:
> >>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
> >>         [<c0067c28>] lock_acquire+0xa0/0x130
> >>         [<c0698180>] mutex_lock_nested+0x5c/0x3ac
> >>         [<c0024218>] get_online_cpus+0x3c/0x58
> >>         [<c00d0ab0>] lru_add_drain_all+0x24/0x190
> >>         [<c0101d3c>] migrate_prep+0x10/0x18
> >>         [<c00cba04>] alloc_contig_range+0xf4/0x30c
> >>         [<c0371588>] dma_alloc_from_contiguous+0x7c/0x130
> >>         [<c0018ef8>] __alloc_from_contiguous+0x38/0x12c
> >>         [<c0908694>] atomic_pool_init+0x74/0x128
> >>         [<c0008850>] do_one_initcall+0x3c/0x164
> >>         [<c0903c98>] kernel_init_freeable+0x104/0x1d0
> >>         [<c068de54>] kernel_init+0x10/0xec
> >>         [<c000e7a8>] ret_from_fork+0x14/0x2c
>
> dma_alloc_from_contiguous takes the cma_mutex, so here we end up with:
>
> 	cma_mutex
> 	cpu_hotplug.lock
>
> >> -> #1 (lock){+.+...}:
> >>         [<c0066f04>] __lock_acquire+0x151c/0x1ca0
> >>         [<c0067c28>] lock_acquire+0xa0/0x130
> >>         [<c0698180>] mutex_lock_nested+0x5c/0x3ac
> >>         [<c00d0aa8>] lru_add_drain_all+0x1c/0x190
> >>         [<c0101d3c>] migrate_prep+0x10/0x18
> >>         [<c00cba04>] alloc_contig_range+0xf4/0x30c
> >>         [<c0371588>] dma_alloc_from_contiguous+0x7c/0x130
> >>         [<c0018ef8>] __alloc_from_contiguous+0x38/0x12c
> >>         [<c0908694>] atomic_pool_init+0x74/0x128
> >>         [<c0008850>] do_one_initcall+0x3c/0x164
> >>         [<c0903c98>] kernel_init_freeable+0x104/0x1d0
> >>         [<c068de54>] kernel_init+0x10/0xec
> >>         [<c000e7a8>] ret_from_fork+0x14/0x2c
>
> Ditto - here we have:
>
> 	cma_mutex
> 	lock
>
> where "lock" is nicely named... this is a lock inside lru_add_drain_all()
> and under this lock, we call get_online_cpus() and put_online_cpus().
> get_online_cpus() takes cpu_hotplug.lock, so here we also have:
>
> 	cma_mutex
> 	lock
> 	cpu_hotplug.lock
>
> >> -> #0 (cma_mutex){+.+.+.}:
> >>         [<c0690850>] print_circular_bug+0x70/0x2f0
> >>         [<c0066f68>] __lock_acquire+0x1580/0x1ca0
> >>         [<c0067c28>] lock_acquire+0xa0/0x130
> >>         [<c0698180>] mutex_lock_nested+0x5c/0x3ac
> >>         [<c03716f4>] dma_release_from_contiguous+0xb8/0xf8
> >>         [<c00197a4>] __arm_dma_free.isra.11+0x194/0x218
> >>         [<c0019868>] arm_dma_free+0x1c/0x24
> >>         [<c0366e34>] drm_gem_cma_free_object+0x68/0xb8
> >>         [<c0351194>] drm_gem_object_free+0x30/0x38
> >>         [<c0351318>] drm_gem_object_handle_unreference_unlocked+0x108/0x148
> >>         [<c0351498>] drm_gem_handle_delete+0xb0/0x10c
> >>         [<c0351508>] drm_gem_dumb_destroy+0x14/0x18
> >>         [<c035e838>] drm_mode_destroy_dumb_ioctl+0x34/0x40
> >>         [<c034f918>] drm_ioctl+0x3f4/0x498
> >>         [<c0115fac>] do_vfs_ioctl+0x84/0x664
> >>         [<c01165d0>] SyS_ioctl+0x44/0x64
> >>         [<c000e6e0>] ret_fast_syscall+0x0/0x48
>
> drm_gem_object_unreference_unlocked takes dev->struct_mutex, so:
>
> 	dev->struct_mutex
> 	cma_mutex
>
>
> So, the full locking dependency tree is this:
>
> CPU0		CPU1		CPU2		CPU3		CPU4
> dev->struct_mutex (from #0)
> 		mm->mmap_sem
> 		dev->struct_mutex (from #5)
> 				console_lock (from #4)
> 				mm->mmap_sem
> 						cpu_hotplug.lock (from #3)
> 						console_lock
> 								cma_mutex (from #2, but also from #1)
> 								cpu_hotplug.lock
> cma_mutex
>
> Which is pretty sick - and I don't think that blaming this solely on V4L2
> nor DRM is particularly fair.  I believe the onus is on every author of
> one of those locks involved in that chain needs to re-analyse whether
> their locking is sane.
>
> For instance, what is cma_mutex protecting?  Is it protecting the CMA
> bitmap?

This lock is protecting CMA bitmap and also serializes all CMA allocations.
It is required by memory management core to serialize all calls to
alloc_contig_range() (otherwise page block's migrate types might get
overwritten). I don't see any other obvious solution for serializing
alloc_contig_range() calls.

> What if we did these changes:
>
> struct page *dma_alloc_from_contiguous(struct device *dev, int count,
>                                         unsigned int align)
> {
> ...
>          mutex_lock(&cma_mutex);
> ...
>          for (;;) {
>                  pageno = bitmap_find_next_zero_area(cma->bitmap, cma->count,
>                                                      start, count, mask);
>                  if (pageno >= cma->count)
>                          break;
>
>                  pfn = cma->base_pfn + pageno;
> +               bitmap_set(cma->bitmap, pageno, count);
> +               mutex_unlock(&cma_mutex);
>                  ret = alloc_contig_range(pfn, pfn + count, MIGRATE_CMA);
> +               mutex_lock(&cma_mutex);
>                  if (ret == 0) {
> -                       bitmap_set(cma->bitmap, pageno, count);
>                          page = pfn_to_page(pfn);
>                          break;
> -               } else if (ret != -EBUSY) {
> +		}
> +		bitmap_clear(cma->bitmap, pageno, count);
> +		if (ret != -EBUSY) {
>                          break;
>                  }
> ...
>          mutex_unlock(&cma_mutex);
>          pr_debug("%s(): returned %p\n", __func__, page);
>          return page;
> }
>
>
> bool dma_release_from_contiguous(struct device *dev, struct page *pages,
>                                   int count)
> {
> ...
> +       free_contig_range(pfn, count);
>          mutex_lock(&cma_mutex);
>          bitmap_clear(cma->bitmap, pfn - cma->base_pfn, count);
> -       free_contig_range(pfn, count);
>          mutex_unlock(&cma_mutex);
> ...
> }
>
> which avoids the dependency between cma_mutex and cpu_hotplug.lock ?

This will not work correctly if there will be 2 concurrent calls to 
alloc_contig_range(),
which will touch the same memory page blocks.

Best regards
-- 
Marek Szyprowski, PhD
Samsung R&D Institute Poland

