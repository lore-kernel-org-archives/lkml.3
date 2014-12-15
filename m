Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579AbaLOOe4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:34:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:38934 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaLOO3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:29:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Seth Forshee <seth.forshee@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 143/168] xen-netfront: Remove BUGs on paged skb data which crosses a page boundary
Date: Mon, 15 Dec 2014 14:26:37 +0000
Message-Id: <1418653622-21105-144-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
References: <1418653622-21105-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Seth Forshee <seth.forshee@canonical.com>

commit 8d609725d4357f499e2103e46011308b32f53513 upstream.

These BUGs can be erroneously triggered by frags which refer to
tail pages within a compound page. The data in these pages may
overrun the hardware page while still being contained within the
compound page, but since compound_order() evaluates to 0 for tail
pages the assertion fails. The code already iterates through
subsequent pages correctly in this scenario, so the BUGs are
unnecessary and can be removed.

Fixes: f36c374782e4 ("xen/netfront: handle compound page fragments on transmit")
Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Reviewed-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/xen-netfront.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/net/xen-netfront.c b/drivers/net/xen-netfront.c
index 055222bae6e4..7a4cd11e6a07 100644
--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -496,9 +496,6 @@ static void xennet_make_frags(struct sk_buff *skb, struct netfront_queue *queue,
 		len = skb_frag_size(frag);
 		offset = frag->page_offset;
 
-		/* Data must not cross a page boundary. */
-		BUG_ON(len + offset > PAGE_SIZE<<compound_order(page));
-
 		/* Skip unused frames from start of page */
 		page += offset >> PAGE_SHIFT;
 		offset &= ~PAGE_MASK;
@@ -506,8 +503,6 @@ static void xennet_make_frags(struct sk_buff *skb, struct netfront_queue *queue,
 		while (len > 0) {
 			unsigned long bytes;
 
-			BUG_ON(offset >= PAGE_SIZE);
-
 			bytes = PAGE_SIZE - offset;
 			if (bytes > len)
 				bytes = len;
-- 
2.1.3

