Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031712AbaGDWta (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jul 2014 18:49:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57334 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030974AbaGDWUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jul 2014 18:20:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Asai Thambi S P <asamymuthupa@micron.com>, Jens Axboe <axboe@fb.com>
Subject: [PATCH 3.14 13/59] mtip32xx: Remove dfs_parent after pci unregister
Date: Fri,  4 Jul 2014 15:19:02 -0700
Message-Id: <20140704221540.160502462@linuxfoundation.org>
X-Mailer: git-send-email 2.0.1
In-Reply-To: <20140704221539.544876024@linuxfoundation.org>
References: <20140704221539.544876024@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asai Thambi S P <asamymuthupa@micron.com>

commit af5ded8ccf21627f9614afc03b356712666ed225 upstream.

In module exit, dfs_parent and it's subtree were removed before
unregistering with pci. When debugfs entry for each device is attempted
to remove in pci_remove() context, they don't exist, as dfs_parent and
its children were already ripped apart.

Modified to first unregister with pci and then remove dfs_parent.

Signed-off-by: Asai Thambi S P <asamymuthupa@micron.com>
Signed-off-by: Jens Axboe <axboe@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/mtip32xx/mtip32xx.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -4990,13 +4990,13 @@ static int __init mtip_init(void)
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


