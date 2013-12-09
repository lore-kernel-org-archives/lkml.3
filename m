Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933807Ab3LIQFY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 11:05:24 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:21695 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932609Ab3LIQFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 11:05:21 -0500
Date: Mon, 9 Dec 2013 11:05:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 04/14] tools lib traceevent: Get rid of malloc_or_die()
 allocate_arg()
Message-ID: <20131209110519.7e9fd95c@gandalf.local.home>
In-Reply-To: <1386567251-22751-5-git-send-email-namhyung@kernel.org>
References: <1386567251-22751-1-git-send-email-namhyung@kernel.org>
	<1386567251-22751-5-git-send-email-namhyung@kernel.org>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  9 Dec 2013 14:34:01 +0900
Namhyung Kim <namhyung@kernel.org> wrote:

> @@ -409,8 +408,10 @@ create_arg_op(enum filter_op_type btype)
>  	struct filter_arg *arg;
>  
>  	arg = allocate_arg();
> -	arg->type = FILTER_ARG_OP;
> -	arg->op.type = btype;
> +	if (arg) {
> +		arg->type = FILTER_ARG_OP;
> +		arg->op.type = btype;
> +	}
>  
>  	return arg;
>  }
> @@ -421,8 +422,10 @@ create_arg_exp(enum filter_exp_type etype)
>  	struct filter_arg *arg;
>  
>  	arg = allocate_arg();
> -	arg->type = FILTER_ARG_EXP;
> -	arg->op.type = etype;
> +	if (arg) {
> +		arg->type = FILTER_ARG_EXP;
> +		arg->op.type = etype;
> +	}
>  
>  	return arg;
>  }
> @@ -433,9 +436,11 @@ create_arg_cmp(enum filter_exp_type etype)
>  	struct filter_arg *arg;
>  
>  	arg = allocate_arg();
> -	/* Use NUM and change if necessary */
> -	arg->type = FILTER_ARG_NUM;
> -	arg->op.type = etype;
> +	if (arg) {
> +		/* Use NUM and change if necessary */
> +		arg->type = FILTER_ARG_NUM;
> +		arg->op.type = etype;
> +	}
>  
>  	return arg;
>  }
> @@ -896,8 +901,10 @@ static struct filter_arg *collapse_tree(struct filter_arg *arg)
>  	case FILTER_VAL_FALSE:
>  		free_arg(arg);
>  		arg = allocate_arg();
> -		arg->type = FILTER_ARG_BOOLEAN;
> -		arg->boolean.value = ret == FILTER_VAL_TRUE;
> +		if (arg) {
> +			arg->type = FILTER_ARG_BOOLEAN;
> +			arg->boolean.value = ret == FILTER_VAL_TRUE;
> +		}

Just a nit, but I wonder if all these would look nicer if we just did:

	arg = allocate_arg();
	if (!arg)
		return NULL;
	[...]

Instead of doing the work within an if statement.

Also, I prefer if (!arg) over if (arg == NULL), but I'm not going to
fight over that ;-)

-- Steve

>  	}
>  
>  	return arg;
> @@ -1044,6 +1051,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
>  			switch (op_type) {
>  			case OP_BOOL:
>  				arg = create_arg_op(btype);
> +				if (arg == NULL)
> +					goto fail_alloc;
>  				if (current_op)
>  					ret = add_left(arg, current_op);
>  				else
> @@ -1054,6 +1063,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
>  
>  			case OP_NOT:
>  				arg = create_arg_op(btype);
> +				if (arg == NULL)
> +					goto fail_alloc;
>  				if (current_op)
>  					ret = add_right(current_op, arg, error_str);
>  				if (ret < 0)
> @@ -1073,6 +1084,8 @@ process_filter(struct event_format *event, struct filter_arg **parg,
>  					arg = create_arg_exp(etype);
>  				else
>  					arg = create_arg_cmp(ctype);
> +				if (arg == NULL)
> +					goto fail_alloc;
>  
>  				if (current_op)
>  					ret = add_right(current_op, arg, error_str);
> @@ -1106,11 +1119,16 @@ process_filter(struct event_format *event, struct filter_arg **parg,
>  		current_op = current_exp;
>  
>  	current_op = collapse_tree(current_op);
> +	if (current_op == NULL)
> +		goto fail_alloc;
>  
>  	*parg = current_op;
>  
>  	return 0;
>  
> + fail_alloc:
> +	show_error(error_str, "failed to allocate filter arg");
> +	goto fail;
>   fail_print:
>  	show_error(error_str, "Syntax error");
>   fail:
> @@ -1141,6 +1159,10 @@ process_event(struct event_format *event, const char *filter_str,
>  	/* If parg is NULL, then make it into FALSE */
>  	if (!*parg) {
>  		*parg = allocate_arg();
> +		if (*parg == NULL) {
> +			show_error(error_str, "failed to allocate filter arg");
> +			return -1;
> +		}
>  		(*parg)->type = FILTER_ARG_BOOLEAN;
>  		(*parg)->boolean.value = FILTER_FALSE;
>  	}
> @@ -1164,6 +1186,10 @@ static int filter_event(struct event_filter *filter,
>  	} else {
>  		/* just add a TRUE arg */
>  		arg = allocate_arg();
> +		if (arg == NULL) {
> +			show_error(error_str, "failed to allocate filter arg");
> +			return -1;
> +		}
>  		arg->type = FILTER_ARG_BOOLEAN;
>  		arg->boolean.value = FILTER_TRUE;
>  	}
> @@ -1399,6 +1425,9 @@ static int copy_filter_type(struct event_filter *filter,
>  	if (strcmp(str, "TRUE") == 0 || strcmp(str, "FALSE") == 0) {
>  		/* Add trivial event */
>  		arg = allocate_arg();
> +		if (arg == NULL)
> +			return -1;
> +
>  		arg->type = FILTER_ARG_BOOLEAN;
>  		if (strcmp(str, "TRUE") == 0)
>  			arg->boolean.value = 1;

