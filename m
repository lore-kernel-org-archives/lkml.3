Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933586Ab3HNXPA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 19:15:00 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:58124 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933514Ab3HNXNp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 19:13:45 -0400
From: Joel Fernandes <joelf@ti.com>
To: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Greer <mgreer@animalcreek.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Lokesh Vutla <lokeshvutla@ti.com>
CC: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Joel Fernandes <joelf@ti.com>
Subject: [PATCH 05/10] crypto: omap-aes: Sync SG before DMA operation
Date: Wed, 14 Aug 2013 18:12:44 -0500
Message-ID: <1376521969-16807-6-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376521969-16807-1-git-send-email-joelf@ti.com>
References: <1376521969-16807-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Earlier functions that did a similar sync are replaced by
the dma_sync_sg_* which can operate on entire SG list.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 9104a7f..df2f867 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -499,6 +499,8 @@ static int omap_aes_crypt_dma(struct crypto_tfm *tfm,
 	struct dma_slave_config cfg;
 	int ret;
 
+	dma_sync_sg_for_device(dd->dev, dd->in_sg, in_sg_len, DMA_TO_DEVICE);
+
 	memset(&cfg, 0, sizeof(cfg));
 
 	cfg.src_addr = dd->phys_base + AES_REG_DATA_N(dd, 0);
@@ -686,6 +688,8 @@ static void omap_aes_done_task(unsigned long data)
 
 	pr_debug("enter done_task\n");
 
+	dma_sync_sg_for_cpu(dd->dev, dd->in_sg, dd->in_sg_len, DMA_FROM_DEVICE);
+
 	omap_aes_crypt_dma_stop(dd);
 	omap_aes_finish_req(dd, 0);
 	omap_aes_handle_queue(dd, NULL);
-- 
1.7.9.5

