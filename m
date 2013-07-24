Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3GXOGo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 10:06:44 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:45849 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752273Ab3GXOGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 10:06:36 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Paul Clements" <paul.clements@steeleye.com>,
        "Rob Landley" <rob@landley.net>
Date: Wed, 24 Jul 2013 15:02:45 +0100
Message-ID: <lsq.1374674565.879707266@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [70/85] nbd: correct disconnect behavior
In-Reply-To: <lsq.1374674564.753305150@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.49-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust device pointer name]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/nbd.c | 7 ++++++-
 include/linux/nbd.h | 1 +
 2 files changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -598,8 +598,10 @@ static int __nbd_ioctl(struct block_devi
 		if (!lo->sock)
 			return -EINVAL;
 
+		lo->disconnect = 1;
+
 		nbd_send_req(lo, &sreq);
-                return 0;
+		return 0;
 	}
  
 	case NBD_CLEAR_SOCK: {
@@ -629,6 +631,7 @@ static int __nbd_ioctl(struct block_devi
 				lo->sock = SOCKET_I(inode);
 				if (max_part > 0)
 					bdev->bd_invalidated = 1;
+				lo->disconnect = 0; /* we're connected now */
 				return 0;
 			} else {
 				fput(file);
@@ -701,6 +704,8 @@ static int __nbd_ioctl(struct block_devi
 		set_capacity(lo->disk, 0);
 		if (max_part > 0)
 			ioctl_by_bdev(bdev, BLKRRPART, 0);
+		if (lo->disconnect) /* user requested, ignore socket errors */
+			return 0;
 		return lo->harderror;
 	}
 
--- a/include/linux/nbd.h
+++ b/include/linux/nbd.h
@@ -68,6 +68,7 @@ struct nbd_device {
 	u64 bytesize;
 	pid_t pid; /* pid of nbd-client, if attached */
 	int xmit_timeout;
+	int disconnect; /* a disconnect has been requested by user */
 };
 
 #endif

