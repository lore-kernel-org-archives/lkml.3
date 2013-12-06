Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422746Ab3LFXPd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:15:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48548 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161346Ab3LFXPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:15:24 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Eric Seppanen <eric@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 147/152] iscsi-target: chap auth shouldn't match username with trailing garbage
Date: Fri,  6 Dec 2013 15:11:11 -0800
Message-Id: <1386371476-2477-148-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/target/iscsi/iscsi_target_auth.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/target/iscsi/iscsi_target_auth.c b/drivers/target/iscsi/iscsi_target_auth.c
index a0fc7b9..b54f6ec 100644
--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -174,6 +174,7 @@ static int chap_server_compute_md5(
 	unsigned char client_digest[MD5_SIGNATURE_SIZE];
 	unsigned char server_digest[MD5_SIGNATURE_SIZE];
 	unsigned char chap_n[MAX_CHAP_N_SIZE], chap_r[MAX_RESPONSE_LENGTH];
+	size_t compare_len;
 	struct iscsi_chap *chap = conn->auth_protocol;
 	struct crypto_hash *tfm;
 	struct hash_desc desc;
@@ -212,7 +213,9 @@ static int chap_server_compute_md5(
 		goto out;
 	}
 
-	if (memcmp(chap_n, auth->userid, strlen(auth->userid)) != 0) {
+	/* Include the terminating NULL in the compare */
+	compare_len = strlen(auth->userid) + 1;
+	if (strncmp(chap_n, auth->userid, compare_len) != 0) {
 		pr_err("CHAP_N values do not match!\n");
 		goto out;
 	}
-- 
1.8.3.2

