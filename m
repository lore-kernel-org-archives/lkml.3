Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758555Ab3DXMnT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 08:43:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab3DXMnS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 08:43:18 -0400
Date: Wed, 24 Apr 2013 14:42:57 +0200
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
Subject: Re: [PATCH 02/14] perf util: Use evsel->name to get tracepoint_paths
Message-ID: <20130424124257.GE971@krava.brq.redhat.com>
References: <1366705872-12132-1-git-send-email-namhyung@kernel.org>
 <1366705872-12132-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366705872-12132-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 05:31:00PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Most tracepoint events already have their system and event name in
> ->name field so that searching whole event tracing directory for each
> evsel to match given id is suboptimal.
> 
> Cc: Jiri Olsa <jolsa@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/trace-event-info.c | 19 +++++++++++++++++++
>  1 file changed, 19 insertions(+)
> 
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index ab18bf12d54a..dcfc1869c9af 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -414,12 +414,31 @@ get_tracepoints_path(struct list_head *pattrs)
>  		if (pos->attr.type != PERF_TYPE_TRACEPOINT)
>  			continue;
>  		++nr_tracepoints;
> +
> +		if (pos->name && strchr(pos->name, ':')) {
> +			char *str = strchr(pos->name, ':');
> +
> +			ppath->next = zalloc(sizeof(path));
> +			if (!ppath->next)
> +				goto error;
> +
> +			ppath->next->system = strndup(pos->name, str - pos->name);
> +			ppath->next->name = strdup(str+1);
> +
> +			if (!ppath->next->system || !ppath->next->name)
> +				goto error;
> +
> +			goto next;
> +		}

good idea, could you please move this ^^^ into function ?
something like 'tracepoint_name_to_path'

jirka

> +
>  		ppath->next = tracepoint_id_to_path(pos->attr.config);
>  		if (!ppath->next) {
> +error:
>  			pr_debug("No memory to alloc tracepoints list\n");
>  			put_tracepoints_path(&path);
>  			return NULL;
>  		}
> +next:
>  		ppath = ppath->next;
>  	}
>  
> -- 
> 1.7.11.7
> 
