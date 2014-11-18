Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaKRAbH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 19:31:07 -0500
Received: from lgeamrelo01.lge.com ([156.147.1.125]:35345 "EHLO
	lgeamrelo01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728AbaKRAbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 19:31:06 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@gmail.com
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, Petr Mladek <pmladek@suse.cz>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [RFC][PATCH 09/23 v4] tracing/probes: Do not use return value of trace_seq_printf()
References: <20141114011244.256115061@goodmis.org>
	<20141114011411.530216306@goodmis.org>
Date: Tue, 18 Nov 2014 09:30:59 +0900
In-Reply-To: <20141114011411.530216306@goodmis.org> (Steven Rostedt's message
	of "Thu, 13 Nov 2014 20:12:53 -0500")
Message-ID: <87r3x1s62k.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steve,

On Thu, 13 Nov 2014 20:12:53 -0500, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
>
> The functions trace_seq_printf() and friends will soon not have a return
> value and will only be a void function. Use trace_seq_has_overflowed()
> instead to know if the trace_seq operations succeeded or not.
>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Namhyung Kim <namhyung@kernel.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> ---
>  kernel/trace/trace_probe.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
>
> diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
> index d4b9fc22cd27..b983b2fd2ca1 100644
> --- a/kernel/trace/trace_probe.c
> +++ b/kernel/trace/trace_probe.c
> @@ -40,7 +40,8 @@ const char *reserved_field_names[] = {
>  int PRINT_TYPE_FUNC_NAME(type)(struct trace_seq *s, const char *name,	\
>  				void *data, void *ent)			\
>  {									\
> -	return trace_seq_printf(s, " %s=" fmt, name, *(type *)data);	\
> +	trace_seq_printf(s, " %s=" fmt, name, *(type *)data);		\
> +	return !trace_seq_has_overflowed(s);				\

At first, I wondered why you used this instead of trace_handle_return()
but I found out that it's only used for checking loop break so I'm okay
with this.

Acked-by: Namhyung Kim <namhyung@kernel.org>

Thanks,
Namhyung


>  }									\
>  const char PRINT_TYPE_FMT_NAME(type)[] = fmt;				\
>  NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(type));
> @@ -61,10 +62,11 @@ int PRINT_TYPE_FUNC_NAME(string)(struct trace_seq *s, const char *name,
>  	int len = *(u32 *)data >> 16;
>  
>  	if (!len)
> -		return trace_seq_printf(s, " %s=(fault)", name);
> +		trace_seq_printf(s, " %s=(fault)", name);
>  	else
> -		return trace_seq_printf(s, " %s=\"%s\"", name,
> -					(const char *)get_loc_data(data, ent));
> +		trace_seq_printf(s, " %s=\"%s\"", name,
> +				 (const char *)get_loc_data(data, ent));
> +	return !trace_seq_has_overflowed(s);
>  }
>  NOKPROBE_SYMBOL(PRINT_TYPE_FUNC_NAME(string));
