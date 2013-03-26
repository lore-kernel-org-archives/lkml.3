Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757267Ab3CZXra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:47:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209Ab3CZWnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 15/98] Revert "ip_gre: make ipgre_tunnel_xmit() not parse network header as IP unconditionally"
Date: Tue, 26 Mar 2013 15:42:04 -0700
Message-Id: <20130326224244.040370129@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Timo Teräs <timo.teras@iki.fi>

[ Upstream commit 8c6216d7f118a128678270824b6a1286a63863ca ]

This reverts commit 412ed94744d16806fbec3bd250fd94e71cde5a1f.

The commit is wrong as tiph points to the outer IPv4 header which is
installed at ipgre_header() and not the inner one which is protocol dependant.

This commit broke succesfully opennhrp which use PF_PACKET socket with
ETH_P_NHRP protocol. Additionally ssl_addr is set to the link-layer
IPv4 address. This address is written by ipgre_header() to the skb
earlier, and this is the IPv4 header tiph should point to - regardless
of the inner protocol payload.

Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -761,10 +761,7 @@ static netdev_tx_t ipgre_tunnel_xmit(str
 
 	if (dev->header_ops && dev->type == ARPHRD_IPGRE) {
 		gre_hlen = 0;
-		if (skb->protocol == htons(ETH_P_IP))
-			tiph = (const struct iphdr *)skb->data;
-		else
-			tiph = &tunnel->parms.iph;
+		tiph = (const struct iphdr *)skb->data;
 	} else {
 		gre_hlen = tunnel->hlen;
 		tiph = &tunnel->parms.iph;


