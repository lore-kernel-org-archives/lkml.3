Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab3HGPYU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 11:24:20 -0400
Received: from mail-ve0-f175.google.com ([209.85.128.175]:40964 "EHLO
	mail-ve0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754534Ab3HGPYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 11:24:16 -0400
Date: Wed, 7 Aug 2013 11:30:33 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: Vince Weaver <vincent.weaver@maine.edu>
cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "trinity@vger.kernel.org" <trinity@vger.kernel.org>
Subject: Re: perf,arm -- oops in validate_event
In-Reply-To: <alpine.DEB.2.10.1308071122470.8139@vincent-weaver-1.um.maine.edu>
Message-ID: <alpine.DEB.2.10.1308071129000.8139@vincent-weaver-1.um.maine.edu>
References: <alpine.DEB.2.10.1308051622270.28589@vincent-weaver-1.um.maine.edu> <alpine.DEB.2.10.1308051711080.31327@vincent-weaver-1.um.maine.edu> <20130806111932.GA25383@e106331-lin.cambridge.arm.com> <20130806115921.GA14798@mudshark.cambridge.arm.com>
 <20130806130815.GC25383@e106331-lin.cambridge.arm.com> <20130807130027.GA16474@mudshark.cambridge.arm.com> <alpine.DEB.2.10.1308071122470.8139@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Aug 2013, Vince Weaver wrote:

> On Wed, 7 Aug 2013, Will Deacon wrote:
> 
> > Ok, so the following quick hack below should solve the issue (can you confirm
> > it please, since I don't have access to any hardware atm?)
> > 
> > We should revisit this for 3.12 though, because I'm not sure that our
> > validation code even does the right thing when there are multiple PMUs
> > involved.
> > 
> > --->8
> > 
> > diff --git a/arch/arm/kernel/perf_event.c b/arch/arm/kernel/perf_event.c
> > index d9f5cd4..0500f10b 100644
> > --- a/arch/arm/kernel/perf_event.c
> > +++ b/arch/arm/kernel/perf_event.c
> > @@ -253,6 +253,9 @@ validate_event(struct pmu_hw_events *hw_events,
> >         struct arm_pmu *armpmu = to_arm_pmu(event->pmu);
> >         struct pmu *leader_pmu = event->group_leader->pmu;
> >  
> > +       if (is_software_event(event))
> > +               return 1;
> > +
> >         if (event->pmu != leader_pmu || event->state < PERF_EVENT_STATE_OFF)
> >                 return 1;
> 
> this isn't enough.  You can also trigger the oops by using
> tracepoint or breakpoint events as group leaders in addition to software
> events.

I take that back, it turns out tracepoint and breakpoint both
have task_ctx_nr set to perf_sw_context (althouth breakpoint has
a comment saying this may change in the future).

Let me compile and verify the fix.  It may take some time for the compile 
to finish as it's not a very fast machine.

Vince
