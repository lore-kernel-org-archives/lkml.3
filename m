Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751857AbaJKGa4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 02:30:56 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:51982 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751171AbaJKGay (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 02:30:54 -0400
Date: Fri, 10 Oct 2014 23:30:53 -0700
From: Petr Vandrovec <petr@vmware.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Arvind Kumar <arvindkumar@vmware.com>,
        Chris J Arges <chris.j.arges@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, Petr Vandrovec <petr@vmware.com>
Subject: [PATCH] Do not silently discard WRITE_SAME requests
Message-ID: <20141011063053.GB18215@petr-dev3.eng.vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
  it was brought to my attention that there are claims of data corruption
caused by VMware's SCSI implementation.  After investigating, problem
seems to be in a way completion handler for WRITE_SAME handles EOPNOTSUPP
error, causing all-but-first WRITE_SAME request on the LVM device to be
silently ignored - command is never issued, but success is returned to
higher layers.  Problem affects all disks without WRITE_SAME support -
and I guess VMware's SCSI emulation is one of few that do not support
this command ATM.

Please apply patch below.
					Thanks,
						Petr Vandrovec

From: Petr Vandrovec <petr@vmware.com>
Subject: [PATCH] Do not silently discard WRITE_SAME requests


When device does not support WRITE_SAME, after first failure
block layer starts throwing away WRITE_SAME requests without
warning anybody, leading to the data corruption.

Let's do something about it - do not use EOPNOTSUPP error,
as apparently that error code is special (use EREMOTEIO, AKA
target failure, like when request hits hardware), and propagate
inabiity to do WRITE_SAME to the top of stack, so we do not
try to issue WRITE_SAME again and again.

It also reverts 4089b71cc820a426d601283c92fcd4ffeb5139c2, as
there is nothing wrong with VMware's WRITE_SAME emulation.
Only problem was that block layer did not issue WRITE_SAME
request at all, but reported success, and it affected all
disks that do not support WRITE_SAME.

Signed-off-by: Petr Vandrovec <petr@vmware.com>
Cc: Arvind Kumar <arvindkumar@vmware.com>
Cc: Chris J Arges <chris.j.arges@canonical.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: stable@vger.kernel.org
---
 block/blk-core.c                |  2 +-
 block/blk-lib.c                 | 10 ++++++++++
 drivers/message/fusion/mptspi.c |  5 -----
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9c888bd..b070782 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1822,7 +1822,7 @@ generic_make_request_checks(struct bio *bio)
 	}
 
 	if (bio->bi_rw & REQ_WRITE_SAME && !bdev_write_same(bio->bi_bdev)) {
-		err = -EOPNOTSUPP;
+		err = -EREMOTEIO;
 		goto end_io;
 	}
 
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 8411be3..abad72d 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -298,6 +298,16 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 					     ZERO_PAGE(0)))
 			return 0;
 
+		/*
+		 * If WRITE_SAME failed, inability to perform WRITE_SAME was
+		 * possibly recorded in device's queue by sd.c.  But in case
+		 * of LVM we are issuing request here on LVM device.  So
+		 * we should mark device as ineligible for WRITE_SAME here too,
+		 * as otherwise we keep trying to submit WRITE_SAME again and
+		 * again to LVM where they get promptly rejected by underlying
+		 * disk queue.
+		 */
+		blk_queue_max_write_same_sectors(bdev_get_queue(bdev), 0);
 		bdevname(bdev, bdn);
 		pr_err("%s: WRITE SAME failed. Manually zeroing.\n", bdn);
 	}
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 613231c..787933d 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1419,11 +1419,6 @@ mptspi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto out_mptspi_probe;
         }
 
-	/* VMWare emulation doesn't properly implement WRITE_SAME
-	 */
-	if (pdev->subsystem_vendor == 0x15AD)
-		sh->no_write_same = 1;
-
 	spin_lock_irqsave(&ioc->FreeQlock, flags);
 
 	/* Attach the SCSI Host to the IOC structure
-- 
2.1.1

