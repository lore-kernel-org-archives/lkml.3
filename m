Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbaIHMUz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 08:20:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752925AbaIHMUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 08:20:54 -0400
Date: Mon, 8 Sep 2014 14:19:52 +0200
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
Message-ID: <20140908121952.GB17728@krava.brq.redhat.com>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
 <1408977943-16594-2-git-send-email-jolsa@kernel.org>
 <20140902105036.GH5806@worktop.ger.corp.intel.com>
 <20140908094348.GB1172@krava.brq.redhat.com>
 <20140908094548.GA6758@twins.programming.kicks-ass.net>
 <20140908094855.GR3588@twins.programming.kicks-ass.net>
 <20140908100122.GS3588@twins.programming.kicks-ass.net>
 <20140908113958.GT3588@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140908113958.GT3588@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 01:39:58PM +0200, Peter Zijlstra wrote:
> On Mon, Sep 08, 2014 at 12:01:22PM +0200, Peter Zijlstra wrote:
> > On Mon, Sep 08, 2014 at 11:48:55AM +0200, Peter Zijlstra wrote:
> > 
> > > > The thing is; I don't understand those reasons. That commit log doesn't
> > > > explain.
> > > 
> > > Ah wait, I finally see. I think we want to fix that exit path, not
> > > disallow the cloning.
> > > 
> > > The thing is, by not allowing this optimization simple things like eg.
> > > pipe-test say very expensive.
> > 
> > So its 179033b3e064 ("perf: Add PERF_EVENT_STATE_EXIT state for events
> > with exited task") that introduces the problem. Before that things would
> > work correctly afaict.
> > 
> > The exit would remove from the context but leave the event in existence.
> > Both the fd and the inherited events would have references to it, only
> > once those are gone do we destroy the actual event.
> 
> I have another 'problem' with 179033b3e064. What if you 'want' to
> continue monitoring after the initial task died? Eg. if you want to
> monitor crap that unconditionally daemonizes.

right.. did not think of that.. need to check more, but
seems like just the check for children should be enough

jirka


---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index bf482ccbdbe1..341d0b47ca14 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3568,6 +3568,19 @@ static int perf_event_read_one(struct perf_event *event,
 	return n * sizeof(u64);
 }
 
+static bool is_event_hup(struct perf_event *event)
+{
+	bool no_children;
+
+	if (event->state != PERF_EVENT_STATE_EXIT)
+		return false;
+
+	mutex_lock(&event->child_mutex);
+	no_children = list_empty(&event->child_list);
+	mutex_unlock(&event->child_mutex);
+	return no_children;
+}
+
 /*
  * Read the performance event - simple non blocking version for now
  */
@@ -3582,8 +3595,7 @@ perf_read_hw(struct perf_event *event, char __user *buf, size_t count)
 	 * error state (i.e. because it was pinned but it couldn't be
 	 * scheduled on to the CPU at some point).
 	 */
-	if ((event->state == PERF_EVENT_STATE_ERROR) ||
-	    (event->state == PERF_EVENT_STATE_EXIT))
+	if ((event->state == PERF_EVENT_STATE_ERROR) || (is_event_hup(event)))
 		return 0;
 
 	if (count < event->read_size)
@@ -3614,7 +3626,7 @@ static unsigned int perf_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &event->waitq, wait);
 
-	if (event->state == PERF_EVENT_STATE_EXIT)
+	if (is_event_hup(event))
 		return events;
 
 	/*
