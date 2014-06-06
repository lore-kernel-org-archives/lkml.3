Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752143AbaFFN1n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 09:27:43 -0400
Received: from relay.parallels.com ([195.214.232.42]:43644 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaFFN1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 09:27:42 -0400
Subject: [PATCH 1/5] fuse: add close_wait flag to fuse_conn
To: miklos@szeredi.hu
From: Maxim Patlasov <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Date: Fri, 06 Jun 2014 17:27:40 +0400
Message-ID: <20140606132715.30321.45639.stgit@localhost.localdomain>
In-Reply-To: <20140606132541.30321.68679.stgit@localhost.localdomain>
References: <20140606132541.30321.68679.stgit@localhost.localdomain>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The feature will be governed by fc->close_wait. Userspace can enable it in
the same way as auto_inval_data or any other kernel fuse capability.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/fuse_i.h          |    3 +++
 fs/fuse/inode.c           |    4 +++-
 include/uapi/linux/fuse.h |    3 +++
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 7aa5c75..434ff08 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -557,6 +557,9 @@ struct fuse_conn {
 	/** Does the filesystem support asynchronous direct-IO submission? */
 	unsigned async_dio:1;
 
+	/** Wait for response from daemon on close */
+	unsigned close_wait:1;
+
 	/** The number of requests waiting for completion */
 	atomic_t num_waiting;
 
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 754dcf2..580d1b3 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -898,6 +898,8 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 			else
 				fc->sb->s_time_gran = 1000000000;
 
+			if (arg->flags & FUSE_CLOSE_WAIT)
+				fc->close_wait = 1;
 		} else {
 			ra_pages = fc->max_read / PAGE_CACHE_SIZE;
 			fc->no_lock = 1;
@@ -926,7 +928,7 @@ static void fuse_send_init(struct fuse_conn *fc, struct fuse_req *req)
 		FUSE_SPLICE_WRITE | FUSE_SPLICE_MOVE | FUSE_SPLICE_READ |
 		FUSE_FLOCK_LOCKS | FUSE_IOCTL_DIR | FUSE_AUTO_INVAL_DATA |
 		FUSE_DO_READDIRPLUS | FUSE_READDIRPLUS_AUTO | FUSE_ASYNC_DIO |
-		FUSE_WRITEBACK_CACHE;
+		FUSE_WRITEBACK_CACHE | FUSE_CLOSE_WAIT;
 	req->in.h.opcode = FUSE_INIT;
 	req->in.numargs = 1;
 	req->in.args[0].size = sizeof(*arg);
diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 40b5ca8..1e1b6fa 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -101,6 +101,7 @@
  *  - add FATTR_CTIME
  *  - add ctime and ctimensec to fuse_setattr_in
  *  - add FUSE_RENAME2 request
+ *  - add FUSE_CLOSE_WAIT
  */
 
 #ifndef _LINUX_FUSE_H
@@ -229,6 +230,7 @@ struct fuse_file_lock {
  * FUSE_READDIRPLUS_AUTO: adaptive readdirplus
  * FUSE_ASYNC_DIO: asynchronous direct I/O submission
  * FUSE_WRITEBACK_CACHE: use writeback cache for buffered writes
+ * FUSE_CLOSE_WAIT: wait for response from daemon on close
  */
 #define FUSE_ASYNC_READ		(1 << 0)
 #define FUSE_POSIX_LOCKS	(1 << 1)
@@ -247,6 +249,7 @@ struct fuse_file_lock {
 #define FUSE_READDIRPLUS_AUTO	(1 << 14)
 #define FUSE_ASYNC_DIO		(1 << 15)
 #define FUSE_WRITEBACK_CACHE	(1 << 16)
+#define FUSE_CLOSE_WAIT		(1 << 17)
 
 /**
  * CUSE INIT request/reply flags

