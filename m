Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751804AbaLRVle (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 16:41:34 -0500
Received: from ns.gsystem.sk ([62.176.172.50]:37375 "EHLO gsystem.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211AbaLRVld (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 16:41:33 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: Krzysztof Helt <krzysztof.h1@wp.pl>
Cc: linux-fbdev@vger.kernel.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] tridentfb: fix hang on Blade3D with CONFIG_CC_OPTIMIZE_FOR_SIZE
Date: Thu, 18 Dec 2014 22:41:22 +0100
Message-Id: <1418938882-28984-1-git-send-email-linux@rainbow-software.org>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel is compiled with -Os (CONFIG_CC_OPTIMIZE_FOR_SIZE), tridentfb
hangs the machine upon load with Blade3D cards unless acceleration is disabled.

This is caused by memcpy() which copies data byte-by-byte (rep movsb) when
compiled with -Os. The card does not like that - it requires 32-bit access.

Use iowrite_32() instead.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/video/fbdev/tridentfb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/tridentfb.c b/drivers/video/fbdev/tridentfb.c
index 7ed9a22..7429713 100644
--- a/drivers/video/fbdev/tridentfb.c
+++ b/drivers/video/fbdev/tridentfb.c
@@ -226,7 +226,7 @@ static void blade_image_blit(struct tridentfb_par *par, const char *data,
 	writemmr(par, DST1, point(x, y));
 	writemmr(par, DST2, point(x + w - 1, y + h - 1));
 
-	memcpy(par->io_virt + 0x10000, data, 4 * size);
+	iowrite32_rep(par->io_virt + 0x10000, data, size);
 }
 
 static void blade_copy_rect(struct tridentfb_par *par,
-- 
Ondrej Zary

