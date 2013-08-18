Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab3HRCng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 22:43:36 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:53612 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752947Ab3HRCnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 22:43:33 -0400
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
Subject: [PATCH v2 01/14] crypto: scatterwalk:  Add support for calculating number of SG elements
Date: Sat, 17 Aug 2013 21:42:22 -0500
Message-ID: <1376793755-30478-2-git-send-email-joelf@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1376793755-30478-1-git-send-email-joelf@ti.com>
References: <1376793755-30478-1-git-send-email-joelf@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Crypto layer only passes nbytes to encrypt but in omap-aes driver we need to
know number of SG elements to pass to dmaengine slave API.  We add function for
the same to scatterwalk library.

Signed-off-by: Joel Fernandes <joelf@ti.com>
---
 crypto/scatterwalk.c         |   22 ++++++++++++++++++++++
 include/crypto/scatterwalk.h |    2 ++
 2 files changed, 24 insertions(+)

diff --git a/crypto/scatterwalk.c b/crypto/scatterwalk.c
index 7281b8a..79ca227 100644
--- a/crypto/scatterwalk.c
+++ b/crypto/scatterwalk.c
@@ -124,3 +124,25 @@ void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 	scatterwalk_done(&walk, out, 0);
 }
 EXPORT_SYMBOL_GPL(scatterwalk_map_and_copy);
+
+int scatterwalk_bytes_sglen(struct scatterlist *sg, int num_bytes)
+{
+	int offset = 0, n = 0;
+
+	/* num_bytes is too small */
+	if (num_bytes < sg->length)
+		return -1;
+
+	do {
+		offset += sg->length;
+		n++;
+		sg = scatterwalk_sg_next(sg);
+
+		/* num_bytes is too large */
+		if (unlikely(!sg && (num_bytes < offset)))
+			return -1;
+	} while (sg && (num_bytes > offset));
+
+	return n;
+}
+EXPORT_SYMBOL_GPL(scatterwalk_bytes_sglen);
diff --git a/include/crypto/scatterwalk.h b/include/crypto/scatterwalk.h
index 3744d2a..13621cc 100644
--- a/include/crypto/scatterwalk.h
+++ b/include/crypto/scatterwalk.h
@@ -113,4 +113,6 @@ void scatterwalk_done(struct scatter_walk *walk, int out, int more);
 void scatterwalk_map_and_copy(void *buf, struct scatterlist *sg,
 			      unsigned int start, unsigned int nbytes, int out);
 
+int scatterwalk_bytes_sglen(struct scatterlist *sg, int num_bytes);
+
 #endif  /* _CRYPTO_SCATTERWALK_H */
-- 
1.7.9.5

