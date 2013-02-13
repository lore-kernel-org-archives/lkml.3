Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933836Ab3BMTIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 14:08:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:46065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764Ab3BMTIl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 14:08:41 -0500
Message-ID: <511BE4A3.8050607@redhat.com>
Date: Wed, 13 Feb 2013 14:08:19 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, rostedt@goodmiss.org,
        aquini@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Michel Lespinasse <walken@google.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:core/locking] x86/smp: Move waiting on contended ticket
 lock out of line
References: <20130206150403.006e5294@cuia.bos.redhat.com> <tip-4aef331850b637169ff036ed231f0d236874f310@git.kernel.org> <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
In-Reply-To: <CA+55aFx6N6SaRN+w=CTXJ=ZSsOE6KeS2R9sT_uhAx9h2j+hjKg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/13/2013 11:20 AM, Linus Torvalds wrote:
> On Wed, Feb 13, 2013 at 4:06 AM, tip-bot for Rik van Riel
> <riel@redhat.com> wrote:
>>
>> x86/smp: Move waiting on contended ticket lock out of line
>>
>> Moving the wait loop for congested loops to its own function
>> allows us to add things to that wait loop, without growing the
>> size of the kernel text appreciably.
>
> Did anybody actually look at the code generation of this?

Good catch.

This looks like something that may be fixable, though I
do not know whether it actually matters. Adding an unlikely
to the if condition where we call the contention path does
seem to clean up the code a little bit...

> This is apparently for the auto-tuning, which came with absolutely no
> performance numbers (except for the *regressions* it caused), and
> which is something we have actively *avoided* in the past, because
> back-off is a f*cking idiotic thing, and the only real fix for
> contended spinlocks is to try to avoid the contention and fix the
> caller to do something smarter to begin with.
>
> In other words, the whole f*cking thing looks incredibly broken. At
> least give some good explanations for why crap like this is needed,
> instead of just implementing backoff without even numbers for real
> loads. And no, don't bother to give numbers for pointless benchmarks.
> It's easy to get contention on a benchmark, but spinlock backoff is
> only remotely interesting on real loads.

Lock contention falls into two categories. One is contention
on resources that are used inside the kernel, which may be
fixable by changing the data and the code.

The second is lock contention driven by external factors,
like userspace processes all trying to access the same file,
or grab the same semaphore. Not all of these cases may be
fixable on the kernel side.

A further complication is that these kinds of performance
issues often get discovered on production systems, which
are stuck on a particular kernel and cannot introduce
drastic changes.

The spinlock backoff code prevents these last cases from
experiencing large performance regressions when the hardware
is upgraded.

None of the scalable locking systems magically make things
scale. All they do is prevent catastrophic performance drops
when moving from N to N+x CPUs, allowing user systems to
continue working while kernel developers address the actual
underlying scalability issues.

As a car analogy, think of this not as an accelerator, but
as an airbag. Spinlock backoff (or other scalable locking
code) exists to keep things from going horribly wrong when
we hit a scalability wall.

Does that make more sense?

-- 
All rights reversed
