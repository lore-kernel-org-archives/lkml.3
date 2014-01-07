Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072AbaAGNG0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 08:06:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34390 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751492AbaAGNGU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 08:06:20 -0500
Date: Tue, 7 Jan 2014 14:05:58 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] tools lib traceevent: Add state member to struct
 trace_seq
Message-ID: <20140107130558.GB2919@krava.brq.redhat.com>
References: <1389063612-18173-1-git-send-email-namhyung@kernel.org>
 <1389063612-18173-3-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389063612-18173-3-git-send-email-namhyung@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 12:00:09PM +0900, Namhyung Kim wrote:

SNIP

>  void trace_seq_init(struct trace_seq *s);
> diff --git a/tools/lib/traceevent/trace-seq.c b/tools/lib/traceevent/trace-seq.c
> index d7f2e68bc5b9..1747aa50ecb0 100644
> --- a/tools/lib/traceevent/trace-seq.c
> +++ b/tools/lib/traceevent/trace-seq.c
> @@ -32,8 +32,9 @@
>  #define TRACE_SEQ_POISON	((void *)0xdeadbeef)
>  #define TRACE_SEQ_CHECK(s)						\
>  do {									\
> -	if ((s)->buffer == TRACE_SEQ_POISON)			\
> -		die("Usage of trace_seq after it was destroyed");	\
> +	if (WARN_ONCE((s)->buffer == TRACE_SEQ_POISON,			\
> +		      "Usage of trace_seq after it was destroyed"))	\
> +		(s)->state = TRACE_SEQ__BUFFER_POISONED;		\
>  } while (0)
>  
>  /**
> @@ -46,6 +47,7 @@ void trace_seq_init(struct trace_seq *s)
>  	s->readpos = 0;
>  	s->buffer_size = TRACE_SEQ_BUF_SIZE;
>  	s->buffer = malloc_or_die(s->buffer_size);
> +	s->state = TRACE_SEQ__GOOD;
>  }
>  
>  /**
> @@ -81,7 +83,7 @@ static void expand_buffer(struct trace_seq *s)
>  	s->buffer_size += TRACE_SEQ_BUF_SIZE;
>  	s->buffer = realloc(s->buffer, s->buffer_size);
>  	if (!s->buffer)
> -		die("Can't allocate trace_seq buffer memory");
> +		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;

and also here?

	if (WARN_ONCE(!s->buffer))
		s->state = TRACE_SEQ__MEM_ALLOC_FAILED;

otherwise the whole series seems ok,
jirka
