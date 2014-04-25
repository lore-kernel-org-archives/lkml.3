Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751669AbaDYApJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:45:09 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:44432 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbaDYApE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:45:04 -0400
Message-ID: <5359B00B.6080900@gmail.com>
Date: Fri, 25 Apr 2014 08:44:59 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, len.brown@intel.com
CC: "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v3] kernel/power/hibernate.c: use unsigned variables instead
 of signed variables in swsusp_show_speed()
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do_div() needs 'u64' type, or it reports warning. And negative number
is meaningless for "speed", so change all signed to unsigned within
swsusp_show_speed().

The related warning (with allmodconfig for unicore32):

    CC      kernel/power/hibernate.o
  kernel/power/hibernate.c: In function ‘swsusp_show_speed’:
  kernel/power/hibernate.c:237: warning: comparison of distinct pointer types lacks a cast


Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 kernel/power/hibernate.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index f4f2073..afc11a0 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -228,19 +228,23 @@ static void platform_recover(int platform_mode)
 void swsusp_show_speed(struct timeval *start, struct timeval *stop,
 			unsigned nr_pages, char *msg)
 {
-	s64 elapsed_centisecs64;
-	int centisecs;
-	int k;
-	int kps;
+	u64 elapsed_centisecs64;
+	unsigned int centisecs;
+	unsigned int k;
+	unsigned int kps;
 
 	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
+	/*
+	 * If "(s64)elapsed_centisecs64 < 0", it will print long elapsed time,
+	 * it is obvious enough for what went wrong.
+	 */
 	do_div(elapsed_centisecs64, NSEC_PER_SEC / 100);
 	centisecs = elapsed_centisecs64;
 	if (centisecs == 0)
 		centisecs = 1;	/* avoid div-by-zero */
 	k = nr_pages * (PAGE_SIZE / 1024);
 	kps = (k * 100) / centisecs;
-	printk(KERN_INFO "PM: %s %d kbytes in %d.%02d seconds (%d.%02d MB/s)\n",
+	printk(KERN_INFO "PM: %s %u kbytes in %u.%02u seconds (%u.%02u MB/s)\n",
 			msg, k,
 			centisecs / 100, centisecs % 100,
 			kps / 1000, (kps % 1000) / 10);
-- 
1.9.2.459.g68773ac
