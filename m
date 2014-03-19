Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609AbaCSHOV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 03:14:21 -0400
Received: from mga01.intel.com ([192.55.52.88]:57511 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932087AbaCSHOS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 03:14:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,684,1389772800"; 
   d="scan'208";a="494889831"
Message-ID: <532943A2.7040407@intel.com>
Date: Wed, 19 Mar 2014 09:13:38 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>,
        Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 06/13] perf tools: Use tid in mmap/mmap2 events to find
 maps
References: <1395177965-8879-1-git-send-email-acme@infradead.org> <1395177965-8879-7-git-send-email-acme@infradead.org>
In-Reply-To: <1395177965-8879-7-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18.03.2014 23:25, Arnaldo Carvalho de Melo wrote:
> From: Don Zickus <dzickus@redhat.com>
> 
> Now that we can properly synthesize threads system-wide, make sure the
> mmap and mmap2 events use tids instead of pids to locate their maps.

This is a good change but it cannot go yet because it is dependent on Jiri's
"perf tools: Share map groups within process" series.

perf tools assume that threads share virtual memory.  That means that a
mapping created by one thread is visible to all threads in the thread group.
 That was implemented by putting all the maps on the thread group leader
(pid == tid).  The alternative is to share the map groups instead, which is
what Jiri is doing.

> 
> Signed-off-by: Don Zickus <dzickus@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/r/1393429527-167840-3-git-send-email-dzickus@redhat.com
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/tests/hists_link.c | 1 +
>  tools/perf/util/machine.c     | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/tests/hists_link.c b/tools/perf/tests/hists_link.c
> index 2b6519e0e36f..7ccbc7b6ae77 100644
> --- a/tools/perf/tests/hists_link.c
> +++ b/tools/perf/tests/hists_link.c
> @@ -101,6 +101,7 @@ static struct machine *setup_fake_machine(struct machines *machines)
>  			.mmap = {
>  				.header = { .misc = PERF_RECORD_MISC_USER, },
>  				.pid = fake_mmap_info[i].pid,
> +				.tid = fake_mmap_info[i].pid,
>  				.start = fake_mmap_info[i].start,
>  				.len = 0x1000ULL,
>  				.pgoff = 0ULL,
> diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
> index d280bf210183..a53cd0b8c151 100644
> --- a/tools/perf/util/machine.c
> +++ b/tools/perf/util/machine.c
> @@ -1027,7 +1027,7 @@ int machine__process_mmap2_event(struct machine *machine,
>  	}
>  
>  	thread = machine__findnew_thread(machine, event->mmap2.pid,
> -					event->mmap2.pid);
> +					event->mmap2.tid);
>  	if (thread == NULL)
>  		goto out_problem;
>  
> @@ -1075,7 +1075,7 @@ int machine__process_mmap_event(struct machine *machine, union perf_event *event
>  	}
>  
>  	thread = machine__findnew_thread(machine, event->mmap.pid,
> -					 event->mmap.pid);
> +					 event->mmap.tid);
>  	if (thread == NULL)
>  		goto out_problem;
>  
> 

