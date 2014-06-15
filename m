Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274AbaFOLHL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 07:07:11 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:47260 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbaFOLHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 07:07:07 -0400
From: Roman Pen <r.peniaev@gmail.com>
Cc: Roman Pen <r.peniaev@gmail.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Rob Landley <rob@landley.net>, Randy Dunlap <rdunlap@infradead.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Krzysztof Mazur <krzysiek@podlesie.net>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 1/1] init: fix race between rootfs mount and firmware loading
Date: Sun, 15 Jun 2014 20:06:53 +0900
Message-Id: <1402830413-4009-1-git-send-email-r.peniaev@gmail.com>
X-Mailer: git-send-email 1.9.1
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thing is that built-in modules are being inited before
rootfs mount. Some of the modules can request firmware loading
using async 'request_firmware_nowait' call just while inition,
so we can catch this kind of race: rootfs does not exist yet,
but we are going to open and load firmware file requesting from
the kernel.

This is RFC because I do not feel confident about the convention
of firmware loading. The questions are:

1. can 'request_firmware' (sync variant) be called on module inition
   directly, without any threads? if can, that means firmware will
   never be loaded for the driver at first try in case of built-in
   module, because rootfs will be mounted only at the end of kernel
   init sequence.

2. in case of separated '/lib' mount point we still have the problem:
   firmware will be loaded only on further tries, but the first attempt
   will always fail, because '/lib' mount point does not exist. Seems
   to me this can't be simply fixed, and firmware_request logic needs
   some refactoring..

Probably, there are other good questions which I do not see because
of shallow understanding of init and firmware loading sequences.

Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Rob Landley <rob@landley.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Cc: Krzysztof Mazur <krzysiek@podlesie.net>
Cc: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Roman Pen <r.peniaev@gmail.com>
---
 drivers/base/firmware_class.c |  6 ++++++
 include/linux/init.h          |  4 ++++
 init/main.c                   | 20 +++++++++++++++++++-
 3 files changed, 29 insertions(+), 1 deletion(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index c30df50e..219ac84 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -28,6 +28,7 @@
 #include <linux/suspend.h>
 #include <linux/syscore_ops.h>
 #include <linux/reboot.h>
+#include <linux/init.h>
 
 #include <generated/utsrelease.h>
 
@@ -323,6 +324,11 @@ static int fw_get_filesystem_firmware(struct device *device,
 	int rc = -ENOENT;
 	char *path = __getname();
 
+	/* Before any file access we have to wait for rootfs.
+	   In case of built-in module we can race with kernel init
+	   thread, which mounts rootfs, and driver firmware loading */
+	wait_for_rootfs();
+
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
 		struct file *file;
 
diff --git a/include/linux/init.h b/include/linux/init.h
index e168880..36e7b14 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -153,6 +153,10 @@ void prepare_namespace(void);
 void __init load_default_modules(void);
 int __init init_rootfs(void);
 
+/* Defined in init/main.c */
+void wait_for_rootfs(void);
+void wake_up_rootfs_waiters(void);
+
 extern void (*late_time_init)(void);
 
 extern bool initcall_debug;
diff --git a/init/main.c b/init/main.c
index 9c7fd4c..cc96498 100644
--- a/init/main.c
+++ b/init/main.c
@@ -931,9 +931,27 @@ static noinline void __init kernel_init_freeable(void)
 	/*
 	 * Ok, we have completed the initial bootup, and
 	 * we're essentially up and running. Get rid of the
-	 * initmem segments and start the user-mode stuff..
+	 * initmem segments, wake up rootfs mount waiters
+	 * and start the user-mode stuff..
 	 */
+	wake_up_rootfs_waiters();
 
 	/* rootfs is available now, try loading default modules */
 	load_default_modules();
 }
+
+static DECLARE_COMPLETION(rootfs_mounted);
+
+void wait_for_rootfs(void)
+{
+	/* Avoid waiting for ourselves */
+	if (is_global_init(current))
+		pr_warn("kernel_init: it is not a good idea to wait for rootfs mount from init task\n");
+	else
+		wait_for_completion(&rootfs_mounted);
+}
+
+void wake_up_rootfs_waiters(void)
+{
+	complete(&rootfs_mounted);
+}
-- 
1.9.1

