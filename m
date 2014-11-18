Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbaKRPXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:23:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57159 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859AbaKROJ1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:09:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ian Morgan <imorgan@primordial.ca>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 012/206] ax88179_178a: fix bonding failure
Date: Tue, 18 Nov 2014 15:06:07 +0100
Message-Id: <93b6d31fdc9b3b4ee3f6544c18ad48aefeb54ce0.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Morgan <imorgan@primordial.ca>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
---
 drivers/net/usb/ax88179_178a.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/ax88179_178a.c b/drivers/net/usb/ax88179_178a.c
index 3ecb2133dee6..b8b8f9948a0f 100644
--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -698,6 +698,7 @@ static int ax88179_set_mac_addr(struct net_device *net, void *p)
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct sockaddr *addr = p;
+	int ret;
 
 	if (netif_running(net))
 		return -EBUSY;
@@ -707,8 +708,12 @@ static int ax88179_set_mac_addr(struct net_device *net, void *p)
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
2.1.3

