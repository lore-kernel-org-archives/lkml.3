Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984AbaKBVml (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 16:42:41 -0500
Received: from smtprelay0038.hostedemail.com ([216.40.44.38]:56349 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750990AbaKBVmi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 16:42:38 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:2:41:69:355:379:541:800:960:973:982:988:989:1260:1277:1311:1313:1314:1345:1373:1437:1515:1516:1518:1535:1593:1594:1605:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3865:3866:3867:3870:3871:3872:3874:4049:4117:4321:4605:5007:6261:7903:8603:9592:10004:10848:11026:11473:11657:11658:11914:12043:12296:12438:12517:12519:12555:12663:13255:14394:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: view95_50eb215ba1b07
X-Filterd-Recvd-Size: 6986
Message-ID: <1414964554.17743.7.camel@perches.com>
Subject: [PATCH] printk: Add and use LOGLEVEL_<level> defines for
 KERN_<LEVEL> equivalents
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg KH <gregkh@linuxfoundation.org>, Jason Baron <jbaron@akamai.com>,
        linux-usb <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 02 Nov 2014 13:42:34 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use #defines instead of magic values.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/usb/storage/debug.c |  2 +-
 include/linux/kern_levels.h | 13 +++++++++++++
 kernel/printk/printk.c      | 28 +++++++++++++---------------
 lib/dynamic_debug.c         |  4 ++--
 4 files changed, 29 insertions(+), 18 deletions(-)

diff --git a/drivers/usb/storage/debug.c b/drivers/usb/storage/debug.c
index e08f647..e43a956 100644
--- a/drivers/usb/storage/debug.c
+++ b/drivers/usb/storage/debug.c
@@ -186,7 +186,7 @@ int usb_stor_dbg(const struct us_data *us, const char *fmt, ...)
 
 	va_start(args, fmt);
 
-	r = dev_vprintk_emit(7, &us->pusb_dev->dev, fmt, args);
+	r = dev_vprintk_emit(LOGLEVEL_DEBUG, &us->pusb_dev->dev, fmt, args);
 
 	va_end(args);
 
diff --git a/include/linux/kern_levels.h b/include/linux/kern_levels.h
index 866caaa..3b9e71f 100644
--- a/include/linux/kern_levels.h
+++ b/include/linux/kern_levels.h
@@ -22,4 +22,17 @@
  */
 #define KERN_CONT	""
 
+/* integer equivalents of KERN_<LEVEL> */
+#define LOGLEVEL_SCHED		-2	/* Deferred messages from sched code
+					 * are set to this special level */
+#define LOGLEVEL_DEFAULT	-1	/* default (or last) loglevel */
+#define LOGLEVEL_EMERG		0	/* system is unusable */
+#define LOGLEVEL_ALERT		1	/* action must be taken immediately */
+#define LOGLEVEL_CRIT		2	/* critical conditions */
+#define LOGLEVEL_ERR		3	/* error conditions */
+#define LOGLEVEL_WARNING	4	/* warning conditions */
+#define LOGLEVEL_NOTICE		5	/* normal but significant condition */
+#define LOGLEVEL_INFO		6	/* informational */
+#define LOGLEVEL_DEBUG		7	/* debug-level messages */
+
 #endif
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index ced2b84..2b8606e 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -62,9 +62,6 @@ int console_printk[4] = {
 	CONSOLE_LOGLEVEL_DEFAULT,	/* default_console_loglevel */
 };
 
-/* Deferred messaged from sched code are marked by this special level */
-#define SCHED_MESSAGE_LOGLEVEL -2
-
 /*
  * Low level drivers may need that to know if they can schedule in
  * their unblank() callback or not. So let's export it.
@@ -1259,7 +1256,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 int do_syslog(int type, char __user *buf, int len, bool from_file)
 {
 	bool clear = false;
-	static int saved_console_loglevel = -1;
+	static int saved_console_loglevel = LOGLEVEL_DEFAULT;
 	int error;
 
 	error = check_syslog_permissions(type, from_file);
@@ -1316,15 +1313,15 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		break;
 	/* Disable logging to console */
 	case SYSLOG_ACTION_CONSOLE_OFF:
-		if (saved_console_loglevel == -1)
+		if (saved_console_loglevel == LOGLEVEL_DEFAULT)
 			saved_console_loglevel = console_loglevel;
 		console_loglevel = minimum_console_loglevel;
 		break;
 	/* Enable logging to console */
 	case SYSLOG_ACTION_CONSOLE_ON:
-		if (saved_console_loglevel != -1) {
+		if (saved_console_loglevel != LOGLEVEL_DEFAULT) {
 			console_loglevel = saved_console_loglevel;
-			saved_console_loglevel = -1;
+			saved_console_loglevel = LOGLEVEL_DEFAULT;
 		}
 		break;
 	/* Set level of messages printed to console */
@@ -1336,7 +1333,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			len = minimum_console_loglevel;
 		console_loglevel = len;
 		/* Implicitly re-enable logging to console */
-		saved_console_loglevel = -1;
+		saved_console_loglevel = LOGLEVEL_DEFAULT;
 		error = 0;
 		break;
 	/* Number of chars in the log buffer */
@@ -1629,8 +1626,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 	/* cpu currently holding logbuf_lock in this function */
 	static volatile unsigned int logbuf_cpu = UINT_MAX;
 
-	if (level == SCHED_MESSAGE_LOGLEVEL) {
-		level = -1;
+	if (level == LOGLEVEL_SCHED) {
+		level = LOGLEVEL_DEFAULT;
 		in_sched = true;
 	}
 
@@ -1695,8 +1692,9 @@ asmlinkage int vprintk_emit(int facility, int level,
 			const char *end_of_header = printk_skip_level(text);
 			switch (kern_level) {
 			case '0' ... '7':
-				if (level == -1)
+				if (level == LOGLEVEL_DEFAULT)
 					level = kern_level - '0';
+				/* fallthrough */
 			case 'd':	/* KERN_DEFAULT */
 				lflags |= LOG_PREFIX;
 			}
@@ -1710,7 +1708,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		}
 	}
 
-	if (level == -1)
+	if (level == LOGLEVEL_DEFAULT)
 		level = default_message_loglevel;
 
 	if (dict)
@@ -1788,7 +1786,7 @@ EXPORT_SYMBOL(vprintk_emit);
 
 asmlinkage int vprintk(const char *fmt, va_list args)
 {
-	return vprintk_emit(0, -1, NULL, 0, fmt, args);
+	return vprintk_emit(0, LOGLEVEL_DEFAULT, NULL, 0, fmt, args);
 }
 EXPORT_SYMBOL(vprintk);
 
@@ -1842,7 +1840,7 @@ asmlinkage __visible int printk(const char *fmt, ...)
 	}
 #endif
 	va_start(args, fmt);
-	r = vprintk_emit(0, -1, NULL, 0, fmt, args);
+	r = vprintk_emit(0, LOGLEVEL_DEFAULT, NULL, 0, fmt, args);
 	va_end(args);
 
 	return r;
@@ -2634,7 +2632,7 @@ int printk_deferred(const char *fmt, ...)
 
 	preempt_disable();
 	va_start(args, fmt);
-	r = vprintk_emit(0, SCHED_MESSAGE_LOGLEVEL, NULL, 0, fmt, args);
+	r = vprintk_emit(0, LOGLEVEL_SCHED, NULL, 0, fmt, args);
 	va_end(args);
 
 	__this_cpu_or(printk_pending, PRINTK_PENDING_OUTPUT);
diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
index dfba055..527799d 100644
--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -576,7 +576,7 @@ void __dynamic_dev_dbg(struct _ddebug *descriptor,
 	} else {
 		char buf[PREFIX_SIZE];
 
-		dev_printk_emit(7, dev, "%s%s %s: %pV",
+		dev_printk_emit(LOGLEVEL_DEBUG, dev, "%s%s %s: %pV",
 				dynamic_emit_prefix(descriptor, buf),
 				dev_driver_string(dev), dev_name(dev),
 				&vaf);
@@ -605,7 +605,7 @@ void __dynamic_netdev_dbg(struct _ddebug *descriptor,
 	if (dev && dev->dev.parent) {
 		char buf[PREFIX_SIZE];
 
-		dev_printk_emit(7, dev->dev.parent,
+		dev_printk_emit(LOGLEVEL_DEBUG, dev->dev.parent,
 				"%s%s %s %s%s: %pV",
 				dynamic_emit_prefix(descriptor, buf),
 				dev_driver_string(dev->dev.parent),


