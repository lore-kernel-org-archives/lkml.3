Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756130AbaDVTlj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 15:41:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44388 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755761AbaDVTlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 15:41:09 -0400
Date: Tue, 22 Apr 2014 15:40:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@redhat.com,
        peterz@infradead.org, mingo@elte.hu, namhyung@kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH] perf tools: fix processing of pid/tid for mmap records
Message-ID: <20140422194031.GM8488@redhat.com>
References: <20140421160655.GA4201@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140421160655.GA4201@quad>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 06:06:55PM +0200, Stephane Eranian wrote:
> perf tools: fix processing of pid/tid for mmap records
>     
> Mmaps are global to a process (always). Processing them
> per-thread was causing some serious issues in case mmaps
> would overlap. The overlap fixups would only occur in the
> context of the thread which generated the overlapping
> mmap. But that was cause issues later on when a sample
> from another thread would fall into that overlapping
> mmap.

eh?  You are basically reverting my patch for a similar problem. :-)

I was running a large multi-threading program (specjbb) and the threads
were not being seperated into their own map'd areas.  So either I had to
lump all threads in to the same pid space or make the change you are
reverting.

The problem I had with the double pid (as you propose), I would later look
up samples based on pid/tid and there would be _no_ map available because
it was created as a pid/pid pair.  As a result, our c2c program would drop
thousands of samples on the floor (because there was no mapping for the
data address to get the major/minor/inode info).

Now I modified our c2c program to lookup samples as pid/pid but now the
maps lost tid info, and I had to hack around that by carrying the tid info
in a private struct.

Hopefully Jiri's thread work using pointers will solve both our problems.
:-)  But I can't ack your patch because it will break my work :-(

Cheers,
Don


> 
> The solution to the problem is to handle ALL mmaps as
> occurring in the master thread (pid = tid) and then to
> lookup for thread map using pid as the tid argument.
> This is how samples are looking up for the thread map
> already (notice pid passed twice):
>     
> int perf_event__preprocess_sample(const union perf_event *event,
>                                   struct machine *machine,
>                                   struct addr_location *al,
>                                   struct perf_sample *sample)
> {
>         struct thread *thread = machine__findnew_thread(machine, sample->pid,
>                                                         sample->pid);
> }
>     
> Without this fix, some samples in overlapping regions
> may not be symbolized.
>     
> Signed-off-by: Stephane Eranian <eranian@google.com>
> 
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index a53cd0b..43cdc0a 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1025,9 +1025,9 @@ int machine__process_mmap2_event(struct machine *machine,
>  			goto out_problem;
>  		return 0;
>  	}
> -
> +	/* only look by pid for mmap events */
>  	thread = machine__findnew_thread(machine, event->mmap2.pid,
> -					event->mmap2.tid);
> +					event->mmap2.pid);
>  	if (thread == NULL)
>  		goto out_problem;
>  
> @@ -1073,9 +1073,9 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
>  			goto out_problem;
>  		return 0;
>  	}
> -
> +	/* only look by pid for mmap events */
>  	thread = machine__findnew_thread(machine, event->mmap.pid,
> -					 event->mmap.tid);
> +					 event->mmap.pid);
>  	if (thread == NULL)
>  		goto out_problem;
>  
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
