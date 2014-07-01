Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757548AbaGAK5m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 06:57:42 -0400
Received: from adelie.canonical.com ([91.189.90.139]:60168 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752804AbaGAK5k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 06:57:40 -0400
Subject: [PATCH v2 0/9] Updated fence patch series
To: gregkh@linuxfoundation.org
From: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Cc: linux-arch@vger.kernel.org, thellstrom@vmware.com,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org, robdclark@gmail.com,
        thierry.reding@gmail.com, ccross@google.com, daniel@ffwll.ch,
        sumit.semwal@linaro.org, linux-media@vger.kernel.org
Date: Tue, 01 Jul 2014 12:57:02 +0200
Message-ID: <20140701103432.12718.82795.stgit@patser>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So after some more hacking I've moved dma-buf to its own subdirectory,
drivers/dma-buf and applied the fence patches to its new place. I believe that the
first patch should be applied regardless, and the rest should be ready now.
:-)

Changes to the fence api:
- release_fence -> fence_release etc.
- __fence_init -> fence_init
- __fence_signal -> fence_signal_locked
- __fence_is_signaled -> fence_is_signaled_locked
- Changing BUG_ON to WARN_ON in fence_later, and return NULL if it triggers.

Android can expose fences to userspace. It's possible to make the new fence
mechanism expose the same fences to userspace by changing sync_fence_create
to take a struct fence instead of a struct sync_pt. No other change is needed,
because only the fence parts of struct sync_pt are used. But because the
userspace fences are a separate problem and I haven't really looked at it yet
I feel it should stay in staging, for now.

---

Maarten Lankhorst (9):
      dma-buf: move to drivers/dma-buf
      fence: dma-buf cross-device synchronization (v18)
      seqno-fence: Hardware dma-buf implementation of fencing (v6)
      dma-buf: use reservation objects
      android: convert sync to fence api, v6
      reservation: add support for fences to enable cross-device synchronisation
      dma-buf: add poll support, v3
      reservation: update api and add some helpers
      reservation: add suppport for read-only access using rcu


 Documentation/DocBook/device-drivers.tmpl      |    8 
 MAINTAINERS                                    |    4 
 drivers/Makefile                               |    1 
 drivers/base/Kconfig                           |    9 
 drivers/base/Makefile                          |    1 
 drivers/base/dma-buf.c                         |  743 --------------------
 drivers/base/reservation.c                     |   39 -
 drivers/dma-buf/Makefile                       |    1 
 drivers/dma-buf/dma-buf.c                      |  907 ++++++++++++++++++++++++
 drivers/dma-buf/fence.c                        |  431 +++++++++++
 drivers/dma-buf/reservation.c                  |  477 +++++++++++++
 drivers/dma-buf/seqno-fence.c                  |   73 ++
 drivers/gpu/drm/armada/armada_gem.c            |    2 
 drivers/gpu/drm/drm_prime.c                    |    8 
 drivers/gpu/drm/exynos/exynos_drm_dmabuf.c     |    2 
 drivers/gpu/drm/i915/i915_gem_dmabuf.c         |    3 
 drivers/gpu/drm/nouveau/nouveau_drm.c          |    1 
 drivers/gpu/drm/nouveau/nouveau_gem.h          |    1 
 drivers/gpu/drm/nouveau/nouveau_prime.c        |    7 
 drivers/gpu/drm/omapdrm/omap_gem_dmabuf.c      |    2 
 drivers/gpu/drm/radeon/radeon_drv.c            |    2 
 drivers/gpu/drm/radeon/radeon_prime.c          |    8 
 drivers/gpu/drm/tegra/gem.c                    |    2 
 drivers/gpu/drm/ttm/ttm_object.c               |    2 
 drivers/media/v4l2-core/videobuf2-dma-contig.c |    2 
 drivers/staging/android/Kconfig                |    1 
 drivers/staging/android/Makefile               |    2 
 drivers/staging/android/ion/ion.c              |    3 
 drivers/staging/android/sw_sync.c              |    6 
 drivers/staging/android/sync.c                 |  913 ++++++++----------------
 drivers/staging/android/sync.h                 |   79 +-
 drivers/staging/android/sync_debug.c           |  247 ++++++
 drivers/staging/android/trace/sync.h           |   12 
 include/drm/drmP.h                             |    3 
 include/linux/dma-buf.h                        |   21 -
 include/linux/fence.h                          |  360 +++++++++
 include/linux/reservation.h                    |   82 ++
 include/linux/seqno-fence.h                    |  116 +++
 include/trace/events/fence.h                   |  128 +++
 39 files changed, 3258 insertions(+), 1451 deletions(-)
 delete mode 100644 drivers/base/dma-buf.c
 delete mode 100644 drivers/base/reservation.c
 create mode 100644 drivers/dma-buf/Makefile
 create mode 100644 drivers/dma-buf/dma-buf.c
 create mode 100644 drivers/dma-buf/fence.c
 create mode 100644 drivers/dma-buf/reservation.c
 create mode 100644 drivers/dma-buf/seqno-fence.c
 create mode 100644 drivers/staging/android/sync_debug.c
 create mode 100644 include/linux/fence.h
 create mode 100644 include/linux/seqno-fence.h
 create mode 100644 include/trace/events/fence.h

-- 
Signature
