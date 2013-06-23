Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751806Ab3FWO0S (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 10:26:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab3FWO0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 10:26:15 -0400
Date: Sun, 23 Jun 2013 17:26:58 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: "David S. Miller" <davem@davemloft.net>, Jason Wang <jasowang@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        Brad Hubbard <bhubbard@redhat.com>
Subject: [PATCH net] macvtap: fix recovery from gup errors
Message-ID: <20130623142658.GA21141@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get user pages might fail partially in macvtap zero copy
mode. To recover we need to put all pages that we got,
but code used a wrong index resulting in double-free
errors.

Reported-by: Brad Hubbard <bhubbard@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Same as the tun patch really. Also stable material.

 drivers/net/macvtap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 59e9605..4ddd108 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -524,8 +524,9 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 			return -EMSGSIZE;
 		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
 		if (num_pages != size) {
-			for (i = 0; i < num_pages; i++)
-				put_page(page[i]);
+			int j;
+			for (j = 0; j < num_pages; j++)
+				put_page(page[i + j]);
 			return -EFAULT;
 		}
 		truesize = size * PAGE_SIZE;
-- 
MST
