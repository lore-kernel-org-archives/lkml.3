Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878AbaATTF4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 14:05:56 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:39039 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751380AbaATTFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 14:05:54 -0500
Date: Mon, 20 Jan 2014 14:05:51 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: riel@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        chegu_vinod@hp.com, mgorman@suse.de, mingo@redhat.com
Subject: Re: [PATCH 4/7] numa,sched: tracepoints for NUMA balancing active
 nodemask changes
Message-ID: <20140120140551.3343ab2b@gandalf.local.home>
In-Reply-To: <20140120165205.GJ31570@twins.programming.kicks-ass.net>
References: <1389993129-28180-1-git-send-email-riel@redhat.com>
	<1389993129-28180-5-git-send-email-riel@redhat.com>
	<20140120165205.GJ31570@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014 17:52:05 +0100
Peter Zijlstra <peterz@infradead.org> wrote:

> On Fri, Jan 17, 2014 at 04:12:06PM -0500, riel@redhat.com wrote:
> > From: Rik van Riel <riel@redhat.com>
> > 

> > +++ b/kernel/sched/fair.c
> > @@ -1300,10 +1300,14 @@ static void update_numa_active_node_mask(struct task_struct *p)
> >  		faults = numa_group->faults_from[task_faults_idx(nid, 0)] +
> >  			 numa_group->faults_from[task_faults_idx(nid, 1)];
> >  		if (!node_isset(nid, numa_group->active_nodes)) {
> > -			if (faults > max_faults * 4 / 10)
> > +			if (faults > max_faults * 4 / 10) {
> > +				trace_update_numa_active_nodes_mask(current->pid, numa_group->gid, nid, true, faults, max_faults);
> 
> While I think the tracepoint hookery is smart enough to avoid evaluating
> arguments when they're disabled, it might be best to simply pass:
> current and numa_group and do the dereference in fast_assign().

It's really up to gcc to optimize it. But that said, it is more
efficient to just past the pointer and do the dereferencing in the
fast_assign(). At least it keeps any bad optimization in gcc from
infecting the tracepoint caller.

It also makes it easier to get other information if you want to later
extend that tracepoint.

Does this tracepoint always use current? If so, why bother passing it
in?

-- Steve
