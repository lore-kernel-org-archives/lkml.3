Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab3JCVaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 17:30:14 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:62050 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab3JCVaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 17:30:11 -0400
MIME-Version: 1.0
In-Reply-To: <20131003205706.GM13318@ZenIV.linux.org.uk>
References: <20131003163411.GA17101@www.outflux.net>
	<20131003175824.GH13318@ZenIV.linux.org.uk>
	<CAGXu5j+8sxc8vc4bwv14nGNiOhq-ey2nxAK99LgMKO+Qmh1L6A@mail.gmail.com>
	<20131003182311.GI13318@ZenIV.linux.org.uk>
	<CAGXu5j+4NUKfgKiAK+w2MrsqRxHiYc62LBMx4UsfxUBSxNwNJA@mail.gmail.com>
	<20131003205706.GM13318@ZenIV.linux.org.uk>
Date: Thu, 3 Oct 2013 14:30:10 -0700
X-Google-Sender-Auth: _iX4rW15jiLaW7nSlj4AgwhZSdE
Message-ID: <CAGXu5j+T=brqEpmL9UKyQ+qrD7=DOTfuzPm1+FoU_NWdXDdcNQ@mail.gmail.com>
Subject: Re: [PATCH] fs: make sure we do not read beyond allocation
From: Kees Cook <keescook@chromium.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Dmitry Vyukov <dvyukov@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 3, 2013 at 1:57 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
> Let n be some integer between 32 and 4096 and N be equal to n rounded up
> to word size.  If kmalloc(n) returns a pointer such that fetch from
> (char *)p[N - 1] triggers an exception, we have a badly broken kernel.

Sure, this is certainly true given (4096 byte) page-level protections.
And, yes, in the __d_alloc case, the only pathological condition would
be a page boundary. However, this is not always true for other
beyond-allocation reads. Some are much worse/larger, some end up as
info leaks, etc, which is why looking for them has value.

> It can happen only if there is a page boundary between p[n-1] and p[N-1],
> which means that p is not word-aligned.
> Consider the following code:
>         struct foo {
>                 unsigned long n;
>                 char a[];
>         } *p = kmalloc(offsetof(struct foo, a) + 33);
>         if (p)
>                 p->n = 1;
> and note that it will result in an exception on any architecture that prohibits
> unaligned accesses in the kernel.  Even on architectures where those are
> allowed, misaligned structures mean serious correctness problems (atomicity of
> stores, etc.)
>
> In other words, kmalloc() (or, indeed, userland malloc()) demonstrating
> such behaviour would need immediate fixing.  The only exception I can
> think of is something with byte granularity of memory protection; in such
> case we can have that without unaligned return values returned by allocator.
> Which would require a lot of changes in mm/*, at the very least, and probably
> would violate a lot of assumptions elsewhere in the kernel (starting with
> sizeof(void *) == sizeof(unsigned long)).

Byte granularity of memory protection could be provided by future
hypervisors with hooks into the allocator routines, or by leveraging
something like Intel's future MPX[1] stuff for bounds checking. I
still think it'd be better to just fix this directly. The above
examples don't exist right now, but they could soon. Why not fix this
now instead of waiting for someone else to trip over it later?

>> What the patch does help with, though, is dynamic analysis tools that
>> are looking for out-of-bound reads, which this clearly is. It should
>> be considered a violation of the API to attempt to access a range
>> beyond what was requested for the allocation. Fixing this means lots
>> of noise vanishes from such analysis of the allocation API, letting
>> other tools besides just KASAN do work to find other more serious
>> problems in heap usage.
>>
>> Does fixing this to help dynamic analysis tools somehow make the
>> kernel worse? I think that fixing this makes it easier to find further
>> bugs that might be much more serious.
>
> Possibly true.  But then I'd suggest wrapping that into a different ifdef;
> grep for ifdef __CHECKER__, with comment along the lines of "to simplify
> analysis of potential out-of-bounds accesses".

I can live with that. I'll send an updated patch.

Thanks!

-Kees

[1] http://software.intel.com/en-us/blogs/2013/07/22/intel-memory-protection-extensions-intel-mpx-support-in-the-gnu-toolchain

-- 
Kees Cook
Chrome OS Security
