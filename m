Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078AbaK0JTn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 04:19:43 -0500
Received: from mail.kernel.org ([198.145.19.201]:41344 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505AbaK0Iqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:46:43 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Ross Lagerwall <ross.lagerwall@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 19/91] xen/manage: Always freeze/thaw processes when suspend/resuming
Date: Thu, 27 Nov 2014 16:42:02 +0800
Message-Id: <1417077794-9299-19-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ross Lagerwall <ross.lagerwall@citrix.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/xen/manage.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/xen/manage.c b/drivers/xen/manage.c
index 412b96c..8da1ed1 100644
--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -109,16 +109,11 @@ static void do_suspend(void)
 
 	shutting_down = SHUTDOWN_SUSPEND;
 
-#ifdef CONFIG_PREEMPT
-	/* If the kernel is preemptible, we need to freeze all the processes
-	   to prevent them from being in the middle of a pagetable update
-	   during suspend. */
 	err = freeze_processes();
 	if (err) {
 		printk(KERN_ERR "xen suspend: freeze failed %d\n", err);
 		goto out;
 	}
-#endif
 
 	err = dpm_suspend_start(PMSG_FREEZE);
 	if (err) {
@@ -170,10 +165,8 @@ out_resume:
 	clock_was_set();
 
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

