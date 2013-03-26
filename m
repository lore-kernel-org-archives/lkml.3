Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934993Ab3CZQMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:12:23 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53691 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964861Ab3CZPWT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:19 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 047/150] rtnl: fix info leak on RTM_GETLINK request for VF devices
Date: Tue, 26 Mar 2013 15:19:06 +0000
Message-Id: <1364311249-14454-48-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 84d73cd3fb142bf1298a8c13fd4ca50fd2432372 upstream.

Initialize the mac address buffer with 0 as the driver specific function
will probably not fill the whole buffer. In fact, all in-kernel drivers
fill only ETH_ALEN of the MAX_ADDR_LEN bytes, i.e. 6 of the 32 possible
bytes. Therefore we currently leak 26 bytes of stack memory to userland
via the netlink interface.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/core/rtnetlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 6c50ac0..8f37bec 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -981,6 +981,7 @@ static int rtnl_fill_ifinfo(struct sk_buff *skb, struct net_device *dev,
 			 * report anything.
 			 */
 			ivi.spoofchk = -1;
+			memset(ivi.mac, 0, sizeof(ivi.mac));
 			if (dev->netdev_ops->ndo_get_vf_config(dev, i, &ivi))
 				break;
 			vf_mac.vf =
-- 
1.8.1.2

