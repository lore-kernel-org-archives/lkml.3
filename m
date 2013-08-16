Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab3HPF3B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 01:29:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752186Ab3HPF2J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 01:28:09 -0400
From: Jason Wang <jasowang@redhat.com>
To: mst@redhat.com, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Jason Wang <jasowang@redhat.com>
Subject: [PATCH 4/6] vhost_net: determine whether or not to use zerocopy at one time
Date: Fri, 16 Aug 2013 13:16:28 +0800
Message-Id: <1376630190-5912-5-git-send-email-jasowang@redhat.com>
In-Reply-To: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
References: <1376630190-5912-1-git-send-email-jasowang@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, even if the packet length is smaller than VHOST_GOODCOPY_LEN, if
upend_idx != done_idx we still set zcopy_used to true and rollback this choice
later. This could be avoided by determine zerocopy once by checking all
conditions at one time before.

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c |   46 +++++++++++++++++++---------------------------
 1 files changed, 19 insertions(+), 27 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 8a6dd0d..70cab75 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -404,43 +404,35 @@ static void handle_tx(struct vhost_net *net)
 			       iov_length(nvq->hdr, s), hdr_size);
 			break;
 		}
-		zcopy_used = zcopy && (len >= VHOST_GOODCOPY_LEN ||
-				       nvq->upend_idx != nvq->done_idx);
+
+		zcopy_used = zcopy && len >= VHOST_GOODCOPY_LEN
+			&& nvq->upend_idx != nvq->done_idx
+			&& vhost_net_tx_select_zcopy(net);
 
 		/* use msg_control to pass vhost zerocopy ubuf info to skb */
 		if (zcopy_used) {
+			struct ubuf_info *ubuf;
+			ubuf = nvq->ubuf_info + nvq->upend_idx;
+
 			vq->heads[nvq->upend_idx].id = head;
-			if (!vhost_net_tx_select_zcopy(net) ||
-			    len < VHOST_GOODCOPY_LEN) {
-				/* copy don't need to wait for DMA done */
-				vq->heads[nvq->upend_idx].len =
-							VHOST_DMA_DONE_LEN;
-				msg.msg_control = NULL;
-				msg.msg_controllen = 0;
-				ubufs = NULL;
-			} else {
-				struct ubuf_info *ubuf;
-				ubuf = nvq->ubuf_info + nvq->upend_idx;
-
-				vq->heads[nvq->upend_idx].len =
-					VHOST_DMA_IN_PROGRESS;
-				ubuf->callback = vhost_zerocopy_callback;
-				ubuf->ctx = nvq->ubufs;
-				ubuf->desc = nvq->upend_idx;
-				msg.msg_control = ubuf;
-				msg.msg_controllen = sizeof(ubuf);
-				ubufs = nvq->ubufs;
-				kref_get(&ubufs->kref);
-			}
+			vq->heads[nvq->upend_idx].len = VHOST_DMA_IN_PROGRESS;
+			ubuf->callback = vhost_zerocopy_callback;
+			ubuf->ctx = nvq->ubufs;
+			ubuf->desc = nvq->upend_idx;
+			msg.msg_control = ubuf;
+			msg.msg_controllen = sizeof(ubuf);
+			ubufs = nvq->ubufs;
+			kref_get(&ubufs->kref);
 			nvq->upend_idx = (nvq->upend_idx + 1) % UIO_MAXIOV;
-		} else
+		} else {
 			msg.msg_control = NULL;
+			ubufs = NULL;
+		}
 		/* TODO: Check specific error and bomb out unless ENOBUFS? */
 		err = sock->ops->sendmsg(NULL, sock, &msg, len);
 		if (unlikely(err < 0)) {
 			if (zcopy_used) {
-				if (ubufs)
-					vhost_net_ubuf_put(ubufs);
+				vhost_net_ubuf_put(ubufs);
 				nvq->upend_idx = ((unsigned)nvq->upend_idx - 1)
 					% UIO_MAXIOV;
 			}
-- 
1.7.1

