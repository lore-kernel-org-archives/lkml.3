Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423460Ab3CVXck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 19:32:40 -0400
Received: from mail-wg0-f53.google.com ([74.125.82.53]:55916 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423061Ab3CVXci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 19:32:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130322203652.GC19091@google.com>
References: <1363977199-1507-1-git-send-email-octavian.purdila@intel.com>
	<20130322203652.GC19091@google.com>
Date: Fri, 22 Mar 2013 16:32:36 -0700
Message-ID: <CAE1zot+ij8KBS6WDe0W=e5vobNwDLa0UDo66i1N0b6p7cfxdXQ@mail.gmail.com>
Subject: Re: [PATCH] aio: convert the ioctx list to radix tree
From: Octavian Purdila <octavian.purdila@intel.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-s390@vger.kernel.org, bcrl@kvack.org, schwidefsky@de.ibm.com,
        kirill.shutemov@linux.intel.com, Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 1:36 PM, Kent Overstreet <koverstreet@google.com> wrote:
> On Fri, Mar 22, 2013 at 08:33:19PM +0200, Octavian Purdila wrote:
>> When using a large number of threads performing AIO operations the
>> IOCTX list may get a significant number of entries which will cause
>> significant overhead. For example, when running this fio script:
>>
>> rw=randrw; size=256k ;directory=/mnt/fio; ioengine=libaio; iodepth=1
>> blocksize=1024; numjobs=512; thread; loops=100
>>
>> on an EXT2 filesystem mounted on top of a ramdisk we can observe up to
>> 30% CPU time spent by lookup_ioctx:
>>
>>  32.51%  [guest.kernel]  [g] lookup_ioctx
>>   9.19%  [guest.kernel]  [g] __lock_acquire.isra.28
>>   4.40%  [guest.kernel]  [g] lock_release
>>   4.19%  [guest.kernel]  [g] sched_clock_local
>>   3.86%  [guest.kernel]  [g] local_clock
>>   3.68%  [guest.kernel]  [g] native_sched_clock
>>   3.08%  [guest.kernel]  [g] sched_clock_cpu
>>   2.64%  [guest.kernel]  [g] lock_release_holdtime.part.11
>>   2.60%  [guest.kernel]  [g] memcpy
>>   2.33%  [guest.kernel]  [g] lock_acquired
>>   2.25%  [guest.kernel]  [g] lock_acquire
>>   1.84%  [guest.kernel]  [g] do_io_submit
>>
>> This patchs converts the ioctx list to a radix tree. For a performance
>> comparison the above FIO script was run on a 2 sockets 8 core
>> machine. This are the results for the original list based
>> implementation and for the radix tree based implementation:
>
> The biggest reason the overhead is so high is that the kioctx's
> hlist_node shares a cacheline with the refcount. Did you check what just
> fixing that does? My aio patch series (in akpm's tree) fixes that.
>

Hi Kent,

Just checked, and I don't see any improvements for this particular workload.

> Also, why are you using so many kioctxs? I can't think any good reason
> why userspace would want to - you really want to use only one or a few
> (potentially one per cpu) so that events can get serviced as soon as a
> worker thread is available.
>

For servers, 1 kioctx per core can easily translate to 16-32 kioctxes.
And you probably want to oversubscribe the cores, especially since IO
is getting faster these days. So, I think 512 is not such an
outrageously large number of kioctxes.

> Currently there are applications using many kioctxs to work around the
> fact that performance is terrible when you're sharing kioctxs between
> threads - but that's fixed in my aio patch series.
>
> In fact, we want userspace to be using as few kioctxs as they can so we
> can benefit from batch completion.
>

I think that using multiple contexts has its uses, with your great
series not for I/O performance anymore :) , but for example for I/O
operations management/grouping. Then, there is the case of existing
applications, it would be nice to have them perform better without
rewriting them. So, I think that this patch is complementary to your
work.
