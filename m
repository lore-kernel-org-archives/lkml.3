Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739Ab3A0M6u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 07:58:50 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:53398 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247Ab3A0M6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 07:58:49 -0500
Message-ID: <1359291524.11083.5.camel@phoenix>
Subject: [RFT][PATCH v2] backlight: 88pm860x_bl: Add missing of_node_put()
From: Axel Lin <axel.lin@ingics.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, linux-kernel@vger.kernel.org
Date: Sun, 27 Jan 2013 20:58:44 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

of_find_node_by_name() returns a node pointer with refcount incremented, use
of_node_put() on it when done.

of_find_node_by_name() will call of_node_put() against the node pass to from
parameter, thus we also need to call of_node_get(from) before calling
of_find_node_by_name().

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
v2:
need to call of_node_get(pdev->dev.parent->of_node) before calling
of_find_node_by_name().

 drivers/video/backlight/88pm860x_bl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/88pm860x_bl.c b/drivers/video/backlight/88pm860x_bl.c
index c072ed9..2cd6350 100644
--- a/drivers/video/backlight/88pm860x_bl.c
+++ b/drivers/video/backlight/88pm860x_bl.c
@@ -165,8 +165,10 @@ static int pm860x_backlight_dt_init(struct platform_device *pdev,
 				    struct pm860x_backlight_data *data,
 				    char *name)
 {
-	struct device_node *nproot = pdev->dev.parent->of_node, *np;
+	struct device_node *nproot, *np;
 	int iset = 0;
+
+	nproot = of_node_get(pdev->dev.parent->of_node);
 	if (!nproot)
 		return -ENODEV;
 	nproot = of_find_node_by_name(nproot, "backlights");
@@ -184,6 +186,7 @@ static int pm860x_backlight_dt_init(struct platform_device *pdev,
 			break;
 		}
 	}
+	of_node_put(nproot);
 	return 0;
 }
 #else
-- 
1.7.9.5



