Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755912Ab3E0Jrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 05:47:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35349 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3E0Jru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 05:47:50 -0400
Date: Mon, 27 May 2013 02:47:38 -0700
From: tip-bot for Thomas Gleixner <tipbot@zytor.com>
Message-ID: <tip-29b5407819f59731c9423238fae03b756822708c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, john.stultz@linaro.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, magnus.damm@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, john.stultz@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        magnus.damm@gmail.com
In-Reply-To: <20130425143435.895851338@linutronix.de>
References: <20130425143435.895851338@linutronix.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] clocksource: Split out user string input
Git-Commit-ID: 29b5407819f59731c9423238fae03b756822708c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  29b5407819f59731c9423238fae03b756822708c
Gitweb:     http://git.kernel.org/tip/29b5407819f59731c9423238fae03b756822708c
Author:     Thomas Gleixner <tglx@linutronix.de>
AuthorDate: Thu, 25 Apr 2013 20:31:45 +0000
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 16 May 2013 11:09:15 +0200

clocksource: Split out user string input

Split out the user string input for clocksource override. Preparatory
patch for unbind.

[ jstultz: Fix an off by one error ]

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: John Stultz <john.stultz@linaro.org>
Cc: Magnus Damm <magnus.damm@gmail.com>
Link: http://lkml.kernel.org/r/20130425143435.895851338@linutronix.de
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/clocksource.c | 37 +++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 14 deletions(-)

diff --git a/kernel/time/clocksource.c b/kernel/time/clocksource.c
index 9782997..d7f1a45 100644
--- a/kernel/time/clocksource.c
+++ b/kernel/time/clocksource.c
@@ -174,7 +174,8 @@ clocks_calc_mult_shift(u32 *mult, u32 *shift, u32 from, u32 to, u32 maxsec)
 static struct clocksource *curr_clocksource;
 static LIST_HEAD(clocksource_list);
 static DEFINE_MUTEX(clocksource_mutex);
-static char override_name[32];
+#define CS_NAME_LEN		32
+static char override_name[CS_NAME_LEN];
 static int finished_booting;
 
 #ifdef CONFIG_CLOCKSOURCE_WATCHDOG
@@ -838,6 +839,23 @@ sysfs_show_current_clocksources(struct device *dev,
 	return count;
 }
 
+static size_t clocksource_get_uname(const char *buf, char *dst, size_t cnt)
+{
+	size_t ret = cnt;
+
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
+	return ret;
+}
+
 /**
  * sysfs_override_clocksource - interface for manually overriding clocksource
  * @dev:	unused
@@ -852,22 +870,13 @@ static ssize_t sysfs_override_clocksource(struct device *dev,
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
-	clocksource_select();
+	ret = clocksource_get_uname(buf, override_name, count);
+	if (ret >= 0)
+		clocksource_select();
 
 	mutex_unlock(&clocksource_mutex);
 
