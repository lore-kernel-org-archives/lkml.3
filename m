Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101AbbA0BkT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:40:19 -0500
Received: from mail-ig0-f169.google.com ([209.85.213.169]:53048 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757725AbbA0BhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:37:03 -0500
From: David Decotigny <ddecotig@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        Ben Hutchings <ben@decadent.org.uk>, Amir Vadai <amirv@mellanox.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-api@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        Eugenia Emantayev <eugenia@mellanox.co.il>,
        Or Gerlitz <ogerlitz@mellanox.com>, Ido Shamay <idos@mellanox.com>,
        Joe Perches <joe@perches.com>, Saeed Mahameed <saeedm@mellanox.com>,
        Govindarajulu Varadarajan <_govind@gmx.com>,
        Venkata Duvvuru <VenkatKumar.Duvvuru@Emulex.Com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Eyal Perry <eyalpe@mellanox.com>, Pravin B Shelar <pshelar@nicira.com>,
        Ed Swierk <eswierk@skyportsystems.com>,
        David Decotigny <decot@googlers.com>
Subject: [PATCH net-next v1 11/18] net: fcoe: use __ethtool_get_ksettings
Date: Mon, 26 Jan 2015 17:36:07 -0800
Message-Id: <1422322574-6188-12-git-send-email-ddecotig@gmail.com>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <1422322574-6188-1-git-send-email-ddecotig@gmail.com>
References: <1422322574-6188-1-git-send-email-ddecotig@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Decotigny <decot@googlers.com>

Signed-off-by: David Decotigny <decot@googlers.com>
---
 drivers/scsi/fcoe/fcoe_transport.c | 36 ++++++++++++++++++++----------------
 1 file changed, 20 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/fcoe/fcoe_transport.c b/drivers/scsi/fcoe/fcoe_transport.c
index bdc8989..6097f0d 100644
--- a/drivers/scsi/fcoe/fcoe_transport.c
+++ b/drivers/scsi/fcoe/fcoe_transport.c
@@ -93,36 +93,40 @@ static struct notifier_block libfcoe_notifier = {
 int fcoe_link_speed_update(struct fc_lport *lport)
 {
 	struct net_device *netdev = fcoe_get_netdev(lport);
-	struct ethtool_cmd ecmd;
+	struct ethtool_ksettings ecmd;
 
-	if (!__ethtool_get_settings(netdev, &ecmd)) {
+	if (!__ethtool_get_ksettings(netdev, &ecmd)) {
 		lport->link_supported_speeds &= ~(FC_PORTSPEED_1GBIT  |
 		                                  FC_PORTSPEED_10GBIT |
 		                                  FC_PORTSPEED_20GBIT |
 		                                  FC_PORTSPEED_40GBIT);
 
-		if (ecmd.supported & (SUPPORTED_1000baseT_Half |
-		                      SUPPORTED_1000baseT_Full |
-		                      SUPPORTED_1000baseKX_Full))
+		if (ecmd.link_modes.supported.mask[0] & (
+			    SUPPORTED_1000baseT_Half |
+			    SUPPORTED_1000baseT_Full |
+			    SUPPORTED_1000baseKX_Full))
 			lport->link_supported_speeds |= FC_PORTSPEED_1GBIT;
 
-		if (ecmd.supported & (SUPPORTED_10000baseT_Full   |
-		                      SUPPORTED_10000baseKX4_Full |
-		                      SUPPORTED_10000baseKR_Full  |
-		                      SUPPORTED_10000baseR_FEC))
+		if (ecmd.link_modes.supported.mask[0] & (
+			    SUPPORTED_10000baseT_Full   |
+			    SUPPORTED_10000baseKX4_Full |
+			    SUPPORTED_10000baseKR_Full  |
+			    SUPPORTED_10000baseR_FEC))
 			lport->link_supported_speeds |= FC_PORTSPEED_10GBIT;
 
-		if (ecmd.supported & (SUPPORTED_20000baseMLD2_Full |
-		                      SUPPORTED_20000baseKR2_Full))
+		if (ecmd.link_modes.supported.mask[0] & (
+			    SUPPORTED_20000baseMLD2_Full |
+			    SUPPORTED_20000baseKR2_Full))
 			lport->link_supported_speeds |= FC_PORTSPEED_20GBIT;
 
-		if (ecmd.supported & (SUPPORTED_40000baseKR4_Full |
-		                      SUPPORTED_40000baseCR4_Full |
-		                      SUPPORTED_40000baseSR4_Full |
-		                      SUPPORTED_40000baseLR4_Full))
+		if (ecmd.link_modes.supported.mask[0] & (
+			    SUPPORTED_40000baseKR4_Full |
+			    SUPPORTED_40000baseCR4_Full |
+			    SUPPORTED_40000baseSR4_Full |
+			    SUPPORTED_40000baseLR4_Full))
 			lport->link_supported_speeds |= FC_PORTSPEED_40GBIT;
 
-		switch (ethtool_cmd_speed(&ecmd)) {
+		switch (ecmd.parent.speed) {
 		case SPEED_1000:
 			lport->link_speed = FC_PORTSPEED_1GBIT;
 			break;
-- 
2.2.0.rc0.207.ga3a616c

