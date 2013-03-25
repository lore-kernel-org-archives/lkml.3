Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab3CYBj0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:39:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33793 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438Ab3CYBPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:15:04 -0400
Message-Id: <20130325010525.843130800@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:39 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 015/104] dcbnl: fix various netlink info leaks
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/dcb/dcbnl.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -336,6 +336,7 @@ static int dcbnl_getperm_hwaddr(struct n
 	dcb->dcb_family = AF_UNSPEC;
 	dcb->cmd = DCB_CMD_GPERM_HWADDR;
 
+	memset(perm_addr, 0, sizeof(perm_addr));
 	netdev->dcbnl_ops->getpermhwaddr(netdev, perm_addr);
 
 	ret = nla_put(dcbnl_skb, DCB_ATTR_PERM_HWADDR, sizeof(perm_addr),
@@ -1238,6 +1239,7 @@ static int dcbnl_ieee_fill(struct sk_buf
 
 	if (ops->ieee_getets) {
 		struct ieee_ets ets;
+		memset(&ets, 0, sizeof(ets));
 		err = ops->ieee_getets(netdev, &ets);
 		if (!err)
 			NLA_PUT(skb, DCB_ATTR_IEEE_ETS, sizeof(ets), &ets);
@@ -1245,6 +1247,7 @@ static int dcbnl_ieee_fill(struct sk_buf
 
 	if (ops->ieee_getpfc) {
 		struct ieee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->ieee_getpfc(netdev, &pfc);
 		if (!err)
 			NLA_PUT(skb, DCB_ATTR_IEEE_PFC, sizeof(pfc), &pfc);
@@ -1277,6 +1280,7 @@ static int dcbnl_ieee_fill(struct sk_buf
 	/* get peer info if available */
 	if (ops->ieee_peer_getets) {
 		struct ieee_ets ets;
+		memset(&ets, 0, sizeof(ets));
 		err = ops->ieee_peer_getets(netdev, &ets);
 		if (!err)
 			NLA_PUT(skb, DCB_ATTR_IEEE_PEER_ETS, sizeof(ets), &ets);
@@ -1284,6 +1288,7 @@ static int dcbnl_ieee_fill(struct sk_buf
 
 	if (ops->ieee_peer_getpfc) {
 		struct ieee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->ieee_peer_getpfc(netdev, &pfc);
 		if (!err)
 			NLA_PUT(skb, DCB_ATTR_IEEE_PEER_PFC, sizeof(pfc), &pfc);
@@ -1463,6 +1468,7 @@ static int dcbnl_cee_fill(struct sk_buff
 	/* peer info if available */
 	if (ops->cee_peer_getpg) {
 		struct cee_pg pg;
+		memset(&pg, 0, sizeof(pg));
 		err = ops->cee_peer_getpg(netdev, &pg);
 		if (!err)
 			NLA_PUT(skb, DCB_ATTR_CEE_PEER_PG, sizeof(pg), &pg);
@@ -1470,6 +1476,7 @@ static int dcbnl_cee_fill(struct sk_buff
 
 	if (ops->cee_peer_getpfc) {
 		struct cee_pfc pfc;
+		memset(&pfc, 0, sizeof(pfc));
 		err = ops->cee_peer_getpfc(netdev, &pfc);
 		if (!err)
 			NLA_PUT(skb, DCB_ATTR_CEE_PEER_PFC, sizeof(pfc), &pfc);


