Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbaJUET5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 00:19:57 -0400
Received: from bh-25.webhostbox.net ([208.91.199.152]:33805 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaJUEOY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 00:14:24 -0400
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jkosina@suse.cz>,
        x86@kernel.org
Subject: [PATCH v2 31/47] x86: apm: Register with kernel poweroff handler
Date: Mon, 20 Oct 2014 21:12:47 -0700
Message-Id: <1413864783-3271-32-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
References: <1413864783-3271-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.5445DDA0.009D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.000
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 165
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

Register with kernel poweroff handler instead of setting pm_power_off
directly. Register with high priority to reflect that the original code
overwrites existing poweroff handlers.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v2:
- Use define to specify poweroff handler priority

 arch/x86/kernel/apm_32.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 5848744..b03a65e 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -219,6 +219,7 @@
 #include <linux/init.h>
 #include <linux/time.h>
 #include <linux/sched.h>
+#include <linux/notifier.h>
 #include <linux/pm.h>
 #include <linux/capability.h>
 #include <linux/device.h>
@@ -981,7 +982,8 @@ recalc:
  *	on their first cpu.
  */
 
-static void apm_power_off(void)
+static int apm_power_off(struct notifier_block *this, unsigned long unused1,
+			 void *unused2)
 {
 	/* Some bioses don't like being called from CPU != 0 */
 	if (apm_info.realmode_power_off) {
@@ -990,8 +992,14 @@ static void apm_power_off(void)
 	} else {
 		(void)set_system_power_state(APM_STATE_OFF);
 	}
+	return NOTIFY_DONE;
 }
 
+static struct notifier_block apm_poweroff_nb = {
+	.notifier_call = apm_power_off,
+	.priority = POWEROFF_PRIORITY_HIGH,
+};
+
 #ifdef CONFIG_APM_DO_ENABLE
 
 /**
@@ -1847,8 +1855,11 @@ static int apm(void *unused)
 	}
 
 	/* Install our power off handler.. */
-	if (power_off)
-		pm_power_off = apm_power_off;
+	if (power_off) {
+		error = register_power_off_handler(&apm_poweroff_nb);
+		if (error)
+			pr_err("apm: Failed to register poweroff handler\n");
+	}
 
 	if (num_online_cpus() == 1 || smp) {
 #if defined(CONFIG_APM_DISPLAY_BLANK) && defined(CONFIG_VT)
@@ -2408,9 +2419,8 @@ static void __exit apm_exit(void)
 			apm_error("disengage power management", error);
 	}
 	misc_deregister(&apm_device);
+	unregister_power_off_handler(&apm_poweroff_nb);
 	remove_proc_entry("apm", NULL);
-	if (power_off)
-		pm_power_off = NULL;
 	if (kapmd_task) {
 		kthread_stop(kapmd_task);
 		kapmd_task = NULL;
-- 
1.9.1

