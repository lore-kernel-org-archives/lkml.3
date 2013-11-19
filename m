Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab3KSIFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:05:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745Ab3KSIFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:05:46 -0500
From: Jason Wang <jasowang@redhat.com>
To: rusty@rustcorp.com.au, mst@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>, Michael Dalton <mwdalton@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH net] virtio-net: fix page refcnt leaking when fail to allocate frag skb
Date: Tue, 19 Nov 2013 16:05:07 +0800
Message-Id: <1384848307-7217-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to drop the refcnt of page when we fail to allocate an skb for frag
list, otherwise it will be leaked. The bug was introduced by commit
2613af0ed18a11d5c566a81f9a6510b73180660a ("virtio_net: migrate mergeable rx
buffers to page frag allocators").

Cc: Michael Dalton <mwdalton@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
The patch was needed for 3.12 stable.
---
 drivers/net/virtio_net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 69ad42b..3798517 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -322,9 +322,11 @@ static int receive_mergeable(struct receive_queue *rq, struct sk_buff *head_skb)
 				 head_skb->dev->name);
 			len = MERGE_BUFFER_LEN;
 		}
+		page = virt_to_head_page(buf);
 		if (unlikely(num_skb_frags == MAX_SKB_FRAGS)) {
 			struct sk_buff *nskb = alloc_skb(0, GFP_ATOMIC);
 			if (unlikely(!nskb)) {
+				put_page(page);
 				head_skb->dev->stats.rx_dropped++;
 				return -ENOMEM;
 			}
@@ -341,7 +343,6 @@ static int receive_mergeable(struct receive_queue *rq, struct sk_buff *head_skb)
 			head_skb->len += len;
 			head_skb->truesize += MERGE_BUFFER_LEN;
 		}
-		page = virt_to_head_page(buf);
 		offset = buf - (char *)page_address(page);
 		if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
 			put_page(page);
-- 
1.8.3.2

