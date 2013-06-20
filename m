Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965447Ab3FTMHs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 08:07:48 -0400
Received: from mail-ee0-f52.google.com ([74.125.83.52]:43027 "EHLO
	mail-ee0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab3FTMHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 08:07:47 -0400
Date: Thu, 20 Jun 2013 14:07:43 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Stephane Eranian <eranian@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Jiri Olsa <jolsa@redhat.com>,
        vincent.weaver@maine.edu, "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH] perf,x86: Fix shared registers mutual exclusion bug
Message-ID: <20130620120743.GA15789@gmail.com>
References: <20130605144346.GA20338@quad>
 <20130618091118.GG3204@twins.programming.kicks-ass.net>
 <CABPqkBTtnX3KNyVXzXwL82EADhs14v-LCuoxLgGnXPTP_FaSFQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBTtnX3KNyVXzXwL82EADhs14v-LCuoxLgGnXPTP_FaSFQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@google.com> wrote:

> On Tue, Jun 18, 2013 at 11:11 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, Jun 05, 2013 at 04:43:46PM +0200, Stephane Eranian wrote:
> >>
> >> This patch fixes a problem with the shared registers mutual
> >> exclusion code and incremental event scheduling by the
> >> generic perf_event code.
> >>
> >> There was a bug whereby the mutual exclusion on the shared
> >> registers was not enforced because of incremental scheduling
> >> abort due to event constraints.
> >>
> >> Example on Nehalem:
> >> group1= ref-cycles,OFFCORE_RESPONSE_0:PF_RFO
> >> group2= ref-cycles
> >>
> >> The ref-cycles event can only be measured by 1 counter. Yet, there
> >> are 2 instances here. The first group can be scheduled and is committed.
> >> Then, the generic code tries to schedule group2 and this fails (because
> >> there is no more counter to support the 2nd instance of ref-cycles).
> >>
> >> But in x86_schedule_events() error path, put_event_contraints() is invoked
> >> on ALL the events and not just the ones that just failed. That causes the
> >> "lock" on the shared offcore_response MSR to be released. Yet the first group
> >> is actually scheduled and is exposed to reprogramming of that shared msr by
> >> the sibling HT thread (when they are shared by HT threads). In other words,
> >> there is no guarantee on what is measured for the offcore_response event.
> >>
> >> This patch fixes the problem by tagging committed events with the
> >> PERF_X86_EVENT_COMMITTED tag. In the error path of x86_schedule_events(),
> >> only the events NOT tagged have their constraint released. The tag
> >> is eventually removed when the event in descheduled.
> >>
> >> Example was given with offcore_response but also applies to LBR_SELECT
> >> and LDLAT shared registers.
> >>
> >> Signed-off-by: Stephane Eranian <eranian@google.com>
> >
> > I'm getting conflicts against other patches -- most notably I think the
> > contraints stack opt from Andrew Hunter.
> >
> Yes, that would not surprise me. I wrote this patch without assuming
> Andrew's patch would be there. But we need to add it. Then we can fix
> the shared_regs patch.
> 
> > I'll try and get Ingo to finally pick up my queued patches so we can
> > rebase.
> 
> Ok, thanks.

That happened yesterday, so latest -tip should be a good base to work on.

Thanks,

	Ingo
