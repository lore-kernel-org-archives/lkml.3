Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271AbaJCVpK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 17:45:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45300 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756058AbaJCVnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 17:43:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ross Lagerwall <ross.lagerwall@citrix.com>,
        David Vrabel <david.vrabel@citrix.com>
Subject: [PATCH 3.16 213/357] xen/manage: Always freeze/thaw processes when suspend/resuming
Date: Fri,  3 Oct 2014 14:29:59 -0700
Message-Id: <20141003212939.927323093@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141003212933.458851516@linuxfoundation.org>
References: <20141003212933.458851516@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/xen/manage.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/xen/manage.c
+++ b/drivers/xen/manage.c
@@ -103,16 +103,11 @@ static void do_suspend(void)
 
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
@@ -157,10 +152,8 @@ out_resume:
 	dpm_resume_end(si.cancelled ? PMSG_THAW : PMSG_RESTORE);
 
 out_thaw:
-#ifdef CONFIG_PREEMPT
 	thaw_processes();
 out:
-#endif
 	shutting_down = SHUTDOWN_INVALID;
 }
 #endif	/* CONFIG_HIBERNATE_CALLBACKS */


