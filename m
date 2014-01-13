Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755800AbaAMQr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:47:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53157 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749AbaAMQCj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:39 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Korsgaard <peter@korsgaard.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 074/208] dm9601: fix reception of full size ethernet frames on dm9620/dm9621a
Date: Mon, 13 Jan 2014 15:58:35 +0000
Message-Id: <1389628849-1614-75-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Korsgaard <peter@korsgaard.com>

commit 407900cfb54bdb2cfa228010b6697305f66b2948 upstream.

dm9620/dm9621a require room for 4 byte padding even in dm9601 (3 byte
header) mode.

Signed-off-by: Peter Korsgaard <peter@korsgaard.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/usb/dm9601.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/usb/dm9601.c b/drivers/net/usb/dm9601.c
index c6867f9..732a926 100644
--- a/drivers/net/usb/dm9601.c
+++ b/drivers/net/usb/dm9601.c
@@ -364,7 +364,12 @@ static int dm9601_bind(struct usbnet *dev, struct usb_interface *intf)
 	dev->net->ethtool_ops = &dm9601_ethtool_ops;
 	dev->net->hard_header_len += DM_TX_OVERHEAD;
 	dev->hard_mtu = dev->net->mtu + dev->net->hard_header_len;
-	dev->rx_urb_size = dev->net->mtu + ETH_HLEN + DM_RX_OVERHEAD;
+
+	/* dm9620/21a require room for 4 byte padding, even in dm9601
+	 * mode, so we need +1 to be able to receive full size
+	 * ethernet frames.
+	 */
+	dev->rx_urb_size = dev->net->mtu + ETH_HLEN + DM_RX_OVERHEAD + 1;
 
 	dev->mii.dev = dev->net;
 	dev->mii.mdio_read = dm9601_mdio_read;
-- 
1.8.3.2

