Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752522Ab3FZCqM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 22:46:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54156 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752129Ab3FZCp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 22:45:27 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Neal Cardwell" <ncardwell@google.com>,
        "Herbert Xu" <herbert@gondor.hengli.com.au>,
        "Eric Dumazet" <edumazet@google.com>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 26 Jun 2013 03:35:58 +0100
Message-ID: <lsq.1372214158.376527225@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [14/26] ipv6: fix possible crashes in ip6_cork_release()
In-Reply-To: <lsq.1372214158.425780530@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.48-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ipv6/ip6_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 3ccd9b2..6aadaa8 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1233,7 +1233,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 			if (WARN_ON(np->cork.opt))
 				return -EINVAL;
 
-			np->cork.opt = kmalloc(opt->tot_len, sk->sk_allocation);
+			np->cork.opt = kzalloc(opt->tot_len, sk->sk_allocation);
 			if (unlikely(np->cork.opt == NULL))
 				return -ENOBUFS;
 

