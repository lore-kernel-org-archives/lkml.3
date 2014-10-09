Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932897AbaJIVhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 17:37:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:59206 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757397AbaJIVIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 17:08:23 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ross Lagerwall <ross.lagerwall@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 022/163] xen/manage: Always freeze/thaw processes when suspend/resuming
Date: Thu,  9 Oct 2014 14:00:47 -0700
Message-Id: <1412888588-26755-23-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412888588-26755-1-git-send-email-kamal@canonical.com>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ross Lagerwall <ross.lagerwall@citrix.com>

commit 61a734d305e16944b42730ef582a7171dc733321 upstream.

Always freeze processes when suspending and thaw processes when resuming
to prevent a race noticeable with HVM guests.

This prevents a deadlock where the khubd kthread (which is designed to
be freezable) acquires a usb device lock and then tries to allocate
memory which requires the disk which hasn't been resumed yet.
Meanwhile, the xenwatch thread deadlocks waiting for the usb device
lock.

Freezing processes fixes this because the khubd thread is only thawed
after the xenwatch thread finishes resuming all the devices.

Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
Signed-off-by: David Vrabel <david.vrabel@citrix.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/xen/manage.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 0bc8086..a344372 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -110,16 +110,11 @@ static void do_suspend(void)
 
 	shutting_down = SHUTDOWN_SUSPEND;
 
-#ifdef CONFIG_PREEMPT
-	/* If the kernel is preemptible, we need to freeze all the processes
-	   to prevent them from being in the middle of a pagetable update
-	   during suspend. */
 	err = freeze_processes();
 	if (err) {
 		pr_err("%s: freeze failed %d\n", __func__, err);
 		goto out;
 	}
-#endif
 
 	err = dpm_suspend_start(PMSG_FREEZE);
 	if (err) {
@@ -172,10 +167,8 @@ out_resume:
 	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
 out_thaw:
-#ifdef CONFIG_PREEMPT
 	thaw_processes();
 out:
-#endif
 	shutting_down = SHUTDOWN_INVALID;
 }
 #endif	/* CONFIG_HIBERNATE_CALLBACKS */
-- 
1.9.1

