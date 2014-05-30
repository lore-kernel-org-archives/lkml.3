Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932581AbaE3HFQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 03:05:16 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:47109 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205AbaE3HFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 03:05:15 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@gmail.com>
To: Don Zickus <dzickus@redhat.com>
Cc: jolsa@redhat.com, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, eranian@google.com,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH 2/7] Revert "perf: Disable PERF_RECORD_MMAP2 support"
References: <1401208087-181977-1-git-send-email-dzickus@redhat.com>
	<1401208087-181977-3-git-send-email-dzickus@redhat.com>
Date: Fri, 30 May 2014 16:05:12 +0900
In-Reply-To: <1401208087-181977-3-git-send-email-dzickus@redhat.com> (Don
	Zickus's message of "Tue, 27 May 2014 12:28:02 -0400")
Message-ID: <87zjhzeogn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Don,

On Tue, 27 May 2014 12:28:02 -0400, Don Zickus wrote:
> This reverts commit 3090ffb5a2515990182f3f55b0688a7817325488.
>
> Re-enable the mmap2 interface as we will have a user soon.
>
> Since things have changed since perf disabled mmap2, small tweaks
> to the revert had to be done:
>
> o commit 9d4ecc88 forced (n!=8) to become (n<7)
> o a new libunwind test needed updating to use mmap2 interface

Just few nitpicks..


[SNIP]
> @@ -195,14 +196,15 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
>  		strcpy(execname, "");
>  
>  		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
> -		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
> -		       &event->mmap.start, &event->mmap.len, prot,
> -		       &event->mmap.pgoff,
> -		       execname);
> -		/*
> - 		 * Anon maps don't have the execname.
> - 		 */

I think it's better to leave this comment as is.


> -		if (n < 4)
> +		n = sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %x:%x %u %s\n",
> +		       &event->mmap2.start, &event->mmap2.len, prot,
> +		       &event->mmap2.pgoff, &event->mmap2.maj,
> +		       &event->mmap2.min,
> +		       &ino, execname);
> +
> +		event->mmap2.ino = (u64)ino;

And this can be moved below check..

Thanks,
Namhyung


> +
> +		if (n < 7)
>  			continue;
>  		/*
>  		 * Just like the kernel, see __perf_event_mmap in kernel/perf_event.c
> @@ -223,15 +225,15 @@ int perf_event__synthesize_mmap_events(struct perf_tool *tool,
>  			strcpy(execname, anonstr);
>  
>  		size = strlen(execname) + 1;
> -		memcpy(event->mmap.filename, execname, size);
> +		memcpy(event->mmap2.filename, execname, size);
>  		size = PERF_ALIGN(size, sizeof(u64));
> -		event->mmap.len -= event->mmap.start;
> -		event->mmap.header.size = (sizeof(event->mmap) -
> -					(sizeof(event->mmap.filename) - size));
> -		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
> -		event->mmap.header.size += machine->id_hdr_size;
> -		event->mmap.pid = tgid;
> -		event->mmap.tid = pid;
> +		event->mmap2.len -= event->mmap.start;
> +		event->mmap2.header.size = (sizeof(event->mmap2) -
> +					(sizeof(event->mmap2.filename) - size));
> +		memset(event->mmap2.filename + size, 0, machine->id_hdr_size);
> +		event->mmap2.header.size += machine->id_hdr_size;
> +		event->mmap2.pid = tgid;
> +		event->mmap2.tid = pid;
>  
>  		if (process(tool, event, &synth_sample, machine) != 0) {
>  			rc = -1;
> diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
> index 5c28d82..21154da 100644
> --- a/tools/perf/util/evsel.c
> +++ b/tools/perf/util/evsel.c
> @@ -659,6 +659,7 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
>  		perf_evsel__set_sample_bit(evsel, WEIGHT);
>  
>  	attr->mmap  = track;
> +	attr->mmap2 = track && !perf_missing_features.mmap2;
>  	attr->comm  = track;
>  
>  	if (opts->sample_transaction)
