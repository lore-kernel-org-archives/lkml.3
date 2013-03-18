Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab3CRVQI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:16:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46113 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932378Ab3CRVKW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:10:22 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Moore <pmoore@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 36/40] netlabel: correctly list all the static label mappings
Date: Mon, 18 Mar 2013 14:11:14 -0700
Message-Id: <20130318211018.857192841@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318211016.254453918@linuxfoundation.org>
References: <20130318211016.254453918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Paul Moore <pmoore@redhat.com>

[ Upstream commits 0c1233aba1e948c37f6dc7620cb7c253fcd71ce9 and
  a6a8fe950e1b8596bb06f2c89c3a1a4bf2011ba9 ]

When we have a large number of static label mappings that spill across
the netlink message boundary we fail to properly save our state in the
netlink_callback struct which causes us to repeat the same listings.
This patch fixes this problem by saving the state correctly between
calls to the NetLabel static label netlink "dumpit" routines.

Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netlabel/netlabel_unlabeled.c |   27 +++++++++++----------------
 1 file changed, 11 insertions(+), 16 deletions(-)

--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1192,8 +1192,6 @@ static int netlbl_unlabel_staticlist(str
 	struct netlbl_unlhsh_walk_arg cb_arg;
 	u32 skip_bkt = cb->args[0];
 	u32 skip_chain = cb->args[1];
-	u32 skip_addr4 = cb->args[2];
-	u32 skip_addr6 = cb->args[3];
 	u32 iter_bkt;
 	u32 iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_unlhsh_iface *iface;
@@ -1218,7 +1216,7 @@ static int netlbl_unlabel_staticlist(str
 				continue;
 			netlbl_af4list_foreach_rcu(addr4,
 						   &iface->addr4_list) {
-				if (iter_addr4++ < skip_addr4)
+				if (iter_addr4++ < cb->args[2])
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1234,7 +1232,7 @@ static int netlbl_unlabel_staticlist(str
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 			netlbl_af6list_foreach_rcu(addr6,
 						   &iface->addr6_list) {
-				if (iter_addr6++ < skip_addr6)
+				if (iter_addr6++ < cb->args[3])
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1253,10 +1251,10 @@ static int netlbl_unlabel_staticlist(str
 
 unlabel_staticlist_return:
 	rcu_read_unlock();
-	cb->args[0] = skip_bkt;
-	cb->args[1] = skip_chain;
-	cb->args[2] = skip_addr4;
-	cb->args[3] = skip_addr6;
+	cb->args[0] = iter_bkt;
+	cb->args[1] = iter_chain;
+	cb->args[2] = iter_addr4;
+	cb->args[3] = iter_addr6;
 	return skb->len;
 }
 
@@ -1276,12 +1274,9 @@ static int netlbl_unlabel_staticlistdef(
 {
 	struct netlbl_unlhsh_walk_arg cb_arg;
 	struct netlbl_unlhsh_iface *iface;
-	u32 skip_addr4 = cb->args[0];
-	u32 skip_addr6 = cb->args[1];
-	u32 iter_addr4 = 0;
+	u32 iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_af4list *addr4;
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
-	u32 iter_addr6 = 0;
 	struct netlbl_af6list *addr6;
 #endif
 
@@ -1295,7 +1290,7 @@ static int netlbl_unlabel_staticlistdef(
 		goto unlabel_staticlistdef_return;
 
 	netlbl_af4list_foreach_rcu(addr4, &iface->addr4_list) {
-		if (iter_addr4++ < skip_addr4)
+		if (iter_addr4++ < cb->args[0])
 			continue;
 		if (netlbl_unlabel_staticlist_gen(NLBL_UNLABEL_C_STATICLISTDEF,
 					      iface,
@@ -1308,7 +1303,7 @@ static int netlbl_unlabel_staticlistdef(
 	}
 #if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
 	netlbl_af6list_foreach_rcu(addr6, &iface->addr6_list) {
-		if (iter_addr6++ < skip_addr6)
+		if (iter_addr6++ < cb->args[1])
 			continue;
 		if (netlbl_unlabel_staticlist_gen(NLBL_UNLABEL_C_STATICLISTDEF,
 					      iface,
@@ -1323,8 +1318,8 @@ static int netlbl_unlabel_staticlistdef(
 
 unlabel_staticlistdef_return:
 	rcu_read_unlock();
-	cb->args[0] = skip_addr4;
-	cb->args[1] = skip_addr6;
+	cb->args[0] = iter_addr4;
+	cb->args[1] = iter_addr6;
 	return skb->len;
 }
 


