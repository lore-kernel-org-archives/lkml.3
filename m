Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760613Ab3GZVVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 17:21:38 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51023 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932847Ab3GZUxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 16:53:39 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dave Jones <davej@redhat.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 22/59] ipv6: ip6_sk_dst_check() must not assume ipv6 dst
Date: Fri, 26 Jul 2013 13:52:46 -0700
Message-Id: <20130726205016.187814067@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130726205013.795696531@linuxfoundation.org>
References: <20130726205013.795696531@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -912,11 +912,17 @@ static struct dst_entry *ip6_sk_dst_chec
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


