Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab3HMQLV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 12:11:21 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:13725 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758592Ab3HMP61 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 11:58:27 -0400
X-Authority-Analysis: v=2.0 cv=P6i4d18u c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=2XlrhHUARbkA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=N6GxHJm4w-MA:10 a=1XWaLZrsAAAA:8 a=J1Y8HTJGAAAA:8 a=FNyBlpCuAAAA:8 a=h1aNt0RaAAAA:8 a=5cIBTxRJ4pZzZk2xk6UA:9 a=GY2gF6XR40cA:10 a=UTB_XpHje0EA:10 a=4N9Db7Z2_RYA:10 a=9n0VZpmWo7gA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130813155825.546401589@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 13 Aug 2013 11:57:06 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Neal Cardwell <ncardwell@google.com>
Subject: [12/88] ipv6: fix possible crashes in ip6_cork_release()
References: <20130813155654.069291373@goodmis.org>
Content-Disposition: inline; filename=0012-ipv6-fix-possible-crashes-in-ip6_cork_release.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.7-rc1 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 net/ipv6/ip6_output.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 3d485ec..a26d44c 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1236,7 +1236,7 @@ int ip6_append_data(struct sock *sk, int getfrag(void *from, char *to,
 			if (WARN_ON(np->cork.opt))
 				return -EINVAL;
 
-			np->cork.opt = kmalloc(opt->tot_len, sk->sk_allocation);
+			np->cork.opt = kzalloc(opt->tot_len, sk->sk_allocation);
 			if (unlikely(np->cork.opt == NULL))
 				return -ENOBUFS;
 
-- 
1.7.10.4


