Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731AbaIOU13 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:27:29 -0400
Received: from mail-lb0-f171.google.com ([209.85.217.171]:36133 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757716AbaIOU10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 16:27:26 -0400
MIME-Version: 1.0
In-Reply-To: <cover.1410810247.git.milosz@adfin.com>
References: <cover.1410810247.git.milosz@adfin.com>
Date: Mon, 15 Sep 2014 16:27:24 -0400
Message-ID: <CANP1eJFsL7uuYqd_LZpkJ5bqSQ44JSWj63tbAbk_MGkBknpoKw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
From: Milosz Tanski <milosz@adfin.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As promised here is some performance data. I ended up having up
copying the posix AIO engine and hacking it up to support the preadv2
syscall to perform a "fast read" in the submit thread. Bellow my
observations, followed by test data on a local filesystem (ext4) for
two different test cases (the second one being more of a realistic
case). I also tried this with a remote filesystem (Ceph) where I was
able to get a much better latency improvement.

- I tested two workloads. One is a primarily would be cached work-load
and the other a simulating a more complex workload that tries to mimic
what we would see in our db nodes.
- In the mostly cached case. The bandwidth doesn't increase, but the
request latency is much better. Here the bottleneck on total bandwidth
is probably a single submission thread.
- In the second case we see the same thing we generally. Bandwidth is
more or less the same, request latency is much better in the case of
random read (cached data), and sequential read (due to kernel's
readahead detection). Request latency of random uncached data is worse
(since we do two syscalls).
- Posix AIO probably suffers due to synchronization it could be
improved by a lockless mpmc queue and a aggressive spin before
sleeping wait.
- I can probably improve the uncached latency to be margin of error if
I add miss detection to the submission code (don't try fast read for a
while if a low percentage of those fail).

A lot of possible improvement, but even in its crude state it helps
similar apps (threaded IO worker pool).

Simple in-memory workload (mostly cached), 16kb blocks:

posix_aio:

bw (KB  /s): min=    5, max=29125, per=100.00%, avg=17662.31, stdev=4735.36
lat (usec) : 100=0.17%, 250=0.02%, 500=0.02%, 750=0.01%, 1000=0.01%
lat (msec) : 2=0.01%, 4=0.08%, 10=0.54%, 20=2.97%, 50=40.26%
lat (msec) : 100=49.41%, 250=6.31%, 500=0.21%
READ: io=5171.4MB, aggrb=17649KB/s, minb=17649KB/s, maxb=17649KB/s,
mint=300030msec, maxt=300030msec

posix_aio w/ fast_read:

bw (KB  /s): min=   15, max=38624, per=100.00%, avg=17977.23, stdev=6043.56
lat (usec) : 2=84.33%, 4=0.01%, 10=0.01%, 20=0.01%
lat (msec) : 50=0.01%, 100=0.01%, 250=0.48%, 500=14.45%, 750=0.67%
lat (msec) : 1000=0.05%
READ: io=5235.4MB, aggrb=17849KB/s, minb=17849KB/s, maxb=17849KB/s,
mint=300341msec, maxt=300341msec

Complex workload (simulate our DB access patern), 16kb blocks

f1: ~73% rand read over mostly cached data (zipf med-size dataset)
f2: ~18% rand read over mostly un-cached data (uniform large-dataset)
f3: ~9% seq-read over large dataset

posix_aio:

f1:
    bw (KB  /s): min=   11, max= 9088, per=0.56%, avg=969.54, stdev=827.99
    lat (msec) : 50=0.01%, 100=1.06%, 250=5.88%, 500=4.08%, 750=12.48%
    lat (msec) : 1000=17.27%, 2000=49.86%, >=2000=9.42%
f2:
    bw (KB  /s): min=    2, max= 1882, per=0.16%, avg=273.28, stdev=220.26
    lat (msec) : 250=5.65%, 500=3.31%, 750=15.64%, 1000=24.59%, 2000=46.56%
    lat (msec) : >=2000=4.33%
f3:
    bw (KB  /s): min=    0, max=265568, per=99.95%, avg=174575.10,
stdev=34526.89
    lat (usec) : 2=0.01%, 4=0.01%, 10=0.02%, 20=0.27%, 50=10.82%
    lat (usec) : 100=50.34%, 250=5.05%, 500=7.12%, 750=6.60%, 1000=4.55%
    lat (msec) : 2=8.73%, 4=3.49%, 10=1.83%, 20=0.89%, 50=0.22%
    lat (msec) : 100=0.05%, 250=0.02%, 500=0.01%
total:
   READ: io=102365MB, aggrb=174669KB/s, minb=240KB/s, maxb=173599KB/s,
mint=600001msec, maxt=600113msec

posix_aio w/ fast_read:

f1:
    bw (KB  /s): min=    3, max=14897, per=1.28%, avg=2276.69, stdev=2930.39
    lat (usec) : 2=70.63%, 4=0.01%
    lat (msec) : 250=0.20%, 500=2.26%, 750=1.18%, 2000=0.22%, >=2000=25.53%
f2:
    bw (KB  /s): min=    2, max= 2362, per=0.14%, avg=249.83, stdev=222.00
    lat (msec) : 250=6.35%, 500=1.78%, 750=9.29%, 1000=20.49%, 2000=52.18%
    lat (msec) : >=2000=9.99%
f3:
    bw (KB  /s): min=    1, max=245448, per=100.00%, avg=177366.50,
stdev=35995.60
    lat (usec) : 2=64.04%, 4=0.01%, 10=0.01%, 20=0.06%, 50=0.43%
    lat (usec) : 100=0.20%, 250=1.27%, 500=2.93%, 750=3.93%, 1000=7.35%
    lat (msec) : 2=14.27%, 4=2.88%, 10=1.54%, 20=0.81%, 50=0.22%
    lat (msec) : 100=0.05%, 250=0.02%
total:
   READ: io=103941MB, aggrb=177339KB/s, minb=213KB/s, maxb=176375KB/s,
mint=600020msec, maxt=600178msec

On Mon, Sep 15, 2014 at 4:20 PM, Milosz Tanski <milosz@adfin.com> wrote:
> This patcheset introduces an ability to perform a non-blocking read from
> regular files in buffered IO mode. This works by only for those filesystems
> that have data in the page cache.
>
> It does this by introducing new syscalls new syscalls readv2/writev2 and
> preadv2/pwritev2. These new syscalls behave like the network sendmsg, recvmsg
> syscalls that accept an extra flag argument (O_NONBLOCK).
>
> It's a very common patern today (samba, libuv, etc..) use a large threadpool to
> perform buffered IO operations. They submit the work form another thread
> that performs network IO and epoll or other threads that perform CPU work. This
> leads to increased latency for processing, esp. in the case of data that's
> already cached in the page cache.
>
> With the new interface the applications will now be able to fetch the data in
> their network / cpu bound thread(s) and only defer to a threadpool if it's not
> there. In our own application (VLDB) we've observed a decrease in latency for
> "fast" request by avoiding unnecessary queuing and having to swap out current
> tasks in IO bound work threads.
>
> I have co-developed these changes with Christoph Hellwig, a whole lot of his
> fixes went into the first patch in the series (were squashed with his
> approval).
>
> I am going to post the perf report in a reply-to to this RFC.
>
> Christoph Hellwig (3):
>   documentation updates
>   move flags enforcement to vfs_preadv/vfs_pwritev
>   check for O_NONBLOCK in all read_iter instances
>
> Milosz Tanski (4):
>   Prepare for adding a new readv/writev with user flags.
>   Define new syscalls readv2,preadv2,writev2,pwritev2
>   Export new vector IO (with flags) to userland
>   O_NONBLOCK flag for readv2/preadv2
>
>  Documentation/filesystems/Locking |    4 +-
>  Documentation/filesystems/vfs.txt |    4 +-
>  arch/x86/syscalls/syscall_32.tbl  |    4 +
>  arch/x86/syscalls/syscall_64.tbl  |    4 +
>  drivers/target/target_core_file.c |    6 +-
>  fs/afs/internal.h                 |    2 +-
>  fs/afs/write.c                    |    4 +-
>  fs/aio.c                          |    4 +-
>  fs/block_dev.c                    |    9 ++-
>  fs/btrfs/file.c                   |    2 +-
>  fs/ceph/file.c                    |   10 ++-
>  fs/cifs/cifsfs.c                  |    9 ++-
>  fs/cifs/cifsfs.h                  |   12 ++-
>  fs/cifs/file.c                    |   30 +++++---
>  fs/ecryptfs/file.c                |    4 +-
>  fs/ext4/file.c                    |    4 +-
>  fs/fuse/file.c                    |   10 ++-
>  fs/gfs2/file.c                    |    5 +-
>  fs/nfs/file.c                     |   13 ++--
>  fs/nfs/internal.h                 |    4 +-
>  fs/nfsd/vfs.c                     |    4 +-
>  fs/ocfs2/file.c                   |   13 +++-
>  fs/pipe.c                         |    7 +-
>  fs/read_write.c                   |  146 +++++++++++++++++++++++++++++++------
>  fs/splice.c                       |    4 +-
>  fs/ubifs/file.c                   |    5 +-
>  fs/udf/file.c                     |    5 +-
>  fs/xfs/xfs_file.c                 |   12 ++-
>  include/linux/fs.h                |   16 ++--
>  include/linux/syscalls.h          |   12 +++
>  include/uapi/asm-generic/unistd.h |   10 ++-
>  mm/filemap.c                      |   34 +++++++--
>  mm/shmem.c                        |    6 +-
>  33 files changed, 306 insertions(+), 112 deletions(-)
>
> --
> 1.7.9.5
>



-- 
Milosz Tanski
CTO
16 East 34th Street, 15th floor
New York, NY 10016

p: 646-253-9055
e: milosz@adfin.com
