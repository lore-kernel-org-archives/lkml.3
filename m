Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754531Ab3BLUgA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 15:36:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53532 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab3BLUf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 15:35:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 32/61] IP_GRE: Fix kernel panic in IP_GRE with GRE csum.
Date: Tue, 12 Feb 2013 12:34:52 -0800
Message-Id: <20130212203422.578622890@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130212203417.890993903@linuxfoundation.org>
References: <20130212203417.890993903@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Pravin B Shelar <pshelar@nicira.com>

[ Upstream commit 5465740ace36f179de5bb0ccb5d46ddeb945e309 ]

Due to IP_GRE GSO support, GRE can recieve non linear skb which
results in panic in case of GRE_CSUM.  Following patch fixes it by
using correct csum API.

Bug introduced in commit 6b78f16e4bdde3936b (gre: add GSO support)

Signed-off-by: Pravin B Shelar <pshelar@nicira.com>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -972,8 +972,12 @@ static netdev_tx_t ipgre_tunnel_xmit(str
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
 


