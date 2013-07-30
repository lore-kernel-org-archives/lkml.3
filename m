Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab3G3Ndy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 09:33:54 -0400
Received: from mail-qa0-f51.google.com ([209.85.216.51]:42145 "EHLO
	mail-qa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753572Ab3G3Ndw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 09:33:52 -0400
Date: Tue, 30 Jul 2013 10:33:42 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>,
        Jeremy Eder <jeder@redhat.com>
Subject: Re: [PATCH 02/17] perf util: Add more debug message on failure path
Message-ID: <20130730133342.GB2607@ghostprotocols.net>
References: <1375175954-798-1-git-send-email-namhyung@kernel.org>
 <1375175954-798-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375175954-798-3-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jul 30, 2013 at 06:18:59PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> It's helpful for debugging on tracing features.

I wonder if we shouldn't start using 'perf probe to insert those
things... Having some shell script with a series of probe insertions...
What do you think? At least we would be eating our own dog food 8-)

Or at least have something that shows the source file name and line
number, so that things like:

 static int read_event_file(struct pevent *pevent, char *sys,
 			    unsigned long long size)
 {
+	int ret;
 	char *buf;
 
 	buf = malloc(size);
-	if (buf == NULL)
+	if (buf == NULL) {
+		pr_debug("memory allocation failure\n");
 		return -1;
+	}

actually help us 8-)

- Arnaldo
 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/header.c           |  4 ++-
>  tools/perf/util/trace-event-read.c | 53 ++++++++++++++++++++++++++------------
>  2 files changed, 39 insertions(+), 18 deletions(-)
> 
> diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
> index f558f83769af..11b08f24ba42 100644
> --- a/tools/perf/util/header.c
> +++ b/tools/perf/util/header.c
> @@ -2700,8 +2700,10 @@ static int perf_evsel__prepare_tracepoint_event(struct perf_evsel *evsel,
>  	}
>  
>  	event = pevent_find_event(pevent, evsel->attr.config);
> -	if (event == NULL)
> +	if (event == NULL) {
> +		pr_debug("cannot find event format for %d\n", (int)evsel->attr.config);
>  		return -1;
> +	}
>  
>  	if (!evsel->name) {
>  		snprintf(bf, sizeof(bf), "%s:%s", event->system, event->name);
> diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
> index e084e5e654b6..0e3b3f527320 100644
> --- a/tools/perf/util/trace-event-read.c
> +++ b/tools/perf/util/trace-event-read.c
> @@ -262,39 +262,53 @@ static int read_header_files(struct pevent *pevent)
>  
>  static int read_ftrace_file(struct pevent *pevent, unsigned long long size)
>  {
> +	int ret;
>  	char *buf;
>  
>  	buf = malloc(size);
> -	if (buf == NULL)
> +	if (buf == NULL) {
> +		pr_debug("memory allocation failure\n");
>  		return -1;
> +	}
>  
> -	if (do_read(buf, size) < 0) {
> -		free(buf);
> -		return -1;
> +	ret = do_read(buf, size);
> +	if (ret < 0) {
> +		pr_debug("error reading ftrace file.\n");
> +		goto out;
>  	}
>  
> -	parse_ftrace_file(pevent, buf, size);
> +	ret = parse_ftrace_file(pevent, buf, size);
> +	if (ret < 0)
> +		pr_debug("error parsing ftrace file.\n");
> +out:
>  	free(buf);
> -	return 0;
> +	return ret;
>  }
>  
>  static int read_event_file(struct pevent *pevent, char *sys,
>  			    unsigned long long size)
>  {
> +	int ret;
>  	char *buf;
>  
>  	buf = malloc(size);
> -	if (buf == NULL)
> +	if (buf == NULL) {
> +		pr_debug("memory allocation failure\n");
>  		return -1;
> +	}
>  
> -	if (do_read(buf, size) < 0) {
> +	ret = do_read(buf, size);
> +	if (ret < 0) {
>  		free(buf);
> -		return -1;
> +		goto out;
>  	}
>  
> -	parse_event_file(pevent, buf, size, sys);
> +	ret = parse_event_file(pevent, buf, size, sys);
> +	if (ret < 0)
> +		pr_debug("error parsing event file.\n");
> +out:
>  	free(buf);
> -	return 0;
> +	return ret;
>  }
>  
>  static int read_ftrace_files(struct pevent *pevent)
> @@ -347,6 +361,7 @@ static int read_saved_cmdline(struct pevent *pevent)
>  {
>  	unsigned long long size;
>  	char *buf;
> +	int ret;
>  
>  	/* it can have 0 size */
>  	size = read8(pevent);
> @@ -354,18 +369,22 @@ static int read_saved_cmdline(struct pevent *pevent)
>  		return 0;
>  
>  	buf = malloc(size + 1);
> -	if (buf == NULL)
> +	if (buf == NULL) {
> +		pr_debug("memory allocation failure\n");
>  		return -1;
> +	}
>  
> -	if (do_read(buf, size) < 0) {
> -		free(buf);
> -		return -1;
> +	ret = do_read(buf, size);
> +	if (ret < 0) {
> +		pr_debug("error reading saved cmdlines\n");
> +		goto out;
>  	}
>  
>  	parse_saved_cmdline(pevent, buf, size);
> -
> +	ret = 0;
> +out:
>  	free(buf);
> -	return 0;
> +	return ret;
>  }
>  
>  ssize_t trace_report(int fd, struct pevent **ppevent, bool __repipe)
> -- 
> 1.7.11.7
