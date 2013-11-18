Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab3KRTBE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 14:01:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57465 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751959Ab3KRSkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:40:46 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Steinar H. Gunderson" <sgunderson@bigfoot.com>,
        Valentijn Sessink <valentyn@blub.net>,
        YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>,
        Eric Dumazet <edumazet@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.11 09/25] ipv6: reset dst.expires value when clearing expire flag
Date: Mon, 18 Nov 2013 10:40:38 -0800
Message-Id: <20131118184035.168853423@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184032.248465920@linuxfoundation.org>
References: <20131118184032.248465920@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip6_fib.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/net/ip6_fib.h
+++ b/include/net/ip6_fib.h
@@ -165,6 +165,7 @@ static inline struct inet6_dev *ip6_dst_
 static inline void rt6_clean_expires(struct rt6_info *rt)
 {
 	rt->rt6i_flags &= ~RTF_EXPIRES;
+	rt->dst.expires = 0;
 }
 
 static inline void rt6_set_expires(struct rt6_info *rt, unsigned long expires)


