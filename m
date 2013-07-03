Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965171Ab3GCTGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:06:32 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6261 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965012Ab3GCTA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:29 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=iEzd6U16YrgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=jEMl0_Aq3XwA:10 a=THCAyMpEAAAA:8 a=KKAkSRfTAAAA:8 a=VwQbUJbxAAAA:8 a=QyXUC8HyAAAA:8 a=fBeKd2HRWbP4T1pgm1MA:9 a=FCIOWvmKq0cA:10 a=WwgC8nHKvroA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184100.302588080@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Rabin Vincent <rabin.vincent@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vinod Koul <vinod.koul@intel.com>
Subject: [091/141] dmaengine: ste_dma40: fix pm runtime ref counting
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0091-dmaengine-ste_dma40-fix-pm-runtime-ref-counting.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Rabin Vincent <rabin.vincent@stericsson.com>

[ Upstream commit 9ecb41bd8cf002fd8f3e063db4df81647ddd623c ]

The pm runtime reference counting of the driver is broken for the case
when there is more than one transfer queued, leading to the device being
runtime suspend while active.  Fix it.

Signed-off-by: Rabin Vincent <rabin.vincent@stericsson.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Cc: stable@vger.kernel.org
Signed-off-by: Vinod Koul <vinod.koul@intel.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/dma/ste_dma40.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 000d309..6a68d5a 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -1393,10 +1393,12 @@ static void dma_tc_handle(struct d40_chan *d40c)
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
1.7.10.4


