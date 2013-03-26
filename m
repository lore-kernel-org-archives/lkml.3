Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab3CZRny (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:43:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab3CZRgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:24 -0400
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=vlSwbVFKw24A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=PCIzzkmUXfYA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=J1Y8HTJGAAAA:8 a=8eMvtHSQL7EHquPUrckA:9 a=jEp0ucaQiEUA:10 a=dGJ0OcVc7YAA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173608.292268681@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Kbuild Test Robot <fengguang.wu@intel.com>, Paul Moore <pmoore@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 52/86] netlabel: fix build problems when CONFIG_IPV6=n
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0052-netlabel-fix-build-problems-when-CONFIG_IPV6-n.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Paul Moore <pmoore@redhat.com>

[ Upstream commit a6a8fe950e1b8596bb06f2c89c3a1a4bf2011ba9 ]

My last patch to solve a problem where the static/fallback labels were
not fully displayed resulted in build problems when IPv6 was disabled.
This patch resolves the IPv6 build problems; sorry for the screw-up.

Please queue for -stable or simply merge with the previous patch.

Reported-by: Kbuild Test Robot <fengguang.wu@intel.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/netlabel/netlabel_unlabeled.c |   15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_unlabeled.c
index e7ff694..c39d63c 100644
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
1.7.10.4


