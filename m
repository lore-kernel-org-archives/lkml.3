Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751272AbaJLGSI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 02:18:08 -0400
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:45688 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750802AbaJLGSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 02:18:05 -0400
Message-ID: <543A1D1A.8090808@vmware.com>
Date: Sat, 11 Oct 2014 23:18:02 -0700
From: Petr Vandrovec <petr@vmware.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Martin K. Petersen" <martin.petersen@oracle.com>
CC: Jens Axboe <axboe@kernel.dk>, Arvind Kumar <arvindkumar@vmware.com>,
        Chris J Arges <chris.j.arges@canonical.com>,
        Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Do not silently discard WRITE_SAME requests
References: <20141011063053.GB18215@petr-dev3.eng.vmware.com> <yq1lhomahwt.fsf@sermon.lab.mkp.net>
In-Reply-To: <yq1lhomahwt.fsf@sermon.lab.mkp.net>
Content-Type: multipart/mixed;
 boundary="------------070109080706090206050800"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------070109080706090206050800
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 10/11/2014 5:51 AM, Martin K. Petersen wrote:
>>>>>> "Petr" == Petr Vandrovec <petr@vmware.com> writes:
>
> Petr> After investigating, problem seems to be in a way completion
> Petr> handler for WRITE_SAME handles EOPNOTSUPP error, causing
> Petr> all-but-first WRITE_SAME request on the LVM device to be silently
> Petr> ignored - command is never issued, but success is returned to
> Petr> higher layers.
>
> Commit 7eee4ae2dbb2 was meant to address this issue. Does it still
> happen with that in place?

Hi,
   that commit alleviates need for change to blk-lib.c.  But I believe 
that change to blk-core.c that changes return value from EOPNOTSUPP to 
EREMOTEIO is still necessary - unless I'm missing some locking 
somewhere, there is a race in blkdev_issue_write_same() wrt. updating 
max_write_same_sectors:

blkdev_issue_write_same() checks whether max_write_same_sectors is 
non-zero at the beginning, and if it is non-zero it proceeds with 
generating BIOs.  While it generates them, other thread seems to be able 
to complete previously issued write_same, find it is not supported, and 
clear max_write_same_sectors.  Which means that BIOs that are now being 
generated will fast-fail in blk-core.c with EOPNOTSUPP, and 
blkdev_issue_write_same() will then return success, rather than failure.

It is true that now WRITE_SAME is failing only if second WRITE_SAME is 
issued to the device while first ever issued WRITE_SAME on the device is 
being completed, but I see no reason why to not close this race.

Logic (from 2011, commit 8af1954d172a46a63e5e79dae523a6d74715e458) says 
that EOPNOTSUPP is returned when DISCARD request failed, as discarding 
is optional, and failures can be safely ignored.  That is definitely not 
true for WRITE_SAME failures, and so unsupported WRITE_SAME should 
return different error code than unsupported DISCARD.

Which is what patch does.  I've removed part that propagates disabling 
WRITE_SAME from the diff, keeping only EOPNOTSUPP => EREMOTEIO change, 
and revert of blacklisting VMware's LSI (if anything, blacklist should 
be for current firmware version of 'VMware Virtual SCSI Disk', as f.e. 
passed-through (RDM) SCSI disks do support WRITE_SAME under VMware) -- 
see attached updated diff.
					Petr Vandrovec


--------------070109080706090206050800
Content-Type: text/plain; charset=windows-1252;
 name="0001-Do-not-silently-discard-WRITE_SAME-requests.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-Do-not-silently-discard-WRITE_SAME-requests.patch"

>From 975c1f8be719bb297de4bbf704cc5a58edee62b6 Mon Sep 17 00:00:00 2001
From: Petr Vandrovec <petr@vandrovec.name>
Date: Fri, 10 Oct 2014 23:10:25 -0700
Subject: [PATCH] Do not silently discard WRITE_SAME requests

When device does not support WRITE_SAME, after first failure
block layer starts throwing away WRITE_SAME requests without
warning anybody, leading to the data corruption.

Let's do something about it - do not use EOPNOTSUPP error,
as that error code is special, reserved for DISCARD, and
return EREMOTEIO, AKA target failure, like when request
hits hardware..

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
 block/blk-core.c                | 2 +-
 drivers/message/fusion/mptspi.c | 5 -----
 2 files changed, 1 insertion(+), 6 deletions(-)

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


--------------070109080706090206050800--
