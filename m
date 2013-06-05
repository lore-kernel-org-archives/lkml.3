Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932788Ab3FEVfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 17:35:31 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37731 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932487Ab3FEVfW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 17:35:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Chan <mchan@broadcom.com>,
        Nithin Nayak Sujir <nsujir@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 038/127] tg3: Fix data corruption on 5725 with TSO
Date: Wed,  5 Jun 2013 14:33:25 -0700
Message-Id: <20130605213222.278113919@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130605213217.966891866@linuxfoundation.org>
References: <20130605213217.966891866@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Chan <mchan@broadcom.com>

commit 0f0d15100a8ac875bdd408324c473e16d73d3557 upstream.

The 5725 family of devices (asic rev 5762), corrupts TSO packets where
the buffer is within MSS bytes of a 4G boundary (4G, 8G etc.). Detect
this condition and trigger the workaround path.

Signed-off-by: Michael Chan <mchan@broadcom.com>
Signed-off-by: Nithin Nayak Sujir <nsujir@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/tg3.c |   17 +++++++++++++++++
 1 file changed, 17 insertions(+)

--- a/drivers/net/ethernet/broadcom/tg3.c
+++ b/drivers/net/ethernet/broadcom/tg3.c
@@ -7078,6 +7078,20 @@ static inline int tg3_4g_overflow_test(d
 	return (base > 0xffffdcc0) && (base + len + 8 < base);
 }
 
+/* Test for TSO DMA buffers that cross into regions which are within MSS bytes
+ * of any 4GB boundaries: 4G, 8G, etc
+ */
+static inline int tg3_4g_tso_overflow_test(struct tg3 *tp, dma_addr_t mapping,
+					   u32 len, u32 mss)
+{
+	if (tg3_asic_rev(tp) == ASIC_REV_5762 && mss) {
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
@@ -7114,6 +7128,9 @@ static bool tg3_tx_frag_set(struct tg3_n
 	if (tg3_4g_overflow_test(map, len))
 		hwbug = true;
 
+	if (tg3_4g_tso_overflow_test(tp, map, len, mss))
+		hwbug = true;
+
 	if (tg3_40bit_overflow_test(tp, map, len))
 		hwbug = true;
 


