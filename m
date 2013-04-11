Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758702Ab3DKHWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 03:22:51 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:18277 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751183Ab3DKHWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 03:22:48 -0400
Date: Thu, 11 Apr 2013 00:22:39 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Mike Snitzer <snitzer@redhat.com>,
        Kent Overstreet <koverstreet@google.com>,
        Amit Kale <akale@stec-inc.com>
Cc: linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        linux-bcache@vger.kernel.org
Subject: bcache/dmcache/enhanceio bake-off
Message-ID: <20130411072239.GD8910@blackbox.djwong.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Lately I've been having some fun playing with bcache, dmcache, and enhanceio.
I've an fio config[1] that thinks it simulates a certain kind of workload
<cough> by randomly reading and writing 8k blocks to 8x 1GB files.  Since the
storage summit is in a week, I thought I might get the party started.

I had two machines to play with.  The first ("sub3") has a three-way RAID1 of
7200rpm disks, and a 1.2GB partition on an otherwise empty SSD.  The second
("blackbox") is a laptop with a single 5400rpm disk and a 1.2GB partition on an
SSD.  These configurations are a little silly, but I constrained the SSD size
to try to observe cache demotions.  None of the spinny disks have enough
streaming bandwidth to beat the SSD.

I set up each cache, formatted the cache device with "mkfs.ext4 -E
lazy_itable_init=1 -F <device>", mounted it, and ran fio for five minutes.
dmcache was set up with the default ("mq") policy in writeback mode with the
sequential threshold set to 16M, and all other settings set to defaults.  I
changed dmcache's sequential threshold because I observed that with its default
of 256K, setting readahead to 256K sometimes caused dmcache to confuse
readahead for streaming IO, and ignore the IO.  bcache and enhanceio were set
up with LRU replacement and writeback mode.  The kernel was 3.9-rc6, with
bcache pulled in from bcache-testing on Kent's git tree, and enhanceio pulled
in from STEC's github tree.  There seems to be a reworked version of bcache in
-next, but it appears to depend on the aio rework, which I didn't feel like
backporting. :)

The results live at [2].  In hindsight I wish I'd let it run longer so that in
all cases we would end up performing more IO than there was cache space, but
there's still time for that.  bcache pretty consistently delivered 2-3x the
bandwidth of the raw device, and the latencies went down by about the same
amount.  In general, I managed about a 70% hit rate with bcache.  EnhanceIO
provided a smaller boost, between 1.5-2x the bandwidth.  Read latencies went
down a bit, and write latencies seemed to decrease substantially, and enhanceio
was pretty consistent about the boost as well.  I don't know how to get hit
rate data out of enhanceio.

However, the weirdest results came from dmcache.  I reran the mkcache + format
+ fio loop quite a few times.  Most of the time it would produce a really nice
3-20x speedup, like what I posted at [2].  Other times, however, it was barely
faster than the spinny disk.  It was always the case that the cache hit full
utilization (i.e. all cache blocks in use), however in the fast case I would
see about a 90% hit rate and in the slow case, about 1%.  Sadly, I don't have a
dumper tool that would let me examine which cache blocks remained in the cache,
however I /did/ observe that if I ran mkfs with lazy_itable_init=0, the cache
would be pre-stuffed with ~600MB of inode tables, causing a very low hit rate
and poor performance.  I don't think those inode tables are all that hot,
seeing as there are only 20 inodes in the whole filesystem.  Oddly, the
latencies are higher on dmcache even despite the higher throughput.  My
speculation here is that I've not yet figured out what circumstances are
favorable to convincing dmcache to demote a cache block in favor of promoting
another.  The demotion count was almost zero.

Maybe I just need to run a longer workload?

<shrug> It's midnight here, I'm going to sleep on it for now and see what
people have to say in the morning.

Hopefully I'll see some of you at the upcoming storage/fs/etc summit?

--D

[1] http://djwong.org/docs/ssd-cache-bakeoff/database-funtime.fio
[2] http://djwong.org/docs/ssd-cache-bakeoff/
