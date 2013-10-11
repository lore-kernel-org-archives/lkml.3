Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab3JKUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 16:16:57 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932290Ab3JKTk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 15:40:57 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Daniel Borkmann <dborkman@redhat.com>, Lin Ming <mlin@ss.pku.edu.cn>,
        Matti Vaittinen <matti.vaittinen@nsn.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 010/135] net: fib: fib6_add: fix potential NULL pointer dereference
Date: Fri, 11 Oct 2013 12:38:11 -0700
Message-Id: <20131011193946.347613112@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131011193945.181603934@linuxfoundation.org>
References: <20131011193945.181603934@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <dborkman@redhat.com>

[ Upstream commit ae7b4e1f213aa659aedf9c6ecad0bf5f0476e1e2 ]

When the kernel is compiled with CONFIG_IPV6_SUBTREES, and we return
with an error in fn = fib6_add_1(), then error codes are encoded into
the return pointer e.g. ERR_PTR(-ENOENT). In such an error case, we
write the error code into err and jump to out, hence enter the if(err)
condition. Now, if CONFIG_IPV6_SUBTREES is enabled, we check for:

  if (pn != fn && pn->leaf == rt)
    ...
  if (pn != fn && !pn->leaf && !(pn->fn_flags & RTN_RTINFO))
    ...

Since pn is NULL and fn is f.e. ERR_PTR(-ENOENT), then pn != fn
evaluates to true and causes a NULL-pointer dereference on further
checks on pn. Fix it, by setting both NULL in error case, so that
pn != fn already evaluates to false and no further dereference
takes place.

This was first correctly implemented in 4a287eba2 ("IPv6 routing,
NLM_F_* flag support: REPLACE and EXCL flags support, warn about
missing CREATE flag"), but the bug got later on introduced by
188c517a0 ("ipv6: return errno pointers consistently for fib6_add_1()").

Signed-off-by: Daniel Borkmann <dborkman@redhat.com>
Cc: Lin Ming <mlin@ss.pku.edu.cn>
Cc: Matti Vaittinen <matti.vaittinen@nsn.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Acked-by: Matti Vaittinen <matti.vaittinen@nsn.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_fib.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -825,9 +825,9 @@ int fib6_add(struct fib6_node *root, str
 	fn = fib6_add_1(root, &rt->rt6i_dst.addr, sizeof(struct in6_addr),
 			rt->rt6i_dst.plen, offsetof(struct rt6_info, rt6i_dst),
 			allow_create, replace_required);
-
 	if (IS_ERR(fn)) {
 		err = PTR_ERR(fn);
+		fn = NULL;
 		goto out;
 	}
 


