Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaHTLuE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:50:04 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59045 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752626AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <jon.maloy@ericsson.com>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 097/104] tipc: don't use memcpy to copy from user space
Date: Wed, 20 Aug 2014 13:44:00 +0200
Message-Id: <4d6b3a202070a739e3bc2a5ea986a8df04eccb1d.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ying Xue <ying.xue@windriver.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 5c0a0fc81f4dc786b42c4fc9c7c72ba635406ab5 upstream.

tipc_msg_build() calls skb_copy_to_linear_data_offset() to copy data
from user space to kernel space. However, the latter function does
in its turn call memcpy() to perform the actual copying. This poses
an obvious security and robustness risk, since memcpy() never makes
any validity check on the pointer it is copying from.

To correct this, we the replace the offending function call with
a call to memcpy_fromiovecend(), which uses copy_from_user() to
perform the copying.

Signed-off-by: Ying Xue <ying.xue@windriver.com>
Reviewed-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Signed-off-by: Jon Maloy <jon.maloy@ericsson.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 net/tipc/msg.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index ced60e2fc4f7..1e76d91e5691 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -76,10 +76,11 @@ int tipc_msg_build(struct tipc_msg *hdr, struct iovec const *msg_sect,
 		   u32 num_sect, unsigned int total_len, int max_size,
 		   struct sk_buff **buf)
 {
-	int dsz, sz, hsz, pos, res, cnt;
+	int dsz, sz, hsz;
+	unsigned char *to;
 
 	dsz = total_len;
-	pos = hsz = msg_hdr_sz(hdr);
+	hsz = msg_hdr_sz(hdr);
 	sz = hsz + dsz;
 	msg_set_size(hdr, sz);
 	if (unlikely(sz > max_size)) {
@@ -91,16 +92,11 @@ int tipc_msg_build(struct tipc_msg *hdr, struct iovec const *msg_sect,
 	if (!(*buf))
 		return -ENOMEM;
 	skb_copy_to_linear_data(*buf, hdr, hsz);
-	for (res = 1, cnt = 0; res && (cnt < num_sect); cnt++) {
-		skb_copy_to_linear_data_offset(*buf, pos,
-					       msg_sect[cnt].iov_base,
-					       msg_sect[cnt].iov_len);
-		pos += msg_sect[cnt].iov_len;
+	to = (*buf)->data + hsz;
+	if (total_len && memcpy_fromiovecend(to, msg_sect, 0, dsz)) {
+		kfree_skb(*buf);
+		*buf = NULL;
+		return -EFAULT;
 	}
-	if (likely(res))
-		return dsz;
-
-	kfree_skb(*buf);
-	*buf = NULL;
-	return -EFAULT;
+	return dsz;
 }
-- 
2.0.4

