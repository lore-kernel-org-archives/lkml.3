Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab3BUSKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 13:10:32 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:63690 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756133Ab3BUSK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 13:10:28 -0500
Date: Thu, 21 Feb 2013 10:10:47 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc: lwn@lwn.net, Jiri Slaby <jslaby@suse.cz>
Subject: Re: Linux 3.0.66
Message-ID: <20130221181047.GB7510@kroah.com>
References: <20130221181038.GA7510@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130221181038.GA7510@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


diff --git a/Makefile b/Makefile
index cdba5c1..da3ff21 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION = 3
 PATCHLEVEL = 0
-SUBLEVEL = 65
+SUBLEVEL = 66
 EXTRAVERSION =
 NAME = Sneaky Weasel
 
diff --git a/include/linux/syslog.h b/include/linux/syslog.h
index 3891139..ce4c665 100644
--- a/include/linux/syslog.h
+++ b/include/linux/syslog.h
@@ -47,6 +47,12 @@
 #define SYSLOG_FROM_CALL 0
 #define SYSLOG_FROM_FILE 1
 
+/*
+ * Syslog priority (PRI) maximum length in char : '<[0-9]{1,3}>'
+ * See RFC5424 for details
+*/
+#define SYSLOG_PRI_MAX_LENGTH 5
+
 int do_syslog(int type, char __user *buf, int count, bool from_file);
 
 #endif /* _LINUX_SYSLOG_H */
diff --git a/kernel/printk.c b/kernel/printk.c
index 3fc4708..6edc4e89 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -633,8 +633,19 @@ static void call_console_drivers(unsigned start, unsigned end)
 	start_print = start;
 	while (cur_index != end) {
 		if (msg_level < 0 && ((end - cur_index) > 2)) {
+			/*
+			 * prepare buf_prefix, as a contiguous array,
+			 * to be processed by log_prefix function
+			 */
+			char buf_prefix[SYSLOG_PRI_MAX_LENGTH+1];
+			unsigned i;
+			for (i = 0; i < ((end - cur_index)) && (i < SYSLOG_PRI_MAX_LENGTH); i++) {
+				buf_prefix[i] = LOG_BUF(cur_index + i);
+			}
+			buf_prefix[i] = '\0'; /* force '\0' as last string character */
+
 			/* strip log prefix */
-			cur_index += log_prefix(&LOG_BUF(cur_index), &msg_level, NULL);
+			cur_index += log_prefix((const char *)&buf_prefix, &msg_level, NULL);
 			start_print = cur_index;
 		}
 		while (cur_index != end) {
