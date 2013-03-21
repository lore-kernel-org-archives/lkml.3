Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab3CUOE0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 10:04:26 -0400
Received: from relay.parallels.com ([195.214.232.42]:38998 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757623Ab3CUOEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 10:04:22 -0400
Subject: [PATCH 4/4] fuse: implement exclusive wakeup for blocked_waitq
To: miklos@szeredi.hu
From: "Maxim V. Patlasov" <MPatlasov@parallels.com>
Cc: fuse-devel@lists.sourceforge.net, xemul@parallels.com,
        linux-kernel@vger.kernel.org, devel@openvz.org, dev@parallels.com
Date: Thu, 21 Mar 2013 18:02:36 +0400
Message-ID: <20130321140233.4051.30911.stgit@maximpc.sw.ru>
In-Reply-To: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
References: <20130321140047.4051.6701.stgit@maximpc.sw.ru>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch solves thundering herd problem. So far as previous patches ensured
that only allocations for background may block, it's safe to wake up one
waiter. Whoever it is, it will wake up another one in request_end() afterwards.

Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
---
 fs/fuse/dev.c |   20 ++++++++++++++++----
 1 files changed, 16 insertions(+), 4 deletions(-)

diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 1f7ce89..ea99e2a 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -152,7 +152,8 @@ struct fuse_req *fuse_get_req_internal(struct fuse_conn *fc, unsigned npages,
 		int intr;
 
 		block_sigs(&oldset);
-		intr = wait_event_interruptible(fc->blocked_waitq, !*flag_p);
+		intr = wait_event_interruptible_exclusive(fc->blocked_waitq,
+							  !*flag_p);
 		restore_sigs(&oldset);
 		err = -EINTR;
 		if (intr)
@@ -265,6 +266,13 @@ struct fuse_req *fuse_get_req_nofail_nopages(struct fuse_conn *fc,
 void fuse_put_request(struct fuse_conn *fc, struct fuse_req *req)
 {
 	if (atomic_dec_and_test(&req->count)) {
+		if (unlikely(req->background)) {
+			spin_lock(&fc->lock);
+			if (!fc->blocked)
+				wake_up(&fc->blocked_waitq);
+			spin_unlock(&fc->lock);
+		}
+
 		if (req->waiting)
 			atomic_dec(&fc->num_waiting);
 
@@ -362,10 +370,14 @@ __releases(fc->lock)
 	list_del(&req->intr_entry);
 	req->state = FUSE_REQ_FINISHED;
 	if (req->background) {
-		if (fc->num_background == fc->max_background) {
+		req->background = 0;
+
+		if (fc->num_background == fc->max_background)
 			fc->blocked = 0;
-			wake_up_all(&fc->blocked_waitq);
-		}
+
+		if (!fc->blocked)
+			wake_up(&fc->blocked_waitq);
+
 		if (fc->num_background == fc->congestion_threshold &&
 		    fc->connected && fc->bdi_initialized) {
 			clear_bdi_congested(&fc->bdi, BLK_RW_SYNC);

