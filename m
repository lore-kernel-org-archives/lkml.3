Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161475Ab3LFWSR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:18:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60847 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758778Ab3LFVx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 11/58] macvtap: limit head length of skb allocated
Date: Fri,  6 Dec 2013 13:51:42 -0800
Message-Id: <20131206214845.966583939@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214844.906193530@linuxfoundation.org>
References: <20131206214844.906193530@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

Signed-off-by: Jason Wang <jasowang@redhat.com>
Cc: Stefan Hajnoczi <stefanha@redhat.com>
Cc: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macvtap.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -661,6 +661,7 @@ static ssize_t macvtap_get_user(struct m
 				const struct iovec *iv, unsigned long total_len,
 				size_t count, int noblock)
 {
+	int good_linear = SKB_MAX_HEAD(NET_IP_ALIGN);
 	struct sk_buff *skb;
 	struct macvlan_dev *vlan;
 	unsigned long len = total_len;
@@ -703,6 +704,8 @@ static ssize_t macvtap_get_user(struct m
 
 	if (m && m->msg_control && sock_flag(&q->sk, SOCK_ZEROCOPY)) {
 		copylen = vnet_hdr.hdr_len ? vnet_hdr.hdr_len : GOODCOPY_LEN;
+		if (copylen > good_linear)
+			copylen = good_linear;
 		linear = copylen;
 		if (iov_pages(iv, vnet_hdr_len + copylen, count)
 		    <= MAX_SKB_FRAGS)
@@ -711,7 +714,10 @@ static ssize_t macvtap_get_user(struct m
 
 	if (!zerocopy) {
 		copylen = len;
-		linear = vnet_hdr.hdr_len;
+		if (vnet_hdr.hdr_len > good_linear)
+			linear = good_linear;
+		else
+			linear = vnet_hdr.hdr_len;
 	}
 
 	skb = macvtap_alloc_skb(&q->sk, NET_IP_ALIGN, copylen,


