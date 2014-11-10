Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874AbaKJQV3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:21:29 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:54069 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753810AbaKJQVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:21:21 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 7/7] drbd: Remove an useless copy of kernel_setsockopt()
Date: Mon, 10 Nov 2014 17:21:15 +0100
Message-Id: <1415636475-7883-8-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
References: <1415636475-7883-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Old backward-compat cruft

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_int.h | 29 ++++-------------------------
 1 file changed, 4 insertions(+), 25 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index d2a7589..b905e98 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1557,52 +1557,31 @@ extern void drbd_set_recv_tcq(struct drbd_device *device, int tcq_enabled);
 extern void _drbd_clear_done_ee(struct drbd_device *device, struct list_head *to_be_freed);
 extern int drbd_connected(struct drbd_peer_device *);
 
-/* Yes, there is kernel_setsockopt, but only since 2.6.18.
- * So we have our own copy of it here. */
-static inline int drbd_setsockopt(struct socket *sock, int level, int optname,
-				  char *optval, int optlen)
-{
-	mm_segment_t oldfs = get_fs();
-	char __user *uoptval;
-	int err;
-
-	uoptval = (char __user __force *)optval;
-
-	set_fs(KERNEL_DS);
-	if (level == SOL_SOCKET)
-		err = sock_setsockopt(sock, level, optname, uoptval, optlen);
-	else
-		err = sock->ops->setsockopt(sock, level, optname, uoptval,
-					    optlen);
-	set_fs(oldfs);
-	return err;
-}
-
 static inline void drbd_tcp_cork(struct socket *sock)
 {
 	int val = 1;
-	(void) drbd_setsockopt(sock, SOL_TCP, TCP_CORK,
+	(void) kernel_setsockopt(sock, SOL_TCP, TCP_CORK,
 			(char*)&val, sizeof(val));
 }
 
 static inline void drbd_tcp_uncork(struct socket *sock)
 {
 	int val = 0;
-	(void) drbd_setsockopt(sock, SOL_TCP, TCP_CORK,
+	(void) kernel_setsockopt(sock, SOL_TCP, TCP_CORK,
 			(char*)&val, sizeof(val));
 }
 
 static inline void drbd_tcp_nodelay(struct socket *sock)
 {
 	int val = 1;
-	(void) drbd_setsockopt(sock, SOL_TCP, TCP_NODELAY,
+	(void) kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY,
 			(char*)&val, sizeof(val));
 }
 
 static inline void drbd_tcp_quickack(struct socket *sock)
 {
 	int val = 2;
-	(void) drbd_setsockopt(sock, SOL_TCP, TCP_QUICKACK,
+	(void) kernel_setsockopt(sock, SOL_TCP, TCP_QUICKACK,
 			(char*)&val, sizeof(val));
 }
 
-- 
1.9.1

