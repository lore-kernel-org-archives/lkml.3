Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752810AbaCXIv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 04:51:28 -0400
Received: from hqemgate15.nvidia.com ([216.228.121.64]:2941 "EHLO
	hqemgate15.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752551AbaCXIqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 04:46:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 24 Mar 2014 01:40:12 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>
CC: Thierry Reding <thierry.reding@gmail.com>, <nouveau@lists.freedesktop.org>,
        <dri-devel@lists.freedesktop.org>, <linux-tegra@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gnurou@gmail.com>,
        Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH 02/12] drm/nouveau/timer: skip calibration on GK20A
Date: Mon, 24 Mar 2014 17:42:24 +0900
Message-ID: <1395650554-31925-3-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
References: <1395650554-31925-1-git-send-email-acourbot@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

GK20A's timer is directly attached to the system timer and cannot be
calibrated. Skip the calibration phase on that chip since the
corresponding registers do not exist.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
 drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c b/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
index c0bdd10358d7..822fe0d8a871 100644
--- a/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
+++ b/drivers/gpu/drm/nouveau/core/subdev/timer/nv04.c
@@ -185,6 +185,10 @@ nv04_timer_init(struct nouveau_object *object)
 	if (ret)
 		return ret;
 
+	/* gk20a does not have the calibration registers */
+	if (device->chipset == 0xea)
+		goto skip_clk_init;
+
 	/* aim for 31.25MHz, which gives us nanosecond timestamps */
 	d = 1000000 / 32;
 
@@ -235,20 +239,23 @@ nv04_timer_init(struct nouveau_object *object)
 		d >>= 1;
 	}
 
-	/* restore the time before suspend */
-	lo = priv->suspend_time;
-	hi = (priv->suspend_time >> 32);
-
 	nv_debug(priv, "input frequency : %dHz\n", f);
 	nv_debug(priv, "input multiplier: %d\n", m);
 	nv_debug(priv, "numerator       : 0x%08x\n", n);
 	nv_debug(priv, "denominator     : 0x%08x\n", d);
 	nv_debug(priv, "timer frequency : %dHz\n", (f * m) * d / n);
-	nv_debug(priv, "time low        : 0x%08x\n", lo);
-	nv_debug(priv, "time high       : 0x%08x\n", hi);
 
 	nv_wr32(priv, NV04_PTIMER_NUMERATOR, n);
 	nv_wr32(priv, NV04_PTIMER_DENOMINATOR, d);
+
+skip_clk_init:
+	/* restore the time before suspend */
+	lo = priv->suspend_time;
+	hi = (priv->suspend_time >> 32);
+
+	nv_debug(priv, "time low        : 0x%08x\n", lo);
+	nv_debug(priv, "time high       : 0x%08x\n", hi);
+
 	nv_wr32(priv, NV04_PTIMER_INTR_0, 0xffffffff);
 	nv_wr32(priv, NV04_PTIMER_INTR_EN_0, 0x00000000);
 	nv_wr32(priv, NV04_PTIMER_TIME_1, hi);
-- 
1.9.1

