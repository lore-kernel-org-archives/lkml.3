Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283Ab3BFTvU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 14:51:20 -0500
Received: from mail-oa0-f43.google.com ([209.85.219.43]:33513 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030222Ab3BFTvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 14:51:01 -0500
From: Tejun Heo <tj@kernel.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Krishna C Gudipati <kgudipat@brocade.com>, linux-scsi@vger.kernel.org
Subject: [PATCH 60/77] scsi/bfa: convert to idr_alloc()
Date: Wed,  6 Feb 2013 11:40:32 -0800
Message-Id: <1360179649-22465-61-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.8.1
In-Reply-To: <1360179649-22465-1-git-send-email-tj@kernel.org>
References: <1360179649-22465-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert to the much saner new idr interface.

Only compile tested.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Krishna C Gudipati <kgudipat@brocade.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/bfa/bfad_im.c | 15 ++++-----------
 1 file changed, 4 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/bfa/bfad_im.c b/drivers/scsi/bfa/bfad_im.c
index 8f92732..5864f98 100644
--- a/drivers/scsi/bfa/bfad_im.c
+++ b/drivers/scsi/bfa/bfad_im.c
@@ -523,20 +523,13 @@ bfad_im_scsi_host_alloc(struct bfad_s *bfad, struct bfad_im_port_s *im_port,
 	int error = 1;
 
 	mutex_lock(&bfad_mutex);
-	if (!idr_pre_get(&bfad_im_port_index, GFP_KERNEL)) {
+	error = idr_alloc(&bfad_im_port_index, im_port, 0, 0, GFP_KERNEL);
+	if (error < 0) {
 		mutex_unlock(&bfad_mutex);
-		printk(KERN_WARNING "idr_pre_get failure\n");
+		printk(KERN_WARNING "idr_alloc failure\n");
 		goto out;
 	}
-
-	error = idr_get_new(&bfad_im_port_index, im_port,
-					 &im_port->idr_id);
-	if (error) {
-		mutex_unlock(&bfad_mutex);
-		printk(KERN_WARNING "idr_get_new failure\n");
-		goto out;
-	}
-
+	im_port->idr_id = error;
 	mutex_unlock(&bfad_mutex);
 
 	im_port->shost = bfad_scsi_host_alloc(im_port, bfad);
-- 
1.8.1

