Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109AbaFCSzb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 14:55:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752241AbaFCSz3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 14:55:29 -0400
Date: Tue, 3 Jun 2014 20:55:05 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] perf script/python: Print array argument as string
Message-ID: <20140603185505.GB4213@krava.brq.redhat.com>
References: <1401207274-8170-2-git-send-email-bigeasy@linutronix.de>
 <1401338695-18837-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401338695-18837-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 01:44:55PM +0900, Namhyung Kim wrote:
> With the Sebastian's change of handling num array argument (of raw
> syscall enter), the script still failed to work like this:
> 
>   $ perf record -e raw_syscalls:* sleep 1
>   $ perf script -g python
>   $ perf script -s perf-script.py
>   ...
>   Traceback (most recent call last):
>     File "perf-script.py", line 42, in raw_syscalls__sys_enter
>       (id, args),
>   TypeError: %u format: a number is required, not list
>   Fatal Python error: problem in Python trace event handler
>   Aborted (core dumped)
> 
> This is because the generated script tries to print the array arg as
> unsigned integer (%u).  Since the python seems to convert arguments to
> strings by default, just using %s solved the problem for me.
> 
> Cc: Tom Zanussi <tzanussi@gmail.com>
> Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>

ack/test anyone? ;-)

thanks,
jirka

> ---
>  tools/perf/util/scripting-engines/trace-event-python.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/tools/perf/util/scripting-engines/trace-event-python.c b/tools/perf/util/scripting-engines/trace-event-python.c
> index 40a815a5360b..a22ab53788bf 100644
> --- a/tools/perf/util/scripting-engines/trace-event-python.c
> +++ b/tools/perf/util/scripting-engines/trace-event-python.c
> @@ -649,6 +649,7 @@ static int python_generate_script(struct pevent *pevent, const char *outfile)
>  			fprintf(ofp, "%s=", f->name);
>  			if (f->flags & FIELD_IS_STRING ||
>  			    f->flags & FIELD_IS_FLAG ||
> +			    f->flags & FIELD_IS_ARRAY ||
>  			    f->flags & FIELD_IS_SYMBOLIC)
>  				fprintf(ofp, "%%s");
>  			else if (f->flags & FIELD_IS_SIGNED)
> -- 
> 1.9.2
> 
