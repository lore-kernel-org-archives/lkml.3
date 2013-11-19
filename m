Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab3KSICb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 03:02:31 -0500
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:62400 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750806Ab3KSIC3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 03:02:29 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AtUHAJoai1J5LGc//2dsb2JhbABZgweDLbdRhUiBGxd0gmYcIxgkNAUlAyETiADCMxaPQYQ4A5gPkg6DPCg
Date: Tue, 19 Nov 2013 19:02:18 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org
Subject: [Regression x2, 3.13-git] virtio block mq hang, iostat busted on
 virtio devices
Message-ID: <20131119080218.GJ11434@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

I was just running xfstests on a 3.13 kernel that has had the block
layer changed merged into it. generic/269 on XFS is hanging on a 2
CPU VM using virtio,cache=none for the block devices under test,
with many (130+) threads stuck below submit_bio() like this:

 Call Trace:
  [<ffffffff81adb1c9>] schedule+0x29/0x70
  [<ffffffff817833ee>] percpu_ida_alloc+0x16e/0x330
  [<ffffffff81759bef>] blk_mq_wait_for_tags+0x1f/0x40
  [<ffffffff81758bee>] blk_mq_alloc_request_pinned+0x4e/0xf0
  [<ffffffff8175931b>] blk_mq_make_request+0x3bb/0x4a0
  [<ffffffff8174d2b2>] generic_make_request+0xc2/0x110
  [<ffffffff8174e40c>] submit_bio+0x6c/0x120

reads and writes are hung, both data (direct and buffered) and
metadata.

Some IOs are sitting in io_schedule, waiting for IO completion (both
buffered and direct IO, both reads and writes) so it looks like IO
completion has stalled in some manner, too.

Also, when I run iostat, all my virtio block devices have
disappeared from it. i.e. I only see /dev/sda, and not /dev/vd[a-d]
like all previous kernels have shown up. That appears to be due to
/proc/diskstats not showing any stats for those devices anymore.

$ cat /proc/diskstats |grep vd
 253       0 vda 0 0 0 0 0 0 0 0 0 0 0
 253      16 vdb 0 0 0 0 0 0 0 0 0 0 0
 253      32 vdc 0 0 0 0 0 0 0 0 0 0 0
 253      48 vdd 0 0 0 0 0 0 0 0 0 0 0

I have no idea if it's related to the above hang, but either way
breaking iostat is a major regression....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
