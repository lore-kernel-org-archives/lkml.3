Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbbANHV4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 02:21:56 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:47150 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750975AbbANHVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 02:21:55 -0500
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20150110183911.GB2915@two.firstfloor.org>
References: <54AE5BE8.1050701@gmail.com> <87r3v350io.fsf@tassilo.jf.intel.com>
 <CAKgNAki3Fh8N=jyPHxxFpicjyJ=0kA75SJ65QjYzPmWnvy4nsw@mail.gmail.com>
 <54B01F41.10001@intel.com> <54B12DD3.5020605@gmail.com> <20150110183911.GB2915@two.firstfloor.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Wed, 14 Jan 2015 08:21:32 +0100
Message-ID: <CAKgNAkgtDtU5TsOEpjoLggn-gzSLXuqUOhhieVgc4sOo41Oz=w@mail.gmail.com>
Subject: Re: [PATCH] x86, mpx: Ensure unused arguments of prctl() MPX requests
 are 0
To: Andi Kleen <andi@firstfloor.org>
Cc: Dave Hansen <dave.hansen@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Qiaowei Ren <qiaowei.ren@intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On 10 January 2015 at 19:39, Andi Kleen <andi@firstfloor.org> wrote:
> On Sat, Jan 10, 2015 at 02:49:07PM +0100, Michael Kerrisk (man-pages) wrote:
>> On 01/09/2015 07:34 PM, Dave Hansen wrote:
>> > On 01/09/2015 10:25 AM, Michael Kerrisk (man-pages) wrote:
>> >> On 9 January 2015 at 18:25, Andi Kleen <andi@firstfloor.org> wrote:
>> >>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
>> >>>> From: Michael Kerrisk <mtk.manpages@gmail.com>
>> >>>>
>> >>>> commit fe8c7f5cbf91124987106faa3bdf0c8b955c4cf7 added two new prctl()
>> >>>> operations, PR_MPX_ENABLE_MANAGEMENT and PR_MPX_DISABLE_MANAGEMENT.
>> >>>> However, no checks were included to ensure that unused arguments
>> >>>> are zero, as is done in many existing prctl()s and as should be
>> >>>> done for all new prctl()s. This patch adds the required checks.
>> >>>
>> >>> This will break the existing gcc run time, which doesn't zero these
>> >>> arguments.
>> >>
>> >> I'm a little lost here. Weren't these flags new in the
>> >> as-yet-unreleased 3.19? How does gcc run-time depends on them already?
>> >
>> > These prctl()s have been around in some form or another for a few months
>> > since the patches had not yet been merged in to the kernel.  There is
>> > support for them in a set of (yet unmerged) gcc patches, as well as some
>> > tests which are only internal to Intel.
>> >
>> > This change will, indeed, break those internal tests as well as the gcc
>> > patches.  As far as I know, the code is not in production anywhere and
>> > can be changed.  The prctl() numbers have changed while the patches were
>> > out of tree and it's a somewhat painful process each time it changes.
>> > It's not impossible, just painful.
>>
>> So, sounds like thinks can be fixed (with mild inconvenience), and they
>> should be fixed before 3.19 is actually released.
>
> FWIW I added these checks to prctl first, but in hindsight it was a
> mistake.

(I'm not clear here whether you mean you added them for other prctl()
operations, of for the MPX operations.)

> The glibc prctl() function is stdarg.

Sigh. Yes. It's ugly.

> Often you only have a single
> extra argument, so you need to add 4 zeroes.

And more ugliness. As far as I can tell, no prctl() operation even
uses arg5. PR_SET_MM passes it to its helper routine, but that routine
requires the argument to be zero. And PR_SET_MM is the only operation
that uses arg4. That observation inclines me even more to a point I
thought about recently: PR_SET_MM is sufficiently complicated that it
really should have been a separate system call, rather than being
crammed into prctl().

Carrying on with this point, the only operations that use arg3 are
PR_MCE_KILL, PR_SET_MM, PR_SET_SECCOMP. And, after prodding from me
and one or two others, the functionality of that last one was
eventually split off into a separate seccomp() system call instead of
further overloading prctl().

I know it's ancient history (prctl() dates pack to Linux 2.2 days),
but one has to wonder what people were thinking of when they decided
it was a good idea to add a generic multi-argument system call. (Even
in the first operation that was added, PR_SET_PDEATHSIG, only arg2 was
used.) Like, "hey ioctl() is a great idea, let's try the same idea
with even more arguments".

> There is no compile
> time checking. It is very easy to get wrong and miscount the zeroes,
> happened several times.

Yes, but (in the case of those prctl() operations that don't check for
the zeros), what's the harm of getting it wrong?

> The failure may be hard to catch, because
> it only happens at runtime.

<irony>
But, I mean, the developer will catch that on the first test, right?
</irony>

> Also the extra zeroes look ugly in the source.

I don't suppose you can be proposing this as a strong argument, but I
don''t think this pomit carries much wait at all. Anyway, the
fundamental point is that it's the API that is ugly, not the zeros.

> And it doesn't really buy you anything because it's very cheap
> to add new prctl numbers if you want to extend something.

I still tend to disagree. There's already enough completely unrelated
functionality overloaded onto this API. I don't think we really want
to follow the philosophy of "oh, we'll just add another operation
later".

> So I would advise against it.

The counter-argument  here is of course that user-space programmers
sometimes make the converse error: omitting an argument on some
prctl() that requires. The consequence of that sort of error can be
considerably worse than miscounting the zeros required for prctl()
operations that don't need check their unused arguments. Overall,
given the messy API, I think it best to encourage user-space
programmers into a discipline of always supplying the zeros for the
unused arguments, so I still think this patch should be applied.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
