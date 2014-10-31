Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548AbaJaWlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 18:41:09 -0400
Received: from mail.ispras.ru ([83.149.199.45]:39713 "EHLO mail.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750918AbaJaWlH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 18:41:07 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ldv-project@linuxtesting.org
Subject: [PATCH] m501fb: don't return zero on failure path in sm501fb_probe()
Date: Sat,  1 Nov 2014 01:40:47 +0300
Message-Id: <1414795247-14686-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If no framebuffers found, sm501fb_probe() breaks off initialization,
deallocates sm501fb_info, but returns zero. As a result, use after free
can happen in sm501fb_remove().

The patch adds -ENODEV as a return value in this case.

Found by Linux Driver Verification project (linuxtesting.org).

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
---
 drivers/video/fbdev/sm501fb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/sm501fb.c b/drivers/video/fbdev/sm501fb.c
index 9e74e8fbe074..8b98b011fc04 100644
--- a/drivers/video/fbdev/sm501fb.c
+++ b/drivers/video/fbdev/sm501fb.c
@@ -1988,6 +1988,7 @@ static int sm501fb_probe(struct platform_device *pdev)
 	if (info->fb[HEAD_PANEL] == NULL &&
 	    info->fb[HEAD_CRT] == NULL) {
 		dev_err(dev, "no framebuffers found\n");
+		ret = -ENODEV;
 		goto err_alloc;
 	}
 
-- 
1.9.1

