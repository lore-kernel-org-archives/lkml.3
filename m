Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932637AbaESReI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:34:08 -0400
Received: from mail-vc0-f177.google.com ([209.85.220.177]:57672 "EHLO
	mail-vc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754533AbaESReH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:34:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140519143540.BE9F6E009B@blue.fi.intel.com>
References: <CALN0BAu_ibgpVykHL-byKm_4X1Afr1R1LRC5ocYVzcqA_k=_9Q@mail.gmail.com>
	<20140519130114.GA3140@dhcp22.suse.cz>
	<20140519143540.BE9F6E009B@blue.fi.intel.com>
Date: Mon, 19 May 2014 13:34:05 -0400
Message-ID: <CALN0BAu0E9r0hdy_Vc6GoKiXXk_w0vetRdumW-3eFFzOPqsFSQ@mail.gmail.com>
Subject: Re: remap_file_pages() use
From: Kenny Simpson <theonetruekenny@gmail.com>
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Armin Rigo <arigo@tunes.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For the circular buffer case, yes I could make some temp file under
/dev/shm, unlink it, mmap() it multiple times, etc... its just makes
it a little more hairy.
https://lkml.org/lkml/2011/3/19/94

For the other cases I had used the remapping to have more of a sliding
window over a disk-backed file where I also was using aliasing to
eliminate the corner cases of hitting the end of a window and needing
to split records due to crossing boundaries, etc..  These were done
for other projects in the past, but I am no longer on those projects
(or with some of the companies), so I can't as easily double check the
code or make changes.
Being able to replace mappings in-place was logically simpler than
doing mmap() over the old mappings.  I was also under the impression
that it should have less pressure on the mm_sem - I'm pretty sure I
did profile it many years ago (>5), but many things have changed since
then so maybe this is not a big deal any more.  This use case was more
performance-critical than the one-time setup of the anonymous circular
buffer as it was more like a transaction log/journal.

All that said, if remap_file_pages were to go away as of a mainline
kernel this year, the projects I had worked on would probably not be
impacted for many years and would probably have been retired/rewritten
before they would ever see the change (unless some Linux vendor in
N.C. backported its removal).  Since valgrind doesn't support it, I
tend to write fallback/debug variants anyway.

-Kenny


On Mon, May 19, 2014 at 10:35 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Michal Hocko wrote:
>> [CCing Kirill and other people involved]
>>
>> On Sun 18-05-14 00:03:28, Kenny Simpson wrote:
>> > I saw that remap_file_pages() was possibly going away to be replaced
>> > by some emulation. I've used this call in several projects over the
>> > years mostly as a way of mapping multiple virtual memory pages to
>> > alias the same private or shared memory region (to do things like
>> > circular buffers). mmap()
>> > in the case of anonymous memory doesn't work as well since there is
>> > not a file descriptor to reference.
>> >
>> > Would this sort of thing be supported in the emulation, or should I be
>> > planning on reimplementing/rewriting some things?
>
> From functional POV, emulation *should* be identical to original
> remap_file_pages(), but slower. It would be nice, if you test it early.
>
> It's not clear yet how long emulation will be there.
> Is there a reason why you can't use fd from shared memory (shm_open() or
> direct open() on /dev/shm/xxx)?
>
> --
>  Kirill A. Shutemov
