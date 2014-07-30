Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755081AbaG3Maq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:30:46 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:36746 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752929AbaG3MPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:15:33 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        Edward Allcutt <edward.allcutt@openmarket.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 42/94] ipv4: icmp: Fix pMTU handling for rare case
Date: Wed, 30 Jul 2014 14:14:31 +0200
Message-Id: <1f947b0728aa761cb16e1f5da62c7db1012d0b91.1406722270.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
References: <e43bbc2c2b44d8f0bd0b7f65d6fd50ef738c57aa.1406722270.git.jslaby@suse.cz>
In-Reply-To: <cover.1406722269.git.jslaby@suse.cz>
References: <cover.1406722269.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edward Allcutt <edward.allcutt@openmarket.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 68b7107b62983f2cff0948292429d5f5999df096 ]

Some older router implementations still send Fragmentation Needed
errors with the Next-Hop MTU field set to zero. This is explicitly
described as an eventuality that hosts must deal with by the
standard (RFC 1191) since older standards specified that those
bits must be zero.

Linux had a generic (for all of IPv4) implementation of the algorithm
described in the RFC for searching a list of MTU plateaus for a good
value. Commit 46517008e116 ("ipv4: Kill ip_rt_frag_needed().")
removed this as part of the changes to remove the routing cache.
Subsequently any Fragmentation Needed packet with a zero Next-Hop
MTU has been discarded without being passed to the per-protocol
handlers or notifying userspace for raw sockets.

When there is a router which does not implement RFC 1191 on an
MTU limited path then this results in stalled connections since
large packets are discarded and the local protocols are not
notified so they never attempt to lower the pMTU.

One example I have seen is an OpenBSD router terminating IPSec
tunnels. It's worth pointing out that this case is distinct from
the BSD 4.2 bug which incorrectly calculated the Next-Hop MTU
since the commit in question dismissed that as a valid concern.

All of the per-protocols handlers implement the simple approach from
RFC 1191 of immediately falling back to the minimum value. Although
this is sub-optimal it is vastly preferable to connections hanging
indefinitely.

Remove the Next-Hop MTU != 0 check and allow such packets
to follow the normal path.

Fixes: 46517008e116 ("ipv4: Kill ip_rt_frag_needed().")
Signed-off-by: Edward Allcutt <edward.allcutt@openmarket.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/ipv4/icmp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 5f7d11a45871..ff670cab5af5 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -705,8 +705,6 @@ static void icmp_unreach(struct sk_buff *skb)
 					       &iph->daddr);
 			} else {
 				info = ntohs(icmph->un.frag.mtu);
-				if (!info)
-					goto out;
 			}
 			break;
 		case ICMP_SR_FAILED:
-- 
2.0.1

