Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760527Ab3B0AM6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 19:12:58 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42960 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760447Ab3B0AJ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 19:09:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ying Xue <ying.xue@windriver.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 74/86] net: fix a compile error when SOCK_REFCNT_DEBUG is enabled
Date: Tue, 26 Feb 2013 16:08:22 -0800
Message-Id: <20130226235920.624217932@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130226235912.881663118@linuxfoundation.org>
References: <20130226235912.881663118@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sock.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -944,7 +944,7 @@ static inline void sk_refcnt_debug_dec(s
 	       sk->sk_prot->name, sk, atomic_read(&sk->sk_prot->socks));
 }
 
-inline void sk_refcnt_debug_release(const struct sock *sk)
+static inline void sk_refcnt_debug_release(const struct sock *sk)
 {
 	if (atomic_read(&sk->sk_refcnt) != 1)
 		printk(KERN_DEBUG "Destruction of the %s socket %p delayed, refcnt=%d\n",


