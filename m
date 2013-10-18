Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092Ab3JRQvh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 12:51:37 -0400
Received: from mail.tpi.com ([74.45.170.26]:57686 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756519Ab3JRQvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 12:51:24 -0400
From: Tim Gardner <timg@tpi.com>
To: linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
        linux-kernel@vger.kernel.org
Cc: Tim Gardner <timg@tpi.com>, Jeff Layton <jlayton@redhat.com>,
        Steve French <sfrench@samba.org>
Subject: [PATCH linux-next] cifs: Cleanup and clarify CalcNTLMv2_response()
Date: Fri, 18 Oct 2013 10:51:15 -0600
Message-Id: <1382115075-4386-1-git-send-email-timg@tpi.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use of a structure aids in the understanding of this
seemingly simple bit of code. The addition of a couple
of comments also helps.

Cc: Jeff Layton <jlayton@redhat.com>
Cc: Steve French <sfrench@samba.org>
Signed-off-by: Tim Gardner <timg@tpi.com>
---

I'd just like to be sure that the destructive copy is
really what was intended. I can't tell from reading the MSDN
section 3.3.2 NTLM v2 Authentication. It sort of makes
my head hurt.

rtg

 fs/cifs/cifsencrypt.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/fs/cifs/cifsencrypt.c b/fs/cifs/cifsencrypt.c
index fc6f4f3..fecbfd0 100644
--- a/fs/cifs/cifsencrypt.c
+++ b/fs/cifs/cifsencrypt.c
@@ -548,7 +548,9 @@ static int
 CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 {
 	int rc;
-	unsigned int offset = CIFS_SESS_KEY_SIZE + 8;
+	struct ntlmv2_resp *resp = (struct ntlmv2_resp *)
+		(ses->auth_key.response + CIFS_SESS_KEY_SIZE);
+	unsigned int hashed_len = ses->auth_key.len - (CIFS_SESS_KEY_SIZE + 8);
 
 	if (!ses->server->secmech.sdeschmacmd5) {
 		cifs_dbg(VFS, "%s: can't generate ntlmv2 hash\n", __func__);
@@ -569,21 +571,30 @@ CalcNTLMv2_response(const struct cifs_ses *ses, char *ntlmv2_hash)
 		return rc;
 	}
 
+	/*
+	 * The cryptkey is part of the buffer that feeds the MD5 hash, but
+	 * gets over written later by the digest. See crypto_shash_final()
+	 * below.
+	 */
 	if (ses->server->negflavor == CIFS_NEGFLAVOR_EXTENDED)
-		memcpy(ses->auth_key.response + offset,
+		memcpy(&resp->ntlmv2_hash[CIFS_SERVER_CHALLENGE_SIZE],
 			ses->ntlmssp->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
 	else
-		memcpy(ses->auth_key.response + offset,
+		memcpy(&resp->ntlmv2_hash[CIFS_SERVER_CHALLENGE_SIZE],
 			ses->server->cryptkey, CIFS_SERVER_CHALLENGE_SIZE);
 	rc = crypto_shash_update(&ses->server->secmech.sdeschmacmd5->shash,
-		ses->auth_key.response + offset, ses->auth_key.len - offset);
+		&resp->ntlmv2_hash[8], hashed_len);
 	if (rc) {
 		cifs_dbg(VFS, "%s: Could not update with response\n", __func__);
 		return rc;
 	}
 
+	/*
+	 * Yes - this is destructive. The 16 byte MD5 digest clobbers the
+	 * cryptkey that was just copied into &resp->ntlmv2_hash[8].
+	 */
 	rc = crypto_shash_final(&ses->server->secmech.sdeschmacmd5->shash,
-		ses->auth_key.response + CIFS_SESS_KEY_SIZE);
+		resp->ntlmv2_hash);
 	if (rc)
 		cifs_dbg(VFS, "%s: Could not generate md5 hash\n", __func__);
 
-- 
1.7.9.5

