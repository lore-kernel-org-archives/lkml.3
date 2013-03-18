Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3CRV1I (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 17:27:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45946 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3CRVIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 17:08:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 47/48] dcbnl: fix various netlink info leaks
Date: Mon, 18 Mar 2013 14:08:55 -0700
Message-Id: <20130318210813.566011616@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.2.434.g9a6c84e.dirty
In-Reply-To: <20130318210810.247845918@linuxfoundation.org>
References: <20130318210810.247845918@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/dcb/dcbnl.c |    7 +++++++
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


