Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935469Ab3DKN3d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:29:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933462Ab3DKN33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:29:29 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH 13/26] genrtc: Don't use create_proc_read_entry() [RFC]
To: linux-kernel@vger.kernel.org
From: David Howells <dhowells@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, viro@ZenIV.linux.org.uk,
        Arnd Bergmann <arnd@arndb.de>
Date: Thu, 11 Apr 2013 14:29:23 +0100
Message-ID: <20130411132923.32763.91630.stgit@warthog.procyon.org.uk>
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

 drivers/char/genrtc.c |   48 +++++++++++++++++++++++-------------------------
 1 file changed, 23 insertions(+), 25 deletions(-)

diff --git a/drivers/char/genrtc.c b/drivers/char/genrtc.c
index 21cb980..bc9b84d 100644
--- a/drivers/char/genrtc.c
+++ b/drivers/char/genrtc.c
@@ -52,6 +52,7 @@
 #include <linux/init.h>
 #include <linux/poll.h>
 #include <linux/proc_fs.h>
+#include <linux/seq_file.h>
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 
@@ -386,18 +387,15 @@ static int gen_rtc_release(struct inode *inode, struct file *file)
  *	Info exported via "/proc/driver/rtc".
  */
 
-static int gen_rtc_proc_output(char *buf)
+static int gen_rtc_proc_show(struct seq_file *m, void *v)
 {
-	char *p;
 	struct rtc_time tm;
 	unsigned int flags;
 	struct rtc_pll_info pll;
 
-	p = buf;
-
 	flags = get_rtc_time(&tm);
 
-	p += sprintf(p,
+	seq_printf(m,
 		     "rtc_time\t: %02d:%02d:%02d\n"
 		     "rtc_date\t: %04d-%02d-%02d\n"
 		     "rtc_epoch\t: %04u\n",
@@ -406,23 +404,23 @@ static int gen_rtc_proc_output(char *buf)
 
 	tm.tm_hour = tm.tm_min = tm.tm_sec = 0;
 
-	p += sprintf(p, "alarm\t\t: ");
+	seq_puts(m, "alarm\t\t: ");
 	if (tm.tm_hour <= 24)
-		p += sprintf(p, "%02d:", tm.tm_hour);
+		seq_printf(m, "%02d:", tm.tm_hour);
 	else
-		p += sprintf(p, "**:");
+		seq_puts(m, "**:");
 
 	if (tm.tm_min <= 59)
-		p += sprintf(p, "%02d:", tm.tm_min);
+		seq_printf(m, "%02d:", tm.tm_min);
 	else
-		p += sprintf(p, "**:");
+		seq_puts(m, "**:");
 
 	if (tm.tm_sec <= 59)
-		p += sprintf(p, "%02d\n", tm.tm_sec);
+		seq_printf(m, "%02d\n", tm.tm_sec);
 	else
-		p += sprintf(p, "**\n");
+		seq_puts(m, "**\n");
 
-	p += sprintf(p,
+	seq_printf(m,
 		     "DST_enable\t: %s\n"
 		     "BCD\t\t: %s\n"
 		     "24hr\t\t: %s\n"
@@ -442,7 +440,7 @@ static int gen_rtc_proc_output(char *buf)
 		     0L /* freq */,
 		     (flags & RTC_BATT_BAD) ? "bad" : "okay");
 	if (!get_rtc_pll(&pll))
-	    p += sprintf(p,
+	    seq_printf(m,
 			 "PLL adjustment\t: %d\n"
 			 "PLL max +ve adjustment\t: %d\n"
 			 "PLL max -ve adjustment\t: %d\n"
@@ -455,26 +453,26 @@ static int gen_rtc_proc_output(char *buf)
 			 pll.pll_posmult,
 			 pll.pll_negmult,
 			 pll.pll_clock);
-	return p - buf;
+	return 0;
 }
 
-static int gen_rtc_read_proc(char *page, char **start, off_t off,
-			     int count, int *eof, void *data)
+static int gen_rtc_proc_open(struct inode *inode, struct file *file)
 {
-	int len = gen_rtc_proc_output (page);
-        if (len <= off+count) *eof = 1;
-	*start = page + off;
-	len -= off;
-        if (len>count) len = count;
-        if (len<0) len = 0;
-	return len;
+	return single_open(file, gen_rtc_proc_show, NULL);
 }
 
+static const struct file_operations gen_rtc_proc_fops = {
+	.open		= gen_rtc_proc_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= seq_release,
+};
+
 static int __init gen_rtc_proc_init(void)
 {
 	struct proc_dir_entry *r;
 
-	r = create_proc_read_entry("driver/rtc", 0, NULL, gen_rtc_read_proc, NULL);
+	r = proc_create("driver/rtc", 0, NULL, &gen_rtc_proc_fops);
 	if (!r)
 		return -ENOMEM;
 	return 0;

