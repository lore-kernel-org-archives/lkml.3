Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755597Ab3HRCrO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:47:14 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33939 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754360Ab3HRCni (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:38 -0400
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
Subject: [PATCH v2 03/14] crypto: omap-aes: Populate number of SG elements
Date: Sat, 17 Aug 2013 21:42:24 -0500
Message-ID: <1376793755-30478-4-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crypto layer only passes nbytes but number of SG elements is needed for mapping
or unmapping SGs at one time using dma_map* API and also needed to pass in for
dmaengine prep function.

We call function added to scatterwalk for this purpose in omap_aes_handle_queue
to populate the values which are used later.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 drivers/crypto/omap-aes.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/crypto/omap-aes.c b/drivers/crypto/omap-aes.c
index 26b802b..e369e6e 100644
--- a/drivers/crypto/omap-aes.c
+++ b/drivers/crypto/omap-aes.c
@@ -164,6 +164,8 @@ struct omap_aes_dev {
 	void			*buf_out;
 	int			dma_out;
 	struct dma_chan		*dma_lch_out;
+	int			in_sg_len;
+	int			out_sg_len;
 	dma_addr_t		dma_addr_out;
 
 	const struct omap_aes_pdata	*pdata;
@@ -731,6 +733,10 @@ static int omap_aes_handle_queue(struct omap_aes_dev *dd,
 	dd->out_offset = 0;
 	dd->out_sg = req->dst;
 
+	dd->in_sg_len = scatterwalk_bytes_sglen(dd->in_sg, dd->total);
+	dd->out_sg_len = scatterwalk_bytes_sglen(dd->out_sg, dd->total);
+	BUG_ON(dd->in_sg_len < 0 || dd->out_sg_len < 0);
+
 	rctx = ablkcipher_request_ctx(req);
 	ctx = crypto_ablkcipher_ctx(crypto_ablkcipher_reqtfm(req));
 	rctx->mode &= FLAGS_MODE_MASK;
-- 
1.7.9.5

