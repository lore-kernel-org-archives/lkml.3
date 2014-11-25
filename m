Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751808AbaKYBHx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 20:07:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34797 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751AbaKYBHw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 20:07:52 -0500
Subject: [RFC PATCH 4/4] KEYS: exec request-key within the requesting task's
 namespace
From: Ian Kent <ikent@redhat.com>
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: "J. Bruce Fields" <bfields@fieldses.org>,
        Oleg Nesterov <onestero@redhat.com>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        David Howells <dhowells@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Date: Tue, 25 Nov 2014 09:07:42 +0800
Message-ID: <20141125010741.4974.7022.stgit@pluto.fritz.box>
In-Reply-To: <20141125005255.4974.54193.stgit@pluto.fritz.box>
References: <20141125005255.4974.54193.stgit@pluto.fritz.box>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

Copy the current task's namespaces into the request-key userspace helper to
restrict contained processes from executing key instantiation processes
outside their containers.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Signed-off-by: Ian Kent <ikent@redhat.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
Cc: J. Bruce Fields <bfields@fieldses.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Trond Myklebust <trond.myklebust@primarydata.com>
Cc: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: Oleg Nesterov <onestero@redhat.com>
Cc: Eric W. Biederman <ebiederm@xmission.com>
---
 security/keys/request_key.c |   45 +++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/security/keys/request_key.c b/security/keys/request_key.c
index bb4337c..b03feec 100644
--- a/security/keys/request_key.c
+++ b/security/keys/request_key.c
@@ -17,6 +17,8 @@
 #include <linux/err.h>
 #include <linux/keyctl.h>
 #include <linux/slab.h>
+#include <linux/nsproxy.h>
+#include <linux/mount.h>
 #include "internal.h"
 
 #define key_negative_timeout	60	/* default timeout on a negative key's existence */
@@ -46,6 +48,11 @@ void complete_request_key(struct key_construction *cons, int error)
 }
 EXPORT_SYMBOL(complete_request_key);
 
+struct request_key_info {
+	struct key	*keyring;
+	struct nsproxy	*nsproxy;
+};
+
 /*
  * Initialise a usermode helper that is going to have a specific session
  * keyring.
@@ -55,9 +62,14 @@ EXPORT_SYMBOL(complete_request_key);
  */
 static int umh_keys_init(struct subprocess_info *info, struct cred *cred)
 {
-	struct key *keyring = info->data;
+	struct request_key_info *rki = info->data;
+	struct nsproxy *ns = rki->nsproxy;
 
-	return install_session_keyring_to_cred(cred, keyring);
+	if (ns) {
+		mntns_setfs(ns->mnt_ns);
+		switch_task_namespaces(current, ns);
+	}
+	return install_session_keyring_to_cred(cred, rki->keyring);
 }
 
 /*
@@ -65,8 +77,9 @@ static int umh_keys_init(struct subprocess_info *info, struct cred *cred)
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
@@ -76,12 +89,32 @@ static int call_usermodehelper_keys(char *path, char **argv, char **envp,
 					struct key *session_keyring, int wait)
 {
 	struct subprocess_info *info;
+	struct request_key_info *rki;
+	struct nsproxy *ns;
+
+	ns = umh_open_ns();
+	if (ns && IS_ERR(ns))
+		return PTR_ERR(ns);
+
+	rki = kmalloc(sizeof(*rki), GFP_KERNEL);
+	if (!rki) {
+		if (ns)
+			free_nsproxy(ns);
+		return -ENOMEM;
+	}
+
+	rki->keyring = session_keyring;
+	rki->nsproxy = ns;
 
 	info = call_usermodehelper_setup(path, argv, envp, GFP_KERNEL,
 					  umh_keys_init, umh_keys_cleanup,
-					  session_keyring);
-	if (!info)
+					  rki);
+	if (!info) {
+		if (ns)
+			free_nsproxy(ns);
+		kfree(rki);
 		return -ENOMEM;
+	}
 
 	key_get(session_keyring);
 	return call_usermodehelper_exec(info, wait);

