Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137Ab3AXVN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:13:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:15556 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755769Ab3AXVNY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:13:24 -0500
X-Authority-Analysis: v=2.0 cv=C91rOHz+ c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=YyIrxvMppY0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=W0fAN9IbdjwA:10 a=20KFwNOVAAAA:8 a=VnNF1IyMAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=hGzw-44bAAAA:8 a=zJbueoD6h_z2apYZcdIA:9 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=LI9Vle30uBYA:10 a=dowx1zmaLagA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1359061993.21576.156.camel@gandalf.local.home>
Subject: Re: [PATCHv2] tools lib traceevent: Handle dynamic array's element
 size properly
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Thu, 24 Jan 2013 16:13:13 -0500
In-Reply-To: <1359060403-32422-1-git-send-email-jolsa@redhat.com>
References: <1359060403-32422-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-01-24 at 21:46 +0100, Jiri Olsa wrote:
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
>  tools/lib/traceevent/event-parse.c | 39 ++++++++++++++++++++++++++++++++++++--
>  1 file changed, 37 insertions(+), 2 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index bb8b3db..2083462 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -1223,6 +1223,34 @@ static int field_is_long(struct format_field *field)
>  	return 0;
>  }
>  
> +static unsigned int type_size(char *name)

Sorry to nitpick, but please make that const char *name.

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
> +		if (!strcmp(table[i].type, name))
> +			return table[i].size;
> +	}
> +
> +	return 0;
> +}
> +
>  static int event_read_fields(struct event_format *event, struct format_field **fields)
>  {
>  	struct format_field *field = NULL;
> @@ -1232,6 +1260,8 @@ static int event_read_fields(struct event_format *event, struct format_field **f
>  	int count = 0;
>  
>  	do {
> +		unsigned int size_dynamic = 0;
> +
>  		type = read_token(&token);
>  		if (type == EVENT_NEWLINE) {
>  			free_token(token);
> @@ -1390,6 +1420,7 @@ static int event_read_fields(struct event_format *event, struct format_field **f
>  				field->type = new_type;
>  				strcat(field->type, " ");
>  				strcat(field->type, field->name);
> +				size_dynamic = type_size(field->name);
>  				free_token(field->name);
>  				strcat(field->type, brackets);
>  				field->name = token;
> @@ -1478,10 +1509,14 @@ static int event_read_fields(struct event_format *event, struct format_field **f
>  		if (field->flags & FIELD_IS_ARRAY) {
>  			if (field->arraylen)
>  				field->elementsize = field->size / field->arraylen;
> +			else if (field->flags & FIELD_IS_DYNAMIC)
> +				field->elementsize = size_dynamic;
>  			else if (field->flags & FIELD_IS_STRING)
>  				field->elementsize = 1;
> -			else
> -				field->elementsize = event->pevent->long_size;
> +			else if (field->flags & FIELD_IS_LONG)
> +				field->elementsize = event->pevent ?
> +						     event->pevent->long_size :
> +						     sizeof(long);
>  		} else

The rest looks good.

-- Steve

>  			field->elementsize = field->size;
>  


