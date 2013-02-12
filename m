Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933301Ab3BLQGd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 11:06:33 -0500
Received: from mail-vc0-f171.google.com ([209.85.220.171]:59679 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933270Ab3BLQGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 11:06:31 -0500
From: Paolo Bonzini <pbonzini@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: <nbd-general@lists.sf.net>, Paul Clements <Paul.Clements@steeleye.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] nbd: show read-only state in sysfs
Date: Tue, 12 Feb 2013 17:06:11 +0100
Message-Id: <1360685171-3792-4-git-send-email-pbonzini@redhat.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
References: <1360685171-3792-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pass the read-only flag to set_device_ro, so that it will be
visible to the block layer and in sysfs.

Cc: <nbd-general@lists.sf.net>
Cc: Paul Clements <Paul.Clements@steeleye.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
---
 drivers/block/nbd.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index a9c5c7a..ef17c2e 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -703,6 +703,8 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 
 		mutex_unlock(&nbd->tx_lock);
 
+		if (nbd->flags & NBD_FLAG_READ_ONLY)
+			set_device_ro(bdev, true);
 		if (nbd->flags & NBD_FLAG_SEND_TRIM)
 			queue_flag_set_unlocked(QUEUE_FLAG_DISCARD,
 				nbd->disk->queue);
@@ -730,6 +732,7 @@ static int __nbd_ioctl(struct block_device *bdev, struct nbd_device *nbd,
 		dev_warn(disk_to_dev(nbd->disk), "queue cleared\n");
 		kill_bdev(bdev);
 		queue_flag_clear_unlocked(QUEUE_FLAG_DISCARD, nbd->disk->queue);
+		set_device_ro(bdev, false);
 		if (file)
 			fput(file);
 		nbd->flags = 0;
-- 
1.7.1

