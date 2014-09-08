Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaIHQqR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 12:46:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754267AbaIHQqM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 12:46:12 -0400
Date: Mon, 8 Sep 2014 18:45:24 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 1/9] perf: Remove redundant parent context check from
 context_equiv
Message-ID: <20140908164524.GJ17728@krava.brq.redhat.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
 <20140908100122.GS3588@twins.programming.kicks-ass.net>
 <20140908120140.GA17728@krava.brq.redhat.com>
 <20140908133428.GG6758@twins.programming.kicks-ass.net>
 <20140908151305.GU3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908151305.GU3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 05:13:05PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 08, 2014 at 03:34:28PM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 08, 2014 at 02:01:41PM +0200, Jiri Olsa wrote:
> > > On Mon, Sep 08, 2014 at 12:01:22PM +0200, Peter Zijlstra wrote:
> > > > On Mon, Sep 08, 2014 at 11:48:55AM +0200, Peter Zijlstra wrote:
> > > > 
> > > > > > The thing is; I don't understand those reasons. That commit log doesn't
> > > > > > explain.
> > > > > 
> > > > > Ah wait, I finally see. I think we want to fix that exit path, not
> > > > > disallow the cloning.
> > > > > 
> > > > > The thing is, by not allowing this optimization simple things like eg.
> > > > > pipe-test say very expensive.
> > > > 
> > > > So its 179033b3e064 ("perf: Add PERF_EVENT_STATE_EXIT state for events
> > > > with exited task") that introduces the problem. Before that things would
> > > > work correctly afaict.
> > > 
> > > hum, I dont think so.. because the perf_remove_from_context set event
> > > to PERF_EVENT_STATE_OFF state anyway.. thus making any new cloned events
> > > disabled
> > 
> > Urgh, see I knew I was missing something.
> > 
> > Can't we fix that? Lemme check to see what relies on this.
> 
> 2e2af50b1fab ("perf_events: Disable events when we detach them")
> 
> Seems to be about it. And I think we should solve that differently, but
> the best I can come up with ties into the event->ctx mess we have in
> that other thread.
> 
> The thing is, IOC_ENABLE/DISABLE and read() and such should act
> (sanely and) independent from the attached state.
> 
> Its just that the whole event->ctx migration mess is making this
> somewhat hard atm.
> 
> So things like perf_event_read() should not only check ctx->is_active
> but also worry about event->attach_state & PERF_ATTACH_CONTEXT.
> 
> Now the biggest problem is that we cannot tell if its a temporary state
> (move_group / migrate_context) or permanent (exit)... 
> 
> Urgh

I just noticed that we initialize the child state with base parent
state not the real (immediate) parent.. which is what we want IMO

I wonder attached patch could fix the issue mentioned in:
  1f9a726 perf: Do not allow optimized switch for non-cloned events

now I need to recall what I used to test this ;-)

jirka


---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index e4d6924..561a4ea 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7794,6 +7794,7 @@ inherit_event(struct perf_event *parent_event,
 	      struct perf_event *group_leader,
 	      struct perf_event_context *child_ctx)
 {
+	enum perf_event_active_state parent_state = parent_event->state;
 	struct perf_event *child_event;
 	unsigned long flags;
 
@@ -7827,7 +7828,7 @@ inherit_event(struct perf_event *parent_event,
 	 * not its attr.disabled bit.  We hold the parent's mutex,
 	 * so we won't race with perf_event_{en, dis}able_family.
 	 */
-	if (parent_event->state >= PERF_EVENT_STATE_INACTIVE)
+	if (parent_state >= PERF_EVENT_STATE_INACTIVE)
 		child_event->state = PERF_EVENT_STATE_INACTIVE;
 	else
 		child_event->state = PERF_EVENT_STATE_OFF;
