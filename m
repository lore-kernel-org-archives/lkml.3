Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966990AbaCUB07 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 21:26:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36489 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297AbaCUAD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 20:03:28 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Xin Long <lucien.xin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 020/149] ip_tunnel:multicast process cause panic due to skb->_skb_refdst NULL pointer
Date: Thu, 20 Mar 2014 17:03:03 -0700
Message-Id: <20140321000437.646612940@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140321000436.377902063@linuxfoundation.org>
References: <20140321000436.377902063@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 10ddceb22bab11dab10ba645c7df2e4a8e7a5db5 ]

when ip_tunnel process multicast packets, it may check if the packet is looped
back packet though 'rt_is_output_route(skb_rtable(skb))' in ip_tunnel_rcv(),
but before that , skb->_skb_refdst has been dropped in iptunnel_pull_header(),
so which leads to a panic.

fix the bug: https://bugzilla.kernel.org/show_bug.cgi?id=70681

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel_core.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/ipv4/ip_tunnel_core.c
+++ b/net/ipv4/ip_tunnel_core.c
@@ -109,7 +109,6 @@ int iptunnel_pull_header(struct sk_buff
 	secpath_reset(skb);
 	if (!skb->l4_rxhash)
 		skb->rxhash = 0;
-	skb_dst_drop(skb);
 	skb->vlan_tci = 0;
 	skb_set_queue_mapping(skb, 0);
 	skb->pkt_type = PACKET_HOST;


