Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933729Ab3AOWwu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 17:52:50 -0500
Received: from mail.kernel.org ([198.145.19.201]:46977 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932834Ab3AOWwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 17:52:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Josh Durgin <josh.durgin@inktank.com>, Alex Elder <elder@inktank.com>
Subject: [ 134/171] rbd: only reset capacity when pointing to head
Date: Tue, 15 Jan 2013 14:44:59 -0800
Message-Id: <20130115224323.013575478@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.336.g94702dd
In-Reply-To: <20130115224313.394976595@linuxfoundation.org>
References: <20130115224313.394976595@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Josh Durgin <josh.durgin@inktank.com>

Snapshots cannot be resized, and the new capacity of head should not
be reflected by the snapshot.

Signed-off-by: Josh Durgin <josh.durgin@inktank.com>
Reviewed-by: Alex Elder <elder@inktank.com>
(cherry picked from commit 474ef7ce832d471148f63a9d07f67fc5564834f1)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1721,7 +1721,12 @@ static int __rbd_update_snaps(struct rbd
 		return ret;
 
 	/* resized? */
-	set_capacity(rbd_dev->disk, h.image_size / SECTOR_SIZE);
+	if (rbd_dev->snap_id == CEPH_NOSNAP) {
+		sector_t size = (sector_t) h.image_size / SECTOR_SIZE;
+
+		dout("setting size to %llu sectors", (unsigned long long) size);
+		set_capacity(rbd_dev->disk, size);
+	}
 
 	down_write(&rbd_dev->header_rwsem);
 


