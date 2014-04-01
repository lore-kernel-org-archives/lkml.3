Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbaDALS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 07:18:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42733 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955AbaDALSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 07:18:53 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <ilya.dryomov@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 128/144] libceph: rename ceph_msg::front_max to front_alloc_len
Date: Tue,  1 Apr 2014 12:15:32 +0100
Message-Id: <1396350948-29910-129-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
References: <1396350948-29910-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <ilya.dryomov@inktank.com>

commit 3cea4c3071d4e55e9d7356efe9d0ebf92f0c2204 upstream.

Rename front_max field of struct ceph_msg to front_alloc_len to make
its purpose more clear.

Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 include/linux/ceph/messenger.h | 2 +-
 net/ceph/messenger.c           | 6 +++---
 net/ceph/mon_client.c          | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
index 7c1420b..6ade97d 100644
--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -157,7 +157,7 @@ struct ceph_msg {
 	bool front_is_vmalloc;
 	bool more_to_follow;
 	bool needs_out_seq;
-	int front_max;
+	int front_alloc_len;
 	unsigned long ack_stamp;        /* tx: when we were acked */
 
 	struct ceph_msgpool *pool;
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index eb0a46a..a9226b7 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -3126,7 +3126,7 @@ struct ceph_msg *ceph_msg_new(int type, int front_len, gfp_t flags,
 	INIT_LIST_HEAD(&m->data);
 
 	/* front */
-	m->front_max = front_len;
+	m->front_alloc_len = front_len;
 	if (front_len) {
 		if (front_len > PAGE_CACHE_SIZE) {
 			m->front.iov_base = __vmalloc(front_len, flags,
@@ -3301,8 +3301,8 @@ EXPORT_SYMBOL(ceph_msg_last_put);
 
 void ceph_msg_dump(struct ceph_msg *msg)
 {
-	pr_debug("msg_dump %p (front_max %d length %zd)\n", msg,
-		 msg->front_max, msg->data_length);
+	pr_debug("msg_dump %p (front_alloc_len %d length %zd)\n", msg,
+		 msg->front_alloc_len, msg->data_length);
 	print_hex_dump(KERN_DEBUG, "header: ",
 		       DUMP_PREFIX_OFFSET, 16, 1,
 		       &msg->hdr, sizeof(msg->hdr), true);
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 1fe25cd..2ac9ef3 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -152,7 +152,7 @@ static int __open_session(struct ceph_mon_client *monc)
 		/* initiatiate authentication handshake */
 		ret = ceph_auth_build_hello(monc->auth,
 					    monc->m_auth->front.iov_base,
-					    monc->m_auth->front_max);
+					    monc->m_auth->front_alloc_len);
 		__send_prepared_auth_request(monc, ret);
 	} else {
 		dout("open_session mon%d already open\n", monc->cur_mon);
@@ -196,7 +196,7 @@ static void __send_subscribe(struct ceph_mon_client *monc)
 		int num;
 
 		p = msg->front.iov_base;
-		end = p + msg->front_max;
+		end = p + msg->front_alloc_len;
 
 		num = 1 + !!monc->want_next_osdmap + !!monc->want_mdsmap;
 		ceph_encode_32(&p, num);
@@ -897,7 +897,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 	ret = ceph_handle_auth_reply(monc->auth, msg->front.iov_base,
 				     msg->front.iov_len,
 				     monc->m_auth->front.iov_base,
-				     monc->m_auth->front_max);
+				     monc->m_auth->front_alloc_len);
 	if (ret < 0) {
 		monc->client->auth_err = ret;
 		wake_up_all(&monc->client->auth_wq);
@@ -939,7 +939,7 @@ static int __validate_auth(struct ceph_mon_client *monc)
 		return 0;
 
 	ret = ceph_build_auth(monc->auth, monc->m_auth->front.iov_base,
-			      monc->m_auth->front_max);
+			      monc->m_auth->front_alloc_len);
 	if (ret <= 0)
 		return ret; /* either an error, or no need to authenticate */
 	__send_prepared_auth_request(monc, ret);
-- 
1.9.1

