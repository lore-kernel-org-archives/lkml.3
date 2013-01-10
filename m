Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758190Ab3AQBEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:04:01 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:49317 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755859Ab3AQBEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:04:00 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [RFC PATCH v1 0/3] kdump,
 vmcore: Map vmcore memory in direct mapping region
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 10 Jan 2013 20:59:34 +0900
Message-ID: <20130110115615.645.56499.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, kdump reads the 1st kernel's memory, called old memory in
the source code, using ioremap per a single page. This causes big
performance degradation since page tables modification and tlb flush
happen each time the single page is read.

This issue turned out from Cliff's kernel-space filtering work.

To avoid calling ioremap, we map a whole 1st kernel's memory targeted
as vmcore regions in direct mapping table. By this we got big
performance improvement. See the following simple benchmark.

Machine spec:

| CPU    | Intel(R) Xeon(R) CPU E7- 4820  @ 2.00GHz (4 sockets, 8 cores) (*) |
| Memory | 32 GB                                                             |
| Kernel | 3.7 vanilla and with this patch set                               |

 (*) only 1 cpu is used in the 2nd kenrel now.

Benchmark:

I executed the following commands on the 2nd kernel and recorded real
time.

  $ time dd bs=$((4096 * n)) if=/proc/vmcore of=/dev/null

[3.7 vanilla]

| block size | time      | performance |
|       [KB] |           | [MB/sec]    |
|------------+-----------+-------------|
|          4 | 5m 46.97s | 93.56       |
|          8 | 4m 20.68s | 124.52      |
|         16 | 3m 37.85s | 149.01      |

[3.7 with this patch]

| block size | time   | performance |
|       [KB] |        |    [GB/sec] |
|------------+--------+-------------|
|          4 | 17.59s |        1.85 |
|          8 | 14.73s |        2.20 |
|         16 | 14.26s |        2.28 |
|         32 | 13.38s |        2.43 |
|         64 | 12.77s |        2.54 |
|        128 | 12.41s |        2.62 |
|        256 | 12.50s |        2.60 |
|        512 | 12.37s |        2.62 |
|       1024 | 12.30s |        2.65 |
|       2048 | 12.29s |        2.64 |
|       4096 | 12.32s |        2.63 |

[perf bench]

I also did perf bench mem memcpy -o on the 2nd kenrel like:

# /var/crash/perf bench mem memcpy -o -l 128MB
# Running mem/memcpy benchmark...
# Copying 128MB Bytes ...

       2.854337 GB/Sec (with prefault)

Several trials stably showed around 2.85 [GB/Sec].

Notes:

* Why direct mapping region

  I chose direct mapping region because this address space has 64TB
  length to cover a whole physical memory while vmlloc-and-ioremap
  region has 16TB only. For some particular machine with huge memory,
  the latter is already problematic.

  In the near future, machine with more than 64TB could occur, but
  then direct mapping space would also be extended to follow.

* Memory consumption issue on the 2nd kenrel

  Typical reserved memory size for the 2nd kerne is 512MB. But if
  mapping tera-byte memory with 4kB pages, page table size amounts to
  more than giga bytes.

  But direct mapping region is mapped using 1GB and 2MB pages. By
  this, memory consumption for page table is minimamized in most
  cases.

  Boot debug message tells you how each map is mapped:

vmcore: [oldmem 0000000027000000-000000002708afff]
vmcore: [oldmem 0000000000100000-0000000026ffffff]
vmcore: [oldmem 0000000037000000-000000007b00cfff]
vmcore: [oldmem 0000000100000000-000000087fffffff]
 [mem 0x27000000-0x2708afff] page 4k
 [mem 0x00100000-0x001fffff] page 4k
 [mem 0x00200000-0x26ffffff] page 2M
 [mem 0x37000000-0x7affffff] page 2M
 [mem 0x7b000000-0x7b00cfff] page 4k
 [mem 0x100000000-0x87fffffff] page 1G

  where each [oldmem <start>-<end>] is mapped region and I omited some
  other messages.

TODO:

* Use of init_memory_mapping

  init_memory_mapping is used to map memory in direct mapping region
  both in boot time and memory hot-plug codes. This should be used
  here too, but just as I explain in the patch description, I faced
  some page-fault related bugs after it was called in the 2nd kernel
  boot. This means page table mapping is not done correctly.

  As a workaround, I wrote the code constructing page table from
  scratch just like Cliff's patch, and it works well aparently now.

  But ideally it's necessary to know why init_memory_mapping doesn't
  work well. I continue to debug this. Sugestion around this is very
  helpful. This issue comes purely from lack of my familiality around
  here (^^;

* Benchmark of Cliff's kernel-space filtering

  He has attempted kernel-space filtering of makedumpfile for
  performance improvement. I noticed the ioremap issue through his
  this work.

  I now think bad performance is mainly caused by the ioremap issue. I
  don't know how much filtering performance is improved by doing it in
  kernel-space. I guess there's just a similar improvement just like
  increasing block size just as the above benchmark.

  Anyway, we need first to compare kernel-space filtering with
  user-space one.

  Note that this work is orthogonal to kernel-space filtering, can be
  proceeded separately.

---

HATAYAMA Daisuke (3):
      vmcore: read vmcore through direct mapping region
      vmcore: map vmcore memory in direct mapping region
      vmcore: Add function to merge memory mapping of vmcore


 fs/proc/vmcore.c |  420 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 419 insertions(+), 1 deletions(-)

-- 

Thanks.
HATAYAMA, Daisuke
