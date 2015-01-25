Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897AbbAYNuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 08:50:32 -0500
Received: from mail-pd0-f169.google.com ([209.85.192.169]:40426 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753451AbbAYNu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 08:50:29 -0500
Date: Sun, 25 Jan 2015 22:50:10 +0900
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH 5/5] perf: Make perf aware of tracefs
Message-ID: <20150125135010.GA24454@danjae>
References: <20150124181330.195149364@goodmis.org>
 <20150124181449.157590751@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20150124181449.157590751@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Sat, Jan 24, 2015 at 01:13:35PM -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> As tracefs may be mounted instead of debugfs to get to the event directories,
> have perf know about tracefs, and use that file system over debugfs if it
> is present.
> 
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  const char *find_tracing_dir(void)
>  {
> +	const char *tracing_dir = "";
>  	static char *tracing;
>  	static int tracing_found;
>  	const char *debugfs;
> @@ -351,11 +385,15 @@ const char *find_tracing_dir(void)
>  	if (tracing_found)
>  		return tracing;
>  
> -	debugfs = find_debugfs();
> -	if (!debugfs)
> -		return NULL;
> +	debugfs = find_tracefs();
> +	if (!debugfs) {
> +		tracing_dir = "/tracing";
> +		debugfs = find_debugfs();
> +		if (!debugfs)
> +			return NULL;
> +	}
>  
> -	if (asprintf(&tracing, "%s/tracing", debugfs) < 0)
> +	if (asprintf(&tracing, "%s%s", tracing_dir, debugfs) < 0)

s/tracing_dir, debugfs/debugfs, tracing_dir/

Thanks,
Namhyung


>  		return NULL;
>  
>  	tracing_found = 1;
> diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
> index 027a5153495c..73c2f8e557ab 100644
> --- a/tools/perf/util/util.h
> +++ b/tools/perf/util/util.h
> @@ -75,6 +75,7 @@
>  #include <linux/types.h>
>  #include <sys/ttydefaults.h>
>  #include <api/fs/debugfs.h>
> +#include <api/fs/tracefs.h>
>  #include <termios.h>
>  #include <linux/bitops.h>
>  #include <termios.h>
> -- 
> 2.1.4
> 
> 
