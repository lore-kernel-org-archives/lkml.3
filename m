Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932109AbaDBMpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 08:45:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38158 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932065AbaDBMpY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 08:45:24 -0400
From: Takashi Iwai <tiwai@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Struan Bartlett <struan.bartlett@gmail.com>,
        Andreas Schwab <schwab@linux-m68k.org>,
        Jean Delvare <jdelvare@suse.de>, gnomes@lxorguk.ukuu.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 2/2] ttyprintk: Allow built as a module
Date: Wed,  2 Apr 2014 14:45:22 +0200
Message-Id: <1396442722-26346-2-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1396442722-26346-1-git-send-email-tiwai@suse.de>
References: <1396442722-26346-1-git-send-email-tiwai@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The driver is well written to be used as a module, just the exit call
is missing.

Reviewed-by: Jean Delvare <jdelvare@suse.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
---
v1->v2: add missing __exit, add review tag

 drivers/char/Kconfig     |  2 +-
 drivers/char/ttyprintk.c | 13 ++++++++++++-
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
index 1386749b48ff..97816b133c7f 100644
--- a/drivers/char/Kconfig
+++ b/drivers/char/Kconfig
@@ -40,7 +40,7 @@ config SGI_MBCS
 source "drivers/tty/serial/Kconfig"
 
 config TTY_PRINTK
-	bool "TTY driver to output user messages via printk"
+	tristate "TTY driver to output user messages via printk"
 	depends on EXPERT && TTY
 	default n
 	---help---
diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index 2a39c5790364..73606eaaba71 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -17,7 +17,7 @@
 #include <linux/device.h>
 #include <linux/serial.h>
 #include <linux/tty.h>
-#include <linux/export.h>
+#include <linux/module.h>
 
 struct ttyprintk_port {
 	struct tty_port port;
@@ -214,4 +214,15 @@ error:
 	tty_port_destroy(&tpk_port.port);
 	return ret;
 }
+
+static void __exit ttyprintk_exit(void)
+{
+	tty_unregister_driver(ttyprintk_driver);
+	put_tty_driver(ttyprintk_driver);
+	tty_port_destroy(&tpk_port.port);
+}
+
 device_initcall(ttyprintk_init);
+module_exit(ttyprintk_exit);
+
+MODULE_LICENSE("GPL");
-- 
1.9.1

