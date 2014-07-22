Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754368AbaGVOAk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 10:00:40 -0400
Received: from mail.kernel.org ([198.145.19.201]:45595 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750870AbaGVOAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 10:00:39 -0400
Date: Tue, 22 Jul 2014 11:00:34 -0300
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/52] perf tools: Fix jump label always changing during
 tracing
Message-ID: <20140722140034.GE20303@kernel.org>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
 <1406035081-14301-2-git-send-email-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1406035081-14301-2-git-send-email-adrian.hunter@intel.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 22, 2014 at 04:17:10PM +0300, Adrian Hunter escreveu:
> Intel PT decoding walks the object code to reconstruct
> the trace.  A jump label change during tracing causes
> decoding errors.
> 
> The "Enable close-on-exec flag on perf file descriptor"
> patch caused there to be always a jump label change.
> 
> It was found that using a per-cpu context instead of a
> per-thread context for the probe of the close-on-exec
> feature, made the problem go away.

And it is ok for our purposes, as this code just needs to figure out if
PERF_FLAG_FD_CLOEXEC is present, but I wonder when this kind of thing
will hit again...

Anyway, I'll take this patch.

- Arnaldo
 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  tools/perf/util/cloexec.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
> index c5d05ec..6a37be5 100644
> --- a/tools/perf/util/cloexec.c
> +++ b/tools/perf/util/cloexec.c
> @@ -1,3 +1,4 @@
> +#include <sched.h>
>  #include "util.h"
>  #include "../perf.h"
>  #include "cloexec.h"
> @@ -14,9 +15,13 @@ static int perf_flag_probe(void)
>  	};
>  	int fd;
>  	int err;
> +	int cpu = sched_getcpu();
> +
> +	if (cpu < 0)
> +		cpu = 0;
>  
>  	/* check cloexec flag */
> -	fd = sys_perf_event_open(&attr, 0, -1, -1,
> +	fd = sys_perf_event_open(&attr, -1, cpu, -1,
>  				 PERF_FLAG_FD_CLOEXEC);
>  	err = errno;
>  
> @@ -30,7 +35,7 @@ static int perf_flag_probe(void)
>  		  err, strerror(err));
>  
>  	/* not supported, confirm error related to PERF_FLAG_FD_CLOEXEC */
> -	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
> +	fd = sys_perf_event_open(&attr, -1, cpu, -1, 0);
>  	err = errno;
>  
>  	if (WARN_ONCE(fd < 0,
> -- 
> 1.8.3.2
