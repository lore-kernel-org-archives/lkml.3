Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaGGKU6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:20:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35968 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751933AbaGGKUz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:20:55 -0400
Date: Mon, 7 Jul 2014 12:20:20 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/1] perf: Prevent race in PERF_SAMPLE_READ group format
 sample output
Message-ID: <20140707102020.GA22764@krava.redhat.com>
References: <1403721875-15669-1-git-send-email-jolsa@kernel.org>
 <1403721875-15669-2-git-send-email-jolsa@kernel.org>
 <20140707090428.GG6758@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140707090428.GG6758@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 07, 2014 at 11:04:28AM +0200, Peter Zijlstra wrote:
> On Wed, Jun 25, 2014 at 08:44:35PM +0200, Jiri Olsa wrote:
> > From: Jiri Olsa <jolsa@redhat.com>
> > 
> > While iterating siblings in perf_output_read_group we could
> > race with addition and removal of sibling in perf_group_attach
> > and perf_group_detach respective.
> 
> So why would anybody do this?

the test program from 0/1 email hangs up my server
but no standard reason AFAICS

> 
> > While in perf_output_read_group we are under active context,
> > so the only sibling_list modification could come via IPI in:
> >   perf_install_in_context or perf_remove_from_context
> > 
> > Disable interrupts before iterating siblings to prevent
> > this race.
> > 
> > Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> > Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Ingo Molnar <mingo@kernel.org>
> > Cc: Paul Mackerras <paulus@samba.org>
> > Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> >  kernel/events/core.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> > 
> > diff --git a/kernel/events/core.c b/kernel/events/core.c
> > index a33d9a2b..66649d3 100644
> > --- a/kernel/events/core.c
> > +++ b/kernel/events/core.c
> > @@ -4509,6 +4509,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
> >  {
> >  	struct perf_event *leader = event->group_leader, *sub;
> >  	u64 read_format = event->attr.read_format;
> > +	unsigned long flags;
> >  	u64 values[5];
> >  	int n = 0;
> >  
> > @@ -4529,6 +4530,15 @@ static void perf_output_read_group(struct perf_output_handle *handle,
> >  
> >  	__output_copy(handle, values, n * sizeof(u64));
> >  
> > +	/*
> > +	 * We are now under active context, so the only sibling_list
> > +	 * modification could come via IPI in:
> > +	 *   perf_install_in_context and perf_remove_from_context
> > +	 *
> > +	 * Disable interrupts to prevent this race.
> > +	 */
> > +	local_irq_save(flags);
> 
> I think this is too late; you want it right at the beginning, before we
> read ->nr_siblings, as that is also changed by
> add_event_to_ctx()->perf_group_attach().
> 
> That said; it would be nice not to have to poke at the interrupt flag,
> its expensive.

right.. I'll check if we could use the rcu loop/locking here

> 
> So is this really a problem, or just a case of: if you do silly things,
> you get silly results?

I've got soft lockup, sometimes ended up with unkillable perf process
also few total server hangs

jirka
