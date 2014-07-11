Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848AbaGKNci (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:32:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752985AbaGKNch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:32:37 -0400
Date: Fri, 11 Jul 2014 15:31:56 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 2/5] perf: Destroy event's children on task exit
Message-ID: <20140711133156.GA13494@krava.redhat.com>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
 <1405079782-8139-3-git-send-email-jolsa@kernel.org>
 <20140711132309.GH20603@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140711132309.GH20603@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 03:23:09PM +0200, Peter Zijlstra wrote:
> On Fri, Jul 11, 2014 at 01:56:19PM +0200, Jiri Olsa wrote:
> > From: Jiri Olsa <jolsa@redhat.com>
> > 
> > When task exits we close:
> >   1) all events that are installed in task
> >   2) all events owned by task (via file descriptor)
> > 
> > But we don't close children events of 2) events. Those children
> > events stay until the child task exits and are useless with the
> > parent being gone, because we have no way to get to values any
> > more.
> > 
> > Plus if the event stays installed in task even with the owner task
> > gone, it runs the perf callback any time the task forks, for no
> > real reason.
> > 
> > Closing all children events events when the owner task of the
> > parent event is closed.
> 
> So I _think_ the reason we didn't do this is because this is potentially
> very expensive and keeping them around isn't too much bother, they'll
> die eventually.

yep, they will.. but until then the task they are installed
in will continue having them and clone them on each fork

also for each such fork there's the permission check for inherited
tracepoint event, which we canot make without the owner task

so I ended up with closing all the children

jirka
