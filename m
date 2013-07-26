Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759931Ab3GZUsd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 16:48:33 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932206Ab3GZUsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cong Wang <amwang@redhat.com>, Pravin B Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 12/79] ipip: fix a regression in ioctl
Date: Fri, 26 Jul 2013 13:47:02 -0700
Message-Id: <20130726204723.239847543@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726204721.849052763@linuxfoundation.org>
References: <20130726204721.849052763@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <amwang@redhat.com>

[ Upstream commit 3b7b514f44bff05d26a6499c4d4fac2a83938e6e ]

This is a regression introduced by
commit fd58156e456d9f68fe0448 (IPIP: Use ip-tunneling code.)

Similar to GRE tunnel, previously we only check the parameters
for SIOCADDTUNNEL and SIOCCHGTUNNEL, after that commit, the
check is moved for all commands.

So, just check for SIOCADDTUNNEL and SIOCCHGTUNNEL.

Also, the check for i_key, o_key etc. is suspicious too,
which did not exist before, reset them before passing
to ip_tunnel_ioctl().

Signed-off-by: Cong Wang <amwang@redhat.com>
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ipip.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/net/ipv4/ipip.c
+++ b/net/ipv4/ipip.c
@@ -240,11 +240,13 @@ ipip_tunnel_ioctl(struct net_device *dev
 	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
 		return -EFAULT;
 
-	if (p.iph.version != 4 || p.iph.protocol != IPPROTO_IPIP ||
-			p.iph.ihl != 5 || (p.iph.frag_off&htons(~IP_DF)))
-		return -EINVAL;
-	if (p.i_key || p.o_key || p.i_flags || p.o_flags)
-		return -EINVAL;
+	if (cmd == SIOCADDTUNNEL || cmd == SIOCCHGTUNNEL) {
+		if (p.iph.version != 4 || p.iph.protocol != IPPROTO_IPIP ||
+		    p.iph.ihl != 5 || (p.iph.frag_off&htons(~IP_DF)))
+			return -EINVAL;
+	}
+
+	p.i_key = p.o_key = p.i_flags = p.o_flags = 0;
 	if (p.iph.ttl)
 		p.iph.frag_off |= htons(IP_DF);
 


