Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab3LSL4H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:56:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44514 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab3LSL4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:02 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Fan Du <fan.du@windriver.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 029/208] xfrm: Release dst if this dst is improper for vti tunnel
Date: Thu, 19 Dec 2013 11:52:07 +0000
Message-Id: <1387454106-19326-30-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "fan.du" <fan.du@windriver.com>

commit 236c9f84868534c718b6889aa624de64763281f9 upstream.

After searching rt by the vti tunnel dst/src parameter,
if this rt has neither attached to any transformation
nor the transformation is not tunnel oriented, this rt
should be released back to ip layer.

otherwise causing dst memory leakage.

Signed-off-by: Fan Du <fan.du@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_vti.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 0656041..feb19db 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -350,6 +350,7 @@ static netdev_tx_t vti_tunnel_xmit(struct sk_buff *skb, struct net_device *dev)
 	if (!rt->dst.xfrm ||
 	    rt->dst.xfrm->props.mode != XFRM_MODE_TUNNEL) {
 		dev->stats.tx_carrier_errors++;
+		ip_rt_put(rt);
 		goto tx_error_icmp;
 	}
 	tdev = rt->dst.dev;
-- 
1.8.3.2

