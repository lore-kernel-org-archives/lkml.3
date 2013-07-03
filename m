Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933271Ab3GCS45 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:56:57 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28058 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933198Ab3GCSky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:40:54 -0400
X-Authority-Analysis: v=2.0 cv=Du3UCRD+ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=WwWSySzPPhEA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=iPAFudzbcycA:10 a=Q-fNiiVtAAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=pQFG53Joc4AfjvbZiugA:9 a=lcTMV_K9oDIA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184047.783976613@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:39:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Michael Chan <mchan@broadcom.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [019/141] tg3: Fix data corruption on 5725 with TSO
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0019-tg3-Fix-data-corruption-on-5725-with-TSO.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

[ Upstream commit 0f0d15100a8ac875bdd408324c473e16d73d3557 ]

The 5725 family of devices (asic rev 5762), corrupts TSO packets where
the buffer is within MSS bytes of a 4G boundary (4G, 8G etc.). Detect
this condition and trigger the workaround path.

Cc: <stable@vger.kernel.org>
Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/net/ethernet/broadcom/tg3.c |   17 +++++++++++++++++
 drivers/net/ethernet/broadcom/tg3.h |    1 +
 2 files changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/tg3.c b/drivers/net/ethernet/broadcom/tg3.c
index f0f26b0..1e7f1a8 100644
--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -6772,6 +6772,20 @@ static inline int tg3_4g_overflow_test(dma_addr_t mapping, int len)
 	return (base > 0xffffdcc0) && (base + len + 8 < base);
 }
 
+/* Test for TSO DMA buffers that cross into regions which are within MSS bytes
+ * of any 4GB boundaries: 4G, 8G, etc
+ */
+static inline int tg3_4g_tso_overflow_test(struct tg3 *tp, dma_addr_t mapping,
+					   u32 len, u32 mss)
+{
+	if (GET_ASIC_REV(tp->pci_chip_rev_id) == ASIC_REV_5762 && mss) {
+		u32 base = (u32) mapping & 0xffffffff;
+
+		return ((base + len + (mss & 0x3fff)) < base);
+	}
+	return 0;
+}
+
 /* Test for DMA addresses > 40-bit */
 static inline int tg3_40bit_overflow_test(struct tg3 *tp, dma_addr_t mapping,
 					  int len)
@@ -6808,6 +6822,9 @@ static bool tg3_tx_frag_set(struct tg3_napi *tnapi, u32 *entry, u32 *budget,
 	if (tg3_4g_overflow_test(map, len))
 		hwbug = true;
 
+	if (tg3_4g_tso_overflow_test(tp, map, len, mss))
+		hwbug = true;
+
 	if (tg3_40bit_overflow_test(tp, map, len))
 		hwbug = true;
 
diff --git a/drivers/net/ethernet/broadcom/tg3.h b/drivers/net/ethernet/broadcom/tg3.h
index 3a58339..0f8e583 100644
--- a/drivers/net/ethernet/broadcom/tg3.h
+++ b/drivers/net/ethernet/broadcom/tg3.h
@@ -168,6 +168,7 @@
 #define   ASIC_REV_USE_PROD_ID_REG	 0x0f
 #define   ASIC_REV_5784			 0x5784
 #define   ASIC_REV_5761			 0x5761
+#define   ASIC_REV_5762			 0x5762
 #define   ASIC_REV_5785			 0x5785
 #define   ASIC_REV_57780		 0x57780
 #define   ASIC_REV_5717			 0x5717
-- 
1.7.10.4


