Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691AbaDCUYJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 16:24:09 -0400
Received: from smtp.bbn.com ([128.33.0.80]:51224 "EHLO smtp.bbn.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497AbaDCUYG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 16:24:06 -0400
X-Submitted: to socket.bbn.com (Postfix) with ESMTPSA id 728D64034D
Message-ID: <533DC357.1080203@bbn.com>
Date: Thu, 03 Apr 2014 16:23:51 -0400
From: Richard Hansen <rhansen@bbn.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: mtk.manpages@gmail.com
CC: Steven Whitehouse <swhiteho@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>, Greg Troxel <gdt@ir.bbn.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] mm: msync: require either MS_ASYNC or MS_SYNC
References: <533B04A9.6090405@bbn.com> <20140402111032.GA27551@infradead.org> <1396439119.2726.29.camel@menhir> <533CA0F6.2070100@bbn.com> <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com>
In-Reply-To: <CAKgNAki8U+j0mvYCg99j7wJ2Z7ve-gxusVbM3zdog=hKGPdidQ@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-04-03 04:25, Michael Kerrisk (man-pages) wrote:
> [CC += Peter Zijlstra]
> [CC += bug-readline@gnu.org -- maintainers, it _may_ be desirable to
> fix your msync() call]

I didn't see bug-readline@gnu.org in the CC list -- did you forget to
add them, or were they BCC'd?

>>   * Clearer intentions.  Looking at the existing code and the code
>>     history, the fact that flags=0 behaves like flags=MS_ASYNC appears
>>     to be a coincidence, not the result of an intentional choice.
> 
> Maybe. You earlier asserted that the semantics when flags==0 may have
> been different, prior to Peter Zijstra's patch,
> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=204ec841fbea3e5138168edbc3a76d46747cc987
> .
> It's not clear to me that that is the case. But, it would be wise to
> CC the developer, in case he has an insight.

Good idea, thanks.

> But, even if you could find and fix every application that misuses
> msync(), new kernels with your proposed changes would still break old
> binaries. Linus has made it clear on numerous occasions that kernel
> changes must not break user space. So, the change you suggest is never
> going to fly (and Christoph's NAK at least saves Linus yelling at you
> ;-).)

OK -- that's a good enough reason for me.

> I think the only reasonable solution is to better document existing
> behavior and what the programmer should do.

Greg mentioned the possibility of syslogging a warning the first time a
process uses msync() with neither flag set.  Another alternative would
be to do this in userspace: modify the {g,u}libc shims to log a warning
to stderr.

And there's yet another alternative that's probably a bad idea but I'll
toss it out anyway:  I'm not very familiar with the Linux kernel, but
the NetBSD kernel defines multiple versions of some syscalls for
backward-compatibility reasons.  A new non-backward-compatible version
of an existing syscall gets a new syscall number.  Programs compiled
against the latest headers use the new version of the syscall but old
binaries still get the old behavior.  I imagine folks would frown upon
doing something like this in Linux for msync() (create a new version
that EINVALs if neither flag is specified), but it would be a way to
migrate toward a portability-friendly behavior while maintaining
compatibility with existing binaries.  (Sloppy userspace programs would
still need to be fixed, so this would still "break userspace".)

> With that in mind, I've
> drafted the following text for the msync(2) man page:
> 
>     NOTES
>        According to POSIX, exactly one of MS_SYNC and MS_ASYNC  must  be
>        specified  in  flags.   However,  Linux permits a call to msync()
>        that specifies neither of these flags, with  semantics  that  are
>        (currently)  equivalent  to  specifying  MS_ASYNC.   (Since Linux
>        2.6.19, MS_ASYNC is in fact a no-op, since  the  kernel  properly
>        tracks  dirty  pages  and  flushes them to storage as necessary.)
>        Notwithstanding the Linux behavior, portable, future-proof appli‐
>        cations  should  ensure  that they specify exactly one of MS_SYNC
>        and MS_ASYNC in flags.
> 
> Comments on this draft welcome.

I agree with Greg's reply to this note.  How about this text instead:

    Exactly one of MS_SYNC and MS_ASYNC must be specified in flags.
    If neither flag is set, the behavior is unspecified.

I'll follow up with a new patch that explicitly defaults to MS_ASYNC (to
document the desire to maintain compaitibility and to prevent unexpected
problems if msync() is ever overhauled again).

Thanks,
Richard

