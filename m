Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935259Ab3FSVJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:09:21 -0400
Received: from hancock.steeleye.com ([66.162.12.4]:34141 "EHLO
	hancock.steeleye.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S935148Ab3FSVJU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:09:20 -0400
From: Paul Clements <paul.clements@steeleye.com>
CC: <linux-kernel@vger.kernel.org>, <paul.clements@steeleye.com>,
        <nbd-general@lists.sourceforge.net>
Subject: [PATCH] nbd: correct disconnect behavior
To: <akpm@linux-foundation.org>
X-Mailer: mail (GNU Mailutils 2.2)
Message-Id: <20130619210918.DF616222D8@clements>
Date: Wed, 19 Jun 2013 17:09:18 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, when a disconnect is requested by the user (via NBD_DISCONNECT
ioctl) the return from NBD_DO_IT is undefined (it is usually one of
several error codes). This means that nbd-client does not know if a
manual disconnect was performed or whether a network error occurred.
Because of this, nbd-client's persist mode (which tries to reconnect after
error, but not after manual disconnect) does not always work correctly.

This change fixes this by causing NBD_DO_IT to always return 0 if a user
requests a disconnect. This means that nbd-client can correctly either
persist the connection (if an error occurred) or disconnect (if the user
requested it).

Signed-off-by: Paul Clements <paul.clements@steeleye.com>
---

 drivers/block/nbd.c |    5 +++++
 include/linux/nbd.h |    1 +
 2 files changed, 6 insertions(+)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 7fecc78..8b7664d 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -623,6 +623,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		if (!nbd->sock)
 			return -EINVAL;
 
+		nbd->disconnect = 1;
+
 		nbd_send_req(nbd, &sreq);
                 return 0;
 	}
@@ -654,6 +656,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 				nbd->sock = SOCKET_I(inode);
 				if (max_part > 0)
 					bdev->bd_invalidated = 1;
+				nbd->disconnect = 0; /* we're connected now */
 				return 0;
 			} else {
 				fput(file);
@@ -742,6 +745,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
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
