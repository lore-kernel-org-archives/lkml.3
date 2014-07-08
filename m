Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbaGHI0g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:26:36 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:12165 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594AbaGHI0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:26:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Tue, 08 Jul 2014 01:19:36 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v4 0/6] drm: nouveau: memory coherency on ARM
Date: Tue, 8 Jul 2014 17:25:55 +0900
Message-ID: <1404807961-30530-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.0.0
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Another revision of this patchset critical for GK20A to operate.

Previous attempts were exclusively using either TTM's regular page allocator or 
the DMA API one. Both have their advantages and drawbacks: the page allocator is 
fast but requires explicit synchronization on non-coherent architectures, 
whereas the DMA allocator always returns coherent memory, but is also slower,
creates a permanent kernel mapping, and is more constrained as to which memory
it can use.

This version attempts to use the most-fit allocator according to the buffer 
use-case:
- buffers that are passed to user-space can explicitly be synced during their 
  validation and preparation for CPU access, as previously shown by Lucas 
  (http://lists.freedesktop.org/archives/nouveau/2013-August/014029.html ). For 
  these, we don't mind if the memory is not coherent and prefer to use the page 
  allocator.
- buffers that are used by the kernel, typically fences and GPFIFO buffers, are
  accessed rarely and thus should not trigger a costly flush or cache
  invalidation. For these, we want to guarantee coherent access and use the DMA
  API if necessary.

This series attempts to implement this behavior by allowing the
TTM_PL_FLAG_UNCACHED flag to be passed to nouveau_bo_new(). On coherent 
architectures this flag is a no-op ; on non-coherent architectures, it will 
force the creation of a coherent buffer using the DMA-API.

Several fixes and changes were necessary to enable this behavior:
- CPU addresses of DMA-allocated BOs must be made visible (patch 1) so the 
  coherent mapping can be used by drivers
- The DMA-sync functions are required for BOs populated using the page allocator 
  (patch 4). Pages need to be mapped to the device using the correct API if we
  are to call the sync functions (patch 2). Additionally, we need to understand 
  whether we are on a CPU-coherent architecture (patch 3).
- Coherent BOs need to be detected by Nouveau so their coherent kernel mapping
  can be used instead of creating a new one (patch 5).
- Finally, buffers that are used by the kernel should be requested to be
  coherent (page 6).

Changes since v3:
- Only use the DMA allocator for BOs that strictly require to be coherent
- Fixed the way pages are mapped to the GPU on platform devices
- Thoroughly checked with CONFIG_DMA_API_DEBUG that there were no API violations

Alexandre Courbot (6):
  drm/ttm: expose CPU address of DMA-allocated pages
  drm/nouveau: map pages using DMA API on platform devices
  drm/nouveau: introduce nv_device_is_cpu_coherent()
  drm/nouveau: synchronize BOs when required
  drm/nouveau: implement explicitly coherent BOs
  drm/nouveau: allocate GPFIFOs and fences coherently

 drivers/gpu/drm/nouveau/core/engine/device/base.c  |  14 ++-
 drivers/gpu/drm/nouveau/core/include/core/device.h |   3 +
 drivers/gpu/drm/nouveau/nouveau_bo.c               | 132 +++++++++++++++++++--
 drivers/gpu/drm/nouveau/nouveau_bo.h               |   3 +
 drivers/gpu/drm/nouveau/nouveau_chan.c             |   2 +-
 drivers/gpu/drm/nouveau/nouveau_gem.c              |  12 ++
 drivers/gpu/drm/nouveau/nv84_fence.c               |   4 +-
 drivers/gpu/drm/ttm/ttm_page_alloc_dma.c           |   2 +
 drivers/gpu/drm/ttm/ttm_tt.c                       |   6 +-
 include/drm/ttm/ttm_bo_driver.h                    |   2 +
 10 files changed, 167 insertions(+), 13 deletions(-)

-- 
2.0.0

