Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933875Ab3LIQTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:19:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:15623 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932812Ab3LIQTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:19:38 -0500
Date: Mon, 9 Dec 2013 11:19:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 13/14] tools lib traceevent: Refactor test_filter() to
 get rid of die()
Message-ID: <20131209111936.71a448c5@gandalf.local.home>
In-Reply-To: <1386567251-22751-14-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-14-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Dec 2013 14:34:10 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> The test_filter() function is for testing given filter is matched to a
> given record.  However it doesn't handle error cases properly so add a
> new argument error_str to save error info during the test and also
> pass it to internal test functions.
> 
> For now, it just save the error but does nothing with it.  Maybe it
> can be given by user through pevent_filter_match() later.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/event-parse.h  |   1 +
>  tools/lib/traceevent/parse-filter.c | 102 ++++++++++++++++++++++--------------
>  2 files changed, 65 insertions(+), 38 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 6e23f197175f..a1d8b2792e3a 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -836,6 +836,7 @@ struct event_filter {
>  
>  struct event_filter *pevent_filter_alloc(struct pevent *pevent);
>  
> +#define FILTER_ERROR		-3
>  #define FILTER_NONE		-2
>  #define FILTER_NOEXIST		-1
>  #define FILTER_MISS		0
> diff --git a/tools/lib/traceevent/parse-filter.c b/tools/lib/traceevent/parse-filter.c
> index 4d395e8b88bb..8a5b7a74b44e 100644
> --- a/tools/lib/traceevent/parse-filter.c
> +++ b/tools/lib/traceevent/parse-filter.c
> @@ -1698,8 +1698,8 @@ int pevent_filter_event_has_trivial(struct event_filter *filter,
>  	}
>  }
>  
> -static int test_filter(struct event_format *event,
> -		       struct filter_arg *arg, struct pevent_record *record);
> +static int test_filter(struct event_format *event, struct filter_arg *arg,
> +		       struct pevent_record *record, char **error_str);
>  
>  static const char *
>  get_comm(struct event_format *event, struct pevent_record *record)
> @@ -1745,15 +1745,17 @@ get_value(struct event_format *event,
>  }
>  
>  static unsigned long long
> -get_arg_value(struct event_format *event, struct filter_arg *arg, struct pevent_record *record);
> +get_arg_value(struct event_format *event, struct filter_arg *arg,
> +	      struct pevent_record *record, char **error_str);
>  
>  static unsigned long long
> -get_exp_value(struct event_format *event, struct filter_arg *arg, struct pevent_record *record)
> +get_exp_value(struct event_format *event, struct filter_arg *arg,
> +	      struct pevent_record *record, char **error_str)
>  {
>  	unsigned long long lval, rval;
>  
> -	lval = get_arg_value(event, arg->exp.left, record);
> -	rval = get_arg_value(event, arg->exp.right, record);
> +	lval = get_arg_value(event, arg->exp.left, record, error_str);
> +	rval = get_arg_value(event, arg->exp.right, record, error_str);
>  
>  	switch (arg->exp.type) {
>  	case FILTER_EXP_ADD:
> @@ -1788,39 +1790,44 @@ get_exp_value(struct event_format *event, struct filter_arg *arg, struct pevent_
>  
>  	case FILTER_EXP_NOT:
>  	default:
> -		die("error in exp");
> +		if (*error_str == NULL)
> +			*error_str = "invalid expression type";

Hmm, how do we tell the caller that there was an error? Do they just
check to see if error_str was changed?

>  	}
>  	return 0;
>  }
>  
>  static unsigned long long
> -get_arg_value(struct event_format *event, struct filter_arg *arg, struct pevent_record *record)
> +get_arg_value(struct event_format *event, struct filter_arg *arg,
> +	      struct pevent_record *record, char **error_str)
>  {
>  	switch (arg->type) {
>  	case FILTER_ARG_FIELD:
>  		return get_value(event, arg->field.field, record);
>  
>  	case FILTER_ARG_VALUE:
> -		if (arg->value.type != FILTER_NUMBER)
> -			die("must have number field!");
> +		if (arg->value.type != FILTER_NUMBER) {
> +			if (*error_str == NULL)
> +				*error_str = "must have number field!";
> +		}
>  		return arg->value.val;
>  
>  	case FILTER_ARG_EXP:
> -		return get_exp_value(event, arg, record);
> +		return get_exp_value(event, arg, record, error_str);
>  
>  	default:
> -		die("oops in filter");
> +		if (*error_str == NULL)
> +			*error_str = "invalid numeric argument type";
>  	}
>  	return 0;
>  }
>  
> -static int test_num(struct event_format *event,
> -		    struct filter_arg *arg, struct pevent_record *record)
> +static int test_num(struct event_format *event, struct filter_arg *arg,
> +		    struct pevent_record *record, char **error_str)
>  {
>  	unsigned long long lval, rval;
>  
> -	lval = get_arg_value(event, arg->num.left, record);
> -	rval = get_arg_value(event, arg->num.right, record);
> +	lval = get_arg_value(event, arg->num.left, record, error_str);
> +	rval = get_arg_value(event, arg->num.right, record, error_str);
>  
>  	switch (arg->num.type) {
>  	case FILTER_CMP_EQ:
> @@ -1842,7 +1849,8 @@ static int test_num(struct event_format *event,
>  		return lval <= rval;
>  
>  	default:
> -		/* ?? */
> +		if (*error_str == NULL)
> +			*error_str = "invalid numeric comparison type";
>  		return 0;
>  	}
>  }
> @@ -1889,8 +1897,8 @@ static const char *get_field_str(struct filter_arg *arg, struct pevent_record *r
>  	return val;
>  }
>  
> -static int test_str(struct event_format *event,
> -		    struct filter_arg *arg, struct pevent_record *record)
> +static int test_str(struct event_format *event, struct filter_arg *arg,
> +		    struct pevent_record *record, char **error_str)
>  {
>  	const char *val;
>  
> @@ -1914,48 +1922,57 @@ static int test_str(struct event_format *event,
>  		return regexec(&arg->str.reg, val, 0, NULL, 0);
>  
>  	default:
> -		/* ?? */
> +		if (*error_str == NULL)
> +			*error_str = "invalid string comparison type";
>  		return 0;
>  	}
>  }
>  
> -static int test_op(struct event_format *event,
> -		   struct filter_arg *arg, struct pevent_record *record)
> +static int test_op(struct event_format *event, struct filter_arg *arg,
> +		   struct pevent_record *record, char **error_str)
>  {
>  	switch (arg->op.type) {
>  	case FILTER_OP_AND:
> -		return test_filter(event, arg->op.left, record) &&
> -			test_filter(event, arg->op.right, record);
> +		return test_filter(event, arg->op.left, record, error_str) &&
> +			test_filter(event, arg->op.right, record, error_str);
>  
>  	case FILTER_OP_OR:
> -		return test_filter(event, arg->op.left, record) ||
> -			test_filter(event, arg->op.right, record);
> +		return test_filter(event, arg->op.left, record, error_str) ||
> +			test_filter(event, arg->op.right, record, error_str);
>  
>  	case FILTER_OP_NOT:
> -		return !test_filter(event, arg->op.right, record);
> +		return !test_filter(event, arg->op.right, record, error_str);
>  
>  	default:
> -		/* ?? */
> +		if (*error_str == NULL)
> +			*error_str = "invalid operator type";
>  		return 0;
>  	}
>  }
>  
> -static int test_filter(struct event_format *event,
> -		       struct filter_arg *arg, struct pevent_record *record)
> +static int test_filter(struct event_format *event, struct filter_arg *arg,
> +		       struct pevent_record *record, char **error_str)
>  {
> +	if (*error_str) {
> +		/*
> +		 * There was an error, no need to process anymore.
> +		 */
> +		return 0;
> +	}
> +
>  	switch (arg->type) {
>  	case FILTER_ARG_BOOLEAN:
>  		/* easy case */
>  		return arg->boolean.value;
>  
>  	case FILTER_ARG_OP:
> -		return test_op(event, arg, record);
> +		return test_op(event, arg, record, error_str);
>  
>  	case FILTER_ARG_NUM:
> -		return test_num(event, arg, record);
> +		return test_num(event, arg, record, error_str);
>  
>  	case FILTER_ARG_STR:
> -		return test_str(event, arg, record);
> +		return test_str(event, arg, record, error_str);
>  
>  	case FILTER_ARG_EXP:
>  	case FILTER_ARG_VALUE:
> @@ -1964,11 +1981,11 @@ static int test_filter(struct event_format *event,
>  		 * Expressions, fields and values evaluate
>  		 * to true if they return non zero
>  		 */
> -		return !!get_arg_value(event, arg, record);
> +		return !!get_arg_value(event, arg, record, error_str);
>  
>  	default:
> -		die("oops!");
> -		/* ?? */
> +		if (*error_str == NULL)
> +			*error_str = "invalid argument type";
>  		return 0;
>  	}
>  }
> @@ -2004,6 +2021,7 @@ int pevent_event_filtered(struct event_filter *filter,
>   *  0 - filter found for event and @record does not match
>   * -1 - no filter found for @record's event
>   * -2 - if no filters exist
> + * -3 - if error occurred during test
>   */
>  int pevent_filter_match(struct event_filter *filter,
>  			struct pevent_record *record)
> @@ -2011,6 +2029,8 @@ int pevent_filter_match(struct event_filter *filter,
>  	struct pevent *pevent = filter->pevent;
>  	struct filter_type *filter_type;
>  	int event_id;
> +	char *error_str = NULL;
> +	int ret;
>  
>  	if (!filter->filters)
>  		return FILTER_NONE;
> @@ -2022,8 +2042,14 @@ int pevent_filter_match(struct event_filter *filter,
>  	if (!filter_type)
>  		return FILTER_NOEXIST;
>  
> -	return test_filter(filter_type->event, filter_type->filter, record) ?
> -		FILTER_MATCH : FILTER_MISS;
> +	ret = test_filter(filter_type->event, filter_type->filter, record,
> +			  &error_str);
> +	if (error_str) {
> +		/* TODO: maybe we can print it or pass back to user */

Ah, I guess this answers my question :-)

Maybe we can save the error_str in the pevent. Then we can extract it
later. The return of FILTER_ERROR will let the user see what happened.

-- Steve

> +		return FILTER_ERROR;
> +	}
> +
> +	return ret ? FILTER_MATCH : FILTER_MISS;
>  }
>  
>  static char *op_to_str(struct event_filter *filter, struct filter_arg *arg)

