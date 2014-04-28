Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaD1BaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 21:30:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42821 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752145AbaD1B3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 21:29:20 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Date: Mon, 28 Apr 2014 02:11:21 +0100
Message-ID: <lsq.1398647481.372556947@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 08/94] vhost: fix total length when packets are too short
In-Reply-To: <lsq.1398647481.453080089@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.58-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit d8316f3991d207fe32881a9ac20241be8fa2bad0 ]

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/vhost/net.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -346,6 +346,12 @@ static int get_rx_bufs(struct vhost_virt
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
@@ -400,6 +406,14 @@ static void handle_rx(struct vhost_net *
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

