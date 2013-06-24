Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881Ab3FXPsh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 11:48:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55106 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752565Ab3FXPsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 11:48:35 -0400
Date: Mon, 24 Jun 2013 17:48:20 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        vincent.weaver@maine.edu, Jiri Olsa <jolsa@redhat.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Subject: Re: [PATCH v2] perf,x86: Fix shared register mutual exclusion
 enforcement
Message-ID: <20130624154820.GV28407@twins.programming.kicks-ass.net>
References: <20130620164254.GA3556@quad>
 <20130624074656.GG28407@twins.programming.kicks-ass.net>
 <CABPqkBRpCmDH-TJgAYCDUF4bONuY1mtSiRmRTnbxduWj=+EsEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABPqkBRpCmDH-TJgAYCDUF4bONuY1mtSiRmRTnbxduWj=+EsEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 10:01:26AM +0200, Stephane Eranian wrote:

> You are missing the error path in schedule_events():
> 
>  if (!assign || num) {
> 
>                 for (i = 0; i < n; i++) {
>                         if (x86_pmu.put_event_constraints)
>                                 x86_pmu.put_event_constraints(cpuc,
> cpuc->event_list[i]);
>                 }
> 
>         }
> 
> That one wipes out on get() even on events that were correctly
> schedule in the previous
> invocation. So here group2 fails, but it should not release the
> constraints from group1.

What I was saying:

 schedule(group1)
   get_event_constraints() +1
   no error path, no puts

 schedule(group2)
   get_event_constraints() +1
   *fail*
     put_event_constraints() -1

This leaves the constraints of group1 with a net +1 'ref' count and thus
if we were to treat the get/put as such, the put wouldn't be the last
and thus shouldn't release resources.

> > Only once these events pass through x86_pmu_del() will they get a final
> > put and the 'ref' count will drop to 0.
> >
> > Now the problem seems to be the get/put things don't actually count
> > properly.
> >
> > However, if we look at __intel_shared_reg_{get,put}_constraints() there
> > is a refcount in there; namely era->ref; however we don't appear to
> > clear reg->alloc based on it.
> >
> The era->ref is not used to ref count the number of successful attempts
> at scheduling. It is used to count the number of CPU sharing the resource.
> So it goes from 0, 1, to 2. You can invoke schedule_events() many more
> times. The reg->alloc is a bypass, to avoid checking the shared reg
> again and again if it succeeded once.

Oh right, I knew I was missing something..  :/

> For a while I thought I could leverage the era->ref to account the get/put.
> But it does not work. Because the of the put().

Crud, right you are. 

Also, I don't think we could even use them as I outlined; suppose it
would have worked; then we'd have:

  schedule(group1)
    get_event_constraints() +1

  schedule(group2)
    get_event_constraints() +1

And we'd be stuck with a ref of 2, the put at x86_pmu_del() would never
be sufficient to drop them back to 0 again.

A well, your patch does indeed make it work so I'll grab that.
