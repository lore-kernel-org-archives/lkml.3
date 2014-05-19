Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaESSbZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 14:31:25 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:45732 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaESSbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 14:31:24 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1405191908450.1847@denkbrett>
References: <alpine.LFD.2.11.1405191908450.1847@denkbrett>
Date: Mon, 19 May 2014 11:31:22 -0700
Message-ID: <CAOMFOmUzTJLJdUTCVwSt1H=LDiproX-X19p0bjoDMHJrkyTR9g@mail.gmail.com>
Subject: Re: hanging aio process
From: Anatol Pomozov <anatol.pomozov@gmail.com>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: Benjamin LaHaise <bcrl@kvack.org>, linux-aio@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, May 19, 2014 at 10:38 AM, Sebastian Ott
<sebott@linux.vnet.ibm.com> wrote:
> Hello,
>
> on the latest kernel a fio job with 4 workers using libaio hangs.
>
> git bisect points to:
>         commit e02ba72aabfade4c9cd6e3263e9b57bf890ad25c
>         Author: Anatol Pomozov <anatol.pomozov@gmail.com>
>         Date:   Tue Apr 15 11:31:33 2014 -0700
>
>             aio: block io_destroy() until all context requests are completed
>
>
> The fio workers are on the wait_for_completion in sys_io_destroy.

I ran your script on my dev machine (kernel built from current HEAD
v3.15-rc5-77-g14186fe) and fio (versions 1.35 and 2.1.9) - it works
fine. I use only 1 partition as it is what I have on my dev machine.

dev:~# uname -a
Linux lpa12 3.15.0-smp-DEV #1 SMP Mon May 19 10:43:11 PDT 2014 x86_64 GNU/Linux
dev:~# ./fio fio.config
file1: (g=0): rw=randrw, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=32
fio-2.1.9
Starting 1 process
Jobs: 1 (f=1): [V] [97.7% done] [23148KB/0KB/0KB /s] [5787/0/0 iops]
[eta 00m:06s]
file1: (groupid=0, jobs=1): err= 0: pid=8886: Mon May 19 11:28:01 2014
  read : io=262144KB, bw=1030.4KB/s, iops=257, runt=254422msec
    slat (usec): min=2, max=6661.1K, avg=1683383.24, stdev=2043757.55
    clat (usec): min=502, max=1790.7K, avg=101036.69, stdev=130084.58
     lat (usec): min=516, max=6670.5K, avg=1784420.38, stdev=1967789.22
    clat percentiles (msec):
     |  1.00th=[    5],  5.00th=[    6], 10.00th=[    6], 20.00th=[    6],
     | 30.00th=[    6], 40.00th=[    6], 50.00th=[    6], 60.00th=[   96],
     | 70.00th=[  151], 80.00th=[  206], 90.00th=[  285], 95.00th=[  359],
     | 99.00th=[  523], 99.50th=[  586], 99.90th=[  758], 99.95th=[  840],
     | 99.99th=[ 1090]
    bw (KB  /s): min=  354, max=  738, per=51.26%, avg=527.94, stdev=56.33
  write: io=130924KB, bw=538931B/s, iops=131, runt=248763msec
    slat (usec): min=3, max=211966, avg=111.03, stdev=2891.12
    clat (usec): min=24, max=278755, avg=46127.52, stdev=40482.33
     lat (usec): min=432, max=278772, avg=46238.99, stdev=40477.33
    clat percentiles (usec):
     |  1.00th=[  636],  5.00th=[ 1032], 10.00th=[ 3184], 20.00th=[ 9920],
     | 30.00th=[18560], 40.00th=[28544], 50.00th=[38656], 60.00th=[48896],
     | 70.00th=[59648], 80.00th=[73216], 90.00th=[96768], 95.00th=[128512],
     | 99.00th=[183296], 99.50th=[201728], 99.90th=[236544], 99.95th=[250880],
     | 99.99th=[276480]
    bw (KB  /s): min=  262, max=  788, per=100.00%, avg=527.29, stdev=86.42
    lat (usec) : 50=0.01%, 100=0.01%, 250=0.04%, 500=0.02%, 750=0.82%
    lat (usec) : 1000=0.83%
    lat (msec) : 2=0.97%, 4=1.72%, 10=36.38%, 20=4.35%, 50=11.45%
    lat (msec) : 100=14.21%, 250=20.03%, 500=8.34%, 750=0.76%, 1000=0.07%
    lat (msec) : 2000=0.01%
  cpu          : usr=0.71%, sys=0.65%, ctx=96595, majf=0, minf=775
  IO depths    : 1=0.1%, 2=0.1%, 4=0.1%, 8=0.1%, 16=0.1%, 32=99.9%, >=64=0.0%
     submit    : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.0%, 64=0.0%, >=64=0.0%
     complete  : 0=0.0%, 4=100.0%, 8=0.0%, 16=0.0%, 32=0.1%, 64=0.0%, >=64=0.0%
     issued    : total=r=65536/w=32731/d=0, short=r=0/w=0/d=0
     latency   : target=0, window=0, percentile=100.00%, depth=32

Run status group 0 (all jobs):
   READ: io=262144KB, aggrb=1030KB/s, minb=1030KB/s, maxb=1030KB/s,
mint=254422msec, maxt=254422msec
  WRITE: io=130924KB, aggrb=526KB/s, minb=526KB/s, maxb=526KB/s,
mint=248763msec, maxt=248763msec

Disk stats (read/write):
  sdb: ios=65536/32734, merge=0/0, ticks=6599230/1502876,
in_queue=8102038, util=100.00%





+1 what Benjamin said, provide kernel stack traces for stuck processes
(use sysrq for it). And add other relevant information how to repro
the issue.
