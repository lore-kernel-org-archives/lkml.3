Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754192Ab3ILEmi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 00:42:38 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:55628 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752624Ab3ILEmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 00:42:36 -0400
From: Olof Johansson <olof@lixom.net>
To: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Terje=20Bergstr=C3=B6m?= <tbergstrom@nvidia.com>
Cc: dri-devel@lists.freedesktop.org, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org, Olof Johansson <olof@lixom.net>
Subject: [PATCH] gpu: host1x: use %pa to print dma_addr_t
Date: Wed, 11 Sep 2013 21:41:49 -0700
Message-Id: <1378960909-15773-1-git-send-email-olof@lixom.net>
X-Mailer: git-send-email 1.8.1.192.gc4361b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes two warnings where dma_addr_t variables were printed using
%x when built with CONFIG_ARM_LPAE=y, thus having 64-bit dma_addr_t:

  drivers/gpu/host1x/hw/cdma_hw.c:57:3: warning: format '%x' expects argument of type 'unsigned int', but argument 5 has type 'dma_addr_t'
  drivers/gpu/host1x/hw/debug_hw.c:175:10: warning: format '%x' expects argument of type 'unsigned int', but argument 3 has type 'dma_addr_t'

Signed-off-by: Olof Johansson <olof@lixom.net>
---
 drivers/gpu/host1x/hw/cdma_hw.c  |    4 ++--
 drivers/gpu/host1x/hw/debug_hw.c |    4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
index 2ee4ad5..3db3011 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -54,8 +54,8 @@ static void cdma_timeout_cpu_incr(struct host1x_cdma *cdma, u32 getptr,
 		u32 *p = (u32 *)((u32)pb->mapped + getptr);
 		*(p++) = HOST1X_OPCODE_NOP;
 		*(p++) = HOST1X_OPCODE_NOP;
-		dev_dbg(host1x->dev, "%s: NOP at 0x%x\n", __func__,
-			pb->phys + getptr);
+		dev_dbg(host1x->dev, "%s: NOP at %pa+0x%x\n", __func__,
+			&pb->phys, getptr);
 		getptr = (getptr + 8) & (pb->size_bytes - 1);
 	}
 	wmb();
diff --git a/drivers/gpu/host1x/hw/debug_hw.c b/drivers/gpu/host1x/hw/debug_hw.c
index 334c038..346a54b 100644
--- a/drivers/gpu/host1x/hw/debug_hw.c
+++ b/drivers/gpu/host1x/hw/debug_hw.c
@@ -171,8 +171,8 @@ static void show_channel_gathers(struct output *o, struct host1x_cdma *cdma)
 				continue;
 			}
 
-			host1x_debug_output(o, "    GATHER at %08x+%04x, %d words\n",
-					    g->base, g->offset, g->words);
+			host1x_debug_output(o, "    GATHER at %pa+%04x, %d words\n",
+					    &g->base, g->offset, g->words);
 
 			show_gather(o, g->base + g->offset, g->words, cdma,
 				    g->base, mapped);
-- 
1.7.10.4

