Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965939AbaGRNUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 09:20:37 -0400
Received: from bband-dyn38.178-41-141.t-com.sk ([178.41.141.38]:18008 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1761617AbaGRNTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 09:19:30 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Asai Thambi S P <asamymuthupa@micron.com>,
        Jens Axboe <axboe@fb.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 018/170] mtip32xx: Remove dfs_parent after pci unregister
Date: Fri, 18 Jul 2014 14:10:23 +0200
Message-Id: <99579b19a034c87f814f9243434c2974cdde3e48.1405685481.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
References: <48e8cad86bb1241c08bdaa80db022c25068ff8e0.1405685481.git.jslaby@suse.cz>
In-Reply-To: <cover.1405685481.git.jslaby@suse.cz>
References: <cover.1405685481.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Asai Thambi S P <asamymuthupa@micron.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit af5ded8ccf21627f9614afc03b356712666ed225 upstream.

In module exit, dfs_parent and it's subtree were removed before
unregistering with pci. When debugfs entry for each device is attempted
to remove in pci_remove() context, they don't exist, as dfs_parent and
its children were already ripped apart.

Modified to first unregister with pci and then remove dfs_parent.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/block/mtip32xx/mtip32xx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 6fc6beb86493..560227b817fe 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4785,13 +4785,13 @@ static int __init mtip_init(void)
  */
 static void __exit mtip_exit(void)
 {
-	debugfs_remove_recursive(dfs_parent);
-
 	/* Release the allocated major block device number. */
 	unregister_blkdev(mtip_major, MTIP_DRV_NAME);
 
 	/* Unregister the PCI driver. */
 	pci_unregister_driver(&mtip_pci_driver);
+
+	debugfs_remove_recursive(dfs_parent);
 }
 
 MODULE_AUTHOR("Micron Technology, Inc");
-- 
2.0.0

