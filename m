Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934166Ab3CZQLd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:11:33 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53677 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964938Ab3CZPWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:17 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Moore <pmoore@redhat.com>, "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 044/150] netlabel: fix build problems when CONFIG_IPV6=n
Date: Tue, 26 Mar 2013 15:19:03 +0000
Message-Id: <1364311249-14454-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

commit a6a8fe950e1b8596bb06f2c89c3a1a4bf2011ba9 upstream.

My last patch to solve a problem where the static/fallback labels were
not fully displayed resulted in build problems when IPv6 was disabled.
This patch resolves the IPv6 build problems; sorry for the screw-up.

Please queue for -stable or simply merge with the previous patch.

Reported-by: Kbuild Test Robot <fengguang.wu@intel.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/netlabel/netlabel_unlabeled.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index 8a0df47..7fe20d0 100644
--- a/net/netlabel/netlabel_unlabeled.c
+++ b/net/netlabel/netlabel_unlabeled.c
@@ -1189,8 +1189,6 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 	struct netlbl_unlhsh_walk_arg cb_arg;
 	u32 skip_bkt = cb->args[0];
 	u32 skip_chain = cb->args[1];
-	u32 skip_addr4 = cb->args[2];
-	u32 skip_addr6 = cb->args[3];
 	u32 iter_bkt;
 	u32 iter_chain = 0, iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_unlhsh_iface *iface;
@@ -1215,7 +1213,7 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 				continue;
 			netlbl_af4list_foreach_rcu(addr4,
 						   &iface->addr4_list) {
-				if (iter_addr4++ < skip_addr4)
+				if (iter_addr4++ < cb->args[2])
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1231,7 +1229,7 @@ static int netlbl_unlabel_staticlist(struct sk_buff *skb,
 #if IS_ENABLED(CONFIG_IPV6)
 			netlbl_af6list_foreach_rcu(addr6,
 						   &iface->addr6_list) {
-				if (iter_addr6++ < skip_addr6)
+				if (iter_addr6++ < cb->args[3])
 					continue;
 				if (netlbl_unlabel_staticlist_gen(
 					      NLBL_UNLABEL_C_STATICLIST,
@@ -1273,12 +1271,9 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 {
 	struct netlbl_unlhsh_walk_arg cb_arg;
 	struct netlbl_unlhsh_iface *iface;
-	u32 skip_addr4 = cb->args[0];
-	u32 skip_addr6 = cb->args[1];
-	u32 iter_addr4 = 0;
+	u32 iter_addr4 = 0, iter_addr6 = 0;
 	struct netlbl_af4list *addr4;
 #if IS_ENABLED(CONFIG_IPV6)
-	u32 iter_addr6 = 0;
 	struct netlbl_af6list *addr6;
 #endif
 
@@ -1292,7 +1287,7 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 		goto unlabel_staticlistdef_return;
 
 	netlbl_af4list_foreach_rcu(addr4, &iface->addr4_list) {
-		if (iter_addr4++ < skip_addr4)
+		if (iter_addr4++ < cb->args[0])
 			continue;
 		if (netlbl_unlabel_staticlist_gen(NLBL_UNLABEL_C_STATICLISTDEF,
 					      iface,
@@ -1305,7 +1300,7 @@ static int netlbl_unlabel_staticlistdef(struct sk_buff *skb,
 	}
 #if IS_ENABLED(CONFIG_IPV6)
 	netlbl_af6list_foreach_rcu(addr6, &iface->addr6_list) {
-		if (iter_addr6++ < skip_addr6)
+		if (iter_addr6++ < cb->args[1])
 			continue;
 		if (netlbl_unlabel_staticlist_gen(NLBL_UNLABEL_C_STATICLISTDEF,
 					      iface,
-- 
1.8.1.2

