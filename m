Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760761Ab3GZVpR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:45:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50712 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759680Ab3GZUsP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:15 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roman Mamedov <rm@romanrm.ru>, David Miller <davem@davemloft.net>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Subject: [ 03/79] ipv6: only apply anti-spoofing checks to not-pointopoint tunnels
Date: Fri, 26 Jul 2013 13:46:53 -0700
Message-Id: <20130726204722.265616440@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 5c29fb12e8fb8a8105ea048cb160fd79a85a52bb ]

Because of commit 218774dc341f219bfcf940304a081b121a0e8099 ("ipv6: add
anti-spoofing checks for 6to4 and 6rd") the sit driver dropped packets
for 2002::/16 destinations and sources even when configured to work as a
tunnel with fixed endpoint. We may only apply the 6rd/6to4 anti-spoofing
checks if the device is not in pointopoint mode.

This was an oversight from me in the above commit, sorry.  Thanks to
Roman Mamedov for reporting this!

Reported-by: Roman Mamedov <rm@romanrm.ru>
Cc: David Miller <davem@davemloft.net>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/sit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/sit.c
+++ b/net/ipv6/sit.c
@@ -589,7 +589,7 @@ static int ipip6_rcv(struct sk_buff *skb
 				tunnel->dev->stats.rx_errors++;
 				goto out;
 			}
-		} else {
+		} else if (!(tunnel->dev->flags&IFF_POINTOPOINT)) {
 			if (is_spoofed_6rd(tunnel, iph->saddr,
 					   &ipv6_hdr(skb)->saddr) ||
 			    is_spoofed_6rd(tunnel, iph->daddr,


