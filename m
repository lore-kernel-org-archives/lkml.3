Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932896AbbAIKuY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 05:50:24 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44540 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757427AbbAIKc3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 05:32:29 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 06/78] xen-netfront: Remove BUGs on paged skb data which crosses a page boundary
Date: Fri,  9 Jan 2015 11:31:15 +0100
Message-Id: <7493962219d95121cf95214db07df51373020363.1420799385.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.1
In-Reply-To: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
References: <72002f1f248c28d1715d10454190e209d5a20fe1.1420799385.git.jslaby@suse.cz>
In-Reply-To: <cover.1420799385.git.jslaby@suse.cz>
References: <cover.1420799385.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Seth Forshee <seth.forshee@canonical.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit 8d609725d4357f499e2103e46011308b32f53513 ]

These BUGs can be erroneously triggered by frags which refer to
tail pages within a compound page. The data in these pages may
overrun the hardware page while still being contained within the
compound page, but since compound_order() evaluates to 0 for tail
pages the assertion fails. The code already iterates through
subsequent pages correctly in this scenario, so the BUGs are
unnecessary and can be removed.

Fixes: f36c374782e4 ("xen/netfront: handle compound page fragments on transmit")
Cc: <stable@vger.kernel.org> # 3.7+
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/xen-netfront.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 7c541dc1647e..fd3c1da14495 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -468,9 +468,6 @@ static void xennet_make_frags(struct sk_buff *skb, struct net_device *dev,
 		len = skb_frag_size(frag);
 		offset = frag->page_offset;
 
-		/* Data must not cross a page boundary. */
-		BUG_ON(len + offset > PAGE_SIZE<<compound_order(page));
-
 		/* Skip unused frames from start of page */
 		page += offset >> PAGE_SHIFT;
 		offset &= ~PAGE_MASK;
@@ -478,8 +475,6 @@ static void xennet_make_frags(struct sk_buff *skb, struct net_device *dev,
 		while (len > 0) {
 			unsigned long bytes;
 
-			BUG_ON(offset >= PAGE_SIZE);
-
 			bytes = PAGE_SIZE - offset;
 			if (bytes > len)
 				bytes = len;
-- 
2.2.1

