Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab3ILS0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 14:26:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57010 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab3ILR7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 13:59:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pravin B Shelar <pshelar@nicira.com>,
        =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 12/46] ip_gre: fix ipgre_header to return correct offset MIME-Version: 1.0
Date: Thu, 12 Sep 2013 10:58:23 -0700
Message-Id: <20130912175722.387509228@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20130912175721.001906199@linuxfoundation.org>
References: <20130912175721.001906199@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Timo=20Ter=C3=A4s?= <timo.teras@iki.fi>

[ Upstream commit 77a482bdb2e68d13fae87541b341905ba70d572b ]

Fix ipgre_header() (header_ops->create) to return the correct
amount of bytes pushed. Most callers of dev_hard_header() seem
to care only if it was success, but af_packet.c uses it as
offset to the skb to copy from userspace only once. In practice
this fixes packet socket sendto()/sendmsg() to gre tunnels.

Regression introduced in c54419321455631079c7d6e60bc732dd0c5914c5
("GRE: Refactor GRE tunneling code.")

Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: Timo Teräs <timo.teras@iki.fi>
Acked-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -572,7 +572,7 @@ static int ipgre_header(struct sk_buff *
 	if (daddr)
 		memcpy(&iph->daddr, daddr, 4);
 	if (iph->daddr)
-		return t->hlen;
+		return t->hlen + sizeof(*iph);
 
 	return -(t->hlen + sizeof(*iph));
 }


