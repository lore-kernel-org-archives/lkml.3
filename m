Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761007Ab3LIKov (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 05:44:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49779 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab3LIKou (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 05:44:50 -0500
Date: Mon, 9 Dec 2013 11:44:37 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 02/14] tools lib traceevent: Get rid of die in
 add_filter_type()
Message-ID: <20131209104437.GF1242@krava.brq.redhat.com>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
 <1386567251-22751-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386567251-22751-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 09, 2013 at 02:33:59PM +0900, Namhyung Kim wrote:
> The realloc() should check return value and not to overwrite previous
> pointer in case of error.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/parse-filter.c | 21 ++++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)
> 
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index 0fc905c230ad..d9c239933992 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -161,11 +161,13 @@ add_filter_type(struct event_filter *filter, int id)
>  	if (filter_type)
>  		return filter_type;
>  
> -	filter->event_filters =	realloc(filter->event_filters,
> -					sizeof(*filter->event_filters) *
> -					(filter->filters + 1));
> -	if (!filter->event_filters)
> -		die("Could not allocate filter");
> +	filter_type = realloc(filter->event_filters,
> +			      sizeof(*filter->event_filters) *
> +			      (filter->filters + 1));
> +	if (!filter_type)
> +		return NULL;
> +
> +	filter->event_filters = filter_type;
>  
>  	for (i = 0; i < filter->filters; i++) {
>  		if (filter->event_filters[i].event_id > id)
> @@ -1164,6 +1166,12 @@ static int filter_event(struct event_filter *filter,
>  	}
>  
>  	filter_type = add_filter_type(filter, event->id);
> +	if (filter_type == NULL) {
> +		show_error(error_str, "failed to add a new filter: %s",
> +			   filter_str ? filter_str : "true");
> +		return -1;

so your key for using show_error in case of error is if it's
used already in the error path in the function.. right?

jirka

> +	}
> +
>  	if (filter_type->filter)
>  		free_arg(filter_type->filter);
>  	filter_type->filter = arg;
> @@ -1395,6 +1403,9 @@ static int copy_filter_type(struct event_filter *filter,
>  			arg->boolean.value = 0;
>  
>  		filter_type = add_filter_type(filter, event->id);
> +		if (filter_type == NULL)
> +			return -1;
> +
>  		filter_type->filter = arg;
>  
>  		free(str);
> -- 
> 1.7.11.7
> 
