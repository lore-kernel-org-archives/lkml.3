Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758388AbaCSAX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 20:23:59 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:45970 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756851AbaCSAX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 20:23:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140319001826.GA13475@bbox>
References: <1394779070-8545-1-git-send-email-minchan@kernel.org>
 <5328888C.7030402@mit.edu> <20140319001826.GA13475@bbox>
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 18 Mar 2014 17:23:37 -0700
Message-ID: <CALCETrUsgVgKDRjqY=7avbvowkNSn-CWJ3L9zti1SCOYgrY3UA@mail.gmail.com>
Subject: Re: [RFC 0/6] mm: support madvise(MADV_FREE)
To: Minchan Kim <minchan@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>, Jason Evans <je@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 18, 2014 at 5:18 PM, Minchan Kim <minchan@kernel.org> wrote:
> Hello,
>
> On Tue, Mar 18, 2014 at 10:55:24AM -0700, Andy Lutomirski wrote:
>> On 03/13/2014 11:37 PM, Minchan Kim wrote:
>> > This patch is an attempt to support MADV_FREE for Linux.
>> >
>> > Rationale is following as.
>> >
>> > Allocators call munmap(2) when user call free(3) if ptr is
>> > in mmaped area. But munmap isn't cheap because it have to clean up
>> > all pte entries, unlinking a vma and returns free pages to buddy
>> > so overhead would be increased linearly by mmaped area's size.
>> > So they like madvise_dontneed rather than munmap.
>> >
>> > "dontneed" holds read-side lock of mmap_sem so other threads
>> > of the process could go with concurrent page faults so it is
>> > better than munmap if it's not lack of address space.
>> > But the problem is that most of allocator reuses that address
>> > space soonish so applications see page fault, page allocation,
>> > page zeroing if allocator already called madvise_dontneed
>> > on the address space.
>> >
>> > For avoidng that overheads, other OS have supported MADV_FREE.
>> > The idea is just mark pages as lazyfree when madvise called
>> > and purge them if memory pressure happens. Otherwise, VM doesn't
>> > detach pages on the address space so application could use
>> > that memory space without above overheads.
>>
>> I must be missing something.
>>
>> If the application issues MADV_FREE and then writes to the MADV_FREEd
>> range, the kernel needs to know that the pages are no longer safe to
>> lazily free.  This would presumably happen via a page fault on write.
>> For that to happen reliably, the kernel has to write protect the pages
>> when MADV_FREE is called, which in turn requires flushing the TLBs.
>
> It could be done by pte_dirty bit check. Of course, if some architectures
> don't support it by H/W, pte_mkdirty would make it CoW as you said.

If the page already has dirty PTEs, then you need to clear the dirty
bits and flush TLBs so that other CPUs notice that the PTEs are clean,
I think.

Also, this has very odd semantics wrt reading the page after MADV_FREE
-- is reading the page guaranteed to un-free it?

>>
>> How does this end up being faster than munmap?
>
> MADV_FREE doesn't need to return back the pages into page allocator
> compared to MADV_DONTNEED and the overhead is not small when I measured
> that on my machine.(Roughly, MADV_FREE's cost is half of DONTNEED through
> avoiding involving page allocator.)
>
> But I'd like to clarify that it's not MADV_FREE's goal that syscall
> itself should be faster than MADV_DONTNEED but major goal is to
> avoid unnecessary page fault + page allocation + page zeroing +
> garbage swapout.

This sounds like it might be better solved by trying to make munmap or
MADV_DONTNEED faster.  Maybe those functions should lazily give pages
back to the buddy allocator.

--Andy
