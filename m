Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060AbaHHUvd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 16:51:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:40986 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758492AbaHHUv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:51:26 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Edward Allcutt <edward.allcutt@openmarket.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 243/259] ipv4: icmp: Fix pMTU handling for rare case
Date: Fri,  8 Aug 2014 13:41:06 -0700
Message-Id: <1407530482-4483-244-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv4/icmp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 5c0e8bc..dfe19f2 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -710,8 +710,6 @@ static void icmp_unreach(struct sk_buff *skb)
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

