Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752809Ab3KLHAn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 02:00:43 -0500
Received: from mga09.intel.com ([134.134.136.24]:40119 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751407Ab3KLHAh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 02:00:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="407305126"
Message-ID: <5281D3B8.2030104@intel.com>
Date: Tue, 12 Nov 2013 09:07:36 +0200
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 10/10] perf tests: Use lower sample_freq in sw clock event
 period test
References: <1384201353-23863-1-git-send-email-acme@infradead.org> <1384201353-23863-11-git-send-email-acme@infradead.org>
In-Reply-To: <1384201353-23863-11-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/13 22:22, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> We were using it at 10 kHz, which doesn't work in machines where somehow
> the max freq was auto reduced by the kernel:
>
> [root@ssdandy ~]# perf test 19
> 19: Test software clock events have valid period values    : FAILED!
> [root@ssdandy ~]# perf test -v 19
> 19: Test software clock events have valid period values    :
> --- start ---
> Couldn't open evlist: Invalid argument
> ---- end ----
> Test software clock events have valid period values: FAILED!
> [root@ssdandy ~]#
>
> [root@ssdandy ~]# cat /proc/sys/kernel/perf_event_max_sample_rate
> 7000
>
> Reducing it to 500 Hz should be good enough for this test and also
> shouldn't affect what it is testing.
>
> But warn the user if it fails, informing the knob and the freq tried.

Doesn't work for me:

./perf test -v 19
19: Test software clock events have valid period values    :
--- start ---
mmap size 528384B
mmap size 528384B
All (0) samples have period value of 1!
---- end ----
Test software clock events have valid period values: FAILED!

But this fixes it:

diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
index 93a7139..6664a7c 100644
--- a/tools/perf/tests/sw-clock.c
+++ b/tools/perf/tests/sw-clock.c
@@ -9,7 +9,7 @@
 #include "util/cpumap.h"
 #include "util/thread_map.h"
 
-#define NR_LOOPS  1000000
+#define NR_LOOPS  10000000
 
 /*
  * This test will open software clock events (cpu-clock, task-clock)


>
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Link: http://lkml.kernel.org/n/tip-548rhj1uo6xbwnxa95kw3hqe@git.kernel.org
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/tests/sw-clock.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
>
> diff --git a/tools/perf/tests/sw-clock.c b/tools/perf/tests/sw-clock.c
> index ed777728dfe7..93a7139ff5f7 100644
> --- a/tools/perf/tests/sw-clock.c
> +++ b/tools/perf/tests/sw-clock.c
> @@ -34,7 +34,7 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
>  		.freq = 1,
>  	};
>  
> -	attr.sample_freq = 10000;
> +	attr.sample_freq = 500;
>  
>  	evlist = perf_evlist__new();
>  	if (evlist == NULL) {
> @@ -58,8 +58,11 @@ static int __test__sw_clock_freq(enum perf_sw_ids clock_id)
>  	}
>  
>  	if (perf_evlist__open(evlist)) {
> +		const char *knob = "/proc/sys/kernel/perf_event_max_sample_rate";
> +
>  		err = -errno;
> -		pr_debug("Couldn't open evlist: %s\n", strerror(errno));
> +		pr_debug("Couldn't open evlist: %s\nHint: check %s, using %" PRIu64 " in this test.\n",
> +			 strerror(errno), knob, (u64)attr.sample_freq);
>  		goto out_delete_maps;
>  	}
>  

