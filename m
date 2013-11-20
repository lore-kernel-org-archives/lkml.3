Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755063Ab3KTU3v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 15:29:51 -0500
Received: from mail-ve0-f177.google.com ([209.85.128.177]:39580 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754992Ab3KTU3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 15:29:48 -0500
MIME-Version: 1.0
In-Reply-To: <528D18AB.5020009@vmware.com>
References: <1384891576-7851-1-git-send-email-thellstrom@vmware.com>
 <528BEB60.7040402@amacapital.net> <528C6ED9.3070600@vmware.com>
 <CALCETrXFqV1S6qVsxHRDrxw-trGK0O4Jf1rXOFwze4JL0uAEAA@mail.gmail.com> <528D18AB.5020009@vmware.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 20 Nov 2013 12:29:27 -0800
Message-ID: <CALCETrXGi3267NefnFJr0gykUFVE5HVGqH4vL1KhpOXHxhfq1A@mail.gmail.com>
Subject: Re: [PATCH RFC 0/3] Add dirty-tracking infrastructure for
 non-page-backed address spaces
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-graphics-maintainer <linux-graphics-maintainer@vmware.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 12:16 PM, Thomas Hellstrom
<thellstrom@vmware.com> wrote:
> On 11/20/2013 05:50 PM, Andy Lutomirski wrote:
>>
>> On Wed, Nov 20, 2013 at 12:12 AM, Thomas Hellstrom
>> <thellstrom@vmware.com> wrote:
>>>
>>> On 11/19/2013 11:51 PM, Andy Lutomirski wrote:
>>>>
>>>> On 11/19/2013 12:06 PM, Thomas Hellstrom wrote:
>>>>>
>>>>> Hi!
>>>>>
>>>>> Before going any further with this I'd like to check whether this is an
>>>>> acceptable way to go.
>>>>> Background:
>>>>> GPU buffer objects in general and vmware svga GPU buffers in
>>>>> particular are mapped by user-space using MIXEDMAP or PFNMAP. Sometimes
>>>>> the
>>>>> address space is backed by a set of pages, sometimes it's backed by PCI
>>>>> memory.
>>>>> In the latter case in particular, there is no way to track dirty
>>>>> regions
>>>>> using page_mkwrite() and page_mkclean(), other than allocating a bounce
>>>>> buffer and perform dirty tracking on it, and then copy data to the real
>>>>> GPU
>>>>> buffer. This comes with a big memory- and performance overhead.
>>>>>
>>>>> So I'd like to add the following infrastructure with a callback
>>>>> pfn_mkwrite()
>>>>> and a function mkclean_mapping_range(). Typically we will be cleaning a
>>>>> range
>>>>> of ptes rather than random ptes in a vma.
>>>>> This comes with the extra benefit of being usable when the backing
>>>>> memory
>>>>> of
>>>>> the GPU buffer is not coherent with the GPU itself, and where we either
>>>>> need
>>>>> to flush caches or move data to synchronize.
>>>>>
>>>>> So this is a RFC for
>>>>> 1) The API. Is it acceptable? Any other suggestions if not?
>>>>> 2) Modifying apply_to_page_range(). Better to make a standalone
>>>>> non-populating version?
>>>>> 3) tlb- mmu- and cache-flushing calls. I've looked at
>>>>> unmap_mapping_range()
>>>>> and page_mkclean_one() to try to get it right, but still unsure.
>>>>
>>>> Most (all?) architectures have real dirty tracking -- you can mark a pte
>>>> as "clean" and the hardware (or arch code) will mark it dirty when
>>>> written, *without* a page fault.
>>>>
>>>> I'm not convinced that it works completely correctly right now (I
>>>> suspect that there are some TLB flushing issues on the dirty->clean
>>>> transition), and it's likely prone to bit-rot, since the page cache
>>>> doesn't rely on it.
>>>>
>>>> That being said, using hardware dirty tracking should be *much* faster
>>>> and less latency-inducing than doing it in software like this.  It may
>>>> be worth trying to get HW dirty tracking working before adding more page
>>>> fault-based tracking.
>>>>
>>>> (I think there's also some oddity on S/390.  I don't know what that
>>>> oddity is or whether you should care.)
>>>>
>>>> --Andy
>>>
>>>
>>> Andy,
>>>
>>> Thanks for the tip. It indeed sounds interesting, however there are a
>>> couple
>>> of culprits:
>>>
>>> 1) As you say, it sounds like there might be TLB flushing issues. Let's
>>> say
>>> the TLB detects a write and raises an IRQ for the arch code to set the
>>> PTE
>>> dirty bit, and before servicing that interrupt, we clear the PTE and
>>> flush
>>> that TLB. What will happen?
>>
>> This should be fine.  I assume that all architectures that do this
>> kind of software dirty tracking will make the write block until the
>> fault is handled, so the write won't have happened when you clear the
>> PTE.  After the TLB flush, the PTE will become dirty again and then
>> the page will be written.
>>
>>> And if the TLB hardware would write directly to
>>> the in-memory PTE I guess we'd have the same synchronization issues. I
>>> guess
>>> we'd then need an atomic read-modify-write against the TLB hardware?
>>
>> IIRC the part that looked fishy to me was the combination of hw dirty
>> tracking and write protecting the page.  If you see that the pte is
>> clean and want to write protect it, you probably need to set the write
>> protect bit (atomically so you don't lose a dirty bit), flush the TLB,
>> and then check the dirty bit again.
>>
>>> 2) Even if most hardware is capable of this stuff, I'm not sure what
>>> would
>>> happen in a virtual machine. Need to check.
>>
>> This should be fine.  Any VM monitor that fails to implement dirty
>> tracking is probably terminally broken.
>
>
> OK. I'll give it a try. If I understand this correctly, even if I set up a
> shared RW mapping, the
> PTEs should magically be marked dirty if written to, and everything works as
> it should?
>

I *think* so.  (It's certainly worth doing a quick-and-dirty test to
make sure I'm not completely nuts before you invest too much time here
-- I've read the code, and I've looked at the Intel specs, but I've
never actually verified that pte_dirty and pte_mkclean to what I think
they do.)

(If you ever intend to run on S/390, you should ask someone who
understands what's going on.  I, personally, have no clue, other than
having seen references to something weird happening.)

--Andy
