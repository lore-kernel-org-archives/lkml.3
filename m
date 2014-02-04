Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933644AbaBDVQN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:16:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57553 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934441AbaBDVMy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:12:54 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 118/140] net: gre: use icmp_hdr() to get inner ip header
Date: Tue,  4 Feb 2014 13:11:45 -0800
Message-Id: <20140204211040.343305223@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

[ Upstream commit c0c0c50ff7c3e331c90bab316d21f724fb9e1994 ]

When dealing with icmp messages, the skb->data points the
ip header that triggered the sending of the icmp message.

In gre_cisco_err(), the parse_gre_header() is called, and the
iptunnel_pull_header() is called to pull the skb at the end of
the parse_gre_header(), so the skb->data doesn't point the
inner ip header.

Unfortunately, the ipgre_err still needs those ip addresses in
inner ip header to look up tunnel by ip_tunnel_lookup().

So just use icmp_hdr() to get inner ip header instead of skb->data.

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -178,7 +178,7 @@ static int ipgre_err(struct sk_buff *skb
 	else
 		itn = net_generic(net, ipgre_net_id);
 
-	iph = (const struct iphdr *)skb->data;
+	iph = (const struct iphdr *)(icmp_hdr(skb) + 1);
 	t = ip_tunnel_lookup(itn, skb->dev->ifindex, tpi->flags,
 			     iph->daddr, iph->saddr, tpi->key);
 


