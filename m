Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756976Ab3CNLqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 07:46:32 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47373 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756768Ab3CNLqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 07:46:31 -0400
Date: Thu, 14 Mar 2013 20:46:18 +0900 (JST)
Message-Id: <20130314.204618.00667752.d.hatayama@jp.fujitsu.com>
To: vgoyal@redhat.com, ebiederm@xmission.com, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        akpm@linux-foundation.org, kingboard.ma@hp.com
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: makedumpfile: benchmark on mmap() with /proc/vmcore
From: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>
X-Mailer: Mew version 6.3 on Emacs 24.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I did benchmark makedumpfile performance with mmap() on /proc/vmcore
on 32GB memory system. Even smaller than terabytes memory, it's
possible to see performance improvement precisely to some amount.

However, it's definitely necessary to see how performance is changed
on terabyte-class memory system. Of course, I'll do it and I'm
reserving the system now, but it's restricted on 2TB memory system. If
anyone wants to see performance on more memory system, please help.

In summary, this benchmark shows the improvement from 4.5 seconds to
0.6 seconds for filtering processing on 32GB memory. Roughly, this
corresponds to 19.2 seconds on 1TB memory.

= Machine spec
  - CPU: Intel(R) Xeon(R) CPU E7- 4820 @ 2.00GHz (4 sockets, 8 cores) (*)
  - memory: 32GB
    - vmcore size: 31.7GB
  - kernel
    - 3.9-rc1 with the patch set in: http://lists.infradead.org/pipermail/kexec/2013-March/008092.html
    - 3.8.2-206.fc18.x86_64 for makedumpfile v1.5.1
  - kexec tools: commit: 53bb3029557936ed12960e7cc2619a20ee7d382b
    # v2.0.4-rc1 failed to be compiled.

  (*) only 1 cpu is used in the 2nd kernel now.

= Makedumpfile

I used the following three versions of makedumpfile:

- v1.5.1
  - cyclic mode + free pages filtering on mem_map array was introduced.

- v1.5.2
  - 8-slot cache was introduced

- v1.5.2-map: git map branch
  - mmap() on /proc/vmcore.
  - To use mmap, specify --map-size <size in kilo-bytes> option.

= How to measure

I collected time contained in makedumpfile's report message as
follows:

$ makedumpfile --message-level 31 -p -d 31 /proc/vmcore vmcore-pd31
...
STEP [Checking for memory holes  ] : 0.163673 seconds
STEP [Excluding unnecessary pages] : 1.321702 seconds
STEP [Excluding free pages       ] : 0.489022 seconds
STEP [Copying data               ] : 26.221380 seconds

The message starting with "STEP [Excluding" corresponds to the message
of filtering processing.

- STEP [Excluding unnecessary pages] corresponds to the time for
  mem_map array logic.

- STEP [Excluding free pages ] corresponds to the time for free list
  logic.

I didn't collect times for other two messages here.

The message is displayed multiple times in cyclic mode, exactly the
same number of cycles. But note that throughout this benchmark, the
number of cycles is 1. Much more memory system must need more cycles.

= Benchmark Result

v1.5.1
| cyclic            | non-cyclic        | non-cyclic |
| unnecessary pages | unnecessary pages | free pages |
|-------------------+-------------------+------------|
| 4.618960          | 4.443426          | 1.058048   |

v1.5.2
| cyclic            | non-cyclic        | non-cyclic |
| unnecessary pages | unnecessary pages | free pages |
|-------------------+-------------------+------------|
| 1.438702          | 1.321702          | 0.489022   |

v1.5.2 with mmap
| map size |            cyclic |        non-cyclic | non-cyclic |
|    (KiB) | unnecessary pages | unnecessary pages | free pages |
|----------+-------------------+-------------------+------------|
|        4 |          1.319516 |          1.171109 |   0.247905 |
|        8 |          0.977871 |          0.847379 |   0.253978 |
|       16 |          0.798567 |          0.676428 |   0.261278 |
|       32 |          0.712903 |          0.576884 |   0.267791 |
|       64 |          0.660195 |          0.544579 |   0.266696 |
|      128 |          0.635026 |          0.503244 |   0.279830 |
|      256 |          0.618651 |          0.486801 |   0.304053 |
|      512 |          0.612802 |          0.479643 |   0.350388 |
|     1024 |          0.606328 |          0.480465 |   0.434638 |
|     2048 |          0.604407 |          0.473270 |   0.555480 |
|     4096 |          0.602786 |          0.471901 |   0.745003 |
|     8192 |          0.598396 |          0.468123 |   1.264968 |
|    16384 |          0.598102 |          0.467604 |   2.604322 |
|    32768 |          0.597832 |          0.469231 |   5.336002 |

= Discussion

- From v1.5.2 to v1.5.1, simple 8-slot cache mechanism was
  introduced. By this, access time to /proc/vmcore for paging is
  reduced from about 4.5 to about 1.5.

- On v1.5.2 with mmap: if map size is 4KB, the perforamce looks
  similar to v1.5.2's ioremap case. If large enough map size is
  specified, there's no longer pernalty due to TLB flush caused by
  ioremap/iounmap from access to /proc/vmcore.

- In non-cyclic mode, it takes about 0.5 second to filter a whole
  mem_map array.

- In cyclic mode, it takes about 0.6 second to filter a whole mem_map
  array.

  What is the additional 0.1 second compared to the one in non-cyclic
  mode? One of the reasons is that in cyclic mode, filtering
  processing includes the case for free pages in addition to other
  kind of memory. That is, it's part the below:

  makedumpfile.c:__exclude_unnecessary_pages
                /*
                 * Exclude the free page managed by a buddy
                 */
                if ((info->dump_level & DL_EXCLUDE_FREE)
                    && info->flag_cyclic
                    && info->page_is_buddy
                    && info->page_is_buddy(flags, _mapcount, private, _count)) {

  If we don't specify free pages filitering, the time is reduced from
  0.6 to 0.55 ~ 0.57.

  I guess the remaining 0.07 second was caused by duplicate processing
  in the implementation of cyclic-mode. I don't know now if this can
  actually be problematic on terabyte memory machine, but then it
  indicates we should treat __exclude_unnecessary_page() as fast path,
  and I think it's possible to remove the duplication if necessary.

- For degradation in case of free list with large map size, to be
  honest, I have yet to investigate why precisely now... I guess it's
  caused by the fact that elements linked in free list is not sorted
  increasing order with regard to pfn, so the degradation comes from
  the many calls of mmap() with large map size just like cache miss
  hit.

Thanks.
HATAYAMA, Daisuke

