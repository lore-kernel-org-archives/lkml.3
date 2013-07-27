Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758558Ab3G0Dr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 23:47:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4000 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757543Ab3G0DrY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 23:47:24 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=qUJAF7m9tmYA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=Vl5wU4Dj6BYA:10 a=z_P2J6Y6RrIGwpLIaCUA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374896842.6580.44.camel@gandalf.local.home>
Subject: Re: [PATCH v2 2/2] tracing: Shrink the size of struct
 ftrace_event_field
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Jul 2013 23:47:22 -0400
In-Reply-To: <51F33F41.9040902@huawei.com>
References: <51F08D1B.1080300@huawei.com> <51F08D4B.3010201@huawei.com>
	 <1374851376.6580.34.camel@gandalf.local.home> <51F33F41.9040902@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-07-27 at 11:32 +0800, Li Zefan wrote:
 
>  struct event_filter {
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 7d85429..d72694d 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -106,6 +106,9 @@ trace_find_event_field(struct ftrace_event_call *call, char *name)
>  	return __find_event_field(head, name);
>  }
>  
> +/* detect bit-field overflow */
> +#define VERIFY_SIZE(type) WARN_ON(type > field->type)
> +

One small nit. Move this macro definition into the function itself,
right above the macro usage. That way it will be much easier to review
in the future, as people don't need to go search for VERIFY_SIZE(). It
will be right there with the usage. The aesthetics may be a bit off, but
at least the code will be obvious at first glance at what is happening,
and I think that's more important than the "look" of the code.

Also, it will be obvious that the variable name must match the field
name.

Thanks,

-- Steve

>  static int __trace_define_field(struct list_head *head, const char *type,
>  				const char *name, int offset, int size,
>  				int is_signed, int filter_type)
> @@ -120,13 +123,16 @@ static int __trace_define_field(struct list_head *head, const char *type,
>  	field->type = type;
>  
>  	if (filter_type == FILTER_OTHER)
> -		field->filter_type = filter_assign_type(type);
> -	else
> -		field->filter_type = filter_type;
> +		filter_type = filter_assign_type(type);
>  
> +	field->filter_type = filter_type;
>  	field->offset = offset;
>  	field->size = size;
> -	field->is_signed = is_signed;
> +	field->is_signed = !!is_signed;
> +
> +	VERIFY_SIZE(filter_type);
> +	VERIFY_SIZE(offset);
> +	VERIFY_SIZE(size);
>  
>  	list_add(&field->link, head);
>  


