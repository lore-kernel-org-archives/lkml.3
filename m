Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751776AbaABMIN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:08:13 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:61645 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061AbaABMIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:08:10 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH, RFC 05/30] [media] omap_vout: avoid sleep_on race
Date: Thu,  2 Jan 2014 13:07:29 +0100
Message-Id: <1388664474-1710039-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
References: <1388664474-1710039-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:nKJiOIFltRHci2ICBJ6fs16+lbCLX+fET5irTXwn+i5
 xtWqMedH+tPeqqx9vtcEjs+UZEMO7twf6KgoISI4PgWV43wwGt
 1RmQf5OtjdiS/rPlXghfg65b9h8kIrEvbqPoNKNsO5tXWIx2XB
 aY4rGVuUpGjkzkAnfzQGEfFHFx4oB37JOL+plERJ55UaRf6D8J
 vqTQb3Lj/VK+MT6/Ue26R5813XHUNSvfxAHMrWGwTRGw8PsaTp
 nyz1FAhUNtq6S6mWuHHUTQWa7K0+HqwxH7a5XsPnzMbYRdWELo
 P9eC+7GwLLbBCNxXVCNYIYynjrrvxqO8i5ly3XdIe/UdFUBn3P
 3Ogj6BBi1flba6Sn9QGgIAcl2Fx4oZd1ALw7pEgJP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep_on and its variants are broken and going away soon. This changes
the omap vout driver to use interruptible_sleep_on_timeout instead,
which fixes potential race where the dma is complete before we
schedule.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Mauro Carvalho Chehab <m.chehab@samsung.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/platform/omap/omap_vout_vrfb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/omap/omap_vout_vrfb.c b/drivers/media/platform/omap/omap_vout_vrfb.c
index cf1c437..62e7e57 100644
--- a/drivers/media/platform/omap/omap_vout_vrfb.c
+++ b/drivers/media/platform/omap/omap_vout_vrfb.c
@@ -270,7 +270,8 @@ int omap_vout_prepare_vrfb(struct omap_vout_device *vout,
 	omap_dma_set_global_params(DMA_DEFAULT_ARB_RATE, 0x20, 0);
 
 	omap_start_dma(tx->dma_ch);
-	interruptible_sleep_on_timeout(&tx->wait, VRFB_TX_TIMEOUT);
+	wait_event_interruptible_timeout(tx->wait, tx->tx_status == 1,
+					 VRFB_TX_TIMEOUT);
 
 	if (tx->tx_status == 0) {
 		omap_stop_dma(tx->dma_ch);
-- 
1.8.3.2

