Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585AbaEHXnO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 19:43:14 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:44007 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbaEHXnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 19:43:12 -0400
Message-ID: <536C168B.6090702@linaro.org>
Date: Thu, 08 May 2014 16:43:07 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Robert Love <rlove@google.com>,
        Mel Gorman <mel@csn.ul.ie>, Hugh Dickins <hughd@google.com>,
        Dave Hansen <dave@sr71.net>, Rik van Riel <riel@redhat.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        Neil Brown <neilb@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Mike Hommey <mh@glandium.org>, Taras Glek <tglek@mozilla.com>,
        Jan Kara <jack@suse.cz>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Michel Lespinasse <walken@google.com>,
        Keith Packard <keithp@keithp.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH 2/4] MADV_VOLATILE: Add MADV_VOLATILE/NONVOLATILE hooks
 and handle marking vmas
References: <1398806483-19122-1-git-send-email-john.stultz@linaro.org> <1398806483-19122-3-git-send-email-john.stultz@linaro.org> <20140508012142.GA5282@bbox> <536BB310.1050105@linaro.org> <20140508231259.GA25951@bbox>
In-Reply-To: <20140508231259.GA25951@bbox>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/08/2014 04:12 PM, Minchan Kim wrote:
> On Thu, May 08, 2014 at 09:38:40AM -0700, John Stultz wrote:
>> On 05/07/2014 06:21 PM, Minchan Kim wrote:
>>> Hey John,
>>>
>>> On Tue, Apr 29, 2014 at 02:21:21PM -0700, John Stultz wrote:
>>>> This patch introduces MADV_VOLATILE/NONVOLATILE flags to madvise(),
>>>> which allows for specifying ranges of memory as volatile, and able
>>>> to be discarded by the system.
>>>>
>>>> This initial patch simply adds flag handling to madvise, and the
>>>> vma handling, splitting and merging the vmas as needed, and marking
>>>> them with VM_VOLATILE.
>>>>
>>>> No purging or discarding of volatile ranges is done at this point.
>>>>
>>>> This a simplified implementation which reuses some of the logic
>>>> from Minchan's earlier efforts. So credit to Minchan for his work.
>>> Remove purged argument is really good thing but I'm not sure merging
>>> the feature into madvise syscall is good idea.
>>> My concern is how we support user who don't want SIGBUS.
>>> I believe we should support them because someuser(ex, sanitizer) really
>>> want to avoid MADV_NONVOLATILE call right before overwriting their cache
>>> (ex, If there was purged page for cyclic cache, user should call NONVOLATILE
>>> right before overwriting to avoid SIGBUS).
>> So... Why not use MADV_FREE then for this case?
> MADV_FREE is one-shot operation. I mean we should call it again to make
> them lazyfree while vrange could preserve volatility.
> Pz, think about thread-sanitizer usecase. They do mmap 70TB once start up
> and want to mark the range as volatile. If they uses MADV_FREE instead of
> volatile, they should mark 70TB as lazyfree periodically, which is terrible
> because MADV_FREE's cost is O(N).

I still have had difficulty seeing the thread-sanitizer usage as a
generic enough model for other applications. I realize they want to
avoid marking and unmarking ranges (and they want that marking and
unmarking to be very cheap), but the zero-fill purged page (while still
preserving volatility) causes lots of *very* strange behavior:

* How do general applications know the difference between a purged page
and a valid empty page?
* When reading/writing a page, what happens if half-way the application
is preempted, and the page is purged?
* If a volatile page is purged, then zero-filled on a read or write,
what is its purged state when we're marking it non-volatile?

These use cases don't seem completely baked, or maybe I've just not been
able to comprehend them yet. But I don't quite understand the desire to
prioritize this style of usage over other simpler and more well
established usage?

I'll grant that there may be some form of semantics that work for this,
and I'm open to considering support for those at some point if they
become more clear, but I don't think these stranger(to me at least)
cases should be the default, and I really worry that these requests
continue to make the basic usage harder to understand for reviewers.


>> Just to be clear, by moving back to madvise, I'm not trying to replace
>> MADV_FREE. I think you're work there is still useful and splitting the
>> semantics between the two is cleaner.
> I know.
> New vrange syscall which works with existing VMA instead of new vrange
> interval tree removed big concern from mm folks about duplicating
> of manage layer(ex, vm_area_struct and vrange inteval tree) and
> it removed my concern that mmap_sem write-side lock scalability for
> allocator usecase so we can make the implemenation simple and clear.
> I like it but zero-page VS SIGBUS is another issue we should make an
> agreement.

Zero-fill makes sense to me for MADV_FREE, where we're not trying to
recover the data, but just save the cost of releasing and re-faulting
possibly frequently used pages. The contents are not intended to be
recovered. Thus semantics there are reasonable.

With volatility (which persists until marked non-volatile), zero-filled
purged page access breaks quite a bit of the established semantics (see
the strange behavior questions listed above).

With SIGBUS semantics, its very clear and much more simple. The
application has hit an page that no longer exists and is clearly
notified (via SIGBUS). There's no way for the purged state to become
lost (other then the application ignoring the return value from
MADV_NONVOLATILE).

Again, I do understand that folks want a solution to the
thread-sanitizer usage model, but I really think, much as we found with
MADV_FREE, that its really a quite different semantics that are wanted,
and trying to mix them doesn't help get anything reviewed/merged.

thanks
-john

