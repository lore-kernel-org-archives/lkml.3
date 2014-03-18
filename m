Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756066AbaCROLE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 10:11:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18566 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755507AbaCROLB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 10:11:01 -0400
Date: Tue, 18 Mar 2014 10:43:24 -0300
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Don Zickus <dzickus@redhat.com>, jolsa@redhat.com, jmario@redhat.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] perf: Speed up thread map generation
Message-ID: <20140318134324.GB3585@infradead.org>
References: <1394808224-113774-1-git-send-email-dzickus@redhat.com>
 <87ob15tx6a.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ob15tx6a.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Mar 17, 2014 at 10:45:49AM +0900, Namhyung Kim escreveu:
> Hi Don,
> 
> On Fri, 14 Mar 2014 10:43:44 -0400, Don Zickus wrote:
> > When trying to capture perf data on a system running spejbb2013,
> > perf hung for about 15 minutes.  This is because it took that
> > long to gather about 10,000 thread maps and process them.
> >
> > I don't think a user wants to wait that long.
> >
> > Instead, recognize that thread maps are roughly equivalent to
> > pid maps and just quickly copy those instead.
> >
> > To do this, I synthesize 'fork' events, this eventually calls
> > thread__fork() and copies the maps over.
> >
> > The overhead goes from 15 minutes down to about a few seconds.
> 
> [SNIP]
> > @@ -416,6 +453,10 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
> >  	if (mmap_event == NULL)
> >  		goto out_free_comm;
> >  
> > +	fork_event = malloc(sizeof(fork_event->fork) + machine->id_hdr_size);
> > +	if (fork_event == NULL)
> > +		goto out_free_mmap;
> > +
> >  	if (machine__is_default_guest(machine))
> >  		return 0;
> 
> Not related to this patch, but this will causes a memory leak..
> So I think below patch is needed on top (not sure it's also needed for
> perf_event__synthesize_thread_map() too).

Good catch, applying it, please next time send it under separate cover,
i.e. not inside another thread.

- Arnaldo
 
> 
> >From 3c4b49b4f540c7d49ee78364b02faa0bfce59c67 Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung@kernel.org>
> Date: Mon, 17 Mar 2014 10:23:06 +0900
> Subject: [PATCH] perf tools: Fix a possible memory leak
> 
> Checking default guest machine should be done before allocating event
> structures otherwise it'll leak memory.
> 
> Cc: Don Zickus <dzickus@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/event.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index 3e580be0f6fb..eab930d28159 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -445,6 +445,9 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
>  	union perf_event *comm_event, *mmap_event, *fork_event;
>  	int err = -1;
>  
> +	if (machine__is_default_guest(machine))
> +		return 0;
> +
>  	comm_event = malloc(sizeof(comm_event->comm) + machine->id_hdr_size);
>  	if (comm_event == NULL)
>  		goto out;
> @@ -457,9 +460,6 @@ int perf_event__synthesize_threads(struct perf_tool *tool,
>  	if (fork_event == NULL)
>  		goto out_free_mmap;
>  
> -	if (machine__is_default_guest(machine))
> -		return 0;
> -
>  	snprintf(proc_path, sizeof(proc_path), "%s/proc", machine->root_dir);
>  	proc = opendir(proc_path);
>  
> -- 
> 1.7.11.7
