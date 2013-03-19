Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755300Ab3CSNyY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 09:54:24 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:26750 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab3CSNyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 09:54:23 -0400
X-Authority-Analysis: v=2.0 cv=adbjbGUt c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=kwgYj85l3bcA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=jvOD-YUo0CAA:10 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=zb3LsNbOG7oyTudw7R8A:9 a=QEXdDO2ut3YA:10 a=TIV7c6GJmisA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1363701261.5938.18.camel@gandalf.local.home>
Subject: Re: [PATCH 1/9] perf util: Let get_tracing_file() can return NULL
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Tue, 19 Mar 2013 09:54:21 -0400
In-Reply-To: <1363683224-28804-2-git-send-email-namhyung@kernel.org>
References: <1363683224-28804-1-git-send-email-namhyung@kernel.org>
	 <1363683224-28804-2-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-19 at 17:53 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> So that it can be used by other places.
> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/trace-event-info.c | 25 ++++++++++++++++++++++---
>  1 file changed, 22 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index 5729f434c5b1..f241343b7d48 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -62,7 +62,7 @@ static const char *find_debugfs(void)
>  	const char *path = perf_debugfs_mount(NULL);
>  
>  	if (!path)
> -		die("Your kernel not support debugfs filesystem");
> +		pr_err("Your kernel not support debugfs filesystem");

"Your kernel does not support the debugfs filesystem"

I know you just did a s/die/pr_err/ but might as well fix the grammar
too ;-)

>  
>  	return path;
>  }
> @@ -81,8 +81,12 @@ static const char *find_tracing_dir(void)
>  		return tracing;
>  
>  	debugfs = find_debugfs();
> +	if (!debugfs)
> +		return NULL;
>  
> -	tracing = malloc_or_die(strlen(debugfs) + 9);
> +	tracing = malloc(strlen(debugfs) + 9);
> +	if (!tracing)
> +		return NULL;
>  
>  	sprintf(tracing, "%s/tracing", debugfs);
>  
> @@ -99,7 +103,9 @@ static char *get_tracing_file(const char *name)
>  	if (!tracing)
>  		return NULL;
>  
> -	file = malloc_or_die(strlen(tracing) + strlen(name) + 2);
> +	file = malloc(strlen(tracing) + strlen(name) + 2);
> +	if (!file)
> +		return NULL;

Should have clean up as well. That is, if file fails, we need to free
tracing. Otherwise there's a memory leak.

>  
>  	sprintf(file, "%s/%s", tracing, name);
>  	return file;
> @@ -170,6 +176,9 @@ static void read_header_files(void)
>  	struct stat st;
>  
>  	path = get_tracing_file("events/header_page");
> +	if (!path)
> +		die("can't get tracing/events/header_page");
> +
>  	if (stat(path, &st) < 0)
>  		die("can't read '%s'", path);
>  
> @@ -178,6 +187,9 @@ static void read_header_files(void)
>  	put_tracing_file(path);
>  
>  	path = get_tracing_file("events/header_event");
> +	if (!path)
> +		die("can't get tracing/events/header_event");
> +
>  	if (stat(path, &st) < 0)
>  		die("can't read '%s'", path);
>  
> @@ -251,6 +263,8 @@ static void read_ftrace_files(struct tracepoint_path *tps)
>  	char *path;
>  
>  	path = get_tracing_file("events/ftrace");
> +	if (!path)
> +		die("can't get tracing/events/ftrace");
>  
>  	copy_event_system(path, tps);
>  
> @@ -279,6 +293,8 @@ static void read_event_files(struct tracepoint_path *tps)
>  	int ret;
>  
>  	path = get_tracing_file("events");
> +	if (!path)
> +		die("can't get tracing/events");
>  
>  	dir = opendir(path);
>  	if (!dir)
> @@ -343,6 +359,9 @@ static void read_ftrace_printk(void)
>  	int ret;
>  
>  	path = get_tracing_file("printk_formats");
> +	if (!path)
> +		die("can't get tracing/printk_formats");
> +

OK, so we are just moving die to the caller? I'm fine with that. If we
can get the utilities to remove die, that's a big step.

-- Steve

>  	ret = stat(path, &st);
>  	if (ret < 0) {
>  		/* not found */


