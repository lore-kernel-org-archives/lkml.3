Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753894AbaIHNVr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 09:21:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41321 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121AbaIHNVq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 09:21:46 -0400
From: Vitaly Kuznetsov <vkuznets@redhat.com>
To: xen-devel@lists.xenproject.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>,
        Andrew Jones <drjones@redhat.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] xen/blkback: unmap all persistent grants when frontend gets disconnected
Date: Mon,  8 Sep 2014 15:21:33 +0200
Message-Id: <1410182493-23638-1-git-send-email-vkuznets@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blkback does not unmap persistent grants when frontend goes to Closed
state (e.g. when blkfront module is being removed). This leads to the
following in guest's dmesg:

[  343.243825] xen:grant_table: WARNING: g.e. 0x445 still in use!
[  343.243825] xen:grant_table: WARNING: g.e. 0x42a still in use!
...

When load module -> use device -> unload module sequence is performed multiple times
it is possible to hit BUG() condition in blkfront module:

[  343.243825] kernel BUG at drivers/block/xen-blkfront.c:954!
[  343.243825] invalid opcode: 0000 [#1] SMP
[  343.243825] Modules linked in: xen_blkfront(-) ata_generic pata_acpi [last unloaded: xen_blkfront]
...
[  343.243825] Call Trace:
[  343.243825]  [<ffffffff814111ef>] ? unregister_xenbus_watch+0x16f/0x1e0
[  343.243825]  [<ffffffffa0016fbf>] blkfront_remove+0x3f/0x140 [xen_blkfront]
...
[  343.243825] RIP  [<ffffffffa0016aae>] blkif_free+0x34e/0x360 [xen_blkfront]
[  343.243825]  RSP <ffff88001eb8fdc0>

We don't need to keep these grants if we're disconnecting as frontend might already
forgot about them. Solve the issue by moving xen_blkbk_free_caches() call from
xen_blkif_free() to xen_blkif_disconnect().

Now we can see the following:
[  928.590893] xen:grant_table: WARNING: g.e. 0x587 still in use!
[  928.591861] xen:grant_table: WARNING: g.e. 0x372 still in use!
...
[  929.592146] xen:grant_table: freeing g.e. 0x587
[  929.597174] xen:grant_table: freeing g.e. 0x372
...

Backend does not keep persistent grants any more, reconnect works fine.

Signed-off-by: Vitaly Kuznetsov <vkuznets@redhat.com>
---
 drivers/block/xen-blkback/xenbus.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/xen-blkback/xenbus.c b/drivers/block/xen-blkback/xenbus.c
index 3a8b810..54f4089 100644
--- a/drivers/block/xen-blkback/xenbus.c
+++ b/drivers/block/xen-blkback/xenbus.c
@@ -270,6 +270,9 @@ static int xen_blkif_disconnect(struct xen_blkif *blkif)
 		blkif->blk_rings.common.sring = NULL;
 	}
 
+	/* Remove all persistent grants and the cache of ballooned pages. */
+	xen_blkbk_free_caches(blkif);
+
 	return 0;
 }
 
@@ -281,9 +284,6 @@ static void xen_blkif_free(struct xen_blkif *blkif)
 	xen_blkif_disconnect(blkif);
 	xen_vbd_free(&blkif->vbd);
 
-	/* Remove all persistent grants and the cache of ballooned pages. */
-	xen_blkbk_free_caches(blkif);
-
 	/* Make sure everything is drained before shutting down */
 	BUG_ON(blkif->persistent_gnt_c != 0);
 	BUG_ON(atomic_read(&blkif->persistent_gnt_in_use) != 0);
-- 
1.9.3

