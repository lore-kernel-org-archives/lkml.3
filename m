Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935705Ab3DKNah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:30:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35979 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935410Ab3DKNad (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:30:33 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 20/26] parisc: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Helge Deller <deller@gmx.de>, viro@ZenIV.linux.org.uk,
        linux-parisc@vger.kernel.org,
        "James E.J. Bottomley" <jejb@parisc-linux.org>
Date: Thu, 11 Apr 2013 14:30:17 +0100
Message-ID: <20130411133017.32763.99586.stgit@warthog.procyon.org.uk>
In-Reply-To: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
References: <20130411132739.32763.82609.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't use create_proc_read_entry() as that is deprecated, but rather use
proc_create_data() and seq_file instead.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: "James E.J. Bottomley" <jejb@parisc-linux.org>
cc: Helge Deller <deller@gmx.de>
cc: linux-parisc@vger.kernel.org
---

 arch/parisc/kernel/pdc_chassis.c |   47 +++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 23 deletions(-)

diff --git a/arch/parisc/kernel/pdc_chassis.c b/arch/parisc/kernel/pdc_chassis.c
index d47ba1a..8fa314f 100644
--- a/arch/parisc/kernel/pdc_chassis.c
+++ b/arch/parisc/kernel/pdc_chassis.c
@@ -30,11 +30,13 @@
 #endif
 
 #include <linux/init.h>
+#include <linux/module.h>
 #include <linux/kernel.h>
 #include <linux/reboot.h>
 #include <linux/notifier.h>
 #include <linux/cache.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 
 #include <asm/pdc_chassis.h>
 #include <asm/processor.h>
@@ -244,38 +246,38 @@ int pdc_chassis_send_status(int message)
 
 #ifdef CONFIG_PDC_CHASSIS_WARN
 #ifdef CONFIG_PROC_FS
-static int pdc_chassis_warn_pread(char *page, char **start, off_t off,
-		int count, int *eof, void *data)
+static int pdc_chassis_warn_show(struct seq_file *m, void *v)
 {
-	char *out = page;
-	int len, ret;
 	unsigned long warn;
 	u32 warnreg;
 
-	ret = pdc_chassis_warn(&warn);
-	if (ret != PDC_OK)
+	if (pdc_chassis_warn(&warn) != PDC_OK)
 		return -EIO;
 
 	warnreg = (warn & 0xFFFFFFFF);
 
 	if ((warnreg >> 24) & 0xFF)
-		out += sprintf(out, "Chassis component failure! (eg fan or PSU): 0x%.2x\n", ((warnreg >> 24) & 0xFF));
-
-	out += sprintf(out, "Battery: %s\n", (warnreg & 0x04) ? "Low!" : "OK");
-	out += sprintf(out, "Temp low: %s\n", (warnreg & 0x02) ? "Exceeded!" : "OK");
-	out += sprintf(out, "Temp mid: %s\n", (warnreg & 0x01) ? "Exceeded!" : "OK");
-
-	len = out - page - off;
-	if (len < count) {
-		*eof = 1;
-		if (len <= 0) return 0;
-	} else {
-		len = count;
-	}
-	*start = page + off;
-	return len;
+		seq_printf(m, "Chassis component failure! (eg fan or PSU): 0x%.2x\n",
+			   (warnreg >> 24) & 0xFF);
+
+	seq_printf(m, "Battery: %s\n", (warnreg & 0x04) ? "Low!" : "OK");
+	seq_printf(m, "Temp low: %s\n", (warnreg & 0x02) ? "Exceeded!" : "OK");
+	seq_printf(m, "Temp mid: %s\n", (warnreg & 0x01) ? "Exceeded!" : "OK");
+	return 0;
+}
+
+static int pdc_chassis_warn_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pdc_chassis_warn_show, NULL);
 }
 
+static const struct file_operations pdc_chassis_warn_fops = {
+	.open		= pdc_chassis_warn_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int __init pdc_chassis_create_procfs(void)
 {
 	unsigned long test;
@@ -290,8 +292,7 @@ static int __init pdc_chassis_create_procfs(void)
 
 	printk(KERN_INFO "Enabling PDC chassis warnings support v%s\n",
 			PDC_CHASSIS_VER);
-	create_proc_read_entry("chassis", 0400, NULL, pdc_chassis_warn_pread,
-				NULL);
+	proc_create("chassis", 0400, NULL, &pdc_chassis_warn_fops);
 	return 0;
 }
 

