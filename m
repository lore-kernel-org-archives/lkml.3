Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755177Ab3KTUQs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:16:48 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:38357 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754969Ab3KTUQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:16:47 -0500
Message-ID: <528D18AB.5020009@vmware.com>
Date: Wed, 20 Nov 2013 21:16:43 +0100
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>
CC: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-graphics-maintainer@vmware.com
Subject: Re: [PATCH RFC 0/3] Add dirty-tracking infrastructure for non-page-backed
 address spaces
References: <1384891576-7851-1-git-send-email-thellstrom@vmware.com> <528BEB60.7040402@amacapital.net> <528C6ED9.3070600@vmware.com> <CALCETrXFqV1S6qVsxHRDrxw-trGK0O4Jf1rXOFwze4JL0uAEAA@mail.gmail.com>
In-Reply-To: <CALCETrXFqV1S6qVsxHRDrxw-trGK0O4Jf1rXOFwze4JL0uAEAA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/20/2013 05:50 PM, Andy Lutomirski wrote:
> On Wed, Nov 20, 2013 at 12:12 AM, Thomas Hellstrom
> <thellstrom@vmware.com> wrote:
>> On 11/19/2013 11:51 PM, Andy Lutomirski wrote:
>>> On 11/19/2013 12:06 PM, Thomas Hellstrom wrote:
>>>> Hi!
>>>>
>>>> Before going any further with this I'd like to check whether this is an
>>>> acceptable way to go.
>>>> Background:
>>>> GPU buffer objects in general and vmware svga GPU buffers in
>>>> particular are mapped by user-space using MIXEDMAP or PFNMAP. Sometimes
>>>> the
>>>> address space is backed by a set of pages, sometimes it's backed by PCI
>>>> memory.
>>>> In the latter case in particular, there is no way to track dirty regions
>>>> using page_mkwrite() and page_mkclean(), other than allocating a bounce
>>>> buffer and perform dirty tracking on it, and then copy data to the real
>>>> GPU
>>>> buffer. This comes with a big memory- and performance overhead.
>>>>
>>>> So I'd like to add the following infrastructure with a callback
>>>> pfn_mkwrite()
>>>> and a function mkclean_mapping_range(). Typically we will be cleaning a
>>>> range
>>>> of ptes rather than random ptes in a vma.
>>>> This comes with the extra benefit of being usable when the backing memory
>>>> of
>>>> the GPU buffer is not coherent with the GPU itself, and where we either
>>>> need
>>>> to flush caches or move data to synchronize.
>>>>
>>>> So this is a RFC for
>>>> 1) The API. Is it acceptable? Any other suggestions if not?
>>>> 2) Modifying apply_to_page_range(). Better to make a standalone
>>>> non-populating version?
>>>> 3) tlb- mmu- and cache-flushing calls. I've looked at
>>>> unmap_mapping_range()
>>>> and page_mkclean_one() to try to get it right, but still unsure.
>>> Most (all?) architectures have real dirty tracking -- you can mark a pte
>>> as "clean" and the hardware (or arch code) will mark it dirty when
>>> written, *without* a page fault.
>>>
>>> I'm not convinced that it works completely correctly right now (I
>>> suspect that there are some TLB flushing issues on the dirty->clean
>>> transition), and it's likely prone to bit-rot, since the page cache
>>> doesn't rely on it.
>>>
>>> That being said, using hardware dirty tracking should be *much* faster
>>> and less latency-inducing than doing it in software like this.  It may
>>> be worth trying to get HW dirty tracking working before adding more page
>>> fault-based tracking.
>>>
>>> (I think there's also some oddity on S/390.  I don't know what that
>>> oddity is or whether you should care.)
>>>
>>> --Andy
>>
>> Andy,
>>
>> Thanks for the tip. It indeed sounds interesting, however there are a couple
>> of culprits:
>>
>> 1) As you say, it sounds like there might be TLB flushing issues. Let's say
>> the TLB detects a write and raises an IRQ for the arch code to set the PTE
>> dirty bit, and before servicing that interrupt, we clear the PTE and flush
>> that TLB. What will happen?
> This should be fine.  I assume that all architectures that do this
> kind of software dirty tracking will make the write block until the
> fault is handled, so the write won't have happened when you clear the
> PTE.  After the TLB flush, the PTE will become dirty again and then
> the page will be written.
>
>> And if the TLB hardware would write directly to
>> the in-memory PTE I guess we'd have the same synchronization issues. I guess
>> we'd then need an atomic read-modify-write against the TLB hardware?
> IIRC the part that looked fishy to me was the combination of hw dirty
> tracking and write protecting the page.  If you see that the pte is
> clean and want to write protect it, you probably need to set the write
> protect bit (atomically so you don't lose a dirty bit), flush the TLB,
> and then check the dirty bit again.
>
>> 2) Even if most hardware is capable of this stuff, I'm not sure what would
>> happen in a virtual machine. Need to check.
> This should be fine.  Any VM monitor that fails to implement dirty
> tracking is probably terminally broken.

OK. I'll give it a try. If I understand this correctly, even if I set up 
a shared RW mapping, the
PTEs should magically be marked dirty if written to, and everything 
works as it should?

>
>> 3) For dirty contents that need to appear on a screen within a short
>> interval, we need the write notification anyway, to start a delayed task
>> that will gather the dirty data and flush it to the screen...
>>
> So that's what you want to do :)

Well this is mostly a benefit, actually. We already do this using 
fb_defio, but without this
new interface we need a bounce-buffer covering the whole screen. Luckily 
this isn't a
common use-case.
Typically (if we use this) we'd gather dirty data when the buffer is 
referenced in a GPU
command stream.

>
> I bet that the best approach is some kind of hybrid.  If, on the first
> page fault per frame, you un-write-protected the entire buffer and
> then, near the end of the frame, check all the hw dirty bits and
> re-write-protect the entire buffer, you get the benefit detecting
> which pages were written, but you only take one write fault per frame
> instead of one write fault per page.

Yes, that sounds sane, particularly as un-write-protecting shouldn't 
need any additional
tlb flushing, AFAICT.

>
> (I imagine that there are video apps out that there that would slow
> down measurably if they started taking one write fault per page per
> frame.)

I actually hope to be able to avoid this stuff completely, but I need a 
backup plan, so
that's why I threw out this RFC.

>
> --Andy

Thanks,
Thomas
