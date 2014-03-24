Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542AbaCXIqD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:46:03 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2928 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090AbaCXIqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:46:00 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 24 Mar 2014 01:40:08 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 00/12] drm/nouveau: support for GK20A, cont'd
Date: Mon, 24 Mar 2014 17:42:22 +0900
Message-ID: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.1
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

Here is the second batch of patches to add GK20A support to Nouveau. This time
we are adding the actual chip support, and this series brings the driver to a
point where a slightly-tweaked Mesa successfully runs shaders and renders
triangles on GBM! Many thanks to Thierry Reding and the people on the
#nouveau IRC channel for their help without which we would not have reached
this milestone.

A few lines of hacks (not included here) are still needed to deal with cached
mappings triggering external aborts and CPU/GPU memory coherency issues, but I
hope to understand and address these issues next.

Most of the changes below have already been seen (and sometimes reviewed) in an
earlier patchset. What has been added is proper PGRAPH support (still needing
an external firmware and mostly reusing NVE4's code) as well as a better RAM
implementation.

How to represent and manage VRAM has been the hardest part to deal with, since
GK20A shares the system memory with the CPU without any kind of partition. I
have tried various approaches (included some in which no RAM object ever gets
instanciated) and finally decided to go for one using DMA-contiguous memory
allocations and relying on BAR mappings for kernel access and exposure to
user-space, as it fits better with existing code and keeps us safe from most of
the CPU/GPU memory coherency issues (at the cost of some performance).

Looking forward to your review of these few patches! :)

Cheers,
Alex.

Alexandre Courbot (12):
  drm/nouveau: fix missing newline
  drm/nouveau/timer: skip calibration on GK20A
  drm/nouveau/bar: only ioremap BAR3 if it exists
  drm/nouveau/bar/nvc0: support chips without BAR3
  drm/nouveau/fifo: add GK20A support
  drm/nouveau/ibus: add GK20A support
  drm/nouveau/fb: add GK20A support
  drm/nouveau/graph: enable when using external firmware
  drm/nouveau/graph: pad firmware code at load time
  drm/nouveau/graph: add GK20A support
  drm/nouveau: support GK20A in nouveau_accel_init()
  drm/nouveau: support for probing GK20A

 drivers/gpu/drm/nouveau/Makefile                   |   5 +
 drivers/gpu/drm/nouveau/core/engine/device/nve0.c  |  20 +++
 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.h    |   1 +
 drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c    |  35 +++++
 .../gpu/drm/nouveau/core/engine/graph/ctxnve4.c    |   4 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.c   |  12 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvc0.h   |   9 ++
 drivers/gpu/drm/nouveau/core/engine/graph/nve4.c   |   2 +-
 drivers/gpu/drm/nouveau/core/engine/graph/nvea.c   |  75 +++++++++
 drivers/gpu/drm/nouveau/core/include/engine/fifo.h |   1 +
 .../gpu/drm/nouveau/core/include/engine/graph.h    |   1 +
 drivers/gpu/drm/nouveau/core/include/subdev/fb.h   |   1 +
 drivers/gpu/drm/nouveau/core/include/subdev/ibus.h |   1 +
 drivers/gpu/drm/nouveau/core/subdev/bar/base.c     |   7 +-
 drivers/gpu/drm/nouveau/core/subdev/bar/nvc0.c     | 101 +++++++------
 drivers/gpu/drm/nouveau/core/subdev/fb/nvea.c      |  56 +++++++
 drivers/gpu/drm/nouveau/core/subdev/fb/priv.h      |   1 +
 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvea.c   | 168 +++++++++++++++++++++
 drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c    | 110 ++++++++++++++
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c   |  19 ++-
 drivers/gpu/drm/nouveau/nouveau_drm.c              |  12 +-
 21 files changed, 578 insertions(+), 63 deletions(-)
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/fifo/nvea.c
 create mode 100644 drivers/gpu/drm/nouveau/core/engine/graph/nvea.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/nvea.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/fb/ramnvea.c
 create mode 100644 drivers/gpu/drm/nouveau/core/subdev/ibus/nvea.c

-- 
1.9.1

