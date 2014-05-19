Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055AbaESJqn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:46:43 -0400
Received: from hqemgate16.nvidia.com ([216.228.121.65]:6291 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752681AbaESJql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:46:41 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Mon, 19 May 2014 02:41:49 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>, Ben Skeggs <bskeggs@redhat.com>
CC: <nouveau@lists.freedesktop.org>, <dri-devel@lists.freedesktop.org>,
        <linux-tegra@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <gnurou@gmail.com>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [RFC] drm/nouveau: disable caching for VRAM BOs on ARM
Date: Mon, 19 May 2014 18:46:11 +0900
Message-ID: <1400492771-9746-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.2
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is not meant to be merged, but rather to try and understand
why this is needed and what a more suitable solution could be.

Allowing BOs to be write-cached results in the following happening when
trying to run any program on Tegra/GK20A:

Unhandled fault: external abort on non-linefetch (0x1008) at 0xf0036010
...
(nouveau_bo_rd32) from [<c0357d00>] (nouveau_fence_update+0x5c/0x80)
(nouveau_fence_update) from [<c0357d40>] (nouveau_fence_done+0x1c/0x38)
(nouveau_fence_done) from [<c02c3d00>] (ttm_bo_wait+0xec/0x168)
(ttm_bo_wait) from [<c035e334>] (nouveau_gem_ioctl_cpu_prep+0x44/0x100)
(nouveau_gem_ioctl_cpu_prep) from [<c02aaa84>] (drm_ioctl+0x1d8/0x4f4)
(drm_ioctl) from [<c0355394>] (nouveau_drm_ioctl+0x54/0x80)
(nouveau_drm_ioctl) from [<c00ee7b0>] (do_vfs_ioctl+0x3dc/0x5a0)
(do_vfs_ioctl) from [<c00ee9a8>] (SyS_ioctl+0x34/0x5c)
(SyS_ioctl) from [<c000e6e0>] (ret_fast_syscall+0x0/0x30

The offending nouveau_bo_rd32 is done over an IO-mapped BO, e.g. a BO
mapped through the BAR.

Any idea about the origin of this behavior? Does ARM forbid cached
mappings over IO regions?

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index 8db54a217232..9cfb8e61f5c4 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -552,7 +552,11 @@ nouveau_bo_init_mem_type(struct ttm_bo_device *bdev, uint32_t type,
 			     TTM_MEMTYPE_FLAG_MAPPABLE;
 		man->available_caching = TTM_PL_FLAG_UNCACHED |
 					 TTM_PL_FLAG_WC;
+#if defined(__arm__)
+		man->default_caching = TTM_PL_FLAG_UNCACHED;
+#else
 		man->default_caching = TTM_PL_FLAG_WC;
+#endif
 		break;
 	case TTM_PL_TT:
 		if (nv_device(drm->device)->card_type >= NV_50)
-- 
1.9.2

