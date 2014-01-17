Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099AbaAQRbQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 12:31:16 -0500
Received: from nautica.notk.org ([91.121.71.147]:34319 "EHLO nautica.notk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753043AbaAQRbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 12:31:12 -0500
From: Dominique Martinet <dominique.martinet@cea.fr>
To: Eric Van Hensbergen <ericvh@gmail.com>, linux-fsdevel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net
Cc: Dominique Martinet <dominique.martinet@cea.fr>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH] 9P: Add memory barriers to protect request fields over cb/rpc threads handoff
Date: Fri, 17 Jan 2014 18:31:00 +0100
Message-Id: <1389979860-7821-2-git-send-email-dominique.martinet@cea.fr>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1389979860-7821-1-git-send-email-dominique.martinet@cea.fr>
References: <1389979860-7821-1-git-send-email-dominique.martinet@cea.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need barriers to guarantee this pattern works as intended:
[w] req->rc, 1		[r] req->status, 1
wmb			rmb
[w] req->status, 1	[r] req->rc

Where the wmb ensures that rc gets written before status,
and the rmb ensures that if you observe status == 1, rc is the new value.

Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
---
 include/net/9p/client.h |  2 +-
 net/9p/client.c         | 16 +++++++++++++++-
 net/9p/trans_fd.c       | 15 ++++++---------
 net/9p/trans_rdma.c     |  3 +--
 net/9p/trans_virtio.c   |  3 +--
 5 files changed, 24 insertions(+), 15 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index c38a005..115aeac 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -261,7 +261,7 @@ int p9_client_mkdir_dotl(struct p9_fid *fid, char *name, int mode,
 int p9_client_lock_dotl(struct p9_fid *fid, struct p9_flock *flock, u8 *status);
 int p9_client_getlock_dotl(struct p9_fid *fid, struct p9_getlock *fl);
 struct p9_req_t *p9_tag_lookup(struct p9_client *, u16);
-void p9_client_cb(struct p9_client *c, struct p9_req_t *req);
+void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status);
 
 int p9_parse_header(struct p9_fcall *, int32_t *, int8_t *, int16_t *, int);
 int p9stat_read(struct p9_client *, char *, int, struct p9_wstat *);
diff --git a/net/9p/client.c b/net/9p/client.c
index ee8fd6b..03431f0 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -415,9 +415,17 @@ static void p9_free_req(struct p9_client *c, struct p9_req_t *r)
  * req: request received
  *
  */
-void p9_client_cb(struct p9_client *c, struct p9_req_t *req)
+void p9_client_cb(struct p9_client *c, struct p9_req_t *req, int status)
 {
 	p9_debug(P9_DEBUG_MUX, " tag %d\n", req->tc->tag);
+
+	/*
+	 * This barrier is needed to make sure any change made to req before
+	 * the other thread wakes up will indeed be seen by the waiting side.
+	 */
+	smp_wmb();
+	req->status = status;
+
 	wake_up(req->wq);
 	p9_debug(P9_DEBUG_MUX, "wakeup: %d\n", req->tc->tag);
 }
@@ -751,6 +759,12 @@ again:
 	err = wait_event_interruptible(*req->wq,
 				       req->status >= REQ_STATUS_RCVD);
 
+	/*
+	 * Make sure our req is coherent with regard to updates in other
+	 * threads - echoes to wmb() in the callback
+	 */
+	smp_rmb();
+
 	if ((err == -ERESTARTSYS) && (c->status == Connected)
 				  && (type == P9_TFLUSH)) {
 		sigpending = 1;
diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 9321a77..74e6bbc 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -212,15 +212,9 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 	m->err = err;
 
 	list_for_each_entry_safe(req, rtmp, &m->req_list, req_list) {
-		req->status = REQ_STATUS_ERROR;
-		if (!req->t_err)
-			req->t_err = err;
 		list_move(&req->req_list, &cancel_list);
 	}
 	list_for_each_entry_safe(req, rtmp, &m->unsent_req_list, req_list) {
-		req->status = REQ_STATUS_ERROR;
-		if (!req->t_err)
-			req->t_err = err;
 		list_move(&req->req_list, &cancel_list);
 	}
 	spin_unlock_irqrestore(&m->client->lock, flags);
@@ -228,7 +222,9 @@ static void p9_conn_cancel(struct p9_conn *m, int err)
 	list_for_each_entry_safe(req, rtmp, &cancel_list, req_list) {
 		p9_debug(P9_DEBUG_ERROR, "call back req %p\n", req);
 		list_del(&req->req_list);
-		p9_client_cb(m->client, req);
+		if (!req->t_err)
+			req->t_err = err;
+		p9_client_cb(m->client, req, REQ_STATUS_ERROR);
 	}
 }
 
@@ -302,6 +298,7 @@ static void p9_read_work(struct work_struct *work)
 {
 	int n, err;
 	struct p9_conn *m;
+	int status = REQ_STATUS_ERROR;
 
 	m = container_of(work, struct p9_conn, rq);
 
@@ -375,10 +372,10 @@ static void p9_read_work(struct work_struct *work)
 		p9_debug(P9_DEBUG_TRANS, "got new packet\n");
 		spin_lock(&m->client->lock);
 		if (m->req->status != REQ_STATUS_ERROR)
-			m->req->status = REQ_STATUS_RCVD;
+			status = REQ_STATUS_RCVD;
 		list_del(&m->req->req_list);
 		spin_unlock(&m->client->lock);
-		p9_client_cb(m->client, m->req);
+		p9_client_cb(m->client, m->req, status);
 		m->rbuf = NULL;
 		m->rpos = 0;
 		m->rsize = 0;
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 8f68df5..f127ae5 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -305,8 +305,7 @@ handle_recv(struct p9_client *client, struct p9_trans_rdma *rdma,
 	}
 
 	req->rc = c->rc;
-	req->status = REQ_STATUS_RCVD;
-	p9_client_cb(client, req);
+	p9_client_cb(client, req, REQ_STATUS_RCVD);
 
 	return;
 
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index 9c5a1aa..81785b7b 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -164,8 +164,7 @@ static void req_done(struct virtqueue *vq)
 		p9_debug(P9_DEBUG_TRANS, ": rc %p\n", rc);
 		p9_debug(P9_DEBUG_TRANS, ": lookup tag %d\n", rc->tag);
 		req = p9_tag_lookup(chan->client, rc->tag);
-		req->status = REQ_STATUS_RCVD;
-		p9_client_cb(chan->client, req);
+		p9_client_cb(chan->client, req, REQ_STATUS_RCVD);
 	}
 }
 
-- 
1.8.1.4

