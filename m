Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3CZXoo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:44:44 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52433 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab3CZWnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>, stable@kernel.org
Subject: [ 19/98] vhost/net: fix heads usage of ubuf_info
Date: Tue, 26 Mar 2013 15:42:08 -0700
Message-Id: <20130326224244.465447193@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "Michael S. Tsirkin" <mst@redhat.com>

[ Upstream commit 46aa92d1ba162b4b3d6b7102440e459d4e4ee255 ]

ubuf info allocator uses guest controlled head as an index,
so a malicious guest could put the same head entry in the ring twice,
and we will get two callbacks on the same value.
To fix use upend_idx which is guaranteed to be unique.

Reported-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: stable@kernel.org
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vhost/net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -339,7 +339,8 @@ static void handle_tx(struct vhost_net *
 				msg.msg_controllen = 0;
 				ubufs = NULL;
 			} else {
-				struct ubuf_info *ubuf = &vq->ubuf_info[head];
+				struct ubuf_info *ubuf;
+				ubuf = vq->ubuf_info + vq->upend_idx;
 
 				vq->heads[vq->upend_idx].len =
 					VHOST_DMA_IN_PROGRESS;


