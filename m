Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755558Ab3HCBV2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:21:28 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:8104 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753739Ab3HCBV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:21:27 -0400
X-Authority-Analysis: v=2.0 cv=aqMw+FlV c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=7p5mhCWNro8A:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=xRPFay5u69YA:10 a=pGLkceISAAAA:8 a=20KFwNOVAAAA:8 a=1XWaLZrsAAAA:8 a=3nbZYyFuAAAA:8 a=QyXUC8HyAAAA:8 a=6rqHouBjAAAA:8 a=UsFWTQLR4y7Wx8TtaDQA:9 a=QEXdDO2ut3YA:10 a=jeBq3FmKZ4MA:10 a=MSl-tDqOz04A:10 a=jEp0ucaQiEUA:10 a=UTB_XpHje0EA:10 a=EvKJbDF4Ut8A:10 a=TAmEwCHjoHMA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1375492884.22073.35.camel@gandalf.local.home>
Subject: Re: [PATCH] tracing: a few fields of struct trace_iterator are
 zeroed by mistake
From: Steven Rostedt <rostedt@goodmis.org>
To: Andrew Vagin <avagin@openvz.org>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, David Sharp <dhsharp@google.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Date: Fri, 02 Aug 2013 21:21:24 -0400
In-Reply-To: <1375463803-3085183-1-git-send-email-avagin@openvz.org>
References: <1375463803-3085183-1-git-send-email-avagin@openvz.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-02 at 21:16 +0400, Andrew Vagin wrote:
> tracing_read_pipe zeros all fields bellow "seq". The declaration contains
> a comment about that, but it doesn't help.
> 
> The first field is "snapshot", it's true when current open file is
> snapshot. Looks obvious, that it should not be zeroed.
> 
> The second field is "started". It was converted from cpumask_t to
> cpumask_var_t (v2.6.28-4983-g4462344) or by another words it was
> converted from cpumask to pointer on cpumask.
> 
> Currently the reference on "started" memory is lost after the first read
> from tracing_read_pipe and a proper object will never be freed.

This should be marked for stable, namely for the started mask being
leaked.

> 
> The "started" is never dereferenced for trace_pipe, because trace_pipe
> can't have the TRACE_FILE_ANNOTATE options (why?).

I guess it could, but it's not necessary because trace_pipe has the lost
event counter which basically does the same thing. The annotate was to
please people like Thomas Gleixner, that was confused by the trace file
output where it looked like a bunch happened on CPU 1 and nothing on any
of the other CPUs. But in reality, it was that CPU 1 didn't have many
events and all the other CPUs overwrote their buffers more recently.

The consuming nature of trace_pipe, I left out most of the annotations,
like the header and these annotations. trace_pipe was mainly used to see
events live, no annotation necessary, except for lost events. The lost
events do take over for this instead. As the trace file is more of a
"snapshot" in time (tracing stops when reading that file but not the
trace_pipe file) it shouldn't have lost events. It should see the trace
as complete. Although, due to the reader page nature, there can be a gap
between the reader page and the main buffer.


> 
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Sharp <dhsharp@google.com>
> Cc: Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> 
> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> ---
>  include/linux/ftrace_event.h |   10 ++++++----
>  kernel/trace/trace.c         |    1 +
>  2 files changed, 7 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/ftrace_event.h b/include/linux/ftrace_event.h
> index 4372658..44cdc11 100644
> --- a/include/linux/ftrace_event.h
> +++ b/include/linux/ftrace_event.h
> @@ -78,6 +78,11 @@ struct trace_iterator {
>  	/* trace_seq for __print_flags() and __print_symbolic() etc. */
>  	struct trace_seq	tmp_seq;
>  
> +	cpumask_var_t		started;
> +
> +	/* it's true when current open file is snapshot */
> +	bool			snapshot;
> +

The above two should be swapped. snapshot doesn't change in trace pipe,
but started does.

>  	/* The below is zeroed out in pipe_read */
>  	struct trace_seq	seq;
>  	struct trace_entry	*ent;
> @@ -90,10 +95,7 @@ struct trace_iterator {
>  	loff_t			pos;
>  	long			idx;
>  
> -	cpumask_var_t		started;
> -
> -	/* it's true when current open file is snapshot */
> -	bool			snapshot;
> +	/* All new field here will be zeroed out in pipe_read */
>  };
>  
>  enum trace_iter_flags {
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 0cd500b..897f553 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -4166,6 +4166,7 @@ waitagain:
>  	memset(&iter->seq, 0,
>  	       sizeof(struct trace_iterator) -
>  	       offsetof(struct trace_iterator, seq));
> +	cpumask_clear(iter->started);

Hmm, on second thought should it change? it's ignored because we never
set the TRACE_FILE_ANNOTATE flag in the iterator.

That means that we don't even need the setall in tracing_open_pipe.
Technically, would shouldn't even allocate it, but for now we should,
just to be safe.

-- Steve



>  	iter->pos = -1;
>  
>  	trace_event_read_lock();


