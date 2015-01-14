Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094AbbANJdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 04:33:15 -0500
Received: from mx1.redhat.com ([209.132.183.28]:42107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030AbbANJdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 04:33:12 -0500
Subject: [RFC PATCH 5/5] KEYS: exec request-key within the requesting task's
 init namespace
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: David Howells <dhowells@redhat.com>, Oleg Nesterov <onestero@redhat.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Jeff Layton <jeff.layton@primarydata.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Wed, 14 Jan 2015 17:32:56 +0800
Message-ID: <20150114093255.30252.30614.stgit@pluto.fritz.box>
In-Reply-To: <20150114092704.30252.60446.stgit@pluto.fritz.box>
References: <20150114092704.30252.60446.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Containerized request key helper callbacks need the ability to execute
a binary in a container's context. To do this calling an in kernel
equivalent of setns(2) should be sufficient since the user mode helper
execution kernel thread ultimately calls do_execve().

Signed-off-by: Ian Kent <ikent@redhat.com>
Cc: Benjamin Coddington <bcodding@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
Cc: Jeff Layton <jeff.layton@primarydata.com>
---
 security/keys/request_key.c |   47 ++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 41 insertions(+), 6 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index 9e79bbf..d986ef3 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -17,6 +17,8 @@
 #include <linux/err.h>
 #include <linux/keyctl.h>
 #include <linux/slab.h>
+#include <linux/fs.h>
+#include <linux/nsproxy.h>
 #include "internal.h"
 
 #define key_negative_timeout	60	/* default timeout on a negative key's existence */
@@ -46,6 +48,11 @@ void complete_request_key(struct key_construction *cons, int error)
 }
 EXPORT_SYMBOL(complete_request_key);
 
+struct request_key_info {
+	struct key	*keyring;
+	pid_t		init_pid;
+};
+
 /*
  * Initialise a usermode helper that is going to have a specific session
  * keyring.
@@ -55,9 +62,18 @@ EXPORT_SYMBOL(complete_request_key);
  */
 static int umh_keys_init(struct subprocess_info *info, struct cred *cred)
 {
-	struct key *keyring = info->data;
+	struct request_key_info *rki = info->data;
+	pid_t init_pid = rki->init_pid;
+
+	if (init_pid) {
+		int err;
+
+		err = umh_enter_ns(init_pid, cred);
+		if (err)
+			return err;
+	}
 
-	return install_session_keyring_to_cred(cred, keyring);
+	return install_session_keyring_to_cred(cred, rki->keyring);
 }
 
 /*
@@ -65,8 +81,9 @@ static int umh_keys_init(struct subprocess_info *info, struct cred *cred)
  */
 static void umh_keys_cleanup(struct subprocess_info *info)
 {
-	struct key *keyring = info->data;
-	key_put(keyring);
+	struct request_key_info *rki = info->data;
+	key_put(rki->keyring);
+	kfree(rki);
 }
 
 /*
@@ -76,12 +93,30 @@ static int call_usermodehelper_keys(char *path, char **argv, char **envp,
 					struct key *session_keyring, int flags)
 {
 	struct subprocess_info *info;
+	struct request_key_info *rki;
+	unsigned int use_ns = flags & UMH_USE_NS;
+	pid_t init_pid = 0;
+
+	rki = kmalloc(sizeof(*rki), GFP_KERNEL);
+	if (!rki)
+		return -ENOMEM;
+
+	if (use_ns) {
+		int ret = umh_get_init_pid(&init_pid);
+		if (ret)
+			return ret;
+	}
+
+	rki->keyring = session_keyring;
+	rki->init_pid = init_pid;
 
 	info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL,
 					  umh_keys_init, umh_keys_cleanup,
-					  session_keyring);
-	if (!info)
+					  rki);
+	if (!info) {
+		kfree(rki);
 		return -ENOMEM;
+	}
 
 	key_get(session_keyring);
 	return call_usermodehelper_exec(info, flags);

