Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933155Ab3EOVVk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 17:21:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932698Ab3EOVVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 17:21:38 -0400
Date: Wed, 15 May 2013 23:21:24 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 03/15] perf util: Save pid-cmdline mapping into tracing
 header
Message-ID: <20130515212124.GC5814@krava.redhat.com>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
 <1368526439-31966-4-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368526439-31966-4-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 07:13:47PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Current trace info data lacks the saved cmdline mapping which is
> needed for pevent to find out the comm of a task.  Add this and bump
> up the version number so that perf can determine its presence when
> reading.
> 
> This is mostly corresponding to trace.dat file version 6, but still
> lacks 4 byte of number of cpus, and 10 bytes of type string - and I
> think we don't need those anyway.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/trace-event-info.c  | 33 ++++++++++++++++++++++++++++++++-
>  tools/perf/util/trace-event-parse.c | 17 +++++++++++++++++
>  tools/perf/util/trace-event-read.c  | 36 ++++++++++++++++++++++++++++++++++--
>  tools/perf/util/trace-event.h       |  1 +
>  4 files changed, 84 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index bfcaeac7ef9d..c0f364273993 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -41,7 +41,7 @@
>  #include <lk/debugfs.h>
>  #include "evsel.h"
>  
> -#define VERSION "0.5"
> +#define VERSION "0.6"
>  
>  static int output_fd;
>  
> @@ -390,6 +390,34 @@ out:
>  	return err;
>  }
>  
> +static int record_saved_cmdline(void)
> +{
> +	unsigned int size;
> +	char *path;
> +	struct stat st;
> +	int ret, err = 0;
> +
> +	path = get_tracing_file("saved_cmdlines");
> +	if (!path) {
> +		pr_debug("can't get tracing/saved_cmdline");
> +		return -ENOMEM;
> +	}
> +
> +	ret = stat(path, &st);
> +	if (ret < 0) {
> +		/* not found */
> +		size = 0;
> +		if (write(output_fd, &size, 8) != 8)
> +			err = -EIO;
> +		goto out;
> +	}
> +	err = record_file(path, 8);
> +
> +out:
> +	put_tracing_file(path);
> +	return err;
> +}
> +
>  static void
>  put_tracepoints_path(struct tracepoint_path *tps)
>  {
> @@ -546,6 +574,9 @@ struct tracing_data *tracing_data_get(struct list_head *pattrs,
>  	if (err)
>  		goto out;
>  	err = record_ftrace_printk();
> +	if (err)
> +		goto out;
> +	err = record_saved_cmdline();
>  
>  out:
>  	/*
> diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
> index fe7a27d67d2b..ef09e4720e04 100644
> --- a/tools/perf/util/trace-event-parse.c
> +++ b/tools/perf/util/trace-event-parse.c
> @@ -232,6 +232,23 @@ void parse_ftrace_printk(struct pevent *pevent,
>  	}
>  }
>  
> +void parse_saved_cmdline(struct pevent *pevent,
> +			 char *file, unsigned int size __maybe_unused)

any reason for the size parameter? I can see some other
functions already following this prototype, but I dont
see the reason.. just curious ;)

void parse_ftrace_printk(struct pevent *pevent,
                         char *file, unsigned int size __maybe_unused)

void parse_proc_kallsyms(struct pevent *pevent,
                         char *file, unsigned int size __maybe_unused)


jirka
