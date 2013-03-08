Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933632Ab3CHGQJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 01:16:09 -0500
Received: from mail-ye0-f179.google.com ([209.85.213.179]:51250 "EHLO
	mail-ye0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933279Ab3CHGQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 01:16:06 -0500
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: lucas.de.marchi@gmail.com
Cc: David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/7] KEYS: split call to call_usermodehelper_fns()
Date: Fri,  8 Mar 2013 03:15:10 -0300
Message-Id: <1362723313-839-5-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1362723313-839-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
calling call_usermodehelper_fns(). In case there's an OOM in this last
function the cleanup function may not be called - in this case we would
miss a call to key_put().

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---
 security/keys/request_key.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 4bd6bdb..c958f34 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -93,9 +93,17 @@ static void umh_keys_cleanup(struct subprocess_info *info)
 static int call_usermodehelper_keys(char *path, char **argv, char **envp,
 					struct key *session_keyring, int wait)
 {
-	return call_usermodehelper_fns(path, argv, envp, wait,
-				       umh_keys_init, umh_keys_cleanup,
-				       key_get(session_keyring));
+	struct subprocess_info *info;
+
+	info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL,
+					  umh_keys_init, umh_keys_cleanup,
+					  key_get(session_keyring));
+	if (!info) {
+		key_put(session_keyring);
+		return -ENOMEM;
+	}
+
+	return call_usermodehelper_exec(info, wait);
 }
 
 /*
-- 
1.8.1.5

