Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752309AbaJ0Jtf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 05:49:35 -0400
Received: from hqemgate14.nvidia.com ([216.228.121.143]:19169 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbaJ0Jtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 05:49:32 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 27 Oct 2014 02:48:53 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, David Airlie <airlied@linux.ie>,
        David Herrmann <dh.herrmann@gmail.com>, Lucas Stach <dev@lynxeye.de>,
        Thierry Reding <thierry.reding@gmail.com>,
        Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v5 0/4] drm: nouveau: memory coherency on ARM
Date: Mon, 27 Oct 2014 18:49:15 +0900
Message-ID: <1414403359-22332-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 2.1.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It has been a couple of months since v4 - apologies for this. v4 has not
received many comments, but this version addresses them and makes a new
attempt at pushing the critical bit for GK20A and Nouveau on ARM in
general.

As a reminder, this series addresses the memory coherency issue that we
are seeing on ARM platforms. Contrary to x86 which invalidates the PCI
caches whenever a write is made by the CPU to a GPU-accessed area (and
vice-versa), such accesses on ARM might result in the other accessor to
end up in an incoherent state.

To address this, patches 1-3 add the ability to understand whether we
are on a non-coherent architecture, implement a way to explicitly allocate
coherent buffers buffers using the DMA API, and uses it for GPFIFOS and
fences. Patch 4 also uses the DMA API to synchronize user-space allocated
buffers when they are passed from the CPU to the GPU and vice-versa.

Thanks to the feedback received on the previous revisions I believe this
code looks rather good now. I also have extensively tested it and could
not see any buffer corruption issue anymore. There is still one point
which is not completely satisfying in my opinion:

TTMs for TTM-backed objects are allocated in nouveau_sgdma_create_ttm()
and populated in nouveau_ttm_tt_populate(). Coherently-allocated buffers
need to use the ttm_dma API instead of the pool-based TTM API, and whether
an object is coherent or not is stored in its instance of nouveau_bo.

The problem is that neither nouveau_sgdma_create_ttm() nor
nouveau_ttm_tt_populate() have a way to access the nouveau_bo they are
working for. This is in particular a problem for nouveau_ttm_tt_populate()
since we need to rely on a purely TTM-based heuristic to decide how to
allocate the memory. The heuristic we are using works, but it makes the
code harder to understand than if we could just access the nouveau_bo.
nouveau_sgdma_create_ttm() always allocates a ttm_dma_tt structure,
which is wrong but happens to suit us for now. Still, this part of the
code could be rewritten much more cleanly if only we could access the
nouveau_bo instance in these functions.

I proposed some time ago to address this by making the ttm_tt_create
hook take a pointer to a ttm_bo_object instead of a ttm_bo_device.
This would still allow us to access the ttm_bo_device, while letting
us retrieve the nouveau_bo and store it into whatever structure we
embed our TTM into. For some reason David was not fond of the idea - I
am taking another chance at submitting it since the issue is still
not resolved and leads in inferior-looking code in at least Nouveau.

Phew, sorry for the long cover letter - thanks if you have read until
here! :)

Changes since v4:
- Only use DMA API for sync, as suggested by Daniel

Alexandre Courbot (4):
  drm: introduce nv_device_is_cpu_coherent()
  drm: implement explicitly coherent BOs
  drm: allocate GPFIFOs and fences coherently
  drm: synchronize BOs when required

 drm/nouveau_bo.c           | 122 ++++++++++++++++++++++++++++++++++++++++++---
 drm/nouveau_bo.h           |   3 ++
 drm/nouveau_chan.c         |   2 +-
 drm/nouveau_gem.c          |  12 +++++
 drm/nv84_fence.c           |   4 +-
 lib/core/os.h              |   2 +
 nvkm/include/core/device.h |   6 +++
 7 files changed, 140 insertions(+), 11 deletions(-)

-- 
2.1.2

