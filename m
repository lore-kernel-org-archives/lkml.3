Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaKMQ1c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 11:27:32 -0500
Received: from smarthost01d.mail.zen.net.uk ([212.23.1.7]:55721 "EHLO
	smarthost01d.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753928AbaKMQ1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 11:27:31 -0500
X-Greylist: delayed 22075 seconds by postgrey-1.27 at vger.kernel.org; Thu, 13 Nov 2014 11:27:31 EST
Message-ID: <1415896047.1787.4.camel@linaro.org>
Subject: [PATCH] dmaengine: pl330: Fix linker error "undefined reference to
 `__aeabi_uldivmod'"
From: "Jon Medhurst (Tixy)" <tixy@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 13 Nov 2014 16:27:27 +0000
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-smarthost01d-IP: [82.69.122.217]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

32-bit ARM kernels may have a 64-bit dma_addr_t but have no
implementation of the compiler helper for 64-bit unsigned division,
therefore the use of the modulo operator in pl330_prep_dma_memcpy causes
the link error "undefined reference to `__aeabi_uldivmod'"

As the burst value is always a power of two we can fix the problem, and
make the code more efficient, by replacing "% burst" with "& (burst-1)".

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Jon Medhurst <tixy@linaro.org>
---

Vinod. I haven't added a 'Fixes:' line because I was unsure if the patch
in linux-next is part of a stable branch or if the SHA1 might change
before hitting mainline. If it stable then the line should be...

Fixes: 63369d0a96dc ("dmaengine: pl330: Align DMA memcpy operations to MFIFO width")


 drivers/dma/pl330.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/dma/pl330.c b/drivers/dma/pl330.c
index 38c9617..52c4c62 100644
--- a/drivers/dma/pl330.c
+++ b/drivers/dma/pl330.c
@@ -2464,11 +2464,8 @@ pl330_prep_dma_memcpy(struct dma_chan *chan, dma_addr_t dst,
 	 * parameters because our DMA programming algorithm doesn't cope with
 	 * transfers which straddle an entry in the DMA device's MFIFO.
 	 */
-	while (burst > 1) {
-		if (!((src | dst | len) % burst))
-			break;
+	while ((src | dst | len) & (burst - 1))
 		burst /= 2;
-	}
 
 	desc->rqcfg.brst_size = 0;
 	while (burst != (1 << desc->rqcfg.brst_size))
-- 
2.1.1


