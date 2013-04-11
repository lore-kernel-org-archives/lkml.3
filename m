Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161506Ab3DKNay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:30:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37090 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752188Ab3DKNaw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:30:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 23/26] h8300: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: viro@ZenIV.linux.org.uk, Yoshinori Sato <ysato@users.sourceforge.jp>
Date: Thu, 11 Apr 2013 14:30:40 +0100
Message-ID: <20130411133040.32763.99015.stgit@warthog.procyon.org.uk>
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
cc: Yoshinori Sato <ysato@users.sourceforge.jp>
---

 arch/h8300/kernel/gpio.c |   34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/arch/h8300/kernel/gpio.c b/arch/h8300/kernel/gpio.c
index f8a4f5b..b02c752 100644
--- a/arch/h8300/kernel/gpio.c
+++ b/arch/h8300/kernel/gpio.c
@@ -11,6 +11,7 @@
 
 #include <linux/stddef.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/kernel.h>
 #include <linux/string.h>
 #include <linux/fs.h>
@@ -138,29 +139,34 @@ static char *port_status(int portno)
 	return result;
 }
 
-static int gpio_proc_read(char *buf, char **start, off_t offset, 
-                          int len, int *unused_i, void *unused_v)
+static int gpio_proc_show(struct seq_file *m, void *v)
 {
-	int c,outlen;
 	static const char port_name[]="123456789ABCDEFGH";
-	outlen = 0;
+	int c;
+
 	for (c = 0; c < MAX_PORT; c++) {
 		if (ddrs[c] == NULL)
-			continue ;
-		len = sprintf(buf,"P%c: %s\n",port_name[c],port_status(c));
-		buf += len;
-		outlen += len;
+			continue;
+		seq_printf(m, "P%c: %s\n", port_name[c], port_status(c));
 	}
-	return outlen;
+	return 0;
 }
 
-static __init int register_proc(void)
+static int gpio_proc_open(struct inode *inode, struct file *file)
 {
-	struct proc_dir_entry *proc_gpio;
+	return single_open(file, gpio_proc_show, PDE_DATA(inode));
+}
 
-	proc_gpio = create_proc_read_entry("gpio", S_IRUGO, NULL,
-					gpio_proc_read, NULL);
-	return proc_gpio != NULL;
+static const struct file_operations gpio_proc_fops = {
+	.open		= gpio_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
+static __init int register_proc(void)
+{
+	return proc_create("gpio", S_IRUGO, NULL, &gpio_proc_fops) != NULL;
 }
 
 __initcall(register_proc);

