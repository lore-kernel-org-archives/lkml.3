Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384Ab3GQXTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 19:19:01 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56492 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934335Ab3GQWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 18:54:38 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Paul Clements <paul.clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 067/145] nbd: correct disconnect behavior
Date: Wed, 17 Jul 2013 15:46:39 -0700
Message-Id: <1374101277-7915-68-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1374101277-7915-1-git-send-email-kamal@canonical.com>
References: <1374101277-7915-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Clements <paul.clements@steeleye.com>

commit c378f70adbc1bbecd9e6db145019f14b2f688c7c upstream.

Currently, when a disconnect is requested by the user (via NBD_DISCONNECT
ioctl) the return from NBD_DO_IT is undefined (it is usually one of
several error codes).  This means that nbd-client does not know if a
manual disconnect was performed or whether a network error occurred.
Because of this, nbd-client's persist mode (which tries to reconnect after
error, but not after manual disconnect) does not always work correctly.

This change fixes this by causing NBD_DO_IT to always return 0 if a user
requests a disconnect.  This means that nbd-client can correctly either
persist the connection (if an error occurred) or disconnect (if the user
requested it).

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
Acked-by: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/nbd.c | 7 ++++++-
 include/linux/nbd.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 0f9262e..e6ea105 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -609,8 +609,10 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		if (!nbd->sock)
 			return -EINVAL;
 
+		nbd->disconnect = 1;
+
 		nbd_send_req(nbd, &sreq);
-                return 0;
+		return 0;
 	}
  
 	case NBD_CLEAR_SOCK: {
@@ -640,6 +642,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 				nbd->sock = SOCKET_I(inode);
 				if (max_part > 0)
 					bdev->bd_invalidated = 1;
+				nbd->disconnect = 0; /* we're connected now */
 				return 0;
 			} else {
 				fput(file);
@@ -721,6 +724,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		set_capacity(nbd->disk, 0);
 		if (max_part > 0)
 			ioctl_by_bdev(bdev, BLKRRPART, 0);
+		if (nbd->disconnect) /* user requested, ignore socket errors */
+			return 0;
 		return nbd->harderror;
 	}
 
diff --git a/include/linux/nbd.h b/include/linux/nbd.h
index 4871170..ae4981e 100644
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -41,6 +41,7 @@ struct nbd_device {
 	u64 bytesize;
 	pid_t pid; /* pid of nbd-client, if attached */
 	int xmit_timeout;
+	int disconnect; /* a disconnect has been requested by user */
 };
 
 #endif
-- 
1.8.1.2

