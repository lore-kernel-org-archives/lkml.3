Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754836AbaANApK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 19:45:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:54347 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbaANA20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 19:28:26 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Dalton <mwdalton@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 34/77] virtio_net: dont leak memory or block when too many frags
Date: Mon, 13 Jan 2014 16:27:55 -0800
Message-Id: <20140114002753.473011551@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140114002752.497010554@linuxfoundation.org>
References: <20140114002752.497010554@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

We leak an skb when there are too many frags,
we also stop processing the packet in the middle,
the result is almost sure to be loss of networking.

Reported-by: Michael Dalton <mwdalton@google.com>
Acked-by: Michael Dalton <mwdalton@google.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/virtio_net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -344,7 +344,7 @@ static struct sk_buff *receive_mergeable
 		if (i >= MAX_SKB_FRAGS) {
 			pr_debug("%s: packet too long\n", skb->dev->name);
 			skb->dev->stats.rx_length_errors++;
-			return NULL;
+			goto err_frags;
 		}
 		page = virtqueue_get_buf(rq->vq, &len);
 		if (!page) {
@@ -365,6 +365,7 @@ static struct sk_buff *receive_mergeable
 err_skb:
 	give_pages(rq, page);
 	while (--num_buf) {
+err_frags:
 		buf = virtqueue_get_buf(rq->vq, &len);
 		if (unlikely(!buf)) {
 			pr_debug("%s: rx error: %d buffers missing\n",


