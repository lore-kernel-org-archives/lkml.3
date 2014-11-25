Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755337AbaKYLUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:20:41 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58735 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577AbaKYKmU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:20 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ilya Dryomov <idryomov@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 146/254] rbd: rbd workqueues need a resque worker
Date: Tue, 25 Nov 2014 10:38:16 +0000
Message-Id: <1416912004-5928-147-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@redhat.com>

commit 792c3a914910bd34302c5345578f85cfcb5e2c01 upstream.

Need to use WQ_MEM_RECLAIM for our workqueues to prevent I/O lockups
under memory pressure - we sit on the memory reclaim path.

Signed-off-by: Ilya Dryomov <idryomov@redhat.com>
Tested-by: Micha Krause <micha@krausam.de>
Reviewed-by: Sage Weil <sage@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/block/rbd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 5c38fe1f4b85..3d2b99a15f62 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -5103,7 +5103,8 @@ static int rbd_dev_device_setup(struct rbd_device *rbd_dev)
 	set_capacity(rbd_dev->disk, rbd_dev->mapping.size / SECTOR_SIZE);
 	set_disk_ro(rbd_dev->disk, rbd_dev->mapping.read_only);
 
-	rbd_dev->rq_wq = alloc_workqueue("%s", 0, 0, rbd_dev->disk->disk_name);
+	rbd_dev->rq_wq = alloc_workqueue("%s", WQ_MEM_RECLAIM, 0,
+					 rbd_dev->disk->disk_name);
 	if (!rbd_dev->rq_wq) {
 		ret = -ENOMEM;
 		goto err_out_mapping;
-- 
2.1.0

