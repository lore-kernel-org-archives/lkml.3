Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758047Ab3BEWPd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:15:33 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48267 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3BEWND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:13:03 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 86/93] module: wait when loading a module which is currently initializing.
Date: Tue,  5 Feb 2013 20:07:15 -0200
Message-Id: <1360102042-10732-87-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rusty Russell <rusty@rustcorp.com.au>

commit 9bb9c3be56834653878f766f471fa1c20e562f4c upstream.

The original module-init-tools module loader used a fnctl lock on the
.ko file to avoid attempts to simultaneously load a module.
Unfortunately, you can't get an exclusive fcntl lock on a read-only
fd, making this not work for read-only mounted filesystems.
module-init-tools has a hacky sleep-and-loop for this now.

It's not that hard to wait in the kernel, and only return -EEXIST once
the first module has finished loading (or continue loading the module
if the first one failed to initialize for some reason).  It's also
consistent with what we do for dependent modules which are still loading.

Suggested-by: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 kernel/module.c |   28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 27e302a..8dd60f4 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -2870,6 +2870,20 @@ static int post_relocation(struct module *mod, const struct load_info *info)
 	return module_finalize(info->hdr, info->sechdrs, mod);
 }
 
+/* Is this module of this name done loading?  No locks held. */
+static bool finished_loading(const char *name)
+{
+	struct module *mod;
+	bool ret;
+
+	mutex_lock(&module_mutex);
+	mod = find_module(name);
+	ret = !mod || mod->state != MODULE_STATE_COMING;
+	mutex_unlock(&module_mutex);
+
+	return ret;
+}
+
 /* Allocate and load the module: note that size of section 0 is always
    zero, and we rely on this for optional sections. */
 static struct module *load_module(void __user *umod,
@@ -2877,7 +2891,7 @@ static struct module *load_module(void __user *umod,
 				  const char __user *uargs)
 {
 	struct load_info info = { NULL, };
-	struct module *mod;
+	struct module *mod, *old;
 	long err;
 
 	pr_debug("load_module: umod=%p, len=%lu, uargs=%p\n",
@@ -2943,8 +2957,18 @@ static struct module *load_module(void __user *umod,
 	 * function to insert in a way safe to concurrent readers.
 	 * The mutex protects against concurrent writers.
 	 */
+again:
 	mutex_lock(&module_mutex);
-	if (find_module(mod->name)) {
+	if ((old = find_module(mod->name)) != NULL) {
+		if (old->state == MODULE_STATE_COMING) {
+			/* Wait in case it fails to load. */
+			mutex_unlock(&module_mutex);
+			err = wait_event_interruptible(module_wq,
+					       finished_loading(mod->name));
+			if (err)
+				goto free_arch_cleanup;
+			goto again;
+		}
 		err = -EEXIST;
 		goto unlock;
 	}
-- 
1.7.9.5

