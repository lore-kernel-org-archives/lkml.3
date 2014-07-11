Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747AbaGKMKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 08:10:37 -0400
Received: from mga09.intel.com ([134.134.136.24]:46586 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbaGKMIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 08:08:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,642,1400050800"; 
   d="scan'208";a="541990056"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Tadeusz Struk <tadeusz.struk@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Helge Deller <deller@gmx.de>,
        Ingo Tuchscherer <ingo.tuchscherer@de.ibm.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org,
        Joe Perches <joe@perches.com>, Marek Vasut <marex@denx.de>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v2 3/5] crypto: qat - use seq_hex_dump() to dump buffers
Date: Fri, 11 Jul 2014 15:08:44 +0300
Message-Id: <1405080526-6319-4-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <1405080526-6319-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1405080526-6319-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of custom approach let's use recently introduced seq_hex_dump() helper.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Tadeusz Struk <tadeusz.struk@intel.com>
---
 drivers/crypto/qat/qat_common/adf_transport_debug.c | 16 ++--------------
 1 file changed, 2 insertions(+), 14 deletions(-)

diff --git a/drivers/crypto/qat/qat_common/adf_transport_debug.c b/drivers/crypto/qat/qat_common/adf_transport_debug.c
index 6b69745..5f438a1 100644
--- a/drivers/crypto/qat/qat_common/adf_transport_debug.c
+++ b/drivers/crypto/qat/qat_common/adf_transport_debug.c
@@ -86,9 +86,7 @@ static int adf_ring_show(struct seq_file *sfile, void *v)
 {
 	struct adf_etr_ring_data *ring = sfile->private;
 	struct adf_etr_bank_data *bank = ring->bank;
-	uint32_t *msg = v;
 	void __iomem *csr = ring->bank->csr_addr;
-	int i, x;
 
 	if (v == SEQ_START_TOKEN) {
 		int head, tail, empty;
@@ -111,18 +109,8 @@ static int adf_ring_show(struct seq_file *sfile, void *v)
 		seq_puts(sfile, "----------- Ring data ------------\n");
 		return 0;
 	}
-	seq_printf(sfile, "%p:", msg);
-	x = 0;
-	i = 0;
-	for (; i < (ADF_MSG_SIZE_TO_BYTES(ring->msg_size) >> 2); i++) {
-		seq_printf(sfile, " %08X", *(msg + i));
-		if ((ADF_MSG_SIZE_TO_BYTES(ring->msg_size) >> 2) != i + 1 &&
-		    (++x == 8)) {
-			seq_printf(sfile, "\n%p:", msg + i + 1);
-			x = 0;
-		}
-	}
-	seq_puts(sfile, "\n");
+	seq_hex_dump(sfile, "", DUMP_PREFIX_ADDRESS, 32, 4,
+		     v, ADF_MSG_SIZE_TO_BYTES(ring->msg_size), false);
 	return 0;
 }
 
-- 
2.0.1

