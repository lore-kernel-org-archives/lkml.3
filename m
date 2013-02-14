Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760Ab3BNKLt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 05:11:49 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:48678 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab3BNKLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 05:11:46 -0500
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
Subject: [PATCH 00/13] kdump, vmcore: support mmap() on /proc/vmcore
To: ebiederm@xmission.com, vgoyal@redhat.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Thu, 14 Feb 2013 19:11:43 +0900
Message-ID: <20130214100945.22466.4172.stgit@localhost6.localdomain6>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, read to /proc/vmcore is done by read_oldmem() that uses
ioremap/iounmap per a single page. For example, if memory is 1GB,
ioremap/iounmap is called (1GB / 4KB)-times, that is, 262144
times. This causes big performance degradation.

To address the issue, this patch implements mmap() on /proc/vmcore to
improve read performance. My simple benchmark shows the improvement
from 200 [MiB/sec] to over 50.0 [GiB/sec].

Benchmark
=========

= Machine spec
  - CPU: Intel(R) Xeon(R) CPU E7- 4820 @ 2.00GHz (4 sockets, 8 cores) (*)
  - memory: 32GB
  - kernel: 3.8-rc6 with this patch
  - vmcore size: 31.7GB

  (*) only 1 cpu is used in the 2nd kernel now.

= Benchmark Case

1) copy /proc/vmcore *WITHOUT* mmap() on /proc/vmcore

$ time dd bs=4096 if=/proc/vmcore of=/dev/null
8307246+1 records in
8307246+1 records out
real    2m 31.50s
user    0m 1.06s
sys     2m 27.60s

So performance is 214.26 [MiB/sec].

2) copy /proc/vmcore with mmap()

  I ran the next command and recorded real time:

  $ for n in $(seq 1 15) ; do \
  >   time copyvmcore2 --blocksize=$((4096 * (1 << (n - 1)))) /proc/vmcore /dev/null \
  > done

  where copyvmcore2 is an ad-hoc test tool that read data from
  /proc/vmcore via mmap() in given block-size unit and write them to
  some file.

|  n | map size |  time | page table | performance |
|    |          | (sec) |            |   [GiB/sec] |
|----+----------+-------+------------+-------------|
|  1 | 4 KiB    | 78.35 | 8 iB       |        0.40 |
|  2 | 8 KiB    | 45.29 | 16 iB      |        0.70 |
|  3 | 16 KiB   | 23.82 | 32 iB      |        1.33 |
|  4 | 32 KiB   | 12.90 | 64 iB      |        2.46 |
|  5 | 64 KiB   |  6.13 | 128 iB     |        5.17 |
|  6 | 128 KiB  |  3.26 | 256 iB     |        9.72 |
|  7 | 256 KiB  |  1.86 | 512 iB     |       17.04 |
|  8 | 512 KiB  |  1.13 | 1 KiB      |       28.04 |
|  9 | 1 MiB    |  0.77 | 2 KiB      |       41.16 |
| 10 | 2 MiB    |  0.58 | 4 KiB      |       54.64 |
| 11 | 4 MiB    |  0.50 | 8 KiB      |       63.38 |
| 12 | 8 MiB    |  0.46 | 16 KiB     |       68.89 |
| 13 | 16 MiB   |  0.44 | 32 KiB     |       72.02 |
| 14 | 32 MiB   |  0.44 | 64 KiB     |       72.02 |
| 15 | 64 MiB   |  0.45 | 128 KiB    |       70.42 |

3) copy /proc/vmcore with mmap() on /dev/oldmem

I posted another patch series for mmap() on /dev/oldmem a few weeks ago.
See: https://lkml.org/lkml/2013/2/3/431

Next is the table shown on the post showing the benchmark.

|  n | map size |  time | page table | performance |
|    |          | (sec) |            |   [GiB/sec] |
|----+----------+-------+------------+-------------|
|  1 | 4 KiB    | 41.86 | 8 iB       |        0.76 |
|  2 | 8 KiB    | 25.43 | 16 iB      |        1.25 |
|  3 | 16 KiB   | 13.28 | 32 iB      |        2.39 |
|  4 | 32 KiB   |  7.20 | 64 iB      |        4.40 |
|  5 | 64 KiB   |  3.45 | 128 iB     |        9.19 |
|  6 | 128 KiB  |  1.82 | 256 iB     |       17.42 |
|  7 | 256 KiB  |  1.03 | 512 iB     |       30.78 |
|  8 | 512 KiB  |  0.61 | 1K iB      |       51.97 |
|  9 | 1 MiB    |  0.41 | 2K iB      |       77.32 |
| 10 | 2 MiB    |  0.32 | 4K iB      |       99.06 |
| 11 | 4 MiB    |  0.27 | 8K iB      |      117.41 |
| 12 | 8 MiB    |  0.24 | 16 KiB     |      132.08 |
| 13 | 16 MiB   |  0.23 | 32 KiB     |      137.83 |
| 14 | 32 MiB   |  0.22 | 64 KiB     |      144.09 |
| 15 | 64 MiB   |  0.22 | 128 KiB    |      144.09 |

= Discussion

- For small map size, we can see performance degradation on mmap()
  case due to many page table modification and TLB flushes similarly
  to read_oldmem() case. But for large map size we can see the
  improved performance.

  Each application need to choose appropreate map size for their
  preferable performance.

- mmap() on /dev/oldmem appears better than that on /proc/vmcore. But
  actual processing does not only copying but also IO work. This
  difference is not a problem.

- Both mmap() case shows drastically better performance than previous
  RFC patch set's about 2.5 [GiB/sec] that maps all dump target memory
  in kernel direct mapping address space. This is because there's no
  longer memcpy() from kernel-space to user-space.

Design
======

= Support Range

- mmap() on /proc/vmcore is supported on ELF64 interface only. ELF32
  interface is used only if dump target size is less than 4GB. Then,
  the existing interface is enough in performance.

= Change of /proc/vmcore format

For mmap()'s page-size boundary requirement, /proc/vmcore changed its
own shape and now put its objects in page-size boundary.

- Allocate buffer for ELF headers in page-size boundary.
  => See [PATCH 01/13].

- Note objects scattered on old memory are copied in a single
  page-size aligned buffer on 2nd kernel, and it is remapped to
  user-space.
  => See [PATCH 09/13].
  
- The head and/or tail pages of memroy chunks are also copied on 2nd
  kernel if either of their ends is not page-size aligned. See
  => See [PATCH 12/13].

= 32-bit PAE limitation

- On 32-bit PAE limitation, mmap_vmcore() can handle upto 16TB memory
  only since remap_pfn_range()'s third argument, pfn, has 32-bit
  length only, defined as unsigned long type.

TODO
====

- fix makedumpfile to use mmap() on /proc/vmcore and benchmark it to
  confirm whether we can see enough performance improvement.

Test
====

Done on x86-64, x86-32 both with 1GB and over 4GB memory environments.

---

HATAYAMA Daisuke (13):
      vmcore: introduce mmap_vmcore()
      vmcore: copy non page-size aligned head and tail pages in 2nd kernel
      vmcore: count holes generated by round-up operation for vmcore size
      vmcore: round-up offset of vmcore object in page-size boundary
      vmcore: copy ELF note segments in buffer on 2nd kernel
      vmcore: remove unused helper function
      vmcore: modify read_vmcore() to read buffer on 2nd kernel
      vmcore: modify vmcore clean-up function to free buffer on 2nd kernel
      vmcore: modify ELF32 code according to new type
      vmcore: introduce types for objects copied in 2nd kernel
      vmcore: fill unused part of buffer for ELF headers with 0
      vmcore: round up buffer size of ELF headers by PAGE_SIZE
      vmcore: allocate buffer for ELF headers on page-size alignment


 fs/proc/vmcore.c        |  408 +++++++++++++++++++++++++++++++++++------------
 include/linux/proc_fs.h |   11 +
 2 files changed, 313 insertions(+), 106 deletions(-)

-- 

Thanks.
HATAYAMA, Daisuke
