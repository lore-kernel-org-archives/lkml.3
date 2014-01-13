Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273AbaAMQPB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:15:01 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53736 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaAMQFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Pravin B Shelar <pshelar@nicira.com>,
        =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 180/208] ip_gre: fix msg_name parsing for recvfrom/recvmsg
Date: Mon, 13 Jan 2014 16:00:21 +0000
Message-Id: <1389628849-1614-181-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>

commit 0e3da5bb8da45890b1dc413404e0f978ab71173e upstream.

ipgre_header_parse() needs to parse the tunnel's ip header and it
uses mac_header to locate the iphdr. This got broken when gre tunneling
was refactored as mac_header is no longer updated to point to iphdr.
Introduce skb_pop_mac_header() helper to do the mac_header assignment
and use it in ipgre_rcv() to fix msg_name parsing.

Bug introduced in commit c54419321455 (GRE: Refactor GRE tunneling code.)

Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv4/ip_gre.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index 8d6939e..2977400 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -217,6 +217,7 @@ static int ipgre_rcv(struct sk_buff *skb, const struct tnl_ptk_info *tpi)
 				  iph->saddr, iph->daddr, tpi->key);
 
 	if (tunnel) {
+		skb_pop_mac_header(skb);
 		ip_tunnel_rcv(tunnel, skb, tpi, log_ecn_error);
 		return PACKET_RCVD;
 	}
-- 
1.8.3.2

