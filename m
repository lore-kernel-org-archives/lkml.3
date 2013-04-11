Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965086Ab3DKN3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:29:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30037 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965025Ab3DKN3p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:29:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 12/26] hp_sdc_rtc: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: linux-m68k@vger.kernel.org, "Brian S. Julin" <bri@calyx.com>,
        viro@ZenIV.linux.org.uk, Helge Deller <deller@gmx.de>
Date: Thu, 11 Apr 2013 14:29:16 +0100
Message-ID: <20130411132916.32763.83802.stgit@warthog.procyon.org.uk>
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
cc: Brian S. Julin <bri@calyx.com>
cc: Helge Deller <deller@gmx.de>
cc: linux-m68k@lists.linux-m68k.org
---

 drivers/input/misc/hp_sdc_rtc.c |   58 +++++++++++++++++----------------------
 1 file changed, 26 insertions(+), 32 deletions(-)

diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index 2e3334b..770479d 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -41,6 +41,7 @@
 #include <linux/time.h>
 #include <linux/miscdevice.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/poll.h>
 #include <linux/rtc.h>
 #include <linux/mutex.h>
@@ -74,9 +75,6 @@ static unsigned int hp_sdc_rtc_poll(struct file *file, poll_table *wait);
 static int hp_sdc_rtc_open(struct inode *inode, struct file *file);
 static int hp_sdc_rtc_fasync (int fd, struct file *filp, int on);
 
-static int hp_sdc_rtc_read_proc(char *page, char **start, off_t off,
-				int count, int *eof, void *data);
-
 static void hp_sdc_rtc_isr (int irq, void *dev_id, 
 			    uint8_t status, uint8_t data) 
 {
@@ -427,22 +425,19 @@ static int hp_sdc_rtc_fasync (int fd, struct file *filp, int on)
         return fasync_helper (fd, filp, on, &hp_sdc_rtc_async_queue);
 }
 
-static int hp_sdc_rtc_proc_output (char *buf)
+static int hp_sdc_rtc_proc_show(struct seq_file *m, void *v)
 {
 #define YN(bit) ("no")
 #define NY(bit) ("yes")
-        char *p;
         struct rtc_time tm;
 	struct timeval tv;
 
 	memset(&tm, 0, sizeof(struct rtc_time));
 
-	p = buf;
-
 	if (hp_sdc_rtc_read_bbrtc(&tm)) {
-		p += sprintf(p, "BBRTC\t\t: READ FAILED!\n");
+		seq_puts(m, "BBRTC\t\t: READ FAILED!\n");
 	} else {
-		p += sprintf(p,
+		seq_printf(m,
 			     "rtc_time\t: %02d:%02d:%02d\n"
 			     "rtc_date\t: %04d-%02d-%02d\n"
 			     "rtc_epoch\t: %04lu\n",
@@ -452,41 +447,41 @@ static int hp_sdc_rtc_proc_output (char *buf)
 	}
 
 	if (hp_sdc_rtc_read_rt(&tv)) {
-		p += sprintf(p, "i8042 rtc\t: READ FAILED!\n");
+		seq_puts(m, "i8042 rtc\t: READ FAILED!\n");
 	} else {
-		p += sprintf(p, "i8042 rtc\t: %ld.%02d seconds\n", 
+		seq_printf(m, "i8042 rtc\t: %ld.%02d seconds\n", 
 			     tv.tv_sec, (int)tv.tv_usec/1000);
 	}
 
 	if (hp_sdc_rtc_read_fhs(&tv)) {
-		p += sprintf(p, "handshake\t: READ FAILED!\n");
+		seq_puts(m, "handshake\t: READ FAILED!\n");
 	} else {
-        	p += sprintf(p, "handshake\t: %ld.%02d seconds\n", 
+        	seq_printf(m, "handshake\t: %ld.%02d seconds\n", 
 			     tv.tv_sec, (int)tv.tv_usec/1000);
 	}
 
 	if (hp_sdc_rtc_read_mt(&tv)) {
-		p += sprintf(p, "alarm\t\t: READ FAILED!\n");
+		seq_puts(m, "alarm\t\t: READ FAILED!\n");
 	} else {
-		p += sprintf(p, "alarm\t\t: %ld.%02d seconds\n", 
+		seq_printf(m, "alarm\t\t: %ld.%02d seconds\n", 
 			     tv.tv_sec, (int)tv.tv_usec/1000);
 	}
 
 	if (hp_sdc_rtc_read_dt(&tv)) {
-		p += sprintf(p, "delay\t\t: READ FAILED!\n");
+		seq_puts(m, "delay\t\t: READ FAILED!\n");
 	} else {
-		p += sprintf(p, "delay\t\t: %ld.%02d seconds\n", 
+		seq_printf(m, "delay\t\t: %ld.%02d seconds\n", 
 			     tv.tv_sec, (int)tv.tv_usec/1000);
 	}
 
 	if (hp_sdc_rtc_read_ct(&tv)) {
-		p += sprintf(p, "periodic\t: READ FAILED!\n");
+		seq_puts(m, "periodic\t: READ FAILED!\n");
 	} else {
-		p += sprintf(p, "periodic\t: %ld.%02d seconds\n", 
+		seq_printf(m, "periodic\t: %ld.%02d seconds\n", 
 			     tv.tv_sec, (int)tv.tv_usec/1000);
 	}
 
-        p += sprintf(p,
+        seq_printf(m,
                      "DST_enable\t: %s\n"
                      "BCD\t\t: %s\n"
                      "24hr\t\t: %s\n"
@@ -506,23 +501,23 @@ static int hp_sdc_rtc_proc_output (char *buf)
                      1UL,
                      1 ? "okay" : "dead");
 
-        return  p - buf;
+        return 0;
 #undef YN
 #undef NY
 }
 
-static int hp_sdc_rtc_read_proc(char *page, char **start, off_t off,
-                         int count, int *eof, void *data)
+static int hp_sdc_rtc_proc_open(struct inode *inode, struct file *file)
 {
-	int len = hp_sdc_rtc_proc_output (page);
-        if (len <= off+count) *eof = 1;
-        *start = page + off;
-        len -= off;
-        if (len>count) len = count;
-        if (len<0) len = 0;
-        return len;
+	return single_open(file, hp_sdc_rtc_proc_show, NULL);
 }
 
+static const struct file_operations hp_sdc_rtc_proc_fops = {
+	.open		= hp_sdc_rtc_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int hp_sdc_rtc_ioctl(struct file *file, 
 			    unsigned int cmd, unsigned long arg)
 {
@@ -715,8 +710,7 @@ static int __init hp_sdc_rtc_init(void)
 	if (misc_register(&hp_sdc_rtc_dev) != 0)
 		printk(KERN_INFO "Could not register misc. dev for i8042 rtc\n");
 
-        create_proc_read_entry ("driver/rtc", 0, NULL,
-				hp_sdc_rtc_read_proc, NULL);
+        proc_create("driver/rtc", 0, NULL, &hp_sdc_rtc_proc_fops);
 
 	printk(KERN_INFO "HP i8042 SDC + MSM-58321 RTC support loaded "
 			 "(RTC v " RTC_VERSION ")\n");

