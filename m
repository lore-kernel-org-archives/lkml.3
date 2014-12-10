Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281AbaLJXGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 18:06:55 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:50611 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758226AbaLJXGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 18:06:52 -0500
MIME-Version: 1.0
In-Reply-To: <20141210225627.GA11754@devbig257.prn2.facebook.com>
References: <f0f3eab5f68f74bfabf42d745ccf1e2ecf642683.1418006970.git.shli@fb.com>
 <862cbb2ab71a9f71d1123b5512605350a4b61846.1418006970.git.shli@fb.com>
 <CALCETrUU-vb34550mbE-yqoWYrzVNarVf++Logt0gmSTh_Cg2w@mail.gmail.com>
 <20141210215713.GA30230@devbig257.prn2.facebook.com> <CALCETrUi--fmZLBUB=tjmGt_D3y+HJ+MtJTRZ0=JUKFgAvxyuA@mail.gmail.com>
 <20141210225627.GA11754@devbig257.prn2.facebook.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 10 Dec 2014 15:06:30 -0800
Message-ID: <CALCETrXpVUVY6paKJq0Uq8VeHG2A0E3qc4b_H+5ZT-QJApkaJw@mail.gmail.com>
Subject: Re: [PATCH 3/3] X86: Add a thread cpu time implementation to vDSO
To: Shaohua Li <shli@fb.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 10, 2014 at 2:56 PM, Shaohua Li <shli@fb.com> wrote:
> On Wed, Dec 10, 2014 at 02:13:23PM -0800, Andy Lutomirski wrote:
>> On Wed, Dec 10, 2014 at 1:57 PM, Shaohua Li <shli@fb.com> wrote:
>> > On Wed, Dec 10, 2014 at 11:10:52AM -0800, Andy Lutomirski wrote:
>> >> On Sun, Dec 7, 2014 at 7:03 PM, Shaohua Li <shli@fb.com> wrote:
>> >> > This primarily speeds up clock_gettime(CLOCK_THREAD_CPUTIME_ID, ..). We
>> >> > use the following method to compute the thread cpu time:
>> >>
>> >> I like the idea, and I like making this type of profiling fast.  I
>> >> don't love the implementation because it's an information leak (maybe
>> >> we don't care) and it's ugly.
>> >>
>> >> The info leak could be fixed completely by having a per-process array
>> >> instead of a global array.  That's currently tricky without wasting
>> >> memory, but it could be created on demand if we wanted to do that,
>> >> once my vvar .fault patches go in (assuming they do -- I need to ping
>> >> the linux-mm people).
>> >
>> > those info leak really doesn't matter.
>>
>> Why not?
>
> Ofcourse I can't make sure completely, but how could this info be used
> as attack?

It may leak interesting timing info, even from cpus that are outside
your affinity mask / cpuset.  I don't know how much anyone actually
cares.

>
>> > But we need the global array
>> > anyway. The context switch detection should be per-cpu data and should
>> > be able to access in remote cpus.
>>
>> Right, but the whole array could be per process instead of global.
>>
>> I'm not saying I'm sure that would be better, but I think it's worth
>> considering.
>
> right, it's possible to be per process. As you said, this will waster a
> lot of memory. and you can't even do on-demand, as the context switch
> path will write the count to the per-process/per-thread vvar. Or you can
> maintain the count in kernel and let the .fault copy the count to vvar
> page (if the vvar page is absent). But this still wastes memory if
> applications use the vdso. I'm wondering how you handle page fault in
> context switch too if you don't pin the vdso pages.
>

You need to pin them, but at least you don't need to create them at
all until they're needed the first time.

The totally per-thread approach has all kinds of nice properties,
including allowing the whole thing to work without a loop, at least on
64-bit machines (if you detect that you had a context switch, just
return the most recent sum_exec_runtime).

Anyway, there's no need to achieve perfection here -- we can always
reimplement this if whatever implementation happens first turns out to
be problematic.

--Andy

> Thanks,
> Shaohua



-- 
Andy Lutomirski
AMA Capital Management, LLC
