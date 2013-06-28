Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3F1SyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 14:54:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41637 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144Ab3F1SyV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:54:21 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Neal Cardwell <ncardwell@google.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 068/105] ipv6: fix possible crashes in ip6_cork_release()
Date: Fri, 28 Jun 2013 11:51:30 -0700
Message-Id: <1372445527-24414-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 0c7c03d..2adff32 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1164,7 +1164,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 			if (WARN_ON(np->cork.opt))
 				return -EINVAL;
 
-			np->cork.opt = kmalloc(opt->tot_len, sk->sk_allocation);
+			np->cork.opt = kzalloc(opt->tot_len, sk->sk_allocation);
 			if (unlikely(np->cork.opt == NULL))
 				return -ENOBUFS;
 
-- 
1.8.1.2

