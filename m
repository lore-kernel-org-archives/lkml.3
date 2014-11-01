Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbaKAWpx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:45:53 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60247 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751732AbaKAWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ilya Dryomov" <ilya.dryomov@inktank.com>,
        "Sage Weil" <sage@inktank.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.420326415@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 035/102] libceph: rename ceph_msg::front_max to
 front_alloc_len
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <ilya.dryomov@inktank.com>

commit 3cea4c3071d4e55e9d7356efe9d0ebf92f0c2204 upstream.

Rename front_max field of struct ceph_msg to front_alloc_len to make
its purpose more clear.

Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Reviewed-by: Sage Weil <sage@inktank.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 include/linux/ceph/messenger.h | 2 +-
 net/ceph/messenger.c           | 6 +++---
 net/ceph/mon_client.c          | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

--- a/include/linux/ceph/messenger.h
+++ b/include/linux/ceph/messenger.h
@@ -92,7 +92,7 @@ struct ceph_msg {
 	bool front_is_vmalloc;
 	bool more_to_follow;
 	bool needs_out_seq;
-	int front_max;
+	int front_alloc_len;
 	unsigned long ack_stamp;        /* tx: when we were acked */
 
 	struct ceph_msgpool *pool;
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2423,7 +2423,7 @@ struct ceph_msg *ceph_msg_new(int type,
 	m->footer.middle_crc = 0;
 	m->footer.data_crc = 0;
 	m->footer.flags = 0;
-	m->front_max = front_len;
+	m->front_alloc_len = front_len;
 	m->front_is_vmalloc = false;
 	m->more_to_follow = false;
 	m->ack_stamp = 0;
@@ -2594,8 +2594,8 @@ EXPORT_SYMBOL(ceph_msg_last_put);
 
 void ceph_msg_dump(struct ceph_msg *msg)
 {
-	pr_debug("msg_dump %p (front_max %d nr_pages %d)\n", msg,
-		 msg->front_max, msg->nr_pages);
+	pr_debug("msg_dump %p (front_alloc_len %d nr_pages %d)\n", msg,
+		 msg->front_alloc_len, msg->nr_pages);
 	print_hex_dump(KERN_DEBUG, "header: ",
 		       DUMP_PREFIX_OFFSET, 16, 1,
 		       &msg->hdr, sizeof(msg->hdr), true);
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -150,7 +150,7 @@ static int __open_session(struct ceph_mo
 		/* initiatiate authentication handshake */
 		ret = ceph_auth_build_hello(monc->auth,
 					    monc->m_auth->front.iov_base,
-					    monc->m_auth->front_max);
+					    monc->m_auth->front_alloc_len);
 		__send_prepared_auth_request(monc, ret);
 	} else {
 		dout("open_session mon%d already open\n", monc->cur_mon);
@@ -194,7 +194,7 @@ static void __send_subscribe(struct ceph
 		int num;
 
 		p = msg->front.iov_base;
-		end = p + msg->front_max;
+		end = p + msg->front_alloc_len;
 
 		num = 1 + !!monc->want_next_osdmap + !!monc->want_mdsmap;
 		ceph_encode_32(&p, num);
@@ -860,7 +860,7 @@ static void handle_auth_reply(struct cep
 	ret = ceph_handle_auth_reply(monc->auth, msg->front.iov_base,
 				     msg->front.iov_len,
 				     monc->m_auth->front.iov_base,
-				     monc->m_auth->front_max);
+				     monc->m_auth->front_alloc_len);
 	if (ret < 0) {
 		monc->client->auth_err = ret;
 		wake_up_all(&monc->client->auth_wq);
@@ -887,7 +887,7 @@ static int __validate_auth(struct ceph_m
 		return 0;
 
 	ret = ceph_build_auth(monc->auth, monc->m_auth->front.iov_base,
-			      monc->m_auth->front_max);
+			      monc->m_auth->front_alloc_len);
 	if (ret <= 0)
 		return ret; /* either an error, or no need to authenticate */
 	__send_prepared_auth_request(monc, ret);

