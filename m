Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751305AbaLOT1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 14:27:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40610 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaLOT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 14:27:11 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ian Morgan <imorgan@primordial.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 08/96] ax88179_178a: fix bonding failure
Date: Mon, 15 Dec 2014 11:25:28 -0800
Message-Id: <1418671616-25482-9-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1418671616-25482-1-git-send-email-kamal@canonical.com>
References: <1418671616-25482-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt13 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Morgan <imorgan@primordial.ca>

[ Upstream commit 95ff88688781db2f64042e69bd499e518bbb36e5 ]

The following patch fixes a bug which causes the ax88179_178a driver to be
incapable of being added to a bond.

When I brought up the issue with the bonding maintainers, they indicated
that the real problem was with the NIC driver which must return zero for
success (of setting the MAC address). I see that several other NIC drivers
follow that pattern by either simply always returing zero, or by passing
through a negative (error) result while rewriting any positive return code
to zero. With that same philisophy applied to the ax88179_178a driver, it
allows it to work correctly with the bonding driver.

I believe this is suitable for queuing in -stable, as it's a small, simple,
and obvious fix that corrects a defect with no other known workaround.

This patch is against vanilla 3.17(.0).

Signed-off-by: Ian Morgan <imorgan@primordial.ca>

 drivers/net/usb/ax88179_178a.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/usb/ax88179_178a.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index e62141b..9e5e48f 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -697,6 +697,7 @@ static int ax88179_set_mac_addr(struct net_device *net, void *p)
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct sockaddr *addr = p;
+	int ret;
 
 	if (netif_running(net))
 		return -EBUSY;
@@ -706,8 +707,12 @@ static int ax88179_set_mac_addr(struct net_device *net, void *p)
 	memcpy(net->dev_addr, addr->sa_data, ETH_ALEN);
 
 	/* Set the MAC address */
-	return ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
+	ret = ax88179_write_cmd(dev, AX_ACCESS_MAC, AX_NODE_ID, ETH_ALEN,
 				 ETH_ALEN, net->dev_addr);
+	if (ret < 0)
+		return ret;
+
+	return 0;
 }
 
 static const struct net_device_ops ax88179_netdev_ops = {
-- 
1.9.1

