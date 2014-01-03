Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752160AbaACNYn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jan 2014 08:24:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751675AbaACNYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jan 2014 08:24:42 -0500
Date: Fri, 3 Jan 2014 14:24:25 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] tools lib traceevent: Add state member to struct
 trace_seq
Message-ID: <20140103132425.GC1190@krava.brq.redhat.com>
References: <1387445666-7821-1-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387445666-7821-1-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 06:34:23PM +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> The trace_seq->state is for tracking errors during the use of
> trace_seq APIs and getting rid of die() in it.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/event-parse.h |  7 +++++++
>  tools/lib/traceevent/trace-seq.c   | 41 ++++++++++++++++++++++++++++++++++----
>  2 files changed, 44 insertions(+), 4 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.h b/tools/lib/traceevent/event-parse.h
> index cf5db9013f2c..3c890cb28db7 100644
> --- a/tools/lib/traceevent/event-parse.h
> +++ b/tools/lib/traceevent/event-parse.h
> @@ -58,6 +58,12 @@ struct pevent_record {
>  #endif
>  };
>  
> +enum trace_seq_fail {
> +	TRACE_SEQ__GOOD,
> +	TRACE_SEQ__BUFFER_POISONED,
> +	TRACE_SEQ__MEM_ALLOC_FAILED,
> +};
> +
>  /*
>   * Trace sequences are used to allow a function to call several other functions
>   * to create a string of data to use (up to a max of PAGE_SIZE).
> @@ -68,6 +74,7 @@ struct trace_seq {
>  	unsigned int		buffer_size;
>  	unsigned int		len;
>  	unsigned int		readpos;
> +	enum trace_seq_fail	state;
>  };
>  
>  void trace_seq_init(struct trace_seq *s);
> diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
> index d7f2e68bc5b9..976ad2a146b3 100644
> --- a/tools/lib/traceevent/trace-seq.c
> +++ b/tools/lib/traceevent/trace-seq.c
> @@ -32,8 +32,8 @@
>  #define TRACE_SEQ_POISON	((void *)0xdeadbeef)
>  #define TRACE_SEQ_CHECK(s)						\
>  do {									\
> -	if ((s)->buffer == TRACE_SEQ_POISON)			\
> -		die("Usage of trace_seq after it was destroyed");	\
> +	if ((s)->buffer == TRACE_SEQ_POISON)				\
> +		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\

So unless we use trace_seq_do_printf we dont have any
notification that this went wrong..?

How about use some sort of WARN_ONCE any time the state
is set != GOOD ?

thanks,
jirka
