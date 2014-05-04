Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363AbaEDQeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:34:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36209 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179AbaEDPlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:51 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Dave Airlie <airlied@redhat.com>
Subject: [PATCH 3.14 101/158] DRM: armada: fix corruption while loading cursors
Date: Sun,  4 May 2014 11:40:10 -0400
Message-Id: <20140504154043.675989489@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/armada/armada_crtc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/armada/armada_crtc.c
+++ b/drivers/gpu/drm/armada/armada_crtc.c
@@ -678,6 +678,7 @@ static void armada_load_cursor_argb(void
 				       base + LCD_SPU_SRAM_WRDAT);
 			writel_relaxed(addr | SRAM_WRITE,
 				       base + LCD_SPU_SRAM_CTRL);
+			readl_relaxed(base + LCD_SPU_HWC_OVSA_HPXL_VLN);
 			addr += 1;
 			if ((addr & 0x00ff) == 0)
 				addr += 0xf00;


