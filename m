Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3LYUJe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Dec 2013 15:09:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39263 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752310Ab3LYUJd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Dec 2013 15:09:33 -0500
Date: Wed, 25 Dec 2013 22:13:18 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: netdev@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>,
        Michael Dalton <mwdalton@google.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH stable] virtio_net: don't leak memory or block when too many
 frags
Message-ID: <1387999653-22139-1-git-send-email-mst@redhat.com>
References: <1387983339-1172-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387983339-1172-1-git-send-email-mst@redhat.com>
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We leak an skb when there are too many frags,
we also stop processing the packet in the middle,
the result is almost sure to be loss of networking.

Reported-by: Michael Dalton <mwdalton@google.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Note: this path is gone upstream, so this patch is
for stable kernel only.
This is on top of series:
	virtio-net: backport error handling bugfix
that I sent previously (and that this is in reply to).

 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index c0ed6d5..86fe1e7 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -344,7 +344,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 		if (i >= MAX_SKB_FRAGS) {
 			pr_debug("%s: packet too long\n", skb->dev->name);
 			skb->dev->stats.rx_length_errors++;
-			return NULL;
+			goto err_frags;
 		}
 		page = virtqueue_get_buf(rq->vq, &len);
 		if (!page) {
@@ -364,6 +364,7 @@ static struct sk_buff *receive_mergeable(struct net_device *dev,
 	return skb;
 err_skb:
 	give_pages(rq, page);
 	while (--num_buf) {
+err_frags:
 		buf = virtqueue_get_buf(rq->vq, &len);
 		if (unlikely(!buf)) {
-- 
MST
