Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762274AbbA2Chj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 21:37:39 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47000 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965254AbbA2Chb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 21:37:31 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Bader <stefan.bader@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13.y-ckt 018/139] xen-netfront: use correct linear area after linearizing an skb
Date: Wed, 28 Jan 2015 14:19:21 -0800
Message-Id: <1422483682-15393-19-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422483682-15393-1-git-send-email-kamal@canonical.com>
References: <1422483682-15393-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11-ckt15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 11d3d2a16cc1f05c6ece69a4392e99efb85666a6 upstream.

Commit 97a6d1bb2b658ac85ed88205ccd1ab809899884d (xen-netfront: Fix
handling packets on compound pages with skb_linearize) attempted to
fix a problem where an skb that would have required too many slots
would be dropped causing TCP connections to stall.

However, it filled in the first slot using the original buffer and not
the new one and would use the wrong offset and grant access to the
wrong page.

Netback would notice the malformed request and stop all traffic on the
VIF, reporting:

    vif vif-3-0 vif3.0: txreq.offset: 85e, size: 4002, end: 6144
    vif vif-3-0 vif3.0: fatal error; disabling device

Reported-by: Anthony Wright <anthony@overnetdata.com>
Tested-by: Anthony Wright <anthony@overnetdata.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
BugLink: http://bugs.launchpad.net/bugs/1317811
Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/xen-netfront.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index a3ed8de..9f02c5a 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -572,6 +572,9 @@ static int xennet_start_xmit(struct sk_buff *skb, struct net_device *dev)
 				    slots, skb->len);
 		if (skb_linearize(skb))
 			goto drop;
+		data = skb->data;
+		offset = offset_in_page(data);
+		len = skb_headlen(skb);
 	}
 
 	spin_lock_irqsave(&np->tx_lock, flags);
-- 
1.9.1

