Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933485AbaGOTex (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 15:34:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31394 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933453AbaGOTei (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 15:34:38 -0400
Date: Tue, 15 Jul 2014 15:34:13 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>, Mike Snitzer <msnitzer@redhat.com>,
        Jonathan Brassow <jbrassow@redhat.com>,
        Edward Thornber <thornber@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>
cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [PATCH 0/15] SCSI XCOPY support for the kernel and device mapper
Message-ID: <alpine.LRH.2.02.1407151531140.14632@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series makes it possible to use SCSI XCOPY offload for the 
block layer and device mapper.

It is based on Martin Petersen's work
https://git.kernel.org/cgit/linux/kernel/git/mkp/linux.git/commit/?h=xcopy&id=0bdeed274e16b3038a851552188512071974eea8,
but it is changed significantly so that it is possible to propagate XCOPY
bios through the device mapper stack.

The basic architecture is this: in the function blkdev_issue_copy we
create two bios, one for read and one for write (with bi_rw READ|REQ_COPY
and WRITE|REQ_COPY). Both bios have a pointer to the same bio_copy
structure. These two bios travel independently through the device mapper
stack - each bio can go through different device mapper devices. When both
the bios reach the physical block device (in the function blk_queue_bio)
the bio pair is collected and a XCOPY request is allocated and sent to the
scsi disk driver.

Note that because device mapper mapping can dynamically change, there no
guarantee that the XCOPY command succeeds. If it ends with an error, the
caller is supposed to perform the copying manually.

The dm-kcopyd subsystem is modified to use the XCOPY command, so device
mapper targets that use it (mirror, snapshot, thin, cache) take advantage
of copy offload automatically.

There is a new ioctl BLKCOPY that makes it possible to use copy offload
from userspace.
