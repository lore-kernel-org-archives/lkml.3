Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365AbaKFSMa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 13:12:30 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34656 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaKFSM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 13:12:28 -0500
To: Chris Friesen <chris.friesen@windriver.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: absurdly high "optimal_io_size" on Seagate SAS disk
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
References: <545BA625.40308@windriver.com> <545BAD05.3050800@windriver.com>
	<yq1k338b5d5.fsf@sermon.lab.mkp.net> <545BB3AB.8070409@windriver.com>
Date: Thu, 06 Nov 2014 13:12:17 -0500
In-Reply-To: <545BB3AB.8070409@windriver.com> (Chris Friesen's message of
	"Thu, 6 Nov 2014 11:45:15 -0600")
Message-ID: <yq1fvdwb3lq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Chris" == Chris Friesen <chris.friesen@windriver.com> writes:

Chris> That'd work, but is it the best way to go?  I mean, I found one
Chris> report of a similar problem on an SSD (model number unknown).  In
Chris> that case it was a near-UINT_MAX value as well.

My concern is still the same. Namely that this particular drive happens
to be returning UINT_MAX but it might as well be a value that's entirely
random. Or even a value that is small and innocuous looking but
completely wrong.

Chris> The problem with the blacklist is that until someone patches it,
Chris> the drive is broken.  And then it stays blacklisted even if the
Chris> firmware gets fixed.

Well, you can manually blacklist in /proc/scsi/device_info.

Chris> I'm wondering if it might not be better to just ignore all values
Chris> larger than X (where X is whatever we think is the largest
Chris> conceivable reasonable value).

The problem is that finding that is not easy and it too will be a moving
target.

I'm willing to entertain the following, however...

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 95bfb7bfbb9d..75cc51a01860 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2593,7 +2593,8 @@ static void sd_read_block_limits(struct scsi_disk *sdkp)
 	blk_queue_io_min(sdkp->disk->queue,
 			 get_unaligned_be16(&buffer[6]) * sector_sz);
 	blk_queue_io_opt(sdkp->disk->queue,
-			 get_unaligned_be32(&buffer[12]) * sector_sz);
+			 min_t(u32, get_unaligned_be32(&buffer[12]),
+			       sdkp->capacity) * sector_sz);
 
 	if (buffer[3] == 0x3c) {
 		unsigned int lba_count, desc_count;

-- 
Martin K. Petersen	Oracle Linux Engineering
