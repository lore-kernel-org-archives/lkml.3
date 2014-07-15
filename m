Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758283AbaGOJbs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:31:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28270 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757279AbaGOJbo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:31:44 -0400
Date: Tue, 15 Jul 2014 11:31:08 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140715093108.GC8154@krava.redhat.com>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
 <20140714111833.GU19379@twins.programming.kicks-ass.net>
 <20140714201854.GJ17761@krava.redhat.com>
 <20140715091104.GU9918@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140715091104.GU9918@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 11:11:04AM +0200, Peter Zijlstra wrote:
> On Mon, Jul 14, 2014 at 10:18:54PM +0200, Jiri Olsa wrote:
> > On Mon, Jul 14, 2014 at 01:18:33PM +0200, Peter Zijlstra wrote:
> > > On Fri, Jul 11, 2014 at 01:56:19PM +0200, Jiri Olsa wrote:
> > > > From: Jiri Olsa <jolsa@redhat.com>

SNIP

> 
> > > I don't think this is correct, perf_event_init_context() can come in
> > > concurrently and the first place it runs into ->child_mutex is after its
> > > already allocated and created the (first) child event.
> > 
> > just noticed this.. I'm working on the other version we decide, but FWIW
> > there's also mutex_lock(&child_ctx->mutex); before removing the context,
> > that should protect it against perf_event_init_context call
> 
> Oh, more fail :-)
> 
> You have:
> 
>   perf_event::child_mutex
>     perf_event_context::mutex
> 
> The existing code has:
> 
>   perf_event_context::mutex
>     perf_event::child_context
> 
> See for example:
> 
>   perf_event_init_context()
>     mutex_lock(&parent_ctx->mutex)
>     inherit_task_group()
>       inherit_group()
>         inherit_event()
> 	  mutex_lock(&parent_event->child_mutex)
> 
> and
> 
>   perf_event_for_each()
>     mutex_lock(&ctx->mutex)
>     perf_event_for_each_child()
>       mutex_lock(&event->child_mutex)
> 
> So the patch creates an AB-BA deadlock.

ouch, right.. I'll try to come with other way

thanks,
jirka
