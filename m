Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943AbaDPKnU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:43:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51753 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755768AbaDPKcv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:32:51 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 30/46] vhost: fix total length when packets are too short
Date: Wed, 16 Apr 2014 11:31:46 +0100
Message-Id: <1397644322-13905-31-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit d8316f3991d207fe32881a9ac20241be8fa2bad0 upstream.

When mergeable buffers are disabled, and the
incoming packet is too large for the rx buffer,
get_rx_bufs returns success.

This was intentional in order for make recvmsg
truncate the packet and then handle_rx would
detect err != sock_len and drop it.

Unfortunately we pass the original sock_len to
recvmsg - which means we use parts of iov not fully
validated.

Fix this up by detecting this overrun and doing packet drop
immediately.

CVE-2014-0077

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/vhost/net.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 969a859..1284e7a 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -537,6 +537,12 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 	*iovcount = seg;
 	if (unlikely(log))
 		*log_num = nlogs;
+
+	/* Detect overrun */
+	if (unlikely(datalen > 0)) {
+		r = UIO_MAXIOV + 1;
+		goto err;
+	}
 	return headcount;
 err:
 	vhost_discard_vq_desc(vq, headcount);
@@ -592,6 +598,14 @@ static void handle_rx(struct vhost_net *net)
 		/* On error, stop handling until the next kick. */
 		if (unlikely(headcount < 0))
 			break;
+		/* On overrun, truncate and discard */
+		if (unlikely(headcount > UIO_MAXIOV)) {
+			msg.msg_iovlen = 1;
+			err = sock->ops->recvmsg(NULL, sock, &msg,
+						 1, MSG_DONTWAIT | MSG_TRUNC);
+			pr_debug("Discarded rx packet: len %zd\n", sock_len);
+			continue;
+		}
 		/* OK, now we need to know about added descriptors. */
 		if (!headcount) {
 			if (unlikely(vhost_enable_notify(&net->dev, vq))) {
-- 
1.9.1

