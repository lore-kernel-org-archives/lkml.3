Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208AbaGJTBu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 15:01:50 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:45104 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbaGJTBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 15:01:49 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH] drivers: tty: Merge alloc_tty_struct and initialize_tty_struct
Date: Thu, 10 Jul 2014 21:01:22 +0200
Message-Id: <1405018882-19073-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <53BEBDB7.9080302@suse.cz>
References: <53BEBDB7.9080302@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The two functions alloc_tty_struct and initialize_tty_struct are
always called together. Merge them into alloc_tty_struct, updating its
prototype and the only two callers of these functions.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/tty/pty.c    | 19 +++++++++----------
 drivers/tty/tty_io.c | 37 +++++++++++++------------------------
 include/linux/tty.h  |  4 +---
 3 files changed, 23 insertions(+), 37 deletions(-)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 25c9bc7..ac723e3 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -316,7 +316,7 @@ done:
  *	pty_common_install		-	set up the pty pair
  *	@driver: the pty driver
  *	@tty: the tty being instantiated
- *	@bool: legacy, true if this is BSD style
+ *	@legacy: true if this is BSD style
  *
  *	Perform the initial set up for the tty/pty pair. Called from the
  *	tty layer when the port is first opened.
@@ -331,18 +331,17 @@ static int pty_common_install(struct tty_driver *driver, struct tty_struct *tty,
 	int idx = tty->index;
 	int retval = -ENOMEM;
 
-	o_tty = alloc_tty_struct();
-	if (!o_tty)
-		goto err;
 	ports[0] = kmalloc(sizeof **ports, GFP_KERNEL);
 	ports[1] = kmalloc(sizeof **ports, GFP_KERNEL);
 	if (!ports[0] || !ports[1])
-		goto err_free_tty;
+		goto err;
 	if (!try_module_get(driver->other->owner)) {
 		/* This cannot in fact currently happen */
-		goto err_free_tty;
+		goto err;
 	}
-	initialize_tty_struct(o_tty, driver->other, idx);
+	o_tty = alloc_tty_struct(driver->other, idx);
+	if (!o_tty)
+		goto err_put_module;
 
 	if (legacy) {
 		/* We always use new tty termios data so we can do this
@@ -387,12 +386,12 @@ err_free_termios:
 		tty_free_termios(tty);
 err_deinit_tty:
 	deinitialize_tty_struct(o_tty);
+	free_tty_struct(o_tty);
+err_put_module:
 	module_put(o_tty->driver->owner);
-err_free_tty:
+err:
 	kfree(ports[0]);
 	kfree(ports[1]);
-	free_tty_struct(o_tty);
-err:
 	return retval;
 }
 
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 3411071..f63444d 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -157,20 +157,6 @@ static void __proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 static void proc_set_tty(struct task_struct *tsk, struct tty_struct *tty);
 
 /**
- *	alloc_tty_struct	-	allocate a tty object
- *
- *	Return a new empty tty structure. The data fields have not
- *	been initialized in any way but has been zeroed
- *
- *	Locking: none
- */
-
-struct tty_struct *alloc_tty_struct(void)
-{
-	return kzalloc(sizeof(struct tty_struct), GFP_KERNEL);
-}
-
-/**
  *	free_tty_struct		-	free a disused tty
  *	@tty: tty struct to free
  *
@@ -1455,12 +1441,11 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
 	if (!try_module_get(driver->owner))
 		return ERR_PTR(-ENODEV);
 
-	tty = alloc_tty_struct();
+	tty = alloc_tty_struct(driver, idx);
 	if (!tty) {
 		retval = -ENOMEM;
 		goto err_module_put;
 	}
-	initialize_tty_struct(tty, driver, idx);
 
 	tty_lock(tty);
 	retval = tty_driver_install_tty(driver, tty);
@@ -3003,19 +2988,21 @@ static struct device *tty_get_device(struct tty_struct *tty)
 
 
 /**
- *	initialize_tty_struct
- *	@tty: tty to initialize
+ *	alloc_tty_struct
  *
- *	This subroutine initializes a tty structure that has been newly
- *	allocated.
+ *	This subroutine allocates and initializes a tty structure.
  *
- *	Locking: none - tty in question must not be exposed at this point
+ *	Locking: none - tty in question is not exposed at this point
  */
 
-void initialize_tty_struct(struct tty_struct *tty,
-		struct tty_driver *driver, int idx)
+struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx)
 {
-	memset(tty, 0, sizeof(struct tty_struct));
+	struct tty_struct *tty;
+
+	tty = kzalloc(sizeof(*tty), GFP_KERNEL);
+	if (!tty)
+		return NULL;
+
 	kref_init(&tty->kref);
 	tty->magic = TTY_MAGIC;
 	tty_ldisc_init(tty);
@@ -3039,6 +3026,8 @@ void initialize_tty_struct(struct tty_struct *tty,
 	tty->index = idx;
 	tty_line_name(driver, idx, tty->name);
 	tty->dev = tty_get_device(tty);
+
+	return tty;
 }
 
 /**
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 1c3316a..8413294 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -477,13 +477,11 @@ extern int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 			unsigned int cmd, unsigned long arg);
 extern int tty_perform_flush(struct tty_struct *tty, unsigned long arg);
 extern void tty_default_fops(struct file_operations *fops);
-extern struct tty_struct *alloc_tty_struct(void);
+extern struct tty_struct *alloc_tty_struct(struct tty_driver *driver, int idx);
 extern int tty_alloc_file(struct file *file);
 extern void tty_add_file(struct tty_struct *tty, struct file *file);
 extern void tty_free_file(struct file *file);
 extern void free_tty_struct(struct tty_struct *tty);
-extern void initialize_tty_struct(struct tty_struct *tty,
-		struct tty_driver *driver, int idx);
 extern void deinitialize_tty_struct(struct tty_struct *tty);
 extern struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx);
 extern int tty_release(struct inode *inode, struct file *filp);
-- 
1.9.2

