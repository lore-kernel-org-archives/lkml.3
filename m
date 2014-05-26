Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751877AbaEZSev (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 14:34:51 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:44951 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751461AbaEZSet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 14:34:49 -0400
Message-ID: <1401129279.24099.23.camel@localhost.localdomain>
Subject: [PATCH 2/2] emac: aggregation of v1-2 PLB errors for IER register
From: Ivan Mikhaylov <ivan@ru.ibm.com>
To: netdev@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Alistair Popple <alistair@popple.id.au>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>
Date: Mon, 26 May 2014 22:34:39 +0400
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052618-0928-0000-0000-0000022E3628
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aggreagation of version 1-2 because of version 1 can hit
PLB errors too. If it's not set so we missing events for PLB bits
and driver can't process those interrupts.

Signed-off-by: Ivan Mikhaylov <ivan@ru.ibm.com>

---
 drivers/net/ethernet/ibm/emac/mal.c |  5 +----
 drivers/net/ethernet/ibm/emac/mal.h | 20 ++++++++------------
 2 files changed, 9 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/ibm/emac/mal.c b/drivers/net/ethernet/ibm/emac/mal.c
index 9d75fef..63eb959 100644
--- a/drivers/net/ethernet/ibm/emac/mal.c
+++ b/drivers/net/ethernet/ibm/emac/mal.c
@@ -682,10 +682,7 @@ static int mal_probe(struct platform_device *ofdev)
 		goto fail6;
 
 	/* Enable all MAL SERR interrupt sources */
-	if (mal->version == 2)
-		set_mal_dcrn(mal, MAL_IER, MAL2_IER_EVENTS);
-	else
-		set_mal_dcrn(mal, MAL_IER, MAL1_IER_EVENTS);
+	set_mal_dcrn(mal, MAL_IER, MAL_IER_EVENTS);
 
 	/* Enable EOB interrupt */
 	mal_enable_eob_irq(mal);
diff --git a/drivers/net/ethernet/ibm/emac/mal.h b/drivers/net/ethernet/ibm/emac/mal.h
index e431a32..eeade2e 100644
--- a/drivers/net/ethernet/ibm/emac/mal.h
+++ b/drivers/net/ethernet/ibm/emac/mal.h
@@ -95,24 +95,20 @@
 
 
 #define MAL_IER			0x02
+/* MAL IER bits */
 #define   MAL_IER_DE		0x00000010
 #define   MAL_IER_OTE		0x00000004
 #define   MAL_IER_OE		0x00000002
 #define   MAL_IER_PE		0x00000001
-/* MAL V1 IER bits */
-#define   MAL1_IER_NWE		0x00000008
-#define   MAL1_IER_SOC_EVENTS	MAL1_IER_NWE
-#define   MAL1_IER_EVENTS	(MAL1_IER_SOC_EVENTS | MAL_IER_DE | \
-				 MAL_IER_OTE | MAL_IER_OE | MAL_IER_PE)
 
-/* MAL V2 IER bits */
-#define   MAL2_IER_PT		0x00000080
-#define   MAL2_IER_PRE		0x00000040
-#define   MAL2_IER_PWE		0x00000020
-#define   MAL2_IER_SOC_EVENTS	(MAL2_IER_PT | MAL2_IER_PRE | MAL2_IER_PWE)
-#define   MAL2_IER_EVENTS	(MAL2_IER_SOC_EVENTS | MAL_IER_DE | \
-				 MAL_IER_OTE | MAL_IER_OE | MAL_IER_PE)
+/* PLB read/write/timeout errors */
+#define   MAL_IER_PTE		0x00000080
+#define   MAL_IER_PRE		0x00000040
+#define   MAL_IER_PWE		0x00000020
 
+#define   MAL_IER_SOC_EVENTS	(MAL_IER_PTE | MAL_IER_PRE | MAL_IER_PWE)
+#define   MAL_IER_EVENTS	(MAL_IER_SOC_EVENTS | MAL_IER_DE | \
+				 MAL_IER_OTE | MAL_IER_OE | MAL_IER_PE)
 
 #define MAL_TXCASR		0x04
 #define MAL_TXCARR		0x05
-- 
1.9.3



