Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484AbaEBQVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2014 12:21:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43764 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752785AbaEBPjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2014 11:39:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Russell King <rmk+kernel@arm.linux.org.uk>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 143/151] DRM: armada: fix corruption while loading cursors
Date: Fri,  2 May 2014 08:38:51 -0700
Message-Id: <1399045139-4531-144-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1399045139-4531-1-git-send-email-kamal@canonical.com>
References: <1399045139-4531-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Russell King <rmk+kernel@arm.linux.org.uk>

commit c39b06951f1dc2e384650288676c5b7dcc0ec92c upstream.

Loading cursors to the LCD controller's SRAM can be corrupted when the
configured pixel clock is relatively slow.  This seems to be caused
when we write back-to-back to the SRAM registers.

There doesn't appear to be any status register we can read to check
when an access has completed.

Inserting a dummy read between the writes appears to fix the problem.

Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/armada/armada_crtc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/armada/armada_crtc.c b/drivers/gpu/drm/armada/armada_crtc.c
index d8e3982..66a492a 100644
--- a/drivers/gpu/drm/armada/armada_crtc.c
+++ b/drivers/gpu/drm/armada/armada_crtc.c
@@ -678,6 +678,7 @@ static void armada_load_cursor_argb(void __iomem *base, uint32_t *pix,
 				       base + LCD_SPU_SRAM_WRDAT);
 			writel_relaxed(addr | SRAM_WRITE,
 				       base + LCD_SPU_SRAM_CTRL);
+			readl_relaxed(base + LCD_SPU_HWC_OVSA_HPXL_VLN);
 			addr += 1;
 			if ((addr & 0x00ff) == 0)
 				addr += 0xf00;
-- 
1.9.1

