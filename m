Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759527Ab3LFWSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:18:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60842 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759283Ab3LFVx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:53:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.10 10/58] tuntap: limit head length of skb allocated
Date: Fri,  6 Dec 2013 13:51:41 -0800
Message-Id: <20131206214845.854201216@linuxfoundation.org>
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

[ Upstream commit 96f8d9ecf227638c89f98ccdcdd50b569891976c ]

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
 drivers/net/tun.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1069,6 +1069,7 @@ static ssize_t tun_get_user(struct tun_s
 	struct sk_buff *skb;
 	size_t len = total_len, align = NET_SKB_PAD, linear;
 	struct virtio_net_hdr gso = { 0 };
+	int good_linear;
 	int offset = 0;
 	int copylen;
 	bool zerocopy = false;
@@ -1109,12 +1110,16 @@ static ssize_t tun_get_user(struct tun_s
 			return -EINVAL;
 	}
 
+	good_linear = SKB_MAX_HEAD(align);
+
 	if (msg_control) {
 		/* There are 256 bytes to be copied in skb, so there is
 		 * enough room for skb expand head in case it is used.
 		 * The rest of the buffer is mapped from userspace.
 		 */
 		copylen = gso.hdr_len ? gso.hdr_len : GOODCOPY_LEN;
+		if (copylen > good_linear)
+			copylen = good_linear;
 		linear = copylen;
 		if (iov_pages(iv, offset + copylen, count) <= MAX_SKB_FRAGS)
 			zerocopy = true;
@@ -1122,7 +1127,10 @@ static ssize_t tun_get_user(struct tun_s
 
 	if (!zerocopy) {
 		copylen = len;
-		linear = gso.hdr_len;
+		if (gso.hdr_len > good_linear)
+			linear = good_linear;
+		else
+			linear = gso.hdr_len;
 	}
 
 	skb = tun_alloc_skb(tfile, align, copylen, linear, noblock);


