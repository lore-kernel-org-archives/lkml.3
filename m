Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752095Ab3H0RBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 13:01:05 -0400
Received: from mail-ve0-f180.google.com ([209.85.128.180]:63418 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751465Ab3H0RBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 13:01:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130827165039.GC2886@sgi.com>
References: <87wqo050fc.fsf@tassilo.jf.intel.com>
	<1376663644-153546-1-git-send-email-athorlton@sgi.com>
	<1376663644-153546-2-git-send-email-athorlton@sgi.com>
	<520E672C.3080102@intel.com>
	<20130816181728.GQ26093@sgi.com>
	<20130816185212.GA3568@shutemov.name>
	<20130827165039.GC2886@sgi.com>
Date: Tue, 27 Aug 2013 12:01:01 -0500
Message-ID: <CAPp3RGqifK=tum94nGKcqSmDpzj3ceC_ZDo7KNLOz4KHjqv5mw@mail.gmail.com>
Subject: Re: [PATCH 1/8] THP: Use real address for NUMA policy
From: Robin Holt <robinmholt@gmail.com>
To: Alex Thorlton <athorlton@sgi.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>,
        Dave Hansen <dave.hansen@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        "Eric W . Biederman" <ebiederm@xmission.com>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Dave Jones <davej@redhat.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Al Viro <viro@zeniv.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex,

Although the explanation seems plausible, have you verified this is
actually possible?  You could make a simple pthread test case which
allocates a getpagesize() * <number-of-threads> area, prints its
address and then each thread migrate and reference their page.  Have
the task then sleep(<long-time>) before exit.  Look at the physical
address space with dlook for those virtual addresses in both the THP
and non-THP cases.

Thanks,
Robin

On Tue, Aug 27, 2013 at 11:50 AM, Alex Thorlton <athorlton@sgi.com> wrote:
>> Here's more up-to-date version: https://lkml.org/lkml/2012/8/20/337
>
> These don't seem to give us a noticeable performance change either:
>
> With THP:
>
> real    22m34.279s
> user    10797m35.984s
> sys     39m18.188s
>
> Without THP:
>
> real    4m48.957s
> user    2118m23.208s
> sys     113m12.740s
>
> Looks like we got a few minutes faster on the with THP case, but it's
> still significantly slower, and that could just be a fluke result; we're
> still floating at about a 5x performance degradation.
>
> I talked with one of our performance/benchmarking experts last week and
> he's done a bit more research into the actual problem here, so I've got
> a bit more information:
>
> The real performance hit, based on our testing, seems to be coming from
> the increased latency that comes into play on large NUMA systems when a
> process has to go off-node to read from/write to memory.
>
> To give an extreme example, say we have a 16 node system with 8 cores
> per node. If we have a job that shares a 2MB data structure between 128
> threads, with THP on, the first thread to touch the structure will
> allocate all 2MB of space for that structure in a 2MB page, local to its
> socket.  This means that all the memory accessses for the other 120
> threads will be remote acceses.  With THP off, each thread could locally
> allocate a number of 4K pages sufficient to hold the chunk of the
> structure on which it needs to work, significantly reducing the number
> of remote accesses that each thread will need to perform.
>
> So, with that in mind, do we agree that a per-process tunable (or
> something similar) to control THP seems like a reasonable method to
> handle this issue?
>
> Just want to confirm that everyone likes this approach before moving
> forward with another revision of the patch.  I'm currently in favor of
> moving this to a per-mm tunable, since that seems to make more sense
> when it comes to threaded jobs. Also, a decent chunk of the code I've
> already written can be reused with this approach, and prctl will still
> be an appropriate place from which to control the behavior. Andrew
> Morton suggested possibly controlling this through the ELF header, but
> I'm going to lean towards the per-mm route unless anyone has a major
> objection to it.
>
> - Alex
