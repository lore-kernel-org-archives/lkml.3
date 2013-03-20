Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313Ab3CTV7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 17:59:55 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:26384 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348Ab3CTV7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 17:59:54 -0400
Date: Wed, 20 Mar 2013 16:58:38 -0500
From: scameron@beardog.cce.hp.com
To: linux-kernel@vger.kernel.org
Cc: stephenmcameron@gmail.com, scameron@beardog.cce.hp.com,
        chayan.biswas@sandisk.com, elliott@hp.com
Subject: Question about make_request_fn based block drivers
Message-ID: <20130320215838.GO30284@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


When running mke2fs against the make_request_fn based block driver
I'm working on, I'm seeing only single-block bios.  Other such drivers
(e.g. nvme) are getting, for example, 4k bios coming in from the same
mke2fs command.

mke2fs /dev/sop0

This is on a 3.9-rc1 kernel.

I've tried setting:

	blk_queue_max_hw_sectors(rq, 2048);
	blk_queue_max_segments(rq, 32);
	blk_queue_io_opt(rq, 4096);
	blk_queue_io_min(rq, 4096);
	blk_queue_physical_block_size(rq, 4096);
	blk_queue_logical_block_size(h->rq, 512);
	blk_queue_physical_block_size(h->rq, 4096);

all to no avail.

If I do this:

	dd if=/dev/sop0 of=/dev/null bs=4k iflag=direct 

with that, I can get 4k bios coming in to the make_request_fn.

Driver source is here: https://github.com/HPSmartStorage/scsi-over-pcie
(still a work in progress -- that source doesn't do all the blk_queue_*
settings mentioned above, those are just the things I've tried.)

In /sys/block/sop0/queue...

[scameron@localhost queue]$ for x in *
> do
> echo ===== $x ======
> cat $x
> done
===== add_random ======
1
===== discard_granularity ======
0
===== discard_max_bytes ======
0
===== discard_zeroes_data ======
0
===== hw_sector_size ======
512
===== iostats ======
1
===== logical_block_size ======
512
===== max_hw_sectors_kb ======
1024
===== max_integrity_segments ======
0
===== max_sectors_kb ======
512
===== max_segments ======
32
===== max_segment_size ======
65536
===== minimum_io_size ======
4096
===== nomerges ======
2
===== nr_requests ======
128
===== optimal_io_size ======
4096
===== physical_block_size ======
4096
===== read_ahead_kb ======
128
===== rotational ======
0
===== rq_affinity ======
1
===== scheduler ======
none
===== write_same_max_bytes ======
0
[scameron@localhost queue]$

Any ideas what I'm missing to get I/O's bigger than 1 block to come in?

Thanks,

-- steve

