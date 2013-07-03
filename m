Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965414Ab3GCTSM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 15:18:12 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:28849 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933580Ab3GCTAM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 15:00:12 -0400
X-Authority-Analysis: v=2.0 cv=Odoa/2vY c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=XbShyOEX-7MA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Tx9ZXHa1MQsA:10 a=DswfTcTIAAAA:8 a=4u6H09k7AAAA:8 a=qxUAMtGhAAAA:8 a=eY3ukbst54UnA48RCV4A:9 a=Xj94INMEKCoA:10 a=JfjM6313LcIA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184109.008026231@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:41:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sage Weil <sage@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [134/141] libceph: add update_authorizer auth method
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0134-libceph-add-update_authorizer-auth-method.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

[ Upstream commit 0bed9b5c523d577378b6f83eab5835fe30c27208 ]

Currently the messenger calls out to a get_authorizer con op, which will
create a new authorizer if it doesn't yet have one.  In the meantime, when
we rotate our service keys, the authorizer doesn't get updated.  Eventually
it will be rejected by the server on a new connection attempt and get
invalidated, and we will then rebuild a new authorizer, but this is not
ideal.

Instead, if we do have an authorizer, call a new update_authorizer op that
will verify that the current authorizer is using the latest secret.  If it
is not, we will build a new one that does.  This avoids the transient
failure.

This fixes one of the sorry sequence of events for bug

	http://tracker.ceph.com/issues/4282

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 fs/ceph/mds_client.c      |    7 ++++++-
 include/linux/ceph/auth.h |    3 +++
 net/ceph/auth_x.c         |   23 +++++++++++++++++++++++
 net/ceph/auth_x.h         |    1 +
 net/ceph/osd_client.c     |    5 +++++
 5 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index b254e7a..2553d93 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3410,7 +3410,12 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 	}
 	if (!auth->authorizer && ac->ops && ac->ops->create_authorizer) {
 		int ret = ac->ops->create_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
-							auth);
+						     auth);
+		if (ret)
+			return ERR_PTR(ret);
+	} else if (ac->ops && ac->ops_update_authorizer) {
+		int ret = ac->ops->update_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
+						     auth);
 		if (ret)
 			return ERR_PTR(ret);
 	}
diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
index d4080f3..73e973e 100644
--- a/include/linux/ceph/auth.h
+++ b/include/linux/ceph/auth.h
@@ -52,6 +52,9 @@ struct ceph_auth_client_ops {
 	 */
 	int (*create_authorizer)(struct ceph_auth_client *ac, int peer_type,
 				 struct ceph_auth_handshake *auth);
+	/* ensure that an existing authorizer is up to date */
+	int (*update_authorizer)(struct ceph_auth_client *ac, int peer_type,
+				 struct ceph_auth_handshake *auth);
 	int (*verify_authorizer_reply)(struct ceph_auth_client *ac,
 				       struct ceph_authorizer *a, size_t len);
 	void (*destroy_authorizer)(struct ceph_auth_client *ac,
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index bd8758d..2d59815 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -298,6 +298,7 @@ static int ceph_x_build_authorizer(struct ceph_auth_client *ac,
 			return -ENOMEM;
 	}
 	au->service = th->service;
+	au->secret_id = th->secret_id;
 
 	msg_a = au->buf->vec.iov_base;
 	msg_a->struct_v = 1;
@@ -555,6 +556,27 @@ static int ceph_x_create_authorizer(
 	return 0;
 }
 
+static int ceph_x_update_authorizer(
+	struct ceph_auth_client *ac, int peer_type,
+	struct ceph_auth_handshake *auth)
+{
+	struct ceph_x_authorizer *au;
+	struct ceph_x_ticket_handler *th;
+	int ret;
+
+	th = get_ticket_handler(ac, peer_type);
+	if (IS_ERR(th))
+		return PTR_ERR(th);
+
+	au = (struct ceph_x_authorizer *)auth->authorizer;
+	if (au->secret_id < th->secret_id) {
+		dout("ceph_x_update_authorizer service %u secret %llu < %llu\n",
+		     au->service, au->secret_id, th->secret_id);
+		return ceph_x_build_authorizer(ac, th, au);
+	}
+	return 0;
+}
+
 static int ceph_x_verify_authorizer_reply(struct ceph_auth_client *ac,
 					  struct ceph_authorizer *a, size_t len)
 {
@@ -641,6 +663,7 @@ static const struct ceph_auth_client_ops ceph_x_ops = {
 	.build_request = ceph_x_build_request,
 	.handle_reply = ceph_x_handle_reply,
 	.create_authorizer = ceph_x_create_authorizer,
+	.update_authorizer = ceph_x_update_authorizer,
 	.verify_authorizer_reply = ceph_x_verify_authorizer_reply,
 	.destroy_authorizer = ceph_x_destroy_authorizer,
 	.invalidate_authorizer = ceph_x_invalidate_authorizer,
diff --git a/net/ceph/auth_x.h b/net/ceph/auth_x.h
index f459e93..c5a058d 100644
--- a/net/ceph/auth_x.h
+++ b/net/ceph/auth_x.h
@@ -29,6 +29,7 @@ struct ceph_x_authorizer {
 	struct ceph_buffer *buf;
 	unsigned int service;
 	u64 nonce;
+	u64 secret_id;
 	char reply_buf[128];  /* big enough for encrypted blob */
 };
 
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index f7b56e2..dcb7fe2 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2163,6 +2163,11 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 							auth);
 		if (ret)
 			return ERR_PTR(ret);
+	} else if (ac->ops && ac->ops->update_authorizer) {
+		int ret = ac->ops->update_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
+						     auth);
+		if (ret)
+			return ERR_PTR(ret);
 	}
 	*proto = ac->protocol;
 
-- 
1.7.10.4


