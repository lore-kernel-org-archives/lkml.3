Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab3GTSFJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 14:05:09 -0400
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:56906 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753901Ab3GTSFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 14:05:08 -0400
Message-ID: <1374343505.15242.12.camel@x61.thuisdomein>
Subject: [PATCH v2] ioatdma: silence GCC warnings
From: Paul Bolle <pebolle@tiscali.nl>
To: Dan Williams <djbw@fb.com>, Vinod Koul <vinod.koul@intel.com>
Cc: Dave Jiang <dave.jiang@intel.com>, linux-kernel@vger.kernel.org
Date: Sat, 20 Jul 2013 20:05:05 +0200
In-Reply-To: <1374147757.26384.49.camel@x61.thuisdomein>
References: <1371465315.26299.17.camel@x61.thuisdomein>
	 <CAA9_cmc9XWCvU=d2qu6rMaV+_sxBeMgrreZWU5ofzAd3dANT9w@mail.gmail.com>
	 <1374147757.26384.49.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 20 Jul 2013 18:05:05.0890 (UTC) FILETIME=[A9EC6C20:01CE8573]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building dma_v3.o triggers a GCC warning:
    drivers/dma/ioat/dma_v3.c: In function ‘__ioat3_prep_pq16_lock’:
    drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]
    drivers/dma/ioat/dma_v3.c:264:11: warning: array subscript is below array bounds [-Warray-bounds]

This warning is caused by pq16_set_src(). It uses "int idx" as an index
to an eight element array. Changing "idx" to "unsigned" silences this
warning. Apparently GCC can then determine that "idx" will never be
negative.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) v2: cut back to a one hunk change, as Dan suggested.

1) Still just compile tested.

 drivers/dma/ioat/dma_v3.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/ioat/dma_v3.c b/drivers/dma/ioat/dma_v3.c
index b642e03..2bb4601 100644
--- a/drivers/dma/ioat/dma_v3.c
+++ b/drivers/dma/ioat/dma_v3.c
@@ -251,7 +251,7 @@ static bool is_bwd_noraid(struct pci_dev *pdev)
 }
 
 static void pq16_set_src(struct ioat_raw_descriptor *desc[3],
-			dma_addr_t addr, u32 offset, u8 coef, int idx)
+			dma_addr_t addr, u32 offset, u8 coef, unsigned idx)
 {
 	struct ioat_pq_descriptor *pq = (struct ioat_pq_descriptor *)desc[0];
 	struct ioat_pq16a_descriptor *pq16 =
-- 
1.8.1.4

