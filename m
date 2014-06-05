Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753806AbaFEFPo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 01:15:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:43635 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867AbaFEEUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 00:20:01 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Francois WELLENREITER <f.wellenreiter@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.4 020/214] ipv6: Limit mtu to 65575 bytes
Date: Wed,  4 Jun 2014 21:16:23 -0700
Message-Id: <20140605041642.480725817@linuxfoundation.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <20140605041639.638675216@linuxfoundation.org>
References: <20140605041639.638675216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_route.h |    5 +++++
 net/ipv6/route.c        |    5 +++--
 2 files changed, 8 insertions(+), 2 deletions(-)

--- a/include/net/ip6_route.h
+++ b/include/net/ip6_route.h
@@ -34,6 +34,11 @@ struct route_info {
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
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -1092,7 +1092,7 @@ static unsigned int ip6_mtu(const struct
 	unsigned int mtu = dst_metric_raw(dst, RTAX_MTU);
 
 	if (mtu)
-		return mtu;
+		goto out;
 
 	mtu = IPV6_MIN_MTU;
 
@@ -1102,7 +1102,8 @@ static unsigned int ip6_mtu(const struct
 		mtu = idev->cnf.mtu6;
 	rcu_read_unlock();
 
-	return mtu;
+out:
+	return min_t(unsigned int, mtu, IP6_MAX_MTU);
 }
 
 static struct dst_entry *icmp6_dst_gc_list;


