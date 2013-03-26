Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754625Ab3CZRib (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 13:38:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21945 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754385Ab3CZRgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 13:36:36 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=eBNiE1qmL9oA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=j6JXdZbvbTAA:10 a=mK_AVkanAAAA:8 a=J1Y8HTJGAAAA:8 a=4GEhVLJy-apUUS-8O-sA:9 a=9xyTavCNlvEA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130326173609.037285459@goodmis.org>
User-Agent: quilt/0.60-1
Date: Tue, 26 Mar 2013 13:21:56 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 57/86] dcbnl: fix various netlink info leaks
References: <20130326172059.136127374@goodmis.org>
Content-Disposition: inline; filename=0057-dcbnl-fix-various-netlink-info-leaks.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.1 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

[ Upstream commit 29cd8ae0e1a39e239a3a7b67da1986add1199fc0 ]

The dcb netlink interface leaks stack memory in various places:
* perm_addr[] buffer is only filled at max with 12 of the 32 bytes but
  copied completely,
* no in-kernel driver fills all fields of an IEEE 802.1Qaz subcommand,
  so we're leaking up to 58 bytes for ieee_ets structs, up to 136 bytes
  for ieee_pfc structs, etc.,
* the same is true for CEE -- no in-kernel driver fills the whole
  struct,

Prevent all of the above stack info leaks by properly initializing the
buffers/structures involved.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 net/dcb/dcbnl.c |    8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 81f2bb6..eb1b2eb 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -284,6 +284,7 @@ static int dcbnl_getperm_hwaddr(struct net_device *netdev, struct nlmsghdr *nlh,
 	if (!netdev->dcbnl_ops->getpermhwaddr)
 		return -EOPNOTSUPP;
 
+	memset(perm_addr, 0, sizeof(perm_addr));
 	netdev->dcbnl_ops->getpermhwaddr(netdev, perm_addr);
 
 	return nla_put(skb, DCB_ATTR_PERM_HWADDR, sizeof(perm_addr), perm_addr);
@@ -1042,6 +1043,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_getets) {
 		struct ieee_ets ets;
+		memset(&ets, 0, sizeof(ets));
 		err = ops->ieee_getets(netdev, &ets);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_ETS, sizeof(ets), &ets))
@@ -1050,6 +1052,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_getmaxrate) {
 		struct ieee_maxrate maxrate;
+		memset(&maxrate, 0, sizeof(maxrate));
 		err = ops->ieee_getmaxrate(netdev, &maxrate);
 		if (!err) {
 			err = nla_put(skb, DCB_ATTR_IEEE_MAXRATE,
@@ -1061,6 +1064,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_getpfc) {
 		struct ieee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->ieee_getpfc(netdev, &pfc);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_PFC, sizeof(pfc), &pfc))
@@ -1094,6 +1098,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	/* get peer info if available */
 	if (ops->ieee_peer_getets) {
 		struct ieee_ets ets;
+		memset(&ets, 0, sizeof(ets));
 		err = ops->ieee_peer_getets(netdev, &ets);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_PEER_ETS, sizeof(ets), &ets))
@@ -1102,6 +1107,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_peer_getpfc) {
 		struct ieee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->ieee_peer_getpfc(netdev, &pfc);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_PEER_PFC, sizeof(pfc), &pfc))
@@ -1280,6 +1286,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 	/* peer info if available */
 	if (ops->cee_peer_getpg) {
 		struct cee_pg pg;
+		memset(&pg, 0, sizeof(pg));
 		err = ops->cee_peer_getpg(netdev, &pg);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_CEE_PEER_PG, sizeof(pg), &pg))
@@ -1288,6 +1295,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->cee_peer_getpfc) {
 		struct cee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->cee_peer_getpfc(netdev, &pfc);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_CEE_PEER_PFC, sizeof(pfc), &pfc))
-- 
1.7.10.4


