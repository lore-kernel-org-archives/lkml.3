Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174Ab3JBO7D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 10:59:03 -0400
Received: from mail-ee0-f51.google.com ([74.125.83.51]:41659 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab3JBO65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 10:58:57 -0400
From: David Herrmann <dh.herrmann@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Tom Gundersen <teg@jklm.no>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        dri-devel@lists.freedesktop.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        David Herrmann <dh.herrmann@gmail.com>
Subject: [PATCH 2/2] simplefb: use write-combined remapping
Date: Wed,  2 Oct 2013 16:58:39 +0200
Message-Id: <1380725919-1961-2-git-send-email-dh.herrmann@gmail.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1380725919-1961-1-git-send-email-dh.herrmann@gmail.com>
References: <1380725919-1961-1-git-send-email-dh.herrmann@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Framebuffers shouldn't be cached and it is usually very uncommon to read
them. Therefore, use ioremap_wc() to get significant speed improvements on
systems which provide it. On all other systems it's aliased to
ioremap_nocache() which is also fine.

Reported-by: Tom Gundersen <teg@jklm.no>
Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Tested-by: Tom Gundersen <teg@jklm.no>
Tested-by: Alexandre Courbot <acourbot@nvidia.com>
Tested-by: Stephen Warren <swarren@wwwdotorg.org>
---
 drivers/video/simplefb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
index 74b016c..64db54a 100644
--- a/drivers/video/simplefb.c
+++ b/drivers/video/simplefb.c
@@ -219,8 +219,8 @@ static int simplefb_probe(struct platform_device *pdev)
 
 	info->fbops = &simplefb_ops;
 	info->flags = FBINFO_DEFAULT | FBINFO_MISC_FIRMWARE;
-	info->screen_base = ioremap(info->fix.smem_start,
-				    info->fix.smem_len);
+	info->screen_base = ioremap_wc(info->fix.smem_start,
+				       info->fix.smem_len);
 	if (!info->screen_base) {
 		framebuffer_release(info);
 		return -ENODEV;
-- 
1.8.4

