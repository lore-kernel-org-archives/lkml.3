Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3LLSl4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 13:41:56 -0500
Received: from mail-qc0-f169.google.com ([209.85.216.169]:37207 "EHLO
	mail-qc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab3LLSlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 13:41:55 -0500
Date: Thu, 12 Dec 2013 15:41:47 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 13/14] tools lib traceevent: Get rid of die() in some
 string conversion funcitons
Message-ID: <20131212184147.GE8164@ghostprotocols.net>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
 <1386833777-3790-14-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386833777-3790-14-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Dec 12, 2013 at 04:36:16PM +0900, Namhyung Kim escreveu:
> Those functions are for stringify filter arguments.  As caller of
> those functions handles NULL string properly, it seems that it's
> enough to return NULL rather than calling die().
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/parse-filter.c | 58 +++++++++++++++++++++++--------------
>  1 file changed, 36 insertions(+), 22 deletions(-)
> 
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index 9303c55128db..32ab4396653c 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -1361,8 +1361,10 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
>  		if (ret >= 0 && pevent->test_filters) {
>  			char *test;
>  			test = pevent_filter_make_string(filter, event->event->id);
> -			printf(" '%s: %s'\n", event->event->name, test);
> -			free(test);
> +			if (test) {
> +				printf(" '%s: %s'\n", event->event->name, test);
> +				free(test);
> +			}
>  		}
>  	}
>  
> @@ -2097,7 +2099,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
>  				default:
>  					break;
>  				}
> -				str = malloc_or_die(6);
> +				str = malloc(6);
> +				if (str == NULL)
> +					break;
>  				if (val)
>  					strcpy(str, "TRUE");
>  				else
> @@ -2120,7 +2124,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
>  		}
>  
>  		len = strlen(left) + strlen(right) + strlen(op) + 10;
> -		str = malloc_or_die(len);
> +		str = malloc(len);
> +		if (str == NULL)
> +			break;
>  		snprintf(str, len, "(%s) %s (%s)",
>  			 left, op, right);

Why note:

		str = NULL;
		if (asprintf(&str, "(%s) %s (%s)", left, op, right);
			break;

instead?

Ditto for other places here, also there is a typo in the subject line.

I've applied all the previous patches, thanks!

- Arnaldo

>  		break;
> @@ -2138,7 +2144,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
>  			right_val = 0;
>  		if (right_val >= 0) {
>  			/* just return the opposite */
> -			str = malloc_or_die(6);
> +			str = malloc(6);
> +			if (str == NULL)
> +				break;
>  			if (right_val)
>  				strcpy(str, "FALSE");
>  			else
> @@ -2146,8 +2154,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
>  			break;
>  		}
>  		len = strlen(right) + strlen(op) + 3;
> -		str = malloc_or_die(len);
> -		snprintf(str, len, "%s(%s)", op, right);
> +		str = malloc(len);
> +		if (str)
> +			snprintf(str, len, "%s(%s)", op, right);
>  		break;
>  
>  	default:
> @@ -2163,9 +2172,9 @@ static char *val_to_str(struct event_filter *filter, struct filter_arg *arg)
>  {
>  	char *str;
>  
> -	str = malloc_or_die(30);
> -
> -	snprintf(str, 30, "%lld", arg->value.val);
> +	str = malloc(30);
> +	if (str)
> +		snprintf(str, 30, "%lld", arg->value.val);
>  
>  	return str;
>  }
> @@ -2220,12 +2229,14 @@ static char *exp_to_str(struct event_filter *filter, struct filter_arg *arg)
>  		op = "^";
>  		break;
>  	default:
> -		die("oops in exp");
> +		op = "[ERROR IN EXPRESSION TYPE]";
> +		break;
>  	}
>  
>  	len = strlen(op) + strlen(lstr) + strlen(rstr) + 4;
> -	str = malloc_or_die(len);
> -	snprintf(str, len, "%s %s %s", lstr, op, rstr);
> +	str = malloc(len);
> +	if (str)
> +		snprintf(str, len, "%s %s %s", lstr, op, rstr);
>  out:
>  	free(lstr);
>  	free(rstr);
> @@ -2271,9 +2282,9 @@ static char *num_to_str(struct event_filter *filter, struct filter_arg *arg)
>  			op = "<=";
>  
>  		len = strlen(lstr) + strlen(op) + strlen(rstr) + 4;
> -		str = malloc_or_die(len);
> -		sprintf(str, "%s %s %s", lstr, op, rstr);
> -
> +		str = malloc(len);
> +		if (str)
> +			sprintf(str, "%s %s %s", lstr, op, rstr);
>  		break;
>  
>  	default:
> @@ -2311,10 +2322,11 @@ static char *str_to_str(struct event_filter *filter, struct filter_arg *arg)
>  
>  		len = strlen(arg->str.field->name) + strlen(op) +
>  			strlen(arg->str.val) + 6;
> -		str = malloc_or_die(len);
> -		snprintf(str, len, "%s %s \"%s\"",
> -			 arg->str.field->name,
> -			 op, arg->str.val);
> +		str = malloc(len);
> +		if (str) {
> +			snprintf(str, len, "%s %s \"%s\"",
> +				 arg->str.field->name, op, arg->str.val);
> +		}
>  		break;
>  
>  	default:
> @@ -2330,7 +2342,9 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
>  
>  	switch (arg->type) {
>  	case FILTER_ARG_BOOLEAN:
> -		str = malloc_or_die(6);
> +		str = malloc(6);
> +		if (str == NULL)
> +			return NULL;
>  		if (arg->boolean.value)
>  			strcpy(str, "TRUE");
>  		else
> @@ -2369,7 +2383,7 @@ static char *arg_to_str(struct event_filter *filter, struct filter_arg *arg)
>   *
>   * Returns a string that displays the filter contents.
>   *  This string must be freed with free(str).
> - *  NULL is returned if no filter is found.
> + *  NULL is returned if no filter is found or allocation failed.
>   */
>  char *
>  pevent_filter_make_string(struct event_filter *filter, int event_id)
> -- 
> 1.7.11.7
