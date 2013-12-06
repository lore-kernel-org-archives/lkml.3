Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932395Ab3LFXzQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:55:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48361 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759049Ab3LFXMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:12:33 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 002/152] ipv6: reset dst.expires value when clearing expire flag
Date: Fri,  6 Dec 2013 15:08:46 -0800
Message-Id: <1386371476-2477-3-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 01ba16d6ec85a1ec4669c75513a76b61ec53ee50 ]

On receiving a packet too big icmp error we update the expire value by
calling rt6_update_expires. This function uses dst_set_expires which is
implemented that it can only reduce the expiration value of the dst entry.

If we insert new routing non-expiry information into the ipv6 fib where
we already have a matching rt6_info we only clear the RTF_EXPIRES flag
in rt6i_flags and leave the dst.expires value as is.

When new mtu information arrives for that cached dst_entry we again
call dst_set_expires. This time it won't update the dst.expire value
because we left the dst.expire value intact from the last update. So
dst_set_expires won't touch dst.expires.

Fix this by resetting dst.expires when clearing the RTF_EXPIRE flag.
dst_set_expires checks for a zero expiration and updates the
dst.expires.

In the past this (not updating dst.expires) was necessary because
dst.expire was placed in a union with the dst_entry *from reference
and rt6_clean_expires did assign NULL to it. This split happend in
ecd9883724b78cc72ed92c98bcb1a46c764fff21 ("ipv6: fix race condition
regarding dst->expires and dst->from").

Reported-by: Steinar H. Gunderson <sgunderson@bigfoot.com>
Reported-by: Valentijn Sessink <valentyn@blub.net>
Cc: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Acked-by: Eric Dumazet <edumazet@google.com>
Tested-by: Valentijn Sessink <valentyn@blub.net>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 include/net/ip6_fib.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/net/ip6_fib.h b/include/net/ip6_fib.h
index 28d27a6..90d7b4c 100644
--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -167,6 +167,7 @@ static inline struct inet6_dev *ip6_dst_idev(struct dst_entry *dst)
 static inline void rt6_clean_expires(struct rt6_info *rt)
 {
 	rt->rt6i_flags &= ~RTF_EXPIRES;
+	rt->dst.expires = 0;
 }
 
 static inline void rt6_set_expires(struct rt6_info *rt, unsigned long expires)
-- 
1.8.3.2

