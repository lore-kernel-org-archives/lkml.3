Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840Ab3KSCYA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 21:24:00 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:48989 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab3KSCX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 21:23:58 -0500
X-AuditID: 9c93016f-b7b6aae000005fae-b7-528acbbdaf08
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: tools lib traceevent: Report better error message on bad function args
References: <20131118191131.165034f8@gandalf.local.home>
Date: Tue, 19 Nov 2013 11:23:56 +0900
In-Reply-To: <20131118191131.165034f8@gandalf.local.home> (Steven Rostedt's
	message of "Mon, 18 Nov 2013 19:11:31 -0500")
Message-ID: <87siutt9hf.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On Mon, 18 Nov 2013 19:11:31 -0500, Steven Rostedt wrote:
> When Jiri Olsa was writing a function callback for
> scsi_trace_parse_cdb(), he thought that the traceevent library had a
> bug in it because he was getting this error:
>
>   Error: expected ')' but read ','
>   Error: expected ')' but read ','
>   Error: expected ')' but read ','
>   Error: expected ')' but read ','
>
> But in truth, he didn't have the write number of arguments for the
> function callback, and the error was the library detecting the
> discrepancy. A better error message would have prevented the confusion:
>
>   Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_timeout has more
>   Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_start has more
>   Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_error has more
>   Error: function 'scsi_trace_parse_cdb()' only expects 2 arguments but event scsi_dispatch_cmd_done has more
>
> Or
>
>   Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_timeout only uses 3
>   Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_start only uses 3
>   Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_error only uses 3
>   Error: function 'scsi_trace_parse_cdb()' expects 4 arguments but event scsi_dispatch_cmd_done only uses 3
>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
>
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index 0362d57..f7aab3d 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -2691,7 +2691,6 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
>  	struct print_arg *farg;
>  	enum event_type type;
>  	char *token;
> -	const char *test;
>  	int i;
>  
>  	arg->type = PRINT_FUNC;
> @@ -2708,15 +2707,19 @@ process_func_handler(struct event_format *event, struct pevent_function_handler
>  		}
>  
>  		type = process_arg(event, farg, &token);
> -		if (i < (func->nr_args - 1))
> -			test = ",";
> -		else
> -			test = ")";
> -
> -		if (test_type_token(type, token, EVENT_DELIM, test)) {
> -			free_arg(farg);
> -			free_token(token);
> -			return EVENT_ERROR;
> +		if (i < (func->nr_args - 1)) {
> +			if (type != EVENT_DELIM || strcmp(token, ",") != 0) {
> +				warning("Error: function '%s()' expects %d arguments but event %s only uses %d",
> +					func->name, func->nr_args,
> +					event->name, i + 1);
> +				return EVENT_ERROR;
> +			}
> +		} else {
> +			if (type != EVENT_DELIM || strcmp(token, ")") != 0) {
> +				warning("Error: function '%s()' only expects %d arguments but event %s has more",
> +					func->name, func->nr_args, event->name);
> +				return EVENT_ERROR;

It seems that you missed to free farg and token in error paths.

Thanks,
Namhyung


> +			}
>  		}
>  
>  		*next_arg = farg;
