Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965012Ab3DKUhY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 16:37:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9444 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754977Ab3DKU0C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 16:26:02 -0400
X-Authority-Analysis: v=2.0 cv=aOZyWMBm c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=UXNEZTovifgA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=lQxyQm5rH78A:10 a=20KFwNOVAAAA:8 a=Tty9oNO6AAAA:8 a=VwQbUJbxAAAA:8 a=J1Y8HTJGAAAA:8 a=jmWCE8W1go-RpaolMxwA:9 a=jEp0ucaQiEUA:10 a=LI9Vle30uBYA:10 a=4N9Db7Z2_RYA:10 a=jeBq3FmKZ4MA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130411202549.058614058@goodmis.org>
User-Agent: quilt/0.60-1
Date: Thu, 11 Apr 2013 16:25:20 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        "Michael S. Tsirkin" <mst@redhat.com>, <stable@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 017/171 ] vhost/net: fix heads usage of ubuf_info
References: <20130411202503.783159048@goodmis.org>
Content-Disposition: inline; filename=0017-vhost-net-fix-heads-usage-of-ubuf_info.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.2 stable review patch.
If anyone has any objections, please let me know.

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
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/vhost/net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 7f93f34..156a360 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -235,7 +235,8 @@ static void handle_tx(struct vhost_net *net)
 				msg.msg_controllen = 0;
 				ubufs = NULL;
 			} else {
-				struct ubuf_info *ubuf = &vq->ubuf_info[head];
+				struct ubuf_info *ubuf;
+				ubuf = vq->ubuf_info + vq->upend_idx;
 
 				vq->heads[vq->upend_idx].len = len;
 				ubuf->callback = vhost_zerocopy_callback;
-- 
1.7.10.4


