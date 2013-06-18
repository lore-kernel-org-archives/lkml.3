Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933467Ab3FRQdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 12:33:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:49393 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab3FRQRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 12:17:41 -0400
From: Greg Kroah-Hartman <greg@kroah.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dan van der Ster <dan@vanderster.com>, Alex Elder <elder@inktank.com>,
        Josh Durgin <josh.durgin@inktank.com>
Subject: [ 07/48] rbd: dont destroy ceph_opts in rbd_add()
Date: Tue, 18 Jun 2013 09:17:33 -0700
Message-Id: <20130618161726.946190518@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130618161725.912524266@linuxfoundation.org>
References: <20130618161725.912524266@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

3.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/rbd.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -435,8 +435,8 @@ static const struct block_device_operati
 };
 
 /*
- * Initialize an rbd client instance.
- * We own *ceph_opts.
+ * Initialize an rbd client instance.  Success or not, this function
+ * consumes ceph_opts.
  */
 static struct rbd_client *rbd_client_create(struct ceph_options *ceph_opts)
 {
@@ -583,7 +583,8 @@ static int parse_rbd_opts_token(char *c,
 
 /*
  * Get a ceph client with specific addr and configuration, if one does
- * not exist create it.
+ * not exist create it.  Either way, ceph_opts is consumed by this
+ * function.
  */
 static struct rbd_client *rbd_get_client(struct ceph_options *ceph_opts)
 {
@@ -4104,7 +4105,6 @@ static ssize_t rbd_add(struct bus_type *
 		rc = PTR_ERR(rbdc);
 		goto err_out_args;
 	}
-	ceph_opts = NULL;	/* rbd_dev client now owns this */
 
 	/* pick the pool */
 	osdc = &rbdc->client->osdc;
@@ -4140,8 +4140,6 @@ err_out_rbd_dev:
 err_out_client:
 	rbd_put_client(rbdc);
 err_out_args:
-	if (ceph_opts)
-		ceph_destroy_options(ceph_opts);
 	kfree(rbd_opts);
 	rbd_spec_put(spec);
 err_out_module:


