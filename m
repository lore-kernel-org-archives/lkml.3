Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933593AbaHHVFM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 17:05:12 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:41342 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933097AbaHHUxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 16:53:45 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Vrabel <david.vrabel@citrix.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 113/259] xen/manage: fix potential deadlock when resuming the console
Date: Fri,  8 Aug 2014 13:38:56 -0700
Message-Id: <1407530482-4483-114-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1407530482-4483-1-git-send-email-kamal@canonical.com>
References: <1407530482-4483-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Vrabel <david.vrabel@citrix.com>

commit 1b6478231c6f5f844185acb32045cf195028cfce upstream.

Calling xen_console_resume() in xen_suspend() causes a warning because
it locks irq_mapping_update_lock (a mutex) and this may sleep.  If a
userspace process is using the evtchn device then this mutex may be
locked at the point of the stop_machine() call and
xen_console_resume() would then deadlock.

Resuming the console after stop_machine() returns avoids this
deadlock.

Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Reviewed-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/xen/manage.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 624e8dc..0bc8086 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -95,7 +95,6 @@ static int xen_suspend(void *data)
 
 	if (!si->cancelled) {
 		xen_irq_resume();
-		xen_console_resume();
 		xen_timer_resume();
 	}
 
@@ -152,6 +151,10 @@ static void do_suspend(void)
 
 	err = stop_machine(xen_suspend, &si, cpumask_of(0));
 
+	/* Resume console as early as possible. */
+	if (!si.cancelled)
+		xen_console_resume();
+
 	dpm_resume_start(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
 	if (err) {
-- 
1.9.1

