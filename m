Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab3DYUbs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 16:31:48 -0400
Received: from www.linutronix.de ([62.245.132.108]:45991 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758996Ab3DYUbr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 16:31:47 -0400
Message-Id: <20130425143435.895851338@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 25 Apr 2013 20:31:45 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: John Stultz <john.stultz@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Magnus Damm <magnus.damm@gmail.com>
Subject: [patch 06/15] clocksource: Split out user string input
References: <20130425142452.908423538@linutronix.de>
Content-Disposition: inline;
 filename=clocksource-split-out-user-string-input.patch
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Split out the user string input for clocksource override. Preparatory
patch for unbind.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c |   35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

Index: tip/kernel/time/clocksource.c
===================================================================
--- tip.orig/kernel/time/clocksource.c
+++ tip/kernel/time/clocksource.c
@@ -174,7 +174,8 @@ clocks_calc_mult_shift(u32 *mult, u32 *s
 static struct clocksource *curr_clocksource;
 static LIST_HEAD(clocksource_list);
 static DEFINE_MUTEX(clocksource_mutex);
-static char override_name[32];
+#define CS_NAME_LEN		32
+static char override_name[CS_NAME_LEN];
 static int finished_booting;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
@@ -833,6 +834,21 @@ sysfs_show_current_clocksources(struct d
 	return count;
 }
 
+static size_t clocksource_get_uname(const char *buf, char *dst, size_t cnt)
+{
+	/* strings from sysfs write are not 0 terminated! */
+	if (!cnt || cnt >= CS_NAME_LEN)
+		return -EINVAL;
+
+	/* strip of \n: */
+	if (buf[cnt-1] == '\n')
+		cnt--;
+	if (cnt > 0)
+		memcpy(dst, buf, cnt);
+	dst[cnt] = 0;
+	return cnt;
+}
+
 /**
  * sysfs_override_clocksource - interface for manually overriding clocksource
  * @dev:	unused
@@ -847,22 +863,13 @@ static ssize_t sysfs_override_clocksourc
 					  struct device_attribute *attr,
 					  const char *buf, size_t count)
 {
-	size_t ret = count;
-
-	/* strings from sysfs write are not 0 terminated! */
-	if (count >= sizeof(override_name))
-		return -EINVAL;
-
-	/* strip of \n: */
-	if (buf[count-1] == '\n')
-		count--;
+	size_t ret;
 
 	mutex_lock(&clocksource_mutex);
 
-	if (count > 0)
-		memcpy(override_name, buf, count);
-	override_name[count] = 0;
-	clocksource_select(false);
+	ret = clocksource_get_uname(buf, override_name, count);
+	if (ret >= 0)
+		clocksource_select(false);
 
 	mutex_unlock(&clocksource_mutex);
 


