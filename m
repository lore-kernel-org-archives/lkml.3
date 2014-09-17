Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaIQGX3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 02:23:29 -0400
Received: from mga14.intel.com ([192.55.52.115]:12016 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaIQGX2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 02:23:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,539,1406617200"; 
   d="scan'208";a="478049954"
Message-ID: <5419288C.5010403@intel.com>
Date: Wed, 17 Sep 2014 09:22:04 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Waiman Long <Waiman.Long@hp.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>
CC: Peter Zijlstra <peterz@infradead.org>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Scott J Norton <scott.norton@hp.com>, Don Zickus <dzickus@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: [PATCH v2] perf mem: improves DSO long names search speed with
 RB tree
References: <1410894499-27609-1-git-send-email-Waiman.Long@hp.com> <1410894499-27609-2-git-send-email-Waiman.Long@hp.com>
In-Reply-To: <1410894499-27609-2-git-send-email-Waiman.Long@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/16/2014 10:08 PM, Waiman Long wrote:
> With workload that spawns and destroys many threads and processes,
> it was found that perf-mem could took a long time to post-process
> the perf data after the target workload had completed its operation.
> The performance bottleneck was found to be searching and insertion
> of the new DSO structures (thousands of them in this case).
> 
> In a dual-socket Ivy-Bridge E7-4890 v2 machine (30-core, 60-thread),
> the perf profile below shows what perf was doing after the profiled
> AIM7 shared workload completed:
> 
> -     83.94%  perf  libc-2.11.3.so     [.] __strcmp_sse42
>    - __strcmp_sse42
>       - 99.82% map__new
>            machine__process_mmap_event
>            perf_session_deliver_event
>            perf_session__process_event
>            __perf_session__process_events
>            cmd_record
>            cmd_mem
>            run_builtin
>            main
>            __libc_start_main
> -     13.17%  perf  perf               [.] __dsos__findnew
>      __dsos__findnew
>      map__new
>      machine__process_mmap_event
>      perf_session_deliver_event
>      perf_session__process_event
>      __perf_session__process_events
>      cmd_record
>      cmd_mem
>      run_builtin
>      main
>      __libc_start_main
> 
> So about 97% of CPU times were spent in the map__new() function
> trying to insert new DSO entry into the DSO linked list. The whole
> post-processing step took about 9 minutes.
> 
> The DSO structures are currently searched linearly. So the total
> processing time will be proportional to n^2.
> 
> To overcome this performance problem, the DSO code is modified to
> also put the DSO structures in a RB tree sorted by its long name
> in additional to being in a simple linked list. With this change,
> the processing time will become proportional to n*log(n) which will
> be much quicker for large n. However, the short name will still
> be searched using the old linear searching method which is slow.
> With that patch in place, the same perf-mem post-processing step took
> less than 30 seconds to complete.
> 
> Signed-off-by: Waiman Long <Waiman.Long@hp.com>
> ---
>  tools/perf/util/dso.c |   87 ++++++++++++++++++++++++++++++++++++++++++++++--
>  tools/perf/util/dso.h |    1 +
>  2 files changed, 84 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
> index 819f104..fccb2f0 100644
> --- a/tools/perf/util/dso.c
> +++ b/tools/perf/util/dso.c
> @@ -611,17 +611,93 @@ struct dso *dso__kernel_findnew(struct machine *machine, const char *name,
>  	return dso;
>  }
>  
> +/*
> + * RB root of DSOs sorted by the long name
> + */
> +static struct rb_root dso__longname_root = { NULL };

Global variable!

Why not just change the lists to rbtrees i.e.

diff --git a/tools/perf/util/machine.h b/tools/perf/util/machine.h                                                                                          
index 6a6bcc1..fa30780 100644                                                                                                                               
--- a/tools/perf/util/machine.h                                                                                                                             
+++ b/tools/perf/util/machine.h                                                                                                                             
@@ -32,8 +32,8 @@ struct machine {                                                                                                                          
        struct list_head  dead_threads;                                                                                                                     
        struct thread     *last_match;                                                                                                                      
        struct vdso_info  *vdso_info;                                                                                                                       
-       struct list_head  user_dsos;                                                                                                                        
-       struct list_head  kernel_dsos;                                                                                                                      
+       struct rb_root    user_dsos;                                                                                                                        
+       struct rb_root    kernel_dsos;                                                                                                                      
        struct map_groups kmaps;                                                                                                                            
        struct map        *vmlinux_maps[MAP__NR_TYPES];                                                                                                     
        u64               kernel_start;

And make all the resulting adjustments.

