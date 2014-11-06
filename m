Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751681AbaKFNEk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:04:40 -0500
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61565 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaKFNEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:04:37 -0500
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: Sudip Mukherjee <sudipm.mukherjee@gmail.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] media: davinci: vpbe: missing clk_put
Date: Thu,  6 Nov 2014 18:34:27 +0530
Message-Id: <1415279067-653-1-git-send-email-sudipm.mukherjee@gmail.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

we are getting struct clk using clk_get before calling
clk_prepare_enable. but if clk_prepare_enable fails, then we are
jumping to fail_mutex_unlock where we are just unlocking the mutex,
but we are not freeing the clock source.
this patch just adds a call to clk_put before jumping to
fail_mutex_unlock.

Signed-off-by: Sudip Mukherjee <sudip@vectorindia.org>
---
 drivers/media/platform/davinci/vpbe.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/platform/davinci/vpbe.c b/drivers/media/platform/davinci/vpbe.c
index 49d2de0..e5df991 100644
--- a/drivers/media/platform/davinci/vpbe.c
+++ b/drivers/media/platform/davinci/vpbe.c
@@ -625,6 +625,7 @@ static int vpbe_initialize(struct device *dev, struct vpbe_device *vpbe_dev)
 		}
 		if (clk_prepare_enable(vpbe_dev->dac_clk)) {
 			ret =  -ENODEV;
+			clk_put(vpbe_dev->dac_clk);
 			goto fail_mutex_unlock;
 		}
 	}
-- 
1.8.1.2

