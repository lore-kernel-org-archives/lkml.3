Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030AbaGZT6l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jul 2014 15:58:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33783 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbaGZTDK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jul 2014 15:03:10 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Edward Allcutt <edward.allcutt@openmarket.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 25/56] ipv4: icmp: Fix pMTU handling for rare case
Date: Sat, 26 Jul 2014 12:02:18 -0700
Message-Id: <20140726190200.854859246@linuxfoundation.org>
X-Mailer: git-send-email 2.0.2
In-Reply-To: <20140726190200.061512159@linuxfoundation.org>
References: <20140726190200.061512159@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Edward Allcutt <edward.allcutt@openmarket.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/icmp.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -697,8 +697,6 @@ static void icmp_unreach(struct sk_buff
 					       &iph->daddr);
 			} else {
 				info = ntohs(icmph->un.frag.mtu);
-				if (!info)
-					goto out;
 			}
 			break;
 		case ICMP_SR_FAILED:


