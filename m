Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233AbaJKWdA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 18:33:00 -0400
Received: from mail-lb0-f177.google.com ([209.85.217.177]:59213 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624AbaJKWc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 18:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <20141003200624.GL10583@worktop.programming.kicks-ass.net>
References: <CALCETrUwXk-WtfwMRtcg4NO5i8-36HXDqL3BdV7xRWDWT2w7Jw@mail.gmail.com>
 <20141003200624.GL10583@worktop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Sat, 11 Oct 2014 15:32:36 -0700
Message-ID: <CALCETrWhsSmzcQtXC_4_xHxOCVdfW9_YR5O-2KcyFvFuQceQUg@mail.gmail.com>
Subject: Re: Removing per-task TSD? (Re: Tightening up rdpmc permissions?)
To: Peter Zijlstra <peterz@infradead.org>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Erik Bosman <ebn310@few.vu.nl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 1:06 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, Oct 03, 2014 at 09:41:30AM -0700, Andy Lutomirski wrote:
>> So this is a mess.  I think that any reasonable implementation of
>> rdpmc permissions should be per mm, since we perf_event maps are, of
>> course, per mm.
>>
>> Similarly, any reasonable implementation of rdtsc permissions should
>> be per mm, since doing it sensibly involves telling the vdso not to
>> use rdtsc, and the vdso is per mm
>
> So far so good.
>
>> Unfortunately, PR_SET_TSC is a per-thread setting.  Implementing this
>> correctly looks like it'll require twiddling, or at least thinking
>> about, cr4 at switch_mm time *and* when switching tasks, because the
>> only sensible way of granting PMC access to a running mm is to
>> broadcast a function call to the cpus running that mm.
>
> Confused... now though.
>
> Any cpu can only ever run one mm at the time, and the only way to change
> mm on any one cpu is switch_mm(), so having a CR4 write in switch_mm()
> will DTRT, no weird broadcasts or anything else required.

I have it working, with no change to TIF_NOTSC.  I'm not totally
thrilled by the approach, but I think it's okay, it should have no
effect on any visible ABI, and it's decently fast.

>
> Or were you talking about doing the per mm filter while maintaining the
> old TIF_NOTSC thing? Then still no broadcasts would be required I think.
>
>> Nonetheless, this is doable.  Either there can be separate context
>> switching of CR4.PCE (in switch_mm) and CR4.TSD (in switch_to), or
>> there can be some crazy optimization to make it faster.
>
> IFF you want to retain TIF_NOTSC then yes, we'll need both or crazy.

I actually think that crazy isn't so bad.  switch_mm knows the task
it's switching to, so it can pre-load cr4.  My patch works by creating
a per-cpu cr4 shadow, so pre-loading cr4 for the next task a little
bit early ought to work without any expensive microcoded operations.

I'll send patches reasonably soon.

--Andy

>
>> All of this sucks, so I'll ask a normally verboten question: can we
>> just remove PR_SET_TSC entirely?
>
> Fine with me, see more in that thread, I'll try and reply to the right
> copy.



-- 
Andy Lutomirski
AMA Capital Management, LLC
