Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab3F0TSt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 15:18:49 -0400
Received: from vegas.theobroma-systems.com ([88.198.52.168]:55377 "EHLO
	mail.theobroma-systems.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753654Ab3F0TSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 15:18:48 -0400
From: Christoph Muellner <christoph.muellner@theobroma-systems.com>
To: Fabio Estevam <festevam@gmail.com>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "David S . Miller" <davem@davemloft.net>,
        Fabio Estevam <fabio.estevam@freescale.com>, netdev@vger.kernel.org
Cc: Christoph Muellner <christoph.muellner@theobroma-systems.com>
Subject: [PATCH v2] net: fec: Fix multicast list setup in fec_restart().
Date: Thu, 27 Jun 2013 21:18:23 +0200
Message-Id: <1372360703-20526-1-git-send-email-christoph.muellner@theobroma-systems.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <61455.62.178.124.14.1371832855.squirrel@mail.theobroma-systems.com>
References: <61455.62.178.124.14.1371832855.squirrel@mail.theobroma-systems.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Setup the multicast list of the net_device instead of
clearing it blindly. This restores the multicast groups
in case of a link down/up event or when resuming from
suspend.

Signed-off-by: Christoph Muellner <christoph.muellner@theobroma-systems.com>
---
Changes since v1:
- Adapt the comment to the code change

 drivers/net/ethernet/freescale/fec_main.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/fec_main.c b/drivers/net/ethernet/freescale/fec_main.c
index d48099f..4c32709 100644
--- a/drivers/net/ethernet/freescale/fec_main.c
+++ b/drivers/net/ethernet/freescale/fec_main.c
@@ -60,6 +60,8 @@
 
 #include "fec.h"
 
+static void set_multicast_list(struct net_device *ndev);
+
 #if defined(CONFIG_ARM)
 #define FEC_ALIGNMENT	0xf
 #else
@@ -471,9 +473,8 @@ fec_restart(struct net_device *ndev, int duplex)
 	/* Clear any outstanding interrupt. */
 	writel(0xffc00000, fep->hwp + FEC_IEVENT);
 
-	/* Reset all multicast.	*/
-	writel(0, fep->hwp + FEC_GRP_HASH_TABLE_HIGH);
-	writel(0, fep->hwp + FEC_GRP_HASH_TABLE_LOW);
+	/* Setup multicast filter. */
+	set_multicast_list(ndev);
 #ifndef CONFIG_M5272
 	writel(0, fep->hwp + FEC_HASH_TABLE_HIGH);
 	writel(0, fep->hwp + FEC_HASH_TABLE_LOW);
-- 
1.8.3.1

