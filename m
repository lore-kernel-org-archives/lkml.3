Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760103Ab3GaNko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 09:40:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46879 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751338Ab3GaNZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 09:25:51 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Jason Wang" <jasowang@redhat.com>,
        "Brad Hubbard" <bhubbard@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Wed, 31 Jul 2013 15:23:09 +0200
Message-ID: <lsq.1375276989.608960498@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [03/84] macvtap: fix recovery from gup errors
In-Reply-To: <lsq.1375276989.251749228@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.181
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.50-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit 4c7ab054ab4f5d63625508ed6f8a607184cae7c2 ]

get user pages might fail partially in macvtap zero copy
mode. To recover we need to put all pages that we got,
but code used a wrong index resulting in double-free
errors.

Reported-by: Brad Hubbard <bhubbard@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/macvtap.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 26106c0..d91858e 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -532,8 +532,10 @@ static int zerocopy_sg_from_iovec(struct sk_buff *skb, const struct iovec *from,
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

