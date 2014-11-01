Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbaKAWp2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:45:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60265 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751747AbaKAWjb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:31 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Ilya Dryomov" <ilya.dryomov@inktank.com>,
        "Sage Weil" <sage@redhat.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.21923262@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 037/102] libceph: add process_one_ticket() helper
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

commit 597cda357716a3cf8d994cb11927af917c8d71fa upstream.

Add a helper for processing individual cephx auth tickets.  Needed for
the next commit, which deals with allocating ticket buffers.  (Most of
the diff here is whitespace - view with git diff -b).

Signed-off-by: Ilya Dryomov <ilya.dryomov@inktank.com>
Reviewed-by: Sage Weil <sage@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/ceph/auth_x.c | 228 +++++++++++++++++++++++++++++-------------------------
 1 file changed, 124 insertions(+), 104 deletions(-)

--- a/net/ceph/auth_x.c
+++ b/net/ceph/auth_x.c
@@ -129,17 +129,131 @@ static void remove_ticket_handler(struct
 	kfree(th);
 }
 
+static int process_one_ticket(struct ceph_auth_client *ac,
+			      struct ceph_crypto_key *secret,
+			      void **p, void *end,
+			      void *dbuf, void *ticket_buf)
+{
+	struct ceph_x_info *xi = ac->private;
+	int type;
+	u8 tkt_struct_v, blob_struct_v;
+	struct ceph_x_ticket_handler *th;
+	void *dp, *dend;
+	int dlen;
+	char is_enc;
+	struct timespec validity;
+	struct ceph_crypto_key old_key;
+	void *tp, *tpend;
+	struct ceph_timespec new_validity;
+	struct ceph_crypto_key new_session_key;
+	struct ceph_buffer *new_ticket_blob;
+	unsigned long new_expires, new_renew_after;
+	u64 new_secret_id;
+	int ret;
+
+	ceph_decode_need(p, end, sizeof(u32) + 1, bad);
+
+	type = ceph_decode_32(p);
+	dout(" ticket type %d %s\n", type, ceph_entity_type_name(type));
+
+	tkt_struct_v = ceph_decode_8(p);
+	if (tkt_struct_v != 1)
+		goto bad;
+
+	th = get_ticket_handler(ac, type);
+	if (IS_ERR(th)) {
+		ret = PTR_ERR(th);
+		goto out;
+	}
+
+	/* blob for me */
+	dlen = ceph_x_decrypt(secret, p, end, dbuf,
+			      TEMP_TICKET_BUF_LEN);
+	if (dlen <= 0) {
+		ret = dlen;
+		goto out;
+	}
+	dout(" decrypted %d bytes\n", dlen);
+	dp = dbuf;
+	dend = dp + dlen;
+
+	tkt_struct_v = ceph_decode_8(&dp);
+	if (tkt_struct_v != 1)
+		goto bad;
+
+	memcpy(&old_key, &th->session_key, sizeof(old_key));
+	ret = ceph_crypto_key_decode(&new_session_key, &dp, dend);
+	if (ret)
+		goto out;
+
+	ceph_decode_copy(&dp, &new_validity, sizeof(new_validity));
+	ceph_decode_timespec(&validity, &new_validity);
+	new_expires = get_seconds() + validity.tv_sec;
+	new_renew_after = new_expires - (validity.tv_sec / 4);
+	dout(" expires=%lu renew_after=%lu\n", new_expires,
+	     new_renew_after);
+
+	/* ticket blob for service */
+	ceph_decode_8_safe(p, end, is_enc, bad);
+	tp = ticket_buf;
+	if (is_enc) {
+		/* encrypted */
+		dout(" encrypted ticket\n");
+		dlen = ceph_x_decrypt(&old_key, p, end, ticket_buf,
+				      TEMP_TICKET_BUF_LEN);
+		if (dlen < 0) {
+			ret = dlen;
+			goto out;
+		}
+		dlen = ceph_decode_32(&tp);
+	} else {
+		/* unencrypted */
+		ceph_decode_32_safe(p, end, dlen, bad);
+		ceph_decode_need(p, end, dlen, bad);
+		ceph_decode_copy(p, ticket_buf, dlen);
+	}
+	tpend = tp + dlen;
+	dout(" ticket blob is %d bytes\n", dlen);
+	ceph_decode_need(&tp, tpend, 1 + sizeof(u64), bad);
+	blob_struct_v = ceph_decode_8(&tp);
+	new_secret_id = ceph_decode_64(&tp);
+	ret = ceph_decode_buffer(&new_ticket_blob, &tp, tpend);
+	if (ret)
+		goto out;
+
+	/* all is well, update our ticket */
+	ceph_crypto_key_destroy(&th->session_key);
+	if (th->ticket_blob)
+		ceph_buffer_put(th->ticket_blob);
+	th->session_key = new_session_key;
+	th->ticket_blob = new_ticket_blob;
+	th->validity = new_validity;
+	th->secret_id = new_secret_id;
+	th->expires = new_expires;
+	th->renew_after = new_renew_after;
+	dout(" got ticket service %d (%s) secret_id %lld len %d\n",
+	     type, ceph_entity_type_name(type), th->secret_id,
+	     (int)th->ticket_blob->vec.iov_len);
+	xi->have_keys |= th->service;
+
+out:
+	return ret;
+
+bad:
+	ret = -EINVAL;
+	goto out;
+}
+
 static int ceph_x_proc_ticket_reply(struct ceph_auth_client *ac,
 				    struct ceph_crypto_key *secret,
 				    void *buf, void *end)
 {
-	struct ceph_x_info *xi = ac->private;
-	int num;
 	void *p = buf;
-	int ret;
 	char *dbuf;
 	char *ticket_buf;
 	u8 reply_struct_v;
+	u32 num;
+	int ret;
 
 	dbuf = kmalloc(TEMP_TICKET_BUF_LEN, GFP_NOFS);
 	if (!dbuf)
@@ -150,112 +264,18 @@ static int ceph_x_proc_ticket_reply(stru
 	if (!ticket_buf)
 		goto out_dbuf;
 
-	ceph_decode_need(&p, end, 1 + sizeof(u32), bad);
-	reply_struct_v = ceph_decode_8(&p);
+	ceph_decode_8_safe(&p, end, reply_struct_v, bad);
 	if (reply_struct_v != 1)
-		goto bad;
-	num = ceph_decode_32(&p);
-	dout("%d tickets\n", num);
-	while (num--) {
-		int type;
-		u8 tkt_struct_v, blob_struct_v;
-		struct ceph_x_ticket_handler *th;
-		void *dp, *dend;
-		int dlen;
-		char is_enc;
-		struct timespec validity;
-		struct ceph_crypto_key old_key;
-		void *tp, *tpend;
-		struct ceph_timespec new_validity;
-		struct ceph_crypto_key new_session_key;
-		struct ceph_buffer *new_ticket_blob;
-		unsigned long new_expires, new_renew_after;
-		u64 new_secret_id;
-
-		ceph_decode_need(&p, end, sizeof(u32) + 1, bad);
-
-		type = ceph_decode_32(&p);
-		dout(" ticket type %d %s\n", type, ceph_entity_type_name(type));
-
-		tkt_struct_v = ceph_decode_8(&p);
-		if (tkt_struct_v != 1)
-			goto bad;
-
-		th = get_ticket_handler(ac, type);
-		if (IS_ERR(th)) {
-			ret = PTR_ERR(th);
-			goto out;
-		}
-
-		/* blob for me */
-		dlen = ceph_x_decrypt(secret, &p, end, dbuf,
-				      TEMP_TICKET_BUF_LEN);
-		if (dlen <= 0) {
-			ret = dlen;
-			goto out;
-		}
-		dout(" decrypted %d bytes\n", dlen);
-		dend = dbuf + dlen;
-		dp = dbuf;
-
-		tkt_struct_v = ceph_decode_8(&dp);
-		if (tkt_struct_v != 1)
-			goto bad;
+		return -EINVAL;
 
-		memcpy(&old_key, &th->session_key, sizeof(old_key));
-		ret = ceph_crypto_key_decode(&new_session_key, &dp, dend);
-		if (ret)
-			goto out;
+	ceph_decode_32_safe(&p, end, num, bad);
+	dout("%d tickets\n", num);
 
-		ceph_decode_copy(&dp, &new_validity, sizeof(new_validity));
-		ceph_decode_timespec(&validity, &new_validity);
-		new_expires = get_seconds() + validity.tv_sec;
-		new_renew_after = new_expires - (validity.tv_sec / 4);
-		dout(" expires=%lu renew_after=%lu\n", new_expires,
-		     new_renew_after);
-
-		/* ticket blob for service */
-		ceph_decode_8_safe(&p, end, is_enc, bad);
-		tp = ticket_buf;
-		if (is_enc) {
-			/* encrypted */
-			dout(" encrypted ticket\n");
-			dlen = ceph_x_decrypt(&old_key, &p, end, ticket_buf,
-					      TEMP_TICKET_BUF_LEN);
-			if (dlen < 0) {
-				ret = dlen;
-				goto out;
-			}
-			dlen = ceph_decode_32(&tp);
-		} else {
-			/* unencrypted */
-			ceph_decode_32_safe(&p, end, dlen, bad);
-			ceph_decode_need(&p, end, dlen, bad);
-			ceph_decode_copy(&p, ticket_buf, dlen);
-		}
-		tpend = tp + dlen;
-		dout(" ticket blob is %d bytes\n", dlen);
-		ceph_decode_need(&tp, tpend, 1 + sizeof(u64), bad);
-		blob_struct_v = ceph_decode_8(&tp);
-		new_secret_id = ceph_decode_64(&tp);
-		ret = ceph_decode_buffer(&new_ticket_blob, &tp, tpend);
+	while (num--) {
+		ret = process_one_ticket(ac, secret, &p, end,
+					 dbuf, ticket_buf);
 		if (ret)
 			goto out;
-
-		/* all is well, update our ticket */
-		ceph_crypto_key_destroy(&th->session_key);
-		if (th->ticket_blob)
-			ceph_buffer_put(th->ticket_blob);
-		th->session_key = new_session_key;
-		th->ticket_blob = new_ticket_blob;
-		th->validity = new_validity;
-		th->secret_id = new_secret_id;
-		th->expires = new_expires;
-		th->renew_after = new_renew_after;
-		dout(" got ticket service %d (%s) secret_id %lld len %d\n",
-		     type, ceph_entity_type_name(type), th->secret_id,
-		     (int)th->ticket_blob->vec.iov_len);
-		xi->have_keys |= th->service;
 	}
 
 	ret = 0;

