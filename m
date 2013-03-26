Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079Ab3CZRlY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:41:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:19974 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754340Ab3CZRgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:33 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=Q0PfNjcT1TYA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=w3X_oAyIz6IA:10 a=VPS0CfSAAAAA:8 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=Hb87az3203AA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=fdOLowIc_7uu0WGr:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173610.108770791@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:22:03 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Pravin B Shelar <pshelar@nicira.com>, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 64/86] IP_GRE: Fix kernel panic in IP_GRE with GRE csum.
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0064-IP_GRE-Fix-kernel-panic-in-IP_GRE-with-GRE-csum.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Pravin B Shelar <pshelar@nicira.com>

[ Upstream commit d0a7cc630a337b0f56dc145e7eb6232852b14dd4 ]

Due to IP_GRE GSO support, GRE can recieve non linear skb which
results in panic in case of GRE_CSUM.  Following patch fixes it by
using correct csum API.

Bug introduced in commit 6b78f16e4bdde3936b (gre: add GSO support)

Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/ipv4/ip_gre.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/ip_gre.c b/net/ipv4/ip_gre.c
index b062a98..3ee08ce 100644
--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -946,8 +946,12 @@ static netdev_tx_t ipgre_tunnel_xmit(struct sk_buff *skb, struct net_device *dev
 			ptr--;
 		}
 		if (tunnel->parms.o_flags&GRE_CSUM) {
+			int offset = skb_transport_offset(skb);
+
 			*ptr = 0;
-			*(__sum16 *)ptr = ip_compute_csum((void *)(iph+1), skb->len - sizeof(struct iphdr));
+			*(__sum16 *)ptr = csum_fold(skb_checksum(skb, offset,
+								 skb->len - offset,
+								 0));
 		}
 	}
 
-- 
1.7.10.4


