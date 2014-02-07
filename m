Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755447AbaBGLwx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Feb 2014 06:52:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42525 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752951AbaBGLwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Feb 2014 06:52:45 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 220/233] ip_tunnel: clear IPCB in ip_tunnel_xmit() in case dst_link_failure() is called
Date: Fri,  7 Feb 2014 11:47:19 +0000
Message-Id: <1391773652-25214-221-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
References: <1391773652-25214-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

commit 11c21a307d79ea5f6b6fc0d3dfdeda271e5e65f6 upstream.

commit a622260254ee48("ip_tunnel: fix kernel panic with icmp_dest_unreach")
clear IPCB in ip_tunnel_xmit()  , or else skb->cb[] may contain garbage from
GSO segmentation layer.

But commit 0e6fbc5b6c621("ip_tunnels: extend iptunnel_xmit()") refactor codes,
and it clear IPCB behind the dst_link_failure().

So clear IPCB in ip_tunnel_xmit() just like commti a622260254ee48("ip_tunnel:
fix kernel panic with icmp_dest_unreach").

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_tunnel.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index ffc2108..b6829f4 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -621,6 +621,7 @@ void ip_tunnel_xmit(struct sk_buff *skb, struct net_device *dev,
 				tunnel->err_time + IPTUNNEL_ERR_TIMEO)) {
 			tunnel->err_count--;
 
+			memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 			dst_link_failure(skb);
 		} else
 			tunnel->err_count = 0;
-- 
1.8.3.2

