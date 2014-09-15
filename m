Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900AbaIOVEf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:04:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754964AbaIOT07 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Juergen Gross <jgross@suse.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <JBottomley@Parallels.com>
Subject: [PATCH 3.16 058/158] SCSI: save command pool address of Scsi_Host
Date: Mon, 15 Sep 2014 12:24:57 -0700
Message-Id: <20140915192544.634791812@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Juergen Gross <jgross@suse.com>

commit f6105c0808880c2c432b79bc81b37cc244c300c8 upstream.

If a scsi host driver specifies .cmd_len in it's scsi_host_template, a driver's
private command pool is needed. scsi_find_host_cmd_pool() will locate it, but
scsi_alloc_host_cmd_pool() isn't saving the pool address in the host template.

This will result in an access error when the host is removed.

Avoid the problem by saving the address of a new allocated command pool where
it is expected.

Signed-off-by: Juergen Gross <jgross@suse.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Fixes: 89d9a567952baec13e26ada3e438f1b642d66b6e
Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -380,6 +380,10 @@ scsi_alloc_host_cmd_pool(struct Scsi_Hos
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
+	if (hostt->cmd_size) {
 		scsi_free_host_cmd_pool(pool);
+		hostt->cmd_pool = NULL;
+	}
 	goto out;
 }
 
@@ -447,8 +453,10 @@ static void scsi_put_host_cmd_pool(struc
 	if (!--pool->users) {
 		kmem_cache_destroy(pool->cmd_slab);
 		kmem_cache_destroy(pool->sense_slab);
-		if (hostt->cmd_size)
+		if (hostt->cmd_size) {
 			scsi_free_host_cmd_pool(pool);
+			hostt->cmd_pool = NULL;
+		}
 	}
 	mutex_unlock(&host_cmd_pool_mutex);
 }


