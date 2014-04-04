Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754294AbaDDSxx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 14:53:53 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27082 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754176AbaDDSxv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 14:53:51 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen/manage: Poweroff forcefully if user-space is not yet up.
Date: Fri,  4 Apr 2014 14:53:41 -0400
Message-Id: <1396637621-30113-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1396637621-30113-1-git-send-email-konrad.wilk@oracle.com>
References: <1396637621-30113-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The user can launch the guest in this sequence:

xl create -p /vm.cfg	[launch, but pause it]
xl shutdown latest	[sets control/shutdown=poweroff]
xl unpause latest
xl console latest	[and see that the guest has completely
ignored the shutdown request]

In reality the guest hasn't ignored it. It registers a watch
and gets a notification that there is value. It then calls
the shutdown_handler which ends up calling orderly_shutdown.

Unfortunately that is so early in the bootup that there
are no user-space. Which means that the orderly_shutdown fails.
But since the force flag was set to false it continues on without
reporting.

What we really want to is to use the force when we are in the
SYSTEM_BOOTING state and not use the 'force' when SYSTEM_RUNNING.

However, if we are in the running state - and the shutdown command
has been given before the user-space has been setup, there is nothing
we can do. Worst yet, we stop ignoring the 'xl shutdown' requests!

As such, the other part of this patch is to only stop ignoring
the 'xl shutdown' when we are truly in the power off sequence.

That means the user can do multiple 'xl shutdown' and we will try
to act on them instead of ignoring them.

Fixes-Bug: http://bugs.xenproject.org/xen/bug/6
Reported-by:  Alex Bligh <alex@alex.org.uk>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v2: Add switch statement]
[v3: Add a reboot notifier]
---
 drivers/xen/manage.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 624e8dc..0cf7fe1 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -182,10 +182,32 @@ struct shutdown_handler {
 	void (*cb)(void);
 };
 
+static int poweroff_nb(struct notifier_block *cb, unsigned long code, void *unused)
+{
+	switch (code) {
+	case SYS_DOWN:
+	case SYS_HALT:
+	case SYS_POWER_OFF:
+		shutting_down = SHUTDOWN_POWEROFF;
+	default:
+		break;
+	}
+	return NOTIFY_DONE;
+}
 static void do_poweroff(void)
 {
-	shutting_down = SHUTDOWN_POWEROFF;
-	orderly_poweroff(false);
+	switch (system_state) {
+	case SYSTEM_BOOTING:
+		orderly_poweroff(true);
+		break;
+	case SYSTEM_RUNNING:
+		orderly_poweroff(false);
+		break;
+	default:
+		/* Don't do it when we are halting/rebooting. */
+		pr_info("Ignoring Xen toolstack shutdown.\n");
+		break;
+	}
 }
 
 static void do_reboot(void)
@@ -291,6 +313,10 @@ static struct xenbus_watch shutdown_watch = {
 	.callback = shutdown_handler
 };
 
+static struct notifier_block xen_reboot_nb = {
+	.notifier_call = poweroff_nb,
+};
+
 static int setup_shutdown_watcher(void)
 {
 	int err;
@@ -301,6 +327,7 @@ static int setup_shutdown_watcher(void)
 		return err;
 	}
 
+
 #ifdef CONFIG_MAGIC_SYSRQ
 	err = register_xenbus_watch(&sysrq_watch);
 	if (err) {
@@ -329,6 +356,7 @@ int xen_setup_shutdown_event(void)
 	if (!xen_domain())
 		return -ENODEV;
 	register_xenstore_notifier(&xenstore_notifier);
+	register_reboot_notifier(&xen_reboot_nb);
 
 	return 0;
 }
-- 
1.8.5.3

