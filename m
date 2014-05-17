Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416AbaEQOoI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 10:44:08 -0400
Received: from mail-pb0-f42.google.com ([209.85.160.42]:54452 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757116AbaEQOoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 10:44:06 -0400
Message-ID: <537775B0.2060907@gmail.com>
Date: Sat, 17 May 2014 23:44:00 +0900
From: Akira Hayakawa <ruby.wktk@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: dm-devel@redhat.com
CC: linux-kernel@vger.kernel.org, masami.hiramatsu@gmail.com,
        devel@etsukata.com
Subject: dm-writeboost: Progress Report
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi DM Guys,

I will share the latest progress report about Writeboost.

1. Where we are working on now

Kernel code
-----------
First of all, Writeboost is now merged into
thin-dev branch in Joe's tree.
URL: https://github.com/jthornber/linux-2.6

Testing
-------
Testing for Writeboost is merged into
master branch in Joe's device-mapper-test-suite (or dmts).
URL: https://github.com/jthornber/device-mapper-test-suite

Docs
----
You can access to the lastest documentations here.
URL: https://github.com/akiradeveloper/dm-writeboost/tree/develop/doc

- writeboost.txt : Will be merged into Documentation/ but is not merged yet.

It will be really thankful if you help me
improve the sentences (I am not native).

Aside this,
- writeboost-ja.txt : For Japanese forks
- writeboost.pdf : Very first introduction slides to Writeboost
  DOWNLOAD: https://github.com/akiradeveloper/dm-writeboost/blob/develop/doc/writeboost.pdf?raw=true

2. New feature from the last progress report

The kernel code wasn't changed drastically but
included many important fixes (most of them are revealed
after tested upon Joe's tree and dmts. I recommend other
target developers test their codes on dmts).

Aside the fixes two major new features will be introduced.

Sorted write back
-----------------
In April, a patch to introduce sorting writes
for dm-crypt was introduced.
I thought it is also useful for Writeboost and
decided to do it for Writeboost, too.

This feature is implemented now.

Related thread:
http://www.redhat.com/archives/dm-devel/2014-April/msg00009.html

As a result,
writeback is really efficiently done by Writeboost.
You can see the detail in Section 4 "Benchmarking Results".

Persistent Logging and <type> parameter in constructor
------------------------------------------------------
Writeboost has three layers - RAM buffer, SSD (or cache device) and HDD (or backing device).
The data on the RAM buffer are written on SSD when FLUSH is requested.
Practically, it is not so frequent but in some arbitrary workload
Writeboost performs really badly because of the overhead of writing the RAM buffer
on each FLUSH request.

Persistent Logging is to solve this problem.
It writes the dirty data into Persistent Logging Device (plog_dev)
to reduce this overhead.

For more detail, please read writeboost.pdf.
DOWNLOAD: https://github.com/akiradeveloper/dm-writeboost/blob/develop/doc/writeboost.pdf?raw=true

3. What we are gonna do?
We are engaged in investigating Writeboost 
in terms of what kind of workload is good/bad for Writeboost
and the all tests are in the dmts.
URL: https://github.com/jthornber/device-mapper-test-suite

The on-going discussion between I and Joe is
accessible in dmts. If you are interested in Writeboost
I recommend you to watch the repository.

It will be also thankful if you join us on this work.
Since my hardware environment is not rich,
testing this accelerator on richer environment
will help me a lot.
Especially, I want to test Writeboost with
RAID-ed backing device (e.g. 100-HDDs).

4. Benchmarking Results

I will share the latest benchmark result on my hardware environment.
FYI, formerly, I share this benchmark (randwrite throughput).
http://www.redhat.com/archives/dm-devel/2014-February/msg00000.html

Summary:
Stacking Writeboost on a spindle block device
will reveal these benefits.

- It will always improve writes. If the cache device is small
  and the dirties are always overflown. This is because of the 
  optimization in writeback algorithm. I think the sorting
  really affects. This is supported by the test (A).
- Writeboost doesn't much deteriorate the read although it splits
  the I/O into 4KB fragments. This is supported by (B).
- Even in read-many workload, Writeboost performs really nicely.
  This is supported by (C).
- In realistic workload, Writeboost Type1 really improves the score.
  This is supported by (D).

Test: Writeboost in comparison with backing device only (i.e. wo Writeboost)
(A) 128MB writes to the HDD: Type0 (batch size:256) improves 396% 
(B) 128MB reads: Type0 1% slower (iosize=128KB)
(C) Git Extract: Type0 22% faster (Total time)
(D) dbench: Type1 improves 234%-299% (depends on the option)

Details:

(A) writeback_sorting_effect
To see how writeback optimization effects the time to
complete all writeback is measured.
As the number of segments batched in writeback is the
major factor in writeback optimization we will see how
this parameter affects by changing it.

Note the data amount to write is 128MB.

WriteboostTestsBackingDevice
  Elapsed 118.693293268

WriteboostTestsType0
  Elapsed 117.053297884: batch_size(4)
  Elapsed 76.709325916: batch_size(32)
  Elapsed 47.994442515: batch_size(128)
  Elapsed 29.953923952: batch_size(256)

The bigger the batched size is the elapsed time is shortened.
The best case is 118.69 -> 29.95 sec (x3.96)
It is easy to imagine more higher batch_size will be more gain.

This result means Writeboost has a potential to act as
really efficient I/O scheduler. In batch_size(256)
it submits 127 * 256 4KB blocks in sorted order
asynchronously.

(B) fio_read_overhead
On read, Writeboost splits the I/O and experiences
cache lookup for each split. This is not free.

This tests just reads 128MB by the iosize specified.
With Writeboost, it never read-hits because Writeboost
never caches on read.

WriteboostTestsBackingDevice
  Elapsed 430.314465782: iosize=1k
  Elapsed 217.09349141: iosize=2k
  Elapsed 110.633395391: iosize=4k
  Elapsed 56.652597528: iosize=8k
  Elapsed 29.65688052: iosize=16k
  Elapsed 16.564318187: iosize=32k
  Elapsed 9.679151882: iosize=64k
  Elapsed 6.306119032: iosize=128k

WriteboostTestsType0
  Elapsed 430.062210932: iosize=1k
  Elapsed 217.630954333: iosize=2k
  Elapsed 110.115843367: iosize=4k
  Elapsed 56.863948191: iosize=8k
  Elapsed 29.978668891: iosize=16k
  Elapsed 16.532206415: iosize=32k
  Elapsed 9.807747472: iosize=64k
  Elapsed 6.366230798: iosize=128k

The tendency is that
with Writeboost deteriorates its read
as the iosize gets bigger.
This is because of splitting overhead gets bigger.
When the iosize=128k the deterioration ratio is 1%.

Despite depends on the use-case,
this is enough small for real-world systems
that is equipped with RAM that is used as page cache.

As you imagine, the overhead is getting dominant
as the backing device is faster. To see the
case backing device is extraordinarily fast
I ran this experiments with SSD as the backing device
(I use a HDD as the backing device in above result)

WriteboostTestsBackingDevice
  Elapsed 7.359187932: iosize=1k
  Elapsed 4.810739394: iosize=2k
  Elapsed 2.092146925: iosize=4k
  Elapsed 3.477345334: iosize=8k
  Elapsed 0.992550734: iosize=16k
  Elapsed 0.890939955: iosize=32k
  Elapsed 0.862750482: iosize=64k
  Elapsed 0.964657796: iosize=128k

WriteboostTestsType0
  Elapsed 7.603870984: iosize=1k
  Elapsed 4.124003115: iosize=2k
  Elapsed 2.026922929: iosize=4k
  Elapsed 1.779826802: iosize=8k
  Elapsed 1.378827526: iosize=16k
  Elapsed 1.258259695: iosize=32k
  Elapsed 1.219117654: iosize=64k
  Elapsed 1.301907586: iosize=128k

I don't know why with Writeboost (below)
wins pure SSD in iosize=2, 4 and 8k but
it tends to perform worse than pure SSD.
In iosize=128k, it shows 26% loss.
However, the throughput is almost 100MB/sec and
making a RAID-ed HDDs that performs 100MB/sec 
randread is really hard. So, practically,
Writeboost's overhead on read is acceptable 
if we use 10-100 HDDs as the backing device.
(I want to actually test on such environment but
 don't have such hardwares...)

(C) git_extract_cache_quick
Git extract does "git checkout" several times on linux tree.
This test is really read-many and caches seldom hit on read. 
As a application workload that is not good for Writeboost,
this benchmark means.

WriteboostTestsBackingDevice
  Elapsed 52.494120792: git_prepare
  Elapsed 276.545543981: extract all versions
  Finished in 331.363683334 seconds

WriteboostTestsType0
  Elapsed 46.966797484: git_prepare
  Elapsed 215.305219932: extract all versions
  Finished in 270.176494226 seconds.

WriteboostTestsType1
  Elapsed 83.344358679: git_prepare
  Elapsed 236.562481129: extract all versions
  Finished in 329.684926274 seconds.

With Writeboost it wins the pure HDD.
In total time, it shows 22% faster.

(D) do_dbench
This test runs dbench program with three different 
options (none, -S, -s). -S means only directory operations
are SYNC and -s means all operations are SYNC.
dbench is a benchmark program that emulates fileserver workload.

WriteboostTestsBackingDevice
none: 28.24 MB/sec
-S  : 12.21 MB/sec
-s  :  4.01 MB/sec

WriteboostTestsType0
none: 29.28 MB/sec
-S  :  8.76 MB/sec
-s  :  4.67 MB/sec

WriteboostTestsType1 (with Persistent Logging)
none: 66.36 MB/sec
-S  : 29.35 MB/sec
-s  : 12.00 MB/sec

This benchmark shows that Persistent Logging
really improves the performance (always more than double).
Especially, with -s option (all operations are sync)
the performance is tripled.
However, as the Git extract case shows
Type1 is not always the winner. It depends on the workload.

In -S case, Type0 performs really poorly.
This is because of the said overhead in the "new feature" section.
However, we can improve this by tuning the parameter
"segment_size_order" and "barrier_deadline_ms".
Set smaller number to these parameters can improve the response to the
FLUSH request at the sacrifice of maximum write performance.


Thanks for reading
- Akira
