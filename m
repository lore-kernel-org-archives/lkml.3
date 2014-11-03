Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193AbaKCPu5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 10:50:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbaKCPum (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 10:50:42 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: "Elliott\, Robert \(Server Storage\)" <Elliott@hp.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>, Jens Axboe <axboe@kernel.dk>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Boaz Harrosh <boaz@plexistor.com>, Nick Piggin <npiggin@kernel.dk>,
        "Kani\, Toshimitsu" <toshi.kani@hp.com>,
        "Knippers\, Linda" <linda.knippers@hp.com>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-nvdimm\@lists.01.org" <linux-nvdimm@ml01.01.org>
Subject: Re: [PATCH 1/4] pmem: Initial version of persistent memory driver
References: <1409173922-7484-1-git-send-email-ross.zwisler@linux.intel.com>
	<1409173922-7484-2-git-send-email-ross.zwisler@linux.intel.com>
	<94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 03 Nov 2014 10:50:32 -0500
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B4029593548AB@G9W0745.americas.hpqcorp.net>
	(Robert Elliott's message of "Sun, 2 Nov 2014 03:22:37 +0000")
Message-ID: <x49d294xozb.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Elliott, Robert (Server Storage)" <Elliott@hp.com> writes:

>> +config BLK_DEV_PMEM_COUNT
>> +	int "Default number of PMEM disks"
>> +	default "4"
>
> For real use I think a default of 1 would be better.

For "real" use, it will be the number of actual DIMMs, not a config
option, I would think.  I don't take any issue with defaulting to 4.
This will go away.

>> +	pmem->pmem_queue = blk_alloc_queue(GFP_KERNEL);
>> +	if (!pmem->pmem_queue)
>> +		goto out_free_dev;
>> +
>
> General comment:
> This driver should be blk-mq based.  Not doing so loses
> out on a number of SMP and NUMA performance improvements.
> For example, blk_alloc_queue calls blk_alloc_queue_node
> with NUMA_NO_NODE.  If it called blk_mq_init_queue, then
> each CPU would get structures located on its node.

No need to use blk-mq just to set the numa node, as the driver could
just call blk_alloc_queue_node itself.  I'd chalk this up to another
thing that could be fixed when the driver is used for actual hardware
that describes its own proximity domain.  Further, there is no DMA
engine, here, so what is the benefit of using blk-mq?  I/O completes in
the submission path, and I don't see any locking that's preventing
parallelism.

>
>> +	blk_queue_make_request(pmem->pmem_queue, pmem_make_request);
>> +	blk_queue_max_hw_sectors(pmem->pmem_queue, 1024);
>
> Many storage controllers support 1 MiB IOs now, and increasing
> amounts of software feel comfortable generating those sizes.  
> That means this should be at least 2048.
>
>> +	blk_queue_bounce_limit(pmem->pmem_queue, BLK_BOUNCE_ANY);
>> +
>
> It might be appropriate to call blk_queue_rq_timeout
> and set up a very short timeout, since persistent memory is
> very fast.  I'm not sure what the default is for non-blk-mq
> drivers; for blk-mq, I think it is 30 seconds, which is
> far too long for memory based storage.

If you timeout on a memcpy, then we've definitely got problems. :)

Cheers,
Jeff
