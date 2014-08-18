Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426AbaHRKAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 06:00:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42643 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427AbaHRJe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:34:29 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Edward Allcutt <edward.allcutt@openmarket.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 044/137] ipv4: icmp: Fix pMTU handling for rare case
Date: Mon, 18 Aug 2014 10:31:45 +0100
Message-Id: <1408354398-10226-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Allcutt <edward.allcutt@openmarket.com>

commit 68b7107b62983f2cff0948292429d5f5999df096 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.9.1

