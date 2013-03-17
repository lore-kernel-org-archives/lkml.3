Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab3CQMp5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 08:45:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955Ab3CQMpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 08:45:55 -0400
Date: Sun, 17 Mar 2013 14:46:09 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: stable@kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Jason Wang <jasowang@redhat.com>, Basil Gor <basil.gor@gmail.com>,
        "Nicholas A. Bellinger" <nab@risingtidesystems.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net] vhost/net: fix heads usage of ubuf_info
Message-ID: <20130317124609.GA25967@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ubuf info allocator uses guest controlled head as an index,
so a malicious guest could put the same head entry in the ring twice,
and we will get two callbacks on the same value.
To fix use upend_idx which is guaranteed to be unique.

Reported-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@kernel.org
---

Rusty's working on switching to allocating ubufs dynamically
but that's not 3.9 material.
This patch is against latest net master,
needed for 3.9-rc2 and older kernels.

 drivers/vhost/net.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 959b1cd..ec6fb3f 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -339,7 +339,8 @@ static void handle_tx(struct vhost_net *net)
 				msg.msg_controllen = 0;
 				ubufs = NULL;
 			} else {
-				struct ubuf_info *ubuf = &vq->ubuf_info[head];
+				struct ubuf_info *ubuf;
+				ubuf = vq->ubuf_info + vq->upend_idx;
 
 				vq->heads[vq->upend_idx].len =
 					VHOST_DMA_IN_PROGRESS;
-- 
MST
