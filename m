Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaLNU1c (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:27:32 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53301 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaLNUZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:25:21 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Anthony Wright <anthony@overnetdata.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 41/47] xen-netfront: use correct linear area after linearizing an skb
Date: Sun, 14 Dec 2014 12:21:16 -0800
Message-Id: <20141214201820.117196570@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201818.552715149@linuxfoundation.org>
References: <20141214201818.552715149@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

[ Upstream commit 11d3d2a16cc1f05c6ece69a4392e99efb85666a6 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/xen-netfront.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -627,6 +627,9 @@ static int xennet_start_xmit(struct sk_b
 				    slots, skb->len);
 		if (skb_linearize(skb))
 			goto drop;
+		data = skb->data;
+		offset = offset_in_page(data);
+		len = skb_headlen(skb);
 	}
 
 	spin_lock_irqsave(&queue->tx_lock, flags);


