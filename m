Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753203AbaFGVZZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jun 2014 17:25:25 -0400
Received: from mail-lb0-f176.google.com ([209.85.217.176]:53234 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753059AbaFGVZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jun 2014 17:25:24 -0400
Date: Sun, 8 Jun 2014 01:25:18 +0400
From: Dmitry Popov <ixaphire@qrator.net>
To: "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] ip_vti: Fix 'ip tunnel add' with 'key' parameters
Message-Id: <20140608012518.39affaff049874520ae5a0cc@qrator.net>
X-Mailer: Sylpheed 3.4.1 (GTK+ 2.24.23; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ip tunnel add remote 10.2.2.1 local 10.2.2.2 mode vti ikey 1 okey 2
translates to p->iflags = VTI_ISVTI|GRE_KEY and p->i_key = 1, but GRE_KEY !=
TUNNEL_KEY, so ip_tunnel_ioctl would set i_key to 0 (same story with o_key) 
making us unable to create vti tunnels with [io]key via ip tunnel.

We cannot simply translate GRE_KEY to TUNNEL_KEY (as GRE module does) because 
vti_tunnels with same local/remote addresses but different ikeys will be treated
as different then. So, imo the best option here is to move p->i_flags&*_KEY 
check for vti tunnels from ip_tunnel.c to ip_vti.c and to think about [io]_mark
field for ip_tunnel_parm in the future.

Signed-off-by: Dmitry Popov <ixaphire@qrator.net>
---
 net/ipv4/ip_tunnel.c | 10 ++++++----
 net/ipv4/ip_vti.c    |  8 +++++++-
 2 files changed, 13 insertions(+), 5 deletions(-)

diff --git a/net/ipv4/ip_tunnel.c b/net/ipv4/ip_tunnel.c
index 2acc233..0a03ad1 100644
--- a/net/ipv4/ip_tunnel.c
+++ b/net/ipv4/ip_tunnel.c
@@ -747,10 +747,12 @@ int ip_tunnel_ioctl(struct net_device *dev, struct ip_tunnel_parm *p, int cmd)
 			goto done;
 		if (p->iph.ttl)
 			p->iph.frag_off |= htons(IP_DF);
-		if (!(p->i_flags&TUNNEL_KEY))
-			p->i_key = 0;
-		if (!(p->o_flags&TUNNEL_KEY))
-			p->o_key = 0;
+		if (!(p->i_flags&VTI_ISVTI)) {
+			if (!(p->i_flags&TUNNEL_KEY))
+				p->i_key = 0;
+			if (!(p->o_flags&TUNNEL_KEY))
+				p->o_key = 0;
+		}
 
 		t = ip_tunnel_find(itn, p, itn->fb_tunnel_dev->type);
 
diff --git a/net/ipv4/ip_vti.c b/net/ipv4/ip_vti.c
index 13ef00f..b8960f3 100644
--- a/net/ipv4/ip_vti.c
+++ b/net/ipv4/ip_vti.c
@@ -313,7 +313,13 @@ vti_tunnel_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd)
 			return -EINVAL;
 	}
 
-	p.i_flags |= VTI_ISVTI;
+	if (!(p.i_flags & GRE_KEY))
+		p.i_key = 0;
+	if (!(p.o_flags & GRE_KEY))
+		p.o_key = 0;
+
+	p.i_flags = VTI_ISVTI;
+
 	err = ip_tunnel_ioctl(dev, &p, cmd);
 	if (err)
 		return err;
