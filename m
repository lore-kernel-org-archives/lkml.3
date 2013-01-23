Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab3AWAxb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 19:53:31 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:57464 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3AWAx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 19:53:26 -0500
Date: Tue, 22 Jan 2013 16:53:21 -0800
From: Tejun Heo <tj@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Ming Lei <ming.lei@canonical.com>, Alex Riesen <raa.lkml@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <axboe@kernel.dk>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Fengguang We <fengguang.wu@intel.com>
Subject: [PATCH v2 1/2] init, block: try to load default elevator module
 early during boot
Message-ID: <20130123005321.GE5359@htj.dyndns.org>
References: <CA+55aFzm4k2CyQ_mZVHyeasjw4ybqfO2SpJrZZNZeUsSW8PB=g@mail.gmail.com>
 <CA+55aFxLJ=Yfms9SkPJLjQ-ZASPNZC0JUBsb3OwonJvTCcBzxA@mail.gmail.com>
 <20130116025251.GM2668@htj.dyndns.org>
 <CA+55aFxttTkWG0gfUz3=V8A-9az3+qY3j0JZEAoKv0ne-QupZw@mail.gmail.com>
 <20130116032502.GN2668@htj.dyndns.org>
 <CA+55aFxCudzOv8e2XjHiT=Qhy9q+mrxUfSYAT=eU6Gq8uyNORw@mail.gmail.com>
 <20130116164832.GP2668@htj.dyndns.org>
 <50F6DD4D.3070808@linux.intel.com>
 <CA+55aFyjrXzKMqmOuMo9z24OZj3kD4O4M4y_O-h=r6udCz2MyA@mail.gmail.com>
 <20130116213032.GS2668@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130116213032.GS2668@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From bb813f4c933ae9f887a014483690d5f8b8ec05e1 Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Fri, 18 Jan 2013 14:05:56 -0800

This patch adds default module loading and uses it to load the default
block elevator.  During boot, it's called right after initramfs or
initrd is made available and right before control is passed to
userland.  This ensures that as long as the modules are available in
the usual places in initramfs, initrd or the root filesystem, the
default modules are loaded as soon as possible.

This will replace the on-demand elevator module loading from elevator
init path.

v2: Fixed build breakage when !CONFIG_BLOCK.  Reported by kbuild test
    robot.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alex Riesen <raa.lkml@gmail.com>
Cc: Fengguang We <fengguang.wu@intel.com>
---
Minor revision to fix build breakage on !CONFIG_BLOCK reported by
Fengguang.  The patch is queued to wq/for-3.9-async-deadlock-fixes.

Thanks.

 block/elevator.c         | 16 ++++++++++++++++
 include/linux/elevator.h |  5 +++++
 include/linux/init.h     |  1 +
 init/do_mounts_initrd.c  |  3 +++
 init/initramfs.c         |  8 +++++++-
 init/main.c              | 16 ++++++++++++++++
 6 files changed, 48 insertions(+), 1 deletion(-)

diff --git a/block/elevator.c b/block/elevator.c
index 9edba1b..c2d61d5 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -136,6 +136,22 @@ static int __init elevator_setup(char *str)
 
 __setup("elevator=", elevator_setup);
 
+/* called during boot to load the elevator chosen by the elevator param */
+void __init load_default_elevator_module(void)
+{
+	struct elevator_type *e;
+
+	if (!chosen_elevator[0])
+		return;
+
+	spin_lock(&elv_list_lock);
+	e = elevator_find(chosen_elevator);
+	spin_unlock(&elv_list_lock);
+
+	if (!e)
+		request_module("%s-iosched", chosen_elevator);
+}
+
 static struct kobj_type elv_ktype;
 
 static struct elevator_queue *elevator_alloc(struct request_queue *q,
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index c03af76..1866206 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -138,6 +138,7 @@ extern void elv_drain_elevator(struct request_queue *);
 /*
  * io scheduler registration
  */
+extern void __init load_default_elevator_module(void);
 extern int elv_register(struct elevator_type *);
 extern void elv_unregister(struct elevator_type *);
 
@@ -206,5 +207,9 @@ enum {
 	INIT_LIST_HEAD(&(rq)->csd.list);	\
 	} while (0)
 
+#else /* CONFIG_BLOCK */
+
+static inline void load_default_elevator_module(void) { }
+
 #endif /* CONFIG_BLOCK */
 #endif
diff --git a/include/linux/init.h b/include/linux/init.h
index a799273..9230c94 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -161,6 +161,7 @@ extern unsigned int reset_devices;
 /* used by init/main.c */
 void setup_arch(char **);
 void prepare_namespace(void);
+void __init load_default_modules(void);
 
 extern void (*late_time_init)(void);
 
diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 5e4ded5..dfe606a 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -57,6 +57,9 @@ static void __init handle_initrd(void)
 	sys_mkdir("/old", 0700);
 	sys_chdir("/old");
 
+	/* try loading default modules from initrd */
+	load_default_modules();
+
 	/*
 	 * In case that a resume from disk is carried out by linuxrc or one of
 	 * its children, we need to tell the freezer not to wait for us.
diff --git a/init/initramfs.c b/init/initramfs.c
index 84c6bf1..a67ef9d 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -592,7 +592,7 @@ static int __init populate_rootfs(void)
 			initrd_end - initrd_start);
 		if (!err) {
 			free_initrd();
-			return 0;
+			goto done;
 		} else {
 			clean_rootfs();
 			unpack_to_rootfs(__initramfs_start, __initramfs_size);
@@ -607,6 +607,7 @@ static int __init populate_rootfs(void)
 			sys_close(fd);
 			free_initrd();
 		}
+	done:
 #else
 		printk(KERN_INFO "Unpacking initramfs...\n");
 		err = unpack_to_rootfs((char *)initrd_start,
@@ -615,6 +616,11 @@ static int __init populate_rootfs(void)
 			printk(KERN_EMERG "Initramfs unpacking failed: %s\n", err);
 		free_initrd();
 #endif
+		/*
+		 * Try loading default modules from initramfs.  This gives
+		 * us a chance to load before device_initcalls.
+		 */
+		load_default_modules();
 	}
 	return 0;
 }
diff --git a/init/main.c b/init/main.c
index baf1f0f..18efadb 100644
--- a/init/main.c
+++ b/init/main.c
@@ -70,6 +70,8 @@
 #include <linux/perf_event.h>
 #include <linux/file.h>
 #include <linux/ptrace.h>
+#include <linux/blkdev.h>
+#include <linux/elevator.h>
 
 #include <asm/io.h>
 #include <asm/bugs.h>
@@ -794,6 +796,17 @@ static void __init do_pre_smp_initcalls(void)
 		do_one_initcall(*fn);
 }
 
+/*
+ * This function requests modules which should be loaded by default and is
+ * called twice right after initrd is mounted and right before init is
+ * exec'd.  If such modules are on either initrd or rootfs, they will be
+ * loaded before control is passed to userland.
+ */
+void __init load_default_modules(void)
+{
+	load_default_elevator_module();
+}
+
 static int run_init_process(const char *init_filename)
 {
 	argv_init[0] = init_filename;
@@ -898,4 +911,7 @@ static void __init kernel_init_freeable(void)
 	 * we're essentially up and running. Get rid of the
 	 * initmem segments and start the user-mode stuff..
 	 */
+
+	/* rootfs is available now, try loading default modules */
+	load_default_modules();
 }
-- 
1.8.1

