Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab3CZRxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:53:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3CZRgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:17 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=60r1BAEwUS4A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=hWdHafxERpgA:10 a=t7CeM3EgAAAA:8 a=J1Y8HTJGAAAA:8 a=GZK3lcuhIWR5GrNAc6YA:9 a=2e6ZYRoF4I4A:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173606.511525487@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:40 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Ying Xue <ying.xue@windriver.com>, "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 41/86] net: fix a compile error when SOCK_REFCNT_DEBUG is enabled
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0041-net-fix-a-compile-error-when-SOCK_REFCNT_DEBUG-is-en.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Ying Xue <ying.xue@windriver.com>

[ Upstream commit dec34fb0f5b7873de45132a84a3af29e61084a6b ]

When SOCK_REFCNT_DEBUG is enabled, below build error is met:

kernel/sysctl_binary.o: In function `sk_refcnt_debug_release':
include/net/sock.h:1025: multiple definition of `sk_refcnt_debug_release'
kernel/sysctl.o:include/net/sock.h:1025: first defined here
kernel/audit.o: In function `sk_refcnt_debug_release':
include/net/sock.h:1025: multiple definition of `sk_refcnt_debug_release'
kernel/sysctl.o:include/net/sock.h:1025: first defined here
make[1]: *** [kernel/built-in.o] Error 1
make: *** [kernel] Error 2

So we decide to make sk_refcnt_debug_release static to eliminate
the error.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 include/net/sock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index adb7da2..450a2af 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1012,7 +1012,7 @@ static inline void sk_refcnt_debug_dec(struct sock *sk)
 	       sk->sk_prot->name, sk, atomic_read(&sk->sk_prot->socks));
 }
 
-inline void sk_refcnt_debug_release(const struct sock *sk)
+static inline void sk_refcnt_debug_release(const struct sock *sk)
 {
 	if (atomic_read(&sk->sk_refcnt) != 1)
 		printk(KERN_DEBUG "Destruction of the %s socket %p delayed, refcnt=%d\n",
-- 
1.7.10.4


