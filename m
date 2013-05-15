Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab3EOO7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:59:32 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979Ab3EOO7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:59:31 -0400
Date: Wed, 15 May 2013 16:59:10 +0200
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
Subject: Re: [PATCH 02/15] perf util: Use evsel->name to get tracepoint_paths
Message-ID: <20130515145910.GA2194@krava.brq.redhat.com>
References: <1368526439-31966-1-git-send-email-namhyung@kernel.org>
 <1368526439-31966-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1368526439-31966-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 07:13:46PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>

SNIP

>  };
>  
>  extern struct tracepoint_path *tracepoint_id_to_path(u64 config);
> +extern struct tracepoint_path *tracepoint_name_to_path(const char *name);
>  extern bool have_tracepoints(struct list_head *evlist);
>  
>  const char *event_type(int type);
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index ab18bf12d54a..bfcaeac7ef9d 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -414,12 +414,23 @@ get_tracepoints_path(struct list_head *pattrs)
>  		if (pos->attr.type != PERF_TYPE_TRACEPOINT)
>  			continue;
>  		++nr_tracepoints;
> +
> +		if (pos->name) {
> +			ppath->next = tracepoint_name_to_path(pos->name);

yep, looks like big time saver ;)

> +			if (!ppath->next)
> +				goto error;

hum, the tracepoint_name_to_path fails also because of the
malformed tracepoint name.. then the error message is
misleading.. but not quite sure this could happen

jirka

> +
> +			goto next;
> +		}
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
