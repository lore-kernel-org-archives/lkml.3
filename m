Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161016Ab3GZVn7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:43:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:50738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756470Ab3GZUsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:48:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Cong Wang <amwang@redhat.com>, Pravin B Shelar <pshelar@nicira.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 07/79] gre: fix a regression in ioctl
Date: Fri, 26 Jul 2013 13:46:57 -0700
Message-Id: <20130726204722.712616246@linuxfoundation.org>
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

[ Upstream commit 6c734fb8592f6768170e48e7102cb2f0a1bb9759 ]

When testing GRE tunnel, I got:

 # ip tunnel show
 get tunnel gre0 failed: Invalid argument
 get tunnel gre1 failed: Invalid argument

This is a regression introduced by commit c54419321455631079c7d
("GRE: Refactor GRE tunneling code.") because previously we
only check the parameters for SIOCADDTUNNEL and SIOCCHGTUNNEL,
after that commit, the check is moved for all commands.

So, just check for SIOCADDTUNNEL and SIOCCHGTUNNEL.

After this patch I got:

 # ip tunnel show
 gre0: gre/ip  remote any  local any  ttl inherit  nopmtudisc
 gre1: gre/ip  remote 192.168.122.101  local 192.168.122.45  ttl inherit

Signed-off-by: Cong Wang <amwang@redhat.com>
Cc: Pravin B Shelar <pshelar@nicira.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/ip_gre.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/net/ipv4/ip_gre.c
+++ b/net/ipv4/ip_gre.c
@@ -503,10 +503,11 @@ static int ipgre_tunnel_ioctl(struct net
 
 	if (copy_from_user(&p, ifr->ifr_ifru.ifru_data, sizeof(p)))
 		return -EFAULT;
-	if (p.iph.version != 4 || p.iph.protocol != IPPROTO_GRE ||
-	    p.iph.ihl != 5 || (p.iph.frag_off&htons(~IP_DF)) ||
-	    ((p.i_flags|p.o_flags)&(GRE_VERSION|GRE_ROUTING))) {
-		return -EINVAL;
+	if (cmd == SIOCADDTUNNEL || cmd == SIOCCHGTUNNEL) {
+		if (p.iph.version != 4 || p.iph.protocol != IPPROTO_GRE ||
+		    p.iph.ihl != 5 || (p.iph.frag_off&htons(~IP_DF)) ||
+		    ((p.i_flags|p.o_flags)&(GRE_VERSION|GRE_ROUTING)))
+			return -EINVAL;
 	}
 	p.i_flags = gre_flags_to_tnl_flags(p.i_flags);
 	p.o_flags = gre_flags_to_tnl_flags(p.o_flags);


