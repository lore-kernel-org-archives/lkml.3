Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932087Ab3CLArn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:47:43 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:33494 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940Ab3CLAri (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:47:38 -0400
From: Lucas De Marchi <lucas.demarchi@profusion.mobi>
To: Oleg Nesterov <oleg@redhat.com>
Cc: lucas.de.marchi@gmail.com, David Howells <dhowells@redhat.com>,
        James Morris <james.l.morris@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: [PATCH v3 4/7] KEYS: split call to call_usermodehelper_fns()
Date: Mon, 11 Mar 2013 21:48:08 -0300
Message-Id: <1363049291-946-4-git-send-email-lucas.demarchi@profusion.mobi>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
References: <1363049291-946-1-git-send-email-lucas.demarchi@profusion.mobi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use call_usermodehelper_setup() + call_usermodehelper_exec() instead of
calling call_usermodehelper_fns(). In case there's an OOM in this last
function the cleanup function may not be called - in this case we would
miss a call to key_put().

Signed-off-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
---

Changes from v2: simplify error handling as suggested by Oleg.

 security/keys/request_key.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 4bd6bdb..c411f9b 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -93,9 +93,16 @@ static void umh_keys_cleanup(struct subprocess_info *info)
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
+					  session_keyring);
+	if (!info)
+		return -ENOMEM;
+
+	key_get(session_keyring);
+	return call_usermodehelper_exec(info, wait);
 }
 
 /*
-- 
1.8.1.5

