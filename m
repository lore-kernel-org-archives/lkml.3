Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240AbaBZLCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 06:02:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.130]:49946 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbaBZLCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 06:02:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org
Subject: [PATCH 05/16] [media] omap_vout: avoid sleep_on race
Date: Wed, 26 Feb 2014 12:01:45 +0100
Message-Id: <1393412516-3762435-6-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
References: <1393412516-3762435-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:4oSMKQGpcEFweb3lSl1smCtu0Fo33fe3vUqf2A8rosk
 0srvVuYrN/YnQY+sEakf7JWlEvSbfmaQhWClymO8grDJLdGmBq
 Mfmq6Yiff6MVgeG9wNRY0KvWxRA7VvinfEY4hlzlErJ2XWaGQt
 NsR8UqNzpRODmm37yIKaJwOzGvOMY3L5fE51jq7qSzHgYpfve4
 1wJtwRKyfy4+kGsvzX8zJS/UIJCwf9zrZ9oPEpVOVHNaXOBGrx
 HX7MfrJ/QeSR4ig0wb2+pkTtUhZIFiMxgmrQcggT44n4CDvRqj
 cqp8zRrRvOPYErwsvhhEr1SPz0+MCLrqzrg/LvwhfeAcHaiTEH
 MZ4BTIoZqDY1ttRyvutszO2UOv4YOJ/4YVchDn2fg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sleep_on and its variants are broken and going away soon. This changes
the omap vout driver to use interruptible_sleep_on_timeout instead,
which fixes potential race where the dma is complete before we
schedule.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Hans Verkuil <hans.verkuil@cisco.com>
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

