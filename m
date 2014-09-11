Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaIKMii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:38:38 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51691 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755465AbaIKMeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:09 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "NeilBrown" <neilb@suse.de>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.543053930@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 032/131] md/raid1,raid10: always abort recover on
 write error.
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 2446dba03f9dabe0b477a126cbeb377854785b47 upstream.

Currently we don't abort recovery on a write error if the write error
to the recovering device was triggerd by normal IO (as opposed to
recovery IO).

This means that for one bitmap region, the recovery might write to the
recovering device for a few sectors, then not bother for subsequent
sectors (as it never writes to failed devices).  In this case
the bitmap bit will be cleared, but it really shouldn't.

The result is that if the recovering device fails and is then re-added
(after fixing whatever hardware problem triggerred the failure),
the second recovery won't redo the region it was in the middle of,
so some of the device will not be recovered properly.

If we abort the recovery, the region being processes will be cancelled
(bit not cleared) and the whole region will be retried.

As the bug can result in data corruption the patch is suitable for
-stable.  For kernels prior to 3.11 there is a conflict in raid10.c
which will require care.

Original-from: jiao hui <jiaohui@bwstor.com.cn>
Reported-and-tested-by: jiao hui <jiaohui@bwstor.com.cn>
Signed-off-by: NeilBrown <neilb@suse.de>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1233,12 +1233,12 @@ static void error(struct mddev *mddev, s
 		mddev->degraded++;
 		set_bit(Faulty, &rdev->flags);
 		spin_unlock_irqrestore(&conf->device_lock, flags);
-		/*
-		 * if recovery is running, make sure it aborts.
-		 */
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	} else
 		set_bit(Faulty, &rdev->flags);
+	/*
+	 * if recovery is running, make sure it aborts.
+	 */
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);
 	printk(KERN_ALERT
 	       "md/raid1:%s: Disk failure on %s, disabling device.\n"
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1272,11 +1272,11 @@ static void error(struct mddev *mddev, s
 		spin_lock_irqsave(&conf->device_lock, flags);
 		mddev->degraded++;
 		spin_unlock_irqrestore(&conf->device_lock, flags);
-		/*
-		 * if recovery is running, make sure it aborts.
-		 */
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	}
+	/*
+	 * If recovery is running, make sure it aborts.
+	 */
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 	set_bit(Blocked, &rdev->flags);
 	set_bit(Faulty, &rdev->flags);
 	set_bit(MD_CHANGE_DEVS, &mddev->flags);

