Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965034Ab3DKN3p (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:29:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933462Ab3DKN3m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:29:42 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 15/26] ds1620: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, viro@ZenIV.linux.org.uk,
        Arnd Bergmann <arnd@arndb.de>
Date: Thu, 11 Apr 2013 14:29:38 +0100
Message-ID: <20130411132937.32763.34911.stgit@warthog.procyon.org.uk>
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
cc: Arnd Bergmann <arnd@arndb.de>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

 drivers/char/ds1620.c |   33 +++++++++++++++++++--------------
 1 file changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/char/ds1620.c b/drivers/char/ds1620.c
index b599fae..544b4ce 100644
--- a/drivers/char/ds1620.c
+++ b/drivers/char/ds1620.c
@@ -6,6 +6,7 @@
 #include <linux/miscdevice.h>
 #include <linux/delay.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/capability.h>
 #include <linux/init.h>
 #include <linux/mutex.h>
@@ -329,9 +330,7 @@ ds1620_unlocked_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 }
 
 #ifdef THERM_USE_PROC
-static int
-proc_therm_ds1620_read(char *buf, char **start, off_t offset,
-		       int len, int *eof, void *unused)
+static int ds1620_proc_therm_show(struct seq_file *m, void *v)
 {
 	struct therm th;
 	int temp;
@@ -339,17 +338,25 @@ proc_therm_ds1620_read(char *buf, char **start, off_t offset,
 	ds1620_read_state(&th);
 	temp =  cvt_9_to_int(ds1620_in(THERM_READ_TEMP, 9));
 
-	len = sprintf(buf, "Thermostat: HI %i.%i, LOW %i.%i; "
-		      "temperature: %i.%i C, fan %s\n",
-		      th.hi >> 1, th.hi & 1 ? 5 : 0,
-		      th.lo >> 1, th.lo & 1 ? 5 : 0,
-		      temp  >> 1, temp  & 1 ? 5 : 0,
-		      fan_state[netwinder_get_fan()]);
+	seq_printf(m, "Thermostat: HI %i.%i, LOW %i.%i; temperature: %i.%i C, fan %s\n",
+		   th.hi >> 1, th.hi & 1 ? 5 : 0,
+		   th.lo >> 1, th.lo & 1 ? 5 : 0,
+		   temp  >> 1, temp  & 1 ? 5 : 0,
+		   fan_state[netwinder_get_fan()]);
+	return 0;
+}
 
-	return len;
+static int ds1620_proc_therm_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, ds1620_proc_therm_show, NULL);
 }
 
-static struct proc_dir_entry *proc_therm_ds1620;
+static const struct file_operations ds1620_proc_therm_fops = {
+	.open		= ds1620_proc_therm_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
 #endif
 
 static const struct file_operations ds1620_fops = {
@@ -397,9 +404,7 @@ static int __init ds1620_init(void)
 		return ret;
 
 #ifdef THERM_USE_PROC
-	proc_therm_ds1620 = create_proc_read_entry("therm", 0, NULL,
-					proc_therm_ds1620_read, NULL);
-	if (!proc_therm_ds1620)
+	if (!proc_create("therm", 0, NULL, &ds1620_proc_therm_fops))
 		printk(KERN_ERR "therm: unable to register /proc/therm\n");
 #endif
 

