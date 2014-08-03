Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752398AbaHCMMX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Aug 2014 08:12:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44999 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaHCMMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Aug 2014 08:12:22 -0400
Date: Sun, 3 Aug 2014 14:10:36 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Yann Droneaud <ydroneaud@opteya.com>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        William Cohen <wcohen@redhat.com>
Subject: [PATCH] perf tools: Fix PERF_FLAG_FD_CLOEXEC flag probing event type
 open counters due to EBUSY error
Message-ID: <20140803121036.GA1181@krava.brq.redhat.com>
References: <1406908014-8312-1-git-send-email-jolsa@kernel.org>
 <1407002305.3573.12.camel@dworkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407002305.3573.12.camel@dworkin>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 02, 2014 at 07:58:25PM +0200, Yann Droneaud wrote:
> Hi Jiri,

SNIP

> >  	err = errno;
> >  
> > -	if (WARN_ONCE(fd < 0,
> > +	if (WARN_ONCE(fd < 0 && err != EBUSY,
> >  		      "perf_event_open(..., 0) failed unexpectedly with error %d (%s)\n",
> >  		      err, strerror(err)))
> >  		return -1;
> 
> It's definitely possible to shortcut the function if EBUSY is returned
> by first call to perf_event_open().
> 
> diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
> index dc360ebde745..d5c626d5432a 100644
> --- a/tools/perf/util/cloexec.c
> +++ b/tools/perf/util/cloexec.c
> @@ -25,6 +25,9 @@ static int perf_flag_probe(void)
>  		return 1;
>  	}
>  
> +	if (err == EBUSY)
> +		return -1;
> +
>  	WARN_ONCE(err != EINVAL,
>  		  "perf_event_open(..., PERF_FLAG_FD_CLOEXEC) failed with unexpected error %d (%s)\n",
>  		  err, strerror(err));

heh, I haven't realized that your probing event was
PERF_COUNT_SW_CPU_CLOCK, which could never be busy
and found following bug ;-)

jirka


---
We were using PERF_COUNT_SW_CPU_CLOCK as an probing event type.
Using expected PERF_TYPE_SOFTWARE type instead.

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: William Cohen <wcohen@redhat.com>
Cc: Yann Droneaud <ydroneaud@opteya.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/cloexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/cloexec.c b/tools/perf/util/cloexec.c
index dc360ebde745..0f7eb0a53d4b 100644
--- a/tools/perf/util/cloexec.c
+++ b/tools/perf/util/cloexec.c
@@ -9,7 +9,7 @@ static int perf_flag_probe(void)
 {
 	/* use 'safest' configuration as used in perf_evsel__fallback() */
 	struct perf_event_attr attr = {
-		.type = PERF_COUNT_SW_CPU_CLOCK,
+		.type = PERF_TYPE_SOFTWARE,
 		.config = PERF_COUNT_SW_CPU_CLOCK,
 	};
 	int fd;
-- 
1.8.3.1

