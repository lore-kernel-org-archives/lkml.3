Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757793AbaHZMFB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 08:05:01 -0400
Received: from mail4.hitachi.co.jp ([133.145.228.5]:58502 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757732AbaHZME6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 08:04:58 -0400
Subject: [RFC PATCH 1/2] libkmod: support lockup module option
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
To: Rusty Russell <rusty@rustcorp.com.au>,
        Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-modules@vger.kernel.org, Josh Poimboeuf <jpoimboe@redhat.com>
Date: Tue, 26 Aug 2014 12:04:49 +0000
Message-ID: <20140826120449.8223.6053.stgit@kbuild-fedora.novalocal>
In-Reply-To: <20140826120442.8223.80618.stgit@kbuild-fedora.novalocal>
References: <20140826120442.8223.80618.stgit@kbuild-fedora.novalocal>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add lockup option support to load an unloadable module.
Since unloadable module is not removed normally, module refcounting
is skipped. That will improve multi-core scalability on big machine.

Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---
 libkmod/libkmod-module.c |    3 +++
 libkmod/libkmod.h        |    4 +++-
 libkmod/missing.h        |    4 ++++
 3 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/libkmod/libkmod-module.c b/libkmod/libkmod-module.c
index b81b451..557e637 100644
--- a/libkmod/libkmod-module.c
+++ b/libkmod/libkmod-module.c
@@ -789,6 +789,7 @@ extern long init_module(const void *mem, unsigned long len, const char *args);
  * behavior of this function, valid flags are
  * KMOD_INSERT_FORCE_VERMAGIC: ignore kernel version magic;
  * KMOD_INSERT_FORCE_MODVERSION: ignore symbol version hashes.
+ * KMOD_INSERT_LOCKUP_MODULE: make module unloadable.
  * @options: module's options to pass to Linux Kernel.
  *
  * Insert a module in Linux kernel. It opens the file pointed by @mod,
@@ -830,6 +831,8 @@ KMOD_EXPORT int kmod_module_insert_module(struct kmod_module *mod,
 			kernel_flags |= MODULE_INIT_IGNORE_VERMAGIC;
 		if (flags & KMOD_INSERT_FORCE_MODVERSION)
 			kernel_flags |= MODULE_INIT_IGNORE_MODVERSIONS;
+		if (flags & KMOD_INSERT_LOCKUP_MODULE)
+			kernel_flags |= MODULE_INIT_LOCKUP;
 
 		err = finit_module(kmod_file_get_fd(mod->file), args, kernel_flags);
 		if (err == 0 || errno != ENOSYS)
diff --git a/libkmod/libkmod.h b/libkmod/libkmod.h
index a7ea221..69a3237 100644
--- a/libkmod/libkmod.h
+++ b/libkmod/libkmod.h
@@ -143,10 +143,11 @@ enum kmod_remove {
 	KMOD_REMOVE_NOWAIT = O_NONBLOCK, /* always set */
 };
 
-/* Insertion flags */
+/* Insertion flags: must be same as KMOD_PROBE_* */
 enum kmod_insert {
 	KMOD_INSERT_FORCE_VERMAGIC = 0x1,
 	KMOD_INSERT_FORCE_MODVERSION = 0x2,
+	KMOD_INSERT_LOCKUP_MODULE = 0x40,
 };
 
 /* Flags to kmod_module_probe_insert_module() */
@@ -157,6 +158,7 @@ enum kmod_probe {
 	KMOD_PROBE_IGNORE_LOADED =		0x00008,
 	KMOD_PROBE_DRY_RUN =			0x00010,
 	KMOD_PROBE_FAIL_ON_LOADED =		0x00020,
+	KMOD_PROBE_LOCKUP_MODULE =		0x00040,
 
 	/* codes below can be used in return value, too */
 	KMOD_PROBE_APPLY_BLACKLIST_ALL =	0x10000,
diff --git a/libkmod/missing.h b/libkmod/missing.h
index 8d47af8..c38f588 100644
--- a/libkmod/missing.h
+++ b/libkmod/missing.h
@@ -15,6 +15,10 @@
 # define MODULE_INIT_IGNORE_VERMAGIC 2
 #endif
 
+#ifndef MODULE_INIT_LOCKUP
+# define MODULE_INIT_LOCKUP 4
+#endif
+
 #ifndef __NR_finit_module
 # define __NR_finit_module -1
 #endif


