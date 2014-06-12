Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224AbaFLQBs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 12:01:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753049AbaFLQBr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 12:01:47 -0400
Date: Thu, 12 Jun 2014 19:02:08 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org
Subject: [PATCH] vhost-scsi: don't open-code kvfree
Message-ID: <1402588896-25446-1-git-send-email-mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mutt-Fcc: =sent
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we have kvfree, use it in vhost-scsi instead of
the open-coded version.

Cc: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

I have this queued for -rc2.
Nicholas could you review ack pls?

 drivers/vhost/scsi.c | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
index 83b834b..b08863e 100644
--- a/drivers/vhost/scsi.c
+++ b/drivers/vhost/scsi.c
@@ -1396,14 +1396,6 @@ static int vhost_scsi_set_features(struct vhost_scsi *vs, u64 features)
 	return 0;
 }
 
-static void vhost_scsi_free(struct vhost_scsi *vs)
-{
-	if (is_vmalloc_addr(vs))
-		vfree(vs);
-	else
-		kfree(vs);
-}
-
 static int vhost_scsi_open(struct inode *inode, struct file *f)
 {
 	struct vhost_scsi *vs;
@@ -1443,7 +1435,7 @@ static int vhost_scsi_open(struct inode *inode, struct file *f)
 	return 0;
 
 err_vqs:
-	vhost_scsi_free(vs);
+	kvfree(vs);
 err_vs:
 	return r;
 }
@@ -1462,7 +1454,7 @@ static int vhost_scsi_release(struct inode *inode, struct file *f)
 	/* Jobs can re-queue themselves in evt kick handler. Do extra flush. */
 	vhost_scsi_flush(vs);
 	kfree(vs->dev.vqs);
-	vhost_scsi_free(vs);
+	kvfree(vs);
 	return 0;
 }
 
-- 
MST
