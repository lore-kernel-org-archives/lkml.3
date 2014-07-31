Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859AbaGaPbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 11:31:07 -0400
Received: from adelie.canonical.com ([91.189.90.139]:56427 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaGaPbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 11:31:06 -0400
Subject: [PATCH 00/17] Convert TTM to the new fence interface. v2
To: airlied@linux.ie
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: thellstrom@vmware.com, nouveau@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        bskeggs@redhat.com, alexander.deucher@amd.com,
        christian.koenig@amd.com
Date: Thu, 31 Jul 2014 17:30:52 +0200
Message-ID: <20140731152809.14619.29424.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This series applies on top of the driver-core-next branch of
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git

Before converting ttm to the new fence interface I had to fix some
drivers to require a reservation before poking with fence_obj.
After flipping the switch RCU becomes available instead, and
the extra reservations can be dropped again. 

I've done at least basic testing on all the drivers I've converted
at some point, but more testing is definitely welcomed!

Changes since v1:
- Almost all radeon changes, radeon reworked their page flip code which
  made things easier for me.
- Added a delayed work for radeon that checks gpu lockups.
- Reworked the radeon fence implementation to remove deadlocks,
  and end up slightly cleaner.

---

Maarten Lankhorst (18):
      fence: add debugging lines to fence_is_signaled for the callback
      drm/ttm: add interruptible parameter to ttm_eu_reserve_buffers
      drm/ttm: kill off some members to ttm_validate_buffer
      drm/nouveau: add reservation to nouveau_gem_ioctl_cpu_prep
      drm/nouveau: require reservations for nouveau_fence_sync and nouveau_bo_fence
      drm/ttm: call ttm_bo_wait while inside a reservation
      drm/ttm: kill fence_lock
      drm/nouveau: rework to new fence interface
      drm/radeon: handle lockup in delayed work, v2
      drm/radeon: add timeout argument to radeon_fence_wait_seq
      drm/radeon: use common fence implementation for fences, v2
      drm/qxl: rework to new fence interface
      drm/vmwgfx: get rid of different types of fence_flags entirely
      drm/vmwgfx: rework to new fence interface
      drm/ttm: flip the switch, and convert to dma_fence
      drm/nouveau: use rcu in nouveau_gem_ioctl_cpu_prep
      drm/radeon: use rcu waits in some ioctls
      drm/vmwgfx: use rcu in vmw_user_dmabuf_synccpu_grab


 drivers/gpu/drm/nouveau/core/core/event.c |    4 
 drivers/gpu/drm/nouveau/nouveau_bo.c      |   59 +---
 drivers/gpu/drm/nouveau/nouveau_display.c |   25 +-
 drivers/gpu/drm/nouveau/nouveau_fence.c   |  431 +++++++++++++++++++----------
 drivers/gpu/drm/nouveau/nouveau_fence.h   |   22 +
 drivers/gpu/drm/nouveau/nouveau_gem.c     |   55 +---
 drivers/gpu/drm/nouveau/nv04_fence.c      |    4 
 drivers/gpu/drm/nouveau/nv10_fence.c      |    4 
 drivers/gpu/drm/nouveau/nv17_fence.c      |    2 
 drivers/gpu/drm/nouveau/nv50_fence.c      |    2 
 drivers/gpu/drm/nouveau/nv84_fence.c      |   11 -
 drivers/gpu/drm/qxl/Makefile              |    2 
 drivers/gpu/drm/qxl/qxl_cmd.c             |    7 
 drivers/gpu/drm/qxl/qxl_debugfs.c         |   16 +
 drivers/gpu/drm/qxl/qxl_drv.h             |   20 -
 drivers/gpu/drm/qxl/qxl_fence.c           |   91 ------
 drivers/gpu/drm/qxl/qxl_kms.c             |    1 
 drivers/gpu/drm/qxl/qxl_object.c          |    2 
 drivers/gpu/drm/qxl/qxl_object.h          |    6 
 drivers/gpu/drm/qxl/qxl_release.c         |  172 ++++++++++--
 drivers/gpu/drm/qxl/qxl_ttm.c             |   93 ------
 drivers/gpu/drm/radeon/radeon.h           |   21 +
 drivers/gpu/drm/radeon/radeon_cs.c        |   10 +
 drivers/gpu/drm/radeon/radeon_device.c    |   27 +-
 drivers/gpu/drm/radeon/radeon_display.c   |    8 -
 drivers/gpu/drm/radeon/radeon_fence.c     |  405 +++++++++++++++++++++------
 drivers/gpu/drm/radeon/radeon_gem.c       |   19 +
 drivers/gpu/drm/radeon/radeon_irq_kms.c   |   43 +++
 drivers/gpu/drm/radeon/radeon_object.c    |    8 -
 drivers/gpu/drm/radeon/radeon_ring.c      |    1 
 drivers/gpu/drm/radeon/radeon_ttm.c       |   34 --
 drivers/gpu/drm/radeon/radeon_uvd.c       |   10 -
 drivers/gpu/drm/radeon/radeon_vm.c        |   16 +
 drivers/gpu/drm/ttm/ttm_bo.c              |  239 +++++++++-------
 drivers/gpu/drm/ttm/ttm_bo_util.c         |   28 --
 drivers/gpu/drm/ttm/ttm_bo_vm.c           |    3 
 drivers/gpu/drm/ttm/ttm_execbuf_util.c    |  146 +++-------
 drivers/gpu/drm/vmwgfx/vmwgfx_buffer.c    |   47 ---
 drivers/gpu/drm/vmwgfx/vmwgfx_drv.h       |    1 
 drivers/gpu/drm/vmwgfx/vmwgfx_execbuf.c   |   24 --
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.c     |  329 ++++++++++++----------
 drivers/gpu/drm/vmwgfx/vmwgfx_fence.h     |   35 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_resource.c  |   43 +--
 include/drm/ttm/ttm_bo_api.h              |    7 
 include/drm/ttm/ttm_bo_driver.h           |   29 --
 include/drm/ttm/ttm_execbuf_util.h        |   22 +
 include/linux/fence.h                     |   23 +-
 47 files changed, 1408 insertions(+), 1199 deletions(-)
 delete mode 100644 drivers/gpu/drm/qxl/qxl_fence.c

-- 
Signature
