Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000Ab3FDW5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 18:57:37 -0400
Received: from 1wt.eu ([62.212.114.60]:35741 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab3FDWn3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:43:29 -0400
Message-Id: <20130604172137.017070009@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:24:12 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Mathias Krause <minipli@googlemail.com>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 162/184] dcbnl: fix various netlink info leaks
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 2.6.32: no support for IEEE or CEE commands, so only
 deal with perm_addr]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/dcb/dcbnl.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/dcb/dcbnl.c b/net/dcb/dcbnl.c
index ac1205d..813fe4b 100644
--- a/net/dcb/dcbnl.c
+++ b/net/dcb/dcbnl.c
@@ -307,6 +307,7 @@ static int dcbnl_getperm_hwaddr(struct net_device *netdev, struct nlattr **tb,
 	dcb->dcb_family = AF_UNSPEC;
 	dcb->cmd = DCB_CMD_GPERM_HWADDR;
 
+	memset(perm_addr, 0, sizeof(perm_addr));
 	netdev->dcbnl_ops->getpermhwaddr(netdev, perm_addr);
 
 	ret = nla_put(dcbnl_skb, DCB_ATTR_PERM_HWADDR, sizeof(perm_addr),
-- 
1.7.12.2.21.g234cd45.dirty



