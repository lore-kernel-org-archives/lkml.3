Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471AbaCHBID (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:08:03 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46646 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754388AbaCHBHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:07:53 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Paul Clements <paul.clements@steeleye.com>,
        Rob Landley <rob@landley.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Rui Xiang <rui.xiang@huawei.com>
Subject: [PATCH 3.4 64/99] nbd: correct disconnect behavior
Date: Fri,  7 Mar 2014 17:08:00 -0800
Message-Id: <20140308010613.649452661@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140308010611.468206150@linuxfoundation.org>
References: <20140308010611.468206150@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
[xr: Backported to 3.4: adjust context]
Signed-off-by: Rui Xiang <rui.xiang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/nbd.c |    8 +++++++-
 include/linux/nbd.h |    1 +
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -590,8 +590,11 @@ static int __nbd_ioctl(struct block_devi
 		nbd_cmd(&sreq) = NBD_CMD_DISC;
 		if (!nbd->sock)
 			return -EINVAL;
+
+		nbd->disconnect = 1;
+
 		nbd_send_req(nbd, &sreq);
-                return 0;
+		return 0;
 	}
  
 	case NBD_CLEAR_SOCK: {
@@ -620,6 +623,7 @@ static int __nbd_ioctl(struct block_devi
 				nbd->sock = SOCKET_I(inode);
 				if (max_part > 0)
 					bdev->bd_invalidated = 1;
+				nbd->disconnect = 0; /* we're connected now */
 				return 0;
 			} else {
 				fput(file);
@@ -691,6 +695,8 @@ static int __nbd_ioctl(struct block_devi
 		set_capacity(nbd->disk, 0);
 		if (max_part > 0)
 			ioctl_by_bdev(bdev, BLKRRPART, 0);
+		if (nbd->disconnect) /* user requested, ignore socket errors */
+			return 0;
 		return nbd->harderror;
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


