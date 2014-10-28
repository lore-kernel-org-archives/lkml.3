Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756865AbaJ1ElU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:41:20 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:47899 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaJ1ElR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:41:17 -0400
Date: Tue, 28 Oct 2014 10:11:12 +0530
From: Heena Sirwani <heenasirwani@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: john.stultz@linaro.org, tglx@linutronix.de, arnd@arndb.de
Subject: [PATCH v6] cpuset: Replace all instances of time_t with time64_t
Message-ID: <20141028044112.GA27078@heena-HP-Compaq-8200-Elite-MT-PC>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch replaces all instances of time_t with time64_t i.e.
change the type used for representing time from 32-bit to 64-bit. All
32-bit kernels to date use a signed 32-bit time_t type, which can only
represent time until January 2038. Since embedded systems running 32-bit
Linux are going to survive beyond that date, we have to change all
current uses, in a backwards compatible way.

The patch also changes the function get_seconds() that returns a 32-bit
integer to ktime_get_seconds() that returns seconds as 64-bit integer.

The patch changes the type of ticks from time_t to u32. We keep ticks as
32-bits as the function uses 32-bit arithmetic which would prove less
expensive than 64-bit arithmetic and the function is expected to be
called atleast once every 32 seconds.

Signed-off-by: Heena Sirwani <heenasirwani@gmail.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
---
Changes in v6:
	- Changed the function ktime_get_ts64() to ktime_get_seconds().

 kernel/cpuset.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 1f107c7..65c7b20 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -51,6 +51,7 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/time.h>
+#include <linux/time64.h>
 #include <linux/backing-dev.h>
 #include <linux/sort.h>
 
@@ -68,7 +69,7 @@ struct static_key cpusets_enabled_key __read_mostly = STATIC_KEY_INIT_FALSE;
 struct fmeter {
 	int cnt;		/* unprocessed events count */
 	int val;		/* most recent output value */
-	time_t time;		/* clock (secs) when val computed */
+	time64_t time;		/* clock (secs) when val computed */
 	spinlock_t lock;	/* guards read or write of above */
 };
 
@@ -1355,7 +1356,7 @@ out:
  */
 
 #define FM_COEF 933		/* coefficient for half-life of 10 secs */
-#define FM_MAXTICKS ((time_t)99) /* useless computing more ticks than this */
+#define FM_MAXTICKS ((u32)99)   /* useless computing more ticks than this */
 #define FM_MAXCNT 1000000	/* limit cnt to avoid overflow */
 #define FM_SCALE 1000		/* faux fixed point scale */
 
@@ -1371,8 +1372,11 @@ static void fmeter_init(struct fmeter *fmp)
 /* Internal meter update - process cnt events and update value */
 static void fmeter_update(struct fmeter *fmp)
 {
-	time_t now = get_seconds();
-	time_t ticks = now - fmp->time;
+	time64_t now;
+	u32 ticks;
+
+	now = ktime_get_seconds();
+	ticks = now - fmp->time;
 
 	if (ticks == 0)
 		return;
-- 
1.9.1

