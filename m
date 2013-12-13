Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab3LMOwM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 09:52:12 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:39196 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab3LMOwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 09:52:11 -0500
Date: Fri, 13 Dec 2013 11:52:04 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 13/14] tools lib traceevent: Get rid of die() in some
 string conversion funcitons
Message-ID: <20131213145204.GC29275@ghostprotocols.net>
References: <1386833777-3790-1-git-send-email-namhyung@kernel.org>
 <1386833777-3790-14-git-send-email-namhyung@kernel.org>
 <20131212184147.GE8164@ghostprotocols.net>
 <87y53phah9.fsf@sejong.aot.lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y53phah9.fsf@sejong.aot.lge.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, Dec 13, 2013 at 09:15:46AM +0900, Namhyung Kim escreveu:
> Hi Arnaldo,
> 
> On Thu, 12 Dec 2013 15:41:47 -0300, Arnaldo Carvalho de Melo wrote:
> > Em Thu, Dec 12, 2013 at 04:36:16PM +0900, Namhyung Kim escreveu:
> >> Those functions are for stringify filter arguments.  As caller of
> >> those functions handles NULL string properly, it seems that it's
> >> enough to return NULL rather than calling die().
> >> 
> >> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> >> ---
> >>  tools/lib/traceevent/parse-filter.c | 58 +++++++++++++++++++++++--------------
> >>  1 file changed, 36 insertions(+), 22 deletions(-)
> >> 
> >> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> >> index 9303c55128db..32ab4396653c 100644
> >> --- a/tools/lib/traceevent/parse-filter.c
> >> +++ b/tools/lib/traceevent/parse-filter.c
> >> @@ -1361,8 +1361,10 @@ enum pevent_errno pevent_filter_add_filter_str(struct event_filter *filter,
> >>  		if (ret >= 0 && pevent->test_filters) {
> >>  			char *test;
> >>  			test = pevent_filter_make_string(filter, event->event->id);
> >> -			printf(" '%s: %s'\n", event->event->name, test);
> >> -			free(test);
> >> +			if (test) {
> >> +				printf(" '%s: %s'\n", event->event->name, test);
> >> +				free(test);
> >> +			}
> >>  		}
> >>  	}
> >>  
> >> @@ -2097,7 +2099,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
> >>  				default:
> >>  					break;
> >>  				}
> >> -				str = malloc_or_die(6);
> >> +				str = malloc(6);
> >> +				if (str == NULL)
> >> +					break;
> >>  				if (val)
> >>  					strcpy(str, "TRUE");
> >>  				else
> >> @@ -2120,7 +2124,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
> >>  		}
> >>  
> >>  		len = strlen(left) + strlen(right) + strlen(op) + 10;
> >> -		str = malloc_or_die(len);
> >> +		str = malloc(len);
> >> +		if (str == NULL)
> >> +			break;
> >>  		snprintf(str, len, "(%s) %s (%s)",
> >>  			 left, op, right);
> >
> > Why note:
> >
> > 		str = NULL;
> > 		if (asprintf(&str, "(%s) %s (%s)", left, op, right);
> > 			break;
> >
> > instead?
> >
> > Ditto for other places here, also there is a typo in the subject line.
> >
> > I've applied all the previous patches, thanks!
> 
> Thank you very much!
> 
> Here is the updated patch:

Thanks! There are some more questions below:
 
> 
> From d775295fb53930b1e3d946e145e9a6172773d4f5 Mon Sep 17 00:00:00 2001
> From: Namhyung Kim <namhyung@kernel.org>
> Date: Sat, 7 Dec 2013 15:13:35 +0000
> Subject: [PATCH v2.1 13/14] tools lib traceevent: Get rid of die() in some string
>  conversion functions
> 
> Those functions are for stringify filter arguments.  As caller of
> those functions handles NULL string properly, it seems that it's
> enough to return NULL rather than calling die().
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/parse-filter.c | 59 +++++++++++++++----------------------
>  1 file changed, 24 insertions(+), 35 deletions(-)
> 
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index 9303c55128db..72fe16562546 100644
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
> @@ -2050,7 +2052,6 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
>  	int left_val = -1;
>  	int right_val = -1;
>  	int val;
> -	int len;
>  
>  	switch (arg->op.type) {
>  	case FILTER_OP_AND:
> @@ -2097,7 +2098,9 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
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

The malloc here can be combined with the strcpy, and the else clause
gets immediately after:

				if (asprintf(&str, "%s", "TRUE") < 0)

> @@ -2119,10 +2122,7 @@ static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)
>  			break;
>  		}
>  
> -		len = strlen(left) + strlen(right) + strlen(op) + 10;
> -		str = malloc_or_die(len);
> -		snprintf(str, len, "(%s) %s (%s)",
> -			 left, op, right);
> +		asprintf(&str, "(%s) %s (%s)", left, op, right);
>  		break;

I was unsure if str was NULL, it is already, at decl site, good :)

All the rest is ok, so its just the malloc + strcpy that remains to be
converted, do you want me to do it?

- Arnaldo
