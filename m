Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756205Ab3KIPfj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 10:35:39 -0500
Received: from mail-qa0-f51.google.com ([209.85.216.51]:34123 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753785Ab3KIPfh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 10:35:37 -0500
From: Felipe Pena <felipensp@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org,
        Felipe Pena <felipensp@gmail.com>
Subject: [PATCH] block: xen-blkfront: Fix possible NULL ptr dereference
Date: Sat,  9 Nov 2013 13:36:09 -0200
Message-Id: <1384011369-4381-1-git-send-email-felipensp@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the blkif_release function the bdget_disk() call might returns
a NULL ptr which might be dereferenced on bdev->bd_openers checking

Signed-off-by: Felipe Pena <felipensp@gmail.com>
---
 drivers/block/xen-blkfront.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index a4660bb..7bb1552 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -1959,6 +1959,9 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
 
 	bdev = bdget_disk(disk, 0);
 
+	if (!bdev)
+		goto out_mutex;
+
 	if (bdev->bd_openers)
 		goto out;
 
@@ -1989,6 +1992,7 @@ static void blkif_release(struct gendisk *disk, fmode_t mode)
 
 out:
 	bdput(bdev);
+out_mutex:
 	mutex_unlock(&blkfront_mutex);
 }
 
-- 
1.7.10.4

