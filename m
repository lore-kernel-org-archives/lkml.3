Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab3LMTXD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 14:23:03 -0500
Received: from mail-ea0-f171.google.com ([209.85.215.171]:47307 "EHLO
	mail-ea0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753489Ab3LMTXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 14:23:00 -0500
From: Levente Kurusa <levex@linux.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Levente Kurusa <levex@linux.com>, Jingoo Han <jg1.han@samsung.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org
Subject: [PATCH 3/4] backlight: lcd: call put_device if device_register fails
Date: Fri, 13 Dec 2013 20:22:36 +0100
Message-Id: <1386962557-8899-4-git-send-email-levex@linux.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1386962557-8899-1-git-send-email-levex@linux.com>
References: <1386962557-8899-1-git-send-email-levex@linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently we kfree the container of the device which failed to register.
This is wrong as the last reference is not given up with a put_device
call. Also, now that we have put_device() callen, we no longer need
the kfree as the new_ld->dev.release function will take care of kfreeing
the associated memory.

Signed-off-by: Levente Kurusa <levex@linux.com>
---
 drivers/video/backlight/lcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/backlight/lcd.c b/drivers/video/backlight/lcd.c
index 93cf15e..7de847d 100644
--- a/drivers/video/backlight/lcd.c
+++ b/drivers/video/backlight/lcd.c
@@ -228,7 +228,7 @@ struct lcd_device *lcd_device_register(const char *name, struct device *parent,
 
 	rc = device_register(&new_ld->dev);
 	if (rc) {
-		kfree(new_ld);
+		put_device(&new_ld->dev);
 		return ERR_PTR(rc);
 	}
 
-- 
1.8.3.1

