Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaIOOpn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 10:45:43 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:34702 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaIOOpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 10:45:39 -0400
From: Roman Pen <r.peniaev@gmail.com>
Cc: Roman Pen <r.peniaev@gmail.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/1] init: fix race between rootfs mount and firmware loading
Date: Mon, 15 Sep 2014 23:45:08 +0900
Message-Id: <1410792308-21577-1-git-send-email-r.peniaev@gmail.com>
X-Mailer: git-send-email 2.0.0
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The thing is that built-in modules are being inited before
rootfs mount.  Some of the modules can request firmware loading
from another thread using async 'request_firmware_nowait' call
on inition, so we can catch this kind of race:
   rootfs does not exist yet, but we are going to open and load
   firmware file requesting it from the kernel thread.

Solution is simple: before any rootfs access firmware loader
must wait for rootfs mount.

There are few questions which remain unanswered, but in this
patch I do not want to complicate things and want to fix exactly
the race.  So here are the questions:

1. can 'request_firmware' (sync variant) be called on module inition
   directly, without any threads? if can, that means firmware will
   never be loaded for the driver at first try in case of built-in
   module, because rootfs will be mounted only at the end of kernel
   init sequence.

2. in case of separated '/lib' mount point we still have the problem:
   firmware will be loaded only on further tries, but the first attempt
   will always fail, because '/lib' mount point does not exist.  Seems
   to me this can't be simply fixed, and firmware_request logic needs
   some refactoring.

Probably, there are other good questions which I do not see because
of shallow understanding of init and firmware loading sequences.

Signed-off-by: Roman Pen <r.peniaev@gmail.com>
Cc: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org
---
 drivers/base/firmware_class.c |  6 ++++++
 include/linux/init.h          |  1 +
 init/main.c                   | 22 ++++++++++++++++++++--
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
index bf42430..450c4ae 100644
--- a/drivers/base/firmware_class.c
+++ b/drivers/base/firmware_class.c
@@ -29,6 +29,7 @@
 #include <linux/syscore_ops.h>
 #include <linux/reboot.h>
 #include <linux/security.h>
+#include <linux/init.h>
 
 #include <generated/utsrelease.h>
 
@@ -324,6 +325,11 @@ static int fw_get_filesystem_firmware(struct device *device,
 	int rc = -ENOENT;
 	char *path = __getname();
 
+	/* Before any file access we have to wait for rootfs.
+	   In case of built-in module we can race with kernel init
+	   thread, which has not mounted rootfs yet */
+	wait_for_rootfs();
+
 	for (i = 0; i < ARRAY_SIZE(fw_path); i++) {
 		struct file *file;
 
diff --git a/include/linux/init.h b/include/linux/init.h
index 2df8e8d..83233ae 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -152,6 +152,7 @@ void setup_arch(char **);
 void prepare_namespace(void);
 void __init load_default_modules(void);
 int __init init_rootfs(void);
+void wait_for_rootfs(void);
 
 extern void (*late_time_init)(void);
 
diff --git a/init/main.c b/init/main.c
index bb1aed9..15e1bb1 100644
--- a/init/main.c
+++ b/init/main.c
@@ -973,6 +973,22 @@ static int __ref kernel_init(void *unused)
 	      "See Linux Documentation/init.txt for guidance.");
 }
 
+static DECLARE_COMPLETION(rootfs_mounted);
+
+void wait_for_rootfs(void)
+{
+	/* Avoid waiting for ourselves */
+	if (is_global_init(current))
+		pr_warn("it is not a good idea to wait for rootfs mount from init task\n");
+	else
+		wait_for_completion(&rootfs_mounted);
+}
+
+static inline void wake_up_rootfs_waiters(void)
+{
+	complete(&rootfs_mounted);
+}
+
 static noinline void __init kernel_init_freeable(void)
 {
 	/*
@@ -1025,9 +1041,11 @@ static noinline void __init kernel_init_freeable(void)
 
 	/*
 	 * Ok, we have completed the initial bootup, and
-	 * we're essentially up and running. Get rid of the
-	 * initmem segments and start the user-mode stuff..
+	 * we're essentially up and running.  Wake up rootfs
+	 * mount waiters, get rid of the initmem segments,
+	 * and start the user-mode stuff..
 	 */
+	wake_up_rootfs_waiters();
 
 	/* rootfs is available now, try loading default modules */
 	load_default_modules();
-- 
2.0.0

