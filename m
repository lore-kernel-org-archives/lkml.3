Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab3EMVB5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 17:01:57 -0400
Received: from mail-ia0-f173.google.com ([209.85.210.173]:38889 "EHLO
	mail-ia0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab3EMVB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 17:01:56 -0400
MIME-Version: 1.0
In-Reply-To: <20130510211538.GD7801@google.com>
References: <1366026055-28604-1-git-send-email-octavian.purdila@intel.com>
	<20130510134015.ac8ad56305c539fa9bd8b5a7@linux-foundation.org>
	<20130510211538.GD7801@google.com>
Date: Tue, 14 May 2013 00:01:55 +0300
Message-ID: <CAE1zot+KAtuOK+O2EAraqEn-5n9ZzpiAVSyLS0mT-Vgz8u5Ujg@mail.gmail.com>
Subject: Re: [PATCH v3 next/akpm] aio: convert the ioctx list to radix tree
From: Octavian Purdila <octavian.purdila@intel.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-s390@vger.kernel.org, bcrl@kvack.org,
        schwidefsky@de.ibm.com,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Zach Brown <zab@redhat.com>, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 11, 2013 at 12:15 AM, Kent Overstreet
<koverstreet@google.com> wrote:
> On Fri, May 10, 2013 at 01:40:15PM -0700, Andrew Morton wrote:
>> On Mon, 15 Apr 2013 14:40:55 +0300 Octavian Purdila <octavian.purdila@intel.com> wrote:
>>
>> > When using a large number of threads performing AIO operations the
>> > IOCTX list may get a significant number of entries which will cause
>> > significant overhead. For example, when running this fio script:
>> >
>> > rw=randrw; size=256k ;directory=/mnt/fio; ioengine=libaio; iodepth=1
>> > blocksize=1024; numjobs=512; thread; loops=100
>> >
>> > on an EXT2 filesystem mounted on top of a ramdisk we can observe up to
>> > 30% CPU time spent by lookup_ioctx:
>> >
>> >  32.51%  [guest.kernel]  [g] lookup_ioctx
>> >   9.19%  [guest.kernel]  [g] __lock_acquire.isra.28
>> >   4.40%  [guest.kernel]  [g] lock_release
>> >   4.19%  [guest.kernel]  [g] sched_clock_local
>> >   3.86%  [guest.kernel]  [g] local_clock
>> >   3.68%  [guest.kernel]  [g] native_sched_clock
>> >   3.08%  [guest.kernel]  [g] sched_clock_cpu
>> >   2.64%  [guest.kernel]  [g] lock_release_holdtime.part.11
>> >   2.60%  [guest.kernel]  [g] memcpy
>> >   2.33%  [guest.kernel]  [g] lock_acquired
>> >   2.25%  [guest.kernel]  [g] lock_acquire
>> >   1.84%  [guest.kernel]  [g] do_io_submit
>> >
>> > This patchs converts the ioctx list to a radix tree.
>>
>> The patch looks nice.  One thing we should pay attention to is the
>> memory consumption.  radix-trees can be far less space-efficient than
>> lists, and as the tree key comes from mmap() it can be pretty sparsely
>> distributed.
>>
>> So could you please have a think about this, see if we can cook up some
>> worst-case numbers and decide if they are problematic?
>
> Because the overhead of an ioctx is so high (ringbuffer is some number
> of pages) it shouldn't matter much - but I wouldn't mind seeing a bit of
> arithmatic.


The worst case seems to be when we are running on 64 bits and
CONFIG_BASE_SMALL is enable. In that case, if the aio_rings are mapped
dispersed enough (4 bits "space" between mappings, e.g. at 0, 0x400,
0x4000, 0x40000, etc.) then we will have to allocate a full depth
branch, in this case 13 nodes: (64-PAGE_SIZE_BITS)/4.

That adds up to 7384 just for the radix tree, per aio context, with a
radix_tree_node size of 568. Besides that, the minimum memory
allocated for an aio context seems to be 4928 bytes (one page +
sizeof(kioctx)), if I did not miss anything. That looks like a 300%
increase in memory consumption.

However, I am not sure if the worst case is so relevant in practice.
As the number of entries grows the overhead reduces, as some of nodes
can be shared. Also, when the address space is that pathologically
sparse, shouldn't the radix tree used for memory management suffer
from the same problem?
