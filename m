Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964983Ab3CZQKu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 12:10:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53699 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964955Ab3CZPWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:22:20 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 048/150] dcbnl: fix various netlink info leaks
Date: Tue, 26 Mar 2013 15:19:07 +0000
Message-Id: <1364311249-14454-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mathias Krause <minipli@googlemail.com>

commit 29cd8ae0e1a39e239a3a7b67da1986add1199fc0 upstream.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 net/dcb/dcbnl.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index 656c7c7..9499791 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -337,6 +337,7 @@ static int dcbnl_getperm_hwaddr(struct net_device *netdev, struct nlattr **tb,
 	dcb->dcb_family = AF_UNSPEC;
 	dcb->cmd = DCB_CMD_GPERM_HWADDR;
 
+	memset(perm_addr, 0, sizeof(perm_addr));
 	netdev->dcbnl_ops->getpermhwaddr(netdev, perm_addr);
 
 	ret = nla_put(dcbnl_skb, DCB_ATTR_PERM_HWADDR, sizeof(perm_addr),
@@ -1243,6 +1244,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_getets) {
 		struct ieee_ets ets;
+		memset(&ets, 0, sizeof(ets));
 		err = ops->ieee_getets(netdev, &ets);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_ETS, sizeof(ets), &ets))
@@ -1251,6 +1253,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_getmaxrate) {
 		struct ieee_maxrate maxrate;
+		memset(&maxrate, 0, sizeof(maxrate));
 		err = ops->ieee_getmaxrate(netdev, &maxrate);
 		if (!err) {
 			err = nla_put(skb, DCB_ATTR_IEEE_MAXRATE,
@@ -1262,6 +1265,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_getpfc) {
 		struct ieee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->ieee_getpfc(netdev, &pfc);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_PFC, sizeof(pfc), &pfc))
@@ -1295,6 +1299,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 	/* get peer info if available */
 	if (ops->ieee_peer_getets) {
 		struct ieee_ets ets;
+		memset(&ets, 0, sizeof(ets));
 		err = ops->ieee_peer_getets(netdev, &ets);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_PEER_ETS, sizeof(ets), &ets))
@@ -1303,6 +1308,7 @@ static int dcbnl_ieee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->ieee_peer_getpfc) {
 		struct ieee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->ieee_peer_getpfc(netdev, &pfc);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_IEEE_PEER_PFC, sizeof(pfc), &pfc))
@@ -1487,6 +1493,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 	/* peer info if available */
 	if (ops->cee_peer_getpg) {
 		struct cee_pg pg;
+		memset(&pg, 0, sizeof(pg));
 		err = ops->cee_peer_getpg(netdev, &pg);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_CEE_PEER_PG, sizeof(pg), &pg))
@@ -1495,6 +1502,7 @@ static int dcbnl_cee_fill(struct sk_buff *skb, struct net_device *netdev)
 
 	if (ops->cee_peer_getpfc) {
 		struct cee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->cee_peer_getpfc(netdev, &pfc);
 		if (!err &&
 		    nla_put(skb, DCB_ATTR_CEE_PEER_PFC, sizeof(pfc), &pfc))
-- 
1.8.1.2

