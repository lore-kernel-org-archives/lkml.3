Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab3G3Sr1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 14:47:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56558 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756927Ab3G3Spe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 14:45:34 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 49/75] macvtap: fix recovery from gup errors
Date: Tue, 30 Jul 2013 11:44:53 -0700
Message-Id: <1375209919-1768-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1375197464-27962-1-git-send-email-kamal@canonical.com>
References: <1375197464-27962-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 4c7ab054ab4f5d63625508ed6f8a607184cae7c2 upstream.

get user pages might fail partially in macvtap zero copy
mode. To recover we need to put all pages that we got,
but code used a wrong index resulting in double-free
errors.

Reported-by: Brad Hubbard <bhubbard@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvtap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 0f0f9ce..ba4d38b 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -535,8 +535,10 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
 			return -EMSGSIZE;
 		num_pages = get_user_pages_fast(base, size, 0, &page[i]);
 		if (num_pages != size) {
-			for (i = 0; i < num_pages; i++)
-				put_page(page[i]);
+			int j;
+
+			for (j = 0; j < num_pages; j++)
+				put_page(page[i + j]);
 			return -EFAULT;
 		}
 		truesize = size * PAGE_SIZE;
-- 
1.8.1.2

