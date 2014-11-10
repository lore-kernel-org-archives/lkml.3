Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752935AbaKJBtw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 20:49:52 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:39114 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752451AbaKJBoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 20:44:34 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Kosina <jkosina@suse.cz>,
        x86@kernel.org
Subject: [PATCH v6 31/48] x86: apm: Register with kernel power-off handler
Date: Sun,  9 Nov 2014 17:42:48 -0800
Message-Id: <1415583785-6980-32-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
References: <1415583785-6980-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A02020A.54601881.01F7,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 175
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

Register with kernel power-off handler instead of setting pm_power_off
directly. Register with high priority to reflect that the original code
overwrites existing power-off handlers.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jiri Kosina <jkosina@suse.cz>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
v6:
- This patch: No change.
  Global: Replaced priority defines with enum.
v5:
- Rebase to v3.18-rc3
v4:
- Do not use notifiers but internal functions and data structures to manage
  the list of power-off handlers. Drop unused parameters from callbacks, and
  make the power-off function type void
v3:
- Replace poweroff in all newly introduced variables and in text
  with power_off or power-off as appropriate
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Use define to specify poweroff handler priority

 arch/x86/kernel/apm_32.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index 5848744..04910de 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -981,7 +981,7 @@ recalc:
  *	on their first cpu.
  */
 
-static void apm_power_off(void)
+static void apm_power_off(struct power_off_handler_block *this)
 {
 	/* Some bioses don't like being called from CPU != 0 */
 	if (apm_info.realmode_power_off) {
@@ -992,6 +992,11 @@ static void apm_power_off(void)
 	}
 }
 
+static struct power_off_handler_block apm_power_off_hb = {
+	.handler = apm_power_off,
+	.priority = POWER_OFF_PRIORITY_HIGH,
+};
+
 #ifdef CONFIG_APM_DO_ENABLE
 
 /**
@@ -1847,8 +1852,11 @@ static int apm(void *unused)
 	}
 
 	/* Install our power off handler.. */
-	if (power_off)
-		pm_power_off = apm_power_off;
+	if (power_off) {
+		error = register_power_off_handler(&apm_power_off_hb);
+		if (error)
+			pr_warn("apm: Failed to register power-off handler\n");
+	}
 
 	if (num_online_cpus() == 1 || smp) {
 #if defined(CONFIG_APM_DISPLAY_BLANK) && defined(CONFIG_VT)
@@ -2408,9 +2416,8 @@ static void __exit apm_exit(void)
 			apm_error("disengage power management", error);
 	}
 	misc_deregister(&apm_device);
+	unregister_power_off_handler(&apm_power_off_hb);
 	remove_proc_entry("apm", NULL);
-	if (power_off)
-		pm_power_off = NULL;
 	if (kapmd_task) {
 		kthread_stop(kapmd_task);
 		kapmd_task = NULL;
-- 
1.9.1

