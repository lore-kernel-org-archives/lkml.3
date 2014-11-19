Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933168AbaKSU7t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:59:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56064 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbaKSUyT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:19 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.17 103/141] md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN
Date: Wed, 19 Nov 2014 12:52:06 -0800
Message-Id: <20141119205154.014293924@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.de>

commit 45eaf45dfa4850df16bc2e8e7903d89021137f40 upstream.

md_check_recovery will skip any recovery and also clear
MD_RECOVERY_NEEDED if MD_RECOVERY_FROZEN is set.
So when we clear _FROZEN, we must set _NEEDED and ensure that
md_check_recovery gets run.
Otherwise we could miss out on something that is needed.

In particular, this can make it impossible to remove a
failed device from an array is the  'recovery-needed' processing
didn't happen.
Suitable for stable kernels since 3.13.

Reported-and-tested-by: Joe Lawrence <joe.lawrence@stratus.com>
Fixes: 30b8feb730f9b9b3c5de02580897da03f59b6b16
Signed-off-by: NeilBrown <neilb@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/md.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5313,6 +5313,7 @@ static int md_set_readonly(struct mddev
 		printk("md: %s still in use.\n",mdname(mddev));
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			md_wakeup_thread(mddev->thread);
 		}
 		err = -EBUSY;
@@ -5327,6 +5328,8 @@ static int md_set_readonly(struct mddev
 		mddev->ro = 1;
 		set_disk_ro(mddev->gendisk, 1);
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 		err = 0;
 	}
@@ -5370,6 +5373,7 @@ static int do_md_stop(struct mddev * mdd
 		mutex_unlock(&mddev->open_mutex);
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			md_wakeup_thread(mddev->thread);
 		}
 		return -EBUSY;


