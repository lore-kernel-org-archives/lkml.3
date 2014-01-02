Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaABRGr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:06:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40259 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627AbaABRGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:06:45 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fan Du <fan.du@windriver.com>, "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 24/91] xfrm: Release dst if this dst is improper for vti tunnel
Date: Thu,  2 Jan 2014 09:03:59 -0800
Message-Id: <1388682306-30859-25-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "fan.du" <fan.du@windriver.com>

[ Upstream commit 236c9f84868534c718b6889aa624de64763281f9 ]

After searching rt by the vti tunnel dst/src parameter,
if this rt has neither attached to any transformation
nor the transformation is not tunnel oriented, this rt
should be released back to ip layer.

otherwise causing dst memory leakage.

Signed-off-by: Fan Du <fan.du@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/ip_vti.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index d011525..331a075 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -388,6 +388,7 @@ static netdev_tx_t vti_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (!rt->dst.xfrm ||
 	    rt->dst.xfrm->props.mode != XFRM_MODE_TUNNEL) {
 		dev->stats.tx_carrier_errors++;
+		ip_rt_put(rt);
 		goto tx_error_icmp;
 	}
 	tdev = rt->dst.dev;
-- 
1.8.3.2

