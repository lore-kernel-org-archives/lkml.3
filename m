Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756143AbaDPTUs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 15:20:48 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:57775 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232AbaDPTUp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 15:20:45 -0400
Date: Wed, 16 Apr 2014 22:20:36 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>, Nitin Gupta <ngupta@vflare.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHv9 0/7] add compressing abstraction and multi stream
 support
Message-ID: <20140416192036.GA936@swordfish>
References: <1393609927-22090-1-git-send-email-sergey.senozhatsky@gmail.com>
 <20140306081137.GA14287@bbox>
 <1555642.jW49oRcvBj@amdc1032>
 <20140416145353.GC944@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140416145353.GC944@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On (04/16/14 17:53), Sergey Senozhatsky wrote:
> On (04/16/14 15:53), Bartlomiej Zolnierkiewicz wrote:
> > Hi,
> > 
> > I'm a bit late on this patch series (sorry for that) but why are we not
> > using Crypto API for compression algorithm selection and multi stream
> > support?  Compared to the earlier patches for zram like the ones we did
> > in July 2013 [1] this patch series requires us to:
> > 
> > - implement compression algorithm support for each algorithm separately
> >   (when using Crypto API all compression algorithms supported by Crypto
> >   API are supported automatically)
> > 
> > - manually set the number of maximum active compression streams (earlier
> >   patches using Crypto API needed a lot less code and automatically scaled
> >   number of compression streams to number of online CPUs)
> 
> Hello Bartlomiej,
> 
> there was a short discussion of `custom solution' vs `crypto API'.
> personally, I was not impressed by Crypto API. basically it requires
> 	a) locking of transformation context (if we have only one tfm
> 	for everyone)
> or
> 	b) having some sort of a list of tfms
> or
> 	c) storing tfm in a per_cpu area.
> 
> c) requires ZRAM block device to become CPU hotplug aware and to begin
> reacting on onlining/offlining of a CPU by allocating/deallocating of
> transformation context. allocating new tfm potentially could a problem
> if system is under memory pressure and ZRAM is used as a swap device.
> besides, c) also requires additional locking via get_cpu()/put_cpu()
> around every comp op.
> 
> in overall, that was something that I wanted to avoid. current solution
> does not depend on CPU notifier (which is a good thing for a block device
> driver, imho) and, thus, looks simpler in some ways. yet we still have
> ability to scale.
> 
> there was a patch that was letting ZRAM to automatically scale number of
> compression streams to number of online CPUs, but Minchan wanted explicit
> one-stream-only option for swap device use-case.
> 

to be correct, special case for one-stream-only is reasonable. single
stream, protected with mutex, gives us really nice performance numbers
comparing to spinlock and wait_event(), because of adaptive spin-on-onwner
mutex's behaviour. we probably can reduce lines of code with adaptive
locking, which will behave as spinlock for multistream and as adaptive
mutex for single stream.

	-ss

> the other thing to mention is that CPU offlining API was under rework at
> that time by Srivatsa S. Bhat (cpu_notifier_register_begin(),
> cpu_notifier_register_done()) due to discovered races, which resulted in
> a patchset of 50+ patches (every existing CPU notifier user, including
> zsmalloc) and that played as additional factor.
> 
> 
> 	-ss
> 
> > From what I see the pros of the current patch series are:
> > 
> > - dynamic selection of the compression algorithm
> > 
> > - ability to limit number of active streams below tha number of online CPUs
> > 
> > However I believe that both above features can be also implemented on top of
> > the code using Crypto API.  What am I missing?
> > 
> > [1] https://lkml.org/lkml/2013/7/30/365
> > 
> > Best regards,
> > --
> > Bartlomiej Zolnierkiewicz
> > Samsung R&D Institute Poland
> > Samsung Electronics
> > 
> > On Thursday, March 06, 2014 05:11:37 PM Minchan Kim wrote:
> > > Hello Sergey,
> > > 
> > > Sorry for the late.
> > > 
> > > Today, I tested this patch and confirm that it's really good.
> > > I send result for the record.
> > > 
> > > In x86(4core and x2 hyper threading, i7, 2.8GHz), I did parallel 4 dd
> > > test with 200m file like below
> > > 
> > > dd if=./test200m.file of=mnt/file1 bs=512k count=1024 oflag=direct &
> > > dd if=./test200m.file of=mnt/file2 bs=512k count=1024 oflag=direct &
> > > dd if=./test200m.file of=mnt/file3 bs=512k count=1024 oflag=direct &
> > > dd if=./test200m.file of=mnt/file4 bs=512k count=1024 oflag=direct &
> > > wait all backgroud job
> > > 
> > > The result is 
> > > 
> > > When 1 max_comp_streams, elapsed time is 36.26s
> > > When 8 max_comp_streams, elapsed time is 4.09s
> > > 
> > > In ARM(4core, ARMv7, 1.5GHz), I did iozone test.
> > > 
> > >       1 max_comp_streams,      8 max_comp_streams
> > > ==Initial  write      ==Initial  write
> > > records:   10         records:   10
> > > avg:       141964.05  avg:       239632.54
> > > std:       3532.11    (2.49%)    std:       43863.53  (18.30%)
> > > max:       147900.45  max:       319046.62
> > > min:       135363.73  min:       178929.40
> > > ==Rewrite  ==Rewrite
> > > records:   10         records:   10
> > > avg:       144757.46  avg:       247410.80
> > > std:       4019.19    (2.78%)    std:       37378.42  (15.11%)
> > > max:       150757.72  max:       293284.84
> > > min:       135127.55  min:       188984.27
> > > ==Read     ==Read
> > > records:   10         records:   10
> > > avg:       208325.22  avg:       202894.24
> > > std:       57072.62   (27.40%)   std:       41099.56  (20.26%)
> > > max:       293428.96  max:       289581.12
> > > min:       79445.37   min:       157478.27
> > > ==Re-read  ==Re-read
> > > records:   10         records:   10
> > > avg:       204750.36  avg:       237406.96
> > > std:       36959.99   (18.05%)   std:       41518.36  (17.49%)
> > > max:       268399.89  max:       286898.13
> > > min:       154831.28  min:       160326.88
> > > ==Reverse  Read       ==Reverse  Read
> > > records:   10         records:   10
> > > avg:       215043.10  avg:       208946.35
> > > std:       31239.60   (14.53%)   std:       38859.74  (18.60%)
> > > max:       251564.57  max:       284481.31
> > > min:       154719.20  min:       155024.33
> > > ==Stride   read       ==Stride   read
> > > records:   10         records:   10
> > > avg:       227246.54  avg:       198925.10
> > > std:       31105.89   (13.69%)   std:       30721.86  (15.44%)
> > > max:       290020.34  max:       227178.70
> > > min:       157399.46  min:       153592.91
> > > ==Random   read       ==Random   read
> > > records:   10         records:   10
> > > avg:       238239.81  avg:       216298.41
> > > std:       37276.91   (15.65%)   std:       38194.73  (17.66%)
> > > max:       291416.20  max:       286345.37
> > > min:       152734.23  min:       151871.52
> > > ==Mixed    workload   ==Mixed    workload
> > > records:   10         records:   10
> > > avg:       208434.11  avg:       234355.66
> > > std:       31385.40   (15.06%)   std:       22064.02  (9.41%)
> > > max:       253990.11  max:       270412.58
> > > min:       162041.47  min:       186052.12
> > > ==Random   write      ==Random   write
> > > records:   10         records:   10
> > > avg:       142172.54  avg:       290231.28
> > > std:       6233.67    (4.38%)    std:       46462.35  (16.01%)
> > > max:       150652.40  max:       338096.54
> > > min:       130584.14  min:       183253.25
> > > ==Pwrite   ==Pwrite
> > > records:   10         records:   10
> > > avg:       141247.91  avg:       267085.70
> > > std:       6756.08    (4.78%)    std:       40019.39  (14.98%)
> > > max:       150239.13  max:       335512.33
> > > min:       130456.98  min:       180832.45
> > > ==Pread    ==Pread
> > > records:   10         records:   10
> > > avg:       214990.26  avg:       208730.94
> > > std:       40701.79   (18.93%)   std:       50797.78  (24.34%)
> > > max:       287060.54  max:       300675.25
> > > min:       157642.17  min:       156763.98
> > > 
> > > So, all write test both x86 and ARM is really huge win
> > > and I couldn't find any regression!
> > > 
> > > Thanks for nice work.
> > > 
> > > For all patchset,
> > > 
> > > Acked-by: Minchan Kim <minchan@kernel.org>
> > > 
> > > On Fri, Feb 28, 2014 at 08:52:00PM +0300, Sergey Senozhatsky wrote:
> > > > This patchset introduces zcomp compression backend abstraction
> > > > adding ability to support compression algorithms other than LZO;
> > > > support for multi compression streams, making parallel compressions
> > > > possible; adds support for LZ4 compression algorithm.
> > > > 
> > > > v8->v9 (reviewed by Andrew Morton):
> > > > -- add LZ4 backend (+iozone test vs LZO)
> > > > -- merge patches 'zram: document max_comp_streams' and 'zram: add multi
> > > >    stream functionality'
> > > > -- do not extern backend struct from source file
> > > > -- use find()/release() naming instead of get()/put()
> > > > -- minor code, commit messages and code comments `nitpicks'
> > > > -- removed Acked-by Minchan Kim from first two patches, because I've
> > > >    changed them a bit.
> > > > 
> > > > v7->v8 (reviewed by Minchan Kim):
> > > > -- merge patches 'add multi stream functionality' and 'enable multi
> > > >    stream compression support in zram'
> > > > -- return status code from set_max_streams knob and print message on
> > > >    error
> > > > -- do not use atomic type for ->avail_strm
> > > > -- return back: allocate by default only one stream for multi stream backend
> > > > -- wake sleeping write in zcomp_strm_multi_put() only if we put stream
> > > >    to idle list
> > > > -- minor code `nitpicks'
> > > > 
> > > > v6->v7 (reviewed by Minchan Kim):
> > > > -- enable multi and single stream support out of the box (drop
> > > >    ZRAM_MULTI_STREAM config option)
> > > > -- add set_max_stream knob, so we can adjust max number of compression
> > > >    streams in runtime (for multi stream backend at the moment)
> > > > -- minor code `nitpicks'
> > > > 
> > > > v5->v6 (reviewed by Minchan Kim):
> > > > -- handle single compression stream case separately, using mutex locking,
> > > >    to address perfomance regression
> > > > -- handle multi compression stream using spin lock and wait_event()/wake_up()
> > > > -- make multi compression stream support configurable (ZRAM_MULTI_STREAM
> > > >    config option)
> > > > 
> > > > v4->v5 (reviewed by Minchan Kim):
> > > > -- renamed zcomp buffer_lock; removed src len and dst len from
> > > >    compress() and decompress(); not using term `buffer' and
> > > >    `workmem' in code and documentation; define compress() and
> > > >    decompress() functions for LZO backend; not using goto's;
> > > >    do not put idle zcomp_strm to idle list tail.
> > > > 
> > > > v3->v4 (reviewed by Minchan Kim):
> > > > -- renamed compression backend and working memory structs as requested
> > > >    by Minchan Kim; fixed several issues noted by Minchan Kim.
> > > > 
> > > > Sergey Senozhatsky (7):
> > > >   zram: introduce compressing backend abstraction
> > > >   zram: use zcomp compressing backends
> > > >   zram: factor out single stream compression
> > > >   zram: add multi stream functionality
> > > >   zram: add set_max_streams knob
> > > >   zram: make compression algorithm selection possible
> > > >   zram: add lz4 algorithm backend
> > > > 
> > > >  Documentation/ABI/testing/sysfs-block-zram |  17 +-
> > > >  Documentation/blockdev/zram.txt            |  45 +++-
> > > >  drivers/block/zram/Kconfig                 |  10 +
> > > >  drivers/block/zram/Makefile                |   4 +-
> > > >  drivers/block/zram/zcomp.c                 | 349 +++++++++++++++++++++++++++++
> > > >  drivers/block/zram/zcomp.h                 |  68 ++++++
> > > >  drivers/block/zram/zcomp_lz4.c             |  47 ++++
> > > >  drivers/block/zram/zcomp_lz4.h             |  17 ++
> > > >  drivers/block/zram/zcomp_lzo.c             |  47 ++++
> > > >  drivers/block/zram/zcomp_lzo.h             |  17 ++
> > > >  drivers/block/zram/zram_drv.c              | 131 ++++++++---
> > > >  drivers/block/zram/zram_drv.h              |  11 +-
> > > >  12 files changed, 715 insertions(+), 48 deletions(-)
> > > >  create mode 100644 drivers/block/zram/zcomp.c
> > > >  create mode 100644 drivers/block/zram/zcomp.h
> > > >  create mode 100644 drivers/block/zram/zcomp_lz4.c
> > > >  create mode 100644 drivers/block/zram/zcomp_lz4.h
> > > >  create mode 100644 drivers/block/zram/zcomp_lzo.c
> > > >  create mode 100644 drivers/block/zram/zcomp_lzo.h
> > 
> 
