Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaHDLYZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 07:24:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57225 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751181AbaHDLYY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 07:24:24 -0400
From: jgross@suse.com
To: James.Bottomley@HansenPartnership.com, hch@infradead.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V4] Save command pool address of Scsi_Host
Date: Mon,  4 Aug 2014 13:24:20 +0200
Message-Id: <1407151460-26888-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.

This will result in an access error when the host is removed.

Avoid the problem by saving the address of a new allocated command pool where
it is expected.

Signed-off-by: Juergen Gross <jgross@suse.com>
---
 drivers/scsi/scsi.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index 88d46fe..f654ac1 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -380,6 +380,10 @@ scsi_alloc_host_cmd_pool(struct Scsi_Host *shost)
 		pool->slab_flags |= SLAB_CACHE_DMA;
 		pool->gfp_mask = __GFP_DMA;
 	}
+
+	if (hostt->cmd_size)
+		hostt->cmd_pool = pool;
+
 	return pool;
 }
 
@@ -424,8 +428,10 @@ out:
 out_free_slab:
 	kmem_cache_destroy(pool->cmd_slab);
 out_free_pool:
-	if (hostt->cmd_size)
-		scsi_free_host_cmd_pool(pool);
+	if (hostt->cmd_size) {
+		scsi_free_host_cmd_pool(hostt->cmd_pool);
+		hostt->cmd_pool = NULL;
+	}
 	goto out;
 }
 
@@ -447,8 +453,10 @@ static void scsi_put_host_cmd_pool(struct Scsi_Host *shost)
 	if (!--pool->users) {
 		kmem_cache_destroy(pool->cmd_slab);
 		kmem_cache_destroy(pool->sense_slab);
-		if (hostt->cmd_size)
-			scsi_free_host_cmd_pool(pool);
+		if (hostt->cmd_size) {
+			scsi_free_host_cmd_pool(hostt->cmd_pool);
+			hostt->cmd_pool = NULL;
+		}
 	}
 	mutex_unlock(&host_cmd_pool_mutex);
 }
-- 
1.8.4.5

