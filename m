Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758443Ab3JKKya (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:54:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58683 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758008Ab3JKKnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:43:46 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Claudiu Manoil <claudiu.manoil@freescale.com>,
        "David S. Miller" <davem@davemloft.net>,
        Christian Engelmayer <christian.engelmayer@frequentis.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 066/100] gianfar: Change default HW Tx queue scheduling mode
Date: Fri, 11 Oct 2013 11:41:36 +0100
Message-Id: <1381488130-30235-67-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
References: <1381488130-30235-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.23 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Manoil <claudiu.manoil@freescale.com>

commit b98b8babd6e3370fadb7c6eaacb00eb2f6344a6c upstream.

This is primarily to address transmission timeout occurrences, when
multiple H/W Tx queues are being used concurrently. Because in
the priority scheduling mode the controller does not service the
Tx queues equally (but in ascending index order), Tx timeouts are
being triggered rightaway for a basic test with multiple simultaneous
connections like:
iperf -c <server_ip> -n 100M -P 8

resulting in kernel trace:
NETDEV WATCHDOG: eth1 (fsl-gianfar): transmit queue <X> timed out
------------[ cut here ]------------
WARNING: at net/sched/sch_generic.c:255
...
and controller reset during intense traffic, and possibly further
complications.

This patch changes the default H/W Tx scheduling setting (TXSCHED)
for multi-queue devices, from priority scheduling mode to a weighted
round robin mode with equal weights for all H/W Tx queues, and
addresses the issue above.

Signed-off-by: Claudiu Manoil <claudiu.manoil@freescale.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Christian Engelmayer <christian.engelmayer@frequentis.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 11 ++++++++++-
 drivers/net/ethernet/freescale/gianfar.h | 11 ++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index ccc2b3b..285049f 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -394,7 +394,13 @@ static void gfar_init_mac(struct net_device *ndev)
 	if (ndev->features & NETIF_F_IP_CSUM)
 		tctrl |= TCTRL_INIT_CSUM;
 
-	tctrl |= TCTRL_TXSCHED_PRIO;
+	if (priv->prio_sched_en)
+		tctrl |= TCTRL_TXSCHED_PRIO;
+	else {
+		tctrl |= TCTRL_TXSCHED_WRRS;
+		gfar_write(&regs->tr03wt, DEFAULT_WRRS_WEIGHT);
+		gfar_write(&regs->tr47wt, DEFAULT_WRRS_WEIGHT);
+	}
 
 	gfar_write(&regs->tctrl, tctrl);
 
@@ -1153,6 +1159,9 @@ static int gfar_probe(struct platform_device *ofdev)
 	priv->rx_filer_enable = 1;
 	/* Enable most messages by default */
 	priv->msg_enable = (NETIF_MSG_IFUP << 1 ) - 1;
+	/* use pritority h/w tx queue scheduling for single queue devices */
+	if (priv->num_tx_queues == 1)
+		priv->prio_sched_en = 1;
 
 	/* Carrier starts down, phylib will bring it up */
 	netif_carrier_off(dev);
diff --git a/drivers/net/ethernet/freescale/gianfar.h b/drivers/net/ethernet/freescale/gianfar.h
index 27d8aeb..22eabc1 100644
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -301,8 +301,16 @@ extern const char gfar_driver_version[];
 #define TCTRL_TFCPAUSE		0x00000008
 #define TCTRL_TXSCHED_MASK	0x00000006
 #define TCTRL_TXSCHED_INIT	0x00000000
+/* priority scheduling */
 #define TCTRL_TXSCHED_PRIO	0x00000002
+/* weighted round-robin scheduling (WRRS) */
 #define TCTRL_TXSCHED_WRRS	0x00000004
+/* default WRRS weight and policy setting,
+ * tailored to the tr03wt and tr47wt registers:
+ * equal weight for all Tx Qs, measured in 64byte units
+ */
+#define DEFAULT_WRRS_WEIGHT	0x18181818
+
 #define TCTRL_INIT_CSUM		(TCTRL_TUCSEN | TCTRL_IPCSEN)
 
 #define IEVENT_INIT_CLEAR	0xffffffff
@@ -1096,7 +1104,8 @@ struct gfar_private {
 		extended_hash:1,
 		bd_stash_en:1,
 		rx_filer_enable:1,
-		wol_en:1; /* Wake-on-LAN enabled */
+		wol_en:1, /* Wake-on-LAN enabled */
+		prio_sched_en:1; /* Enable priorty based Tx scheduling in Hw */
 	unsigned short padding;
 
 	/* PHY stuff */
-- 
1.8.3.2

