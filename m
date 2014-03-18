Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbaCRRz3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 13:55:29 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:43103 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757345AbaCRRz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 13:55:27 -0400
Message-ID: <5328888C.7030402@mit.edu>
Date: Tue, 18 Mar 2014 10:55:24 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Rik van Riel <riel@redhat.com>, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave.hansen@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Jason Evans <je@fb.com>
Subject: Re: [RFC 0/6] mm: support madvise(MADV_FREE)
References: <1394779070-8545-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1394779070-8545-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 11:37 PM, Minchan Kim wrote:
> This patch is an attempt to support MADV_FREE for Linux.
> 
> Rationale is following as.
> 
> Allocators call munmap(2) when user call free(3) if ptr is
> in mmaped area. But munmap isn't cheap because it have to clean up
> all pte entries, unlinking a vma and returns free pages to buddy
> so overhead would be increased linearly by mmaped area's size.
> So they like madvise_dontneed rather than munmap.
> 
> "dontneed" holds read-side lock of mmap_sem so other threads
> of the process could go with concurrent page faults so it is
> better than munmap if it's not lack of address space.
> But the problem is that most of allocator reuses that address
> space soonish so applications see page fault, page allocation,
> page zeroing if allocator already called madvise_dontneed
> on the address space.
> 
> For avoidng that overheads, other OS have supported MADV_FREE.
> The idea is just mark pages as lazyfree when madvise called
> and purge them if memory pressure happens. Otherwise, VM doesn't
> detach pages on the address space so application could use
> that memory space without above overheads.

I must be missing something.

If the application issues MADV_FREE and then writes to the MADV_FREEd
range, the kernel needs to know that the pages are no longer safe to
lazily free.  This would presumably happen via a page fault on write.
For that to happen reliably, the kernel has to write protect the pages
when MADV_FREE is called, which in turn requires flushing the TLBs.

How does this end up being faster than munmap?

--Andy
