Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965539AbaFQVpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 17:45:30 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53629 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965485AbaFQVp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 17:45:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 009/212] ipv6: Limit mtu to 65575 bytes
Date: Tue, 17 Jun 2014 14:41:43 -0700
Message-Id: <1403041506-13646-10-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403041506-13646-1-git-send-email-kamal@canonical.com>
References: <1403041506-13646-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 30f78d8ebf7f514801e71b88a10c948275168518 ]

Francois reported that setting big mtu on loopback device could prevent
tcp sessions making progress.

We do not support (yet ?) IPv6 Jumbograms and cook corrupted packets.

We must limit the IPv6 MTU to (65535 + 40) bytes in theory.

Tested:

ifconfig lo mtu 70000
netperf -H ::1

Before patch : Throughput :   0.05 Mbits

After patch : Throughput : 35484 Mbits

Reported-by: Francois WELLENREITER <f.wellenreiter@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/ip6_route.h | 5 +++++
 net/ipv6/route.c        | 5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/include/net/ip6_route.h b/include/net/ip6_route.h
index 733747c..9302699 100644
--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -32,6 +32,11 @@ struct route_info {
 #define RT6_LOOKUP_F_SRCPREF_PUBLIC	0x00000010
 #define RT6_LOOKUP_F_SRCPREF_COA	0x00000020
 
+/* We do not (yet ?) support IPv6 jumbograms (RFC 2675)
+ * Unlike IPv4, hdr->seg_len doesn't include the IPv6 header
+ */
+#define IP6_MAX_MTU (0xFFFF + sizeof(struct ipv6hdr))
+
 /*
  * rt6_srcprefs2flags() and rt6_flags2srcprefs() translate
  * between IPV6_ADDR_PREFERENCES socket option values
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 40b6e69..0caafb5 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1324,7 +1324,7 @@ static unsigned int ip6_mtu(const struct dst_entry *dst)
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 
 	if (mtu)
-		return mtu;
+		goto out;
 
 	mtu = IPV6_MIN_MTU;
 
@@ -1334,7 +1334,8 @@ static unsigned int ip6_mtu(const struct dst_entry *dst)
 		mtu = idev->cnf.mtu6;
 	rcu_read_unlock();
 
-	return mtu;
+out:
+	return min_t(unsigned int, mtu, IP6_MAX_MTU);
 }
 
 static struct dst_entry *icmp6_dst_gc_list;
-- 
1.9.1

