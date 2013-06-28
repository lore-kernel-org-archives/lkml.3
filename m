Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983Ab3F1THz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jun 2013 15:07:55 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41832 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753470Ab3F1S4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jun 2013 14:56:54 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 036/105] libceph: add update_authorizer auth method
Date: Fri, 28 Jun 2013 11:50:58 -0700
Message-Id: <1372445527-24414-37-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372445527-24414-1-git-send-email-kamal@canonical.com>
References: <1372445527-24414-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 0bed9b5c523d577378b6f83eab5835fe30c27208 upstream.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/ceph/mds_client.c      |  7 ++++++-
 include/linux/ceph/auth.h |  3 +++
 net/ceph/auth_x.c         | 23 +++++++++++++++++++++++
 net/ceph/auth_x.h         |  1 +
 net/ceph/osd_client.c     |  5 +++++
 5 files changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index c86cab7..7532cb5 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -3415,7 +3415,12 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
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
index b7b980d..c1ca5a6 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -2138,6 +2138,11 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
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
1.8.1.2

