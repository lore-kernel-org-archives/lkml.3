Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753459Ab3LMXQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 18:16:21 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58358 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab3LMXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 18:16:19 -0500
From: Linus Walleij <linus.walleij@linaro.org>
To: Vinod Koul <vinod.koul@intel.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Alban Bedel <alban.bedel@avionic-design.de>,
        Tomasz Figa <tomasz.figa@gmail.com>
Subject: [PATCH 1/2] dma: pl08x: fix descriptor unmapping
Date: Sat, 14 Dec 2013 00:16:07 +0100
Message-Id: <1386976567-31343-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The descriptor unmapping code introduced in commit
d38a8c622a1b3 "dmaengine: prepare for generic 'unmap' data"
accidentally affects a local struct rather than the
async TX descriptor, resulting in this compile error:

  CC      drivers/dma/amba-pl08x.o
drivers/dma/amba-pl08x.c: In function ‘pl08x_desc_free’:
drivers/dma/amba-pl08x.c:1172:2: warning: passing argument 1 of
‘dma_descriptor_unmap’ from incompatible pointer type [enabled by default]
In file included from linux/include/linux/amba/pl08x.h:21:0,
                 from linux/drivers/dma/amba-pl08x.c:79:
linux/include/linux/dmaengine.h:476:20: note: expected
‘struct dma_async_tx_descriptor *’ but argument is of type ‘struct pl08x_txd *’

Cc: stable@vger.kernel.org
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Alban Bedel <alban.bedel@avionic-design.de>
Cc: Tomasz Figa <tomasz.figa@gmail.com>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 drivers/dma/amba-pl08x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/amba-pl08x.c b/drivers/dma/amba-pl08x.c
index 16a2aa28f856..ec4ee5c1fe9d 100644
--- a/drivers/dma/amba-pl08x.c
+++ b/drivers/dma/amba-pl08x.c
@@ -1169,7 +1169,7 @@ static void pl08x_desc_free(struct virt_dma_desc *vd)
 	struct pl08x_txd *txd = to_pl08x_txd(&vd->tx);
 	struct pl08x_dma_chan *plchan = to_pl08x_chan(vd->tx.chan);
 
-	dma_descriptor_unmap(txd);
+	dma_descriptor_unmap(&vd->tx);
 	if (!txd->done)
 		pl08x_release_mux(plchan);
 
-- 
1.8.3.1

