Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752537AbaKFQpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:45:52 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56659 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338AbaKFQpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:45:40 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>
Subject: [PATCH v5 48/48] kernel: Remove pm_power_off
Date: Thu,  6 Nov 2014 08:43:32 -0800
Message-Id: <1415292213-28652-49-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=1.3
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.545BA5B3.02C2,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 274
X-CTCH-SenderID-TotalSpam: 0
X-CTCH-SenderID-TotalSuspected: 0
X-CTCH-SenderID-TotalConfirmed: 0
X-CTCH-SenderID-TotalBulk: 0
X-CTCH-SenderID-TotalVirus: 0
X-CTCH-SenderID-TotalRecipients: 0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - bh-25.webhostbox.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - roeck-us.net
X-Get-Message-Sender-Via: bh-25.webhostbox.net: mailgid no entry from get_relayhosts_entry
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No users of pm_power_off are left, so it is safe to remove the function.

Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Len Brown <len.brown@intel.com>
Acked-by: Rafael J. Wysocki <rjw@rjwysocki.net>
Acked-by: Pavel Machek <pavel@ucw.cz>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v5:
- Rebase to v3.18-rc3
v4:
- Do not use notifiers but internal functions and data structures to manage
  the list of power-off handlers. Drop unused parameters from callbacks, and
  make the power-off function type void
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
v2:
- poweroff -> power_off for API functions

 include/linux/pm.h               |  1 -
 kernel/power/power_off_handler.c | 13 +------------
 2 files changed, 1 insertion(+), 13 deletions(-)

diff --git a/include/linux/pm.h b/include/linux/pm.h
index a4d6bf8..8fcf352 100644
--- a/include/linux/pm.h
+++ b/include/linux/pm.h
@@ -31,7 +31,6 @@
 /*
  * Callbacks for platform drivers to implement.
  */
-extern void (*pm_power_off)(void);
 extern void (*pm_power_off_prepare)(void);
 
 struct device; /* we have a circular dep with device.h */
diff --git a/kernel/power/power_off_handler.c b/kernel/power/power_off_handler.c
index e283ea1..d67ab57 100644
--- a/kernel/power/power_off_handler.c
+++ b/kernel/power/power_off_handler.c
@@ -23,12 +23,6 @@
 #include <linux/types.h>
 
 /*
- * If set, calling this function will power off the system immediately.
- */
-void (*pm_power_off)(void);
-EXPORT_SYMBOL(pm_power_off);
-
-/*
  * List of handlers for kernel code which wants to be called
  * to power off the system.
  */
@@ -277,10 +271,6 @@ void do_kernel_power_off(void)
 	 * removed while the call chain is traversed, but we'll have to accept
 	 * that risk.
 	 */
-
-	if (pm_power_off)
-		pm_power_off();
-
 	p = rcu_dereference_raw(power_off_handler_list);
 	while (p) {
 		next_p = rcu_dereference_raw(p->next);
@@ -296,7 +286,6 @@ void do_kernel_power_off(void)
  */
 bool have_kernel_power_off(void)
 {
-	return pm_power_off != NULL ||
-			rcu_dereference_raw(power_off_handler_list) != NULL;
+	return rcu_dereference_raw(power_off_handler_list) != NULL;
 }
 EXPORT_SYMBOL(have_kernel_power_off);
-- 
1.9.1

