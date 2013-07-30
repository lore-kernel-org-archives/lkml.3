Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932429Ab3G3JdM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 05:33:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53123 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab3G3JdA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 05:33:00 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 045/106] ipv6: ip6_sk_dst_check() must not assume ipv6 dst
Date: Tue, 30 Jul 2013 10:31:04 +0100
Message-Id: <1375176725-5825-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
References: <1375176725-5825-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.18 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit a963a37d384d71ad43b3e9e79d68d42fbe0901f3 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/ipv6/ip6_output.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index ccb2adb..6c5f1c1 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -919,11 +919,17 @@ static struct dst_entry *ip6_sk_dst_check(struct sock *sk,
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
-- 
1.8.3.2

