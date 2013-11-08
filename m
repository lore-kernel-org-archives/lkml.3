Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932095Ab3KHRin (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 12:38:43 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:45850 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757898Ab3KHRiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 12:38:23 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian.Campbell@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        david.vrabel@citrix.com, boris.ostrovsky@oracle.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] xen/manage: Poweroff forcefully if user-space is not yet up.
Date: Fri,  8 Nov 2013 12:38:04 -0500
Message-Id: <1383932286-25080-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
References: <1383932286-25080-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
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

We check if the system is still in the booting stage and if so
enable the force option (which will shutdown in early bootup
process). If in normal running case we don't force it.

Fixes-Bug: http://bugs.xenproject.org/xen/bug/6
Reported-by:  Alex Bligh <alex@alex.org.uk>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
[v2: Add switch statement]
---
 drivers/xen/manage.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 624e8dc..3f8496c 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -185,7 +185,18 @@ struct shutdown_handler {
 static void do_poweroff(void)
 {
 	shutting_down = SHUTDOWN_POWEROFF;
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
-- 
1.8.3.1

