Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab3CUOED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:04:03 -0400
Received: from relay.parallels.com ([195.214.232.42]:38951 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758313Ab3CUOEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:04:01 -0400
Subject: [PATCH 2/4] fuse: add flag fc->uninitialized
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, xemul@parallels.com,
        linux-kernel@vger.kernel.org, devel@openvz.org, dev@parallels.com
Date: Thu, 21 Mar 2013 18:02:15 +0400
Message-ID: <20130321140209.4051.90573.stgit@maximpc.sw.ru>
In-Reply-To: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
References: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Existing flag fc->blocked is used to suspend request allocation both in case
of many background request submitted and period of time before init_reply
arrives from userspace. Next patch will skip blocking allocations of
synchronous request (disregarding fc->blocked). This is mostly OK, but
we still need to suspend allocations if init_reply is not arrived yet. The
patch introduces flag fc->uninitialized which will serve this purpose.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/cuse.c   |    1 +
 fs/fuse/dev.c    |    1 +
 fs/fuse/fuse_i.h |    4 ++++
 fs/fuse/inode.c  |    3 +++
 4 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/fs/fuse/cuse.c b/fs/fuse/cuse.c
index b7c7f30..8fe0998 100644
--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -505,6 +505,7 @@ static int cuse_channel_open(struct inode *inode, struct file *file)
 
 	cc->fc.connected = 1;
 	cc->fc.blocked = 0;
+	cc->fc.uninitialized = 0;
 	rc = cuse_send_init(cc);
 	if (rc) {
 		fuse_conn_put(&cc->fc);
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 512626f..6137650 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -2089,6 +2089,7 @@ void fuse_abort_conn(struct fuse_conn *fc)
 	if (fc->connected) {
 		fc->connected = 0;
 		fc->blocked = 0;
+		fc->uninitialized = 0;
 		end_io_requests(fc);
 		end_queued_requests(fc);
 		end_polls(fc);
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index 457f62e..e893126 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -417,6 +417,10 @@ struct fuse_conn {
 	/** Batching of FORGET requests (positive indicates FORGET batch) */
 	int forget_batch;
 
+	/** Flag indicating that INIT reply is not received yet. Allocating
+	 * any fuse request will be suspended until the flag is cleared */
+	int uninitialized;
+
 	/** Flag indicating if connection is blocked.  This will be
 	    the case before the INIT reply is received, and if there
 	    are too many outstading backgrounds requests */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index de0bee0..0d14f03 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -362,6 +362,7 @@ void fuse_conn_kill(struct fuse_conn *fc)
 	spin_lock(&fc->lock);
 	fc->connected = 0;
 	fc->blocked = 0;
+	fc->uninitialized = 0;
 	spin_unlock(&fc->lock);
 	/* Flush all readers on this fs */
 	kill_fasync(&fc->fasync, SIGIO, POLL_IN);
@@ -582,6 +583,7 @@ void fuse_conn_init(struct fuse_conn *fc)
 	fc->polled_files = RB_ROOT;
 	fc->reqctr = 0;
 	fc->blocked = 1;
+	fc->uninitialized = 1;
 	fc->attr_version = 1;
 	get_random_bytes(&fc->scramble_key, sizeof(fc->scramble_key));
 }
@@ -881,6 +883,7 @@ static void process_init_reply(struct fuse_conn *fc, struct fuse_req *req)
 		fc->conn_init = 1;
 	}
 	fc->blocked = 0;
+	fc->uninitialized = 0;
 	wake_up_all(&fc->blocked_waitq);
 }
 

