Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627AbaABR3I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 12:29:08 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40193 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbaABRFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 12:05:30 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 10/91] macvtap: limit head length of skb allocated
Date: Thu,  2 Jan 2014 09:03:45 -0800
Message-Id: <1388682306-30859-11-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1388682306-30859-1-git-send-email-kamal@canonical.com>
References: <1388682306-30859-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Wang <jasowang@redhat.com>

[ Upstream commit 16a3fa28630331e28208872fa5341ce210b901c7 ]

We currently use hdr_len as a hint of head length which is advertised by
guest. But when guest advertise a very big value, it can lead to an 64K+
allocating of kmalloc() which has a very high possibility of failure when host
memory is fragmented or under heavy stress. The huge hdr_len also reduce the
effect of zerocopy or even disable if a gso skb is linearized in guest.

To solves those issues, this patch introduces an upper limit (PAGE_SIZE) of the
head, which guarantees an order 0 allocation each time.

Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/macvtap.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 9872202..15820ab 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -672,6 +672,7 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 				const struct iovec *iv, unsigned long total_len,
 				size_t count, int noblock)
 {
+	int good_linear = SKB_MAX_HEAD(NET_IP_ALIGN);
 	struct sk_buff *skb;
 	struct macvlan_dev *vlan;
 	unsigned long len = total_len;
@@ -714,6 +715,8 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 
 	if (m && m->msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY)) {
 		copylen = vnet_hdr.hdr_len ? vnet_hdr.hdr_len : GOODCOPY_LEN;
+		if (copylen > good_linear)
+			copylen = good_linear;
 		linear = copylen;
 		if (iov_pages(iv, vnet_hdr_len + copylen, count)
 		    <= MAX_SKB_FRAGS)
@@ -722,7 +725,10 @@ static ssize_t macvtap_get_user(struct macvtap_queue *q, struct msghdr *m,
 
 	if (!zerocopy) {
 		copylen = len;
-		linear = vnet_hdr.hdr_len;
+		if (vnet_hdr.hdr_len > good_linear)
+			linear = good_linear;
+		else
+			linear = vnet_hdr.hdr_len;
 	}
 
 	skb = macvtap_alloc_skb(&q->sk, NET_IP_ALIGN, copylen,
-- 
1.8.3.2

