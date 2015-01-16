Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756017AbbAPCe5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 21:34:57 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:23244 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754001AbbAPCe4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 21:34:56 -0500
Date: Thu, 15 Jan 2015 21:35:19 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Javi Merino <javi.merino@arm.com>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <srostedt@redhat.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [RESEND PATCH v2 2/2] tools lib traceevent: Add support for
 __print_array()
Message-ID: <20150115213519.79beb0a9@grimm.local.home>
In-Reply-To: <1421340659-18063-2-git-send-email-javi.merino@arm.com>
References: <1421340659-18063-1-git-send-email-javi.merino@arm.com>
	<1421340659-18063-2-git-send-email-javi.merino@arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Jan 2015 12:05:52 -0500
Javi Merino <javi.merino@arm.com> wrote:

> Trace can now generate traces with variable element size arrays.  Add
> support to parse them.
> 
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <srostedt@redhat.com>
> Cc: Jiri Olsa <jolsa@redhat.com>
> Signed-off-by: Javi Merino <javi.merino@arm.com>
> ---
>  tools/lib/traceevent/event-parse.c | 127
> +++++++++++++++++++++++++++++++++++++
> tools/lib/traceevent/event-parse.h |   8 +++ 2 files changed, 135
> insertions(+)
> 
> diff --git a/tools/lib/traceevent/event-parse.c
> b/tools/lib/traceevent/event-parse.c index cf3a44bf1ec3..00dd6213449c
> 100644 --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -757,6 +757,11 @@ static void free_arg(struct print_arg *arg)
>  		free_arg(arg->hex.field);
>  		free_arg(arg->hex.size);
>  		break;
> +	case PRINT_INT_ARRAY:
> +		free_arg(arg->int_array.field);
> +		free_arg(arg->int_array.size);
> +		free_arg(arg->int_array.el_size);
> +		break;
>  	case PRINT_TYPE:
>  		free(arg->typecast.type);
>  		free_arg(arg->typecast.item);
> @@ -2533,6 +2538,71 @@ process_hex(struct event_format *event, struct
> print_arg *arg, char **tok) }
>  
>  static enum event_type
> +process_int_array(struct event_format *event, struct print_arg *arg,
> char **tok) +{
> +	struct print_arg *field;
> +	enum event_type type;
> +	char *token;
> +
> +	memset(arg, 0, sizeof(*arg));
> +	arg->type = PRINT_INT_ARRAY;
> +
> +	field = alloc_arg();
> +	if (!field) {
> +		do_warning_event(event, "%s: not enough memory!",
> __func__);
> +		goto out;
> +	}
> +
> +	type = process_arg(event, field, &token);
> +
> +	if (test_type_token(type, token, EVENT_DELIM, ","))
> +		goto out_free;
> +
> +	arg->int_array.field = field;
> +
> +	free_token(token);
> +
> +	field = alloc_arg();
> +	if (!field) {
> +		do_warning_event(event, "%s: not enough memory!",
> __func__);
> +		goto out;
> +	}
> +
> +	type = process_arg(event, field, &token);
> +
> +	if (test_type_token(type, token, EVENT_DELIM, ","))
> +		goto out_free;
> +
> +	arg->int_array.size = field;
> +
> +	free_token(token);
> +
> +	field = alloc_arg();
> +	if (!field) {
> +		do_warning_event(event, "%s: not enough memory!",
> __func__);
> +		goto out;
> +	}

Hmm, perhaps we should make a helper function to allocate the field and
show the warning for the event instead of duplicating the code three
times.

> +
> +	type = process_arg(event, field, &token);
> +
> +	if (test_type_token(type, token, EVENT_DELIM, ")"))
> +		goto out_free;
> +
> +	arg->int_array.el_size = field;
> +
> +	free_token(token);
> +	type = read_token_item(tok);
> +	return type;
> +
> + out_free:
> +	free_arg(field);
> +	free_token(token);
> +out:
> +	*tok = NULL;
> +	return EVENT_ERROR;
> +}
> +
> +static enum event_type
>  process_dynamic_array(struct event_format *event, struct print_arg
> *arg, char **tok) {
>  	struct format_field *field;
> @@ -2827,6 +2897,10 @@ process_function(struct event_format *event,
> struct print_arg *arg, free_token(token);
>  		return process_hex(event, arg, tok);
>  	}
> +	if (strcmp(token, "__print_array") == 0) {
> +		free_token(token);
> +		return process_int_array(event, arg, tok);
> +	}
>  	if (strcmp(token, "__get_str") == 0) {
>  		free_token(token);
>  		return process_str(event, arg, tok);
> @@ -3355,6 +3429,7 @@ eval_num_arg(void *data, int size, struct
> event_format *event, struct print_arg break;
>  	case PRINT_FLAGS:
>  	case PRINT_SYMBOL:
> +	case PRINT_INT_ARRAY:
>  	case PRINT_HEX:
>  		break;
>  	case PRINT_TYPE:
> @@ -3765,6 +3840,49 @@ static void print_str_arg(struct trace_seq *s,
> void *data, int size, }
>  		break;
>  
> +	case PRINT_INT_ARRAY: {
> +		void *num;
> +		int el_size;
> +
> +		if (arg->int_array.field->type ==
> PRINT_DYNAMIC_ARRAY) {
> +			unsigned long offset;
> +
> +			offset = pevent_read_number(pevent,
> +				 data +
> arg->int_array.field->dynarray.field->offset,
> +
> arg->int_array.field->dynarray.field->size);

Grumble, I hate that my mail client is breaking lines up like this.
I'm using my laptop atm and haven't customized it to not screw up other
people's email. Sorry for the messy reply here.


> +			num = data + (offset & 0xffff);
> +		} else {
> +			field = arg->int_array.field->field.field;
> +			if (!field) {
> +				str =
> arg->int_array.field->field.name;
> +				field = pevent_find_any_field(event,
> str);
> +				if (!field)
> +					goto out_warning_field;
> +				arg->int_array.field->field.field =
> field;
> +			}
> +			num = data + field->offset;
> +		}
> +		len = eval_num_arg(data, size, event,
> arg->int_array.size);
> +		el_size = eval_num_arg(data, size, event,
> +				       arg->int_array.el_size);
> +		el_size /= 8;
> +		for (i = 0; i < len; i++) {
> +			if (i)
> +				trace_seq_putc(s, ' ');
> +
> +			if (el_size == 1)
> +				trace_seq_printf(s, "%u", *(uint8_t
> *)num);
> +			else if (el_size == 2)
> +				trace_seq_printf(s, "%u", *(uint16_t
> *)num);
> +			else if (el_size == 4)
> +				trace_seq_printf(s, "%u", *(uint32_t
> *)num);
> +			else if (el_size == 8)
> +				trace_seq_printf(s, "%lu",

Shouldn't that be "%llu"? This shouldn't warn on i386 compiles either.

> *(uint64_t *)num); +

I wonder if we should have a "else" here to show the same BAD SIZE that
I replied with in the other patch.

Rest looks good.

-- Steve


> +			num += el_size;
> +		}
> +		break;
> +	}
>  	case PRINT_TYPE:
>  		break;
>  	case PRINT_STRING: {
> @@ -4928,6 +5046,15 @@ static void print_args(struct print_arg *args)
>  		print_args(args->hex.size);
>  		printf(")");
>  		break;
> +	case PRINT_INT_ARRAY:
> +		printf("__print_array(");
> +		print_args(args->int_array.field);
> +		printf(", ");
> +		print_args(args->int_array.size);
> +		printf(", ");
> +		print_args(args->int_array.el_size);
> +		printf(")");
> +		break;
>  	case PRINT_STRING:
>  	case PRINT_BSTRING:
>  		printf("__get_str(%s)", args->string.string);
> diff --git a/tools/lib/traceevent/event-parse.h
> b/tools/lib/traceevent/event-parse.h index 7a3873ff9a4f..5ac3e3c00389
> 100644 --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -245,6 +245,12 @@ struct print_arg_hex {
>  	struct print_arg	*size;
>  };
>  
> +struct print_arg_int_array {
> +	struct print_arg	*field;
> +	struct print_arg	*size;
> +	struct print_arg	*el_size;
> +};
> +
>  struct print_arg_dynarray {
>  	struct format_field	*field;
>  	struct print_arg	*index;
> @@ -273,6 +279,7 @@ enum print_arg_type {
>  	PRINT_FLAGS,
>  	PRINT_SYMBOL,
>  	PRINT_HEX,
> +	PRINT_INT_ARRAY,
>  	PRINT_TYPE,
>  	PRINT_STRING,
>  	PRINT_BSTRING,
> @@ -292,6 +299,7 @@ struct print_arg {
>  		struct print_arg_flags		flags;
>  		struct print_arg_symbol		symbol;
>  		struct print_arg_hex		hex;
> +		struct print_arg_int_array	int_array;
>  		struct print_arg_func		func;
>  		struct print_arg_string		string;
>  		struct print_arg_bitmask	bitmask;

