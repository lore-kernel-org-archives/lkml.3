Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab3JNBW7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Oct 2013 21:22:59 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:63744 "EHLO
	LGEAMRELO02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab3JNBW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Oct 2013 21:22:58 -0400
X-AuditID: 9c93017e-b7c75ae00000230e-7c-525b47705900
From: Namhyung Kim <namhyung@kernel.org>
To: Howard Cochran <hcochran@lexmark.com>
Cc: rostedt@goodmis.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Handle __print_hex(__get_dynamic_array(fieldname), len)
References: <1381503349-12271-1-git-send-email-hcochran@lexmark.com>
Date: Mon, 14 Oct 2013 10:22:56 +0900
In-Reply-To: <1381503349-12271-1-git-send-email-hcochran@lexmark.com> (Howard
	Cochran's message of "Fri, 11 Oct 2013 10:55:49 -0400")
Message-ID: <87ob6sbq8f.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Howard,

On Fri, 11 Oct 2013 10:55:49 -0400, Howard Cochran wrote:
> The kernel has a few events with a format similar to this excerpt:
>         field:unsigned int len;     offset:12;      size:4; signed:0;
>         field:__data_loc unsigned char[] data_array;  offset:16;      size:4; signed:0;
> print fmt: "%s", __print_hex(__get_dynamic_array(data_array), REC->len)
>
> trace-cmd could already parse that arg correctly, but print_str_arg()
> was unable to handle the first parameter being a dynamic array. (It
> just printed a "field not found" warning).
>
> Teach print_str_arg's PRINT_HEX case to handle the nested
> PRINT_DYNAMIC_ARRAY correctly. The output now matches the kernel's own
> formatting for this case.

It seems that it needs to be added to libtraceevent also.  Could you
also send a patch against tools/lib/traceevent/event-parse.c in the
Linux kernel source?

Thanks,
Namhyung

>
> Signed-off-by: Howard Cochran <hcochran@lexmark.com>
> ---
>  event-parse.c |   24 ++++++++++++++++--------
>  1 file changed, 16 insertions(+), 8 deletions(-)
>
> diff --git a/event-parse.c b/event-parse.c
> index e961553..fdb176e 100644
> --- a/event-parse.c
> +++ b/event-parse.c
> @@ -3550,15 +3550,23 @@ static void print_str_arg(struct trace_seq *s, void *data, int size,
>  		}
>  		break;
>  	case PRINT_HEX:
> -		field = arg->hex.field->field.field;
> -		if (!field) {
> -			str = arg->hex.field->field.name;
> -			field = pevent_find_any_field(event, str);
> -			if (!field)
> -				goto out_warning_field;
> -			arg->hex.field->field.field = field;
> +		if (PRINT_DYNAMIC_ARRAY == arg->hex.field->type) {
> +			unsigned long offset;
> +			offset = pevent_read_number(pevent,
> +				data + arg->hex.field->dynarray.field->offset,
> +				arg->hex.field->dynarray.field->size);
> +			hex = data + (offset & 0xffff);
> +		} else {
> +			field = arg->hex.field->field.field;
> +			if (!field) {
> +				str = arg->hex.field->field.name;
> +				field = pevent_find_any_field(event, str);
> +				if (!field)
> +					goto out_warning_field;
> +				arg->hex.field->field.field = field;
> +			}
> +			hex = data + field->offset;
>  		}
> -		hex = data + field->offset;
>  		len = eval_num_arg(data, size, event, arg->hex.size);
>  		for (i = 0; i < len; i++) {
>  			if (i)
