Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756906AbaKSUyD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:54:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:55888 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688AbaKSUxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:53:51 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Enric Balletbo i Serra <eballetbo@iseebcn.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 017/141] smsc911x: power-up phydev before doing a software reset.
Date: Wed, 19 Nov 2014 12:50:40 -0800
Message-Id: <20141119205151.234335887@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Enric Balletbo i Serra <eballetbo@iseebcn.com>

[ Upstream commit ccf899a27c08038db91765ff12bb0380dcd85887 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/smsc/smsc911x.c |   46 +++++++++++++++++++++++++++++++++++
 1 file changed, 46 insertions(+)

--- a/drivers/net/ethernet/smsc/smsc911x.c
+++ b/drivers/net/ethernet/smsc/smsc911x.c
@@ -1342,6 +1342,42 @@ static void smsc911x_rx_multicast_update
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
@@ -1415,6 +1451,16 @@ static int smsc911x_soft_reset(struct sm
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


