Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab3KTJIB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:08:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751080Ab3KTJH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:07:56 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net 2/3] virtio-net: fix num calculation on frag skb allocation failure
Date: Wed, 20 Nov 2013 17:07:26 +0800
Message-Id: <1384938447-3775-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1384938447-3775-1-git-send-email-jasowang@redhat.com>
References: <1384938447-3775-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need decrease the rq->num after we can get a buf through
virtqueue_get_buf() even if we could not allocate frag skb. Otherwise, the
refill routine won't be triggered under heavy memory stress since the driver may
still think there's enough room.

This bug was introduced by commit 2613af0ed18a11d5c566a81f9a6510b73180660a
(virtio_net: migrate mergeable rx buffers to page frag allocators).

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michael Dalton <mwdalton@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
The patch was needed for 3.12 stable.
---
 drivers/net/virtio_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 24fd502..de1d6ca 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -333,6 +333,7 @@ static int receive_mergeable(struct receive_queue *rq, struct sk_buff *head_skb)
 			head_skb->dev->stats.rx_length_errors++;
 			return -EINVAL;
 		}
+		--rq->num;
 		if (unlikely(len > MERGE_BUFFER_LEN)) {
 			pr_debug("%s: rx error: merge buffer too long\n",
 				 head_skb->dev->name);
@@ -367,7 +368,6 @@ static int receive_mergeable(struct receive_queue *rq, struct sk_buff *head_skb)
 			skb_add_rx_frag(curr_skb, num_skb_frags, page,
 					offset, len, MERGE_BUFFER_LEN);
 		}
-		--rq->num;
 	}
 	return 0;
 }
-- 
1.8.3.2

