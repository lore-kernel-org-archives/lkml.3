Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753131AbaFSBBJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 21:01:09 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:36903 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaFSBBH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 21:01:07 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>
CC: Bart Van Assche <bvanassche@fusionio.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: scsi-mq
Thread-Topic: scsi-mq
Thread-Index: AQHPhkTL6P783gg4/EmIzBJz+o9Cjpt1ZBoAgADetQCAAVOtkA==
Date: Thu, 19 Jun 2014 00:58:02 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958B3D123@G9W0745.americas.hpqcorp.net>
References: <1402580946-11470-1-git-send-email-hch@lst.de>
 <53A05068.4080702@acm.org> <53A10B3A.6050705@kernel.dk>
In-Reply-To: <53A10B3A.6050705@kernel.dk>
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
> From: Jens Axboe [mailto:axboe@kernel.dk]
> Sent: Tuesday, 17 June, 2014 10:45 PM
> To: Bart Van Assche; Christoph Hellwig; James Bottomley
> Cc: Bart Van Assche; Elliott, Robert (Server Storage); linux-
> scsi@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: Re: scsi-mq
> 
> On 2014-06-17 07:27, Bart Van Assche wrote:
> > On 06/12/14 15:48, Christoph Hellwig wrote:
> >> Bart and Robert have helped with some very detailed measurements that they
> >> might be able to send in reply to this, although these usually involve
> >> significantly reworked low level drivers to avoid other bottle necks.
> >
> > In case someone would like to see the results of the measurements I ran,
> > these results can be found here:
> > https://docs.google.com/file/d/0B1YQOreL3_FxUXFMSjhmNDBNNTg.
> >
> > Two important conclusions from the data in that PDF document are as
> follows:
> > - A small but significant performance improvement for the traditional
> >    SCSI mid-layer (use_blk_mq=N).
> > - A very significant performance improvement for multithreaded
> >    workloads with use_blk_mq=Y. As an example, the number of I/O
> >    operations per second reported for the random write test increased
> >    with 170%. That means 2.7 times the performance
> >    of use_blk_mq=N.
> 
> Thanks for posting these numbers, Bart. The CPU utilization and IOPS
> speak a very clear message. The only mystery is why the singe threaded
> performance is down. That we need to get sort, but it's not a show
> stopper for inclusion.
> 
> If you run the single threaded tests and watch for queue depths, is
> there a difference between blk-mq=y/scsi-mq and the stock kernel?
> 
> > I think this means the scsi-mq patches are ready for wider use.
> 
> I would agree. James, I haven't seen any comments from you on this yet.
> I've run various bits of scsi-mq testing as well, and no ill effects
> seen. On top of that, Christophs patches are nicely separated and have
> general benefits even for the non-blk-mq cases. Time to shove them into
> the queue for the next merge window?
> 
> --
> Jens Axboe

We've been testing the hpsa driver extensively with the scsi-mq-wip trees.
I don't have numbers with the latest scsi-mq tree yet, but here are some
performance numbers from scsi-mq-wip.5 through 7.  

scsi-mq slightly underperformed non-scsi-mq when using multiple devices:
* normal		975K IOPS (16 devices each made from 1 drive)
* scsi-mq-wip.5	905K IOPS (16 devices each made from 1 drive)
* scsi-mq-wip.6+	969K IOPS (16 devices... 3 threads per device)

but was much better when using a single device:
* normal		166K IOPS (1 device made from 8 drives, 1 thread)          
* normal		266K IOPS (1 device made from 8 drives, 12 threads)
* scsi-mq-wip.5	880K IOPS (1 device made from 8 drives, 12 threads)

* normal		266K IOPS (1 device made from 16 drives, 12 threads)
* scsi-mq-wip.5	973K IOPS (1 device made from 16 drives, 12 threads)
* scsi-mq-wip.6+	979K IOPS (1 device made from 16 drives, 12 threads)


The headline improvement is that one device can reach the same performance 
as multiple devices - no more bottleneck in per-device queue locks limiting 
performance to around 266K IOPS per device.  Even the scsi_debug driver in
fake_rw mode hits that limit.

hpsa is limited to one submission queue, so submissions from multiple CPUs 
still meet inside the driver - SCSI Express will keep them isolated all 
the way.  hpsa supports one completion queue per CPU, so completions are 
already isolated.

The blk-mq bitmap tag allocator is working much better than its 
predecessor, but some combinations of active CPUs and devices still 
result in low queue depths for some devices.

We haven't fully tested cases where the hardware interrupt is handled
on a different CPU than the block layer wants to run its completion
processing per rq_affinity. That was previously scheduled as a softirq,
but is now handled directly in hardirq processing with IPIs.  This
changes the CPU utilization %soft and %hard metrics:
* normal 	5% hard, 25% soft
* scsi-mq	30% hard, 0% soft
(with something like 5% usr, 55% sys, 8% iowait idle, 2% idle)


Configuration:
* HP ProLiant DL380p Gen8 with 6 CPU hyperthreading cores (12 logical cores)
* lockless hpsa driver (forthcoming patches with performance 
  improvements such as eliminating locks, plus improved error handling)
* Smart Array P431 RAID controller
* 16 12 Gb/s SAS SSDs
* fio: 4 KiB random reads with options:
  direct=1, ioengine=libaio, norandommap, randrepeat=0,
  iodepth=96 or 1024, numjobs=1 or 12, thread, 
  cpus_allowed=0-11, cpus_allowed_policy=split,
  iodepth_batch=4, iodepth_batch_complete=4, userspace_reap,
  bs=4096, rw=randread
  time_based, group_reporting, gtod_reduce
* block layer queue parameters:
  nr_requests=1011, add_random=0
  nomerges=2, rq_affinity=2, max_sectors_kb=max_hw_sectors_kb
* old version of irqbalance-1.0.4, which still honors 
  /proc/irq/NN/affinity_hint (the new version defaults to
  ignoring that)

---
Rob Elliott    HP Server Storage



