Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036AbaLNUvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 15:51:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:52881 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaLNUVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 15:21:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>,
        David Vrabel <david.vrabel@citrix.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 03/24] xen-netfront: Remove BUGs on paged skb data which crosses a page boundary
Date: Sun, 14 Dec 2014 12:20:23 -0800
Message-Id: <20141214201800.733102544@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141214201800.613573495@linuxfoundation.org>
References: <20141214201800.613573495@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/xen-netfront.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/net/xen-netfront.c
+++ b/drivers/net/xen-netfront.c
@@ -459,9 +459,6 @@ static void xennet_make_frags(struct sk_
 		len = skb_frag_size(frag);
 		offset = frag->page_offset;
 
-		/* Data must not cross a page boundary. */
-		BUG_ON(len + offset > PAGE_SIZE<<compound_order(page));
-
 		/* Skip unused frames from start of page */
 		page += offset >> PAGE_SHIFT;
 		offset &= ~PAGE_MASK;
@@ -469,8 +466,6 @@ static void xennet_make_frags(struct sk_
 		while (len > 0) {
 			unsigned long bytes;
 
-			BUG_ON(offset >= PAGE_SIZE);
-
 			bytes = PAGE_SIZE - offset;
 			if (bytes > len)
 				bytes = len;


