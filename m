Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3FYKqX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 06:46:23 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:59215 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750784Ab3FYKqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 06:46:22 -0400
Date: Tue, 25 Jun 2013 12:46:16 +0200
From: Robert Richter <rric@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/14] perf, persistent: Kernel updates for perf tool
 integration
Message-ID: <20130625104616.GE21579@rric.localhost>
References: <1370968960-22527-1-git-send-email-rric@kernel.org>
 <20130624100819.GQ28407@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130624100819.GQ28407@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.06.13 12:08:19, Peter Zijlstra wrote:
> >  git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git persistent-v2
> > 
> 
> OK, so I gave up on reading the patches :/ and went and looked at the git
> tree. There's just too much needless churn in the patches.

Ok, we will rework the patches to have a final patch set hiding all
reworks. I was hoping we could work on a public branch since this
eases developing code with multiple people working on it. This also
shows how code matures. But this seems not to fly.

> + int perf_add_persistent_event(struct perf_event_attr *attr, unsigned nr_pages)
> + {
> + 	struct perf_event *event;
> + 	int i;
> + 
> + 	for_each_possible_cpu(i) {
> + 		event = add_persistent_event_on_cpu(i, attr, nr_pages);
> + 		if (IS_ERR(event))
> + 			goto unwind;
> + 	}
> + 	return 0;
> + 
> + unwind:
> + 	pr_err("%s: Error adding persistent event on cpu %d: %ld\n",
> + 		__func__, i, PTR_ERR(event));
> + 
> + 	while (--i >= 0)
> + 		del_persistent_event(i, attr);
> + 
> + 	return PTR_ERR(event);
> + }
> 
> This assumes cpu_possible_mask doesn't have holes in; I'm fairly sure we cannot
> assume such.

Right, needs to be fixed.

> Furthermore; while the function is exposed and thus looks like a generic usable
> thing; however it looks to 'forget' making a sysfs entry, making it look like
> something incomplete.
> 
> Only the ill named perf_add_persistent_event_by_id() function looks
> something that's usable outside of this.

Right, the name should be actually perf_add_persistent_tp() or so.

And, most of the function should be merged with
perf_add_persistent_event(). Maybe perf_add_persistent_event_by_id()
could be removed completly leaving perf_add_persistent_tp() as wrapper
for tracepoints.

> What's with MAX_EVENTS ?

It is the total number of sysfs entries that can currently be
registered dynamically. The problem with an unlimited event number is
that the sysfs attr list is a fixed array. We need to resize the array
which involves copying entries including locking etc. This was left
for later. ;)

Btw, another thing left for later is cpu hotplug code. I know this
needs to be implemented. But we want to see something running first.
Do you know what happens to system-wide events if a cpu is offline? It
looks like cpu_function_call() in perf_install_in_context() simply
ignores to install an event on an offline cpu. Not sure if it is later
enabled while bringing the cpu online. Quick looking at the code seems
to be not.

-Robert
