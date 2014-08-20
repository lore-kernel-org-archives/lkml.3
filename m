Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaHTRnO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 13:43:14 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42786 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751625AbaHTRnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 13:43:12 -0400
Date: Wed, 20 Aug 2014 23:13:07 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "David S. Miller" <davem@davemloft.net>,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: [PATCH] dn_dev: Use time_before
Message-ID: <20140820174306.GA4180@himangi-Dell>
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
expression E1,E2;
@@

(
- (jiffies - E1) < E2
+ time_before(jiffies, E1+E2)
)

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 net/decnet/dn_dev.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/decnet/dn_dev.c b/net/decnet/dn_dev.c
index 3b726f3..4400da7 100644
--- a/net/decnet/dn_dev.c
+++ b/net/decnet/dn_dev.c
@@ -41,6 +41,7 @@
 #include <linux/sysctl.h>
 #include <linux/notifier.h>
 #include <linux/slab.h>
+#include <linux/jiffies.h>
 #include <asm/uaccess.h>
 #include <net/net_namespace.h>
 #include <net/neighbour.h>
@@ -875,7 +876,7 @@ static void dn_send_endnode_hello(struct net_device *dev, struct dn_ifaddr *ifa)
 static int dn_am_i_a_router(struct dn_neigh *dn, struct dn_dev *dn_db, struct dn_ifaddr *ifa)
 {
 	/* First check time since device went up */
-	if ((jiffies - dn_db->uptime) < DRDELAY)
+	if (time_before(jiffies, dn_db->uptime + DRDELAY))
 		return 0;
 
 	/* If there is no router, then yes... */
-- 
1.9.1

