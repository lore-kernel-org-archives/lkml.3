Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932518Ab3FRLzu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 07:55:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:56154 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932230Ab3FRLoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 07:44:54 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sage Weil <sage@inktank.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 58/93] libceph: wrap auth ops in wrapper functions
Date: Tue, 18 Jun 2013 12:43:06 +0100
Message-Id: <1371555821-12820-59-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
References: <1371555821-12820-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sage Weil <sage@inktank.com>

commit 27859f9773e4a0b2042435b13400ee2c891a61f4 upstream.

Use wrapper functions that check whether the auth op exists so that callers
do not need a bunch of conditional checks.  Simplifies the external
interface.

Signed-off-by: Sage Weil <sage@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 fs/ceph/mds_client.c      | 26 ++++++++++++--------------
 include/linux/ceph/auth.h | 13 +++++++++++++
 net/ceph/auth.c           | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 net/ceph/auth_x.c         |  1 -
 net/ceph/mon_client.c     |  7 +++----
 net/ceph/osd_client.c     | 26 +++++++++-----------------
 6 files changed, 84 insertions(+), 36 deletions(-)

diff --git a/fs/ceph/mds_client.c b/fs/ceph/mds_client.c
index 38042cb..7111bc9 100644
--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -335,9 +335,9 @@ void ceph_put_mds_session(struct ceph_mds_session *s)
 	     atomic_read(&s->s_ref), atomic_read(&s->s_ref)-1);
 	if (atomic_dec_and_test(&s->s_ref)) {
 		if (s->s_auth.authorizer)
-		     s->s_mdsc->fsc->client->monc.auth->ops->destroy_authorizer(
-			     s->s_mdsc->fsc->client->monc.auth,
-			     s->s_auth.authorizer);
+			ceph_auth_destroy_authorizer(
+				s->s_mdsc->fsc->client->monc.auth,
+				s->s_auth.authorizer);
 		kfree(s);
 	}
 }
@@ -3408,18 +3408,17 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 	struct ceph_auth_handshake *auth = &s->s_auth;
 
 	if (force_new && auth->authorizer) {
-		if (ac->ops && ac->ops->destroy_authorizer)
-			ac->ops->destroy_authorizer(ac, auth->authorizer);
+		ceph_auth_destroy_authorizer(ac, auth->authorizer);
 		auth->authorizer = NULL;
 	}
-	if (!auth->authorizer && ac->ops && ac->ops->create_authorizer) {
-		int ret = ac->ops->create_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
-						     auth);
+	if (!auth->authorizer) {
+		int ret = ceph_auth_create_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
+						      auth);
 		if (ret)
 			return ERR_PTR(ret);
-	} else if (ac->ops && ac->ops_update_authorizer) {
-		int ret = ac->ops->update_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
-						     auth);
+	} else {
+		int ret = ceph_auth_update_authorizer(ac, CEPH_ENTITY_TYPE_MDS,
+						      auth);
 		if (ret)
 			return ERR_PTR(ret);
 	}
@@ -3435,7 +3434,7 @@ static int verify_authorizer_reply(struct ceph_connection *con, int len)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 	struct ceph_auth_client *ac = mdsc->fsc->client->monc.auth;
 
-	return ac->ops->verify_authorizer_reply(ac, s->s_auth.authorizer, len);
+	return ceph_auth_verify_authorizer_reply(ac, s->s_auth.authorizer, len);
 }
 
 static int invalidate_authorizer(struct ceph_connection *con)
@@ -3444,8 +3443,7 @@ static int invalidate_authorizer(struct ceph_connection *con)
 	struct ceph_mds_client *mdsc = s->s_mdsc;
 	struct ceph_auth_client *ac = mdsc->fsc->client->monc.auth;
 
-	if (ac->ops->invalidate_authorizer)
-		ac->ops->invalidate_authorizer(ac, CEPH_ENTITY_TYPE_MDS);
+	ceph_auth_invalidate_authorizer(ac, CEPH_ENTITY_TYPE_MDS);
 
 	return ceph_monc_validate_auth(&mdsc->fsc->client->monc);
 }
diff --git a/include/linux/ceph/auth.h b/include/linux/ceph/auth.h
index 73e973e..c9c3b3a 100644
--- a/include/linux/ceph/auth.h
+++ b/include/linux/ceph/auth.h
@@ -97,5 +97,18 @@ extern int ceph_build_auth(struct ceph_auth_client *ac,
 		    void *msg_buf, size_t msg_len);
 
 extern int ceph_auth_is_authenticated(struct ceph_auth_client *ac);
+extern int ceph_auth_create_authorizer(struct ceph_auth_client *ac,
+				       int peer_type,
+				       struct ceph_auth_handshake *auth);
+extern void ceph_auth_destroy_authorizer(struct ceph_auth_client *ac,
+					 struct ceph_authorizer *a);
+extern int ceph_auth_update_authorizer(struct ceph_auth_client *ac,
+				       int peer_type,
+				       struct ceph_auth_handshake *a);
+extern int ceph_auth_verify_authorizer_reply(struct ceph_auth_client *ac,
+					     struct ceph_authorizer *a,
+					     size_t len);
+extern void ceph_auth_invalidate_authorizer(struct ceph_auth_client *ac,
+					    int peer_type);
 
 #endif
diff --git a/net/ceph/auth.c b/net/ceph/auth.c
index b4bf4ac..a22de54 100644
--- a/net/ceph/auth.c
+++ b/net/ceph/auth.c
@@ -257,3 +257,50 @@ int ceph_auth_is_authenticated(struct ceph_auth_client *ac)
 		return 0;
 	return ac->ops->is_authenticated(ac);
 }
+EXPORT_SYMBOL(ceph_auth_is_authenticated);
+
+int ceph_auth_create_authorizer(struct ceph_auth_client *ac,
+				int peer_type,
+				struct ceph_auth_handshake *auth)
+{
+	if (ac->ops && ac->ops->create_authorizer)
+		return ac->ops->create_authorizer(ac, peer_type, auth);
+	return 0;
+}
+EXPORT_SYMBOL(ceph_auth_create_authorizer);
+
+void ceph_auth_destroy_authorizer(struct ceph_auth_client *ac,
+				  struct ceph_authorizer *a)
+{
+	if (ac->ops && ac->ops->destroy_authorizer)
+		ac->ops->destroy_authorizer(ac, a);
+}
+EXPORT_SYMBOL(ceph_auth_destroy_authorizer);
+
+int ceph_auth_update_authorizer(struct ceph_auth_client *ac,
+				int peer_type,
+				struct ceph_auth_handshake *a)
+{
+	int ret = 0;
+
+	if (ac->ops && ac->ops->update_authorizer)
+		ret = ac->ops->update_authorizer(ac, peer_type, a);
+	return ret;
+}
+EXPORT_SYMBOL(ceph_auth_update_authorizer);
+
+int ceph_auth_verify_authorizer_reply(struct ceph_auth_client *ac,
+				      struct ceph_authorizer *a, size_t len)
+{
+	if (ac->ops && ac->ops->verify_authorizer_reply)
+		return ac->ops->verify_authorizer_reply(ac, a, len);
+	return 0;
+}
+EXPORT_SYMBOL(ceph_auth_verify_authorizer_reply);
+
+void ceph_auth_invalidate_authorizer(struct ceph_auth_client *ac, int peer_type)
+{
+	if (ac->ops && ac->ops->invalidate_authorizer)
+		ac->ops->invalidate_authorizer(ac, peer_type);
+}
+EXPORT_SYMBOL(ceph_auth_invalidate_authorizer);
diff --git a/net/ceph/auth_x.c b/net/ceph/auth_x.c
index 2d59815..96238ba 100644
--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -562,7 +562,6 @@ static int ceph_x_update_authorizer(
 {
 	struct ceph_x_authorizer *au;
 	struct ceph_x_ticket_handler *th;
-	int ret;
 
 	th = get_ticket_handler(ac, peer_type);
 	if (IS_ERR(th))
diff --git a/net/ceph/mon_client.c b/net/ceph/mon_client.c
index 900ea0f..8a9235d 100644
--- a/net/ceph/mon_client.c
+++ b/net/ceph/mon_client.c
@@ -737,7 +737,7 @@ static void delayed_work(struct work_struct *work)
 
 		__validate_auth(monc);
 
-		if (monc->auth->ops->is_authenticated(monc->auth))
+		if (ceph_auth_is_authenticated(monc->auth))
 			__send_subscribe(monc);
 	}
 	__schedule_delayed(monc);
@@ -893,8 +893,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 
 	mutex_lock(&monc->mutex);
 	had_debugfs_info = have_debugfs_info(monc);
-	if (monc->auth->ops)
-		was_auth = monc->auth->ops->is_authenticated(monc->auth);
+	was_auth = ceph_auth_is_authenticated(monc->auth);
 	monc->pending_auth = 0;
 	ret = ceph_handle_auth_reply(monc->auth, msg->front.iov_base,
 				     msg->front.iov_len,
@@ -905,7 +904,7 @@ static void handle_auth_reply(struct ceph_mon_client *monc,
 		wake_up_all(&monc->client->auth_wq);
 	} else if (ret > 0) {
 		__send_prepared_auth_request(monc, ret);
-	} else if (!was_auth && monc->auth->ops->is_authenticated(monc->auth)) {
+	} else if (!was_auth && ceph_auth_is_authenticated(monc->auth)) {
 		dout("authenticated, starting session\n");
 
 		monc->client->msgr.inst.name.type = CEPH_ENTITY_TYPE_CLIENT;
diff --git a/net/ceph/osd_client.c b/net/ceph/osd_client.c
index d514d45..79592c4 100644
--- a/net/ceph/osd_client.c
+++ b/net/ceph/osd_client.c
@@ -672,8 +672,7 @@ static void put_osd(struct ceph_osd *osd)
 	if (atomic_dec_and_test(&osd->o_ref) && osd->o_auth.authorizer) {
 		struct ceph_auth_client *ac = osd->o_osdc->client->monc.auth;
 
-		if (ac->ops && ac->ops->destroy_authorizer)
-			ac->ops->destroy_authorizer(ac, osd->o_auth.authorizer);
+		ceph_auth_destroy_authorizer(ac, osd->o_auth.authorizer);
 		kfree(osd);
 	}
 }
@@ -2151,17 +2150,16 @@ static struct ceph_auth_handshake *get_authorizer(struct ceph_connection *con,
 	struct ceph_auth_handshake *auth = &o->o_auth;
 
 	if (force_new && auth->authorizer) {
-		if (ac->ops && ac->ops->destroy_authorizer)
-			ac->ops->destroy_authorizer(ac, auth->authorizer);
+		ceph_auth_destroy_authorizer(ac, auth->authorizer);
 		auth->authorizer = NULL;
 	}
-	if (!auth->authorizer && ac->ops && ac->ops->create_authorizer) {
-		int ret = ac->ops->create_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
-							auth);
+	if (!auth->authorizer) {
+		int ret = ceph_auth_create_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
+						      auth);
 		if (ret)
 			return ERR_PTR(ret);
-	} else if (ac->ops && ac->ops->update_authorizer) {
-		int ret = ac->ops->update_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
+	} else {
+		int ret = ceph_auth_update_authorizer(ac, CEPH_ENTITY_TYPE_OSD,
 						     auth);
 		if (ret)
 			return ERR_PTR(ret);
@@ -2178,11 +2176,7 @@ static int verify_authorizer_reply(struct ceph_connection *con, int len)
 	struct ceph_osd_client *osdc = o->o_osdc;
 	struct ceph_auth_client *ac = osdc->client->monc.auth;
 
-	/*
-	 * XXX If ac->ops or ac->ops->verify_authorizer_reply is null,
-	 * XXX which do we do:  succeed or fail?
-	 */
-	return ac->ops->verify_authorizer_reply(ac, o->o_auth.authorizer, len);
+	return ceph_auth_verify_authorizer_reply(ac, o->o_auth.authorizer, len);
 }
 
 static int invalidate_authorizer(struct ceph_connection *con)
@@ -2191,9 +2185,7 @@ static int invalidate_authorizer(struct ceph_connection *con)
 	struct ceph_osd_client *osdc = o->o_osdc;
 	struct ceph_auth_client *ac = osdc->client->monc.auth;
 
-	if (ac->ops && ac->ops->invalidate_authorizer)
-		ac->ops->invalidate_authorizer(ac, CEPH_ENTITY_TYPE_OSD);
-
+	ceph_auth_invalidate_authorizer(ac, CEPH_ENTITY_TYPE_OSD);
 	return ceph_monc_validate_auth(&osdc->client->monc);
 }
 
-- 
1.8.1.2

