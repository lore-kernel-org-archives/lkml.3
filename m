Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641AbaJCPDI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:03:08 -0400
Received: from top.free-electrons.com ([176.31.233.9]:46670 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752238AbaJCPCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:02:00 -0400
From: Antoine Tenart <antoine.tenart@free-electrons.com>
To: dan.carpenter@oracle.com
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        sebastian.hesselbarth@gmail.com, alexandre.belloni@free-electrons.com,
        thomas.petazzoni@free-electrons.com, zmxu@marvell.com,
        jszhang@marvell.com, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: pxa168_eth: avoid using signed char for bitops
Date: Fri,  3 Oct 2014 17:01:54 +0200
Message-Id: <1412348517-20352-2-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412348517-20352-1-git-send-email-antoine.tenart@free-electrons.com>
References: <1412348517-20352-1-git-send-email-antoine.tenart@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signedness bugs may occur when using signed char for bitops,
depending on if the highest bit is ever used.

Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
---

Dan reported a static checker warning:
http://marc.info/?l=kernel-janitors&m=141218246222535&w=2

This patch fixes it. Instead of using sa->sa_data we now use
dev->dev_addr (of type unsigned char *) to avoid possible
signedness issues.

 drivers/net/ethernet/marvell/pxa168_eth.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/marvell/pxa168_eth.c b/drivers/net/ethernet/marvell/pxa168_eth.c
index 24de41231593..c3b209cd0660 100644
--- a/drivers/net/ethernet/marvell/pxa168_eth.c
+++ b/drivers/net/ethernet/marvell/pxa168_eth.c
@@ -634,12 +634,12 @@ static int pxa168_eth_set_mac_address(struct net_device *dev, void *addr)
 	memcpy(oldMac, dev->dev_addr, ETH_ALEN);
 	memcpy(dev->dev_addr, sa->sa_data, ETH_ALEN);
 
-	mac_h = sa->sa_data[0] << 24;
-	mac_h |= sa->sa_data[1] << 16;
-	mac_h |= sa->sa_data[2] << 8;
-	mac_h |= sa->sa_data[3];
-	mac_l = sa->sa_data[4] << 8;
-	mac_l |= sa->sa_data[5];
+	mac_h = dev->dev_addr[0] << 24;
+	mac_h |= dev->dev_addr[1] << 16;
+	mac_h |= dev->dev_addr[2] << 8;
+	mac_h |= dev->dev_addr[3];
+	mac_l = dev->dev_addr[4] << 8;
+	mac_l |= dev->dev_addr[5];
 	wrl(pep, MAC_ADDR_HIGH, mac_h);
 	wrl(pep, MAC_ADDR_LOW, mac_l);
 
-- 
1.9.1

