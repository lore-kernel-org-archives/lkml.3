Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161425AbaDQDaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 23:30:21 -0400
Received: from mailout.micron.com ([137.201.242.129]:22502 "EHLO
	mailout.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754390AbaDQDaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 23:30:19 -0400
Message-ID: <534F4AC8.7040104@micron.com>
Date: Wed, 16 Apr 2014 20:30:16 -0700
From: Asai Thambi S P <asamymuthupa@micron.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101 Thunderbird/28.0
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Sam Bradshaw <sbradshaw@micron.com>
Subject: mtip32xx: Remove dfs_parent after pci unregister
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-7.000.1014-20636.004
X-TM-AS-Result: No--4.446300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-MT-CheckInternalSenderRule: True
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


In module exit, dfs_parent and it's subtree were removed before unregistering
with pci. When debugfs entry for each device is attempted to remove in
pci_remove() context, they don't exist, as dfs_parent and its children were
already ripped apart.

Modified to first unregister with pci and then remove dfs_parent.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
---
 drivers/block/mtip32xx/mtip32xx.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/mtip32xx.c
index 51628eb..27641bc 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4939,13 +4939,13 @@ static int __init mtip_init(void)
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
1.7.1

