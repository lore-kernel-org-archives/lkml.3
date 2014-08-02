Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755056AbaHBR6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 13:58:50 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:28636 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754712AbaHBR6s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 13:58:48 -0400
Message-ID: <1407002305.3573.12.camel@dworkin>
Subject: Re: [PATCH] perf tools: Show better error message in case we fail
 to open counters due to EBUSY error
From: Yann Droneaud <ydroneaud@opteya.com>
To: Jiri Olsa <jolsa@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>, ydroneaud@opteya.com
Date: Sat, 02 Aug 2014 19:58:25 +0200
In-Reply-To: <1406908014-8312-1-git-send-email-jolsa@kernel.org>
References: <1406908014-8312-1-git-send-email-jolsa@kernel.org>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

Le vendredi 01 août 2014 à 17:46 +0200, Jiri Olsa a écrit :
> Showing better error message in case we fail to open
> counters due to the EBUSY error. If we detect oprofile
> daemon process running, we now display following message
> for EBUSY error:
> 
>   $ perf record ls
>   Error:
>   The PMU counters are busy/taken by another profiler.
>   We found oprofile daemon running, please stop it and try again.
> 
> In case oprofiled was not detected the current error
> message stays:
> 
>   $ perf record ls
>   Error:
>   The sys_perf_event_open() syscall returned with 16 (Device or resource busy) for event (cycles).
>   /bin/dmesg may provide additional information.
>   No CONFIG_PERF_EVENTS=y kernel support configured?
> 
> Also changing PERF_FLAG_FD_CLOEXEC detection code not to display
> error in case of EBUSY error, as it currently does:
> 
>   $ perf record ls
>   Error:
>   perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error 16 (Device or resource busy)
>   perf_event_open(..., 0) failed unexpectedly with error 16 (Device or resource busy)
>   The PMU counters are busy/taken by another profiler.
>   We found oprofile daemon running, please stop it and try again.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
> Cc: David Ahern <dsahern@gmail.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: William Cohen <wcohen@redhat.com>
> Cc: Yann Droneaud <ydroneaud@opteya.com>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/perf/util/cloexec.c |  4 ++--
>  tools/perf/util/evsel.c   |  6 ++++++
>  tools/perf/util/util.c    | 36 ++++++++++++++++++++++++++++++++++++
>  tools/perf/util/util.h    |  1 +
>  4 files changed, 45 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
> index c5d05ec17220..dede0c388ed4 100644
> --- a/tools/perf/util/cloexec.c
> +++ b/tools/perf/util/cloexec.c
> @@ -25,7 +25,7 @@ static int perf_flag_probe(void)
>  		return 1;
>  	}
>  
> -	WARN_ONCE(err != EINVAL,
> +	WARN_ONCE(err != EINVAL && err != EBUSY,
>  		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
>  		  err, strerror(err));
>  
> @@ -33,7 +33,7 @@ static int perf_flag_probe(void)
>  	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
>  	err = errno;
>  
> -	if (WARN_ONCE(fd < 0,
> +	if (WARN_ONCE(fd < 0 && err != EBUSY,
>  		      "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
>  		      err, strerror(err)))
>  		return -1;

It's definitely possible to shortcut the function if EBUSY is returned
by first call to perf_event_open().

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index dc360ebde745..d5c626d5432a 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -25,6 +25,9 @@ static int perf_flag_probe(void)
 		return 1;
 	}
 
+	if (err == EBUSY)
+		return -1;
+
 	WARN_ONCE(err != EINVAL,
 		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
 		  err, strerror(err));


BTW, I'm going to submit a patch to make the function report such 
warning only once.

Regards.

-- 
Yann Droneaud
OPTEYA


