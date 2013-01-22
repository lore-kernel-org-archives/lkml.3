Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab3AVEpq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 23:45:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8147 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915Ab3AVEpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 23:45:44 -0500
X-Authority-Analysis: v=2.0 cv=W/m6pGqk c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=6SGtptbN4IMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=qG8yL3FeDQwA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=hGzw-44bAAAA:8 a=dP1YJgwhV2fsMVQfHHwA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=dowx1zmaLagA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1358829942.21576.49.camel@gandalf.local.home>
Subject: Re: [PATCH] tools lib traceevent: Handle dynamic array's element
 size properly
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Mon, 21 Jan 2013 23:45:42 -0500
In-Reply-To: <1358772251-4411-1-git-send-email-jolsa@redhat.com>
References: <1358772251-4411-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-01-21 at 13:44 +0100, Jiri Olsa wrote:
> Fixing the dynamic array format field parsing.
> 
> Currently the event_read_fields function could segfault while parsing
> dynamic array other than string type. The reason is the event->pevent
> does not need to be set and gets dereferenced unconditionaly.
> 
> Also adding proper initialization of field->elementsize based on the
> parsed dynamic type.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> ---
>  tools/lib/traceevent/event-parse.c | 40 +++++++++++++++++++++++++++++++++++---
>  tools/lib/traceevent/event-parse.h |  1 +
>  2 files changed, 38 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index f504619..d682df2 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -1223,6 +1223,34 @@ static int field_is_long(struct format_field *field)
>  	return 0;
>  }
>  
> +static unsigned int field_dynamic_elem_size(struct format_field *field)
> +{
> +	/* This covers all FIELD_IS_STRING types. */
> +	static struct {
> +		char *type;
> +		unsigned int size;
> +	} table[] = {
> +		{ "u8",   1 },
> +		{ "u16",  2 },
> +		{ "u32",  4 },
> +		{ "u64",  8 },
> +		{ "s8",   1 },
> +		{ "s16",  2 },
> +		{ "s32",  4 },
> +		{ "s64",  8 },
> +		{ "char", 1 },
> +		{ },
> +	};
> +	int i;
> +
> +	for (i = 0; table[i].type; i++) {
> +		if (!strcmp(table[i].type, field->type_dyn))
> +			return table[i].size;
> +	}
> +
> +	return 0;
> +}
> +
>  static int event_read_fields(struct event_format *event, struct format_field **fields)
>  {
>  	struct format_field *field = NULL;
> @@ -1390,7 +1418,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
>  				field->type = new_type;
>  				strcat(field->type, " ");
>  				strcat(field->type, field->name);
> -				free_token(field->name);
> +				field->type_dyn = field->name;

This is only used in this function (the field_dynamic_elem_size() is
only called here). Can we not add the field->type_dyn, and just use a
local variable here. You just need to make sure you free it correctly.

-- Steve

>  				strcat(field->type, brackets);
>  				field->name = token;
>  				type = read_token(&token);
> @@ -1477,10 +1505,14 @@ static int event_read_fields(struct event_format *event, struct format_field **f
>  		if (field->flags & FIELD_IS_ARRAY) {
>  			if (field->arraylen)
>  				field->elementsize = field->size / field->arraylen;
> +			else if (field->flags & FIELD_IS_DYNAMIC)
> +				field->elementsize = field_dynamic_elem_size(field);
>  			else if (field->flags & FIELD_IS_STRING)
>  				field->elementsize = 1;
> -			else
> -				field->elementsize = event->pevent->long_size;
> +			else if (field->flags & FIELD_IS_LONG)
> +				field->elementsize = event->pevent ?
> +						     event->pevent->long_size :
> +						     sizeof(long);
>  		} else
>  			field->elementsize = field->size;
>  
> @@ -1496,6 +1528,7 @@ fail:
>  fail_expect:
>  	if (field) {
>  		free(field->type);
> +		free(field->type_dyn);
>  		free(field->name);
>  		free(field);
>  	}
> @@ -5500,6 +5533,7 @@ static void free_format_fields(struct format_field *field)
>  	while (field) {
>  		next = field->next;
>  		free(field->type);
> +		free(field->type_dyn);
>  		free(field->name);
>  		free(field);
>  		field = next;
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index 7be7e89..4d54af2 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -174,6 +174,7 @@ struct format_field {
>  	struct format_field	*next;
>  	struct event_format	*event;
>  	char			*type;
> +	char			*type_dyn;
>  	char			*name;
>  	int			offset;
>  	int			size;


