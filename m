Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933617AbaHHVHi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:07:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41279 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932954AbaHHUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:24 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Dooks <ben.dooks@codethink.co.uk>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 215/259] sh_eth: use RNC mode for packet reception
Date: Fri,  8 Aug 2014 13:40:38 -0700
Message-Id: <1407530482-4483-216-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit 530aa2d0d9d55ab2775d47621ddf4b5b15bc1110 ]

The current behaviour of the sh_eth driver is not to use the RNC bit
for the receive ring. This means that every packet recieved is not only
generating an IRQ but it also stops the receive ring DMA as well until
the driver re-enables it after unloading the packet.

This means that a number of the following errors are generated due to
the receive packet FIFO overflowing due to nowhere to put packets:

	net eth0: Receive FIFO Overflow

Since feedback from Yoshihiro Shimoda shows that every supported LSI
for this driver should have the bit enabled it seems the best way is
to remove the RMCR default value from the per-system data and just
write it when initialising the RMCR value. This is discussed in
the message (http://www.spinics.net/lists/netdev/msg284912.html).

I have tested the RMCR_RNC configuration with NFS root filesystem and
the driver has not failed yet.  There are further test reports from
Sergei Shtylov and others for both the R8A7790 and R8A7791.

There is also feedback fron Cao Minh Hiep[1] which reports the
same issue in (http://comments.gmane.org/gmane.linux.network/316285)
showing this fixes issues with losing UDP datagrams under iperf.

Tested-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Acked-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/renesas/sh_eth.c | 10 ++--------
 drivers/net/ethernet/renesas/sh_eth.h |  2 --
 2 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index d256ce1..dc19d37 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -483,7 +483,6 @@ static struct sh_eth_cpu_data sh7757_data = {
 	.register_type	= SH_ETH_REG_FAST_SH4,
 
 	.eesipr_value	= DMAC_M_RFRMER | DMAC_M_ECI | 0x003fffff,
-	.rmcr_value	= RMCR_RNC,
 
 	.tx_check	= EESR_FTC | EESR_CND | EESR_DLC | EESR_CD | EESR_RTO,
 	.eesr_err_check	= EESR_TWB | EESR_TABT | EESR_RABT | EESR_RFE |
@@ -561,7 +560,6 @@ static struct sh_eth_cpu_data sh7757_data_giga = {
 			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
 			  EESR_TDE | EESR_ECI,
 	.fdr_value	= 0x0000072f,
-	.rmcr_value	= RMCR_RNC,
 
 	.irq_flags	= IRQF_SHARED,
 	.apr		= 1,
@@ -689,7 +687,6 @@ static struct sh_eth_cpu_data r8a7740_data = {
 			  EESR_RFE | EESR_RDE | EESR_RFRMER | EESR_TFE |
 			  EESR_TDE | EESR_ECI,
 	.fdr_value	= 0x0000070f,
-	.rmcr_value	= RMCR_RNC,
 
 	.apr		= 1,
 	.mpr		= 1,
@@ -738,9 +735,6 @@ static void sh_eth_set_default_cpu_data(struct sh_eth_cpu_data *cd)
 	if (!cd->fdr_value)
 		cd->fdr_value = DEFAULT_FDR_INIT;
 
-	if (!cd->rmcr_value)
-		cd->rmcr_value = DEFAULT_RMCR_VALUE;
-
 	if (!cd->tx_check)
 		cd->tx_check = DEFAULT_TX_CHECK;
 
@@ -1193,8 +1187,8 @@ static int sh_eth_dev_init(struct net_device *ndev, bool start)
 	sh_eth_write(ndev, mdp->cd->fdr_value, FDR);
 	sh_eth_write(ndev, 0, TFTR);
 
-	/* Frame recv control */
-	sh_eth_write(ndev, mdp->cd->rmcr_value, RMCR);
+	/* Frame recv control (enable multiple-packets per rx irq) */
+	sh_eth_write(ndev, RMCR_RNC, RMCR);
 
 	sh_eth_write(ndev, DESC_I_RINT8 | DESC_I_RINT5 | DESC_I_TINT2, TRSCER);
 
diff --git a/drivers/net/ethernet/renesas/sh_eth.h b/drivers/net/ethernet/renesas/sh_eth.h
index f32c169..de985a3 100644
--- a/drivers/net/ethernet/renesas/sh_eth.h
+++ b/drivers/net/ethernet/renesas/sh_eth.h
@@ -324,7 +324,6 @@ enum TD_STS_BIT {
 enum RMCR_BIT {
 	RMCR_RNC = 0x00000001,
 };
-#define DEFAULT_RMCR_VALUE	0x00000000
 
 /* ECMR */
 enum FELIC_MODE_BIT {
@@ -473,7 +472,6 @@ struct sh_eth_cpu_data {
 	unsigned long fdr_value;
 	unsigned long fcftr_value;
 	unsigned long rpadir_value;
-	unsigned long rmcr_value;
 
 	/* interrupt checking mask */
 	unsigned long tx_check;
-- 
1.9.1

