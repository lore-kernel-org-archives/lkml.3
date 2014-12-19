Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752268AbaLSRDw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 12:03:52 -0500
Received: from casper.infradead.org ([85.118.1.10]:45475 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751218AbaLSRDv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 12:03:51 -0500
Date: Fri, 19 Dec 2014 18:03:34 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Shaohua Li <shli@fb.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, Kernel-team@fb.com,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [PATCH v2 3/3] X86: Add a thread cpu time implementation to vDSO
Message-ID: <20141219170334.GM30905@twins.programming.kicks-ass.net>
References: <8559794d3a1924408a811a2881ab916fffb6015b.1418857018.git.shli@fb.com>
 <95a7ba1a95a6251439d5ca2d3d56fe7f0778cb95.1418857018.git.shli@fb.com>
 <CALCETrVyrOXNFk5OhPGukg+VmOEsHW93NLAd6LvkKFtV7H76kw@mail.gmail.com>
 <CALCETrV2+qkuj3WinOW-Ro_PjtZBhLaXwSHCeWpMpTJnog83EQ@mail.gmail.com>
 <20141219112350.GJ30905@twins.programming.kicks-ass.net>
 <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrXRs5mXYq8OPH-WYqWPoD=35WccnHh7Bcm-YZMjW3ADcw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2014 at 08:48:07AM -0800, Andy Lutomirski wrote:
> On Fri, Dec 19, 2014 at 3:23 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Thu, Dec 18, 2014 at 04:22:59PM -0800, Andy Lutomirski wrote:
> >> Bad news: this patch is incorrect, I think.  Take a look at
> >> update_rq_clock -- it does fancy things involving irq time and
> >> paravirt steal time.  So this patch could result in extremely
> >> non-monotonic results.
> >
> > Yeah, I'm not sure how (and if) we could make all that work :/
> 
> I obviously can't comment on what Facebook needs, but if I were
> rigging something up to profile my own code*, I'd want a count of
> elapsed time, including user, system, and probably interrupt as well.
> I would probably not want to count time during which I'm not
> scheduled, and I would also probably not want to count steal time.
> The latter makes any implementation kind of nasty.
> 
> The API presumably doesn't need to be any particular clock id for
> clock_gettime, and it may not even need to be clock_gettime at all.
> 
> Is perf self-monitoring good enough for this?  If not, can we make it
> good enough?

Yeah, I think you should be able to use that. You could count a NOP
event and simply use its activated time. We have PERF_COUNT_SW_DUMMY for
such purposes iirc.

The advantage of using perf self profiling is that it (obviously)
extends to more than just walltime.
