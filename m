Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab3FQRde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:33:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50502 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab3FQRda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:33:30 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 34/84] dmaengine: ste_dma40: fix pm runtime ref counting
Date: Mon, 17 Jun 2013 10:30:38 -0700
Message-Id: <1371490288-23167-35-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin.vincent@stericsson.com>

commit 9ecb41bd8cf002fd8f3e063db4df81647ddd623c upstream.

The pm runtime reference counting of the driver is broken for the case
when there is more than one transfer queued, leading to the device being
runtime suspend while active.  Fix it.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
[ kamal: backport to 3.8 ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/dma/ste_dma40.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 23c5573..17459ad 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1392,10 +1392,12 @@ static void dma_tc_handle(struct d40_chan *d40c)
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
 	}
 
 	d40c->pending_tx++;
-- 
1.8.1.2

