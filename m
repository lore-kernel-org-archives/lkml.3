Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769AbaEMJpb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 05:45:31 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60869 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760095AbaEMJ24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 05:28:56 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Antoine=20T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 088/182] video: atmel_lcdfb: ensure the hardware is initialized with the correct mode
Date: Tue, 13 May 2014 11:27:20 +0200
Message-Id: <c3552f715cd1b5eb287956dd80f6d04e043e5d6c.1399973152.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
References: <7aa1bde8f6143b2db33e6567a8c3a4debaa246f4.1399973152.git.jslaby@suse.cz>
In-Reply-To: <cover.1399973152.git.jslaby@suse.cz>
References: <cover.1399973152.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Antoine Ténart <antoine.tenart@free-electrons.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 7d3477d801808a5037a511cf5a5aae5718e7ecce upstream.

If no driver takeover the atmel_lcdfb, the lcd won't be in a working state
since atmel_lcdfb_set_par() will never be called. Enabling a driver which does,
like fbcon, will call the function and put atmel_lcdfb in a working state.

Fixes: b985172b328a (video: atmel_lcdfb: add device tree suport)

Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
Reported-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Alexandre Belloni <alexandre.belloni@free-electrons.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/video/atmel_lcdfb.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/video/atmel_lcdfb.c b/drivers/video/atmel_lcdfb.c
index 088511a58a26..0aca4e6b2871 100644
--- a/drivers/video/atmel_lcdfb.c
+++ b/drivers/video/atmel_lcdfb.c
@@ -1081,6 +1081,12 @@ static int __init atmel_lcdfb_probe(struct platform_device *pdev)
 		goto free_cmap;
 	}
 
+	ret = atmel_lcdfb_set_par(info);
+	if (ret < 0) {
+		dev_err(dev, "set par failed: %d\n", ret);
+		goto unregister_irqs;
+	}
+
 	dev_set_drvdata(dev, info);
 
 	/*
-- 
1.9.3

