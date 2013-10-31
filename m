Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752501Ab3JaLrd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Oct 2013 07:47:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50527 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab3JaLr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Oct 2013 07:47:29 -0400
From: Jason Wang <jasowang@redhat.com>
To: davem@davemloft.net, edumazet@google.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rusty@rustcorp.com.au, mst@redhat.com,
        mwdalton@google.com, virtualization@lists.linux-foundation.org
Cc: kmindg@gmail.com, Jason Wang <jasowang@redhat.com>
Subject: [PATCH net-next V2 2/2] virtio-net: coalesce rx frags when possible during rx
Date: Thu, 31 Oct 2013 19:47:07 +0800
Message-Id: <1383220027-12278-2-git-send-email-jasowang@redhat.com>
In-Reply-To: <1383220027-12278-1-git-send-email-jasowang@redhat.com>
References: <1383220027-12278-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 2613af0ed18a11d5c566a81f9a6510b73180660a (virtio_net: migrate mergeable
rx buffers to page frag allocators) try to increase the payload/truesize for
MTU-sized traffic. But this will introduce the extra overhead for GSO packets
received because of the frag list. This commit tries to reduce this issue by
coalesce the possible rx frags when possible during rx. Test result shows the
about 15% improvement on full size GSO packet receiving (and even better than
commit 2613af0ed18a11d5c566a81f9a6510b73180660a).

Before this commit:
./netperf -H 192.168.100.4
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.100.4
() port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.00    20303.87

After this commit:
./netperf -H 192.168.100.4
MIGRATED TCP STREAM TEST from 0.0.0.0 (0.0.0.0) port 0 AF_INET to 192.168.100.4 () port 0 AF_INET : demo
Recv   Send    Send
Socket Socket  Message  Elapsed
Size   Size    Size     Time     Throughput
bytes  bytes   bytes    secs.    10^6bits/sec

 87380  16384  16384    10.00    23841.26

Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Michael S. Tsirkin <mst@redhat.com>
Cc: Michael Dalton <mwdalton@google.com>
Cc: Eric Dumazet <edumazet@google.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/net/virtio_net.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 113ee93..5dc0de0 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -305,7 +305,7 @@ static int receive_mergeable(struct receive_queue *rq, struct sk_buff *head_skb)
 	struct sk_buff *curr_skb = head_skb;
 	char *buf;
 	struct page *page;
-	int num_buf, len;
+	int num_buf, len, offset;
 
 	num_buf = hdr->mhdr.num_buffers;
 	while (--num_buf) {
@@ -342,9 +342,15 @@ static int receive_mergeable(struct receive_queue *rq, struct sk_buff *head_skb)
 			head_skb->truesize += MAX_PACKET_LEN;
 		}
 		page = virt_to_head_page(buf);
-		skb_add_rx_frag(curr_skb, num_skb_frags, page,
-				buf - (char *)page_address(page), len,
-				MAX_PACKET_LEN);
+		offset = buf - (char *)page_address(page);
+		if (skb_can_coalesce(curr_skb, num_skb_frags, page, offset)) {
+			skb_coalesce_rx_frag(curr_skb, num_skb_frags - 1,
+					     len, MAX_PACKET_LEN);
+		} else {
+			skb_add_rx_frag(curr_skb, num_skb_frags, page,
+					offset, len,
+					MAX_PACKET_LEN);
+		}
 		--rq->num;
 	}
 	return 0;
-- 
1.8.1.2

