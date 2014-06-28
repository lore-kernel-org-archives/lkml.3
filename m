Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387AbaF1S5o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 14:57:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53216 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbaF1Rs6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 13:48:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Stefan Roese <sr@denx.de>, Johan Hovold <jhovold@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 001/110] Revert "net: eth: cpsw: Correctly attach to GPIO bitbang MDIO driver"
Date: Sat, 28 Jun 2014 10:45:58 -0700
Message-Id: <20140628174545.427380346@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140628174545.354748696@linuxfoundation.org>
References: <20140628174545.354748696@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <jhovold@gmail.com>

commit 59993f48b38fd46863b23bb1bb1dc3291e7278fb upstream.

This reverts commit f8d56d8f892be43a2404356073e16401eb5a42e6 ("net:
 eth: cpsw: Correctly attach to GPIO bitbang MDIO driver").

Fix potential null-pointer dereference at probe if the mdio-gpio device
has not been successfully probed yet.

The offending commit is plain wrong for a number of reasons. First of
all it accesses internal driver data of an unrelated device. Neither
does it check that the data is non-null (which it is in case the device
has not been probed yet).

Furthermore, the decision on whether to treat any driver data according
to the mdio-gpio driver's internals is made based on the node name. But
the name is not compared against "mdio" which is the normal name for the
node, but rather against "gpio" which the node does not have to be named
(and shouldn't be according to the binding documentation). [ If this
hack is to be kept out-of-tree it should at least be matching against
the compatible property. ]

Cc: Stefan Roese <sr@denx.de>
Signed-off-by: Johan Hovold <jhovold@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/ti/cpsw.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

--- a/drivers/net/ethernet/ti/cpsw.c
+++ b/drivers/net/ethernet/ti/cpsw.c
@@ -1884,18 +1884,8 @@ static int cpsw_probe_dt(struct cpsw_pla
 		mdio_node = of_find_node_by_phandle(be32_to_cpup(parp));
 		phyid = be32_to_cpup(parp+1);
 		mdio = of_find_device_by_node(mdio_node);
-
-		if (strncmp(mdio->name, "gpio", 4) == 0) {
-			/* GPIO bitbang MDIO driver attached */
-			struct mii_bus *bus = dev_get_drvdata(&mdio->dev);
-
-			snprintf(slave_data->phy_id, sizeof(slave_data->phy_id),
-				 PHY_ID_FMT, bus->id, phyid);
-		} else {
-			/* davinci MDIO driver attached */
-			snprintf(slave_data->phy_id, sizeof(slave_data->phy_id),
-				 PHY_ID_FMT, mdio->name, phyid);
-		}
+		snprintf(slave_data->phy_id, sizeof(slave_data->phy_id),
+			 PHY_ID_FMT, mdio->name, phyid);
 
 		mac_addr = of_get_mac_address(slave_node);
 		if (mac_addr)


