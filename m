Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754844Ab3FQRgI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 13:36:08 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50701 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754654Ab3FQRgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 13:36:03 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alex Elder <elder@inktank.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 62/84] rbd: don't destroy ceph_opts in rbd_add()
Date: Mon, 17 Jun 2013 10:31:06 -0700
Message-Id: <1371490288-23167-63-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1371490288-23167-1-git-send-email-kamal@canonical.com>
References: <1371490288-23167-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Elder <elder@inktank.com>

commit 7262cfca430a1a0e0707149af29ae86bc0ded230 upstream.

Whether rbd_client_create() successfully creates a new client or
not, it takes responsibility for getting the ceph_opts structure
it's passed destroyed.  If successful, the structure becomes
associated with the created client; if not, rbd_client_create()
will destroy it.

Previously, rbd_get_client() would call ceph_destroy_options()
if rbd_get_client() failed, and that meant it got called twice.
That led freeing various pointers more than once, which is never a
good idea.

This resolves:
    http://tracker.ceph.com/issues/4559

Reported-by: Dan van der Ster <dan@vanderster.com>
Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/block/rbd.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 89576a0..992dd78 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -329,8 +329,8 @@ static const struct block_device_operations rbd_bd_ops = {
 };
 
 /*
- * Initialize an rbd client instance.
- * We own *ceph_opts.
+ * Initialize an rbd client instance.  Success or not, this function
+ * consumes ceph_opts.
  */
 static struct rbd_client *rbd_client_create(struct ceph_options *ceph_opts)
 {
@@ -469,7 +469,8 @@ static int parse_rbd_opts_token(char *c, void *private)
 
 /*
  * Get a ceph client with specific addr and configuration, if one does
- * not exist create it.
+ * not exist create it.  Either way, ceph_opts is consumed by this
+ * function.
  */
 static struct rbd_client *rbd_get_client(struct ceph_options *ceph_opts)
 {
@@ -3629,7 +3630,6 @@ static ssize_t rbd_add(struct bus_type *bus,
 		rc = PTR_ERR(rbdc);
 		goto err_out_args;
 	}
-	ceph_opts = NULL;	/* rbd_dev client now owns this */
 
 	/* pick the pool */
 	osdc = &rbdc->client->osdc;
@@ -3658,8 +3658,6 @@ err_out_rbd_dev:
 err_out_client:
 	rbd_put_client(rbdc);
 err_out_args:
-	if (ceph_opts)
-		ceph_destroy_options(ceph_opts);
 	kfree(rbd_opts);
 	rbd_spec_put(spec);
 err_out_module:
-- 
1.8.1.2

