Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133AbaGPNbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 09:31:09 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:46042 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933826AbaGPNbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 09:31:06 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net
Subject: [PATCH v2] tty: kgdb_nmi: Automatically manage tty enable
Date: Wed, 16 Jul 2014 14:30:13 +0100
Message-Id: <1405517413-11359-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1405081811-15254-1-git-send-email-daniel.thompson@linaro.org>
References: <1405081811-15254-1-git-send-email-daniel.thompson@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At present it is not possible to boot with the ttyNMI0 console treating
character input normally, instead character input triggers a prompt
telling the user how to trigger the knock detector and enter the
debugger. To use the console normally requires that kdb be entered and
the nmi_console command be used to enable the console (or if only kgdb
is present then gdb must directly manipulate the value of
kgdb_nmi_tty_enabled).

This patch automates the management of kgdb_nmi_tty_enabled by keeping
track of the number of file handles that are open for reading and using
that to determine how to tty should operate.

The approach means that:

1. Behaviour before init starts is unchanged.

2. If the userspace runs a getty or some other interactive process on
   /dev/console (or explicitly on /dev/ttyNMI0) the tty will treat
   character input like any other tty.

3. If the userspace doesn't use /dev/console or if it uses /dev/console
   only to log messages (O_WRONLY) then the user prompt is retained.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: linux-serial@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>
Cc: kgdb-bugreport@lists.sourceforge.net
---
 drivers/tty/serial/kgdb_nmi.c | 36 +++++++++++++++---------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/tty/serial/kgdb_nmi.c b/drivers/tty/serial/kgdb_nmi.c
index cfadf29..6ec7501 100644
--- a/drivers/tty/serial/kgdb_nmi.c
+++ b/drivers/tty/serial/kgdb_nmi.c
@@ -42,7 +42,7 @@ static char *kgdb_nmi_magic = "$3#33";
 module_param_named(magic, kgdb_nmi_magic, charp, 0600);
 MODULE_PARM_DESC(magic, "magic sequence to enter NMI debugger (default $3#33)");
 
-static bool kgdb_nmi_tty_enabled;
+static atomic_t kgdb_nmi_num_readers = ATOMIC_INIT(0);
 
 static int kgdb_nmi_console_setup(struct console *co, char *options)
 {
@@ -136,7 +136,7 @@ static int kgdb_nmi_poll_one_knock(void)
 		n = 0;
 	}
 
-	if (kgdb_nmi_tty_enabled) {
+	if (atomic_read(&kgdb_nmi_num_readers)) {
 		kgdb_tty_recv(c);
 		return 0;
 	}
@@ -197,7 +197,8 @@ static void kgdb_nmi_tty_receiver(unsigned long data)
 	priv->timer.expires = jiffies + (HZ/100);
 	add_timer(&priv->timer);
 
-	if (likely(!kgdb_nmi_tty_enabled || !kfifo_len(&priv->fifo)))
+	if (likely(!atomic_read(&kgdb_nmi_num_readers) ||
+		   !kfifo_len(&priv->fifo)))
 		return;
 
 	while (kfifo_out(&priv->fifo, &ch, 1))
@@ -270,13 +271,23 @@ static void kgdb_nmi_tty_cleanup(struct tty_struct *tty)
 static int kgdb_nmi_tty_open(struct tty_struct *tty, struct file *file)
 {
 	struct kgdb_nmi_tty_priv *priv = tty->driver_data;
+	unsigned int mode = file->f_flags & O_ACCMODE;
+	int ret;
+
+	ret = tty_port_open(&priv->port, tty, file);
+	if (!ret && (mode == O_RDONLY || mode == O_RDWR))
+		atomic_inc(&kgdb_nmi_num_readers);
 
-	return tty_port_open(&priv->port, tty, file);
+	return ret;
 }
 
 static void kgdb_nmi_tty_close(struct tty_struct *tty, struct file *file)
 {
 	struct kgdb_nmi_tty_priv *priv = tty->driver_data;
+	unsigned int mode = file->f_flags & O_ACCMODE;
+
+	if (mode == O_RDONLY || mode == O_RDWR)
+		atomic_dec(&kgdb_nmi_num_readers);
 
 	tty_port_close(&priv->port, tty, file);
 }
@@ -313,12 +324,6 @@ static const struct tty_operations kgdb_nmi_tty_ops = {
 	.write		= kgdb_nmi_tty_write,
 };
 
-static int kgdb_nmi_enable_console(int argc, const char *argv[])
-{
-	kgdb_nmi_tty_enabled = !(argc == 1 && !strcmp(argv[1], "off"));
-	return 0;
-}
-
 int kgdb_register_nmi_console(void)
 {
 	int ret;
@@ -348,19 +353,10 @@ int kgdb_register_nmi_console(void)
 		goto err_drv_reg;
 	}
 
-	ret = kdb_register("nmi_console", kgdb_nmi_enable_console, "[off]",
-			   "switch to Linux NMI console", 0);
-	if (ret) {
-		pr_err("%s: can't register kdb command: %d\n", __func__, ret);
-		goto err_kdb_reg;
-	}
-
 	register_console(&kgdb_nmi_console);
 	arch_kgdb_ops.enable_nmi(1);
 
 	return 0;
-err_kdb_reg:
-	tty_unregister_driver(kgdb_nmi_tty_driver);
 err_drv_reg:
 	put_tty_driver(kgdb_nmi_tty_driver);
 	return ret;
@@ -375,8 +371,6 @@ int kgdb_unregister_nmi_console(void)
 		return 0;
 	arch_kgdb_ops.enable_nmi(0);
 
-	kdb_unregister("nmi_console");
-
 	ret = unregister_console(&kgdb_nmi_console);
 	if (ret)
 		return ret;
-- 
1.9.3

