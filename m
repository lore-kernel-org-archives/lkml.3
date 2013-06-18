Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab3FRMCs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 08:02:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56038 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755579Ab3FRLo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:26 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 33/93] dmaengine: ste_dma40: fix pm runtime ref counting
Date: Tue, 18 Jun 2013 12:42:41 +0100
Message-Id: <1371555821-12820-34-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin.vincent@stericsson.com>

commit 9ecb41bd8cf002fd8f3e063db4df81647ddd623c upstream.

The pm runtime reference counting of the driver is broken for the case
when there is more than one transfer queued, leading to the device being
runtime suspend while active.  Fix it.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
[ luis: backport to 3.5: adjust context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/dma/ste_dma40.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 000d309..aec952f 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1393,10 +1393,13 @@ static void dma_tc_handle(struct d40_chan *d40c)
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
+
 	}
 
 	d40c->pending_tx++;
-- 
1.8.1.2

