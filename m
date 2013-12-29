Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470Ab3L2CK6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:10:58 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55424 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752847Ab3L2CKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:10:54 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Nicholas Bellinger" <nab@linux-iscsi.org>,
        "Eric Seppanen" <eric@purestorage.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.810464826@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 083/185] iscsi-target: chap auth shouldn't match
 username with trailing garbage
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Seppanen <eric@purestorage.com>

commit 86784c6bdeeef78eed94d298be7a8879f6a97ee2 upstream.

In iSCSI negotiations with initiator CHAP enabled, usernames with
trailing garbage are permitted, because the string comparison only
checks the strlen of the configured username.

e.g. "usernameXXXXX" will be permitted to match "username".

Just check one more byte so the trailing null char is also matched.

Signed-off-by: Eric Seppanen <eric@purestorage.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/target/iscsi/iscsi_target_auth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -172,6 +172,7 @@ static int chap_server_compute_md5(
 	unsigned char client_digest[MD5_SIGNATURE_SIZE];
 	unsigned char server_digest[MD5_SIGNATURE_SIZE];
 	unsigned char chap_n[MAX_CHAP_N_SIZE], chap_r[MAX_RESPONSE_LENGTH];
+	size_t compare_len;
 	struct iscsi_chap *chap = (struct iscsi_chap *) conn->auth_protocol;
 	struct crypto_hash *tfm;
 	struct hash_desc desc;
@@ -210,7 +211,9 @@ static int chap_server_compute_md5(
 		goto out;
 	}
 
-	if (memcmp(chap_n, auth->userid, strlen(auth->userid)) != 0) {
+	/* Include the terminating NULL in the compare */
+	compare_len = strlen(auth->userid) + 1;
+	if (strncmp(chap_n, auth->userid, compare_len) != 0) {
 		pr_err("CHAP_N values do not match!\n");
 		goto out;
 	}

