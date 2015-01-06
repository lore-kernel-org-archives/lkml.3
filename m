Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496AbbAFN10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 08:27:26 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:40053 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755292AbbAFN1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 08:27:23 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFwTxbVSGg6F75X2Tt8pYEbV+jVVLOS8AoSqRrcYGELEGQ@mail.gmail.com>
References: <CANd1uZkn_Dk+s9vjxaA4B2oqWVoohzCQOHUuAdt3QK1ng37x6Q@mail.gmail.com>
	<CA+55aFwTxbVSGg6F75X2Tt8pYEbV+jVVLOS8AoSqRrcYGELEGQ@mail.gmail.com>
Date: Tue, 6 Jan 2015 13:27:21 +0000
Message-ID: <CANd1uZ=LZXtG9n+w+DA+z2N5p=oiBJ506=2VnyeNXU18=LobSQ@mail.gmail.com>
Subject: Re: [2/3] mm: fix up some user-visible effects of the stack guard page
From: Jay Foad <jay.foad@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <gregkh@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "# .39.x" <stable@kernel.org>, stable-review@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5 January 2015 at 21:03, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Mon, Jan 5, 2015 at 2:21 AM, Jay Foad <jay.foad@gmail.com> wrote:
>> Sorry for replying to this old email...
>>
>>> commit d7824370e26325c881b665350ce64fb0a4fde24a upstream
>
> Heh. From august 2010. That's 4+ years ago.. How come it was noticed
> only now?

*Not* because we've just upgraded from an ancient kernel. Rather
because we've started running the asan tests on powerpc64, which has
64k pages rather than 4k, which just happens to trigger the failure. A
bit of git blame detective work lead me to this ancient commit.

>> Address sanitizer tries to find the mapping for the current thread's
>> stack by iterating through the entries in /proc/self/maps looking for
>> one that contains the address of some random stack variable. This
>> fails if the stack mapping has already used up all of its RLIMIT_STACK
>> quota, because in that case check_stack_guard_page() will fail to add
>> a guard page, but show_map_vma() will still assume that the first page
>> of the stack *is* a guard page, and won't report it in /proc/maps.
>>
>> Here's a small program that demonstrates the failure:
>
> Yup, your analysis sounds correct.  My completely untested gut feel is
> that the problem is that we don't actually return the error from the
> expand_stack() call, so then do_anonymous_page() will allow the extra
> guard-page access.
>
> IOW, *maybe* a patch like this. TOTALLY UNTESTED! I may have missed
> something, and this may be complete crap.

(Later)
> .. and ti's still untested, but I'm pretty sure it's right - except we
> should probably also allow an extra page for the stack rlimit (so that
> the guard page doesn't count towards the limit).

(Later)
> It does indeed seem to work.
>
> But see my other email about this effectively making the stack limit
> one page smaller. I'm not entirely sure it's worth fixing, but maybe
> in another four years somebody will post a regression email about that
> ;)
>
> IOW, I'd be inclined to say "stack limit includes guard page", and
> just wait and see whether that causes any issues.

I don't have a problem with that, but I suppose some users might have
to bump their stack limit up by a page, if they were already sailing
close to the wind.

> But regardless, I'd like you to test the patch in your environment
> (with the full real load, not just the demonstration test case), since
> you are clearly doing special things. My limited testing was just that
> - very limited.

I can't test kernel patches on the powerpc64 box as I don't even have
root access, but I've done the best I can on my own x86_64 machine:
- rebuilt my current 3.16.0 kernel both without and with your patch
- tested both my small repro and the original asan stack-overflow test
with a variety of small stack limits (12, 16, 20 k)
- run the full address sanitizer test suite
All looks good *except* that stack overflow tests are now getting
SIGBUS where they used to get SIGSEGV. Asan was only handling SIGSEGV,
but it seems entirely reasonable for it to handle SIGBUS in the same
way too (indeed it was already doing that on Darwin, just not on
Linux). If I make that change then the whole test suite runs cleanly
with your patch.

Thus:
Tested-by: Jay Foad <jay.foad@gmail.com>

Thanks,
Jay.
