Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136AbaKAWkm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:40:42 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60372 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751860AbaKAWjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:35 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "David Vrabel" <david.vrabel@citrix.com>,
        "Ross Lagerwall" <ross.lagerwall@citrix.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.405113527@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 021/102] xen/manage: Always freeze/thaw processes when
 suspend/resuming
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/xen/manage.c | 7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -108,16 +108,11 @@ static void do_suspend(void)
 
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
@@ -172,10 +167,8 @@ out_resume:
 	clock_was_set();
 
 out_thaw:
-#ifdef CONFIG_PREEMPT
 	thaw_processes();
 out:
-#endif
 	shutting_down = SHUTDOWN_INVALID;
 }
 #endif	/* CONFIG_HIBERNATE_CALLBACKS */

