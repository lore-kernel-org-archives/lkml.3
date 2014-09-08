Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559AbaIHInW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 04:43:22 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:29000 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869AbaIHInN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 04:43:13 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-37-540d6c1ee436
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Lars-Peter Clausen <lars@metafoo.de>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH v2 1/4] dmaengine: pl330: Remove non-NULL check for
 pl330_submit_req parameters
Date: Mon, 08 Sep 2014 10:42:47 +0200
Message-id: <1410165770-4452-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMJMWRmVeSWpSXmKPExsVy+t/xy7pyObwhBree6lhsnLGe1WL61AuM
	Fqun/mW1eP3C0OJs0xt2iyWT57NaXN41h81i7ZG77BYv+/azOHB6LN7zksljyZtDrB59W1Yx
	enzeJBfAEsVlk5Kak1mWWqRvl8CVsfnxM7aCK1wVc88eZ2xgfMrRxcjBISFgInHpXXoXIyeQ
	KSZx4d56ti5GLg4hgaWMEn1rlrBAOH1MEoenXWMDqWITMJbYvHwJWJWIQCejxMfJJ1lBHGaB
	t4wSHw5vZgepEhZIlNjQPpcJxGYRUJXoXbWUBcTmFXCTuL/4OyvEPjmJk8cms05g5F7AyLCK
	UTS1NLmgOCk911CvODG3uDQvXS85P3cTIyRgvuxgXHzM6hCjAAejEg9vwlWeECHWxLLiytxD
	jBIczEoivAxhvCFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGEsZFvd+fsU/6/t23zkO9dGhursK
	HRPicsqlggXXrn9Zv2u/12UTF701297N1knYET8jhN1T7PYyk4mCsh/PqInbPgyplJx89HfS
	hJzr2xZcu7s/Q3fhp6jTXzYu3v/UPa+feZr1DL3DNjv2x5gsuduv9PPS8tknDXwunssSmSk2
	bR/XTsUjf74rsRRnJBpqMRcVJwIAlIRc0PYBAAA=
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

