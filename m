Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3B1OyV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:54:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42547 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116Ab3B1OvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:51:12 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ying Xue <ying.xue@windriver.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 129/139] net: fix a compile error when SOCK_REFCNT_DEBUG is enabled
Date: Thu, 28 Feb 2013 14:44:39 +0000
Message-Id: <1362062689-2567-130-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ying Xue <ying.xue@windriver.com>

commit dec34fb0f5b7873de45132a84a3af29e61084a6b upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/net/sock.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/sock.h b/include/net/sock.h
index 5de6557..5e904e6 100644
--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -979,7 +979,7 @@ static inline void sk_refcnt_debug_dec(struct sock *sk)
 	       sk->sk_prot->name, sk, atomic_read(&sk->sk_prot->socks));
 }
 
-inline void sk_refcnt_debug_release(const struct sock *sk)
+static inline void sk_refcnt_debug_release(const struct sock *sk)
 {
 	if (atomic_read(&sk->sk_refcnt) != 1)
 		printk(KERN_DEBUG "Destruction of the %s socket %p delayed, refcnt=%d\n",
-- 
1.8.1.2

