Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab3EUMiR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 08:38:17 -0400
Received: from mail-ob0-f180.google.com ([209.85.214.180]:51133 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3EUMiP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 08:38:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130521110858.GH26912@twins.programming.kicks-ass.net>
References: <20130521105337.GA2879@quad>
	<20130521110858.GH26912@twins.programming.kicks-ass.net>
Date: Tue, 21 May 2013 14:38:15 +0200
Message-ID: <CABPqkBTkSkHF9Y58FkEHDc4VV7Af+5erheD8GUhtsKup5cN5=w@mail.gmail.com>
Subject: Re: [PATCH] perf: check branch sampling priv level in generic code
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 1:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> On Tue, May 21, 2013 at 12:53:37PM +0200, Stephane Eranian wrote:
> >
> > This patch reverts commit 7cc23cd:
> >  perf/x86/intel/lbr: Demand proper privileges for PERF_SAMPLE_BRANCH_KERNEL
> >
> > The check is now implemented in generic code
> > instead of x86 specific code. That way we
> > do not have to repeat the test in each arch
> > supporting branch sampling.
>
> Good point indeed.
>
> > Signed-off-by: Stephane Eranian <eranian@google.com>
> > ---
> >  arch/x86/kernel/cpu/perf_event_intel_lbr.c |   13 +++----------
> >  kernel/events/core.c                       |    9 ++++-----
> >  2 files changed, 7 insertions(+), 15 deletions(-)
> >
>
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index 9dc297f..cf79c81 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -6327,11 +6327,6 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
> >               if (!(mask & ~PERF_SAMPLE_BRANCH_PLM_ALL))
> >                       return -EINVAL;
> >
> > -             /* kernel level capture: check permissions */
> > -             if ((mask & PERF_SAMPLE_BRANCH_PERM_PLM)
> > -                 && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> > -                     return -EACCES;
> > -
>
> Oh hey, there was a check..
>
There was a check. But I realized it was broken. It was checking user+kernel.
But it did not cover the case where the priv level which propagated from the
event and was not specific to the branch_sample_type.


>
> >               /* propagate priv level, when not set for branch */
> >               if (!(mask & PERF_SAMPLE_BRANCH_PLM_ALL)) {
> >
> > @@ -6349,6 +6344,10 @@ static int perf_copy_attr(struct perf_event_attr __user *uattr,
> >                        */
> >                       attr->branch_sample_type = mask;
> >               }
> > +             /* kernel level capture: check permissions */
> > +             if ((mask & PERF_SAMPLE_BRANCH_KERNEL)
> > +                 && perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
> > +                     return -EACCES;
> >       }
> >
> >       if (attr->sample_type & PERF_SAMPLE_REGS_USER) {
> > --
> > 1.7.9.5
> >
