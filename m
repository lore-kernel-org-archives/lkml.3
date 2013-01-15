Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758642Ab3AOWkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:40:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:43998 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932320Ab3AOWgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:36:22 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Alex Elder <elder@inktank.com>, Josh Durgin <josh.durgin@inktank.com>
Subject: [ 209/221] rbd: remove snapshots on error in rbd_add()
Date: Tue, 15 Jan 2013 10:52:16 -0800
Message-Id: <20130115185013.129387857@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115184958.025580322@linuxfoundation.org>
References: <20130115184958.025580322@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Alex Elder <elder@inktank.com>

(cherry picked from commit 41f38c2b2f8b66b176a0e548ef06294343a7bfa2)

If rbd_dev_snaps_update() has ever been called for an rbd device
structure there could be snapshot structures on its snaps list.
In rbd_add(), this function is called but a subsequent error
path neglected to clean up any of these snapshots.

Add a call to rbd_remove_all_snaps() in the appropriate spot to
remedy this.  Change a couple of error labels to be a little
clearer while there.

Drop the leading underscores from the function name; there's nothing
special about that function that they might signify.  As suggested
in review, the leading underscores in __rbd_remove_snap_dev() have
been removed as well.

Signed-off-by: Alex Elder <elder@inktank.com>
Reviewed-by: Josh Durgin <josh.durgin@inktank.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -221,7 +221,7 @@ static int rbd_dev_snaps_update(struct r
 static int rbd_dev_snaps_register(struct rbd_device *rbd_dev);
 
 static void rbd_dev_release(struct device *dev);
-static void __rbd_remove_snap_dev(struct rbd_snap *snap);
+static void rbd_remove_snap_dev(struct rbd_snap *snap);
 
 static ssize_t rbd_add(struct bus_type *bus, const char *buf,
 		       size_t count);
@@ -1710,13 +1710,13 @@ static int rbd_read_header(struct rbd_de
 	return ret;
 }
 
-static void __rbd_remove_all_snaps(struct rbd_device *rbd_dev)
+static void rbd_remove_all_snaps(struct rbd_device *rbd_dev)
 {
 	struct rbd_snap *snap;
 	struct rbd_snap *next;
 
 	list_for_each_entry_safe(snap, next, &rbd_dev->snaps, node)
-		__rbd_remove_snap_dev(snap);
+		rbd_remove_snap_dev(snap);
 }
 
 /*
@@ -2060,7 +2060,7 @@ static bool rbd_snap_registered(struct r
 	return ret;
 }
 
-static void __rbd_remove_snap_dev(struct rbd_snap *snap)
+static void rbd_remove_snap_dev(struct rbd_snap *snap)
 {
 	list_del(&snap->node);
 	if (device_is_registered(&snap->dev))
@@ -2442,7 +2442,7 @@ static int rbd_dev_snaps_update(struct r
 
 			if (rbd_dev->mapping.snap_id == snap->id)
 				rbd_dev->mapping.snap_exists = false;
-			__rbd_remove_snap_dev(snap);
+			rbd_remove_snap_dev(snap);
 			dout("%ssnap id %llu has been removed\n",
 				rbd_dev->mapping.snap_id == snap->id ?
 								"mapped " : "",
@@ -3053,11 +3053,11 @@ static ssize_t rbd_add(struct bus_type *
 	/* no need to lock here, as rbd_dev is not registered yet */
 	rc = rbd_dev_snaps_update(rbd_dev);
 	if (rc)
-		goto err_out_header;
+		goto err_out_probe;
 
 	rc = rbd_dev_set_mapping(rbd_dev, snap_name);
 	if (rc)
-		goto err_out_header;
+		goto err_out_snaps;
 
 	/* generate unique id: find highest unique id, add one */
 	rbd_dev_id_get(rbd_dev);
@@ -3121,7 +3121,9 @@ err_out_blkdev:
 	unregister_blkdev(rbd_dev->major, rbd_dev->name);
 err_out_id:
 	rbd_dev_id_put(rbd_dev);
-err_out_header:
+err_out_snaps:
+	rbd_remove_all_snaps(rbd_dev);
+err_out_probe:
 	rbd_header_free(&rbd_dev->header);
 err_out_client:
 	kfree(rbd_dev->header_name);
@@ -3219,7 +3221,7 @@ static ssize_t rbd_remove(struct bus_typ
 		goto done;
 	}
 
-	__rbd_remove_all_snaps(rbd_dev);
+	rbd_remove_all_snaps(rbd_dev);
 	rbd_bus_del_dev(rbd_dev);
 
 done:


