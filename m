Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600AbaKYKxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 05:53:10 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59138 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbaKYKna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:43:30 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Enric Balletbo i Serra <eballetbo@iseebcn.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 225/254] smsc911x: power-up phydev before doing a software reset.
Date: Tue, 25 Nov 2014 10:39:35 +0000
Message-Id: <1416912004-5928-226-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enric Balletbo i Serra <eballetbo@iseebcn.com>

commit ccf899a27c08038db91765ff12bb0380dcd85887 upstream.

With commit be9dad1f9f26604fb ("net: phy: suspend phydev when going
to HALTED"), the PHY device will be put in a low-power mode using
BMCR_PDOWN if the the interface is set down. The smsc911x driver does
a software_reset opening the device driver (ndo_open). In such case,
the PHY must be powered-up before access to any register and before
calling the software_reset function. Otherwise, as the PHY is powered
down the software reset fails and the interface can not be enabled
again.

This patch fixes this scenario that is easy to reproduce setting down
the network interface and setting up again.

    $ ifconfig eth0 down
    $ ifconfig eth0 up
    ifconfig: SIOCSIFFLAGS: Input/output error

Signed-off-by: Enric Balletbo i Serra <eballetbo@iseebcn.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/smsc/smsc911x.c | 46 ++++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

diff --git a/drivers/net/ethernet/smsc/smsc911x.c b/drivers/net/ethernet/smsc/smsc911x.c
index 5e13fa5524ae..a4400035681f 100644
--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1342,6 +1342,42 @@ static void smsc911x_rx_multicast_update_workaround(struct smsc911x_data *pdata)
 	spin_unlock(&pdata->mac_lock);
 }
 
+static int smsc911x_phy_general_power_up(struct smsc911x_data *pdata)
+{
+	int rc = 0;
+
+	if (!pdata->phy_dev)
+		return rc;
+
+	/* If the internal PHY is in General Power-Down mode, all, except the
+	 * management interface, is powered-down and stays in that condition as
+	 * long as Phy register bit 0.11 is HIGH.
+	 *
+	 * In that case, clear the bit 0.11, so the PHY powers up and we can
+	 * access to the phy registers.
+	 */
+	rc = phy_read(pdata->phy_dev, MII_BMCR);
+	if (rc < 0) {
+		SMSC_WARN(pdata, drv, "Failed reading PHY control reg");
+		return rc;
+	}
+
+	/* If the PHY general power-down bit is not set is not necessary to
+	 * disable the general power down-mode.
+	 */
+	if (rc & BMCR_PDOWN) {
+		rc = phy_write(pdata->phy_dev, MII_BMCR, rc & ~BMCR_PDOWN);
+		if (rc < 0) {
+			SMSC_WARN(pdata, drv, "Failed writing PHY control reg");
+			return rc;
+		}
+
+		usleep_range(1000, 1500);
+	}
+
+	return 0;
+}
+
 static int smsc911x_phy_disable_energy_detect(struct smsc911x_data *pdata)
 {
 	int rc = 0;
@@ -1415,6 +1451,16 @@ static int smsc911x_soft_reset(struct smsc911x_data *pdata)
 	int ret;
 
 	/*
+	 * Make sure to power-up the PHY chip before doing a reset, otherwise
+	 * the reset fails.
+	 */
+	ret = smsc911x_phy_general_power_up(pdata);
+	if (ret) {
+		SMSC_WARN(pdata, drv, "Failed to power-up the PHY chip");
+		return ret;
+	}
+
+	/*
 	 * LAN9210/LAN9211/LAN9220/LAN9221 chips have an internal PHY that
 	 * are initialized in a Energy Detect Power-Down mode that prevents
 	 * the MAC chip to be software reseted. So we have to wakeup the PHY
-- 
2.1.0

