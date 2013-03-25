Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757968Ab3CYBjW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:39:22 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33788 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755437Ab3CYBPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:04 -0400
Message-Id: <20130325010525.735872085@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:38 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 014/104] rtnl: fix info leak on RTM_GETLINK request for VF  devices
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 84d73cd3fb142bf1298a8c13fd4ca50fd2432372 ]

Initialize the mac address buffer with 0 as the driver specific function
will probably not fill the whole buffer. In fact, all in-kernel drivers
fill only ETH_ALEN of the MAX_ADDR_LEN bytes, i.e. 6 of the 32 possible
bytes. Therefore we currently leak 26 bytes of stack memory to userland
via the netlink interface.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/core/rtnetlink.c | 1 +
 1 file changed, 1 insertion(+)

--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -973,6 +973,7 @@ static int rtnl_fill_ifinfo(struct sk_bu
 			 * report anything.
 			 */
 			ivi.spoofchk = -1;
+			memset(ivi.mac, 0, sizeof(ivi.mac));
 			if (dev->netdev_ops->ndo_get_vf_config(dev, i, &ivi))
 				break;
 			vf_mac.vf =


