Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319AbaKFQ7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:59:18 -0500
Received: from bh-25.webhostbox.net ([208.91.199.152]:56258 "EHLO
	bh-25.webhostbox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbaKFQoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:44:30 -0500
From: Guenter Roeck <linux@roeck-us.net>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>,
        Corey Minyard <minyard@acm.org>,
        openipmi-developer@lists.sourceforge.net
Subject: [PATCH v5 21/48] ipmi: Register with kernel power-off handler
Date: Thu,  6 Nov 2014 08:43:05 -0800
Message-Id: <1415292213-28652-22-git-send-email-linux@roeck-us.net>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
References: <1415292213-28652-1-git-send-email-linux@roeck-us.net>
X-Authenticated_sender: guenter@roeck-us.net
X-OutGoing-Spam-Status: No, score=-1.0
X-CTCH-PVer: 0000001
X-CTCH-Spam: Unknown
X-CTCH-VOD: Unknown
X-CTCH-Flags: 0
X-CTCH-RefID: str=0001.0A020209.545BA56E.01B6,ss=1,re=0.001,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0
X-CTCH-Score: 0.001
X-CTCH-ScoreCust: 0.000
X-CTCH-Rules: C_4847,
X-CTCH-SenderID: linux@roeck-us.net
X-CTCH-SenderID-Flags: 0
X-CTCH-SenderID-TotalMessages: 122
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
overwrites pm_power_off unconditionally.

Register power-off handler after the ipmi system is ready, and unregister
it prior to cleanup. This avoids having to check for the ready variable
in the poweroff callback.

Reviewed-by: Corey Minyard <minyard@acm.org>
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
- Replace POWEROFF_PRIORITY_xxx with POWER_OFF_PRIORITY_xxx
v2:
- Use define to specify poweroff handler priority
- Use pr_warn instead of pr_err
- Call unregister_power_off_handler on exit only if not already unregistered

 drivers/char/ipmi/ipmi_poweroff.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_poweroff.c b/drivers/char/ipmi/ipmi_poweroff.c
index 9f2e3be..4ae2f22 100644
--- a/drivers/char/ipmi/ipmi_poweroff.c
+++ b/drivers/char/ipmi/ipmi_poweroff.c
@@ -63,9 +63,6 @@ static ipmi_user_t ipmi_user;
 static int ipmi_ifnum;
 static void (*specific_poweroff_func)(ipmi_user_t user);
 
-/* Holds the old poweroff function so we can restore it on removal. */
-static void (*old_poweroff_func)(void);
-
 static int set_param_ifnum(const char *val, struct kernel_param *kp)
 {
 	int rv = param_set_int(val, kp);
@@ -544,15 +541,17 @@ static struct poweroff_function poweroff_functions[] = {
 
 
 /* Called on a powerdown request. */
-static void ipmi_poweroff_function(void)
+static void ipmi_poweroff_function(struct power_off_handler_block *this)
 {
-	if (!ready)
-		return;
-
 	/* Use run-to-completion mode, since interrupts may be off. */
 	specific_poweroff_func(ipmi_user);
 }
 
+static struct power_off_handler_block ipmi_power_off_hb = {
+	.handler = ipmi_poweroff_function,
+	.priority = POWER_OFF_PRIORITY_HIGH,
+};
+
 /* Wait for an IPMI interface to be installed, the first one installed
    will be grabbed by this code and used to perform the powerdown. */
 static void ipmi_po_new_smi(int if_num, struct device *device)
@@ -631,9 +630,12 @@ static void ipmi_po_new_smi(int if_num, struct device *device)
 	printk(KERN_INFO PFX "Found a %s style poweroff function\n",
 	       poweroff_functions[i].platform_type);
 	specific_poweroff_func = poweroff_functions[i].poweroff_func;
-	old_poweroff_func = pm_power_off;
-	pm_power_off = ipmi_poweroff_function;
+
 	ready = 1;
+
+	rv = register_power_off_handler(&ipmi_power_off_hb);
+	if (rv)
+		pr_warn(PFX "failed to register power-off handler\n");
 }
 
 static void ipmi_po_smi_gone(int if_num)
@@ -644,9 +646,10 @@ static void ipmi_po_smi_gone(int if_num)
 	if (ipmi_ifnum != if_num)
 		return;
 
+	unregister_power_off_handler(&ipmi_power_off_hb);
+
 	ready = 0;
 	ipmi_destroy_user(ipmi_user);
-	pm_power_off = old_poweroff_func;
 }
 
 static struct ipmi_smi_watcher smi_watcher = {
@@ -733,11 +736,11 @@ static void __exit ipmi_poweroff_cleanup(void)
 	ipmi_smi_watcher_unregister(&smi_watcher);
 
 	if (ready) {
+		unregister_power_off_handler(&ipmi_power_off_hb);
 		rv = ipmi_destroy_user(ipmi_user);
 		if (rv)
 			printk(KERN_ERR PFX "could not cleanup the IPMI"
 			       " user: 0x%x\n", rv);
-		pm_power_off = old_poweroff_func;
 	}
 }
 module_exit(ipmi_poweroff_cleanup);
-- 
1.9.1

