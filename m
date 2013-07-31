Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760232Ab3GaNrj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:47:39 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46855 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759627Ab3GaNZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:43 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Eric Dumazet" <edumazet@google.com>,
        "Dave Jones" <davej@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Hannes Frederic Sowa" <hannes@stressinduktion.org>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.594119795@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [04/84] ipv6: ip6_sk_dst_check() must not assume ipv6 dst
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit a963a37d384d71ad43b3e9e79d68d42fbe0901f3 ]

It's possible to use AF_INET6 sockets and to connect to an IPv4
destination. After this, socket dst cache is a pointer to a rtable,
not rt6_info.

ip6_sk_dst_check() should check the socket dst cache is IPv6, or else
various corruptions/crashes can happen.

Dave Jones can reproduce immediate crash with
trinity -q -l off -n -c sendmsg -c connect

With help from Hannes Frederic Sowa

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ip6_output.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 6aadaa8..7a0f168 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -909,11 +909,17 @@ static struct dst_entry *ip6_sk_dst_check(struct sock *sk,
 					  const struct flowi6 *fl6)
 {
 	struct ipv6_pinfo *np = inet6_sk(sk);
-	struct rt6_info *rt = (struct rt6_info *)dst;
+	struct rt6_info *rt;
 
 	if (!dst)
 		goto out;
 
+	if (dst->ops->family != AF_INET6) {
+		dst_release(dst);
+		return NULL;
+	}
+
+	rt = (struct rt6_info *)dst;
 	/* Yes, checking route validity in not connected
 	 * case is not very simple. Take into account,
 	 * that we do not support routing by source, TOS,

