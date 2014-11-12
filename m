Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935209AbaKLC0f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 21:26:35 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60907 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965684AbaKLBte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:49:34 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ian Morgan <imorgan@primordial.ca>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 003/123] ax88179_178a: fix bonding failure
Date: Wed, 12 Nov 2014 10:16:09 +0900
Message-Id: <20141112011719.140927069@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/ax88179_178a.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/ax88179_178a.c
+++ b/drivers/net/usb/ax88179_178a.c
@@ -695,6 +695,7 @@ static int ax88179_set_mac_addr(struct n
 {
 	struct usbnet *dev = netdev_priv(net);
 	struct sockaddr *addr = p;
+	int ret;
 
 	if (netif_running(net))
 		return -EBUSY;
@@ -704,8 +705,12 @@ static int ax88179_set_mac_addr(struct n
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


