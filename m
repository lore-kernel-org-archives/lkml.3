Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694Ab3E0OEQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 10:04:16 -0400
Received: from eu1sys200aog102.obsmtp.com ([207.126.144.113]:40016 "EHLO
	eu1sys200aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932537Ab3E0OEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 10:04:15 -0400
From: Rabin Vincent <rabin.vincent@stericsson.com>
To: <vinod.koul@intel.com>, <djbw@fb.com>
Cc: <linus.walleij@linaro.org>, <rabin@rab.in>, <linux-kernel@vger.kernel.org>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: [PATCH] dmaengine: ste_dma40: fix pm runtime ref counting
Date: Mon, 27 May 2013 16:03:40 +0200
Message-ID: <1369663420-3881-1-git-send-email-rabin.vincent@stericsson.com>
X-Mailer: git-send-email 1.8.1.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pm runtime reference counting of the driver is broken for the case
when there is more than one transfer queued, leading to the device being
runtime suspend while active.  Fix it.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
---
 drivers/dma/ste_dma40.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 1734fee..71bf4ec 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1566,10 +1566,12 @@ static void dma_tc_handle(struct d40_chan *d40c)
 			return;
 		}
 
-		if (d40_queue_start(d40c) == NULL)
+		if (d40_queue_start(d40c) == NULL) {
 			d40c->busy = false;
-		pm_runtime_mark_last_busy(d40c->base->dev);
-		pm_runtime_put_autosuspend(d40c->base->dev);
+
+			pm_runtime_mark_last_busy(d40c->base->dev);
+			pm_runtime_put_autosuspend(d40c->base->dev);
+		}
 
 		d40_desc_remove(d40d);
 		d40_desc_done(d40c, d40d);
-- 
1.8.1.5

