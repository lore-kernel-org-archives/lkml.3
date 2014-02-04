Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935081AbaBDWAm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:00:42 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56941 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934190AbaBDVJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:09:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Duan Jiong <duanj.fnst@cn.fujitsu.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 110/133] ip_tunnel: clear IPCB in ip_tunnel_xmit() in case dst_link_failure() is called
Date: Tue,  4 Feb 2014 13:08:31 -0800
Message-Id: <20140204210740.138819126@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204210737.008598235@linuxfoundation.org>
References: <20140204210737.008598235@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Duan Jiong <duanj.fnst@cn.fujitsu.com>

[ Upstream commit 11c21a307d79ea5f6b6fc0d3dfdeda271e5e65f6 ]

commit a622260254ee48("ip_tunnel: fix kernel panic with icmp_dest_unreach")
clear IPCB in ip_tunnel_xmit()  , or else skb->cb[] may contain garbage from
GSO segmentation layer.

But commit 0e6fbc5b6c621("ip_tunnels: extend iptunnel_xmit()") refactor codes,
and it clear IPCB behind the dst_link_failure().

So clear IPCB in ip_tunnel_xmit() just like commti a622260254ee48("ip_tunnel:
fix kernel panic with icmp_dest_unreach").

Signed-off-by: Duan Jiong <duanj.fnst@cn.fujitsu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_tunnel.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -618,6 +618,7 @@ void ip_tunnel_xmit(struct sk_buff *skb,
 				tunnel->err_time + IPTUNNEL_ERR_TIMEO)) {
 			tunnel->err_count--;
 
+			memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
 			dst_link_failure(skb);
 		} else
 			tunnel->err_count = 0;


