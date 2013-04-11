Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935591Ab3DKN3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:29:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36934 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933462Ab3DKN3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:29:38 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 14/26] efirtc: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, viro@ZenIV.linux.org.uk,
        Arnd Bergmann <arnd@arndb.de>
Date: Thu, 11 Apr 2013 14:29:30 +0100
Message-ID: <20130411132930.32763.7735.stgit@warthog.procyon.org.uk>
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

 drivers/char/efirtc.c |   83 ++++++++++++++++++++++++-------------------------
 1 file changed, 40 insertions(+), 43 deletions(-)

diff --git a/drivers/char/efirtc.c b/drivers/char/efirtc.c
index a082d00..ea54a6e 100644
--- a/drivers/char/efirtc.c
+++ b/drivers/char/efirtc.c
@@ -34,6 +34,7 @@
 #include <linux/init.h>
 #include <linux/rtc.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/efi.h>
 #include <linux/uaccess.h>
 
@@ -296,12 +297,10 @@ static struct miscdevice efi_rtc_dev= {
 /*
  *	We export RAW EFI information to /proc/driver/efirtc
  */
-static int
-efi_rtc_get_status(char *buf)
+static int efi_rtc_proc_show(struct seq_file *m, void *v)
 {
 	efi_time_t 	eft, alm;
 	efi_time_cap_t	cap;
-	char		*p = buf;
 	efi_bool_t	enabled, pending;	
 	unsigned long	flags;
 
@@ -316,64 +315,63 @@ efi_rtc_get_status(char *buf)
 
 	spin_unlock_irqrestore(&efi_rtc_lock,flags);
 
-	p += sprintf(p,
-		     "Time           : %u:%u:%u.%09u\n"
-		     "Date           : %u-%u-%u\n"
-		     "Daylight       : %u\n",
-		     eft.hour, eft.minute, eft.second, eft.nanosecond, 
-		     eft.year, eft.month, eft.day,
-		     eft.daylight);
+	seq_printf(m,
+		   "Time           : %u:%u:%u.%09u\n"
+		   "Date           : %u-%u-%u\n"
+		   "Daylight       : %u\n",
+		   eft.hour, eft.minute, eft.second, eft.nanosecond, 
+		   eft.year, eft.month, eft.day,
+		   eft.daylight);
 
 	if (eft.timezone == EFI_UNSPECIFIED_TIMEZONE)
-		p += sprintf(p, "Timezone       : unspecified\n");
+		seq_puts(m, "Timezone       : unspecified\n");
 	else
 		/* XXX fixme: convert to string? */
-		p += sprintf(p, "Timezone       : %u\n", eft.timezone);
+		seq_printf(m, "Timezone       : %u\n", eft.timezone);
 		
 
-	p += sprintf(p,
-		     "Alarm Time     : %u:%u:%u.%09u\n"
-		     "Alarm Date     : %u-%u-%u\n"
-		     "Alarm Daylight : %u\n"
-		     "Enabled        : %s\n"
-		     "Pending        : %s\n",
-		     alm.hour, alm.minute, alm.second, alm.nanosecond, 
-		     alm.year, alm.month, alm.day, 
-		     alm.daylight,
-		     enabled == 1 ? "yes" : "no",
-		     pending == 1 ? "yes" : "no");
+	seq_printf(m,
+		   "Alarm Time     : %u:%u:%u.%09u\n"
+		   "Alarm Date     : %u-%u-%u\n"
+		   "Alarm Daylight : %u\n"
+		   "Enabled        : %s\n"
+		   "Pending        : %s\n",
+		   alm.hour, alm.minute, alm.second, alm.nanosecond, 
+		   alm.year, alm.month, alm.day, 
+		   alm.daylight,
+		   enabled == 1 ? "yes" : "no",
+		   pending == 1 ? "yes" : "no");
 
 	if (eft.timezone == EFI_UNSPECIFIED_TIMEZONE)
-		p += sprintf(p, "Timezone       : unspecified\n");
+		seq_puts(m, "Timezone       : unspecified\n");
 	else
 		/* XXX fixme: convert to string? */
-		p += sprintf(p, "Timezone       : %u\n", alm.timezone);
+		seq_printf(m, "Timezone       : %u\n", alm.timezone);
 
 	/*
 	 * now prints the capabilities
 	 */
-	p += sprintf(p,
-		     "Resolution     : %u\n"
-		     "Accuracy       : %u\n"
-		     "SetstoZero     : %u\n",
-		      cap.resolution, cap.accuracy, cap.sets_to_zero);
+	seq_printf(m,
+		   "Resolution     : %u\n"
+		   "Accuracy       : %u\n"
+		   "SetstoZero     : %u\n",
+		   cap.resolution, cap.accuracy, cap.sets_to_zero);
 
-	return  p - buf;
+	return 0;
 }
 
-static int
-efi_rtc_read_proc(char *page, char **start, off_t off,
-                                 int count, int *eof, void *data)
+static int efi_rtc_proc_open(struct inode *inode, struct file *file)
 {
-        int len = efi_rtc_get_status(page);
-        if (len <= off+count) *eof = 1;
-        *start = page + off;
-        len -= off;
-        if (len>count) len = count;
-        if (len<0) len = 0;
-        return len;
+	return single_open(file, efi_rtc_proc_show, NULL);
 }
 
+static const struct file_operations efi_rtc_proc_fops = {
+	.open		= efi_rtc_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int __init 
 efi_rtc_init(void)
 {
@@ -389,8 +387,7 @@ efi_rtc_init(void)
 		return ret;
 	}
 
-	dir = create_proc_read_entry ("driver/efirtc", 0, NULL,
-			              efi_rtc_read_proc, NULL);
+	dir = proc_create("driver/efirtc", 0, NULL, &efi_rtc_proc_fops);
 	if (dir == NULL) {
 		printk(KERN_ERR "efirtc: can't create /proc/driver/efirtc.\n");
 		misc_deregister(&efi_rtc_dev);

