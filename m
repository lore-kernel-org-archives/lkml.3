Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967659Ab3DRPvl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 11:51:41 -0400
Received: from mail-vb0-f54.google.com ([209.85.212.54]:51787 "EHLO
	mail-vb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966984Ab3DRPvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 11:51:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130418152414.GA26090@Krystal>
References: <20130418152414.GA26090@Krystal>
Date: Thu, 18 Apr 2013 08:51:38 -0700
X-Google-Sender-Auth: ZedYOaq-R28TcYJF_YnhBhn7HJI
Message-ID: <CA+55aFwydR0+gAg597zQVCscdWNuL0Xe+RtSVGL2aWnynxXT8g@mail.gmail.com>
Subject: Re: [commit review] vm: add vm_iomap_memory() helper function
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 8:24 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
> Hi Linus,
>> +
>> +     /* Check that the physical memory area passed in looks valid */
>> +     if (start + len < start)
>
> is len == 0 accepted ?

Here, yes. We only check for *overflow*, and the canonical way to do
that is "a+b < a" (where the expressions have to be unsigned, of
course). We do this pretty commonly in the kernel, it's a pattern.

And I do know that gcc is smart enough to notice the overflow pattern
and turn this into an "add" followed by a "jump if below" without
actually having the compare instruction at all. I'm not sure it
notices the "overflow or zero" pattern, and even if it did, I think
it's not as clear on a source code level (I'd rather have an explicit
test for len being zero, unless there would be some really fundamental
performance reason why it needs to be one instruction and gcc does it
for one case but not the other).

>> +     /*
>> +      * You *really* shouldn't map things that aren't page-aligned,
>> +      * but we've historically allowed it because IO memory might
>> +      * just have smaller alignment.
>> +      */
>> +     len += start & ~PAGE_MASK;
>> +     pfn = start >> PAGE_SHIFT;
>> +     pages = (len + ~PAGE_MASK) >> PAGE_SHIFT;

Side note, there can be overflow in these additions too, so "pages"
may overflow from something really big to something really small, and
we do not test it, because we don't care. We're basically only adding
partial single pages, so even if an overflow were to happen (len
starting out as some huge number), it would overflow to 0 or 1, and
that's fine. Making the length we allow *smaller* isn't a problem.

Also, the "len" we get passed in is supposedly controlled by the
kernel (length of the kernel-allocated data mapping), so it should be
a valid value. My only reason for even considering it is that I don't
trust drivers, and I could imagine some driver using a signed "len",
and setting it to something -1 rather than 0 if an allocation failed.
I don't think that happens, but it's the kind of thing we *could* try
to explicitly check against too, and just say "you can't mmap more
than 2GB using this helper".

On the other hand I *could* also imagine some odd accelerator FPGA
thing having 4GB memory areas on some specialized 64-bit
supercomputer, so adding too many sanity checks on things like this
could be detrimental too.

>> +     if (pfn + pages < pfn)
>> +             return -EINVAL;

Standard overflow check again, although it's not really a big issue.
Neither pfn nor pages is user-controlled.

>> +     /* We start the mapping 'vm_pgoff' pages into the area */
>> +     if (vma->vm_pgoff > pages)
>
> This seems to accept vma->vm_pgoff == pages, which would leave exactly 0
> backing pages. Is this expected ?

Yes. That's fine. It's still a valid number of pages

Technically, if we were to allow zero-sized mappings, the zero length
of the source buffer would be ok too, so regardless, I don't think we
want an explicit test for zero. We just want to check that we have
enough buffer space to be mapped. "zero" *could* be enough, if we have
nothing we want to map ;)

So I don't think "len==0" should be a special case at this level.

But see below:

>> +             return -EINVAL;
>> +     pfn += vma->vm_pgoff;
>> +     pages -= vma->vm_pgoff;
>> +
>> +     /* Can we fit all of the mapping? */
>> +     vm_len = vma->vm_end - vma->vm_start;
>> +     if (vm_len >> PAGE_SHIFT > pages)
>
> Is it possible that we get a situation where vm_end and vm_start are not
> aligned on page addresses ?

Not unless there is some major core VM bug, in which case we shouldn't
check it here.

Also, we don't allow empty vma's, so "vm_len" is not only
page-aligned, it is known to be non-zero. So this is where a
zero-sized physical memory area (either because it was zero to begin
with, or because it became zero after the vma->vm_pgoff fixup) would
hit the wall.

> If it's allowed, then this test may succeed
> even though the range requires more than "pages" backing pages. This
> might be an issue since the first thing remap_pfn_range() does with its
> "size" argument is to PAGE_ALIGN() it.

For remap_pfn_range(), the size comes from a possibly confused caller
(most drivers are a bit confused ;), since the generic pfn remapping
can be used to remap just _parts_ of a vma.

So the generic [io_]remap_pfn_range() functions really are complicated
for a reason: they allow a much more involved and complicated use
case. It's just that for 99.9% of all drivers, they don't want that
complicated case, and they just spend a lot of time doing these checks
and updating vm_pgoff etc crap, that they really shouldn't do, and
sometimes don't do correctly.

In contrast, in this helper function, we take the size from the vma
itself, that the core VM has set up. And a non-page-aligned vma would
be horribly horribly buggy. If it happens, we'd have much bigger
problems than this small function.

But thanks for reading through it. I don't think you caught anything,
but there might be something else I missed.

            Linus
