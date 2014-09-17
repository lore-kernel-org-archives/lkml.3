Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaIQVzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:55:09 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:32207 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953AbaIQVzG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:55:06 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@fb.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: blk-mq timeout handling fixes
Thread-Topic: blk-mq timeout handling fixes
Thread-Index: AQHPz6vDys5MtkP7e0KOy6GRYKCHipwF2/Hw
Date: Wed, 17 Sep 2014 21:53:50 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C86C8E@G9W0745.americas.hpqcorp.net>
References: <1410651613-1993-1-git-send-email-hch@lst.de>
In-Reply-To: <1410651613-1993-1-git-send-email-hch@lst.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Saturday, 13 September, 2014 6:40 PM
> To: Jens Axboe
> Cc: Elliott, Robert (Server Storage); linux-scsi@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: blk-mq timeout handling fixes
> 
> This series fixes various issues with timeout handling that Robert
> ran into when testing scsi-mq heavily.  He tested an earlier version,
> and couldn't reproduce the issues anymore, although the series changed
> quite significantly since and should probably be retested.
> 
> In summary we not only start the blk-mq timer inside the drivers
> ->queue_rq method after the request has been fully setup, and we
> also tell the drivers if we're timing out a reserved (internal)
> request or a real one.  Many drivers including will need to handle
> those internal ones differently, e.g. for scsi-mq we don't even
> have a scsi command structure allocated for the reserved commands.

I have rerun a variety of tests on:
* Jens' for-next tree that went into 3.17rc5
* plus this series
* plus two patches for infinite recursion on flushes from 
  Ming and then Christoph

and have not been able to trigger the scsi_times_out req->special
NULL pointer dereference that prompted this series.

Testing includes:
* concurrent heavy workload generators:
  * fio high iodepth direct 512 byte random reads (> 1M IOPS)
  * programs generating large bursts of paged writes
    * mkfs.ext4 (followed by e2fsck)
    * mkfs.xfs (followed by xfs_check)
    * ddpt
  * watch -n 0 sync to generate flushes
* scsi_logging_level MLCOMPLETE set to 0 or 1
  * scsi_lib.c patched to put all the ACTION_FAIL messages
    under level 1 so they can be squelched (massive error 
    prints cause more timeouts themselves)
* 4 hpsa and 16 mpt3sas devices (all made from SAS SSDs)
  * lockless hpsa driver
* injecting errors
  * device removal
  * device generating infinite errors
  * device generating a brief number of errors

The filesystems don't always recover properly, but nothing in 
the block or scsi midlayers crashed.

So, you may add this to the series:
Tested-by: Robert Elliott <elliott@hp.com>

---
Rob Elliott    HP Server Storage




