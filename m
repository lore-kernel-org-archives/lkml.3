Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752453AbaHTRyu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:54:50 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:62746 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750819AbaHTRys (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:54:48 -0400
Date: Wed, 20 Aug 2014 23:24:40 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] af_decnet: Use time_after_eq
Message-ID: <20140820175440.GA4556@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The functions time_before, time_before_eq, time_after, and time_after_eq
are more robust for comparing jiffies against other values.

A simplified version of the Coccinelle semantic patch making this change
is as follows:

@change@
expression E1,E2,E3;
@@
- jiffies - E1 >= (E2*E3)
+ time_after_eq(jiffies, E1+E2*E3)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 net/decnet/af_decnet.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/decnet/af_decnet.c b/net/decnet/af_decnet.c
index ae011b4..25733d5 100644
--- a/net/decnet/af_decnet.c
+++ b/net/decnet/af_decnet.c
@@ -127,6 +127,7 @@ Version 0.0.6    2.1.110   07-aug-98   Eduardo Marcelo Serrat
 #include <linux/stat.h>
 #include <linux/init.h>
 #include <linux/poll.h>
+#include <linux/jiffies.h>
 #include <net/net_namespace.h>
 #include <net/neighbour.h>
 #include <net/dst.h>
@@ -598,7 +599,7 @@ int dn_destroy_timer(struct sock *sk)
 	if (sk->sk_socket)
 		return 0;
 
-	if ((jiffies - scp->stamp) >= (HZ * decnet_time_wait)) {
+	if (time_after_eq(jiffies, scp->stamp + HZ * decnet_time_wait)) {
 		dn_unhash_sock(sk);
 		sock_put(sk);
 		return 1;
-- 
1.9.1

