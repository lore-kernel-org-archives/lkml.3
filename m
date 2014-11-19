Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932940AbaKSVuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 16:50:13 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56599 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933532AbaKSVE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 16:04:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: [PATCH 3.14 067/122] md: Always set RECOVERY_NEEDED when clearing RECOVERY_FROZEN
Date: Wed, 19 Nov 2014 12:51:57 -0800
Message-Id: <20141119205211.027216705@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205208.812884198@linuxfoundation.org>
References: <20141119205208.812884198@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5333,6 +5333,7 @@ static int md_set_readonly(struct mddev
 		printk("md: %s still in use.\n",mdname(mddev));
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			md_wakeup_thread(mddev->thread);
 		}
 		err = -EBUSY;
@@ -5347,6 +5348,8 @@ static int md_set_readonly(struct mddev
 		mddev->ro = 1;
 		set_disk_ro(mddev->gendisk, 1);
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+		md_wakeup_thread(mddev->thread);
 		sysfs_notify_dirent_safe(mddev->sysfs_state);
 		err = 0;
 	}
@@ -5390,6 +5393,7 @@ static int do_md_stop(struct mddev * mdd
 		mutex_unlock(&mddev->open_mutex);
 		if (did_freeze) {
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 			md_wakeup_thread(mddev->thread);
 		}
 		return -EBUSY;


