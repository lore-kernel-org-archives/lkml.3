Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab3LWV7P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 16:59:15 -0500
Received: from zimbra13.linbit.com ([212.69.166.240]:60680 "EHLO
	zimbra13.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932423Ab3LWV65 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 16:58:57 -0500
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 01/27] drbd: Rename net_conf variables old_conf -> old_net_conf and new_conf -> new_net_conf
Date: Mon, 23 Dec 2013 22:50:30 +0100
Message-Id: <1387835456-29695-2-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
References: <1387835456-29695-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Signed-off-by: Andreas Gruenbacher <agruen@linbit.com>
Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
---
 drivers/block/drbd/drbd_nl.c |   92 +++++++++++++++++++++---------------------
 1 file changed, 46 insertions(+), 46 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index abe96b0..a07b65a 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1921,29 +1921,29 @@ static bool conn_ov_running(struct drbd_connection *connection)
 }
 
 static enum drbd_ret_code
-_check_net_options(struct drbd_connection *connection, struct net_conf *old_conf, struct net_conf *new_conf)
+_check_net_options(struct drbd_connection *connection, struct net_conf *old_net_conf, struct net_conf *new_net_conf)
 {
 	struct drbd_peer_device *peer_device;
 	int i;
 
-	if (old_conf && connection->cstate == C_WF_REPORT_PARAMS && connection->agreed_pro_version < 100) {
-		if (new_conf->wire_protocol != old_conf->wire_protocol)
+	if (old_net_conf && connection->cstate == C_WF_REPORT_PARAMS && connection->agreed_pro_version < 100) {
+		if (new_net_conf->wire_protocol != old_net_conf->wire_protocol)
 			return ERR_NEED_APV_100;
 
-		if (new_conf->two_primaries != old_conf->two_primaries)
+		if (new_net_conf->two_primaries != old_net_conf->two_primaries)
 			return ERR_NEED_APV_100;
 
-		if (strcmp(new_conf->integrity_alg, old_conf->integrity_alg))
+		if (strcmp(new_net_conf->integrity_alg, old_net_conf->integrity_alg))
 			return ERR_NEED_APV_100;
 	}
 
-	if (!new_conf->two_primaries &&
+	if (!new_net_conf->two_primaries &&
 	    conn_highest_role(connection) == R_PRIMARY &&
 	    conn_highest_peer(connection) == R_PRIMARY)
 		return ERR_NEED_ALLOW_TWO_PRI;
 
-	if (new_conf->two_primaries &&
-	    (new_conf->wire_protocol != DRBD_PROT_C))
+	if (new_net_conf->two_primaries &&
+	    (new_net_conf->wire_protocol != DRBD_PROT_C))
 		return ERR_NOT_PROTO_C;
 
 	idr_for_each_entry(&connection->peer_devices, peer_device, i) {
@@ -1951,28 +1951,28 @@ _check_net_options(struct drbd_connection *connection, struct net_conf *old_conf
 		if (get_ldev(device)) {
 			enum drbd_fencing_p fp = rcu_dereference(device->ldev->disk_conf)->fencing;
 			put_ldev(device);
-			if (new_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH)
+			if (new_net_conf->wire_protocol == DRBD_PROT_A && fp == FP_STONITH)
 				return ERR_STONITH_AND_PROT_A;
 		}
-		if (device->state.role == R_PRIMARY && new_conf->discard_my_data)
+		if (device->state.role == R_PRIMARY && new_net_conf->discard_my_data)
 			return ERR_DISCARD_IMPOSSIBLE;
 	}
 
-	if (new_conf->on_congestion != OC_BLOCK && new_conf->wire_protocol != DRBD_PROT_A)
+	if (new_net_conf->on_congestion != OC_BLOCK && new_net_conf->wire_protocol != DRBD_PROT_A)
 		return ERR_CONG_NOT_PROTO_A;
 
 	return NO_ERROR;
 }
 
 static enum drbd_ret_code
-check_net_options(struct drbd_connection *connection, struct net_conf *new_conf)
+check_net_options(struct drbd_connection *connection, struct net_conf *new_net_conf)
 {
 	static enum drbd_ret_code rv;
 	struct drbd_peer_device *peer_device;
 	int i;
 
 	rcu_read_lock();
-	rv = _check_net_options(connection, rcu_dereference(connection->net_conf), new_conf);
+	rv = _check_net_options(connection, rcu_dereference(connection->net_conf), new_net_conf);
 	rcu_read_unlock();
 
 	/* connection->volumes protected by genl_lock() here */
@@ -2010,26 +2010,26 @@ alloc_hash(struct crypto_hash **tfm, char *tfm_name, int err_alg)
 }
 
 static enum drbd_ret_code
-alloc_crypto(struct crypto *crypto, struct net_conf *new_conf)
+alloc_crypto(struct crypto *crypto, struct net_conf *new_net_conf)
 {
 	char hmac_name[CRYPTO_MAX_ALG_NAME];
 	enum drbd_ret_code rv;
 
-	rv = alloc_hash(&crypto->csums_tfm, new_conf->csums_alg,
+	rv = alloc_hash(&crypto->csums_tfm, new_net_conf->csums_alg,
 		       ERR_CSUMS_ALG);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_hash(&crypto->verify_tfm, new_conf->verify_alg,
+	rv = alloc_hash(&crypto->verify_tfm, new_net_conf->verify_alg,
 		       ERR_VERIFY_ALG);
 	if (rv != NO_ERROR)
 		return rv;
-	rv = alloc_hash(&crypto->integrity_tfm, new_conf->integrity_alg,
+	rv = alloc_hash(&crypto->integrity_tfm, new_net_conf->integrity_alg,
 		       ERR_INTEGRITY_ALG);
 	if (rv != NO_ERROR)
 		return rv;
-	if (new_conf->cram_hmac_alg[0] != 0) {
+	if (new_net_conf->cram_hmac_alg[0] != 0) {
 		snprintf(hmac_name, CRYPTO_MAX_ALG_NAME, "hmac(%s)",
-			 new_conf->cram_hmac_alg);
+			 new_net_conf->cram_hmac_alg);
 
 		rv = alloc_hash(&crypto->cram_hmac_tfm, hmac_name,
 			       ERR_AUTH_ALG);
@@ -2050,7 +2050,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 {
 	enum drbd_ret_code retcode;
 	struct drbd_connection *connection;
-	struct net_conf *old_conf, *new_conf = NULL;
+	struct net_conf *old_net_conf, *new_net_conf = NULL;
 	int err;
 	int ovr; /* online verify running */
 	int rsr; /* re-sync running */
@@ -2064,8 +2064,8 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	connection = adm_ctx.connection;
 
-	new_conf = kzalloc(sizeof(struct net_conf), GFP_KERNEL);
-	if (!new_conf) {
+	new_net_conf = kzalloc(sizeof(struct net_conf), GFP_KERNEL);
+	if (!new_net_conf) {
 		retcode = ERR_NOMEM;
 		goto out;
 	}
@@ -2074,48 +2074,48 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 
 	mutex_lock(&connection->data.mutex);
 	mutex_lock(&connection->conf_update);
-	old_conf = connection->net_conf;
+	old_net_conf = connection->net_conf;
 
-	if (!old_conf) {
+	if (!old_net_conf) {
 		drbd_msg_put_info("net conf missing, try connect");
 		retcode = ERR_INVALID_REQUEST;
 		goto fail;
 	}
 
-	*new_conf = *old_conf;
+	*new_net_conf = *old_net_conf;
 	if (should_set_defaults(info))
-		set_net_conf_defaults(new_conf);
+		set_net_conf_defaults(new_net_conf);
 
-	err = net_conf_from_attrs_for_change(new_conf, info);
+	err = net_conf_from_attrs_for_change(new_net_conf, info);
 	if (err && err != -ENOMSG) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
 		goto fail;
 	}
 
-	retcode = check_net_options(connection, new_conf);
+	retcode = check_net_options(connection, new_net_conf);
 	if (retcode != NO_ERROR)
 		goto fail;
 
 	/* re-sync running */
 	rsr = conn_resync_running(connection);
-	if (rsr && strcmp(new_conf->csums_alg, old_conf->csums_alg)) {
+	if (rsr && strcmp(new_net_conf->csums_alg, old_net_conf->csums_alg)) {
 		retcode = ERR_CSUMS_RESYNC_RUNNING;
 		goto fail;
 	}
 
 	/* online verify running */
 	ovr = conn_ov_running(connection);
-	if (ovr && strcmp(new_conf->verify_alg, old_conf->verify_alg)) {
+	if (ovr && strcmp(new_net_conf->verify_alg, old_net_conf->verify_alg)) {
 		retcode = ERR_VERIFY_RUNNING;
 		goto fail;
 	}
 
-	retcode = alloc_crypto(&crypto, new_conf);
+	retcode = alloc_crypto(&crypto, new_net_conf);
 	if (retcode != NO_ERROR)
 		goto fail;
 
-	rcu_assign_pointer(connection->net_conf, new_conf);
+	rcu_assign_pointer(connection->net_conf, new_net_conf);
 
 	if (!rsr) {
 		crypto_free_hash(connection->csums_tfm);
@@ -2140,7 +2140,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	mutex_unlock(&connection->conf_update);
 	mutex_unlock(&connection->data.mutex);
 	synchronize_rcu();
-	kfree(old_conf);
+	kfree(old_net_conf);
 
 	if (connection->cstate >= C_WF_REPORT_PARAMS)
 		drbd_send_sync_param(minor_to_device(conn_lowest_minor(connection)));
@@ -2151,7 +2151,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 	mutex_unlock(&connection->conf_update);
 	mutex_unlock(&connection->data.mutex);
 	free_crypto(&crypto);
-	kfree(new_conf);
+	kfree(new_net_conf);
  done:
 	conn_reconfig_done(connection);
  out:
@@ -2162,7 +2162,7 @@ int drbd_adm_net_opts(struct sk_buff *skb, struct genl_info *info)
 int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 {
 	struct drbd_peer_device *peer_device;
-	struct net_conf *old_conf, *new_conf = NULL;
+	struct net_conf *old_net_conf, *new_net_conf = NULL;
 	struct crypto crypto = { };
 	struct drbd_resource *resource;
 	struct drbd_connection *connection;
@@ -2212,41 +2212,41 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 	}
 
 	/* allocation not in the IO path, drbdsetup / netlink process context */
-	new_conf = kzalloc(sizeof(*new_conf), GFP_KERNEL);
-	if (!new_conf) {
+	new_net_conf = kzalloc(sizeof(*new_net_conf), GFP_KERNEL);
+	if (!new_net_conf) {
 		retcode = ERR_NOMEM;
 		goto fail;
 	}
 
-	set_net_conf_defaults(new_conf);
+	set_net_conf_defaults(new_net_conf);
 
-	err = net_conf_from_attrs(new_conf, info);
+	err = net_conf_from_attrs(new_net_conf, info);
 	if (err && err != -ENOMSG) {
 		retcode = ERR_MANDATORY_TAG;
 		drbd_msg_put_info(from_attrs_err_to_txt(err));
 		goto fail;
 	}
 
-	retcode = check_net_options(connection, new_conf);
+	retcode = check_net_options(connection, new_net_conf);
 	if (retcode != NO_ERROR)
 		goto fail;
 
-	retcode = alloc_crypto(&crypto, new_conf);
+	retcode = alloc_crypto(&crypto, new_net_conf);
 	if (retcode != NO_ERROR)
 		goto fail;
 
-	((char *)new_conf->shared_secret)[SHARED_SECRET_MAX-1] = 0;
+	((char *)new_net_conf->shared_secret)[SHARED_SECRET_MAX-1] = 0;
 
 	conn_flush_workqueue(connection);
 
 	mutex_lock(&connection->conf_update);
-	old_conf = connection->net_conf;
-	if (old_conf) {
+	old_net_conf = connection->net_conf;
+	if (old_net_conf) {
 		retcode = ERR_NET_CONFIGURED;
 		mutex_unlock(&connection->conf_update);
 		goto fail;
 	}
-	rcu_assign_pointer(connection->net_conf, new_conf);
+	rcu_assign_pointer(connection->net_conf, new_net_conf);
 
 	conn_free_crypto(connection);
 	connection->cram_hmac_tfm = crypto.cram_hmac_tfm;
@@ -2277,7 +2277,7 @@ int drbd_adm_connect(struct sk_buff *skb, struct genl_info *info)
 
 fail:
 	free_crypto(&crypto);
-	kfree(new_conf);
+	kfree(new_net_conf);
 
 	conn_reconfig_done(connection);
 out:
-- 
1.7.9.5

