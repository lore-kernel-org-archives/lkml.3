Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab3FYSf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:35:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41238 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042Ab3FYSfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:35:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Neal Cardwell <ncardwell@google.com>
Subject: [ 08/27] ipv6: fix possible crashes in ip6_cork_release()
Date: Tue, 25 Jun 2013 11:35:27 -0700
Message-Id: <20130625183518.652049731@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625183517.651770593@linuxfoundation.org>
References: <20130625183517.651770593@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 284041ef21fdf2e0d216ab6b787bc9072b4eb58a ]

commit 0178b695fd6b4 ("ipv6: Copy cork options in ip6_append_data")
added some code duplication and bad error recovery, leading to potential
crash in ip6_cork_release() as kfree() could be called with garbage.

use kzalloc() to make sure this wont happen.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1236,7 +1236,7 @@ int ip6_append_data(struct sock *sk, int
 			if (WARN_ON(np->cork.opt))
 				return -EINVAL;
 
-			np->cork.opt = kmalloc(opt->tot_len, sk->sk_allocation);
+			np->cork.opt = kzalloc(opt->tot_len, sk->sk_allocation);
 			if (unlikely(np->cork.opt == NULL))
 				return -ENOBUFS;
 


