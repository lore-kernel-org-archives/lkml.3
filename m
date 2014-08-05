Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaHESQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 14:16:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52608 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755477AbaHESQD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 14:16:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Arnaud Ebalard <arno@natisbad.org>, Willy Tarreau <w@1wt.eu>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 23/27] net: mvneta: add missing bit descriptions for interrupt masks and causes
Date: Tue,  5 Aug 2014 11:14:15 -0700
Message-Id: <20140805181344.951231218@linuxfoundation.org>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <20140805181344.268039690@linuxfoundation.org>
References: <20140805181344.268039690@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: willy tarreau <w@1wt.eu>

commit 40ba35e74fa56866918d2f3bc0528b5b92725d5e upstream.

Marvell has not published the chip's datasheet yet, so it's very hard
to find the relevant bits to manipulate to change the IRQ behaviour.
Fortunately, these bits are described in the proprietary LSP patch set
which is publicly available here :

    http://www.plugcomputer.org/downloads/mirabox/

So let's put them back in the driver in order to reduce the burden of
current and future maintenance.

Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Gregory CLEMENT <gregory.clement@free-electrons.com>
Tested-by: Arnaud Ebalard <arno@natisbad.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/marvell/mvneta.c |   44 ++++++++++++++++++++++++++++++++--
 1 file changed, 42 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/marvell/mvneta.c
+++ b/drivers/net/ethernet/marvell/mvneta.c
@@ -99,16 +99,56 @@
 #define      MVNETA_CPU_RXQ_ACCESS_ALL_MASK      0x000000ff
 #define      MVNETA_CPU_TXQ_ACCESS_ALL_MASK      0x0000ff00
 #define MVNETA_RXQ_TIME_COAL_REG(q)              (0x2580 + ((q) << 2))
+
+/* Exception Interrupt Port/Queue Cause register */
+
 #define MVNETA_INTR_NEW_CAUSE                    0x25a0
-#define      MVNETA_RX_INTR_MASK(nr_rxqs)        (((1 << nr_rxqs) - 1) << 8)
 #define MVNETA_INTR_NEW_MASK                     0x25a4
+
+/* bits  0..7  = TXQ SENT, one bit per queue.
+ * bits  8..15 = RXQ OCCUP, one bit per queue.
+ * bits 16..23 = RXQ FREE, one bit per queue.
+ * bit  29 = OLD_REG_SUM, see old reg ?
+ * bit  30 = TX_ERR_SUM, one bit for 4 ports
+ * bit  31 = MISC_SUM,   one bit for 4 ports
+ */
+#define      MVNETA_TX_INTR_MASK(nr_txqs)        (((1 << nr_txqs) - 1) << 0)
+#define      MVNETA_TX_INTR_MASK_ALL             (0xff << 0)
+#define      MVNETA_RX_INTR_MASK(nr_rxqs)        (((1 << nr_rxqs) - 1) << 8)
+#define      MVNETA_RX_INTR_MASK_ALL             (0xff << 8)
+
 #define MVNETA_INTR_OLD_CAUSE                    0x25a8
 #define MVNETA_INTR_OLD_MASK                     0x25ac
+
+/* Data Path Port/Queue Cause Register */
 #define MVNETA_INTR_MISC_CAUSE                   0x25b0
 #define MVNETA_INTR_MISC_MASK                    0x25b4
+
+#define      MVNETA_CAUSE_PHY_STATUS_CHANGE      BIT(0)
+#define      MVNETA_CAUSE_LINK_CHANGE            BIT(1)
+#define      MVNETA_CAUSE_PTP                    BIT(4)
+
+#define      MVNETA_CAUSE_INTERNAL_ADDR_ERR      BIT(7)
+#define      MVNETA_CAUSE_RX_OVERRUN             BIT(8)
+#define      MVNETA_CAUSE_RX_CRC_ERROR           BIT(9)
+#define      MVNETA_CAUSE_RX_LARGE_PKT           BIT(10)
+#define      MVNETA_CAUSE_TX_UNDERUN             BIT(11)
+#define      MVNETA_CAUSE_PRBS_ERR               BIT(12)
+#define      MVNETA_CAUSE_PSC_SYNC_CHANGE        BIT(13)
+#define      MVNETA_CAUSE_SERDES_SYNC_ERR        BIT(14)
+
+#define      MVNETA_CAUSE_BMU_ALLOC_ERR_SHIFT    16
+#define      MVNETA_CAUSE_BMU_ALLOC_ERR_ALL_MASK   (0xF << MVNETA_CAUSE_BMU_ALLOC_ERR_SHIFT)
+#define      MVNETA_CAUSE_BMU_ALLOC_ERR_MASK(pool) (1 << (MVNETA_CAUSE_BMU_ALLOC_ERR_SHIFT + (pool)))
+
+#define      MVNETA_CAUSE_TXQ_ERROR_SHIFT        24
+#define      MVNETA_CAUSE_TXQ_ERROR_ALL_MASK     (0xFF << MVNETA_CAUSE_TXQ_ERROR_SHIFT)
+#define      MVNETA_CAUSE_TXQ_ERROR_MASK(q)      (1 << (MVNETA_CAUSE_TXQ_ERROR_SHIFT + (q)))
+
 #define MVNETA_INTR_ENABLE                       0x25b8
 #define      MVNETA_TXQ_INTR_ENABLE_ALL_MASK     0x0000ff00
-#define      MVNETA_RXQ_INTR_ENABLE_ALL_MASK     0xff000000
+#define      MVNETA_RXQ_INTR_ENABLE_ALL_MASK     0xff000000  // note: neta says it's 0x000000FF
+
 #define MVNETA_RXQ_CMD                           0x2680
 #define      MVNETA_RXQ_DISABLE_SHIFT            8
 #define      MVNETA_RXQ_ENABLE_MASK              0x000000ff


