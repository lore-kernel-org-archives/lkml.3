Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389AbaJYUte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Oct 2014 16:49:34 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:49107 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaJYUtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Oct 2014 16:49:33 -0400
MIME-Version: 1.0
In-Reply-To: <20141025213017.2da2f819@alan.etchedpixels.co.uk>
References: <1413802499-17928-1-git-send-email-a.ryabinin@samsung.com>
	<5444EBFA.5030103@samsung.com>
	<20141020124929.GA23177@thunk.org>
	<54451501.2070700@samsung.com>
	<5445179A.4080804@redhat.com>
	<20141020141635.GA4499@thunk.org>
	<20141024100108.GF12706@worktop.programming.kicks-ass.net>
	<544A52D7.6000202@oracle.com>
	<20141024134205.GB21513@worktop.programming.kicks-ass.net>
	<544A6A6B.3040602@oracle.com>
	<CACT4Y+boMTKpTovCWYQa6baSAWjagCN=mwXBZGAjbobzG80oWA@mail.gmail.com>
	<2E512EF7-577C-43C2-AB95-30DC25AD059D@dilger.ca>
	<544AD123.1010304@zytor.com>
	<544AF3E6.7090003@oracle.com>
	<20141025213017.2da2f819@alan.etchedpixels.co.uk>
Date: Sun, 26 Oct 2014 00:49:32 +0400
Message-ID: <CAPAsAGw52-L=fGOS6LfgYLJBBzQu-3MnW552wErWJM51eXLNbA@mail.gmail.com>
Subject: Re: drivers: random: Shift out-of-bounds in _mix_pool_bytes
From: Andrey Ryabinin <ryabinin.a.a@gmail.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: Sasha Levin <sasha.levin@oracle.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andreas Dilger <adilger@dilger.ca>, Dmitry Vyukov <dvyukov@google.com>,
        Peter Zijlstra <peterz@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        Daniel Borkmann <dborkman@redhat.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Michal Marek <mmarek@suse.cz>, "x86@kernel.org" <x86@kernel.org>,
        linux-kbuild@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Konstantin Khlebnikov <koct9i@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-10-25 23:30 GMT+03:00 One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>:
> On Fri, 24 Oct 2014 20:50:46 -0400
> Sasha Levin <sasha.levin@oracle.com> wrote:
>
>> On 10/24/2014 06:22 PM, H. Peter Anvin wrote:
>> >> By the principle of least surprise, I would expect "__u32 >> N", where
>> >> > N >= 32 to return zero instead of random garbage.  For N < 32 it will
>> >> > return progressively smaller numbers, until it has shifted away all of
>> >> > the set bits, at which turn it will return 0.  For it suddenly to jump
>> >> > up once N = 32 is used, is counter-intuitive.
>> >> >
>> > That's why it is undefined.
>>
>> Now I'm curious about things like "memcpy(ptr, NULL, 0)". According to the
>> standard they're undefined, and since we're using gcc's implementation for
>> memcpy() we are doing "undefined memcpy" in quite a few places in the kernel.
>>
>> Is it an issue, or would you expect memcpy() to not deref the "from" ptr
>> since length is 0?
>
> No. Furthermore gcc 4.9 actually has optimiser magic around this. See the
> "Porting to gcc 4.9" notes.
>
> --------
>
>  GCC might now optimize away the null pointer check in code like:
>
>
>   int copy (int* dest, int* src, size_t nbytes) {
>     memmove (dest, src, nbytes);
>     if (src != NULL)
>       return *src;
>     return 0;
>   }
>
> The pointers passed to memmove (and similar functions in <string.h>) must
> be non-null even when nbytes==0, so GCC can use that information to
> remove the check after the memmove call. Calling copy(p, NULL, 0) can
> therefore deference a null pointer and crash.
>
> -------------
>
> Which is unfortunate because an operating system has a lot of legitimate
> reasons to copy data to address 0 (on many processors its the exception
> vectors for example)

That is why kernel builds with -fno-delete-null-pointer-checks.

>
> Alan



-- 
Best regards,
Andrey Ryabinin
