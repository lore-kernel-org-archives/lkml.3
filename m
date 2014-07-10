Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaGJVhf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:37:35 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:33795 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751019AbaGJVhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:37:34 -0400
Message-ID: <53BF0794.6030606@vmware.com>
Date: Thu, 10 Jul 2014 23:37:24 +0200
From: =?UTF-8?B?VGhvbWFzIEhlbGxzdHLDtm0=?= <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>, airlied@linux.ie
CC: nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, bskeggs@redhat.com,
        alexander.deucher@amd.com, christian.koenig@amd.com
Subject: Re: [PATCH 00/17] Convert TTM to the new fence interface.
References: <20140709093124.11354.3774.stgit@patser>
In-Reply-To: <20140709093124.11354.3774.stgit@patser>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2014-07-09 14:29, Maarten Lankhorst wrote:
> This series applies on top of the driver-core-next branch of
> git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
>
> Before converting ttm to the new fence interface I had to fix some
> drivers to require a reservation before poking with fence_obj.
> After flipping the switch RCU becomes available instead, and
> the extra reservations can be dropped again. :-)
>
> I've done at least basic testing on all the drivers I've converted
> at some point, but more testing is definitely welcomed!

I'm currently on vacation for the next couple of weeks, so I can't test 
or review but otherwise

Acked-by: Thomas Hellstrom <thellstrom@vmware.com>

> ---
>
> Maarten Lankhorst (17):
>        drm/ttm: add interruptible parameter to ttm_eu_reserve_buffers
>        drm/ttm: kill off some members to ttm_validate_buffer
>        drm/nouveau: add reservation to nouveau_gem_ioctl_cpu_prep
>        drm/nouveau: require reservations for nouveau_fence_sync and nouveau_bo_fence
>        drm/ttm: call ttm_bo_wait while inside a reservation
>        drm/ttm: kill fence_lock
>        drm/nouveau: rework to new fence interface
>        drm/radeon: add timeout argument to radeon_fence_wait_seq
>        drm/radeon: use common fence implementation for fences
>        drm/qxl: rework to new fence interface
>        drm/vmwgfx: get rid of different types of fence_flags entirely
>        drm/vmwgfx: rework to new fence interface
>        drm/ttm: flip the switch, and convert to dma_fence
>        drm/nouveau: use rcu in nouveau_gem_ioctl_cpu_prep
>        drm/radeon: use rcu waits in some ioctls
>        drm/vmwgfx: use rcu in vmw_user_dmabuf_synccpu_grab
>        drm/ttm: use rcu in core ttm
>
>   drivers/gpu/drm/nouveau/core/core/event.c |    4
>   drivers/gpu/drm/nouveau/nouveau_bo.c      |   59 +---
>   drivers/gpu/drm/nouveau/nouveau_display.c |   25 +-
>   drivers/gpu/drm/nouveau/nouveau_fence.c   |  431 +++++++++++++++++++----------
>   drivers/gpu/drm/nouveau/nouveau_fence.h   |   22 +
>   drivers/gpu/drm/nouveau/nouveau_gem.c     |   55 +---
>   drivers/gpu/drm/nouveau/nv04_fence.c      |    4
>   drivers/gpu/drm/nouveau/nv10_fence.c      |    4
>   drivers/gpu/drm/nouveau/nv17_fence.c      |    2
>   drivers/gpu/drm/nouveau/nv50_fence.c      |    2
>   drivers/gpu/drm/nouveau/nv84_fence.c      |   11 -
>   drivers/gpu/drm/qxl/Makefile              |    2
>   drivers/gpu/drm/qxl/qxl_cmd.c             |    7
>   drivers/gpu/drm/qxl/qxl_debugfs.c         |   16 +
>   drivers/gpu/drm/qxl/qxl_drv.h             |   20 -
>   drivers/gpu/drm/qxl/qxl_fence.c           |   91 ------
>   drivers/gpu/drm/qxl/qxl_kms.c             |    1
>   drivers/gpu/drm/qxl/qxl_object.c          |    2
>   drivers/gpu/drm/qxl/qxl_object.h          |    6
>   drivers/gpu/drm/qxl/qxl_release.c         |  172 ++++++++++--
>   drivers/gpu/drm/qxl/qxl_ttm.c             |   93 ------
>   drivers/gpu/drm/radeon/radeon.h           |   15 -
>   drivers/gpu/drm/radeon/radeon_cs.c        |   10 +
>   drivers/gpu/drm/radeon/radeon_device.c    |   60 ++++
>   drivers/gpu/drm/radeon/radeon_display.c   |   21 +
>   drivers/gpu/drm/radeon/radeon_fence.c     |  283 +++++++++++++++----
>   drivers/gpu/drm/radeon/radeon_gem.c       |   19 +
>   drivers/gpu/drm/radeon/radeon_object.c    |    8 -
>   drivers/gpu/drm/radeon/radeon_ttm.c       |   34 --
>   drivers/gpu/drm/radeon/radeon_uvd.c       |   10 -
>   drivers/gpu/drm/radeon/radeon_vm.c        |   16 +
>   drivers/gpu/drm/ttm/ttm_bo.c              |  187 ++++++-------
>   drivers/gpu/drm/ttm/ttm_bo_util.c         |   28 --
>   drivers/gpu/drm/ttm/ttm_bo_vm.c           |    3
>   drivers/gpu/drm/ttm/ttm_execbuf_util.c    |  146 +++-------
>   drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c    |   47 ---
>   drivers/gpu/drm/vmwgfx/vmwgfx_drv.h       |    1
>   drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c   |   24 --
>   drivers/gpu/drm/vmwgfx/vmwgfx_fence.c     |  329 ++++++++++++----------
>   drivers/gpu/drm/vmwgfx/vmwgfx_fence.h     |   35 +-
>   drivers/gpu/drm/vmwgfx/vmwgfx_resource.c  |   43 +--
>   include/drm/ttm/ttm_bo_api.h              |    7
>   include/drm/ttm/ttm_bo_driver.h           |   29 --
>   include/drm/ttm/ttm_execbuf_util.h        |   22 +
>   44 files changed, 1256 insertions(+), 1150 deletions(-)
>   delete mode 100644 drivers/gpu/drm/qxl/qxl_fence.c
>
