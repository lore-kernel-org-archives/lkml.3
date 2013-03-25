Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab3CYBUx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Mar 2013 21:20:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34130 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756340Ab3CYBQg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Mar 2013 21:16:36 -0400
Message-Id: <20130325010526.795498363@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 25 Mar 2013 01:05:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 025/104] vhost/net: fix heads usage of ubuf_info
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130325010524.240972766@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:f137:78a:b654:affb
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 46aa92d1ba162b4b3d6b7102440e459d4e4ee255 upstream.

ubuf info allocator uses guest controlled head as an index,
so a malicious guest could put the same head entry in the ring twice,
and we will get two callbacks on the same value.
To fix use upend_idx which is guaranteed to be unique.

Reported-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/vhost/net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -234,7 +234,8 @@ static void handle_tx(struct vhost_net *
 				msg.msg_controllen = 0;
 				ubufs = NULL;
 			} else {
-				struct ubuf_info *ubuf = &vq->ubuf_info[head];
+				struct ubuf_info *ubuf;
+				ubuf = vq->ubuf_info + vq->upend_idx;
 
 				vq->heads[vq->upend_idx].len = len;
 				ubuf->callback = vhost_zerocopy_callback;


