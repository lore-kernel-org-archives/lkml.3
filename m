Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaI2Mmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:42:36 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:64928 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538AbaI2Mmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:42:33 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-53-542953b5d758
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Vinod Koul <vinod.koul@intel.com>, Dan Williams <dan.j.williams@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Michal Simek <michal.simek@xilinx.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [RESEND PATCH v2 1/4] dmaengine: pl330: Remove non-NULL check for
 pl330_submit_req parameters
Date: Mon, 29 Sep 2014 14:42:18 +0200
Message-id: <1411994541-31494-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrKJMWRmVeSWpSXmKPExsVy+t/xK7pbgzVDDB6tMLLYOGM9q8Xrf9NZ
	LKZPvcBosXrqXyD3haHF2aY37BZLJs9ntbi8aw6bxdojd9kt3r2MsHjZt5/Fgdtj8Z6XTB5L
	3hxi9fj49BaLR9+WVYwenzfJeez9/JslgC2KyyYlNSezLLVI3y6BK2Pz42dsBVe4KuaePc7Y
	wPiUo4uRk0NCwETi1em3rBC2mMSFe+vZuhi5OIQEljJKvHt4gRHC6WOS6Lj6khmkik3AWGLz
	8iVgVSICrUwSL2Z+YgFxmAWOMkpM733L1MXIwSEskCHx6FAEiMkioCqxbAIvSC+vgLvEvKmn
	2CC2yUmcPDaZdQIj9wJGhlWMoqmlyQXFSem5RnrFibnFpXnpesn5uZsYIUH1dQfj0mNWhxgF
	OBiVeHg5VmiECLEmlhVX5h5ilOBgVhLhtbPVDBHiTUmsrEotyo8vKs1JLT7EyMTBKdXAGFTw
	pC216pJNjiW/1J/tbDLiX2I1L3fG1BY02in3LBA89ztpUb6O73mPf7LB4eG3M/4YvDOOcdm5
	J4u1YeYKVcZk95mfbXIcdS/0NVo5rFt7YmMn28ZfYhkSE0pfeHMf7twUZ7pDvWzatY0NrD4h
	GbHliVd73s1U2fj+91dujWN7u6ZVPnmkxFKckWioxVxUnAgA4J0+RwgCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The pl330_submit_req() checked supplied 'struct pl330_thread thrd' and
'struct dma_pl330_desc desc' parameters for non-NULL. However these
checks are useless because supplied arguments won't be NULL.

The pl330_submit_req() is called in only one place and:
1. 'desc' is already dereferenced in fill_queue() before calling
   pl330_submit_req().
2. 'thrd' is always dereferenced after calling
   fill_queue()->pl330_submit_req().

Removing the checks for non-NULL values fixes following warning:
drivers/dma/pl330.c:1376 pl330_submit_req() warn: variable dereferenced before check 'thrd' (see line 1367)

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>

---

Changes since v1:
=================
1. Remove the checks for non-NULL completely instead of moving them
   before dereference. Suggested by Lars-Peter Clausen.
---
 drivers/dma/pl330.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index d5149aacd2fe..57049f84d0c0 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -1372,10 +1372,6 @@ static int pl330_submit_req(struct pl330_thread *thrd,
 	u32 ccr;
 	int ret = 0;
 
-	/* No Req or Unacquired Channel or DMAC */
-	if (!desc || !thrd || thrd->free)
-		return -EINVAL;
-
 	regs = thrd->dmac->base;
 
 	if (pl330->state == DYING
-- 
1.9.1

