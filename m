Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145AbaEDQgw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 May 2014 12:36:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36160 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754141AbaEDPls (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 May 2014 11:41:48 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sagi Grimberg <sagig@mellanox.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>,
        Giridhar Malavali <giridhar.malavali@qlogic.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH 3.14 094/158] target/iblock: Fix double bioset_integrity_free bug
Date: Sun,  4 May 2014 11:40:03 -0400
Message-Id: <20140504154042.713093204@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140504154029.975081050@linuxfoundation.org>
References: <20140504154029.975081050@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Bellinger <nab@linux-iscsi.org>

commit d84287bcfe624697cd4f3c1df746beb53b86d9c4 upstream.

This patch fixes a double free bug during IBLOCK backend shutdown
where bioset_integrity_free() was incorrectly called ahead of
bioset_free(), who is already making the same call directly.

This bug was introduced with commit ecebbf6cc, and will end up
triggering a general protection fault in iblock_free_device()

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Cc: Quinn Tran <quinn.tran@qlogic.com>
Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/target/target_core_iblock.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -203,10 +203,9 @@ static void iblock_free_device(struct se
 
 	if (ib_dev->ibd_bd != NULL)
 		blkdev_put(ib_dev->ibd_bd, FMODE_WRITE|FMODE_READ|FMODE_EXCL);
-	if (ib_dev->ibd_bio_set != NULL) {
-		bioset_integrity_free(ib_dev->ibd_bio_set);
+	if (ib_dev->ibd_bio_set != NULL)
 		bioset_free(ib_dev->ibd_bio_set);
-	}
+
 	kfree(ib_dev);
 }
 


