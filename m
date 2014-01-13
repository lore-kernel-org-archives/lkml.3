Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755209AbaAMQLr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:11:47 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53783 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754615AbaAMQFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:05:19 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 191/208] virtio_net: don't leak memory or block when too many frags
Date: Mon, 13 Jan 2014 16:00:32 +0000
Message-Id: <1389628849-1614-192-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
References: <1389628849-1614-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

We leak an skb when there are too many frags,
we also stop processing the packet in the middle,
the result is almost sure to be loss of networking.

Reported-by: Michael Dalton <mwdalton@google.com>
Acked-by: Michael Dalton <mwdalton@google.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index ec0e9f2..68692af 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -341,7 +341,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		if (i >= MAX_SKB_FRAGS) {
 			pr_debug("%s: packet too long\n", skb->dev->name);
 			skb->dev->stats.rx_length_errors++;
-			return NULL;
+			goto err_frags;
 		}
 		page = virtqueue_get_buf(rq->vq, &len);
 		if (!page) {
@@ -362,6 +362,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 err_skb:
 	give_pages(rq, page);
 	while (--num_buf) {
+err_frags:
 		buf = virtqueue_get_buf(rq->vq, &len);
 		if (unlikely(!buf)) {
 			pr_debug("%s: rx error: %d buffers missing\n",
-- 
1.8.3.2

