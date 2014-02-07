Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaBGNYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 08:24:54 -0500
Received: from gnurou.org ([207.192.72.5]:34737 "EHLO mail.gnurou.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753429AbaBGNYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 08:24:53 -0500
From: Alexandre Courbot <acourbot@nvidia.com>
To: Ben Skeggs <bskeggs@redhat.com>, nouveau@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        gnurou@gmail.com, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH] nouveau/drm/fifo: fix ENG_RUNLIST register address
Date: Fri,  7 Feb 2014 22:22:57 +0900
Message-Id: <1391779377-10176-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Address of the ENG_RUNLIST register should be 0x002284 + (engine * 8),
not 0x002284 + (engine * 4).

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
---
Stumbled upon this one and I'm quite certain the offset was not correct.
This is inconsequential for GK20A which only features one runlist, but
other GPUs might run into troubles because of this. Not tested, just
reported for your consideration.

FWIW, the Android GK20A driver uses the same offset calculation.

 drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
index 99c9dee..dbc3ff6 100644
--- a/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
+++ b/drivers/gpu/drm/nouveau/core/engine/fifo/nve0.c
@@ -112,7 +112,7 @@ nve0_fifo_runlist_update(struct nve0_fifo_priv *priv, u32 engine)
 
 	nv_wr32(priv, 0x002270, cur->addr >> 12);
 	nv_wr32(priv, 0x002274, (engine << 20) | (p >> 3));
-	if (!nv_wait(priv, 0x002284 + (engine * 4), 0x00100000, 0x00000000))
+	if (!nv_wait(priv, 0x002284 + (engine * 8), 0x00100000, 0x00000000))
 		nv_error(priv, "runlist %d update timeout\n", engine);
 	mutex_unlock(&nv_subdev(priv)->mutex);
 }
-- 
1.8.5.3

