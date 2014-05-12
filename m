Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaELBlo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 21:41:44 -0400
Received: from 1wt.eu ([62.212.114.60]:34381 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601AbaELBlj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 21:41:39 -0400
Message-Id: <20140512003204.001634895@1wt.eu>
User-Agent: quilt/0.48-1
Date: Mon, 12 May 2014 02:33:21 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>,
        "David S. Miller" <davem@davemloft.net>, Willy Tarreau <w@1wt.eu>
Subject: [ 081/143] net: add BUG_ON if kernel advertises msg_namelen > sizeof(struct
In-Reply-To: <f07e5fe6d87f172fc73580b9c86ba9a2@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------
 sockaddr_storage)

From: Hannes Frederic Sowa <hannes@stressinduktion.org>

[ Upstream commit 68c6beb373955da0886d8f4f5995b3922ceda4be ]

In that case it is probable that kernel code overwrote part of the
stack. So we should bail out loudly here.

The BUG_ON may be removed in future if we are sure all protocols are
conformant.

Suggested-by: Eric Dumazet <eric.dumazet@gmail.com>
Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 net/socket.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/socket.c b/net/socket.c
index 2b7be6d..712f977 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -216,12 +216,13 @@ int move_addr_to_user(struct sockaddr *kaddr, int klen, void __user *uaddr,
 	int err;
 	int len;
 
+	BUG_ON(klen > sizeof(struct sockaddr_storage));
 	err = get_user(len, ulen);
 	if (err)
 		return err;
 	if (len > klen)
 		len = klen;
-	if (len < 0 || len > sizeof(struct sockaddr_storage))
+	if (len < 0)
 		return -EINVAL;
 	if (len) {
 		if (audit_sockaddr(klen, kaddr))
-- 
1.7.12.2.21.g234cd45.dirty



