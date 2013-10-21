Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3JUIxl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 04:53:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39920 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754651Ab3JUIxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 04:53:34 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Claudiu Manoil" <claudiu.manoil@freescale.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 21 Oct 2013 09:46:28 +0100
Message-ID: <lsq.1382345188.733635373@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 149/149] gianfar: Change default HW Tx queue
 scheduling mode
In-Reply-To: <lsq.1382345187.199780875@decadent.org.uk>
X-SA-Exim-Connect-IP: 212.20.242.100
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.52-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/freescale/gianfar.c | 11 ++++++++++-
 drivers/net/ethernet/freescale/gianfar.h | 11 ++++++++++-
 2 files changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -397,7 +397,13 @@ static void gfar_init_mac(struct net_dev
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
 
@@ -1157,6 +1163,9 @@ static int gfar_probe(struct platform_de
 	priv->rx_filer_enable = 1;
 	/* Enable most messages by default */
 	priv->msg_enable = (NETIF_MSG_IFUP << 1 ) - 1;
+	/* use pritority h/w tx queue scheduling for single queue devices */
+	if (priv->num_tx_queues == 1)
+		priv->prio_sched_en = 1;
 
 	/* Carrier starts down, phylib will bring it up */
 	netif_carrier_off(dev);
--- a/drivers/net/ethernet/freescale/gianfar.h
+++ b/drivers/net/ethernet/freescale/gianfar.h
@@ -304,8 +304,16 @@ extern const char gfar_driver_version[];
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
@@ -1101,7 +1109,8 @@ struct gfar_private {
 		extended_hash:1,
 		bd_stash_en:1,
 		rx_filer_enable:1,
-		wol_en:1; /* Wake-on-LAN enabled */
+		wol_en:1, /* Wake-on-LAN enabled */
+		prio_sched_en:1; /* Enable priorty based Tx scheduling in Hw */
 	unsigned short padding;
 
 	/* PHY stuff */

