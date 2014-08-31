Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751316AbaHaJDy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 05:03:54 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:55868 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaHaJDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 05:03:41 -0400
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
To: gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com, falcon@meizu.com,
        tiwai@suse.de, tj@kernel.org, arjan@linux.intel.com
Cc: linux-kernel@vger.kernel.org, oleg@redhat.com, akpm@linux-foundation.org,
        penguin-kernel@i-love.sakura.ne.jp, joseph.salisbury@canonical.com,
        bpoirier@suse.de, "Luis R. Rodriguez" <mcgrof@suse.com>
Subject: [RFC v1 1/3] driver-core: split module_init() and module_exit()
Date: Sun, 31 Aug 2014 02:03:18 -0700
Message-Id: <1409475800-17573-2-git-send-email-mcgrof@do-not-panic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
References: <1409475800-17573-1-git-send-email-mcgrof@do-not-panic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Luis R. Rodriguez" <mcgrof@suse.com>

module_init() currently is the default caller used
for all other types of *_init() calls for modules.
If we want to do something a bit different for
init groups though we are implicating that onto
the other ones. Lets instead use a generic drv_init()
which maps to what module_init() used to be. For
now module_init() will also map to drv_init() but
the idea is that we'll change this eventually.

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Signed-off-by: Luis R. Rodriguez <mcgrof@suse.com>
---
 include/linux/init.h | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 2df8e8d..3b69b1a 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -304,37 +304,40 @@ void __init parse_early_options(char *cmdline);
  * matter when built as a loadable module. Like bus
  * snooping debug drivers.
  */
-#define early_initcall(fn)		module_init(fn)
-#define core_initcall(fn)		module_init(fn)
-#define core_initcall_sync(fn)		module_init(fn)
-#define postcore_initcall(fn)		module_init(fn)
-#define postcore_initcall_sync(fn)	module_init(fn)
-#define arch_initcall(fn)		module_init(fn)
-#define subsys_initcall(fn)		module_init(fn)
-#define subsys_initcall_sync(fn)	module_init(fn)
-#define fs_initcall(fn)			module_init(fn)
-#define fs_initcall_sync(fn)		module_init(fn)
-#define rootfs_initcall(fn)		module_init(fn)
-#define device_initcall(fn)		module_init(fn)
-#define device_initcall_sync(fn)	module_init(fn)
-#define late_initcall(fn)		module_init(fn)
-#define late_initcall_sync(fn)		module_init(fn)
-
-#define console_initcall(fn)		module_init(fn)
-#define security_initcall(fn)		module_init(fn)
+#define early_initcall(fn)		drv_init(fn)
+#define core_initcall(fn)		drv_init(fn)
+#define core_initcall_sync(fn)		drv_init(fn)
+#define postcore_initcall(fn)		drv_init(fn)
+#define postcore_initcall_sync(fn)	drv_init(fn)
+#define arch_initcall(fn)		drv_init(fn)
+#define subsys_initcall(fn)		drv_init(fn)
+#define subsys_initcall_sync(fn)	drv_init(fn)
+#define fs_initcall(fn)			drv_init(fn)
+#define fs_initcall_sync(fn)		drv_init(fn)
+#define rootfs_initcall(fn)		drv_init(fn)
+#define device_initcall(fn)		drv_init(fn)
+#define device_initcall_sync(fn)	drv_init(fn)
+#define late_initcall(fn)		drv_init(fn)
+#define late_initcall_sync(fn)		drv_init(fn)
+
+#define console_initcall(fn)		drv_init(fn)
+#define security_initcall(fn)		drv_init(fn)
 
 /* Each module must use one module_init(). */
-#define module_init(initfn)					\
+#define drv_init(initfn)					\
 	static inline initcall_t __inittest(void)		\
 	{ return initfn; }					\
 	int init_module(void) __attribute__((alias(#initfn)));
 
 /* This is only required if you want to be unloadable. */
-#define module_exit(exitfn)					\
+#define drv_exit(exitfn)					\
 	static inline exitcall_t __exittest(void)		\
 	{ return exitfn; }					\
 	void cleanup_module(void) __attribute__((alias(#exitfn)));
 
+#define module_init(initfn)	drv_init(initfn);
+#define module_exit(exitfn)	drv_exit(exitfn);
+
 #define __setup_param(str, unique_id, fn)	/* nothing */
 #define __setup(str, func) 			/* nothing */
 #endif
-- 
2.0.3

