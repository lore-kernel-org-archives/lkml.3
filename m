Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab3LBUNu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:13:50 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754573Ab3LBTRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:17:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Eric Seppanen <eric@purestorage.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.12 059/212] iscsi-target: chap auth shouldnt match username with trailing garbage
Date: Mon,  2 Dec 2013 11:14:10 -0800
Message-Id: <20131202191254.663440163@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202191248.517975703@linuxfoundation.org>
References: <20131202191248.517975703@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/iscsi/iscsi_target_auth.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/target/iscsi/iscsi_target_auth.c
+++ b/drivers/target/iscsi/iscsi_target_auth.c
@@ -146,6 +146,7 @@ static int chap_server_compute_md5(
 	unsigned char client_digest[MD5_SIGNATURE_SIZE];
 	unsigned char server_digest[MD5_SIGNATURE_SIZE];
 	unsigned char chap_n[MAX_CHAP_N_SIZE], chap_r[MAX_RESPONSE_LENGTH];
+	size_t compare_len;
 	struct iscsi_chap *chap = conn->auth_protocol;
 	struct crypto_hash *tfm;
 	struct hash_desc desc;
@@ -184,7 +185,9 @@ static int chap_server_compute_md5(
 		goto out;
 	}
 
-	if (memcmp(chap_n, auth->userid, strlen(auth->userid)) != 0) {
+	/* Include the terminating NULL in the compare */
+	compare_len = strlen(auth->userid) + 1;
+	if (strncmp(chap_n, auth->userid, compare_len) != 0) {
 		pr_err("CHAP_N values do not match!\n");
 		goto out;
 	}


