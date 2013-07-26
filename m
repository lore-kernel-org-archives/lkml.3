Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226Ab3GZPJk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 11:09:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:18476 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755806Ab3GZPJj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 11:09:39 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=ZPgwZBm_-BwA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=F6OzYz1FwowA:10 a=gBPKbcQ7CweGQIOt8FcA:9 a=QEXdDO2ut3YA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374851376.6580.34.camel@gandalf.local.home>
Subject: Re: [PATCH 2/2][RESEND] tracing: Shrink the size of struct
 ftrace_event_field
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizefan@huawei.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Jul 2013 11:09:36 -0400
In-Reply-To: <51F08D4B.3010201@huawei.com>
References: <51F08D1B.1080300@huawei.com> <51F08D4B.3010201@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-25 at 10:28 +0800, Li Zefan wrote:
>  
>  struct event_filter {
> diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
> index 53582e9..67aee85 100644
> --- a/kernel/trace/trace_events.c
> +++ b/kernel/trace/trace_events.c
> @@ -111,6 +111,11 @@ static int __trace_define_field(struct list_head *head, const char *type,
>  	field->size = size;
>  	field->is_signed = is_signed;

I think we should just change is_signed to bool. At least the parameter.
Or we can make the assignment: field->is_signed = !!is_signed; and nuke
the check below.

>  
> +	WARN_ON(offset >= (1 << 12));
> +	WARN_ON(size >= (1 << 12));
> +	WARN_ON(is_signed >= (1 << 1));
> +	WARN_ON(field->filter_type >= (1 << 4));

Note, the test for field->filter_type is wrong.

We should make a helper macro:

#define VERIFY_SIZE(type) WARN_ON(type > field->type)

and then have:

	VERIFY_SIZE(offset);
	VERIFY_SIZE(size);
	VERIFY_SIZE(filter_type);

-- Steve

> +
>  	list_add(&field->link, head);
>  
>  	return 0;
> -- 1.8.0.2


