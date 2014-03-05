Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754984AbaCER3I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 12:29:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63853 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaCER3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 12:29:05 -0500
Date: Wed, 5 Mar 2014 12:29:01 -0500
From: Don Zickus <dzickus@redhat.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, acme@ghostprotocols.net,
        eranian@google.com
Subject: Re: [PATCH 1/2] perf: fix synthesizing mmaps for threads
Message-ID: <20140305172901.GC25953@redhat.com>
References: <1393429527-167840-1-git-send-email-dzickus@redhat.com>
 <1393429527-167840-2-git-send-email-dzickus@redhat.com>
 <20140305165857.GA28127@krava.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140305165857.GA28127@krava.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 05, 2014 at 05:58:57PM +0100, Jiri Olsa wrote:
> On Wed, Feb 26, 2014 at 10:45:26AM -0500, Don Zickus wrote:
> > Currently if a process creates a bunch of threads using pthread_create
> > and then perf is run in system_wide mode, the mmaps for those threads
> > are not captured with a synthesized mmap event.
> > 
> > The reason is those threads are not visible when walking the /proc/
> > directory looking for /proc/<pid>/maps files.  Instead they are discovered
> > using the /proc/<pid>/tasks file (which the synthesized comm event uses).
> > 
> > This causes problems when a program is trying to map a data address to a
> > tid.  Because the tid has no maps, the event is dropped.  Changing the program
> > to look up using the pid instead of the tid, finds the correct maps but creates
> > ugly hacks in the program to carry the correct tid around.
> 
> hm, 2 hacks comes to my mind ;-)
> 
> 1) share 'struct thread::mg' among thread group (pid)
> 
> 2) or lookup the thread group leader if we find out we are
>    not the leader and dont have the map info (attached)
> 
> your change makes the process map info (same info) being duplicated
> for all threads (eventhough it's probably not that much bytes wasted)
> 
> I think I'd prefer ad 1) ... the patch for ad 2) assumes there's
> always thread group leader (which might not be the case always?)
> also 'thread->pid_' handling seems troubled
> 
> I dont have code solution for 1), maybe you've already cover that
> and considered it hacky.. just throwing ideas ;-)

It doesn't matter to me. :-)  The c2c tool needs this to work correctly
otherwise the analysis is wrong when profiling the system with the app
already running with lots of threads (ie databases).

Well I shouldn't say the analysis is wrong, it just wrongly attributes the
pid being responsible for all the problems when it could be some garbage
collection thread running to frequently.

Cheers,
Don

> 
> jirka
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index b0f3ca8..c428186 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -654,9 +654,17 @@ void thread__find_addr_map(struct thread *thread,
>  			   enum map_type type, u64 addr,
>  			   struct addr_location *al)
>  {
> -	struct map_groups *mg = &thread->mg;
> +	struct map_groups *mg;
>  	bool load_map = false;
>  
> +	if (thread->tid != thread->pid_) {
> +		thread = machine__findnew_thread(machine, thread->pid_, thread->pid_);
> +		if (!thread)
> +			return;
> +	}
> +
> +	mg = &thread->mg;
> +
>  	al->machine = machine;
>  	al->thread = thread;
>  	al->addr = addr;
