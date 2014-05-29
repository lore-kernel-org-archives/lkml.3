Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933905AbaE2FGw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 01:06:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58169 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932748AbaE2Ef4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 00:35:56 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Peter Christensen <pch@ordbogen.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 116/140] macvlan: Dont propagate IFF_ALLMULTI changes on down interfaces.
Date: Wed, 28 May 2014 21:34:15 -0700
Message-Id: <20140529043104.499331306@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0.rc3.2.g998f840
In-Reply-To: <20140529043049.661315084@linuxfoundation.org>
References: <20140529043049.661315084@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Christensen <pch@ordbogen.com>

[ Upstream commit bbeb0eadcf9fe74fb2b9b1a6fea82cd538b1e556 ]

Clearing the IFF_ALLMULTI flag on a down interface could cause an allmulti
overflow on the underlying interface.

Attempting the set IFF_ALLMULTI on the underlying interface would cause an
error and the log message:

"allmulti touches root, set allmulti failed."

Signed-off-by: Peter Christensen <pch@ordbogen.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvlan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -458,8 +458,10 @@ static void macvlan_change_rx_flags(stru
 	struct macvlan_dev *vlan = netdev_priv(dev);
 	struct net_device *lowerdev = vlan->lowerdev;
 
-	if (change & IFF_ALLMULTI)
-		dev_set_allmulti(lowerdev, dev->flags & IFF_ALLMULTI ? 1 : -1);
+	if (dev->flags & IFF_UP) {
+		if (change & IFF_ALLMULTI)
+			dev_set_allmulti(lowerdev, dev->flags & IFF_ALLMULTI ? 1 : -1);
+	}
 }
 
 static void macvlan_set_mac_lists(struct net_device *dev)


